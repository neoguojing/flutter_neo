# Architecture Design: Data Persistence & Business Object Abstraction

This document describes the architecture for handling application data, specifically for the Diversified Investment feature.

## Overview
The project adopts the **Repository Pattern** to decouple business logic from the underlying data source (database). This ensures that the UI and business logic layers remain agnostic of the specific storage implementation (e.g., SQL, NoSQL, or Remote API).

## Core Components

### 1. Model Layer (Business Objects)
- **Responsibility**: Defines pure Dart objects representing the business entities.
- **Key Requirements**: 
  - Independent of persistence logic.
  - Includes serialization methods (, ) for easy data mapping.
- **Example**: `Investment` model.

### 2. Repository Layer (Data Abstraction)
- **Interface (`IInvestmentRepository`)**: Defines the contract for all data operations (e.g., `getAll`, `save`, `delete`).
- **Implementation (`InvestmentRepositoryImpl`)**: Concrete implementation that handles actual database queries.
- **Benefit**: Allows for easy swapping of data sources (e.g., switching from `sqflite` to `Hive` or a REST API) without touching the UI.

### 3. Database Service (Persistence Layer)
- **Responsibility**: Singleton class for initializing and managing the database connection, handling migrations, and providing the low-level database instance.
- **Implementation**: `DatabaseHelper`.

### 4. Manager / Provider Layer (State & logic)
- **Responsibility**: Acts as the bridge between the UI and Repositories.
- **Functionality**:
  - Handles the lifecycle of data (e.g., loading data from the DB on startup).
  - Provides reactive updates to the UI (using `ChangeNotifier`, `Bloc`, or `Riverpod`).
  - Orchestrates complex operations (e.g., adding an investment involves updating the repository and refreshing the list).

## Data Flow
1. **App Launch**: `InvestmentProvider` initializes $\rightarrow$ calls `Repository.getAll()` $\rightarrow$ fetches from `DatabaseHelper` $\rightarrow$ updates UI.
2. **User Action**: User adds an investment $\rightarrow$ `InvestmentProvider` captures input $\rightarrow$ creates `Investment` object $\rightarrow$ calls `Repository.save()` $\rightarrow$ Repository updates DB $\rightarrow$ Provider updates local state and notifies UI.

## Benefits
- **Testability**: Repository interfaces allow for easy mocking during unit/widget tests.
- **Maintainability**: Clear separation of concerns makes it easier to locate and fix bugs.
- **Scalability**: New features can reuse the same architectural patterns consistently.
