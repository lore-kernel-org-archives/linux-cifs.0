From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] Extract DFS referral expansion to new function in
 cifs_mount
Date: Fri, 1 Apr 2011 11:01:57 -0400
Message-ID: <20110401110157.42a571e6@tlielax.poochiereds.net>
References: <20110401090908.6f96c045@tlielax.poochiereds.net>
	<20110401073256.70180710@tlielax.poochiereds.net>
	<E1Q5dRc-0005je-TI@seldlx2151.corpusers.net>
	<20110401091418.76871d76@tlielax.poochiereds.net>
	<20110401073256.70180710@tlielax.poochiereds.net>
	<E1Q5dRd-0005jh-0Z@seldlx2151.corpusers.net>
	<20110401092717.03b42cfe@tlielax.poochiereds.net>
	<20110401073256.70180710@tlielax.poochiereds.net>
	<E1Q5dRc-0005jZ-Mf@seldlx2151.corpusers.net>
	<20110401090829.5521384b@tlielax.poochiereds.net>
	<20110401142625.GA8348@cobija.connexer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110401142625.GA8348-Znhnm/lQSyjxW5zecs3cv0EOCMrvLtNR@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 1 Apr 2011 16:26:25 +0200
sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org> wrote:

> Hi Jeff,
> 
> Thanks for taking the time with these patches.  I think there's only
> one point where I'll need a further clarification (cifs_sb->mountdata
> as discussed below).  In the meantime, I'll fix up the patches as agreed
> and after clarification I'll resubmit them (making sure that I stop 
> back-dating the messages as well, oops).
> 
> On Fri, Apr 01, 2011 at 09:08:29AM -0400, Jeff Layton wrote:
> > On Fri, 18 Mar 2011 10:02:07 +0100
> > Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org> wrote:
> > 
> > Nit:
> > 
> > It's a good idea to prefix the subject with "cifs:" so that when the
> > patches are committed the subsystem they affect is clear. Makes it
> > easier for people to scan "git log" by eye.
> 
> Will do.
> 
> <snip>
> > >  try_mount_again:
> > > +
> > > +	/* cleanup activities if we're chasing a referral */
> > > +	if (referral_walks_count) {
> > > +		if (tcon)
> > > +			cifs_put_tcon(tcon);
> > > +		else if (pSesInfo)
> > > +			cifs_put_smb_ses(pSesInfo);
> > > +
> > > +		cleanup_volume_info(&volume_info);
> > > +		FreeXid(xid);
> > > +	}
> > >  #endif
> > 
> > It's a little ugly to put error handling code at the top like this, but
> > it's probably ok. We need to do a better job of moving the code out of
> > the CONFIG_CIFS_DFS_UPCALL macro, but that's really beyond the scope of
> > this.
> 
> More cleanup than error-handling, but yeah it does make a top-down read
> a bit awkward.  there's also some similar code pre-existing down at the
> check_mount_failed label.  The alternatives that come to mind are
> 
>  * putting another goto label at the bottom, and goto there instead of
>    try_mount_again, do the cleanup, and then goto try_mount_again
>  * extract the cleanup into another external function and call it before
>    doing a goto try_mount_again
> 
> But I'm happy to let sleeping dogs lie if you're willing to overlook it.
> 

I think it's fine for now. Eventually we probably need to refactor this
code so that we don't have ifdef's sprinkled in the middle of the
function but for now I won't sweat it.

> <snip>
> > Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Noted.
> 
> On Fri, Apr 01, 2011 at 09:09:08AM -0400, Jeff Layton wrote:
> > Thanks for respinning the set, this looks much easier to review. One
> > thing I notice right offhand is that the new code doesn't check to see
> > whether referral_walks_count > MAX_NESTED_LINKS (like the original call
> > site does).
> > 
> > That means the client can loop here indefinitely if there is a referral
> > loop. I think we need that check in there.
> 
> Oops, that wasn't intentional to be removed.  Will restore it.
> 
> On Fri, Apr 01, 2011 at 09:27:17AM -0400, Jeff Layton wrote:
> > On Mon, 28 Mar 2011 12:19:29 +0200
> > Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org> wrote:
> <snip>
> > > @@ -2794,11 +2794,14 @@ expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
> > >  		free_dfs_info_array(referrals, num_referrals);
> > >  		kfree(fake_devname);
> > >  
> > > +		if (cifs_sb->mountdata != NULL)
> > > +			kfree(cifs_sb->mountdata);
> > > +
> > >  		if (IS_ERR(mdata)) {
> > >  			rc = PTR_ERR(mdata);
> > >  			mdata = NULL;
> > >  		}
> > > -		*mount_data = mdata;
> > > +		cifs_sb->mountdata = mdata;
> > >  	}
> > >  	kfree(full_path);
> > >  	return rc;
> > > @@ -2821,6 +2824,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
> > >  #ifdef CONFIG_CIFS_DFS_UPCALL
> > >  	int referral_walks_count = 0;
> > >  try_mount_again:
> > > +	mount_data = cifs_sb->mountdata;
> > >  
> > 
> > 	^^^^
> > With this, the mount_data_global parm to cifs_mount is vestigial. I
> > think you can remove that and just plan to pass in the options via
> > cifs_sb->mountdata.
> 
> But if CONFIG_CIFS_DFS_UPCALL isn't enabled you don't have
> cifs_sb->mountdata in the struct at all, so you'd still need some
> extra #ifdef logic in the caller, right?  I felt the one-liner
> after try_mount_again was clean enough but can do something else if
> you prefer.
> 
> While doing this I was thinking to myself that it might make more sense
> to unconditionally have cifs_sb->mountdata available, and always kstr(n)dup
> it before passing it along instead of the global mountdata option, but felt
> I might be overstepping the scope of what I was originally intending to do.
> What do you think?
> 

Good point. I wasn't thinking about that case.

I think having cifs_sb->mountdata as an unconditional member would be a
better option. We don't generally have *that* many superblocks and it
would be nice to get rid of some #ifdef's. In most cases these strings
are quite small so if someone compiles DFS support out, it won't be
wasting that much memory.

Cheers,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
