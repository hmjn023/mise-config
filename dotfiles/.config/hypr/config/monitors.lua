-- The empty output matches the old `monitor=,highres,auto,1` rule and lets
-- both the ThinkPad and Dell use their preferred high-resolution mode.
hl.monitor({
    output = "",
    mode = "highres",
    position = "auto",
    scale = 1,
})
