defmodule DBQuery do

  def get_all_raw() do
    Ecto.Adapters.SQL.query!(
    Cats.Repo, "SELECT * FROM cats"
    )
  end

  def get_all() do
    postgrexResult = Ecto.Adapters.SQL.query!(
    Cats.Repo, "SELECT * FROM cats"
    )
    postgrexResult.rows
  end

  def get_avg() do
    postgrexResult = Ecto.Adapters.SQL.query!(
    Cats.Repo, "SELECT ROUND(AVG(tail_length), 2) AS tail_avg FROM cats"
    )
    [[avg_str]] = postgrexResult.rows
    Decimal.to_float(avg_str)
  end

  def get_median() do
    postgrexResult = Ecto.Adapters.SQL.query!(
    Cats.Repo, "WITH a AS
    (
     SELECT
      tail_length,
      ROW_NUMBER() OVER (order by tail_length) AS rn,
      COUNT(*) OVER () AS c
     FROM
      cats
     WHERE
      tail_length BETWEEN 0 AND 60
    )
    SELECT
     ROUND(AVG(tail_length), 2) AS median
    FROM
     a
    WHERE
     rn IN (c / 2, c / 2 + ABS(c % 2 - 1));"
    )
    [[median_str]] = postgrexResult.rows
    Decimal.to_float(median_str)
  end

  def get_mode() do
    postgrexResult = Ecto.Adapters.SQL.query!(
      Cats.Repo, "SELECT MODE() WITHIN GROUP (ORDER BY tail_length) AS most_frequent FROM cats;"
      )
      [[mode]] = postgrexResult.rows
      mode
  end
end
