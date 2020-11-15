# Contributing

## Guidelines

-   If you have no idea what are [issues](https://docs.github.com/en/free-pro-team@latest/github/managing-your-work-on-github/about-issues) or [PR](https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/about-pull-requests)s, please do refer to the links.

**Make sure your code works before submitting it :D**

<details>

<summary>
<h2 style="display:inline;">Set it up locally </h2>
</summary>

### Clone it

You need to clone (download) it to local machine using

```sh
$ git clone https://github.com/Rony-1008/Agri-com.git
```

Once you have cloned the repository, move to that folder first using `cd` command.

```sh
$ cd Agri-com
```

Move to this folder for all other commands.

### Sync it

**Always keep your local copy of repository updated with the original repository.**

Before making any changes and/or in an appropriate interval, run the following commands _carefully_ to update your local repository.

```sh
# Fetch all remote repositories and delete any deleted remote branches
$ git fetch --all --prune

# Switch to `main` branch
$ git checkout main

# Reset local `main` branch to match `upstream` repository's `main` branch
$ git reset --hard origin/main

### You're Ready to Go

Once you have completed these steps, you are ready to start contributing by checking the Issues and creating [pull requests](https://github.com/GameofSource-GFG/Android-Development/pulls).

</details>

---

<details>
<summary>
<h2 style="display:inline;">Installation</h2>
</summary>

Make sure you have following installed on your machine:

-   [Git](https://git-scm.com/downloads)
-   [Flutter SDK](https://flutter.dev/docs/get-started/install)
-   [Android Studio](https://developer.android.com/studio) or [VSCode](https://code.visualstudio.com/download)

To setup Flutter in Android Studio check [here](https://flutter.dev/docs/development/tools/android-studio)

To setup Flutter in VSCode check [here](https://flutter.dev/docs/development/tools/vs-code)

Install all dependencies using:

```sh
$ flutter pub get
```

Run the app using:

```sh
$ flutter run
```

<!--
+------------------------------------------------------+
| Delete this comment after changes                    |
| Do not delete the below copy command                 |
+------------------------------------------------------+
-->

</details>

---

To add the changes to the branch. Use

```sh
# To add all files to branch <YOUR GITHUB USERNAME>/<ISSUE NUMBER>
$ git add .
```

Type in a message relevant for the code reveiwer using

```sh
# This message get associated with all files you have changed
$ git commit -m 'relevant message'
```

Now, Push your awesome work to our remote repository using

```sh
# To push your work to your remote repository
$ git push -u origin development
#Example
#$ git push -u origin <YOUR GITHUB USERNAME>/<ISSUE NUMBER>
```

Finally, go to our repository in browser, change the branch to `development` and click on `compare and pull requests`.

<h4>NOTE:</h4>

**_Make sure you make Pull Request from `development` branch to the `main` branch of our project_**

Then add a title and description to your pull request that explains your precious effort.
Don't forget to mention the issue number you are working on.

### Thank you for your contribution.
