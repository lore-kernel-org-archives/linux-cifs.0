From: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH v4 5/6] cifs: Use kstrndup for cifs_sb->mountdata
Date: Fri, 8 Apr 2011 16:28:50 +0200
Message-ID: <20110408142850.GA29937@cobija.connexer.com>
References: <1302100005-1848-1-git-send-email-seanius@seanius.net> <1302100005-1848-5-git-send-email-seanius@seanius.net> <20110408095333.2dab9301@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110408095333.2dab9301-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Apr 08, 2011 at 09:53:33AM -0400, Jeff Layton wrote:
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index fb6a2ad..cf8a610 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -134,24 +134,20 @@ cifs_read_super(struct super_block *sb, void *data,
> >  	cifs_sb->bdi.ra_pages = default_backing_dev_info.ra_pages;
> >  
> >  #ifdef CONFIG_CIFS_DFS_UPCALL
> > -	/* copy mount params to sb for use in submounts */
> > -	/* BB: should we move this after the mount so we
> > -	 * do not have to do the copy on failed mounts?
> > -	 * BB: May be it is better to do simple copy before
> > -	 * complex operation (mount), and in case of fail
> > -	 * just exit instead of doing mount and attempting
> > -	 * undo it if this copy fails?*/
> > +	/*
> > +	 * Copy mount params to sb for use in submounts. Better to do
> > +	 * the copy here and deal with the error before cleanup gets
> > +	 * complicated post-mount.
> > +	 */
> >  	if (data) {
> > -		int len = strlen(data);
> > -		cifs_sb->mountdata = kzalloc(len + 1, GFP_KERNEL);
> > +		cifs_sb->mountdata = kstrndup(data, PAGE_CACHE_SIZE,
> > +					      GFP_KERNEL);
> >  		if (cifs_sb->mountdata == NULL) {
> >  			bdi_destroy(&cifs_sb->bdi);
> >  			kfree(sb->s_fs_info);
> >  			sb->s_fs_info = NULL;
> >  			return -ENOMEM;
> >  		}
> > -		strncpy(cifs_sb->mountdata, data, len + 1);
> > -		cifs_sb->mountdata[len] = '\0';
> >  	}
> >  #endif
> >  
> 
> I was wrong before, and we should be using PAGE_SIZE here instead of
> PAGE_CACHE_SIZE. On all arches that I know of those are equivalent
> currently, but that might not be the case in the future. It might not
> hurt to change that in these patches though if you're respinning them
> anyway.

Okay, no big deal to do so, will update it before I re-submit the patches
on monday.  Thanks for the review!


	sean
