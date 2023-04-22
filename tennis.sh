#/bin/bash
#Ariel Ashkenazy 208465096

# arugments:
#   $1 - player 1 score
#   $2 - player 2 score
print_score () {
    echo " Player 1: $1         Player 2: $2 "
}

# arguments:
#  $1 - the location of the ball (between -3 and 3 inclusive)
print_board () {
    middle_line=""
    case $1 in
        -3)
            middle_line="O|       |       #       |       | "
            ;;
        -2)
            middle_line=" |   O   |       #       |       | "
            ;;
        -1)
            middle_line=" |       |   O   #       |       | "
            ;;
        0)
            middle_line=" |       |       O       |       | "
            ;;
        1)
            middle_line=" |       |       #   O   |       | "
            ;;
        2)
            middle_line=" |       |       #       |   O   | "
            ;;
        3)
            middle_line=" |       |       #       |       |O"
            ;;
    esac

    echo " --------------------------------- "
    echo " |       |       #       |       | "
    echo " |       |       #       |       | "
    echo "$middle_line"
    echo " |       |       #       |       | "
    echo " |       |       #       |       | "
    echo " --------------------------------- "
}

# arugments:
#   $1 - the location of the ball
#   $2 - player 1 score
#   $3 - player 2 score
get_winner () {
    if [[ $1 -eq -3 ]]
    # ball exited player 1's side so player 2 wins
    then
        echo "2"
    elif [[ $1 -eq 3 ]]
    # ball exited player 2's side so player 1 wins
    then
        echo "1"
    elif [[ $2 -eq 0 ]] && [[ $3 -eq 0 ]]
    # both players have 0 score
    then
        if [[ $1 -lt 0 ]]
        # ball is on player 1's side so he loses
        then
            echo "2"
        elif [[ $1 -gt 0 ]]
        # ball is on player 2's side so he loses
        then
            echo "1"
        else
        # ball is still at the middle so draw
            echo "0"
        fi
    elif [[ $2 -eq 0 ]]
    then
        echo "2"
    elif [[ $3 -eq 0 ]]
    then
        echo "1"
    else
        echo "-1"
    fi
}

# arugments:
#   $1 - string input
#   $2 - score
is_valid_number () {
    # makes sure that number is valid and within player's score range
    if [[ $1 =~ ^[0-9]+$ ]] && [[ $1 -ge 0 ]] && [[ $1 -le $2 ]]
    then
        echo "1"
    else
        echo "0"
    fi
}

winner=-1
ball_location=0
player_1_score=50
player_2_score=50

print_score $player_1_score $player_2_score
print_board $ball_location
while [[ $winner -eq -1 ]]
do
    player_1_input=""
    while [[ $(is_valid_number $player_1_input $player_1_score) -eq 0 ]]
    do
        echo "PLAYER 1 PICK A NUMBER:"
        read -s player_1_input
        if [[ $(is_valid_number $player_1_input $player_1_score) -eq 0 ]]
        then
            echo "NOT A VALID MOVE !"
        fi
    done

    player_2_input=""
    while [[ $(is_valid_number $player_2_input $player_2_score) -eq 0 ]]
    do
        echo "PLAYER 2 PICK A NUMBER:"
        read -s player_2_input
        if [[ $(is_valid_number $player_2_input $player_2_score) -eq 0 ]]
        then
            echo "NOT A VALID MOVE !"
        fi
    done
    
    player_1_score=$(($player_1_score - $player_1_input))
    player_2_score=$(($player_2_score - $player_2_input))
    
    if [[ $player_1_input -lt $player_2_input ]]
    # player 1 lost this round
    then
        if [[ $ball_location -lt 0 ]]
        # ball is on player 1's side
        then
        # move ball depper on 1's side
            ball_location=$(($ball_location - 1))
        else
        # ball was on 2's side, so now move it to 1's side
            ball_location=-1
        fi
    elif [[ $player_1_input -gt $player_2_input ]]
    # player 2 lost this round
    then
        if [[ $ball_location -gt 0 ]]
        # ball is on player 2's side
        then
            ball_location=$(($ball_location + 1))
            # move ball depper on 2's side
        else
            ball_location=1
            # ball was on 1's side, so now move it to 2's side
        fi
    fi

    winner=$(get_winner $ball_location $player_1_score $player_2_score)
    print_score $player_1_score $player_2_score
    print_board $ball_location
    echo -e "       Player 1 played: $player_1_input\n       Player 2 played: $player_2_input\n\n"
done

if [[ $winner -eq 0 ]]
then
    echo "IT'S A DRAW !"
else
    echo "PLAYER $winner WINS !"
fi
