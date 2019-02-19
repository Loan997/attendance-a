
1
2
3
4
5
6
7
8
import { Controller } from "stimulus"
 
export default class extends Controller {
　　greet() {
　　　　document.text.value = "Hello, stimulus!";
 
　　}
}