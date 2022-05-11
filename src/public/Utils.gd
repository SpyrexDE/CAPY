extends Node

func completeInt(input: float) -> float:
    if input > 0:
        return ceil(input)
    else:
        return floor(input)
