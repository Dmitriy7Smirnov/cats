defmodule DBQuery do

  def fill_cats_stats() do
    avg_tail = get_avg("tail_length")
    avg_whiskers = get_avg("whiskers_length")
    median_tail = get_median("tail_length")
    median_whiskers = get_median("whiskers_length")
    mode_tail = get_mode("tail_length")
    mode_whiskers = get_mode("whiskers_length")
    stats = %Cats.Stat{tail_length_mean: avg_tail, tail_length_median: median_tail, tail_length_mode: mode_tail,
    whiskers_length_mean: avg_whiskers, whiskers_length_median: median_whiskers, whiskers_length_mode: mode_whiskers}
    Cats.Repo.insert(stats)
  end

  def fill_cci() do
    postgresResult = Ecto.Adapters.SQL.query!(
    Cats.Repo, "SELECT color, COUNT(*) FROM cats GROUP BY color"
    )
    Enum.map(postgresResult.rows, fn [color, count]  -> Cat.Colors.Info.changeset(%Cat.Colors.Info{}, %{color: color, count: count}) end)
    |> Enum.each(fn entry -> Cats.Repo.insert(entry) end)
  end

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

  def get_avg(column) do
    postgrexResult = Ecto.Adapters.SQL.query!(
    Cats.Repo, "SELECT ROUND(AVG(#{column}), 2)::float AS tail_avg FROM cats"
    )
    [[avg_str]] = postgrexResult.rows
    avg_str
  end

  def get_median(column) do
    postgrexResult = Ecto.Adapters.SQL.query!(
    Cats.Repo, "WITH a AS
    (
     SELECT
      #{column},
      ROW_NUMBER() OVER (order by #{column}) AS rn,
      COUNT(*) OVER () AS c
     FROM
      cats
     WHERE
      #{column} BETWEEN 0 AND 1000
    )
    SELECT
     ROUND(AVG(#{column}), 2)::float AS median
    FROM
     a
    WHERE
     rn IN (c / 2, c / 2 + ABS(c % 2 - 1));"
    )
    [[median_str]] = postgrexResult.rows
    median_str
  end

  def get_mode(column) do
    postgrexResult = Ecto.Adapters.SQL.query!(
      Cats.Repo, "SELECT MODE() WITHIN GROUP (ORDER BY #{column}) AS most_frequent FROM cats;"
      )
      [[mode]] = postgrexResult.rows
      mode
      # Cats.Repo.insert(struct, opts \\ [])
  end
end
