From: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: Properly update mtab during remount
Date: Thu, 29 Dec 2011 09:00:57 -0200
Message-ID: <20111229110057.GA18191@andromeda.usersys.redhat.com>
References: <1325042532-5500-1-git-send-email-cmaiolino@redhat.com>
 <20111228211801.42d548ee@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111228211801.42d548ee-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> > During a remount of a cifs filesystem, the mtab file is not properly updated, which
> > leads to a doubled entry of the same filesystem in the /etc/mtab file. This patch
> > adds a new function del_mtab() which is called before the add_mtab() in case the fs
> > is being remounted.
> > The del_mtab() function will delete from the mtab, the old entry from the filesystem which
> > is being remounted, and then, calls add_mtab() to add an updated entry to the mtab file.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  mount.cifs.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 81 insertions(+), 0 deletions(-)
> > 
> > diff --git a/mount.cifs.c b/mount.cifs.c
> > index 147f7fc..6535b40 100644
> > --- a/mount.cifs.c
> > +++ b/mount.cifs.c
> > @@ -161,6 +161,7 @@
> >  #define OPT_BKUPUID    30
> >  #define OPT_BKUPGID    31
> >  
> > +#define MNT_TMP_PATH "/tmp/mtab.tmp"
> >  
> >  /* struct for holding parsed mount info for use by privleged process */
> >  struct parsed_mount_info {
> > @@ -1624,6 +1625,81 @@ add_mtab_exit:
> >  	return rc;
> >  }
> >  
> > +static int
> > +del_mtab(char *devname, char *mountpoint)
> > +{
> > +	int fd, tmprc, rc = 0;
> > +	FILE *mnttmp, *mntmtab;
> > +	struct mntent *mountent;
> > +	struct stat statbuf;
> > +
> > +	rc = lock_mtab();
> > +	if(rc) {
> > +		fprintf(stderr, "del_mtab: cannot lock mtab");
> > +		rc = EX_FILEIO;
> > +		goto del_mtab_exit;
> > +	}
> > +
> > +	mntmtab = setmntent(MOUNTED, "r");
> > +	if (!mntmtab) {
> > +		fprintf(stderr, "del_mtab: could not update mount table\n");
> > +		rc = EX_FILEIO;
> > +		goto del_mtab_exit;
> > +	}
> > +
> > +	mnttmp = setmntent(MNT_TMP_PATH, "w");
> > +	if (!mnttmp) {
> > +		fprintf(stderr, "del_mtab: could not update mount table\n");
> > +		endmntent(mntmtab);
> > +		rc = EX_FILEIO;
> > +		goto del_mtab_exit;
> > +	}
> > +
> > +	fd = fileno(mntmtab);
> > +	if (fd < 0) {
> > +		fprintf(stderr, "mntent does not appear to be valid\n");
> > +		endmntent(mntmtab);
> > +		endmntent(mnttmp);
> > +		rc = EX_FILEIO;
> > +		goto del_mtab_exit;
> > +	}
> > +
> > +	while((mountent = getmntent(mntmtab)) != NULL){
> > +		if(!strcmp(mountent->mnt_dir,mountpoint))
> > +			continue;
> > +		rc = addmntent(mnttmp, mountent);
> > +		if (rc) {
> > +			fprintf(stderr, "unable to add mount entry to mtab\n");
> > +			ftruncate(fd, statbuf.st_size);
> > +			rc = EX_FILEIO;
> > +			break;
> > +		}
> > +	}
> > +
> > +	rc = fstat(fd, &statbuf);
> > +	if (rc != 0) {
> > +		fprintf(stderr, "unable to fstat open mtab\n");
> > +		endmntent(mntmtab);
> > +		endmntent(mnttmp);
> > +		rc = EX_FILEIO;
> > +		goto del_mtab_exit;
> > +	}
> > +
> > +	tmprc = my_endmntent(mntmtab, statbuf.st_size);
> > +	if (tmprc) {
> > +		fprintf(stderr, "error %d detected on close of mtab\n", tmprc);
> > +		rc = EX_FILEIO;
> > +	}
> > +	endmntent(mnttmp);
> > +
> > +	rename(MNT_TMP_PATH, MOUNTED);
> 
> You seem to me making the assumption that MNT_TMP_PATH and MOUNTED are
> on the same filesystem. That's not necessarily (or even commonly) the
> case. If you want to do this, you'll probably want to make sure they
> are on the same filesystem.
> 

Hi, I didn't notice rename() shall not cross filesystem boundaries, Would
be better to set the MNT_TMP_PATH to a file into /etc? Maybe a hidden file
like /etc/.mtab.tmp?

> > +	unlink(MNT_TMP_PATH);
> > +
> > +del_mtab_exit:
> > +	unlock_mtab();
> > +	return rc;
> > +}
> > +
> >  /* have the child drop root privileges */
> >  static int
> >  drop_child_privs(void)
> > @@ -2021,6 +2097,11 @@ mount_retry:
> >  	}
> >  
> >  do_mtab:
> > +	if(parsed_info->flags & MS_REMOUNT){
>        ^^^^^^
>     nit: we try to follow kernel coding style in this code...
>    
> > +		rc = del_mtab(orig_dev, mountpoint);
> > +		if(rc)
> > +			goto mount_exit;
> > +	}
> >  	if (!parsed_info->nomtab && !mtab_unusable())
> >  		rc = add_mtab(orig_dev, mountpoint, parsed_info->flags, fstype);
> >  
> 
> Patch looks reasonable otherwise. Nice work...
> 
> Note too, that remounts in the kernel cifs code are quite broken. It
> always returns 0 without ever actually changing anything. It would be
> helpful to fix that as well...
> 
I'll add that to my TODO list.


I'm rewriting the patch with the changes required and should re-send it soon. Thanks
for the review.

-- 
--Carlos
