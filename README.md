# Continuously Informed Heuristic A* - Optimal path retrieval inside an unknown environment #

## Main objective

The developed algorithm ensures the optimal path retrieval between **two given locations** by exploring the **minimum portion of the environment**.

*The term "minimum portion of the environment" is defined as the number of cells that have to be visited by the explorer (robot-scouter) to acquire information about the state (obstacle or free space) of their neighbors.*

## Example

![example_image](http://kapoutsis.info/wp-content/uploads/2020/12/cia_star_example.png)

## Video demonstration

[![Video demonstration](http://kapoutsis.info/wp-content/uploads/2020/12/cia_star_thumbnail.png)](https://www.youtube.com/watch?v=ct_mnyqIjUU)

## Optimality guarantee

In principle, the optimal path can be guaranteed by a searching agent that adopts an A*-like decision mechanism. The proposed CIA* inherits the A* optimality and efficiency guarantees, while at the same time exploits the learnt formation of the obstacles, to on-line revise the heuristic evaluation of the candidate states. For more information please check [this paper](http://kapoutsis.info/wp-content/uploads/2017/10/ssrr2017Final.pdf).

## Cite as: 

```
@article{kapoutsis2017Continuously,
title={Continuously Informed Heuristic A* – Optimal Path Retrieval Inside an Unknown Environment},
author={Kapoutsis, A Ch and Malliou, C M and Chatzichristofis, S A and Kosmatopoulos, E B},
booktitle={2017 IEEE International Symposium on Safety, Security and Rescue Robotics (SSRR)},
pages={216–222},
year={2017},
publisher={IEEE}
}
```
