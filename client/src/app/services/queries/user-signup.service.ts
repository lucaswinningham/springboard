import { Injectable } from '@angular/core';

import { Observable } from 'rxjs';
import { map, mergeMap } from 'rxjs/operators';

import { ApiService } from '@services/utils/api.service';

import { UserAuth } from '@app/models/user/user-auth.model';

export const userSignupDocument = `
  mutation userSignup($name: String! $email: String!) {
    userSignup(name: $name email: $email) {
      salt nonce ckey civ
    }
  }
`;

export const userPasswordChangeDocument = `
  mutation userPasswordChange($email: String! $prevPassword: String! $nextPassword: String!) {
    userPasswordChange(email: $email prevPassword: $prevPassword nextPassword: $nextPassword) {
      jwt
    }
  }
`;

@Injectable({
  providedIn: 'root'
})
export class UserSignupService {
  constructor(private api: ApiService) { }

  public signup(args: { name: string, email: string, password: string }): Observable<UserAuth> {
    const { name, email, password } = args

    const userSignupVariables = { name, email };
    const userSignup$ = this.api.mutate(
      { document: userSignupDocument, variables: userSignupVariables }
    ).pipe(
      map(queryResult => new UserAuth(queryResult.data.userSignup))
    );

    const userPasswordChangeVariables = { email, prevPassword: null, nextPassword: password };
    const userPasswordChange$ = this.api.mutate(
      { document: userPasswordChangeDocument, variables: userPasswordChangeVariables }
    ).pipe(
      map(queryResult => new Jwt(queryResult.data.jwt))
    )

    return userSignup$.pipe(
      mergeMap(userAuth => {
        const nextPassword = this.passwordService.doSomething({ userAuth, password });
        return userPasswordChange$;
      })
    );
  }
}
