import { Injectable } from '@angular/core';

import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

import { ApiService } from '@services/utils/api.service';

import { UserAuth } from '@models/user/user-auth.model';

export const document = `
  mutation userCreate($name: String! $email: String!) {
    userCreate(name: $name email: $email) {
      salt nonce ckey civ
    }
  }
`;

@Injectable({
  providedIn: 'root'
})
export class UserCreateService {
  constructor(private api: ApiService) { }

  public create(variables: { name: string, email: string }): Observable<UserAuth> {
    return this.api.mutate({ document, variables }).pipe(
      map(response => new UserAuth(response.data.userCreate))
    );
  }
}
