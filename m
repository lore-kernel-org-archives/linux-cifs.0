From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Add mount options for backup intent and
 their manpages (try #6)
Date: Mon, 3 Oct 2011 07:49:53 -0400
Message-ID: <20111003074953.06f8eb5d@tlielax.poochiereds.net>
References: <1317149929-1206-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1317149929-1206-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 27 Sep 2011 13:58:49 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Add mount options backupuid and backugid and their manpage contents.
> Check for either a valid uid/gid or valid user/group name.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mount.cifs.8 |   14 +++++++++
>  mount.cifs.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 97 insertions(+), 2 deletions(-)
> 
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 81ebdbe..d7eb2dd 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -282,6 +282,20 @@ See sections on
>  for more information\&.
>  .RE
>  .PP
> +backupuid
> +.RS 4
> +Allow access to files with the intent to back them up for a user\&.
> +.sp
> +An authenticated user at the server with a privilege can access file system objects with the intent to back them up to which it otherwise may not have access permissions.  As an example, a privilege would be "Backup files and directories user right" granted by the server by making that user a part of the built-in group Backup Operators. This mount option restricts to the specified user on the client, as such an authenticated user, privilege to access files with the intent to back them up.

Better, but this is still pretty awkward and confusing. This manpage
needs to answer 3 things:

1. what this option does (turn on the backup intent bit in open calls)

2. what the backup intent bit does (allows a user to open files to
which he wouldn't ordinarily have access)

3. when should (or shouldn't) the user enable it?

If this is going to be too long then you may want to add a new section
to explain the backup intent in detail.

> +.RE
> +.PP
> +backupgid
> +.RS 4
> +Allow access to files with the intent to back them up for a group\&.
> +.sp
> +An authenticated user at the server with a privilege can access file system objects with the intent to back them up to which it otherwise may not have access permissions.  As an example, a privilege would be "Backup files and directories user right" granted by the server by making that user a part of the built-in group Backup Operators. This mount option restricts to the users in the specified group on the client, as such an authenticated user, privilege to access files with the intent to back them up.
> +.RE
> +.PP
>  nocase
>  .RS 4
>  Request case insensitive path name matching (case sensitive is the default if the server suports it)\&.
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 1e3d534..36c3ac0 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -158,6 +158,8 @@
>  #define OPT_MAND       27
>  #define OPT_NOMAND     28
>  #define OPT_CRUID      29
> +#define OPT_BKUPUID    30
> +#define OPT_BKUPGID    31
>  
>  
>  /* struct for holding parsed mount info for use by privleged process */
> @@ -843,6 +845,10 @@ static int parse_opt_token(const char *token)
>  		return OPT_REMOUNT;
>  	if (strncmp(token, "_netdev", 7) == 0)
>  		return OPT_IGNORE;
> +	if (strncmp(token, "backupuid", 9) == 0)
> +		return OPT_BKUPUID;
> +	if (strncmp(token, "backupgid", 9) == 0)
> +		return OPT_BKUPGID;
>  
>  	return OPT_ERROR;
>  }
> @@ -858,11 +864,13 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
>  	int out_len = 0;
>  	int word_len;
>  	int rc = 0;
> +	int got_bkupuid = 0;
> +	int got_bkupgid = 0;
>  	int got_uid = 0;
>  	int got_cruid = 0;
>  	int got_gid = 0;
> -	uid_t uid, cruid = 0;
> -	gid_t gid;
> +	uid_t uid, cruid = 0, bkupuid;
> +	gid_t gid, bkupgid;
>  	char *ep;
>  	struct passwd *pw;
>  	struct group *gr;
> @@ -906,6 +914,8 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
>  			value = equals + 1;
>  		}
>  
> +		ep = NULL;
> +
>  		switch(parse_opt_token(data)) {
>  		case OPT_USERS:
>  			if (!value || !*value) {
> @@ -1171,6 +1181,42 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
>  			break;
>  		case OPT_IGNORE:
>  			goto nocopy;
> +		case OPT_BKUPUID:
> +			if (!value || !*value)
> +				goto nocopy;
> +
> +			got_bkupuid = 1;
> +			bkupuid = strtoul(value, &ep, 10);
> +			if (!strlen(ep))
> +				goto nocopy;
> +
> +			pw = getpwnam(value);
> +			if (pw == NULL) {
> +				fprintf(stderr,
> +					"bad user name \"%s\"\n", value);
> +				return EX_USAGE;
> +			}
> +
> +			bkupuid = pw->pw_uid;
> +			goto nocopy;
> +		case OPT_BKUPGID:
> +			if (!value || !*value)
> +				goto nocopy;
> +
> +			got_bkupgid = 1;
> +			bkupgid = strtoul(value, &ep, 10);
> +			if (!strlen(ep))
> +				goto nocopy;
> +
> +			gr = getgrnam(value);
> +			if (gr == NULL) {
> +				fprintf(stderr,
> +					"bad group name \"%s\"\n", value);
> +				return EX_USAGE;
> +			}
> +
> +			bkupgid = gr->gr_gid;
> +			goto nocopy;
>  		}
>  
>  		/* check size before copying option to buffer */
> @@ -1246,6 +1292,39 @@ nocopy:
>  		}
>  		snprintf(out + out_len, word_len + 5, "gid=%s", txtbuf);
>  	}
> +	/* special-case the uid and gid */
		^^^
I don't think you need this comment.

> +	if (got_bkupuid) {
> +		word_len = snprintf(txtbuf, sizeof(txtbuf), "%u", bkupuid);
> +
> +		/* comma + "uid=" + terminating NULL == 6 */
> +		if (out_len + word_len + 6 > MAX_OPTIONS_LEN) {
> +			fprintf(stderr, "Options string too long\n");
> +			return EX_USAGE;
> +		}
> +
> +		if (out_len) {
> +			strlcat(out, ",", MAX_OPTIONS_LEN);
> +			out_len++;
> +		}
> +		snprintf(out + out_len, word_len + 11, "backupuid=%s", txtbuf);
> +		out_len = strlen(out);
> +	}
> +	if (got_bkupgid) {
> +		word_len = snprintf(txtbuf, sizeof(txtbuf), "%u", bkupgid);
> +
> +		/* comma + "backkupgid=" + terminating NULL == 6 */
> +		if (out_len + word_len + 6 > MAX_OPTIONS_LEN) {
> +			fprintf(stderr, "Options string too long\n");
> +			return EX_USAGE;
> +		}
> +
> +		if (out_len) {
> +			strlcat(out, ",", MAX_OPTIONS_LEN);
> +			out_len++;
> +		}
> +		snprintf(out + out_len, word_len + 11, "backupgid=%s", txtbuf);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -1361,6 +1440,8 @@ static struct option longopts[] = {
>  	{"type", 1, NULL, 't'},
>  	{"uid", 1, NULL, '1'},
>  	{"gid", 1, NULL, '2'},
> +	{"backupuid", 1, NULL, '1'},
> +	{"backupgid", 1, NULL, '2'},

This looks unnecessary and wrong. You're adding a new command line
alias for --uid called --backupuid?

>  	{"user", 1, NULL, 'u'},
>  	{"username", 1, NULL, 'u'},
>  	{"dom", 1, NULL, 'd'},

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
