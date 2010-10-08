From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: on multiuser mount, set ownership to
 current_fsuid/current_fsgid (try #5)
Date: Fri, 8 Oct 2010 07:11:37 -0400
Message-ID: <20101008071137.45a4e27c@corrin.poochiereds.net>
References: <1286477188-26681-1-git-send-email-jlayton@redhat.com>
	<AANLkTimTO_aBJFm==qLkRhXG-LVbMH7CqCdFhkxHAhCB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimTO_aBJFm==qLkRhXG-LVbMH7CqCdFhkxHAhCB-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 7 Oct 2010 22:25:23 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> One case does seem strange - I forgot what happens when you specify a
> mnt_uid of 0 (root)
> 

Oof, you're right... we should base this on CIFS_MOUNT_OVERR_UID and
CIFS_MOUNT_OVERR_GID flags instead. I'll send a fixed patch once I've
tested it.

Now that I think about this though, maybe we shouldn't do this based on
CIFS_MOUNT_MULTIUSER but instead on CIFS_MOUNT_NO_PERM? It would mean
a behavior change for anyone currently "-o noperm" on a mount without
unix extensions but I think it would make a bit more sense than special
casing CIFS_MOUNT_MULTIUSER here.

Thoughts?
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
