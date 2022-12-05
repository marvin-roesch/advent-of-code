import itertools
import functools
import copy
import re

with open('day5.txt') as file:
    lines = [line.rstrip() for line in file]

raw_initializer = list(itertools.takewhile(lambda line: len(line) > 0, lines))

crate_indices = [i for (i, s) in enumerate(raw_initializer[-1]) if re.match('\d', s)]
raw_crates = [[l[i] if l[i] != ' ' else None for i in crate_indices] for l in raw_initializer[:-1]]
crates = [[l[i] for l in raw_crates if l[i] is not None] for i in range(len(crate_indices))]

def parse_instruction(insn):
    parts = insn.split(' ')
    return (int(parts[1]), int(parts[3]) - 1, int(parts[5]) - 1)

instructions = [parse_instruction(line) for line in lines[len(raw_initializer)+1:]]

def build_mover(reverse):
    def apply_instruction(state, insn):
        new_state = copy.deepcopy(state)
        (count, source, target) = insn

        iteration_order = -1 if reverse else 1

        moved_crates = state[source][:count]
        new_state[source] = state[source][count:]
        new_state[target] = [*moved_crates[::iteration_order], *state[target]]

        return new_state

    return apply_instruction

part1 = functools.reduce(build_mover(True), instructions, crates)
print('Part 1:', ''.join(stack[0] for stack in part1))

part2 = functools.reduce(build_mover(False), instructions, crates)
print('Part 2:', ''.join(stack[0] for stack in part2))
