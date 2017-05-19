//
//  ViewController.swift
//  Maze
//
//  Created by Alaattin Bedir on 24.02.2017.
//  Copyright © 2017 Alaattin Bedir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var cheeseFound = false
    var totalCheeseCount = 0
    var cheeseCount = 0
    
    func printSolution(sol:[[Int]]) -> Int{
        var step:Int = 0
        for var x in 0..<sol.count {
            for var y in 0..<sol[x].count {
                
                if sol[x][y] >= 1 {
                    step += sol[x][y]
                }else{
                    continue
                }
            }
        }
        return step;
    }
    
    func totalCheese(sol:[[Int]]) -> Int{
        var step:Int = 0
        for var x in 0..<sol.count {
            for var y in 0..<sol[x].count {
                
                if sol[x][y] == 2 {
                    step+=1
                }else{
                    continue
                }
            }
        }
        return step;
    }
    
    func findCheese(maze:[[Int]]) -> (x:Int,y:Int){
        var step:Int = 0
        for var x in 0..<maze.count {
            for var y in 0..<maze[x].count {
                
                if maze[x][y] == 2 {
                    return (x,y)
                }else{
                    continue
                }
            }
        }
        return (0,0);
    }
    
    
    func isSafe(maze:[[Int]], x: Int, y: Int) -> Bool {
        
        return (x >= 0 && x < 3 && y >= 0 &&
            y < 3 && (maze[x][y] == 0 || maze[x][y] == 2));
    }
    
    // Recursive calls to solve maze
    func solveMaze(maze:[[Int]], x:Int, y:Int, sol:[[Int]] ,_ cheeseLocation:(x:Int,y:Int), _ jeryLocation:(x:Int,y:Int), direction:String) -> (Bool, [[Int]]) {
        
        var sol = sol
        var maze = maze
        var cheeseLocation = cheeseLocation
        
        if (x == jeryLocation.x && y == jeryLocation.y && cheeseCount == totalCheeseCount)
        {
            return (true, sol);
        }
        
        // Check if maze[x][y] is valid
        if (isSafe(maze: maze, x: x, y: y) == true)
        {
            // mark x,y as solution
            if maze[x][y] == 2 {
                // mark that cheese found
                maze[x][y] = 0
                
                //cheese found get location for next cheese
                cheeseLocation = findCheese(maze: maze)
                
                // increase founded cheese
                cheeseCount += 1
            }
            sol[x][y] += 1;
            
            if cheeseCount == totalCheeseCount {
                // if jery down direction
                if jeryLocation.x > x {
                    // Move to down direction
                    let (succes, solution) = solveMaze(maze: maze, x: x + 1, y: y, sol: sol, cheeseLocation, jeryLocation, direction: "down")
                    if succes {
                        return (true,solution);
                    }
                }
                
                // if jery left direction
                if jeryLocation.y < y {
                    // Move to left direction
                    let (succes, solution) = solveMaze(maze: maze, x: x, y: y - 1, sol: sol, cheeseLocation, jeryLocation, direction: "left")
                    if succes {
                        return (true,solution);
                    }
                }
                
                // if jery right direction
                if jeryLocation.y > y {
                    // Move to right direction
                    let (succes, solution) = solveMaze(maze: maze, x: x, y: y + 1, sol: sol, cheeseLocation, jeryLocation, direction: "right")
                    if succes {
                        return (true,solution);
                    }
                }
                
                // if jery up direction
                if jeryLocation.x < x {
                    // Move to up direction
                    let (succes, solution) = solveMaze(maze: maze, x: x - 1, y: y, sol: sol, cheeseLocation, jeryLocation, direction: "up")
                    if succes {
                        return (true,solution);
                    }
                }
            }
            
            if cheeseLocation.y > y {
                // Move to right direction
                if  direction != "left"  {
                    let (succes, solution) = solveMaze(maze: maze, x: x, y: y + 1, sol: sol, cheeseLocation, jeryLocation, direction: "right")
                    if succes {
                        return (true,solution);
                    }
                }
            }
            
            if cheeseLocation.x > x {
                // Move to down direction
                if  direction != "up"  {
                    let (succes, solution) = solveMaze(maze: maze, x: x + 1, y: y, sol: sol, cheeseLocation, jeryLocation, direction: "down")
                    if succes {
                        return (true,solution);
                    }
                }
            }
            
            if cheeseLocation.y < y {
                // Move to left direction
                if  direction != "right" {
                    let (succes, solution) = solveMaze(maze: maze, x: x, y: y - 1, sol: sol, cheeseLocation, jeryLocation, direction: "left")
                    if succes {
                        return (true,solution);
                    }
                }
            }
            
            if cheeseLocation.x < x {
                // Move to up direction
                if  direction != "down"  {
                    let (succes, solution) = solveMaze(maze: maze, x: x - 1, y: y, sol: sol, cheeseLocation, jeryLocation,direction: "up")
                    if succes {
                        return (true,solution);
                    }
                }
            }

            
            //If none of the above movements work then back and unmark solution
            sol[x][y] -= 1
            return (false,sol)
        }
 
        return (false,sol)
    }
    
    // x,y Jery position
    func minMoves(maze: [[Int]], x: Int, y: Int) -> Int {
        //path 0
        //block 1
        //cheese 2
        
        //find cheeses
        let sol: [[Int]] = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
        let cheeseLocation:(x:Int,y:Int) = findCheese(maze: maze)
        totalCheeseCount = totalCheese(sol: maze)
        let jeryLocation:(Int,Int) = (x,y)
        var stepCount = 0
        // start to get the closest cheese
        if cheeseLocation.x == 0 || cheeseLocation.y > 0{
            let (succes, solution) = solveMaze(maze: maze, x: 0, y: 0, sol: sol, cheeseLocation, jeryLocation, direction: "down")
            if (succes == false)
            {
                print("Solution doesn't exist");
                return -1;
            }
            
            stepCount = printSolution(sol: solution)
        }else {
            let (succes, solution) = solveMaze(maze: maze, x: 0, y: 0, sol: sol, cheeseLocation, jeryLocation, direction: "left")
            if (succes == false)
            {
                print("Solution doesn't exist");
                return -1;
            }
            
            stepCount = printSolution(sol: solution)
        }
        
        print("Total Steps: \(stepCount)")
        
        return stepCount
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Sample inputs fo Jery Postion 1,1
//        let maze: [[Int]] = [[0, 2, 0], [0, 0, 1], [1, 1, 1]]
//        let maze: [[Int]] = [[0, 1, 0], [1, 0, 1], [0, 2, 2]]
//        let maze: [[Int]] = [[0, 0, 0], [2, 2, 0], [1, 0, 0]]
//        _ = minMoves(maze: maze, x: 1, y: 1)
        
        //Sample inputs fo Jery Postion 2,2
//        let maze: [[Int]] = [[0, 2, 1], [1, 0, 2], [1, 0, 0]]
        let maze: [[Int]] = [[0, 2, 1], [1, 0, 2], [0, 2, 0]]
        _ = minMoves(maze: maze, x: 2, y: 2)
        
        
        return;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

