class Bird < ApplicationRecord
  belongs_to :node

  NODES_AND_DESCENDANTS_QUERY = <<EOF
    WITH RECURSIVE
      descendants AS
        (SELECT * FROM nodes WHERE id IN (?)
      UNION ALL
      SELECT n.* FROM nodes n
        INNER JOIN descendants d ON n.parent_id = d.id),
      unique_descendants AS
        (SELECT distinct(id) FROM descendants)

    SELECT birds.* FROM birds
      INNER JOIN unique_descendants ud on ud.id = birds.node_id;

EOF

  def self.find_birds_from_nodes_and_descendants(*nodes)
    self.find_by_sql([NODES_AND_DESCENDANTS_QUERY, nodes])
  end
end
