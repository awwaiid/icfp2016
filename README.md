# icfp2016 - Errol's Robots - Perl 6

This year we worked on reverse-engineering folded origami! Our solution is
implemented in Perl 6, calling out to some Perl 5 libraries. We got to the
point where we could begin doing hill-climbing, randomly folding origami in an
attempt to get closer to the target problem's silhouette.

Perl 6 shined for getting the problems parsed and built out into nice object
graphs. The tooling was OK, but needs some work -- we used LREP like you would
use binding.pry in Ruby. We should have spent more time early on finding some
libraries to manipulate polygons ... much time was spent implementing things
from scratch only to replace them with an off the shelf library later.

One particularly fun thing is Perl 6's built-in default of using Rational
numbers, which made keeping accurate values easy. One particularly annoying
thing is that we never know if we should .list or .flat or .Array things, so we
just do them at random.

We just barely reached our goal of automatic problem solving using hill
climbing. This was about 1-2 days behind the schedule initially hoped for!

## Team Info
* Brock Wilcox
* Mike Burns
* Jason Woys

Contest Server: http://2016sv.icfpcontest.org/
Team ID: 31
Password: zXz99ySdzWSn
API Key: 31-99e01d42cda065257f188de236e944ef

## TASKS
* [X] Render problems
* [X] Render solutions
* [X] Fold polygons (split them)
* [X] Track polygon source / dest
* [X] Calculate overlap from an Origami to a Problem
* [X] Output a Solution from an Origami
* [X] Simple fold for an Origami
* [ ] Complex fold for an Origami
* [X] Random fold
* [ ] Random hill climb
* [ ] Simulated annealing
* [ ] Other search -- GA?
* [X] Submit trivial solutions
* [X] Submit less-trivial solutions
* [X] Submit hand-made solutions
* [X] Submit hand-made problems

