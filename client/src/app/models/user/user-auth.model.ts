import { Base } from '@models/base.model';

export class UserAuth extends Base {
  readonly salt: string;
  readonly nonce: string;
  readonly ckey: string;
  readonly civ: string;

  protected afterConstruction(): void {
    const { salt, nonce, ckey, civ } = this.queryResult.data.userAuth;
    Object.assign(this, { salt, nonce, ckey, civ });
  }
}
