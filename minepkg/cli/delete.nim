import terminal
import ../storage

proc delete* =
  echo:
    "Are you SURE that you want to delete your main secret? You'll only be " &
    "able to restore it using the backup phrases! Delete the main secret? [y|N]"
  if getCh() == 'y':
    deleteSecret("main")
    echo "Main secret deleted."
  else:
    echo "Aborted."
