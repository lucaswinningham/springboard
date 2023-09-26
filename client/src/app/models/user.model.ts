import { Jwt } from '@models/jwt.model';

export class User {
  readonly name: string;
  readonly salt: string;
  readonly nonce: string;
  readonly ckey: string;
  readonly civ: string;
  readonly jwt: Jwt;

  constructor(
    args: { name: string, salt: string, nonce: string, ckey: string, civ: string, jwt: Jwt }
  ) {
    Object.assign(this, args);
  }
}
