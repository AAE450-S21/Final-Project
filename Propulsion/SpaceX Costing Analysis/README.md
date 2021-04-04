# AAE 450 Spring 2021 SpaceX Starship Costing Analysis

## Overview

A collection of Excel documents to estimate the cost of a single SpaceX Starship flight to LEO. Two files:

- Baseline: the baseline we selected for Project NextStep with very ambitious numbers, somewhere between current state and Musk's quotes.

- Musk Quotes: an analysis of Musk's quotes about Starship. As shown in the file, this would make SpaceX the world's biggest company by a factor of 6.

Both files have inputs labeled. Excel's solver must be used to optimize the launch cost for the target NPV and free cash flow.

## Brief Methodology

These files take inputs to estimate cash flow every year at SpaceX: launches, launch cost, sale price of a launch, etc. Development costs are also included. Once the next ten years of cash flow are estimated, the Net Present Value is calculated by summing all cash flows converted to present value.

Present value of cash flow:
$$
\text{Present Value} = \frac{\text{Future Value}}{(1+\text{Discount Rate})^\text{Years in Future}}
$$

Net present value of the program:
$$
\text{NPV} = \sum_{y=0}^{10} \text{PV} = \sum_{y=0}^{10} \frac{\text{FV(y)}}{(1+r)^y}
$$

Lastly, SpaceX is also enforced to have a minimum percentage of revenue be free cash flow.

## Authors

- Noah Stockwell
