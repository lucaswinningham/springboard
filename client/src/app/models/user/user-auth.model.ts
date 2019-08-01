export class UserAuth {
  readonly salt: string;
  readonly nonce: string;
  readonly ckey: string;
  readonly civ: string;

  constructor(args: { salt: string, nonce: string, ckey: string, civ: string }) {
    Object.assign(this, args);
  }
}
