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

        %box variables
        box1Center;
        box2Center;
        box3Center;
        box4Center;
        centerBox;
        
    end
    
    methods
        %constructor
        function rob = pathFinderRobot(rob)
            
            rob.arduino1 = arduino('COM5','Uno','Libraries','Servo');
            
            rob.servo1 = servo(rob.arduino1,'D9','MaxPulseDuration',2240e-6,'MinPulseDuration',575e-6)
            rob.servo2 = servo(rob.arduino1,'D10','MaxPulseDuration',2290e-6,'MinPulseDuration',575e-6)
            rob.servo3 = servo(rob.arduino1,'D11','MaxPulseDuration',2200e-6,'MinPulseDuration',700e-6)
            
            % Initial servo positions
            rob.t1ZeroPosition = 0.13;       % theta1 actual zero position
            rob.t2ZeroPosition = 1;          % theta2 actual zero position
            rob.t3Up = 140/180;              % theta3 up position
            rob.t3Down = 70/180;             % theta3 in down position
            rob.t1StartDrawingPos = 0.25;    % position for drawing purposes
            
            
            %Box coordinate values
            load mapvariable.mat;
            box1Center = mymap(3,10); %top left box center point
            box2Center = mymap(12,10); %top right box center point
            box3Center = mymap(12,3); %bottom right box center point
            box4Center = mymap(3,3); %bottom left box center point
            centerBox = mymap(8,6); %Center box center point
        end
        
        function rob = drawMap(rob)
            %load map & draw it on board
        end
        
        function rob = drawPath(rob)
            %use one of the three algorithms to draw
        end
        
        function rob = reDraw(rob)
            data = load(path.filename);
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
        
        function rob = checkPushButton(rob)
            %check if any button is pressed
            pinValue1 = readDigitalPin(rob.arduino1, 'D4'); % pins connected to arduino
            pinValue2 = readDigitalPin(rob.arduino1,'D5');  % pins connected to arduino
            
            if(pinValue1 == 1)
                disp('==== Injecting roadblock & replanning path ====\n');
                

            end
            if(pinValue2 == 1)
                disp('==== Quitting maze solving and returning to start ====');
                
            end
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
        
        function rob = mazeSolver(rob, algorithm)
            disp(' *****Maze solving has begun!!!*****')
            disp('Press pushbutton 1 to inject an obstacle in the rob.');
            disp('Press pushbutton 2 to interrupt maze solving and go back to start position.');
            pause(4);
            
            switch algorithm
                case 'D Star'
%                     determine how to use algorithm
                    rob = drawpath(rob);
                    
                case 'Probabilistic Road Map'
%                     determine how to use algorithm
                    rob = drawPath(rob);
                    
                case 'Distance Transform'
%                     determine how to use algorithm
                    rob = drawPath(rob);
            end %Switch case
        end % playPictionary
        
        function rob = PenUp(rob)
            % Theta3 to move pen tip upwards
            writePosition(rob.servo3, rob.t3Up); %penUp position
        end
        
        function rob = PenDown(rob)
            % Theta3 to move pen tip downwards
            writePosition(rob.servo3, rob.t3Down);
        end
        
        function rob = disconnectRobot(rob)
            %Clear workspace
            clear all;
            clc;
        end
        
    end % methods
end % class def