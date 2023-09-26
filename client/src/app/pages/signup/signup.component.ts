import { Component, OnInit } from '@angular/core';

import { UserSignupService } from '@app/services/queries/users/user-signup.service';
import { tap } from 'rxjs/operators';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss']
})
export class SignupComponent implements OnInit {
  // userSignup: UserSignup = new UserSignup();

  // constructor(private userSignupService: UserSignupService) { }

  ngOnInit() { }

  // submit() {
  //   const vars = { name: 'lucaswinningham', email: 'lucas.winningham@gmail.com', password: '' };
  //   this.userSignup = new UserSignup(vars);
  //   this.userSignupService.signup(this.userSignup).pipe(
  //     tap(userAuth => console.log({ userAuth }))
  //   ).subscribe();
  // }
}
