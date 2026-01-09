# EC 325: Econometrics

Course materials for EC 325 at Colby College.

## Getting Started

### Step 1: Create a GitHub Account

If you don't already have one, create a free account at [github.com](https://github.com).

### Step 2: Clone This Repository in RStudio

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

### Step 3: Open the Project

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
├── book/              # Raw book chapters (.qmd files)
├── data/              # Datasets for labs and problem sets
├── labs/              # In-class lab exercises
├── problem-sets/      # Problem set instructions
├── student-work/      # YOUR work goes here (not tracked by Git!)
└── docs/              # Rendered book (also viewable online)
```

## Where to Save Your Work

**Always save your scripts and work in the `student-work/` folder.**

This folder is ignored by Git, so:
- Your work won't be overwritten when you pull updates
- You won't see annoying "untracked files" warnings

## Viewing the Book

**Online:** [Site goes here](https://yoursite.com/ec325-materials/)

**Locally:** Open `docs/index.html` in your browser, or run `quarto preview` in the terminal.

## Troubleshooting

### "I'm getting merge conflicts"

This usually means you edited a course file directly. To fix:
1. Save any work you want to keep somewhere else
2. In the Terminal tab, run: `git checkout .`
3. Pull again

To avoid this, always work in the `student-work/` folder.

### "Pull isn't working"

Make sure you're connected to the internet and try again. If you see an error message, copy it and email me.

### "I accidentally deleted something"

No problem—just pull again and the original files will be restored.

## Questions?

If you run into issues, come to office hours or post in the course Slack/discussion board.
