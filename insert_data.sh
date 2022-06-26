#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE games, teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $YEAR != year ]]
  then
    GET_WINNER_TEAM="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    if [[ -z $GET_WINNER_TEAM ]]
    then
      INSERT_TEAM="$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")"
    fi
    GET_OPPONENT_TEAM="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    if [[ -z $GET_OPPONENT_TEAM ]]
    then
      INSERT_TEAM="$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")"
    fi
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    INSERT_GAME="$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS)")"
    echo $INSERT_GAME
  fi
done
