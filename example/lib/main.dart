import 'dart:async';

import 'package:access_control/access_control.dart';
import 'package:feature_override/feature_override.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DemoPage(),
      builder: (_, child) {
        return FeatureOverride<Feature>(
          onConvert: (value) => value.key,
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FeatureOverride')),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                final item = Feature.values.elementAt(index);
                final scope = FeatureOverrideScope.of<Feature>(context);

                return FutureBuilder(
                  future: scope.state(item),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      final state = snap.data!;
                      if (snap.data!.isOverride) {
                        return SwitchListTile(
                          subtitle: Align(
                            alignment: Alignment.topLeft,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  scope.remove(item.key);
                                });
                              },
                              child: const Text('remove'),
                            ),
                          ),
                          title: Text(item.title),
                          value: state.value!,
                          onChanged: (value) {
                            setState(() {
                              scope.update(item.key, value);
                            });
                          },
                        );
                      } else {
                        return ListTile(
                          title: Text(item.title),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                scope.update(item.key, true);
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        );
                      }
                    }

                    return const SizedBox();
                  },
                );
              },
              childCount: Feature.values.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: AccessControl.permission(
                permission: DeveloperPermission(),
                denied: const Text('User'),
                child: const Text('Developer'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeveloperPermission extends PermissionOverride<Feature> {
  DeveloperPermission() : super(Feature.developer);

  @override
  FutureOr<bool> fallback(BuildContext context) {
    return kDebugMode;
  }
}

enum Feature {
  beta(key: 'beta', title: 'Beta version'),
  developer(key: 'developer', title: 'Developer');

  final String key;
  final String title;

  const Feature({required this.key, required this.title});
}
