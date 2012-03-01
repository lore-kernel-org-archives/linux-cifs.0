From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: MaxMpx and Blocking Locks
Date: Thu, 1 Mar 2012 16:30:48 -0600
Message-ID: <CAH2r5mvXFjDG=eX4xp49d6QNBfD_r1OxdDSkj9bDbmUKKGrKAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

FYI - There was followup discussion after the dochelp response,
explaining some of the quirks, and some still open questions (about
why Windows doesn't return an error as implied, for example).

My concern remains that we don't want to make things worse with the
fix (opening up deadlocks or data integrity issues) so I would prefer
to  allow SMB Echo through (since it works to all known servers with
MaxMpx 10 or greater, and the alternative, not sending it, may cause
the session to drop and make things worse). Chris Hertel had an
interesting suggestion (he may be able to describe it in more detail)
though for limiting blocking locks to avoid blocking locks "starving"
the available mpx (which are needed for read and write etc.).   I had
suggested limiting outstanding blocking locks to MaxMpx - 2 (or
something similar) - Chris suggested that the client instead use
MaxMpx/2 as a maximum for blocking locks to avoid "starving" the
system (and e.g. deadlocking when we have to do writeback).  This
would involve us keeping a counter of outstanding blocking locks in
the session structure.  This shouldn't slow performance much because a
simple atomic counter could be used and is probably good enough for an
approximation of the current pending locks (it would not require an
expensive semaphore or spinlock).

-- 
Thanks,

Steve
