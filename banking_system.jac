"""AI-Enhanced Banking System"""

import from byllm.llm { Model };

# Initialize LLM
glob llm = Model(model_name="gpt-4o", verbose=False);

# AI advice generator
def financial_advice(balance: int) -> str by llm();

node Transaction {
    has type: str;
    has amount: int;
    has balance_after: int;
}

walker Bank {
    has balance: int = 0;

    can deposit with Transaction entry;
    can withdraw with Transaction entry;
    can check_balance with `root entry;
    can advice with `root entry;
}

impl Bank.deposit {
    self.balance += here.amount;
    here.type = "Deposit";
    here.balance_after = self.balance;
    return { "message": f"Deposited {here.amount}", "balance": self.balance };
}

impl Bank.withdraw {
    if here.amount > self.balance {
        return { "error": "Insufficient funds!" };
    } else {
        self.balance -= here.amount;
        here.type = "Withdraw";
        here.balance_after = self.balance;
        return { "message": f"Withdrew {here.amount}", "balance": self.balance };
    }
}

impl Bank.check_balance {
    return { "balance": self.balance };
}

impl Bank.advice {
    return { "advice": financial_advice(self.balance) };
}

with entry:__main__ {
    root spawn Bank(300);
}
