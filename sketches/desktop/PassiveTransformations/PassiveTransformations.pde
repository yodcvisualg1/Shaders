import nub.core.*;
import nub.primitives.*;
import nub.processing.*;

Graph graph;
Node[] nodes;
PShader shader;

void settings() {
  size(800, 800, P3D);
}

void setup() {
  graph = new Graph(g, width, height);
  graph.setMatrixHandler(new MatrixHandler() {
      @Override
      protected void _setUniforms() {
        shader(shader);
        Scene.setUniform(shader, "nub_transform", transform());
      }
    });
  graph.setFOV(PI / 3);
  graph.fit(1);
  nodes = new Node[50];
  for (int i = 0; i < nodes.length; i++) {
    nodes[i] = new Node(graph) {
      @Override
      public void visit() {
        pushStyle();
        fill(isTracked(graph) ? 0 : 255, 0, 255);
        box(5);
        popStyle();
      }
    };
    nodes[i].randomize();
    nodes[i].setPickingThreshold(20);
  }
  //discard Processing matrices
  resetMatrix();
  shader = loadShader("frag.glsl", "vert.glsl");
}

void draw() {
  background(0);
  //resetMatrix();
  graph.preDraw();
  graph.render();
}

void mouseMoved() {
  graph.track(mouseX, mouseY, nodes);
}

void mouseDragged() {
  if (mouseButton == LEFT)
    graph.spin(new Point(pmouseX, pmouseY), new Point(mouseX, mouseY));
  else if (mouseButton == RIGHT)
    graph.translate(mouseX - pmouseX, mouseY - pmouseY);
  else
    graph.scale(mouseX - pmouseX);
}

void mouseWheel(MouseEvent event) {
  graph.scale(event.getCount() * 20);
}
