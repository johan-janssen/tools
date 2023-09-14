#!/bin/sh
commit=$(git rev-parse HEAD)


working_hours_start="7:00:00"
working_hours_end="18:00:00"
end_of_day_time="23:59:00"

commit_timestamp=$(git show -s --format=%at $commit)
commit_date=$(date -d @$commit_timestamp +%D)
commit_day_of_week=$(date -d @$commit_timestamp +%u)
commit_time=$(date -d @$commit_timestamp +%T)
start_of_working_day=$(date -d "$commit_date $working_hours_start" +%s)
end_of_working_day=$(date -d "$commit_date $working_hours_end" +%s)
end_of_day=$(date -d "$commit_date $end_of_day_time" +%s)
echo $commit $commit_timestamp
#weekend, do nothing
if [ $commit_day_of_week -gt 5 ] ; then
	echo "In weekend"
	return
fi

# commit was outside working hours
if [ $commit_timestamp -lt $start_of_working_day -o $commit_timestamp -gt $end_of_working_day ] ; then
	echo "Outside of working hours"
	return
fi

fraction_at_working_day=$(((($commit_timestamp - $start_of_working_day) * (10**4)) / ($end_of_day - $start_of_working_day)))
new_timestamp=$(((($end_of_day - $end_of_working_day) * $fraction_at_working_day) / (10**4) + $end_of_working_day))

echo $fraction_at_working_day
echo $commit_timestamp $new_timestamp

GIT_COMMITTER_DATE="$new_timestamp" git commit --amend --no-edit --date "$new_timestamp"