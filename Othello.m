%************************************************
%*  Name:  Group H       Date:  10/20/18        *
%*  Seat/Table:  31      File:  Othello.m       *
%*  Instructor:  Dr. Pulcherio 12:40            *                   
%************************************************ 


%Clear Everything
clc
clear
%Load Othello.mat
load Othello.mat

%Display Board
display(Board);

%Construct board
%Player 1 = black, Player 2 = white
%0 = empty, 1 = black, 2 = white
board = [0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 2 1 0 0 0; 0 0 0 1 2 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0;];

%Find all valid moves for both players
[possibleMovesXBlack,possibleMovesBlack] = allValidMoves(1,board);
[possibleMovesXWhite,possibleMovesYWhite] = allValidMoves(2,board);

%Initial Settings
color = 2;
disc = whitedisc;
fprintf('Player 1 is black, Player 2 is white\n');
%While at least one player has a valid move, continue to play
while numel(possibleMovesXBlack) > 0 || numel(possibleMovesXWhite) > 0
        if (color == 1)
            color = 2;
            disc = whitedisc;
        else
            color = 1;
            disc = blackdisc;
        end
        [possibleMovesX,possibleMovesY] = allValidMoves(color,board);
        if(numel(possibleMovesX) ~= 0)
            isInArray = 0;
            %While the selected move isn't in the array of valid moves
            while isInArray == 0
                %User Move input
                playerYMove = input(['Player ' num2str(color) ' Y-Move: ']);
                playerXMove = input(['Player ' num2str(color) ' X-Move: ']);
                %If it is numeric, not empty, and in the array of valid moves,
                if(((isnumeric(playerYMove) == 1 && isnumeric(playerXMove) == 1) && ~(isempty(playerYMove) || isempty(playerXMove))) && isValidMove(playerYMove,playerXMove,possibleMovesY,possibleMovesX) == 1)
                    [board,Board] = updateBoard(color,playerYMove,playerXMove,board,Board,disc);
                    %Set isInArray to 0
                    isInArray = 1;
                else
                   fprintf('Invalid Input!\n')
                end
             end
        else
            fprintf('No Valid Moves For Player %1.0f! Skipping Their Turn!\n',color)
        end
   [possibleMovesXBlack,possibleMovesYBlack] = allValidMoves(1,board);
   [possibleMovesXWhite,possibleMovesYWhite] = allValidMoves(2,board);
end

%Display Score
displayScore(board)

%Function to calculate score and display at the end of the game
function displayScore(board)
    %Calculate Player scores after game is over
    blackScore = 0;
    whiteScore = 0;
    %Check every spot
    for n = 1:1:8
        for i = 1:1:8
            if(board(n,i) == 1)
                blackScore = blackScore + 1;
            elseif(board(n,i) == 2)
                whiteScore = whiteScore + 1;
            end
        end
    end
    %Print Player scores
    fprintf('Player 1 Score: %3.0f\n',blackScore)
    fprintf('Player 2 Score: %3.0f\n',whiteScore)
    %Print Higher Score, or Tie
    if(blackScore > whiteScore)
        fprintf('Player 1 Wins!\n')
    elseif(whiteScore > blackScore)
        fprintf('Player 2 Wins!\n')
    else
        fprintf('Tie!\n')
    end

end

%Function to update the board
function [board,Board] = updateBoard(color,playerYMove,playerXMove,board,Board,disc)
     %Set Coin down on board
     Board{playerYMove,playerXMove} = disc;
     board(playerYMove,playerXMove) = color;
     display(Board);
     %Flip all necessary discs
     [board, Board] = flipCoins(color,playerYMove,playerXMove,board,Board,disc);
     %Redisplay Board
     display(Board);
end

%Returns 0 if move is not valid, 1 if it is
function isValid = isValidMove(playerYMove, playerXMove, possibleMovesY,possibleMovesX)
    isValid = 0;
    %Loop through valid moves to check if selected move is in the array
    for n = 1:1:numel(possibleMovesX)
        %If it is in the array of valid moves,
        if(possibleMovesX(n) == playerXMove && possibleMovesY(n) == playerYMove)
            %Set isInArray to 1 to exit loop and update board
            isValid = 1;
        end
    end
end

