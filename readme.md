# Get WordPress Plugin Reviews

This is a basic shell script that lets you grab all wordpress plugin reviews of a specific 
plugin and the review data and info.

## About

With `get.sh`, you can insert a plugin slug (e.g `hello-dolly`) and generate a JSON file of 
all the reviews that this plugin received.

## Generated Information

JSON information generated for reviews include:

- **Reviewer name**: The display name of the WordPress.org user who did the review
- **Reviewer nicename** (@slug): The user slug of the review author
- **Reviewer avatar URL**: The avatar image `src` attribute, the URL you can use to display 
an 
icon of the review author
- **Review star count**: from `1` to `5`, the number of stars in the review
- **Review content text**: the HTML content of the review, the things the reviewer said in 
their 
review

For the sake of simplicity, that's the information fetched from the review.

## Basic Use

- Clone this to your environment: `git clone 
https://github.com/elhardoum/get-wp-plugin-reviews.git`
- Change directory to this project: `cd get-wp-plugin-reviews`
- Now run `get.sh`, you'll be prompted to provide the plugin slug (not the plugin URL, just 
the name of the plugin as in https://wordpress.org/plugins/`plugin-slug`/

You'll also be prompted to wait couple seconds, it depends on how many reviews this plugin 
has received, the more it got, the more time it will take to fetch them all, taking it easy 
on the WordPress servers. 

## What do I get?

All review data is stored in a JSON file, ..


