import { TestBed } from '@angular/core/testing';

import { NonceService } from './nonce.service';

describe('NonceService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: NonceService = TestBed.get(NonceService);
    expect(service).toBeTruthy();
  });
});
