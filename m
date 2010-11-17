From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: add attribute cache timeout (actimeo) tunable
Date: Wed, 17 Nov 2010 14:39:36 -0500
Message-ID: <20101117143936.0474a2a6@tlielax.poochiereds.net>
References: <1290018214-9415-1-git-send-email-sjayaraman@suse.de>
	<20101117133919.07f9f0db@tlielax.poochiereds.net>
	<4CE429F8.6070105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CE429F8.6070105-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 18 Nov 2010 00:46:08 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 11/18/2010 12:09 AM, Jeff Layton wrote:
> > On Wed, 17 Nov 2010 23:53:34 +0530
> > Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> > 
> >> Currently, the attribute cache timeout for CIFS is hardcoded to 1 second. This
> >> means that the client might have to issue a QPATHINFO/QFILEINFO call every 1
> >> second to verify if something has changes, which seems too expensive. On the
> >> other hand, if the timeout is hardcoded to a higher value, workloads that
> >> expect strict cache coherency might see unexpected results.
> >>
> >> Making attribute cache timeout as a tunable will allow us to make a tradeoff
> >> between performance and cache metadata correctness depending on the
> >> application/workload needs.
> >>
> >> Add 'actimeo' tunable that can be used to tune the attribute cache timeout.
> >> The default timeout is set to 1 second.
> >>
> >> Also, display actimeo option value in /proc/mounts.
> >>
> >> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> >> ---
> >>  fs/cifs/cifs_fs_sb.h |    1 +
> >>  fs/cifs/cifsfs.c     |    1 +
> >>  fs/cifs/cifsglob.h   |    5 +++++
> >>  fs/cifs/connect.c    |   10 ++++++++++
> >>  fs/cifs/inode.c      |    6 +++---
> >>  5 files changed, 20 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> >> index ff7d299..f30700d 100644
> >> --- a/fs/cifs/inode.c
> >> +++ b/fs/cifs/inode.c
> >> @@ -1648,6 +1648,7 @@ static bool
> >>  cifs_inode_needs_reval(struct inode *inode)
> >>  {
> >>  	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
> >> +	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
> >>  
> >>  	if (cifs_i->clientCanCacheRead)
> >>  		return false;
> >> @@ -1658,12 +1659,11 @@ cifs_inode_needs_reval(struct inode *inode)
> >>  	if (cifs_i->time == 0)
> >>  		return true;
> >>  
> >> -	/* FIXME: the actimeo should be tunable */
> >> -	if (time_after_eq(jiffies, cifs_i->time + HZ))
> >> +	if (time_after_eq(jiffies, cifs_i->time + (cifs_sb->actimeo * HZ)))
> > 
> > 	Problem:
> > 
> > 	Suppose (cifs_i->time + (cifs_sb->actimeo * HZ)) carries you
> > 	past two sign bit changes. At that point, it may look like
> > 	the resulting time is in the past, not the future.
> 
> Good catch.
> 
> > 	You actually do need to impose a limit here. I suggest looking
> > 	very closely at time_before/time_after macros. It'll also be
> > 	easier to deal storing actimeo in terms of jiffies instead of
> > 	seconds.
> 
> > 	Finally, this value needs to be displayed in /proc/mounts.
> > 
> 
> Did you mean displaying values in jiffies in /proc/mounts? Wouldn't it
> be confusing for users to see such a higher numbers (usually) when they
> had used a simple 2 digit number for e.g. during mount?
> 
> 
> 

No, you'll want to display it in seconds in /proc/mounts so that it
matches the option that the user specified. So there you'll need to
display (cifs_sb->actimeo / HZ).

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
