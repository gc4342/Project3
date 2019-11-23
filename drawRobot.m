classdef drawRobot
    properties
        % arduino variable
        arduino1;
        
        % declare servos
        servo1;
        servo2;
        servo3;
        
        % variables
        t1ZeroPosition;
        t2ZeroPosition;
        t3Up;
        t3Down;
        t1StartDrawingPos;
        filename;
        workFlag;
        checkFlag;
        
        %defining players struct
        player = struct('name', 0, 'GuessCount', 3, 'buttonFlag', 0);
        
    end
    
    methods    
        function rob = drawRobot(rob)
            
            rob.arduino1 = arduino('COM6','Uno','Libraries','Servo')
            
            rob.servo1 = servo(rob.arduino1,'D9','MaxPulseDuration',2240e-6,'MinPulseDuration',575e-6)
            rob.servo2 = servo(rob.arduino1,'D10','MaxPulseDuration',2290e-6,'MinPulseDuration',575e-6)
            rob.servo3 = servo(rob.arduino1,'D11','MaxPulseDuration',2200e-6,'MinPulseDuration',700e-6)
            
            % Initial servo positions
            rob.t1ZeroPosition = 0.13;       % theta1 actual zero position
            rob.t2ZeroPosition = 1;          % theta2 actual zero position
            rob.t3Up = 140/180;              % theta3 up position
            rob.t3Down = 70/180;             % theta3 in down position
            rob.t1StartDrawingPos = 0.25;    % position for drawing purposes
            
            % Flags for debugging/code functions
            rob.workFlag = 1;
            rob.checkFlag = 1;
        end
        
        function rob = playBackMovements(rob)
            data = load(rob.filename);
            i = 1;
            writePosition(rob.servo3, rob.t3Up);
            pause(1);
            while true % if file is empty > penup
                if ~isfloat(data(i+1,1))
                    writePosition(s3, 160/180);
                    break;
                end
                rob = checkPushButton(rob); % call to check if the button is pressed
                if(rob.workFlag == 0)% || (rob.workFlag == 2))
                    disp('=========  Game Over  ============');
                    pause(20)
                    break;
                end
                
                q1 = data(i,1); % joint angle one
                q2 = data(i,2); % joint angle two
                
                pos1 = abs(rob.t1StartDrawingPos-q1); % how much theta we move
                pos2 = abs(rob.t2ZeroPosition-q2);
                writePosition(rob.servo1, pos1);
                writePosition(rob.servo2, pos2);
                current_pos1 = readPosition(rob.servo1);
                current_pos1 = current_pos1*180;
                current_pos2 = readPosition(rob.servo2);
                current_pos2 = current_pos2*180;
                if (i==1)
                    pause(2);
                    writePosition(rob.servo3, rob.t3Down); % get ready to start drawing
                end
                pause(0.25);
                i = i+1;
            end
        end
        
        function DisconnectRobot(rob)
            %Clear workspace
            clear all;
            clc;
        end
        
        function rob = checkPushButton(rob)
            %check if any button is pressed
            pinValue1 = readDigitalPin(rob.arduino1, 'D4'); % pins connected to arduino
            pinValue2 = readDigitalPin(rob.arduino1,'D5');  % pins connected to arduino
            
            if(pinValue1 == 1)
                fprintf('\n====%s pressed the button====\n',rob.player(1).name);
                rob = UserGuess(rob);
                rob.player(1).buttonFlag = 1;
                rob.player(1).GuessCount = rob.player(1).GuessCount - 1;
                if((rob.player(1).GuessCount ~=0) & (rob.workFlag == 1))
                    fprintf('\nYou have %d guesses left, choose wisely.\n', rob.player(1).GuessCount);
                    pause(2);
                end
                if ~rob.player(1).GuessCount
                    disp('You do not have any more chances left!');
                    %rob.workFlag = 0; % Flag for game over
                end
            end
            if(pinValue2 == 1)
                fprintf('\n====%s pressed the button====\n',rob.player(2).name);
                rob = UserGuess(rob);
                rob.player(2).buttonFlag = 1;
                rob.player(2).GuessCount = rob.player(2).GuessCount - 1;
                if((rob.player(2).GuessCount ~=0) & (rob.workFlag == 1))
                    fprintf('You have %d guesses left, choose wisely. ', rob.player(2).GuessCount);
                    pause(2);
                end
                if ~rob.player(2).GuessCount
                    disp(' %d You have used all your chances!');
                    disp(' Better Luck next time! :(');
                    %rob.workFlag = 2;  % Flag for game over
                end
            end
        end
        
        function rob = PenUp(rob)
            % Theta3 to move pen tip upwards
            writePosition(rob.servo3, rob.t3Up); %penUp position
        end
        
        function rob = PenDown(rob)
            % Theta3 to move pen tip downwards
            writePosition(rob.servo3, rob.t3Down);
        end
        
        function rob = recordMovement(rob, q1, q2, q3)
            pos1 = abs(rob.t1StartDrawingPos-q1);
            pos2 = abs(rob.t2ZeroPosition-q2);
            pos3 = abs(rob.t3Down - q3);
            writePosition(rob.servo1, pos1);
            writePosition(rob.servo2, pos2);
            writePosition(rob.servo3, pos3);
            if(rob.checkFlag == 1)
                pause(2);
                writePosition(rob.servo3, rob.t3Down);
                rob.checkFlag = 0;
            end
        end
              
        function rob = PlayPictionary(rob, picture)
            prompt = 'Enter Player 1 name: ';
            rob.player(1).name = input(prompt,'s');
            prompt = 'Enter Player 2 name: ';
            rob.player(2).name = input(prompt,'s');
            disp(' *****Let us play Pictionary!!!*****')
            disp('Pictionary game starting! You have 3 guesses');
            disp('============Rules of Pictionary game ================');
            disp('1. Two buttons are assigned to 2 players ');
            disp('2. Robot will start drawing and players have to guess the shape drawn by the robot');
            disp('3. Press the button first to enter your guess');
            disp('4. Each player will have only 3 chances to guess the shape');
            disp('5. Robot will pause drawing, while you guess the shape but resumes the drawing if answer is incorrect');
            disp('6. If Robot finishes drawing first, Robot wins and Players lose');
            pause(4);
            disp('          Hands on the push buttons, Let us start the game');
            
            switch picture
                case 'triangle'
                    rob.filename = 'triangle.txt';
                    rob = playBackMovements(rob);
                    
                case 'square'
                    rob.filename = 'square.txt'
                    rob = playBackMovements(rob);
                    
                case 'staircase'
                    rob.filename = 'stairsshape.txt';
                    rob = playBackMovements(rob)
                    
                case 'circle'
                    rob.filename = 'circle.txt';
                    rob = playBackMovements(rob)
                    
            end %Switch case
        end % playPictionary
        
        function rob = UserGuess(rob)
            prompt = 'Enter your answer: ';
            shape = input(prompt,'s');
            shapeFromFile = split(rob.filename,'.');
            CorrectShape = char(shapeFromFile(1));
            if strcmp(shape, CorrectShape)
                disp(' Great Guess!!! You WIN!!!! Congrats :) ');
                disp('*******Exiting Pictionary Game********');
                rob.workFlag = 0;
            else
                disp('Incorrect answer, Try again!');
                pause(2);
            end
        end % userGuess
    end % methods
end % class def