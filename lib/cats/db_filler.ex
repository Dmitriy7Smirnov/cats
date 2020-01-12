defmodule DBFiller do

  def fill() do
    cats = [
      %Cats.Cat{name: "Tihon" , color: "red & white", tail_length: 15, whiskers_length: 12},
      %Cats.Cat{name: "Marfa" , color: "black & white", tail_length: 13, whiskers_length: 11},
      %Cats.Cat{name: "Tihon2" , color: "red & white", tail_length: 17, whiskers_length: 22},
      %Cats.Cat{name: "Marfa2" , color: "black & white", tail_length: 25, whiskers_length: 28},
      %Cats.Cat{name: "Tihon3" , color: "red & white", tail_length: 17, whiskers_length: 58},
      %Cats.Cat{name: "Marfa3" , color: "black & white", tail_length: 48, whiskers_length: 22}
    ]

    Enum.each(cats, fn (cat) -> Cats.Repo.insert(cat) end)
  end

end
