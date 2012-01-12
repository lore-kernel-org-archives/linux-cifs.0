From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: Properly update mtab during remount V5
Date: Thu, 12 Jan 2012 06:54:56 -0500
Message-ID: <20120112065456.6873a6d4@tlielax.poochiereds.net>
References: <1326369090-11600-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1326369090-11600-1-git-send-email-cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 12 Jan 2012 09:51:30 -0200
Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> During a remount of a cifs filesystem, the mtab file is not properly updated,
> which leads to a doubled entry of the same filesystem in the /etc/mtab file.
> This patch adds a new function del_mtab() which is called before the add_mtab()
> in case the fs is being remounted.
> The del_mtab() function will delete from the mtab, the old entry from the
> filesystem which is being remounted, and then, calls add_mtab() to add an
> updated entry to the mtab file.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mount.cifs.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 99 insertions(+), 1 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 147f7fc..2f95d35 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -42,6 +42,7 @@
>  #include <fcntl.h>
>  #include <limits.h>
>  #include <paths.h>
> +#include <libgen.h>
>  #include <sys/mman.h>
>  #include <sys/wait.h>
>  #ifdef HAVE_LIBCAP_NG
> @@ -161,6 +162,7 @@
>  #define OPT_BKUPUID    30
>  #define OPT_BKUPGID    31
>  
> +#define MNT_TMP_FILE "/.mtab.cifs.XXXXXX"
>  
>  /* struct for holding parsed mount info for use by privleged process */
>  struct parsed_mount_info {
> @@ -1624,6 +1626,95 @@ add_mtab_exit:
>  	return rc;
>  }
>  
> +static int
> +del_mtab(char *mountpoint)
> +{
> +	int tmprc, rc = 0;
> +	FILE *mnttmp, *mntmtab;
> +	struct mntent *mountent;
> +	char *mtabfile, *mtabdir, *mtabtmpfile;
> +
> +	mtabfile = strdup(MOUNTED);
> +	mtabdir = dirname(mtabfile);
> +	mtabdir = realloc(mtabdir, strlen(mtabdir) + strlen(MNT_TMP_FILE) + 2);
> +	if (!mtabdir) {
> +		fprintf(stderr, "del_mtab: cannot determine current mtab path");
> +		rc = EX_FILEIO;
> +		goto del_mtab_exit;
> +	}
> +
> +	mtabtmpfile = strcat(mtabdir, MNT_TMP_FILE);
> +	if (!mtabtmpfile) {
> +		fprintf(stderr, "del_mtab: cannot allocate memory to tmp file");
> +		rc = EX_FILEIO;
> +		goto del_mtab_exit;
> +	}
> +
> +	atexit(unlock_mtab);
> +	rc = lock_mtab();
> +	if (rc) {
> +		fprintf(stderr, "del_mtab: cannot lock mtab");
> +		rc = EX_FILEIO;
> +		goto del_mtab_exit;
> +	}
> +
> +	mtabtmpfile = mktemp(mtabtmpfile);
> +	if (!mtabtmpfile) {
> +		fprintf(stderr, "del_mtab: cannot setup tmp file destination");
> +		rc = EX_FILEIO;
> +		goto del_mtab_exit;
> +	}
> +
> +	mntmtab = setmntent(MOUNTED, "r");
> +	if (!mntmtab) {
> +		fprintf(stderr, "del_mtab: could not update mount table\n");
> +		rc = EX_FILEIO;
> +		goto del_mtab_exit;
> +	}
> +
> +	mnttmp = setmntent(mtabtmpfile, "w");
> +	if (!mnttmp) {
> +		fprintf(stderr, "del_mtab: could not update mount table\n");
> +		endmntent(mntmtab);
> +		rc = EX_FILEIO;
> +		goto del_mtab_exit;
> +	}
> +
> +	while ((mountent = getmntent(mntmtab)) != NULL) {
> +		if (!strcmp(mountent->mnt_dir,mountpoint))
> +			continue;
> +		rc = addmntent(mnttmp, mountent);
> +		if (rc) {
> +			fprintf(stderr, "del_mtab: unable to add mount entry to mtab\n");
> +			rc = EX_FILEIO;
> +			goto del_mtab_error;
> +		}
> +	}
> +
> +	endmntent(mntmtab);
> +
> +	tmprc = my_endmntent(mnttmp, 0);
> +	if (tmprc) {
> +		fprintf(stderr, "del_mtab: error %d detected on close of tmp file\n",
> +				tmprc);
> +		rc = EX_FILEIO;
> +		goto del_mtab_error;
> +	}
> +
> +	rename(mtabtmpfile, MOUNTED);
> +
> +del_mtab_exit:
> +	unlock_mtab();
> +	free(mtabdir);
> +	return rc;
> +
> +del_mtab_error:
> +	if (unlink(mtabtmpfile))
> +		fprintf(stderr, "del_mtab: failed to delete tmp file - %s\n",
> +				strerror(errno));
> +	goto del_mtab_exit;
> +}
> +
>  /* have the child drop root privileges */
>  static int
>  drop_child_privs(void)
> @@ -2021,8 +2112,15 @@ mount_retry:
>  	}
>  
>  do_mtab:
> -	if (!parsed_info->nomtab && !mtab_unusable())
> +	if (!parsed_info->nomtab && !mtab_unusable()) {
> +		if (parsed_info->flags & MS_REMOUNT) {
> +			rc = del_mtab(mountpoint);
> +			if (rc)
> +				goto mount_exit;
> +		}
> +
>  		rc = add_mtab(orig_dev, mountpoint, parsed_info->flags, fstype);
> +	}
>  
>  mount_exit:
>  	if (parsed_info) {

Looks good. I'll wait a couple of days before merging it in case anyone
else wants to comment, but it should make the next release.

Thanks,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
