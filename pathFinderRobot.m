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
        algorithm
        algorithm_choice;
        interpolation_method;
        mazefilename;
        pathfilename;
        
        workFlag = 1;
        checkFlag = 1;
        
        start;
        goal;

        %box variables
        box1Center;
        box2Center;
        box3Center;
        box4Center;
        centerBox;
        
    end
    
    methods
        %constructor
        function rob = pathFinderRobot()
            
            rob.arduino1 = arduino('COM5','Uno','Libraries','Servo');
            
            rob.servo1 = servo(rob.arduino1,'D9','MaxPulseDuration',2240e-6,'MinPulseDuration',575e-6);
            rob.servo2 = servo(rob.arduino1,'D10','MaxPulseDuration',2290e-6,'MinPulseDuration',575e-6);
            rob.servo3 = servo(rob.arduino1,'D11','MaxPulseDuration',2200e-6,'MinPulseDuration',700e-6);
            
            % Initial servo positions
            rob.t1ZeroPosition = 0.13;       % theta1 actual zero position
            rob.t2ZeroPosition = 0.7;          % theta2 actual zero position
            rob.t3Up = 140/180;              % theta3 up position
            rob.t3Down = 60/180;             % theta3 in down position
            rob.t1StartDrawingPos = 0.34;    % position for drawing purposes
            
            
            %Box coordinate values
            load mapvariable.mat;
            box1Center = mymap(3,10); %top left box center point
            box2Center = mymap(12,10); %top right box center point
            box3Center = mymap(12,3); %bottom right box center point
            box4Center = mymap(3,3); %bottom left box center point
            centerBox = mymap(8,6); %Center box center point
            

            
            rob.workFlag = 1;
            rob.checkFlag = 1;
            rob = PenUp(rob);
            rob.mazefilename = 'shapesinfo.txt';
            rob.start = [3, 10];
            rob.goal = [12, 3];

        
        function rob = drawMap(rob)
            data = load('shapesinfo.txt');
            i = 1;
            writePosition(rob.servo3, rob.t3Up);
          
            while true % if file is empty > penup
                if (data(i, 1) == 61.000000)
                    i = i+1;
                    writePosition(rob.servo3, rob.t3Up);
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
                if (i==1 || i-1 == 61.000000)
                    writePosition(rob.servo3, rob.t3Down); % get ready to start drawing
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
            
            rob.algorithm;       
            switch rob.algorithm
               case 'D_Star'
                   disp('Dstar algorithm')
                   ds=Dstar(mymap);
               case 'PRM'
                   disp('PRM algorithm')
                   ds=PRM(mymap);
               case 'DXForm'
                   disp('DxForm algorithm')
                   ds=DXform(mymap);
               otherwise
                    disp('Not a valid option for algorithm')
            end
            ds.plan(rob.goal);
            ds.plot();
            ds.query(rob.start, 'animate');
            path_points = ds.query(rob.start, 'animate');
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
                   rob.pathfilename = 'mtrajPoints.txt.txt';
                   hold on;
                   plot(mtraj_path_points_tpoly(:,1),mtraj_path_points_tpoly(:,2),'*w');
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
                   dlmwrite('mtrajPoints.txt.txt',mtraj_path_points_lspb,'delimiter','\t','newline','pc');
                   rob.pathfilename = 'mtrajPoints.txt.txt';
                   hold on;
                   plot(mtraj_path_points_lspb(:,1),mtraj_path_points_lspb(:,2),'*w');
                   pause(2);                  
               otherwise
                    disp('defaulting to no interpolation')
            end
            

        end
        
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
        
        function rob = recordMovement(rob, q1, q2, q3)
            pos1 = abs(rob.t1StartDrawingPos-q1);
            pos2 = abs(rob.t2ZeroPosition-q2);
            pos3 = abs(rob.t3Down - q3);
            writePosition(rob.servo1, pos1);
            writePosition(rob.servo2, pos2);
            writePosition(rob.servo3, pos3);
            if(rob.checkFlag == 1)
                pause(5);
                writePosition(rob.servo3, rob.t3Down);
                rob.checkFlag = 0;
            end
        end
        
        function rob = mazeSolver(rob, algorithm, intp_method)
            disp('Press pushbutton 1 to inject an obstacle in the rob.');
            disp('Press pushbutton 2 to interrupt maze solving and go back to start position.');
            disp('');
            rob.intp_method = intp_method;
            switch algorithm
                case 'D_Star'
%                     determine how to use algorithm
                    disp('         Solving using D Star             ');
                    rob.algorithm = 1;
                    rob = drawPath(rob, rob.start,rob.goal, 0, 0, 0);
                    
                case 'PRM'
%                     determine how to use algorithm
                    rob.algorithm = 2;
                    rob = drawPath(rob, rob.start,rob.goal, 0, 0, 0);
                    
                case 'DXForm'
%                     determine how to use algorithm
                    rob.algorithm = 3;
                    rob = drawPath(rob, rob.start,rob.goal, 0, 0, 0);
            end %Switch case
        end % mazesolver
        
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