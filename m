From: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
Subject: Re: [PATCH 05/17] Remove the automount through follow_link()
 kludge code from pathwalk
Date: Sun, 10 Oct 2010 09:16:12 +0800
Message-ID: <1286673372.3691.14.camel@localhost>
References: <20100930181455.30939.53914.stgit@warthog.procyon.org.uk>
	 <20100930181521.30939.31415.stgit@warthog.procyon.org.uk>
	 <20101008234130.GE30846@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org,
	jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	autofs-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Valerie Aurora <vaurora-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101008234130.GE30846@shell>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2010-10-08 at 19:41 -0400, Valerie Aurora wrote:
> On Thu, Sep 30, 2010 at 07:15:21PM +0100, David Howells wrote:
> > Remove the automount through follow_link() kludge code from pathwalk in favour
> > of using d_automount().
> > 
> > Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Acked-by: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
> > ---
> > 
> >  fs/namei.c |   17 +++--------------
> >  1 files changed, 3 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/namei.c b/fs/namei.c
> > index c50b9d7..86421f9 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -861,17 +861,6 @@ fail:
> >  }
> >  
> >  /*
> > - * This is a temporary kludge to deal with "automount" symlinks; proper
> > - * solution is to trigger them on follow_mount(), so that do_lookup()
> > - * would DTRT.  To be killed before 2.6.34-final.
> > - */
> > -static inline int follow_on_final(struct inode *inode, unsigned lookup_flags)
> > -{
> > -	return inode && unlikely(inode->i_op->follow_link) &&
> > -		((lookup_flags & LOOKUP_FOLLOW) || S_ISDIR(inode->i_mode));
> > -}
> > -
> > -/*
> >   * Name resolution.
> >   * This is the basic name resolution function, turning a pathname into
> >   * the final dentry. We expect 'base' to be positive and a directory.
> > @@ -991,7 +980,8 @@ last_component:
> >  		if (err)
> >  			break;
> >  		inode = next.dentry->d_inode;
> > -		if (follow_on_final(inode, lookup_flags)) {
> > +		if (inode && unlikely(inode->i_op->follow_link) &&
> > +		    (lookup_flags & LOOKUP_FOLLOW)) {
> >  			err = do_follow_link(&next, nd);
> >  			if (err)
> >  				goto return_err;
> > @@ -1882,8 +1872,7 @@ reval:
> >  		struct inode *inode = path.dentry->d_inode;
> >  		void *cookie;
> >  		error = -ELOOP;
> > -		/* S_ISDIR part is a temporary automount kludge */
> > -		if (!(nd.flags & LOOKUP_FOLLOW) && !S_ISDIR(inode->i_mode))
> > +		if (!(nd.flags & LOOKUP_FOLLOW))
> >  			goto exit_dput;
> >  		if (count++ == 32)
> >  			goto exit_dput;
> 
> While you're removing kludges, I bet you can also remove this from
> __follow_link():
> 
>        if (path->mnt != nd->mnt) {
>                path_to_nameidata(path, nd);
>                dget(dentry);
>        }
>        mntget(path->mnt);
> 
> And replace with:
> 
>        if (path->mnt == nd->mnt)
>                mntget(path->mnt);
> 
> This reverts the non-helper-function parts of
> 051d381259eb57d6074d02a6ba6e90e744f1a29f, which breaks union mounts.

Yeah, I was thinking of including it as a separate patch but thought it
best to leave it until after we got feedback on the patch series.

Folding it into this patch just didn't occur to me, but then that change
was done long before the kluge this reverts so maybe including it would
have caused some mild confusion and distracted focus away from the main
task of the series.

Clearly this change can now also be reverted without affecting autofs4,
as an independent patch or as a patch included in the union mounts
series.

David, thoughts?
Ian
