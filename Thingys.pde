//void readThingys(String file_name) {
//  String[] lines = loadStrings(file_name);
//  ArrayList<Thing> tempThingys = new ArrayList<Thing>();

//  for (String line : lines)
//    tempThingys.add(convertThingys(line));
    
//  thingys = new Thing[tempThingys.size()];
//  thingys = tempThingys.toArray(thingys);
//}

//Thing convertThingys(String line) {
//  String[] words = line.split(" ");

//  String keyword;
//  String[] args;

//  keyword = words[0];

//  args = new String[words.length];
//  for (int i = 1; i < words.length; i++)
//    args[i - 1] = words[i];
    
//  return parseThingy(keyword, args);
//}

//Thing parseThingy(String keyword, String... args) {
//  Thing out = null;

//  switch(keyword) {
//  case "Rectangle":
//    out = new Rectangle (
//      new PVector(float(args[0]), float(args[1])), 
//      new PVector(float(args[2]), float(args[3])), 
//      new Colo(float(args[4]), float(args[5]), float(args[6]), float(args[7]))
//      );
//    break;
//  case "Ellipse":
//    out = new Ellipse (
//      new PVector(float(args[0]), float(args[1])), 
//      new PVector(float(args[2]), float(args[3])), 
//      new Color(float(args[4]), float(args[5]), float(args[6]), float(args[7]))
//      );
//    break;
//  case "Polygon":
//    int polyLen = (args.length - 4) / 2;
//    ArrayList<PVector> verticesBuff = new ArrayList<PVector>();
    
//    for (int i = 0; i < polyLen; i++) {
//      verticesBuff.add(new PVector(float(args[i*2 + 4]), float(args[i*2 + 5])));
//    }
    
//    PVector[] vertices = new PVector[verticesBuff.size()];
//    vertices = verticesBuff.toArray(vertices);
    
//    out = new Polygon (
//      new Color(float(args[0]), float(args[1]), float(args[2]), float(args[3])),
//      vertices
//      );
//    break;
//  case "#":
//    out = new Polygon(new Color(0, 0, 0));
//    break;
//  }
  
//  return out;
//}
Thing[] thingys = new Thing[] {
    new Rectangle(new PVector(500, 400), new PVector(30, 30), new Material(255, 255, 255)), 
    new Ellipse(new PVector(400, 300), new PVector(69, 50), new Material(0, 255, 0)), 
    new Rectangle(new PVector(800, 600), new PVector(100, 150), new Material(0, 255, 0)), 
    //new Thing(new PVector(0, 0), new PVector(1000, 800), new Color(255, 255, 255, 14))
    new Polygon(new Material(0, 255, 100, 69), new PVector(0, 700), new PVector(50, 710), new PVector(14, 760), new PVector(100, 769)),
    ////Bounderies
    //new Polygon(new Material(255, 255, 255), new PVector(1, 1), new PVector(1, height-1)),
    //new Polygon(new Material(255, 255, 255), new PVector(1, height-1), new PVector(width-1, height-1)),
    //new Polygon(new Material(255, 255, 255), new PVector(width-1, height-1), new PVector(width-1, 1)),
    //new Polygon(new Material(255, 255, 255), new PVector(width-1, 1), new PVector(1, 1)),
  };
