/*  5 tables to create
    3 indexes
*/
CREATE TABLE  IF NOT EXISTS teams(
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    abbreviation TEXT NOT NULL,
    conference TEXT,
    division TEXT,
    cached_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE  IF NOT EXISTS players(
    id INTEGER PRIMARY KEY,
    team_id INTEGER REFERENCES teams(id),
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL, 
    position TEXT,
    headshot_url TEXT,
    cached_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS player_stats(
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    player_id INTEGER NOT NULL REFERENCES players(id),
    season TEXT NOT NULL, 
    games_played INTEGER NOT NULL DEFAULT 0,
    goals INTEGER NOT NULL DEFAULT 0,
    assists INTEGER NOT NULL DEFAULT 0,
    points INTEGER NOT NULL DEFAULT 0,
    plus_minus INTEGER NOT NULL DEFAULT 0,
    pim INTEGER NOT NULL DEFAULT 0,
    ppg INTEGER NOT NULL DEFAULT 0,
    shg INTEGER NOT NULL DEFAULT 0,
    total_shots INTEGER NOT NULL DEFAULT 0,
    cached_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (player_id, season)
);


CREATE TABLE IF NOT EXISTS standings(
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    team_id INTEGER NOT NULL REFERENCES teams(id),
    season TEXT NOT NULL,
    wins INTEGER NOT NULL DEFAULT 0,
    losses INTEGER NOT NULL DEFAULT 0,
    ot_losses INTEGER NOT NULL DEFAULT 0,
    points INTEGER NOT NULL DEFAULT 0,
    goals_for INTEGER NOT NULL DEFAULT 0,
    goals_against INTEGER NOT NULL DEFAULT 0,
    shut_outs INTEGER NOT NULL DEFAULT 0,
    cached_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), 
    UNIQUE (team_id, season)
);

CREATE TABLE IF NOT EXISTS games(
    id INTEGER PRIMARY KEY,
    game_date DATE NOT NULL,
    home_team_id INTEGER NOT NULL REFERENCES teams(id),
    home_goals INTEGER,
    away_team_id INTEGER NOT NULL REFERENCES teams(id),
    away_goals INTEGER,
    status TEXT,
    cached_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_player_stats_player_id ON player_stats(player_id);

CREATE INDEX IF NOT EXISTS idx_standings_team_id ON standings(team_id);

CREATE INDEX IF NOT EXISTS idx_games_date ON games(game_date);