package grailsyuiexample

class ContactType {

    String name

    static constraints = {
      name(blank:false)
    }

  def String toString() {
    name
  }


}
