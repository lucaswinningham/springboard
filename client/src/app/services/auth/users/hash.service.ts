import { Injectable } from '@angular/core';

import * as bcryptjs from 'bcryptjs';

@Injectable({
  providedIn: 'root'
})
export class HashService {
  static hashSecret(args: { secret: string, salt: string }): string {
    const { secret, salt } = args;
    return bcryptjs.hashSync(secret, salt);
  }
}
