import math
from enum import Enum, auto
from typing import List
import itertools
import click

class States(Enum):
	BLANK = auto()
	FILL = auto()

class Align(Enum):
	LEFT = auto()
	CENTRE = auto()
	RIGHT = auto()

	def index(self, width: int) -> int:
		"""returns an index based on the alignment and page-width"""
		match self:
			case Align.LEFT:
				return 0
			case Align.CENTRE:
				return math.floor((width-1) / 2)
			case Align.RIGHT:
				return width -1

class RuleSet():
	def __init__(self, rule_no: int):
		# iterate through all the rule numbers, and check against the rule number
		self.rules = {}
		bin_rule = format(rule_no, '08b')
		# print(bin_rule)
		for i in range(8):
			rule_active = bin_rule[-i-1] == '1'
			# print(rule_active)
			self.rules[i] = rule_active			
		# print("rule set:", self.rules)

class Cell():
	def __init__(self, state=States.BLANK):
		self.state = state

	def from_bool(state: bool):
		return Cell(state=(States.FILL if state else States.BLANK))

	def int(self) -> int:
		match self.state:
			case States.BLANK:
				return 0
			case States.FILL:
				return 1
		
		
	def print(self):
		match self.state:
			case States.BLANK:
				click.echo(' ', nl=False)
			case States.FILL:
				click.echo('█', nl=False)

def get_kernel(i, prev_line) -> int:
	kernel = []
	for part in [prev_line[i-1], prev_line[i], prev_line[i+1]]:
		kernel.append(str(part.int()))
	# print(kernel)
	kernel = int(''.join(kernel), 2)
	return kernel
	

def generate(rule_set: RuleSet, prev_line: List[Cell], lines_remaining: int):
	# print("NEW_LINE____>")
	if lines_remaining <= 0:
		return
	# print("previous line:", [cell.int() for cell in prev_line])
	new_line = [Cell()]*len(prev_line)

	for i, cell in enumerate(new_line[:-1]):
		variant = get_kernel(i, prev_line)
		# print("kernel:", variant)
		new_val = rule_set.rules[variant]
		# print("computed to:", new_val)
		
		# print(new_val)
		new_line[i] = Cell.from_bool(state=new_val)

	for cell in new_line[:-1]:		
		cell.print()

	click.echo("")
	return generate(rule_set, new_line, lines_remaining - 1)

def get_input() -> str:
	return click.prompt('Please enter a rule number to be used as the rule set.\n', default=1, type=int)

'''
	kernel variants:
		- 7: 111 / [x][x][x]
		- 6: 110 / [x][x][ ]
		- 5: 101 / [x][ ][x]
		- 4: 100 / [x][ ][ ]
		- 3: 011 / [ ][x][x]
		- 2: 010 / [ ][x][ ]
		- 1: 001 / [ ][ ][x]
		- 0: 000 / [ ][ ][ ]

	so, rule 1 = 0b0000001, with each bit acting as a true or false response to
	each of the kernel variants. For our rule 1, this means that only [ ][ ][ ]
	is a winning generation



	
'''
