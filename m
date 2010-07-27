From: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
Subject: Re: [PATCH 1/6] Add a dentry op to handle automounting rather than
 abusing follow_link() [ver #2]
Date: Tue, 27 Jul 2010 11:43:45 +0800
Message-ID: <1280202225.2944.20.camel@localhost>
References: <1280157768.3569.14.camel@localhost>
	 <1279944664.2944.8.camel@localhost>
	 <20100722175847.5552.11520.stgit@warthog.procyon.org.uk>
	 <17723.1279897759@redhat.com> <9168.1280153997@redhat.com>
	 <30118.1280159695@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <30118.1280159695-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2010-07-26 at 16:54 +0100, David Howells wrote:
> Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org> wrote:
> 
> > > Does it make autofs easier if d_op->d_automount() is allowed to return
> > > -EXDEV to request this?  Then you can return it in Oz mode to allow the
> > > daemon to see/use the underlying mountpoint without recursing back into
> > > d_automount().
> > 
> > Yes, it's really useful.
> 
> I think what's required, then, is if d_automount() returns -EXDEV then:
> 
>  (1) If the dentry is terminal in the lookup path, then we just return -EXDEV
>      to indicate to __follow_mount() that we really do want to stop there.
> 
>  (2) If the dentry is not terminal, then we convert the error to -EREMOTE to
>      indicate that we can't complete the pathwalk as one of the earlier
>      components is inaccessible.

Is this something others need?

Again, the exists vs not yet exists case for paths within indirect
autofs mounts. At the moment I can just set the flag on all dentrys in
the autofs fs and return EXDEV for non-empty directories in order to
return the dentry as a path component. OTOH if the dentry is a mount
embeded in the path and the mount fails we get a error return.

I could clear the flag on non-root parent dentrys during mkdir if this
is needed by others.
  
> 
> See the attached patch.
> 
> David
> ---
> diff --git a/fs/namei.c b/fs/namei.c
> index c154112..6c385d4 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -653,8 +653,20 @@ static int follow_automount(struct path *path, unsigned flags, int res)
>  		return -ELOOP;
>  
>  	mnt = path->dentry->d_op->d_automount(path);
> -	if (IS_ERR(mnt))
> +	if (IS_ERR(mnt)) {
> +		/*
> +		 * The filesystem is allowed to return -EXDEV here to indicate
> +		 * they don't want to automount.  For instance, autofs would do
> +		 * this so that its userspace daemon can mount on this dentry.
> +		 *
> +		 * However, we can only permit this if it's a terminal point in
> +		 * the path being looked up; if it wasn't then the remainder of
> +		 * the path is inaccessible and we should say so.
> +		 */
> +		if (PTR_ERR(mnt) == -EXDEV && (flags & LOOKUP_CONTINUE))
> +			return -EREMOTE;
>  		return PTR_ERR(mnt);
> +	}
>  	if (!mnt) /* mount collision */
>  		return 0;
>  
> 
