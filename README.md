# uBlacklist_Subscriptions_for_Pi-Hole
Pi-hole compatible domain lists built from various uBlackList subscription lists

## uBlackList Subscription Lists
uBlacklist features a number of subscriptions on [this page](https://ublacklist.github.io/subscriptions). Some of these offer Pi-hole compatible versions, some do not. For those that don't I've taken it upon myself to extract and create said lists.

- BadWebsiteBlocklist - Built from popcar2's list https://github.com/popcar2/BadWebsiteBlocklist
- ublacklist-ai - Built from [Sarah Engel](https://github.com/PrincessAkira)'s list https://github.com/PrincessAkira/ublacklist-ai
- ublacklist-github-translation - Built from [Sho Iizuka](https://github.com/arosh)'s list https://github.com/arosh/ublacklist-github-translation
- ublacklist-stack-overflow-translation -Built from [Sho Iizuka](https://github.com/arosh)'s list https://github.com/arosh/ublacklist-stackoverflow-translation

##  Other Lists
- RPiList-Malware - Not technically a list for uBlacklist but I don't care https://v.firebog.net/hosts/RPiList-Malware.txt
- RPiList-Phishing - Also not technically a list ofr uBlacklist but I again don't care https://v.firebog.net/hosts/RPiList-Phishing.txt

## Files
- Extract-Domains.psm1 - contains a number of functions used to read, extract, and save the lists
- uBlacklist_Subscriptions_for_Pi-hole.ps1 - the main script that processes the files
- SubscriptionLists.csv - contains the various subscription lists and other details used by the script
