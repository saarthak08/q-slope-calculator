enum AppEnvironment {
  development(value: "dev"),
  production(value: "prod");

  const AppEnvironment({required this.value});
  final String value;
}
