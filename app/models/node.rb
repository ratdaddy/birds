class Node < ApplicationRecord
  belongs_to :parent, optional: true, class_name: 'Node'
  has_many :birds
  attribute :depth, :integer

  COMMON_ANCESTOR_QUERY = <<EOF

    WITH RECURSIVE
      a_ancestors AS
        (SELECT *, 1 as level FROM nodes
          WHERE id = ?
        UNION ALL
        SELECT n.*, level + 1 FROM nodes n
          INNER JOIN a_ancestors a ON a.parent_id = n.id),
      b_ancestors AS
        (SELECT * FROM nodes
          WHERE id = ?
        UNION ALL
        SELECT n1.* FROM nodes n1
          INNER JOIN b_ancestors b on b.parent_id = n1.id
        ),
      maxlevel AS
        (SELECT MAX(level) FROM a_ancestors),
      all_ancestors AS
        (SELECT a_ancestors.*, maxlevel.max - a_ancestors.level + 1 AS depth FROM a_ancestors, b_ancestors, maxlevel
          WHERE a_ancestors.id = b_ancestors.id)

      (SELECT * from all_ancestors ORDER BY depth LIMIT 1)
      UNION ALL
      (SELECT * from all_ancestors ORDER BY depth DESC LIMIT 1);

EOF

  def self.find_root_and_lca(a_id, b_id)
    self.find_by_sql([COMMON_ANCESTOR_QUERY, a_id, b_id])
  end
end
