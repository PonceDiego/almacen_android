part of 'bloc_navigator_bloc.dart';

class NavigatorState extends Equatable {
  final List<int> values;
  final int valuesLength;
  final String parametro;

  NavigatorState(this.values,{this.valuesLength, this.parametro});

  @override
  List<Object> get props => [values,valuesLength, parametro];

  NavigatorState copyWith({List<int> values, String parametro}){
    return NavigatorState(
      values ?? this.values,
      valuesLength: values == null ? 0:values.length,
      parametro :parametro
    );
  }
}
