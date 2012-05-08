VoteDeValeur::Application.routes.draw do
  match '*path' => redirect('http://www.votedevaleur.org')
  match '/' => redirect('http://www.votedevaleur.org')
end
