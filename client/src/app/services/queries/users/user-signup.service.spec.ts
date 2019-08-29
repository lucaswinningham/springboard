import { TestBed } from '@angular/core/testing';
import { of } from 'rxjs';

import { UserSignupService } from './user-signup.service';

import { ApiService } from '@services/utils/api.service';
import { Apollo } from 'apollo-angular';
import { UserCreateService } from '@services/queries/users/user-create.service';
import { UserPasswordChangeService } from '@services/queries/users/user-password-change.service';

describe('UserSignupService', () => {
  let service: UserSignupService;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [ UserCreateService, UserPasswordChangeService, ApiService, Apollo ]
    });

    service = TestBed.get(UserSignupService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
