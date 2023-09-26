import { Injectable } from '@angular/core';

import * as crypto from 'crypto-js';

@Injectable({
  providedIn: 'root'
})
export class CipherService {
  static encrypt(args: { secret: string, ckey: string, civ: string }): string {
    const { secret, ckey, civ } = args;
    return crypto.AES.encrypt(secret, ckey, { iv: civ }).toString();
  }

  static decrypt(args: { secret: string, ckey: string, civ: string }): string {
    const { secret, ckey, civ } = args;
    return crypto.AES.decrypt(secret, ckey, { iv: civ }).toString(crypto.enc.Utf8);
  }
}
