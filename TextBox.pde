class TextBox{
    ArrayList<String> lines = new ArrayList<>();
    int locationX;
    int locationY;
    int spacing;
    boolean vertical = true;
    TextBox(int x, int y, int spacing){ locationX = x; locationY = y; this.spacing = spacing;}
    
    void addText(String text){ lines.add(text); }

    void draw(){
        int offsetX = locationX;
        int offsetY = locationY;
        for(String line : lines){
            text(line, offsetX, offsetY);
            if(vertical) { offsetY += spacing; }
            else { offsetX += spacing; }
        }
    }
}