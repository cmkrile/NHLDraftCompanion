/*
Schema for all info fed into player and goalie ranking algorithm

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

CREATE TABLE IF NOT EXISTS goalie_stats(
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    player_id INTEGER NOT NULL REFERENCES players(id),
    season TEXT NOT NULL, 
    games_played INTEGER NOT NULL DEFAULT 0,
    games_started INTEGER NOT NULL DEFAULT 0,
    wins INTEGER NOT NULL DEFAULT 0,
    losses INTEGER NOT NULL DEFAULT 0,
    ot_losses INTEGER NOT NULL DEFAULT 0,
    shut_outs INTEGER NOT NULL DEFAULT 0,
    shots_against INTEGER NOT NULL DEFAULT 0,
    saves INTEGER NOT NULL DEFAULT 0,
    save_percentage NUMERIC(4,3) NOT NULL DEFAULT 0.0,
    goals_against_average NUMERIC(4,2) NOT NULL DEFAULT 0.0,
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

CREATE TABLE IF NOT EXISTS player_deployment(
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    player_id INTEGER NOT NULL REFERENCES players(id),
    season TEXT NOT NULL,
    line_number INTEGER,
    power_play_unit INTEGER,
    penalty_kill_unit INTEGER,
    avg_toi_minutes NUMERIC(4,2),
    cached_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (player_id, season)
);

CREATE TABLE IF NOT EXISTS player_rankings(
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    player_id INTEGER NOT NULL REFERENCES players(id),
    season TEXT NOT NULL,   
    rank_score NUMERIC(6,2) NOT NULL,
    rank_position INTEGER,
    calculated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (player_id, season)
);

CREATE INDEX IF NOT EXISTS idx_player_stats_player_id ON player_stats(player_id);

CREATE INDEX IF NOT EXISTS idx_goalie_stats_player_id ON goalie_stats(player_id);

CREATE INDEX IF NOT EXISTS idx_standings_team_id ON standings(team_id);

CREATE INDEX IF NOT EXISTS idx_games_date ON games(game_date);