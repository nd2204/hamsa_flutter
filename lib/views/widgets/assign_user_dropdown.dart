import 'package:flutter/material.dart';
import 'package:hamsa_flutter/services/user_service.dart';

class AssignUsersDropdown extends StatefulWidget {
  final UserList users;
  final UserList selected;
  final ValueChanged<UserList> onChanged;

  const AssignUsersDropdown({
    super.key,
    required this.users,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<AssignUsersDropdown> createState() => _AssignUsersDropdownState();
}

class _AssignUsersDropdownState extends State<AssignUsersDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlay;

  void _toggleDropdown() {
    if (_overlay != null) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    _overlay = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: GestureDetector(
            onTap: _close,
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                CompositedTransformFollower(
                  link: _layerLink,
                  offset: const Offset(0, 48),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 250,
                      child: ListView(
                        padding: const EdgeInsets.all(8),
                        shrinkWrap: true,
                        children: widget.users.map((user) {
                          final isSelected = widget.selected.any(
                            (u) => u.id == user.id,
                          );

                          return CheckboxListTile(
                            value: isSelected,
                            title: Text(user.displayName),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (_) {
                              final updated = UserList.from(widget.selected);

                              if (isSelected) {
                                updated.removeWhere((u) => u.id == user.id);
                              } else {
                                updated.add(user);
                              }

                              widget.onChanged(updated);
                              setState(() {});
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlay!);
  }

  void _close() {
    _overlay?.remove();
    _overlay = null;
  }

  @override
  void dispose() {
    _close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.selected.isEmpty
        ? 'Assign users'
        : widget.selected.map((u) => u.displayName).join(', ');

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
