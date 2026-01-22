# Development Guidelines

## Core Requirements

**TEST-DRIVEN DEVELOPMENT IS NON-NEGOTIABLE**
Every single line of production code must be written in response to a failing test. No exceptions.

- Write failing test first, then minimal code to pass, then assess refactoring value
- Test behavior through public APIs only, never implementation details
- Achieve 100% coverage through business behavior tests

**TDD Violations to Avoid:**
- Writing production code without a failing test first
- Writing multiple tests before making the first one pass
- Writing more production code than needed to pass the current test
- Skipping the refactor assessment step

**If you're typing production code and there isn't a failing test demanding it, STOP.**

## TypeScript Configuration

```json
{
  "compilerOptions": {
    "strict": true,  // Enables all strict type-checking options
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

**Note:** `"strict": true` automatically enables:
- `noImplicitAny` - no implicit `any` types
- `strictNullChecks` - null/undefined checking
- `strictFunctionTypes` - contravariant function parameters
- `strictBindCallApply` - strict bind/call/apply checking
- `strictPropertyInitialization` - class properties must be initialized
- `noImplicitThis` - no implicit `this` usage
- `alwaysStrict` - emit "use strict" for each source file

### Type Rules
- No `any` - use `unknown` for truly unknown types
- No type assertions without clear justification
- Prefer `type` over `interface`
- Define schemas with Zod first, derive types from schemas
- Import real schemas in tests, never redefine

## Code Principles

### Mandatory Patterns
- **Immutable data** - no mutations, use spread operators
- **Pure functions** - no side effects where possible
- **Early returns** - guard clauses instead of nested conditionals
- **Self-documenting** - clear names instead of comments
- **Options objects** - for functions with 2+ parameters
- **Small functions** - single responsibility principle

#### Options Object Pattern
```typescript
// Avoid: Multiple positional parameters
const createPayment = (
  amount: number,
  currency: string,
  cardId: string,
  customerId: string,
  description?: string
): Payment => {}

// Calling is unclear
createPayment(100, "GBP", "card_123", "cust_456", undefined)

// Good: Options object with clear property names
type CreatePaymentOptions = {
  amount: number;
  currency: string;
  cardId: string;
  customerId: string;
  description?: string;
};

const createPayment = (options: CreatePaymentOptions): Payment => {
  const { amount, currency, cardId, customerId, description } = options;
  // implementation
}

// Clear at call site
createPayment({
  amount: 100,
  currency: "GBP",
  cardId: "card_123",
  customerId: "cust_456"
})
```

### Naming Conventions
- Functions: `camelCase`, verb-based (`calculateTotal`)
- Types: `PascalCase` (`PaymentRequest`)
- Constants: `UPPER_SNAKE_CASE` for true constants
- Files: `kebab-case.ts`
- Test files: `*.test.ts` or `*.spec.ts`

## Testing Approach

### Tools
- Jest or Vitest for test framework
- React Testing Library for components
- MSW for API mocking when needed

### Test Data Pattern
```typescript
const getMockPayment = (overrides?: Partial<Payment>): Payment => {
  return {
    id: "pay_123",
    amount: 100,
    currency: "USD",
    status: "pending",
    ...overrides
  };
};
```

### Test Organization
- Test behavior, not file structure
- No 1:1 test-to-implementation file mapping
- Group tests by feature/behavior

```
src/
  features/
    payment/
      payment-processor.ts
      payment-validator.ts
      payment-processor.test.ts  # Tests behavior, validator tested through processor
```

### Achieving 100% Coverage Through Behavior

```typescript
// payment-validator.ts (implementation detail - not tested directly)
export const validatePaymentAmount = (amount: number): boolean => {
  return amount > 0 && amount <= 10000;
};

// payment-processor.ts (public API)
export const processPayment = (request: PaymentRequest): Result<Payment> => {
  if (!validatePaymentAmount(request.amount)) {
    return { success: false, error: new Error("Invalid amount") };
  }
  // Process payment...
  return { success: true, data: executedPayment };
};

