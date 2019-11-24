classdef pathFinderRobot
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
        
    end
    
    methods
        function path = pathFinderRobot(path)
            
            path.arduino1 = arduino('COM6','Uno','Libraries','Servo')
            
            path.servo1 = servo(path.arduino1,'D9','MaxPulseDuration',2240e-6,'MinPulseDuration',575e-6)
            path.servo2 = servo(path.arduino1,'D10','MaxPulseDuration',2290e-6,'MinPulseDuration',575e-6)
            path.servo3 = servo(path.arduino1,'D11','MaxPulseDuration',2200e-6,'MinPulseDuration',700e-6)
            
            % Initial servo positions
            path.t1ZeroPosition = 0.13;       % theta1 actual zero position
            path.t2ZeroPosition = 1;          % theta2 actual zero position
            path.t3Up = 140/180;              % theta3 up position
            path.t3Down = 70/180;             % theta3 in down position
            path.t1StartDrawingPos = 0.25;    % position for drawing purposes
            
            % Flags for debugging/code functions
            path.workFlag = 1;
            path.checkFlag = 1;
        end
        
        function path = drawMaze(path)
            %load map & draw it on board
        end
        
        function path = drawPath(path)
            %use d*
        end
                
        function path = reDraw(path)
            data = load(path.filename);
            i = 1;
            writePosition(path.servo3, path.t3Up);
            pause(1);
            while true % if file is empty > penup
                if ~isfloat(data(i+1,1))
                    writePosition(s3, 160/180);
                    break;
                end
                path = checkPushButton(path); % call to check if the button is pressed
                if(path.workFlag == 0)% || (path.workFlag == 2))
                    disp('=========  Game Over  ============');
                    pause(20)
                    break;
                end
                
                q1 = data(i,1); % joint angle one
                q2 = data(i,2); % joint angle two
                
                pos1 = abs(path.t1StartDrawingPos-q1); % how much theta we move
                pos2 = abs(path.t2ZeroPosition-q2);
                writePosition(path.servo1, pos1);
                writePosition(path.servo2, pos2);
                current_pos1 = readPosition(path.servo1);
                current_pos1 = current_pos1*180;
                current_pos2 = readPosition(path.servo2);
                current_pos2 = current_pos2*180;
                if (i==1)
                    pause(2);
                    writePosition(path.servo3, path.t3Down); % get ready to start drawing
                end
                pause(0.25);
                i = i+1;
            end
        end
        
        function path = checkPushButton(path)
            %check if any button is pressed
            pinValue1 = readDigitalPin(path.arduino1, 'D4'); % pins connected to arduino
            pinValue2 = readDigitalPin(path.arduino1,'D5');  % pins connected to arduino
            
            if(pinValue1 == 1)
                fprintf('\n====%s pressed the button====\n',path.player(1).name);
                path = UserGuess(path);
                path.player(1).buttonFlag = 1;
                path.player(1).GuessCount = path.player(1).GuessCount - 1;
                if((path.player(1).GuessCount ~=0) & (path.workFlag == 1))
                    fprintf('\nYou have %d guesses left, choose wisely.\n', path.player(1).GuessCount);
                    pause(2);
                end
                if ~path.player(1).GuessCount
                    disp('You do not have any more chances left!');
                    %path.workFlag = 0; % Flag for game over
                end
            end
            if(pinValue2 == 1)
                fprintf('\n====%s pressed the button====\n',path.player(2).name);
                path = UserGuess(path);
                path.player(2).buttonFlag = 1;
                path.player(2).GuessCount = path.player(2).GuessCount - 1;
                if((path.player(2).GuessCount ~=0) & (path.workFlag == 1))
                    fprintf('You have %d guesses left, choose wisely. ', path.player(2).GuessCount);
                    pause(2);
                end
                if ~path.player(2).GuessCount
                    disp(' %d You have used all your chances!');
                    disp(' Better Luck next time! :(');
                    %path.workFlag = 2;  % Flag for game over
                end
            end
        end
        
        function path = recordMovement(path, q1, q2, q3)
            pos1 = abs(path.t1StartDrawingPos-q1);
            pos2 = abs(path.t2ZeroPosition-q2);
            pos3 = abs(path.t3Down - q3);
            writePosition(path.servo1, pos1);
            writePosition(path.servo2, pos2);
            writePosition(path.servo3, pos3);
            if(path.checkFlag == 1)
                pause(2);
                writePosition(path.servo3, path.t3Down);
                path.checkFlag = 0;
            end
        end
        
        function path = PenUp(path)
            % Theta3 to move pen tip upwards
            writePosition(path.servo3, path.t3Up); %penUp position
        end
        
        function path = PenDown(path)
            % Theta3 to move pen tip downwards
            writePosition(path.servo3, path.t3Down);
        end
        
        function path = disconnectRobot(path)
            %Clear workspace
            clear all;
            clc;
        end
        
    end % methods
end % class def