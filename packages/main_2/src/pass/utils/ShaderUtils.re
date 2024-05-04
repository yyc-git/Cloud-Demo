let buildPath = [%bs.raw
  (. src) => {|
  let path = require("path")
  return path.join(__dirname, "../../../../../", src)
  |}
];