// payment-processor.test.ts
describe('Payment Processing', () => {
  // These tests achieve 100% coverage of validator WITHOUT testing it directly
  it('rejects negative amounts', () => {
    const result = processPayment({ amount: -100 });
    expect(result.success).toBe(false);
    expect(result.error.message).toBe("Invalid amount");
  });

  it('rejects amounts over limit', () => {
    const result = processPayment({ amount: 10001 });
    expect(result.success).toBe(false);
  });

  it('processes valid amounts', () => {
    const result = processPayment({ amount: 100 });
    expect(result.success).toBe(true);
  });
});
```

**Key Point**: The validator gets 100% coverage through testing the public API behavior, not by testing the validator directly.

Tests group by feature behavior, not file structure:
```typescript
describe('Payment Processing', () => {
  describe('validation', () => {
    it('rejects negative amounts', () => {})
    it('rejects amounts over limit', () => {})
  })
  describe('authorization', () => {
    it('authorizes valid payments', () => {})
    it('declines insufficient funds', () => {})
  })
  describe('settlement', () => {
    it('captures authorized payments', () => {})
  })
})
```

### Async Testing Patterns
```typescript
describe('Payment API', () => {
  it('should process payment asynchronously', async () => {
    const payment = getMockPayment({ amount: 100 });

    const result = await processPaymentAsync(payment);

    expect(result.success).toBe(true);
    expect(result.data.status).toBe('completed');
  });

  it('should handle API errors gracefully', async () => {
    const payment = getMockPayment({ cardId: 'invalid' });

    await expect(processPaymentAsync(payment))
      .rejects
      .toThrow('Invalid card');
  });
});

// React Testing Library async patterns
describe('PaymentForm', () => {
  it('should show success after payment', async () => {
    render(<PaymentForm />);

    await userEvent.type(screen.getByLabelText('Amount'), '100');
    await userEvent.click(screen.getByRole('button', { name: 'Pay' }));

    // Wait for async update
    expect(await screen.findByText('Payment successful')).toBeInTheDocument();
  });
});
```

### React Component Behavior Testing

```typescript
describe('PaymentForm', () => {
  it('should handle the complete payment flow', async () => {
    const onSuccess = jest.fn();
    render(<PaymentForm onSuccess={onSuccess} />);

    // User fills form
    await userEvent.type(screen.getByLabelText('Card Number'), '4242424242424242');
    await userEvent.type(screen.getByLabelText('Amount'), '100');

    // User submits
    await userEvent.click(screen.getByRole('button', { name: 'Pay Now' }));

    // Loading state appears
    expect(screen.getByText('Processing...')).toBeInTheDocument();

    // Success message appears (async)
    expect(await screen.findByText('Payment successful')).toBeInTheDocument();

    // Callback fired with correct data
    expect(onSuccess).toHaveBeenCalledWith(
      expect.objectContaining({ amount: 100, status: 'completed' })
    );
  });
});
```

## Refactoring Process

1. **Commit before refactoring** - always have a safe state
2. **Abstract shared semantics** - not structural similarity
3. **DRY = Don't Repeat Knowledge** - not code appearance
4. **Maintain external APIs** - internal changes only
5. **Verify and commit** - tests pass, then commit separately
6. **Assess refactoring value** - does it improve readability, maintainability, testability, or performance?

### When to Abstract
✅ Same semantic meaning - SAFE TO ABSTRACT:
```typescript
// Before: Multiple functions doing the same thing
const formatUserDisplayName = (first: string, last: string): string =>
  `${first} ${last}`.trim();
const formatCustomerDisplayName = (first: string, last: string): string =>
  `${first} ${last}`.trim();
const formatEmployeeDisplayName = (first: string, last: string): string =>
  `${first} ${last}`.trim();

// After: Single function for shared concept "format person name for display"
const formatPersonDisplayName = (first: string, last: string): string =>
  `${first} ${last}`.trim();
```

❌ Different semantic meaning - DO NOT ABSTRACT:
**These look similar but represent different business concepts that will evolve independently**
```typescript
// Similar structure but different business rules that will evolve independently
const validatePaymentAmount = (n: number): boolean => n > 0 && n <= 10000;
const validateProductRating = (n: number): boolean => n >= 1 && n <= 5;
const validateUserAge = (n: number): boolean => n >= 18 && n <= 100;

