# Get WordPress Plugin Reviews

This is a basic shell script that lets you grab all wordpress plugin reviews of a specific plugin and the review data and info.

## About

With `get.sh`, you can insert a plugin slug (e.g `hello-dolly`) and generate a JSON file of all the reviews that this plugin received.

## Generated Information

JSON information generated for reviews include:

- **Reviewer name**: The display name of the WordPress.org user who did the review
- **Reviewer nicename** (@slug): The user slug of the review author
- **Reviewer avatar URL**: The avatar image `src` attribute, the URL you can use to display an icon of the review author
- **Review star count**: from `1` to `5`, the number of stars in the review
- **Review content text**: the HTML content of the review, the things the reviewer said in their review

For the sake of simplicity, that's the information fetched from the review.

## Basic Use

- Clone this to your environment: `git clone https://github.com/elhardoum/get-wp-plugin-reviews.git`
- Change directory to this project: `cd get-wp-plugin-reviews`
- Now run `get.sh`: `./get.sh`, you'll be prompted to provide the plugin slug (not the plugin URL, just the name of the plugin as in <code><span>https://</span>wordpress.org/plugins/<strong>plugin-slug</strong>/</code>). You can also pass the plugin slug as the first parameter and skip this prompt: `./get.sh plugin-name`.

You'll also be prompted to wait couple seconds, it depends on how many reviews this plugin has received, the more it got, the more time it will take to fetch them all, taking it easy on the WordPress servers. 

## What do I get?

All review data is stored in a JSON file, and for multiple use, the file name will have a time string appended to its name, so you might have multiple JSON files and to get the last file, the last date key (e.g `2017-01-22-21-20-14`) is stored in `{plugin-name}.last`.

You can then decode the reviews from the JSON file to make a list, store it in the database, or keep it this way in the file. You can sort the reviews based on the rating, but it is not my problem.

## Cron and Background Tasks

You can add this to your `crontab` (`crontab -e`) and run the `get.sh` frequently like once a week to update the reviews:

`path/to/get.sh plugin-name`

## Thanks!

Thank you for using this. Feel free to contribute and improve it.
*I initially made this for a friend of mine to fetch their plugin and get fresh reviews on their website.*