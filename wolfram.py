import click
import shutil
import math
from lib import *
SHELL_WIDTH = shutil.get_terminal_size().columns


@click.command()
@click.argument('rule', required=False, type=int)
@click.option('--lines', default=100, help="the number of generations to run")
@click.option('--width', default=SHELL_WIDTH, help="The width of the environment to use")
@click.option('--align', default='centre', type=click.Choice(['left', 'centre', 'right']), help="Where to place the initial cell")
def rule(rule, lines, width, align):
	if lines >= 1000:
		raise click.BadParameter("The number of lines must not exceed 1000")
	match align:
		case 'left':
			align = Align.LEFT
		case 'centre':
			align = Align.CENTRE
		case 'right':
			align = Align.RIGHT

	# prompt user for rule if not given
	if rule == None:
		rule = get_input()
	rule_set = RuleSet(int(rule))
	# change width to be even. being even means the filled cell is always in the middle, including the buffer cell at the end
	width = math.floor((width+1) / 2) * 2
	init_line = [Cell(state=States.BLANK)]*(width)
	middle = align.index(width)
	init_line[middle] = Cell(state=States.FILL)
	for cell in init_line[:-1]:
		cell.print()
	print()
	generate(rule_set, init_line, lines - 1)

		
