import { Injectable } from '@angular/core';

import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

import { ApolloQueryResult } from 'apollo-client';

import { ApiService } from '@services/utils/api.service';

import { UserAuth } from '@app/models/user/user-auth.model';

export const document = `
  mutation userSignup($name: String! $email: String!) {
    userSignup(name: $name email: $email) {
      salt nonce ckey civ
    }
  }
`;

@Injectable({
  providedIn: 'root'
})
export class UserSignupService {
  constructor(private api: ApiService) { }

  public signup(variables: { name: string, email: string }): Observable<UserAuth> {
    return this.api.mutate({ document, variables }).pipe(
      map(queryResult => new UserAuth(queryResult.data.userSignup))
    );
  }
}
