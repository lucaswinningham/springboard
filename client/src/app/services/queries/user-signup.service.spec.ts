import { TestBed } from '@angular/core/testing';

import { UserSignupService } from './user-signup.service';

describe('UserSignupService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: UserSignupService = TestBed.get(UserSignupService);
    expect(service).toBeTruthy();
  });
});
