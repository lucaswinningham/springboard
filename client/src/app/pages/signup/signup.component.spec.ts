import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SignupComponent } from './signup.component';

import { UserSignupService } from '@app/services/queries/users/user-signup.service';

describe('SignupComponent', () => {
  let component: SignupComponent;
  let fixture: ComponentFixture<SignupComponent>;
  let userSignupService: jasmine.SpyObj<UserSignupService>;

  beforeEach(async(() => {
    const userSignupServiceSpy = jasmine.createSpyObj('UserSignupService', ['signup']);
    TestBed.configureTestingModule({
      declarations: [ SignupComponent ],
      providers: [{ provide: UserSignupService, useValue: userSignupServiceSpy }]
    }).compileComponents();

    userSignupService = TestBed.get(UserSignupService);
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SignupComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
