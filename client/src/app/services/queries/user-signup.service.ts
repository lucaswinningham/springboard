import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

import { ApiService } from '@services/utils/api.service';

import { UserAuth } from '@app/models/user/user-auth.model';

const document = `
  mutation {
    userSignup(
      $name: String
      $email: String
    ) {
      salt
      nonce
      ckey
      civ
    }
  }
`;
// `
// query getDog($name: String) {
//   dog(name: $name) {
//     id
//     name
//     breedType
//   }
// }
// `

@Injectable({
  providedIn: 'root'
})
export class UserSignupService {
  constructor(private api: ApiService) { }

  public signup(variables: { name: string, email: string }): Observable<UserAuth> {
    console.log( { variables: variables } );
    return this.api.query({ document, variables }).pipe(
      map(queryResult => new UserAuth(queryResult))
    );
  }
}
