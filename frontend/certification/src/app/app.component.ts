import {Component} from '@angular/core';
import {HttpClient} from '@angular/common/http';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  constructor(private http: HttpClient) {
  }

  title = 'certification';
  text: String = 'trolo';
  values = '';

  onKey(event: any) {
    this.values = event.target.value;
  }

  onClickMe() {
    console.log('clicked');
    this.http.get('http://localhost:8080/greeting?name=' + this.values, {responseType: 'text'}).subscribe(data => {
      console.log(data);
      this.text = data;
    })
  }
}
