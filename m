From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] mtab: handle ENOSPC condition properly when altering
 mtab
Date: Tue, 12 Jul 2011 13:25:51 +0530
Message-ID: <4E1BFE07.5060309@suse.de>
References: <1310138300-6694-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1310138300-6694-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/08/2011 08:48 PM, Jeff Layton wrote:
> It's possible that when mount.cifs goes to append the mtab that there
> won't be enough space to do so, and the mntent won't be appended to the
> file in its entirety.
> 
> Add a my_endmntent routine that will fflush and then fsync the FILE if
> that succeeds. If either fails then it will truncate the file back to
> its provided size. It will then call endmntent unconditionally.
> 
> Have add_mtab call fstat on the opened mtab file in order to get the
> size of the file before it has been appended. Assuming that that
> succeeds, use my_endmntent to ensure that the file is not corrupted
> before closing it. It's possible that we'll have a small race window
> where the mtab is incorrect, but it should be quickly corrected.
> 
> This was reported some time ago as CVE-2011-1678:
> 
>     http://openwall.com/lists/oss-security/2011/03/04/9
> 
> ...and it seems to fix the reproducer that I was able to come up with.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.c |   26 ++++++++++++++++++++++++--
>  mount.h      |    1 +
>  mtab.c       |   27 +++++++++++++++++++++++++++
>  3 files changed, 52 insertions(+), 2 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 9d7e107..2026329 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1428,10 +1428,11 @@ static int check_mtab(const char *progname, const char *devname,
>  static int
>  add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstype)
>  {
> -	int rc = 0;
> +	int rc = 0, tmprc, fd;
>  	uid_t uid;
>  	char *mount_user = NULL;
>  	struct mntent mountent;
> +	struct stat statbuf;
>  	FILE *pmntfile;
>  	sigset_t mask, oldmask;
>  
> @@ -1483,6 +1484,23 @@ add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstyp
>  		goto add_mtab_exit;
>  	}
>  
> +	fd = fileno(pmntfile);
> +	if (fd < 0) {
> +		fprintf(stderr, "mntent does not appear to be valid\n");
> +		unlock_mtab();
> +		rc = EX_FILEIO;
> +		goto add_mtab_exit;
> +	}
> +
> +	rc = fstat(fd, &statbuf);
             ^^^ perhaps using fseek() + ftell() is little less
expensive as we just need the size?

Also, now glibc has fixed addmntent() to do fflush() with:
  http://sourceware.org/git/?p=glibc.git;a=commitdiff;h=e1fb097f44

Might be just sufficient to do a ftruncate() when addmntent() fails?

> +	if (rc != 0) {
> +		fprintf(stderr, "unable to fstat open mtab\n");
> +		endmntent(pmntfile);
> +		unlock_mtab();
> +		rc = EX_FILEIO;
> +		goto add_mtab_exit;
> +	}
> +
>  	mountent.mnt_fsname = devname;
>  	mountent.mnt_dir = mountpoint;
>  	mountent.mnt_type = (char *)(void *)fstype;
> @@ -1516,7 +1534,11 @@ add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstyp
>  		fprintf(stderr, "unable to add mount entry to mtab\n");
>  		rc = EX_FILEIO;
>  	}
> -	endmntent(pmntfile);
> +	tmprc = my_endmntent(pmntfile, statbuf.st_size);
> +	if (tmprc) {
> +		fprintf(stderr, "error %d detected on close of mtab\n", tmprc);
> +		rc = EX_FILEIO;
> +	}
>  	unlock_mtab();
>  	SAFE_FREE(mountent.mnt_opts);
>  add_mtab_exit:
> diff --git a/mount.h b/mount.h
> index d49c2ea..80bdbe7 100644
> --- a/mount.h
> +++ b/mount.h
> @@ -35,5 +35,6 @@
>  extern int mtab_unusable(void);
>  extern int lock_mtab(void);
>  extern void unlock_mtab(void);
> +extern int my_endmntent(FILE *stream, off_t size);
>  
>  #endif /* ! _MOUNT_H_ */
> diff --git a/mtab.c b/mtab.c
> index 9cd50d8..de545b7 100644
> --- a/mtab.c
> +++ b/mtab.c
> @@ -251,3 +251,30 @@ lock_mtab (void) {
>  	return 0;
>  }
>  
> +/*
> + * Call fflush and fsync on the mtab, and then endmntent. If either fflush
> + * or fsync fails, then truncate the file back to "size". endmntent is called
> + * unconditionally, and the errno (if any) from fflush and fsync are returned.
> + */
> +int
> +my_endmntent(FILE *stream, off_t size)
> +{
> +	int rc, fd;
> +
> +	fd = fileno(stream);
> +	if (fd < 0)
> +		return -EBADF;
> +
> +	rc = fflush(stream);
> +	if (!rc)
> +		rc = fsync(fd);
> +
> +	/* truncate file back to "size" -- best effort here */
> +	if (rc) {
> +		rc = errno;
> +		ftruncate(fd, size);
> +	}
> +
> +	endmntent(stream);
> +	return rc;
> +}


-- 
Suresh Jayaraman
