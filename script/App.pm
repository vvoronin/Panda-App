package App;
use base 'Panda::App';

__PACKAGE__->define_component(
    DB => App::Model,
    Game => App::Game::Server
);