package grailsyuiexample

class Product {

    String name

    static constraints = {
      name(blank:false)
    }

  def String toString() {
    name
  }


}
