import { Injectable } from '@angular/core';

import { Observable } from 'rxjs';
import { map, mergeMap } from 'rxjs/operators';

import { ApiService } from '@services/utils/api.service';
import { UserCreateService } from '@services/queries/users/user-create.service';
import { UserPasswordChangeService } from '@services/queries/users/user-password-change.service';

import { Jwt } from '@models/jwt.model';

@Injectable({
  providedIn: 'root'
})
export class UserSignupService {
  constructor(
    private userCreateService: UserCreateService,
    private userPasswordChangeService: UserPasswordChangeService
  ) { }

  public signup(args: { name: string, email: string, password: string }): Observable<Jwt> {
    return;
    // return this.userCreateService.create({ name, email }).pipe(
    //   mergeMap(userAuth => {
    //     return this.userPasswordChangeService.changePassword({ email, oldPassword, newPassword });
    //   })
    // );
  }
}
