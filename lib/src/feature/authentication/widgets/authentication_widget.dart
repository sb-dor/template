part of "authentication_config_widget.dart";

class _AuthenticationWidget extends StatefulWidget {
  const _AuthenticationWidget();

  @override
  State<_AuthenticationWidget> createState() => _AuthenticationWidgetState();
}

class _AuthenticationWidgetState extends State<_AuthenticationWidget> {
  final TextEditingController _emailController = TextEditingController(text: 'test@example.com');
  final TextEditingController _passwordController = TextEditingController(text: 'password');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<AuthenticationBloc>().add(const AuthenticationEvent.getCurrentUser());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication Widget')),
      body: RefreshIndicatorWidget(
        onRefresh: () async {
          context.read<AuthenticationBloc>().add(const AuthenticationEvent.getCurrentUser());
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  return switch (state) {
                    AuthenticationInitialState() => SliverToBoxAdapter(
                      child: Center(child: Text('Initial State')),
                    ),
                    AuthenticationInProgressState() => SliverFillRemaining(
                      child: Center(child: CircularProgressIndicatorWidget()),
                    ),
                    AuthenticationFailureState() => SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Failure State: ${state.message ?? "Unknown error"}',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    AuthenticationUnauthenticatedState() => SliverFillRemaining(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Unauthenticated State"),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(labelText: 'Email'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    AuthenticationAuthenticatedState() => SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Authenticated State: ${state.stateModel.user?.email ?? "No user"}',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  };
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              if (state is AuthenticationAuthenticatedState) {
                context.read<AuthenticationBloc>().add(const AuthenticationEvent.signOut());
              } else {
                if (_formKey.currentState?.validate() != true) {
                  return;
                }
                context.read<AuthenticationBloc>().add(
                  AuthenticationEvent.signIn(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  ),
                );
              }
            },
            child:
                state is AuthenticationAuthenticatedState ? Icon(Icons.logout) : Icon(Icons.person),
          );
        },
      ),
    );
  }
}
