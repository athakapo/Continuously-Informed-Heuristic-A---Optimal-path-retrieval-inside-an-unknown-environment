classdef cFibHeap < handle
    %CFIBHEAP Fibonacci Heap
    %   Fibonacci min-heap (beta release)
    %
    %     USAGE:
    %
    %       myHeap = cFibHeap       Create empty Fibonacci Heap 'myHeap'
    %
    %     Assuming 'myHeap' was created as above:
    %
    %       myHeap.insert(x)        Insert key 'x' into heap
    %       z = myHeap.FindMin      Return minimum key 'z'
    %       z = myHeap.ExtractMin   Return and delete minimum key 'z'
    %       n = myHeap.n            Return current size 'n' of the Heap
    %
    %
    %   (Based on algorithms from Cormen, Leiserson, Rivest, and Stein.
    %     "Introduction to Algorithms". 2nd Ed. McGraw-Hill (2007).)
   

    
    % Private data
    properties (SetAccess='private')                
        n     % Number of nodes in heap                
        minH  % pointer to min(H) node in heap
    end
    
    properties (SetAccess='private', GetAccess='private')
       nullNode % pointer to nullNode used in auxiliary array
                % in consolidate() function
    end
    
    
    % Private functions
    methods (Access='private')
        % disconnect root node from left/right siblings
        %   (and repair siblings)
        function disconnect(FH,x)
            prevNode = x.left;
            nextNode = x.right;
            prevNode.right = nextNode;
            nextNode.left = prevNode;
        end %disconnect()
        
        % insert-after into doubly-linked list
        function insertAfter(FH,x,n1)
            x.right = n1.right;
            x.left = n1;
            n1.right.left = x;
            n1.right = x;
        end %insertAfter()    
        
        % make y child of x
        function link(FH,y,x)

            % remove y from the root list of FH
            FH.disconnect(y);

            % make y a child of x, incrementing x.degree
            if isempty(x.child)
                y.right = y;
                y.left = y;
            else
                FH.insertAfter(y,x.child);
            end
            
            y.p=x;     % set pointer to y's parent
            x.child=y; % set pointer to x's child
            
            x.degree = x.degree + 1;

            % y mark set to false (0)
            y.mark=0; 

        end %link()            
    end
    
    
    % Public functions    
    methods
    
        % Initialize empty heap, and create null node
        function FH = cFibHeap()
            FH.n = 0;
            FH.minH = cFibHeapNode(0,[]);
            
            FH.nullNode = cFibHeapNode(0,[]);
            FH.nullNode.key = NaN;
            
            % raise recursion limit
            set(0,'RecursionLimit',Inf)
        end               
        
        
        
        % display current keys in root list
        % (debugging purposes only)
        function RL = rootListKeys(FH)
            
%             RL = [];            
%             assembleRL(FH.minH, FH.minH.left)
%             
%             function assembleRL(x,z)          
%                 RL = [RL x.key];
%                 if x ~= z
%                     assembleRL(x.right,z)
%                 end               
%             end
            
            % ------- experimental ------- %            
            % preallocate root list (RL) array
            RL = inf(1,FH.n);
            
            idx=1;            
            assembleRL(FH.minH, FH.minH.left)
            
            function assembleRL(x,z)          
                RL(idx) = x.key;
                idx=idx+1;
                if x ~= z
                    assembleRL(x.right,z)
                end               
            end
 
            RL = RL(RL ~= Inf);            
            % ---------------------------- %            

        end %rootList()     
        
        % display current nodes in root list
        % (debugging purposes only)
        function RL = rootList(FH)
            
%             RL = [];            
%             assembleRL(FH.minH, FH.minH.left)
%             
%             function assembleRL(x,z)          
%                 RL = [RL x];
%                 if x ~= z
%                     assembleRL(x.right,z)
%                 end               
%             end

            % ------- experimental ------- %            
            % preallocate root list (RL) array
            RL = cFibHeapNode.empty(FH.n,0);
            
            idx=1;            
            assembleRL(FH.minH, FH.minH.left)
            
            function assembleRL(x,z)          
                RL(idx) = x;
                idx=idx+1;
                if x ~= z
                    assembleRL(x.right,z)
                end               
            end
 
            RL = RL(RL ~= Inf);            
            % ---------------------------- %              
            
            
        end %rootList()         
   
      

        
        
        % *************************
        % Insert new node into heap
        % *************************
        
        % insert new node into heap
        function insert(FH,x,addinf)            
            
            insertMakeObject(cFibHeapNode(x,addinf));
            
            function insertMakeObject(x)
            
                % set node properties for new insert
                x.degree = 0;
                x.mark = 0;  
                x.p = [];
                x.child = [];
                x.left = x;
                x.right = x;

                if FH.n == 0      % if empty heap, then replace dummy minH
                    FH.minH = x;
                else              % insert into root list
                    FH.insertAfter(x,FH.minH);
                    if x.key < FH.minH.key
                        FH.minH = x; %new key is min(H)
                    end
                end

                FH.n = FH.n + 1; % increase size of heap
                
            end %insertMakeObject()

        end %insert()
        
        
        % *****************
        % Find minimum node
        % *****************
        
        % find minimum key node in heap
        function [m, addinfo] = findMin(FH)            
            
            if FH.n == 0
                m=[];
                addinfo=[];
            else
                m=FH.minH.key;
                addinfo = FH.minH.inform;
            end
            
        end %insert()
        
        
        % ************************
        % extract minimum-key node
        % ************************
        function [minKey,addinfo] = extractMin(FH)        
            
            if FH.n > 0
                
                z = FH.minH;

                % Promote all children of z to same level as z (which is
                % the root list)
                while ~isempty(z.child)
                    
                    x = z.child;                    
                    FH.disconnect(x);
                    
                    if x.left ~= x
                        x.p.child = x.left;
                    else
                        x.p.child = [];
                    end
                    
                    FH.insertAfter(x,z);                    
                    x.p = [];
                    
                end
                
                % remove z from root list
                FH.disconnect(z);
                
                % set new min-key node
                if z == z.right
                    FH.minH = [];
                else
                    FH.minH = z.right;
                    consolidate(FH)
                end
                
                FH.n = FH.n-1; % 1 fewer nodes after extraction                
            
                minKey = z.key; % return minimum key
                addinfo = z.inform; % return additional information
                
            else % when heap is empty, return empty
                minKey=[];
                addinfo=[];
            end
        
            
            function consolidate(FH)                                     
       
                
                % create auxiliary array
                A = cFibHeapNode.empty(FH.n,0);
                for i=1:FH.n
                   A(i) = FH.nullNode; 
                end
                
                % get current root list
                RL = FH.rootList;
                                
                for i=1:size(RL,2)
                    x = RL(i);
                    d = x.degree;

                    while A(d+1) ~= FH.nullNode
                        y = A(d+1);                        

                        if x.key > y.key
                            temp = x;
                            x = y;
                            y = temp;
                        end   

                        FH.link(y,x)
                        A(d+1) = FH.nullNode;
                        d=d+1;                                            
                    end

                    A(d+1)=x;
                    
                end %end for loop
                
 
                % update pointer to min(H)  
                FH.minH = FH.nullNode;
                for i=1:FH.n
                   if A(i) ~= FH.nullNode
                       if (FH.minH == FH.nullNode || ...
                           A(i).key < FH.minH.key)
                           
                            FH.minH = A(i); %new min(H)
                            
                       end
                   end
                end
               
                
            end %consolidate()           
            
        end %extractMin()
                
    end %methods
    
end

