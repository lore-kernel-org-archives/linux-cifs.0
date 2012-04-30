From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/4] cifs: pave way for change to "strictcache" by
 default
Date: Mon, 30 Apr 2012 11:45:47 -0400
Message-ID: <20120430114547.3c9580c1@corrin.poochiereds.net>
References: <1335524179-1671-1-git-send-email-jlayton@redhat.com>
	<20120430072846.69d489aa@corrin.poochiereds.net>
	<CAH2r5msnmF0d_bmctzKtzSQ-+y9VRa2=USDO8kV=QF9KV+J=7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msnmF0d_bmctzKtzSQ-+y9VRa2=USDO8kV=QF9KV+J=7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 30 Apr 2012 10:11:43 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> There is a related question of how deferring writes slightly (e.g. to
> buffer a full page or a full smb buffer) could corrupt data?
> 

You're returning from write(2) without actually sending it to the
backing store, but a read(2) will go to that backing store. So,
applications that expect the results of that write to be visible to
other clients (or even on the same client) won't see it.

> AFAIK - there isn't an ordering guarantee in posix when writes from
> two different applications overlap (thus the need for byte range locks
> or other synchronization mechanisms, or flush/fsync).
> 

Correct, there isn't, but even locking doesn't really help with cifs.ko
since it doesn't treat locks as cache coherency points like the nfs
client does. Even if it did though, the NFS cache coherency model is not
necessarily something we want to emulate. It's pretty fragile itself.
Coarse-grained timestamps on the underlying fs can easily break it for
instance.

To compound the problem, windows servers tend to be quite lazy about
mtime updates. So even if you do proper locking, there's no guarantee
that the "loose" cache coherency algorithm in cifs.ko will detect that
the file has changed. Another client might do some writes but the mtime
doesn't necessarily change as a result.

I'm certainly aware that this might slow down performance in some
cases. Those people however can always switch to the less-safe
cache=loose if they wish. By default however, we should attempt to
follow the letter of the protocol as best we can...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
