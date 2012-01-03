From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: Properly update mtab during remount V2
Date: Tue, 3 Jan 2012 07:22:29 -0500
Message-ID: <20120103072229.3cb43bf4@tlielax.poochiereds.net>
References: <1325178125-13884-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325178125-13884-1-git-send-email-cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 29 Dec 2011 15:02:05 -0200
Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> During a remount of a cifs filesystem, the mtab file is not properly updated, which
> leads to a doubled entry of the same filesystem in the /etc/mtab file. This patch
> adds a new function del_mtab() which is called before the add_mtab() in case the fs
> is being remounted.
> The del_mtab() function will delete from the mtab, the old entry from the filesystem which
> is being remounted, and then, calls add_mtab() to add an updated entry to the mtab file.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mount.cifs.c |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 102 insertions(+), 0 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 147f7fc..d9bf0b9 100644
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
> +#define MNT_TMP_FILE "/.mtab.tmp.XXXXXX"
>  
>  /* struct for holding parsed mount info for use by privleged process */
>  struct parsed_mount_info {
> @@ -1624,6 +1626,101 @@ add_mtab_exit:
>  	return rc;
>  }
>  
> +static int
> +del_mtab(char *mountpoint)
> +{
> +	int fd, tmprc, rc = 0;
> +	FILE *mnttmp, *mntmtab;
> +	struct mntent *mountent;
> +	struct stat statbuf;
> +	char *mtabfile, *mtabdir, *tmpfile;
> +
> +	mtabfile = strdup(MOUNTED);

This looks like a buffer overrun. Here, you're strduping MOUNTED...

> +	mtabdir = dirname(mtabfile);

Then altering that string to get the dirname...

> +	if (!mtabdir) {
> +		fprintf(stderr, "del_mtab: cannot determine current mtab path");
> +		rc = EX_FILEIO;
> +		goto del_mtab_exit;
> +	}
> +
> +	tmpfile = strcat(mtabdir, MNT_TMP_FILE);

Then using strcat to append MNT_TMP_FILE to mtabdir. But, won't that be
longer than the original string that you strdup'ed?

> +
> +	atexit(unlink(tmpfile));
> +	tmpfile = mktemp(tmpfile);
> +	if (!tmpfile) {
> +		fprintf(stderr, "del_mtab: cannot setup tmp file destination");
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
> +	mntmtab = setmntent(MOUNTED, "r");
> +	if (!mntmtab) {
> +		fprintf(stderr, "del_mtab: could not update mount table\n");
> +		rc = EX_FILEIO;
> +		goto del_mtab_exit;
> +	}
> +
> +	mnttmp = setmntent(tmpfile, "w");
> +	if (!mnttmp) {
> +		fprintf(stderr, "del_mtab: could not update mount table\n");
> +		endmntent(mntmtab);
> +		rc = EX_FILEIO;
> +		goto del_mtab_exit;
> +	}
> +
> +	fd = fileno(mntmtab);
> +	if (fd < 0) {
> +		fprintf(stderr, "del_mtab: mntent does not appear to be valid\n");
> +		endmntent(mntmtab);
> +		endmntent(mnttmp);
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
> +			ftruncate(fd, statbuf.st_size);

			^^^^^^^^^^^^
			At this point, statbuf is full of leftover stack
			junk. You're going to truncate it to an unknown
			value here since you haven't fstat'ed it yet.

			In any case, there's no reason to truncate the
			original mnttab here. You aren't altering it.
			Won't that potentially fail since you opened it
			"r" anyway?

> +			rc = EX_FILEIO;
> +			break;
> +		}
> +	}
> +
> +	rc = fstat(fd, &statbuf);
> +	if (rc != 0) {
> +		fprintf(stderr, "del_mtab: unable to fstat open mtab\n");
> +		endmntent(mntmtab);
> +		endmntent(mnttmp);
> +		rc = EX_FILEIO;
> +		goto del_mtab_exit;
> +	}
> +
> +	tmprc = my_endmntent(mntmtab, statbuf.st_size);
> +	if (tmprc) {
> +		fprintf(stderr, "del_mtab: error %d detected on close of mtab\n", tmprc);
> +		rc = EX_FILEIO;
> +	}

You probably don't need to use my_endmntent here since the original
mtab isn't being altered, just replaced.

> +	endmntent(mnttmp);

You should however fflush the mnttmp stream, and fsync that fd before
you replace the mtab. You could use my_endmntent for that, but there's
no need to truncate if that fails -- you'll just want to delete the
tmpfile in that case and return an error (right?).

> +
> +	rename(tmpfile, MOUNTED);
> +	unlink(tmpfile);
> +
> +del_mtab_exit:
> +	unlock_mtab();
> +	return rc;
> +}
> +
>  /* have the child drop root privileges */
>  static int
>  drop_child_privs(void)
> @@ -2021,6 +2118,11 @@ mount_retry:
>  	}
>  
>  do_mtab:
> +	if (parsed_info->flags & MS_REMOUNT){
> +		rc = del_mtab(mountpoint);
> +		if (rc)
> +			goto mount_exit;
> +	}
>  	if (!parsed_info->nomtab && !mtab_unusable())
>  		rc = add_mtab(orig_dev, mountpoint, parsed_info->flags, fstype);
>  


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