// Payment limits might change based on fraud rules
// Ratings might switch from 1-5 to 1-10
// Age requirements vary by legal jurisdiction
// Abstracting these couples unrelated business concepts
```

**Ask before abstracting:**
- Do these represent the same concept or different concepts that happen to look similar?
- If business rules for one change, should the others change too?
- Am I abstracting based on what the code IS (structure) or what it MEANS (semantics)?

## Schema-First Development

```typescript
import { z } from "zod";

// Define schema
const PaymentSchema = z.object({
  id: z.string(),
  amount: z.number().positive(),
  currency: z.enum(["USD", "EUR", "GBP"]),
  status: z.enum(["pending", "completed", "failed"])
});

// Derive type
type Payment = z.infer<typeof PaymentSchema>;

// Use at boundaries
export const parsePayment = (data: unknown): Payment =>
  PaymentSchema.parse(data);
```

## Error Handling

Use Result types or exceptions with early returns:

```typescript
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

const processPayment = (payment: Payment): Result<ProcessedPayment> => {
  if (!isValid(payment)) {
    return { success: false, error: new Error("Invalid payment") };
  }
  return { success: true, data: execute(payment) };
};
```

### Error Handling with neverthrow

For more robust error handling, consider using the `neverthrow` library:

```typescript
import { ok, err, Result, ResultAsync } from 'neverthrow';

// Synchronous operations that can fail
const validatePayment = (payment: Payment): Result<ValidPayment, ValidationError> => {
  if (payment.amount <= 0) {
    return err(new ValidationError('Amount must be positive'));
  }
  if (payment.amount > 10000) {
    return err(new ValidationError('Amount exceeds limit'));
  }
  return ok(payment as ValidPayment);
};

// Chaining operations with andThen
const processPayment = (payment: Payment): Result<Receipt, PaymentError> => {
  return validatePayment(payment)
    .andThen(authorizePayment)  // Each step returns Result
    .andThen(capturePayment)
    .map(generateReceipt);       // map for transformations that can't fail
};

// Async operations with ResultAsync
const processPaymentAsync = (payment: Payment): ResultAsync<Receipt, PaymentError> => {
  return ResultAsync.fromPromise(
    fetchAccountBalance(payment.accountId),
    e => new PaymentError('Failed to fetch balance')
  )
  .andThen(balance =>
    balance >= payment.amount
      ? okAsync(payment)
      : errAsync(new PaymentError('Insufficient funds'))
  )
  .andThen(authorizePaymentAsync)
  .map(generateReceipt);
};

// Usage - type-safe error handling
const result = processPayment(payment);
if (result.isOk()) {
  console.log('Success:', result.value);
} else {
  console.log('Error:', result.error.message);
}
```

## Working with Claude

### My Commitments
- I will always write tests before production code
- I will assess refactoring opportunities after each passing test
- I will maintain immutability and functional patterns
- I will follow TypeScript strict mode requirements
- I will ask for clarification when requirements are ambiguous

### Communication Style
- Be explicit about trade-offs
- Explain significant design decisions
- Flag any guideline deviations with justification
- Keep changes small and incremental

## Quick Reference

**TDD Cycle**: Red → Green → Refactor (assess value)
**Testing**: Behavior only, 100% coverage, real schemas
**Code**: Immutable, pure, flat, self-documenting
**Types**: Strict mode, no `any`, schema-first with Zod
**Refactoring**: Commit first, semantic abstractions only

## Common Pitfalls

### Writing Code Before Tests
**Symptom**: Finding yourself writing implementation then "backfilling" tests
**Fix**: Delete the implementation, write the test first, then reimplement

### Testing Implementation Instead of Behavior
**Symptom**: Tests break when refactoring despite behavior being unchanged
**Fix**: Test through public APIs only, delete tests that check internals

### Premature Abstraction
**Symptom**: Creating generic utilities before having 3+ real use cases
**Fix**: Duplicate first, abstract only when pattern is proven

## Resources

- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [Testing Library Principles](https://testing-library.com/docs/guiding-principles)
- [Zod Documentation](https://zod.dev)
- [neverthrow Documentation](https://github.com/supermacro/neverthrow)