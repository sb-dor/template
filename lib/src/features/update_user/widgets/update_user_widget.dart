part of 'update_user_config_widget.dart';

class _UpdateUserWidget extends StatefulWidget {
  const _UpdateUserWidget({required this.user});

  final User user;

  @override
  State<_UpdateUserWidget> createState() => _UpdateUserWidgetState();
}

class _UpdateUserWidgetState extends State<_UpdateUserWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name ?? '';
    _emailController.text = widget.user.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserBloc, UpdateUserState>(
      listener: (context, state) {
        if (state is UserUpdateCompletedState) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Update User Widget')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Update User Information'),

                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<UpdateUserBloc>().add(
                      UpdateUserEvent.updateUser(
                        name: _nameController.text,
                        email: _emailController.text,
                      ),
                    );
                  },
                  child: const Text('Update User'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
