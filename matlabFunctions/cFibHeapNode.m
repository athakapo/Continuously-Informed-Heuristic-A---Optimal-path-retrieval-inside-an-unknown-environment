classdef cFibHeapNode < handle
    %CFIBHEAPNODE Fibonacci Heap Node
    %   Nodes for use in Fibonacci min-heap 
    %
    %   (Based on algorithms from Cormen, Leiserson, Rivest, and Stein.
    %     "Introduction to Algorithms". 2nd Ed. McGraw-Hill (2007).)

    
        
    % Private data
    properties
        
        % Key of node
        key
        
        % Additional Information
        inform 
        
        % Number of children in child list of node
        degree
        
        % Indicates whether node has lost child since last time node was
        %  made the child of another node
        mark        
        
        % Pointers
        p           % parent
        child       % any child
        left        % left sibling
        right       % right sibling
    end
         
    methods
    
        % Initialize class instance
        function ND = cFibHeapNode(InitialKey,PermInf)
            ND.key = InitialKey;     
            ND.inform = PermInf;
            ND.left = ND;
            ND.right = ND;
            ND.mark = 0;
            ND.degree = 0;
            ND.p = [];
            ND.child = [];
        end       

        % display list of node and all siblings
        function siblingsList(ND)
            
            SL = [];
            assembleSL(ND, ND.left)
            
            function assembleSL(x,z)
               SL = [SL x.key];
               if x ~= z
                   assembleSL(x.right,z)
               end
            end
            
            SL %#ok<NOPRT>
        end %siblingsList()
        
    end %methods
    
end

