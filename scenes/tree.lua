require('nodes')

local branch = {
  intersect,
  {linear, {0, 0, .5}, {lhp}},
  {linear, {-.1, 0, .22}, {lhp}},
  {linear, {.1, 0,  .77}, {lhp}},
}

local tree = {
  memo, .02,
  {
    join,
    branch,
    {
      linear,
      {0, .3, .05, .8},
      branch
    },
    {
      linear,
      {0, .55, -.1, .7},
      branch
    },
    {
      linear,
      {0, .6, .15, .5},
      branch
    },

  }
}

tree[3][3][3] = tree
tree[3][4][3] = tree
tree[3][5][3] = tree

return {
  linear,
  {0, -.9, 0, 1},
  {
    join,
    tree,
    {tint, {0.71, 0.30, 0.11}, {join, {linear, {0, 0, .5}, {lhp}}, {lhp}}},
  }
}