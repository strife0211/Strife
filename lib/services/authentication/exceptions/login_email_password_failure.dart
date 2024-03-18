class LoginWithEmailAndPasswordFailure {
  final String message;

  const LoginWithEmailAndPasswordFailure([this.message = "An Unknown error occured."]);

  factory LoginWithEmailAndPasswordFailure.code(String code) {
    switch(code) {
      case 'user-not-found':
        return const LoginWithEmailAndPasswordFailure('No user found for that email.');
      case 'wrong-password':
        return const LoginWithEmailAndPasswordFailure('Wrong password provided for that user.');
      default:
        return const LoginWithEmailAndPasswordFailure();
    }
  }
}