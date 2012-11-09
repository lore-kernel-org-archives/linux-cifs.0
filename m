From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Convert slashes in the UNC parameter to backslashes
Date: Fri, 9 Nov 2012 06:19:53 -0500
Message-ID: <20121109061953.2bb49e68@tlielax.poochiereds.net>
References: <509902BB.6020400@innominate.com>
	<20121107070239.1140fe68@tlielax.poochiereds.net>
	<509A7C36.8080800@innominate.com>
	<20121107104853.12935810@tlielax.poochiereds.net>
	<CAFB9KM02kdNwrNVO42r67emTaiRshSB1+sxDOwnOpNwSUyskZQ@mail.gmail.com>
	<20121107132107.007a031d@tlielax.poochiereds.net>
	<509BA299.4000805@innominate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sjayaraman-IBi9RG/b67k@public.gmane.org
To: Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <509BA299.4000805-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 08 Nov 2012 13:16:25 +0100
Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org> wrote:

> 
> 
> On 11/07/2012 07:21 PM, Jeff Layton wrote:
> >>>
> >>> The tricky part is how to get there from here. The mount helper
> >>> provides this option pretty much unconditionally, though it generally
> >>> generates it from the device string. Maybe something like this?
> >>>
> >>> 1) fix the kernel to parse a copy of the UNC out of the device string
> >>>
> >>> 2) compare that UNC to the one provided by the unc= option
> >>>
> >>> 3) if they differ, then printk a warning that mentions that there is a
> >>> discrepancy and that the kernel is going to use the value of the unc=
> >>> option for now, but that we'll change that default in two releases.
> >>>
> >>> Something like:
> >>>
> >>> "CIFS VFS: the unc= mount option differs from the device passed in. Using
> >>> the value of the unc= option. The kernel will begin preferring the value
> >>> in the device string in 3.10!"
> >>>
> >>> Then, have a patch ready to go for the 3.10 merge window that will make
> >>> the kernel start ignoring the value of the unc= option. You might even
> >>> be nice and keep the comparison and warning around for a little while,
> >>> but switch it to mention that the kernel is going to ignore the value
> >>> of the unc= option when there is a discrepancy.
> >>>
> >>> In another few releases, we can then get rid of the warning and
> >>> comparison too.
> >>>
> >>> Sound reasonable?
> >>>
> >>
> >> Would it be reasonable to deprecate the "UNC" / "path" / "target"
> >> options (they all resolve to OPT_UNC from parse_opt_token()) in
> >> mount.cifs if the kernel is going to do the heavy lifting?  That would
> >> break compatibility between mount.cifs and older kernels, though.  I
> >> guess it doesn't hurt anything to keep passing UNC even if it's not
> >> being used, other than users not understanding the unexplained
> >> behavior of the kernel deciding what the actual value of UNC is and
> >> disregarding their explicit setting of it.  After typing that out, it
> >> sounds kind of bad.
> >
> > Eventually, yes...we'd stop the mount helper from providing a unc=
> > option as well. That said, we'll have to contend with the old kernel +
> > new userspace problem for quite a while, so that can't happen at the
> > same time.
> >
> > The first step is to get the kernel to where it doesn't actually need
> > the option. Once that's done we can formulate a plan to stop providing
> > it.
> >
> 
> I came across this issue precisely because I was using a mount helper 
> different than samba (busybox, to be precise.) Thus, the unc parameter 
> was being passed in a slightly different way and thus an error message 
> resulted. This is to say that, if we radically changed the 
> unc/path/target options interface, it would most likely break existing 
> mount implementations.
> 
> I suggest that we just copy the device name as UNC in the parse_options 
> function and ignore whatever the user had provided explicitly without 
> issuing any warnings. I personally like warnings, but the current 
> situation is that this option is implicitly passed by the mount helper, 
> and thus it would most likely confuse users more than it helps them.
> 
> Please let me know what you think. I can quickly provide a tested patch, 
> if you agree to the course of action.
> 

I think we need to be extra cautious with any change in behavior of a
userland interface.

In practice the mount helper assembles the unc= option from the content
of the device string. If someone is using the standard mount.cifs
helper, then it's not likely they'll ever see this warning (assuming we
code up the logic correctly of course).

In the unlikely case that someone is passing in a unc= option that does
not match the device string, then I think the responsible thing is to
warn them that they can expect the behavior to change in the future.

The custom in kernel changes is to warn for two releases before
changing the behavior of a userland interface. If you have the patches
to give the warning ready to go for 3.8, then we can change that
behavior in 3.10

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
