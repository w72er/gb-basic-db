DROP TABLE IF EXISTS rebalance_barriers;
CREATE TABLE rebalance_barriers (
	barrier DECIMAL(4, 4) -- todo: check value truncated
);

INSERT INTO rebalance_barriers (barrier) VALUE (0.1);