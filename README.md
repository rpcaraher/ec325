# EC 325: Econometrics

Course materials for EC 325 at Colby College.

View the [syllabus here](https://www.raymondcaraher.com/ec325/ec325_syllabus.html).

Keep in mind that only reference materials,
data, and ungraded in-class exercises are here.
Graded assignments,
including concept checks and problem sets,
will only be posted on Moodle.
Don't forget you also have to submit your work to Moodle.

## Getting Started

Follow the steps in [EC325 Installation Guide](https://www.raymondcaraher.com/ec325/ec325_installation_guide.html) to get all the software set up for the course.

## What is Git and GitHub?

**Git** is a version control system—software that tracks changes to files over time. Think of it like "Track Changes" in Word, but much more powerful. Git lets you:

- Keep a complete history of every change made to a project
- Revert to previous versions if something breaks
- See exactly what changed, when, and by whom

**GitHub** is a website that hosts Git repositories (projects) online. It makes it easy to share code and collaborate. For this class, I use GitHub to distribute course materials to you—when I update slides or add new datasets, you can download those changes with a single click.

You don't need to become a Git expert for this class. You only need to know how to:

1. **Clone** — download the repository to your computer (you'll do this once)
2. **Pull** — download updates when I announce them

That's it! The instructions below will walk you through both.

## Updating Course Materials

When I announce updates to the course materials:

1. Open the project in RStudio
2. Go to the **Git** tab (usually in the upper-right pane)
3. Click the **Pull** button (down arrow)

That's it! Your materials are now up to date.

> [!IMPORTANT]
> **Use Pull only—never Commit or Push.**
> The Git tab puts **Commit** and **Push** right next to **Pull**, but you don't need
> either one. Committing changes to my files is what causes the merge conflicts
> described below, and Push will just throw a login prompt at you since you don't
> have write access to this repository. If you keep your work in `student-work/`,
> Pull is the only button you'll ever touch.

## Repository Structure

```
ec325/
├── slides/            # The slides and code used to generate them
├── book/              # Raw code for generating book chapters
├── data/              # Datasets for labs and problem sets
├── student-work/      # YOUR work goes here (not tracked by Git!)
├── other/             # Other documents and files I use
├── syllabus/          # Course syllabus
└── docs/              # Rendered book (also viewable online at link below)
```


## Viewing the Lecture Notes Book

**Online:** [https://www.raymondcaraher.com/ec325/](https://www.raymondcaraher.com/ec325/)

**Locally:** Open `docs/index.html` in your web browser.

## Where to Save Your Work

**Always save your scripts and work in the `student-work/` folder.**

This folder is ignored by Git, so:

- Your work won't be overwritten when you pull updates
- You won't see annoying "untracked files" warnings
- You can create all sorts of sub-directories in here to keep your work through the semester organized (e.g., `problem-set-1`, `project-data`, etc.)

## Troubleshooting

### "Pull isn't working" or I get an error about local changes

The most common pull errors look like one of these:

```
error: Your local changes to the following files would be overwritten by merge
```

```
CONFLICT (content): Merge conflict in ...
```

Both mean the same thing: you changed one of *my* files, and Git doesn't know whether
to keep your version or mine. This usually happens by accident—an autosave, a stray
keystroke, or clicking **Commit** in the Git tab.

**The fix:**

1. First, move any work you want to keep out of the repository folder entirely
   (drag it to your Desktop for now). Anything in `student-work/` is safe and does
   not need to be moved.
2. In RStudio, go to **Tools → Terminal → New Terminal**
3. Run these two commands:

```bash
git fetch origin
git reset --hard origin/main
```

4. Click **Pull** again

This throws away every change you made to my files and makes your copy match mine
exactly. It does **not** touch anything in `student-work/`, because Git isn't tracking
that folder.

To avoid this in the first place, always work in the `student-work/` folder.
You are more than welcome to mess around with the files I use to generate course content,
but I recommend you do so by copy-pasting the content from this directory to some other
directory not associated with Git.

### "There is no package called ..."

You're missing one of the R packages we use—most likely because you weren't in class
the day we installed it. Open RStudio and run:

```r
install.packages("name_of_the_package")
```

using whatever name the error message gave you, then try your code again.

### "I don't see a Git tab in RStudio"

RStudio only looks for Git when it starts, so quit RStudio completely and reopen it.
If the tab still isn't there, see the Troubleshooting section of the
[Installation Guide](https://www.raymondcaraher.com/ec325/ec325_installation_guide.html).

### "I accidentally deleted something"

First, try to restore it from your Trash folder.
If you can't find it, as long its one of the files I made, then it's no problem—just pull again and the original files will be restored.
But if it is one of the files you made in the `student-work/` folder,
then it may be gone for good.
Email me and we can try to track it down.
In any case,
it is good practice to back-up the repository every once a while to some other location on your computer.


## Questions?

If you run into issues, come to office hours or send me an email at [rcaraher@colby.edu](mailto:rcaraher@colby.edu)
