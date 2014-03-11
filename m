From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] Add oplock_break to smb_version_operations
Date: Tue, 11 Mar 2014 15:05:20 +0000
Message-ID: <1394550320.9706.12.camel@sachin-laptop>
References: <1394198960-7585-1-git-send-email-sprabhu@redhat.com>
	 <1394198960-7585-2-git-send-email-sprabhu@redhat.com>
	 <20140310110640.4df1710a@tlielax.poochiereds.net>
	 <1394468470.2426.21.camel@sachin-laptop>
	 <20140310141632.7759c5e3@ipyr.poochiereds.net>
	 <1394533549.9706.6.camel@sachin-laptop>
	 <20140311070858.0e878e9d@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140311070858.0e878e9d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2014-03-11 at 07:08 -0400, Jeff Layton wrote:
> On Tue, 11 Mar 2014 10:25:49 +0000
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Mon, 2014-03-10 at 14:16 -0400, Jeffrey Layton wrote:
> > > On Mon, 10 Mar 2014 16:21:10 +0000
> > > Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > 
> > > > On Mon, 2014-03-10 at 11:06 -0400, Jeff Layton wrote:
> > > > > On Fri,  7 Mar 2014 13:29:19 +0000
> > > > > Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > > > 
> > > > > > We need to add protocol specific calls to the oplock break thread.
> > > > > > 
> > > > > 
> > > > > I'm not necessarily doubting this, but why? AFAICT, the oplock_break
> > > > > calls look more or less identical...
> > > > 
> > > > The oplock values for level 2 oplocks are different. For the 2nd fix
> > > > to work, we need to downgrade the oplock only once we are sure that no
> > > > writers are operating.
> > > > 
> > > > We need to downgrade oplocks. Since the constants used to describe
> > > > oplock states varies between cifs and smb2, we need to abstract out
> > > > the functions required to downgrade the oplocks. For this we need
> > > > version specific functions. This could either be the oplock_break
> > > > function as a whole or we could define a new function called
> > > > downgrade_oplock() in smb_version_operations. I have chosen to use
> > > > version specific oplock_break here. downgrade_oplock() could instead
> > > > be used here which would require fewer changes.
> > > > 
> > > > Should I implement this using a downgrade_oplock() function instead?
> > > > 
> > > 
> > > I guess I'm unclear on why the set_oplock_level operation (possibly
> > > combined with some new struct smb_version_values fields) wouldn't be a
> > > better solution.
> > > 
> > > I'll grant however that the oplock handing code is a bit of a mess. It
> > > seems like it could benefit from some rethink and redesign...
> > > 
> > 
> > The constants used to denote oplock values are not consistent across the
> > versions
> > 
> > In this case, a level 2 oplock for smb1 is 
> > #define OPLOCK_READ      3  /* level 2 oplock */
> > for smb2, it is
> > #define SMB2_OPLOCK_LEVEL_II            0x01
> > 
> > similarly the values for other states are different too. 
> > 
> > We could abstract these but it sounded like overkill in this situation.
> > 
> > Sachin Prabhu
> > 
> > 
> 
> Yeah, that's the part that's a mess. We have a generic set_oplock_level
> operation but that requires you to pass down oplock levels that are
> version specific. Typically when you have a generic operation, you want
> it to take a set of generic values as arguments.

I have a patch ready with the downgrade_oplock version specific
function. Since this problem leads to data corruption and needs to be
included in stable, I propose we go ahead with this version for now. The
other option to fix the set_oplock_levels() call will require a lot more
changes and may not be suitable for the stable kernels.
Once this issue has been fixed, we can work to fix set_oplock_level and
remove downgrade_oplock().

Sachin Prabhu
