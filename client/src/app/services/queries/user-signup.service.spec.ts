import { TestBed } from '@angular/core/testing';
import { of } from 'rxjs';

import { UserSignupService, document } from './user-signup.service';

import { ApiService } from '../utils/api.service';

describe('UserSignupService', () => {
  let service: UserSignupService;
  let api: jasmine.SpyObj<ApiService>;

  beforeEach(() => {
    const apiSpy = jasmine.createSpyObj('ApiService', ['mutate']);
    TestBed.configureTestingModule({ providers: [{ provide: ApiService, useValue: apiSpy }] });

    api = TestBed.get(ApiService);
    service = TestBed.get(UserSignupService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('+signup', () => {
    let name, email, salt, nonce, ckey, civ;

    beforeEach(() => {
      name = 'username';
      email = 'user@example.com';

      salt = '$2a$10$pb5oHdE7ylzfVBIuqyVohe';
      nonce = 'NtJvwq/etNBusiwCjoDA7A==';
      ckey = 'EFnAMTRPt1nHF1c5bxsR0Q==\n';
      civ = 'o3SHAgyHmRjwhSGm2MilqA==\n';

      const data = { userSignup: { salt, nonce, ckey, civ } };
      api.mutate.and.returnValue(of({ data }));
    });

    it('should expect api to receive +mutate', () => {
      service.signup({ name, email }).subscribe();
      expect(api.mutate).toHaveBeenCalledWith({ document, variables: { name, email } });
    });

    it('should expect correct data in result', () => {
      service.signup({ name, email }).subscribe(userAuth => {
        expect(userAuth.salt).toEqual(salt);
        expect(userAuth.nonce).toEqual(nonce);
        expect(userAuth.ckey).toEqual(ckey);
        expect(userAuth.civ).toEqual(civ);
      });
    });
  });
});
