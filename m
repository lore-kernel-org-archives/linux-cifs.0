From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs: revalidate directories instiantiated via FIND_* in order to
 handle DFS referrals
Date: Tue, 25 Jun 2013 01:42:44 -0500
Message-ID: <CAH2r5ms41WtzRSMD9F229kFQzVVBu=ymDKd3KHV10UpsjNQX2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looking at this issue at the plugfest this week - the recommendation
is to add a check for ATTR_REPARSE
since this is usually set (for the Windows case) for DFS links (DFS
links are one case of reparse points - but the performance hit for
revalidating all reparse points is not bad).   Tomorrow we can check
for the Samba case in more detail to see how the scenario looks and
whether we can workaround it.

We did find another workaround which could be checked, but decided
against using that one in preference to simply checking for the
reparse attribute.   In the Windows case since you don't create
subdirectories under a DFS link on the server side - the creation time
and last write time of the directory will match for the case of a DFS
link returned by QueryDir or FindFirst (so we also could have refused
to cache directories whose creation time and last write time match -
which would also mean that we don't cache empty subdirectories which
is also a trivial perf hit to not cache those - it would be easy
enough to refuse to cache those directories too if you want).

-- 
Thanks,

Steve
