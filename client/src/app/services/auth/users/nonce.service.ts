import { Injectable } from '@angular/core';

import randomString from 'random-string';
import { CipherService } from './cipher.service';

const ckey = 'r/7G4sNX+OpZwQ4LT/1/yg==\n';
const civ = 'Qh0mpEcb9waVAVPOeJX71Q==\n';

@Injectable({
  providedIn: 'root'
})
export class NonceService {
  static newNonce(args: { length: number }): string {
    const { length } = args;
    const secret = randomString({ length });
    return CipherService.encrypt({ secret, ckey, civ });
  }
}
