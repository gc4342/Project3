classdef pathFinderRobot
    properties
        arduino1; % arduino variable
        servo1;         % For joint 1
        servo2;         % For Joint 2
        servo3;         % For joint 3
        
        % variables
        t1ZeroPosition;         % Initial position of the servo1
        t2ZeroPosition;         % Initial position of the servo2
        t3Up;                   % Pen up position for joint 3
        t3Down;                 % Pen down position for joint 3
        t1StartDrawingPos;      % Joint position for joint 1, where it start drawing
        algorithm;
        intp_method;
        mazefilename;
        pathfilename;
        

        workFlag = 1;   % Flag to track the status of the game
        checkFlag = 1;
        
        start;      %Variable for start position
        goal;       %Variable for goal position
        
        %box variables
        box1Center;     %Coordinates of center of box1
        box2Center;     %Coordinates of center of box2
        box3Center;     %Coordinates of center of box3
        box4Center;     %Coordinates of center of box4
        centerBox;      %Coordinates of center of middle box 
    end
    
    methods
        %******************************************************************
        %   Function: drawRobot
        %   Input   : class object
        %   Output  : Returns the changed object
        %
        %   Working : This is a contructor function of the class pathFinderRobot
        %             it intitializes all the variables and puts the robot
        %             ready to draw the map and begin maze solving
        %******************************************************************
        function rob = pathFinderRobot()

            rob.arduino1 = arduino('COM5','Uno','Libraries','Servo');
            rob.servo1 = servo(rob.arduino1,'D9','MaxPulseDuration',2240e-6,'MinPulseDuration',575e-6);
            rob.servo2 = servo(rob.arduino1,'D10','MaxPulseDuration',2290e-6,'MinPulseDuration',575e-6);
            rob.servo3 = servo(rob.arduino1,'D11','MaxPulseDuration',2200e-6,'MinPulseDuration',700e-6);
         
            % Initial servo positions
            rob.t1ZeroPosition = 0.13;       % theta1 actual zero position
            rob.t2ZeroPosition = 0.7;        % theta2 actual zero position
            rob.t3Up = 140/180;              % theta3 up position
            rob.t3Down = 60/180;             % theta3 in down position
            rob.t1StartDrawingPos = 0.34;    % position for drawing purposes
            
            rob.workFlag = 1;
            rob.checkFlag = 1;

            rob = PenUp(rob);

            rob.mazefilename = 'shapesinfo.txt';
            rob.start = [3, 10];
            rob.goal = [12, 3];
        end
        
        %******************************************************************
        %   Function: drawMap
        %   Input   : class object
        %   Output  : Returns the changed object
        %
        %   Working : This loads the joint angles file obtained from the
        %             GUI and programs the servos to move the joints as
        %             given in the file and hence draw the figure given in
        %             the file.
        %
        %******************************************************************

        function rob = drawMap(rob)
            data = load('shapesinfo.txt');
            i = 1;
            writePosition(rob.servo3, rob.t3Up);
            
            while true % if file is empty > penup
                if (data(i, 1) == 61.000000)
                    i = i+1;
                    chngFlag = 1;    % On map - location jump to another box
                    writePosition(rob.servo3, rob.t3Up);
                end
                
                q1 = data(i,1); % joint angle one
                q2 = data(i,2); % joint angle two
                
                % relative joint angle for servos 1 & 2
                pos1 = abs(rob.t1StartDrawingPos-q1);
                pos2 = abs(rob.t2ZeroPosition-q2);      
                % write position to servos 1 & 2 to move to the specified angle
                writePosition(rob.servo1, pos1);
                writePosition(rob.servo2, pos2);
                
                if (i==1 || chngFlag == 1)
                    pause(0.5);
                    writePosition(rob.servo3, rob.t3Down); % get ready to start drawing
                    chngFlag = 0;
                end
                pause(0.25);
                i = i+1;
            end
        end
        
        function rob = drawPath(rob, start_x, start_y, blk_x, blk_y, reverse)
            load mapvariable.mat;
            if(blk_x ~= 0 || blk_y ~= 0)
                fprintf('CAUTION: Road is blocked ahead at %d, %d\n', blk_x, blk_y);
                fprintf('Relax, till I find a new route for you\n');
                mymap(blk_y, blk_x) = 1;
                rob.start = [start_x, start_y];
            end
            if(reverse == 1)
                rob.goal = rob.start;
                rob.start = [start_x, start_y];
            end
 
            algo = rob.algorithm;      
            switch algo
               case 1
                   disp('Dstar algorithm')
                   ds=Dstar(mymap);
               case 2
                   disp('PRM algorithm')
                   ds=PRM(mymap);
               case 3
                   disp('DxForm algorithm')
                   ds=DXform(mymap);
               otherwise
                    disp('Not a valid option for algorithm')
            end
            ds.plan(rob.goal);
            ds.plot();
            path_points = ds.query(rob.start,rob.goal)
            ds.plot(path_points);
            [m,n]=size(path_points);
            rob.intp_method;
            switch rob.intp_method
               case 'mtraj-tpoly'
                   disp('Mtraj_tpoly')
                   for i=1:1:m-1  %1 to 6
                       if i==1
                          mtraj_path_points_tpoly(1:10,1:2) = mtraj(@tpoly,[path_points(i,1) ...
                          path_points(i,2)], [path_points(i+1,1) path_points(i+1,2)],10);
                       else
                          mtraj_path_points_tpoly((i*10)-9:10*i,1:2) = mtraj(@tpoly,[path_points(i,1) ...
                          path_points(i,2)], [path_points(i+1,1) path_points(i+1,2)],10);                
                       end
                   end
                   dlmwrite('mtrajPoints.txt',mtraj_path_points_tpoly,'delimiter','\t','newline','pc');
                   rob.pathfilename = 'mtrajPoints.txt';
                   hold on;
                   plot(mtraj_path_points_tpoly(:,1),mtraj_path_points_tpoly(:,2),'c');
                   pause(2);
               case 'mtraj-lspb'
                   disp('Mtraj_lspb')
                    for i=1:1:m-1  %1 to 6
                       if i==1
                          mtraj_path_points_lspb(1:10,1:2) = mtraj(@lspb,[path_points(i,1) ...
                          path_points(i,2)], [path_points(i+1,1) path_points(i+1,2)],10);
                       else
                          mtraj_path_points_lspb((i*10)-9:10*i,1:2) = mtraj(@lspb,[path_points(i,1) ...
                          path_points(i,2)], [path_points(i+1,1) path_points(i+1,2)],10);                
                       end
                   end
                   dlmwrite('mtrajPoints.txt',mtraj_path_points_lspb,'delimiter','\t','newline','pc');
                   rob.pathfilename = 'mtrajPoints.txt';
                   hold on;
                   plot(mtraj_path_points_lspb(:,1),mtraj_path_points_lspb(:,2),'b--o');
                   pause(2);                  
               otherwise
                    disp('Not a valid option for interpolation method')
            end
        end
        
        %******************************************************************
        %   Function: checkPushButton
        %   Input   : class object
        %   Output  : Returns the changed object
        %
        %   Working : polling on the push buttons, if the button is pressed,
        %             and is true, then the processing is given to UserGuess
        %             function, the return value is checked, if the number
        %             of guesses per player has not exceeded maximum chances
        %             and proper action is taken accordingly here.
        %******************************************************************
        
        function rob = checkPushButton(rob, new_x, new_y, blk_x, blk_y)
            %check if any button is pressed
            pinValue1 = readDigitalPin(rob.arduino1, 'D4'); % pins connected to arduino
            pinValue2 = readDigitalPin(rob.arduino1,'D5');  % pins connected to arduino
            
            if(pinValue1 == 1)
                disp('==== Injecting roadblock & replanning path ====\n');
                rob = drawPath(rob, fix(new_x), fix(new_y), fix(blk_x), fix(blk_y), 0);
                rob.workFlag = 0;
            end
            if(pinValue2 == 1)
                disp('==== Quitting maze solving and returning to start ====');
                rob = drawPath(rob, fix(new_x), fix(new_y), 0, 0, 1);
                rob.workFlag = 0;
            end
        end
        
        %******************************************************************
        %   Function: recordMovements
        %   Input   : class object, joint angle 1, joint angle 2
        %   Output  : Returns the changed object
        %
        %   Working : writes the joint angle required to move the servo to
        %             move the pen as per the key press position for drawing
        %             on the sheet simultaneously with GUI
        %******************************************************************
        
        function rob = recordMovement(rob, q1, q2, q3)
            % relative joint angle for servos 1 -> 3
            pos1 = abs(rob.t1StartDrawingPos-q1); 
            pos2 = abs(rob.t2ZeroPosition-q2);
            pos3 = abs(rob.t3Down - q3);
            % write position to servos to move to the specified angle
            writePosition(rob.servo1, pos1);
            writePosition(rob.servo2, pos2);
            writePosition(rob.servo3, pos3);
            % PenDown to be down at the first time this function is called
            if(rob.checkFlag == 1)
                pause(5);
                writePosition(rob.servo3, rob.t3Down);
                rob.checkFlag = 0;
            end
        end
        
        function rob = mazeSolver(rob)
            disp('Press pushbutton 1 to inject an obstacle in the rob.');
            disp('Press pushbutton 2 to interrupt maze solving and go back to start position.');
            disp('');
            disp(rob.algorithm)
            %rob.intp_method = intp_method;
            switch rob.algorithm
                case 'D_Star'
                    disp('Solving using D Star');
                  rob.algorithm = 1;

                    rob = drawPath(rob, rob.start,rob.goal, 0, 0, 0);
                    
                case 'PRM'
                    disp('Solving using PRM');
                      rob.algorithm = 2;
                    rob = drawPath(rob, rob.start,rob.goal, 0, 0, 0);
                    
                case 'DXForm'
                    disp('Solving using DXForm');
                      rob.algorithm = 3;
                    rob = drawPath(rob, rob.start,rob.goal, 0, 0, 0);
            end %Switch case
        end % mazesolver
        
        %******************************************************************
        %   Function: PenUp
        %   Input   : class object
        %   Output  : Returns the changed object
        %
        %   Working : writes the joint angle required to move the servo to
        %             move the pen in up right position.
        %
        %******************************************************************

        function rob = PenUp(rob)
            % Theta3 to move pen tip upwards
            writePosition(rob.servo3, rob.t3Up); %penUp position
        end
        
        %******************************************************************
        %   Function: PenDown
        %   Input   : class object
        %   Output  : Returns the changed object
        %
        %   Working : writes the joint angle required to move the servo to
        %             move the pen in ready position for drawing on the
        %             sheet(Perpendicular to the paper)
        %
        %******************************************************************

        function rob = PenDown(rob)
            % Theta3 to move pen tip downwards
            writePosition(rob.servo3, rob.t3Down);
        end
        
        %******************************************************************
        %   Function: DisconnectRobot
        %   Input   : class object
        %   Output  : void
        %
        %   Working : Disconnects the robot and clears all the objects.

        function rob = disconnectRobot(rob)
            clear all;
            clc;
        end
    end % methods
end % class def