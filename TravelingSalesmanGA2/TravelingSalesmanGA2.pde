final int n_cities = 1000;
final int population_size = 100;
final float mutation_rate = 0.5; 

class City {
  float x;
  float y;

  City(float x_, float y_) {
    x = x_;
    y = y_;
  }

  void draw() {
    fill(0, 0, 127, 200);
    ellipse(x, y, 4, 4);
  }
}

class Path {
  // Order of cities to visit
  int[] order;

  Path() {
    order = new int[n_cities];
    for(int i = 0; i < n_cities; i++) {
      order[i] = i;
    }
  }

  // Randomize path
  void randomize() {
    for(int i = 0; i < n_cities; i++) {
      int j = (int)random(0, n_cities);
      int aux = order[i];
      order[i] = order[j];
      order[j] = aux;
    }
  }

  // Invert a random segment of the path
  void mutate1(){
  }

  // Change the place of 2 cities
  void mutate2(){
  }

  float fitness() {
    float x1, y1, x2, y2, total = 0;
    for(int i = 0; i < n_cities; i++) {
      x1 = cities[order[i]].x;
      y1 = cities[order[i]].y;
      x2 = cities[order[(i+1)%n_cities]].x;
      y2 = cities[order[(i+1)%n_cities]].y;
      total += dist(x1, y1, x2, y2);
    }
    return -total;
  }

  void draw()
  {
    float x1, y1, x2, y2;
    stroke(0, 127, 0);
    for(int i = 0; i < n_cities; i++) {
      x1 = cities[order[i]].x;
      y1 = cities[order[i]].y;
      x2 = cities[order[(i+1)%n_cities]].x;
      y2 = cities[order[(i+1)%n_cities]].y;
      line(x1, y1, x2, y2);
    }
  }

  void copy(Path p) {
    for(int i = 0; i < n_cities; i++) {
      order[i] = p.order[i];
    }
  }

  // Very dumb cross, just select the fittest
  void cross(Path x, Path y){
    if(x.fitness() > y.fitness())
      copy(x);
    else
      copy(y);
  }
}

City[] cities;
Path[] current_population;
Path[] next_population;

void setup()
{
  size(640, 480);
  cities = new City[n_cities];
  current_population = new Path[population_size];
  next_population = new Path[population_size];

  for(int i = 0; i < n_cities; i++) {
    cities[i] = new City(random(0, width), random(0, height));
  }

  for(int i = 0; i < population_size; i++) {
    next_population[i] = new Path();
    current_population[i] = new Path();
    current_population[i].randomize();
  }
}

Path select()
{
  int i = (int)random(0, population_size);
  int j = (int)random(0, population_size);

  if(current_population[i].fitness() >current_population[j].fitness())
    return current_population[i];

  return current_population[j];
}

void draw_best_path()
{
  int best = 0;
  for(int i = 1; i < population_size; i++)
    if(current_population[best].fitness() < current_population[i].fitness())
      best = i;

  current_population[best].draw();
}

void draw()
{
  background(127);
  draw_cities();
  draw_best_path();

  for(int j = 0; j < 100; j++) {
    for(int i = 0; i < population_size; i++) {
      Path x = select();
      Path y = select();
      next_population[i].cross(x, y);
      if(random(0, 1.0) <= mutation_rate)
        next_population[i].mutate1();
    }
  
    for(int i = 0; i < population_size; i++) {
      current_population[i].copy(next_population[i]);
    }
  }

}

void draw_cities()
{
  stroke(0, 0, 0);
  for(int i = 0; i < n_cities; i++)
    cities[i].draw();
}