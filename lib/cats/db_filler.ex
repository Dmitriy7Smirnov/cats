defmodule DBFiller do

  def fill() do
    cats = [
      %Cats.Cat{name: "Tihon" , color: "red & white", tail_length: 15, whiskers_length: 12},
      %Cats.Cat{name: "Marfa" , color: "black & white", tail_length: 13, whiskers_length: 11}
    ]

    Enum.each(cats, fn (cat) -> Cats.Repo.insert(cat) end)
  end

end
