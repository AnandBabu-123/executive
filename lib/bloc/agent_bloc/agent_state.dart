import '../../model/agent_model/agent_model.dart';

abstract class AgentState {}

class AgentInitial extends AgentState {}

class AgentLoading extends AgentState {}

class AgentLoaded extends AgentState {
  final List<Agent> agents;
  final int currentPage;
  final int lastPage;

  AgentLoaded({
    required this.agents,
    required this.currentPage,
    required this.lastPage,
  });
}

class AgentError extends AgentState {
  final String message;

  AgentError(this.message);
}

class AgentAdding extends AgentState {}

class AgentAdded extends AgentState {}

class AgentAddError extends AgentState {
  final String message;
  AgentAddError(this.message);
}