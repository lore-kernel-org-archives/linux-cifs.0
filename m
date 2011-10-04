From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix NT_STATUS_ACCESS_DENIED for mounts with
 prefixpath option
Date: Tue, 4 Oct 2011 13:01:35 +0400
Message-ID: <CAKywueQ1shXsy1rSBJx1H7aD80wg-3=GbvKhLXHeH_nJRz3b2g@mail.gmail.com>
References: <1314341541-2476-1-git-send-email-piastry@etersoft.ru>
	<CAKywueRzwQPROzWTNwhbSOeEanV+Pumn=vFDmYL0uuEApfsX9A@mail.gmail.com>
	<20110830085935.71e671e4@corrin.poochiereds.net>
	<CAKywueSy2tFQC4mxOBZYjiY=PyLjUZ44v+qvtNNg+zKoxJmeCw@mail.gmail.com>
	<20110831140044.5ac4a691@tlielax.poochiereds.net>
	<CAKywueTh-XVrmRH-7AwedShAhmAmFAHs9fsOALrZpkzMhemP=Q@mail.gmail.com>
	<20110831144152.788c2543@tlielax.poochiereds.net>
	<CAKywueQB=xM1Uv=HBpBwHSqbDcq43aBm4gYD_XbUahP9fyy9vA@mail.gmail.com>
	<20110831152247.2f2cfcbd@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110831152247.2f2cfcbd-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sorry for the long delay on this.

2011/8/31 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> If the parent dentry is negative, you mean. Ok, Good point...
>
> Ok, so you're proposing to wrap this check in a big mutex to prevent
> this race when the parent dentry is negative. In the event that it's
> positive though, you'll need to make sure that you take the parent's
> i_mutex.

Yes, that's what I meant.

>
> I don't have a great feel for this sort of dcache trickery, but this
> whole scheme sounds like it's going to break a lot of assumptions about
> how the dcache works. In particular having negative dentries with
> children sounds very problematic.
>
> Would it be better to simply make the initial dentry in this case be a
> disconnected or root dentry (see DCACHE_DISCONNECTED), and then later
> "graft" it into a larger tree if the parent comes to life?
>

I am not sure that I understand you right. As I see what you suggest:

Let's predict we have mounted //server/share/a/ so
1. Dummy superblock root is set to //server/share/a/.
2. Get an inode and a dentry for //server/share/a/.

Then, we mount //server/share/, so
3. Get an inode and a dentry for //server/share/

Then, we reach //server/share/a from the second share, so we need to
find the existing dentry from the first share. We can store all
dentries that pass through cifs_lookup and cifs_get_root with a full
path hash and use them in future when such a path is requested.

Makes sense?

-- 
Best regards,
Pavel Shilovsky.
