# EC 325: Econometrics

Course materials for EC 325 at Colby College.

Keep in mind that only reference materials,
data, and ungraded in-class assignments are here.
Graded assignments,
including concept checks and problem sets,
will only be posted on Moodle.
Don't forget you also have to submit your work to Moodle.

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

## Getting Started

### Step 1: Install Git

Before you can use Git with RStudio, you need to install it on your computer.

**Mac:** Git may already be installed. To check, open **Terminal** (search for it in Spotlight) and type `git --version`. If you see a version number, you're all set! If not, you'll be prompted to install the Xcode Command Line Tools—click **Install** and follow the prompts. Alternatively, download Git from [git-scm.com/download/mac](https://git-scm.com/download/mac).

**Windows:** Download the installer from [git-scm.com/download/win](https://git-scm.com/download/win) and run it. Use the default options—just keep clicking **Next**. When asked about "Adjusting your PATH environment," select **"Git from the command line and also from 3rd-party software"** (usually the default). After installation, restart RStudio if it was open.

### Step 2: Create a GitHub Account

If you don't already have one, create a free account at [github.com](https://github.com).

### Step 3: Clone This Repository in RStudio

1. Open RStudio
2. Go to **File → New Project → Version Control → Git**
3. In the "Repository URL" field, paste:
   ```
   https://github.com/rpcaraher/ec325.git
   ```
4. Choose a location on your computer to save the project (e.g., your Documents folder)
5. Click **Create Project**

RStudio will download all the course materials to your computer.

<!-- TODO: Add screenshot of RStudio clone dialog -->

### Step 4: Open the Project

After cloning, always open the course materials by double-clicking the `ec325.Rproj` file. 
This ensures your working directory is set correctly and file paths in the code will work.

## Updating Course Materials

When I announce updates to the course materials:

1. Open the project in RStudio
2. Go to the **Git** tab (usually in the upper-right pane)
3. Click the **Pull** button (down arrow)

<!-- TODO: Add screenshot of Git pane with Pull button highlighted -->

That's it! Your materials are now up to date.

## Repository Structure

```
ec325/
├── slides/            # The slides and code used to generate them
├── book/              # Raw code for generating book chapters
├── data/              # Datasets for labs and problem sets
├── labs/              # In-class lab exercises
├── student-work/      # YOUR work goes here (not tracked by Git!)
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

### "I'm getting merge conflicts"

This usually means you edited the course files I make directly. To fix:

1. Save any work you want to keep somewhere else
2. In the Terminal tab, run: `git checkout .`
3. Pull again

To avoid this, always work in the `student-work/` folder.
You are more than welcome to mess around with the files I use to generate course content,
but I recommend you do so by copy-pasting the content from this directory to some other
directory not associated with Git.

### "Pull isn't working"

Make sure you're connected to the internet and try again. If you see an error message, copy it and email me.

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
