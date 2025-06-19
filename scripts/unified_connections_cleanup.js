async function deleteAllConnections() {
  console.log("Preparing to delete ALL connections");

  // confirmation prompt
  const confirmMessage = `are you sure you want to delete ALL connections?\n\nThis action cannot be undone.`;
  if (!confirm(confirmMessage)) {
    console.log("Operation cancelled by user");
    return;
  }

  console.log("Confirmed! Starting deletion process...");

  const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

  let deletedCount = 0;

  while (true) {
    // find all table rows
    const rows = document.querySelectorAll('.table-row[role="row"]');
    let foundConnection = false;

    for (const row of rows) {
      // find the delete button in this row
      const deleteButton = row.querySelector('button[title="Delete"]');
      if (deleteButton) {
        // get connection ID for logging
        const idCell = row.querySelector(".table-cell:first-child span");
        const connectionId = idCell ? idCell.textContent.trim() : "Unknown";

        console.log(`Deleting connection ${connectionId}`);
        deleteButton.click();
        deletedCount++;
        foundConnection = true;

        // wait for UI update
        await wait(1000);

        // handle confirmation dialog
        const buttons = document.querySelectorAll("button");
        let confirmButton = null;

        for (const btn of buttons) {
          const text = btn.textContent.trim().toLowerCase();
          if (
            text === "confirm" ||
            text === "delete" ||
            text === "yes" ||
            (btn.classList.contains("btn-primary") &&
              (text.includes("delete") || text.includes("confirm")))
          ) {
            confirmButton = btn;
            break;
          }
        }

        if (confirmButton) {
          confirmButton.click();
          await wait(500);
        }

        break; // start over to handle DOM updates
      }
    }

    if (!foundConnection) {
      console.log(`Completed! Deleted ${deletedCount} connections.`);
      break;
    }
  }
}

deleteAllConnections();
