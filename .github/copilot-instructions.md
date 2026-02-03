# GitHub Copilot / AI agent instructions for COMP1850-week2 ✅

## Purpose
This repository contains short, instructor-led exercises (SQL + Python) used for in-class tasks and autograded assignments. The goal for any AI coding agent is: make small, correct, testable changes that follow the established patterns and do not break the autograder.

---

## Big picture / architecture 🔧
- Small, single-repo teaching exercises. Each task is standalone and uses a local SQLite database file (e.g. `tickets.db`, `university.db`, `food_delivery.db`, `orders.db`).
- Python scripts are simple CLI drivers that open an SQLite connection and run queries. Example modules:
  - `worksheet/task_2/cinema.py` (autograder target)
  - `session_1/3_python/leeds_eats/leeds_eats.py` (exercise with menu)
  - `session_1/3_python/example/example.py` (demonstration code)
- No web services, no background daemons. Data flows: Python -> sqlite3 (SQL queries) -> return lists / print to console for interactive scripts.

---

## Critical developer workflows ✅
- Run interactive checks locally using the provided test harness: `python worksheet/task_2/test.py` (it imports functions from `cinema.py` and expects return values, not prints).
- Run individual scripts: `python session_1/3_python/leeds_eats/leeds_eats.py` or `python session_1/3_python/example/example.py`.
- Inspect databases directly with sqlite CLI: `sqlite3 tickets.db`.
- Session 2 scripts use pandas/matplotlib; install with `pip install pandas matplotlib` if needed.
- Use Python 3.10+ (the repo uses `match` statements in `example.py`).

---

## Project-specific conventions & gotchas ⚠️
- Autograded functions must: keep the exact function name and signature, return data (lists/tuples), and must NOT print. Example: `customer_tickets(conn, customer_id)` returns a list of tuples (title, screen, price).
- Test harnesses import functions directly (do not add or change top-level behavior that would break imports). Keep module-level execution under `if __name__ == '__main__':`.
- Use SQL patterns consistent with requirements:
  - When you must include rows with zero matches, use LEFT JOIN (e.g., include screenings with zero tickets).
  - Grouping/counting example (screening sales):

    SELECT sc.screening_id, f.title, COUNT(t.ticket_id) AS tickets_sold
    FROM screenings sc
    JOIN films f ON sc.film_id = f.film_id
    LEFT JOIN tickets t ON sc.screening_id = t.screening_id
    GROUP BY sc.screening_id, f.title
    ORDER BY tickets_sold DESC;

- Prefer using `sqlite3.Row` when named access helps (files commonly set `conn.row_factory = sqlite3.Row`).

---

## Concrete examples from the codebase (copy/paste friendly) 💡
- Correct pattern to return rows from `cinema.py`:

    def customer_tickets(conn, customer_id):
        query = """
        SELECT f.title, sc.screen, t.price
        FROM tickets t
        JOIN screenings sc ON t.screening_id = sc.screening_id
        JOIN films f ON sc.film_id = f.film_id
        WHERE t.customer_id = ?
        ORDER BY f.title
        """
        cur = conn.execute(query, (customer_id,))
        return cur.fetchall()

- When a function must return a list of tuples (not sqlite3.Row), you can convert: `return [tuple(r) for r in cur.fetchall()]`.

---

## Known issues to watch for (examples to avoid) ❗
- Typos in SQL keywords or wrong join conditions occur in `session_1/3_python/example/example.py` (e.g., `JOINS` instead of `JOIN`, `ON c.id=d.id` vs `ON c.department_id=d.id`). When editing SQL, run the small test harness or the sqlite CLI to validate.

---

## Safety & autograder compatibility checklist (must pass before commit) ✅
- Do not change function names or parameters for autograder-target files.
- Do not print from functions required to return values.
- Add or update tests locally via the provided `test.py` harness.
- Keep changes minimal and well-scoped; instructor-provided examples are canonical.

---

## Where to look for more context 🔎
- Task descriptions: `worksheet/task_2/task.md` (cinema example)
- SQL examples: `session_1/1_outer_joins/example.sql`, `session_1/1_outer_joins/example2.sql`
- Test harness: `worksheet/task_2/test.py`

---

If anything in this file is unclear or you want more examples (e.g., a corrected version of a broken query in `example.py`), tell me which section to expand and I will iterate. 👋