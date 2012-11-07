From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Convert slashes in the UNC parameter to backslashes
Date: Wed, 7 Nov 2012 13:21:07 -0500
Message-ID: <20121107132107.007a031d@tlielax.poochiereds.net>
References: <509902BB.6020400@innominate.com>
	<20121107070239.1140fe68@tlielax.poochiereds.net>
	<509A7C36.8080800@innominate.com>
	<20121107104853.12935810@tlielax.poochiereds.net>
	<CAFB9KM02kdNwrNVO42r67emTaiRshSB1+sxDOwnOpNwSUyskZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sjayaraman-IBi9RG/b67k@public.gmane.org
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM02kdNwrNVO42r67emTaiRshSB1+sxDOwnOpNwSUyskZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 7 Nov 2012 11:42:12 -0500
Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Nov 7, 2012 at 10:48 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Wed, 07 Nov 2012 16:20:22 +0100
> > Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org> wrote:
> >
> >> Here the corrected (and tested) version.
> >>
> >> Jeff: I agree with you regarding removing the UNC parameter altogether.
> >> Is there any scenario in which an UNC parameter could differ from the
> >> specified source parameter?
> >>
> >> Regards,
> >> Fred
> >>
> >
> > I suppose someone could provide their own unc= option that differs from
> > the device name. At that point, the device name in /proc/mounts (and in
> > programs like "df") might look like you've mounted one location when in
> > reality you've mounted another.
> >
> > That doesn't seem like a valid use-case to me though. It's probably
> > best that we discourage such abuse ;).
> 
> Would this ever be the case when using a DFS mount? 

No.

> I'm not sure how
> that's handled internally to the kernel (I know Samba doesn't provide
> support for multiple servers on a DFS root, but Windows does, IIRC).
> So far as I can tell, in the simple case Samba is a proxy, in the
> complex case, the share is on another server and the original server
> is down.  Does the kernel use the same device in both cases?
> 

I'm not sure what you're asking. Referrals are chased at mount time, or
whenever you wander over them. If there are multiple possible
destinations, I think it just chooses one.

> >
> > The tricky part is how to get there from here. The mount helper
> > provides this option pretty much unconditionally, though it generally
> > generates it from the device string. Maybe something like this?
> >
> > 1) fix the kernel to parse a copy of the UNC out of the device string
> >
> > 2) compare that UNC to the one provided by the unc= option
> >
> > 3) if they differ, then printk a warning that mentions that there is a
> > discrepancy and that the kernel is going to use the value of the unc=
> > option for now, but that we'll change that default in two releases.
> >
> > Something like:
> >
> > "CIFS VFS: the unc= mount option differs from the device passed in. Using
> > the value of the unc= option. The kernel will begin preferring the value
> > in the device string in 3.10!"
> >
> > Then, have a patch ready to go for the 3.10 merge window that will make
> > the kernel start ignoring the value of the unc= option. You might even
> > be nice and keep the comparison and warning around for a little while,
> > but switch it to mention that the kernel is going to ignore the value
> > of the unc= option when there is a discrepancy.
> >
> > In another few releases, we can then get rid of the warning and
> > comparison too.
> >
> > Sound reasonable?
> >
> 
> Would it be reasonable to deprecate the "UNC" / "path" / "target"
> options (they all resolve to OPT_UNC from parse_opt_token()) in
> mount.cifs if the kernel is going to do the heavy lifting?  That would
> break compatibility between mount.cifs and older kernels, though.  I
> guess it doesn't hurt anything to keep passing UNC even if it's not
> being used, other than users not understanding the unexplained
> behavior of the kernel deciding what the actual value of UNC is and
> disregarding their explicit setting of it.  After typing that out, it
> sounds kind of bad.

Eventually, yes...we'd stop the mount helper from providing a unc=
option as well. That said, we'll have to contend with the old kernel +
new userspace problem for quite a while, so that can't happen at the
same time.

The first step is to get the kernel to where it doesn't actually need
the option. Once that's done we can formulate a plan to stop providing
it.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