%Flip all relevant discs after a move
function [board, Board] = flipCoins(color,moveY,moveX,board,Board,disc)
    %If color is black
    if(color == 1)
        %Check all touching row, col, diagonal
        for n = -1:1:1
            for i = -1:1:1
                foundSameDisc = 0;
                %See if there's a same colored disc on that row, col, diagonal
                for multiplier = 2:1:8
                    if moveY + (n * multiplier) > 0 && moveY + (n * multiplier) < 9 && moveX + (i * multiplier) > 0 && moveX + (i * multiplier) < 9
                         if(board((moveY + (n * multiplier)),(moveX + (i * multiplier))) == 1)
                             foundSameDisc = multiplier;                             
                             break;
                         end
                    end
                end
                %If there is a black disc on that row, col, diagonal
                if(foundSameDisc ~= 0)
                    toFlip = 1;
                    %Check to see if all spaces between them are filled with white discs
                    for a = 1:1:foundSameDisc - 1
                       if(board((moveY + (n * a)),(moveX + (i * a))) ~= 2)
                          toFlip = 0;
                       end
                    end
                    %If all spaces between them are filled with white discs, flip the white discs
                    if(toFlip == 1)
                        for a = 1:1:foundSameDisc - 1
                            board((moveY + n*a),(moveX + i*a)) = 1;
                            Board{(moveY + n*a), (moveX + i*a)} = disc;
                        end
                    end
                end
            end
        end
    else
       %Color is white
       %Check all touching row, col, diagonal
       for n = -1:1:1
            for i = -1:1:1
                foundSameDisc = 0;
                %See if there's a same colored disc on that row, col, diagonal
                for multiplier = 2:1:8
                    if moveY + (n * multiplier) > 0 && moveY + (n * multiplier) < 9 && moveX + (i * multiplier) > 0 && moveX + (i * multiplier) < 9
                         if(board((moveY + (n * multiplier)),(moveX + (i * multiplier))) == 2)
                             foundSameDisc = multiplier;                             
                             break;
                         end
                    end
                end
                %If there is a white disc on that row, col, diagonal
                if(foundSameDisc ~= 0)
                    toFlip = 1;
                    %Check to see if all spaces between them are filled with black discs
                    for a = 1:1:foundSameDisc - 1
                       if(board((moveY + (n * a)),(moveX + (i * a))) ~= 1)
                          toFlip = 0;
                       end
                    end
                    %If all spaces between them are filled with black discs, flip the black discs
                    if(toFlip == 1)
                        for a = 1:1:foundSameDisc - 1
                            board((moveY + n*a),(moveX + i*a)) = 2;
                            Board{(moveY + n*a), (moveX + i*a)} = disc;
                        end
                    end
                end
            end
        end
    end
end

%Returns all valid moves for a player
function [validMovesX,validMovesY] = allValidMoves(color,board)
   %Instantiate return arrays of valid moves
   validMovesX = [];
   validMovesY = [];
   %If Color is Black
   if(color == 1)
       %Check all board positions
        for y= 1:1:8
            for x = 1:1:8
                %If disc at location is white
                if board(y,x) == 2
                   %Check every touching row, col, diagonal
                   for a = -1:1:1
                       for s = -1:1:1
                           %If selected position is on the board, continue
                           if (y + a > 0) && (y + a < 9) && (x + s) > 0 && (x + s) < 9
                               %If the white piece has a black piece touching it
                               if (board(y + a, x + s) == 1)
                                  %Check all positions of that row, col, diagonal
                                   for multiple = 1:1:8
                                    %If is valid postition is on the board, continue
                                    if(y + (a * multiple * -1) > 0 && y + (a * multiple * -1) < 9 && x + (s * multiple * -1) > 0 && x + (s * multiple * -1) < 9)
                                      %If disc at location is white continue checking
                                      if(board(y + (a * multiple * -1),x + (s * multiple * -1)) == 2)
                                         continue;
                                      %If there's an empty space, add to validMoves array and stop checking  
                                      elseif(board(y + (a * multiple * -1),x + (s * multiple * -1)) == 0)
                                         validMovesY = [validMovesY, (y + (a * multiple * -1))];
                                         validMovesX = [validMovesX, (x + (s * multiple * -1))];
                                         break;
                                      %If it's a black piece, stop checking   
                                      else
                                         break;
                                     end                                     
                                  end
                               end
                            end
                           end
                       end
                   end
                end
            end
         end
   else
        %Case where color is white
        %Check all board positions
        for y= 1:1:8
            for x = 1:1:8
                %If disc at location is black
                if board(y,x) == 1
                   %Check every touching row, col, diagonal
                   for a = -1:1:1
                       for s = -1:1:1
                           %If selected position is on the board, continue
                           if (y + a > 0) && (y + a < 9) && (x + s > 0) && (x + s < 9)
                             %If the black piece has a white piece touching it
                             if (board(y + a, x + s) == 2)
                               %Check all positions of that row, col, diagonal  
                               for multiple = 1:1:8
                                  %If is valid postition is on the board, continue
                                  if(y + (a * multiple * -1) > 0 && y + (a * multiple * -1) < 9 && x + (s * multiple * -1) > 0 && x + (s * multiple * -1) < 9)
                                      %If disc at location is black continue checking
                                      if(board(y + (a * multiple * -1),x + (s * multiple * -1)) == 1)
                                         continue;
                                      %If there's an empty space, add to validMoves array and stop checking   
                                      elseif(board(y + (a * multiple * -1),x + (s * multiple * -1)) == 0)
                                         validMovesY = [validMovesY, (y + (a * multiple * -1))];
                                         validMovesX = [validMovesX, (x + (s * multiple * -1))];
                                         break;
                                      %If it's a black piece, stop checking    
                                      else
                                          break;
                                     end                                     
                                  end
                               end
                             end
                           end
                       end
                   end
                end
            end
         end
    end
end

%Displays Board
function display(Board)
imshow([Board{1,:};Board{2,:};Board{3,:};Board{4,:};Board{5,:};Board{6,:};Board{7,:};Board{8,:}])
end