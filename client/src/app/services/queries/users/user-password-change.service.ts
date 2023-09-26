import { Injectable } from '@angular/core';

import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

import { ApiService } from '@services/utils/api.service';
import { CipherService } from '@services/auth/users/cipher.service';
import { HashService } from '@services/auth/users/hash.service';
import { NonceService } from '@services/auth/users/nonce.service';

import { User } from '@models/user.model';

const document = `
  mutation userPasswordChange($email: String! $oldPassword: String $newPassword: String!) {
    userPasswordChange(email: $email oldPassword: $oldPassword newPassword: $newPassword) {
      jwt
    }
  }
`;

@Injectable({
  providedIn: 'root'
})
export class UserPasswordChangeService {
  constructor(private api: ApiService ) { }

  changePassword(args: {
    user: User, email: string, oldPlainPassword: string, newPlainPassword: string
  }): Observable<User> {
    const { user, email, oldPlainPassword, newPlainPassword } = args;
    const { salt, nonce } = user;

    const variables = {
      email,
      oldPassword: this.generateOldPassword({ user, nonce, salt, oldPlainPassword }),
      newPassword: this.generateNewPassword({ user, nonce, salt, newPlainPassword }),
    };

    return this.api.mutate({ document, variables }).pipe(
      map(response => new User(response.data.userPasswordChange))
    );
  }

  private generateOldPassword(args: {
    user: User, nonce: string, salt: string, oldPlainPassword: string
  }): string {
    const { user, nonce, salt, oldPlainPassword } = args;
    const { ckey, civ } = user;

    if (oldPlainPassword) {
      const hashed = HashService.hashSecret({ secret: oldPlainPassword, salt });
      const secret = [nonce, hashed, this.newNonce()].join('||');
      return CipherService.encrypt({ secret, ckey, civ });
    }
  }

  private generateNewPassword(args: {
    user: User, nonce: string, salt: string, newPlainPassword: string
  }): string {
    const { user, nonce, salt, newPlainPassword } = args;
    const { ckey, civ } = user;

    const hashed = HashService.hashSecret({ secret: newPlainPassword, salt });
    const secret = [nonce, hashed, this.newNonce()].join('||');
      console.log({ newmessage: CipherService.encrypt({ secret, ckey, civ }) })
      return CipherService.encrypt({ secret, ckey, civ });
  }

  private newNonce(): string {
    return NonceService.newNonce({ length: 32 });
  }
}
