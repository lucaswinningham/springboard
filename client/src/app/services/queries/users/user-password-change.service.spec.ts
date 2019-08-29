import { TestBed } from '@angular/core/testing';

import { UserPasswordChangeService } from './user-password-change.service';

describe('UserPasswordChangeService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: UserPasswordChangeService = TestBed.get(UserPasswordChangeService);
    expect(service).toBeTruthy();
  });
});
