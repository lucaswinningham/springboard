import { Component, OnInit } from '@angular/core';

import { UserSignupService } from '@app/services/queries/user-signup.service';
import { tap } from 'rxjs/operators';

import { UserSignup } from '@app/models/user/user-signup.model';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss']
})
export class SignupComponent implements OnInit {
  userSignup: UserSignup = new UserSignup();

  constructor(private userSignupService: UserSignupService) { }

  ngOnInit() { }

  submit() {
    const vars = { name: 'lucaswinningham', email: 'lucas.winningham@gmail.com', password: '' };
    this.userSignup = new UserSignup(vars);
    this.userSignupService.signup(this.userSignup).pipe(
      tap(userAuth => console.log({ userAuth }))
    ).subscribe();
  }
}