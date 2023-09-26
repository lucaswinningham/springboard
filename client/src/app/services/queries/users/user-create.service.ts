import { Injectable } from '@angular/core';

import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

import { ApiService } from '@services/utils/api.service';

import { User } from '@models/user.model';

const document = `
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

  create(variables: { name: string, email: string }): Observable<User> {
    return this.api.mutate({ document, variables }).pipe(
      map(response => new User(response.data.userCreate))
    );
  }
}
