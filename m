From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] cifs: NULL dereference on allocation failure
Date: Tue, 24 Jan 2012 07:43:49 -0500
Message-ID: <20120124074349.065af6be@tlielax.poochiereds.net>
References: <20120124083922.GA29097@elgon.mountain>
	<20120124074104.095f8755@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120124074104.095f8755-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 24 Jan 2012 07:41:04 -0500
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On Tue, 24 Jan 2012 11:39:22 +0300
> Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > We should just return directly here, the goto causes a NULL dereference.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > 
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 986709a..026d646 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -3857,10 +3857,8 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
> >  	struct smb_vol *vol_info;
> >  
> >  	vol_info = kzalloc(sizeof(*vol_info), GFP_KERNEL);
> > -	if (vol_info == NULL) {
> > -		tcon = ERR_PTR(-ENOMEM);
> > -		goto out;
> > -	}
> > +	if (vol_info == NULL)
> > +		return ERR_PTR(-ENOMEM);
> >  
> >  	vol_info->local_nls = cifs_sb->local_nls;
> >  	vol_info->linux_uid = fsuid;
> 
> Huh? How so? Here's what "out:" looks like in my tree:
> 
> ---------------[snip]----------------
> out:
>         kfree(vol_info);
> 
>         return tcon;
> ---------------[snip]----------------
> 
> vol_info is NULL, so the kfree is safe. This patch shouldn't break
> anything, but I don't think it's strictly necessary.
> 

Sorry, I was looking at the wrong branch. The patch is correct and
necessary. With the most recent changes, here's what "out:" looks like:

---------------[snip]----------------
out:
        kfree(vol_info->username);
        kfree(vol_info->password);
        kfree(vol_info);
---------------[snip]----------------

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
