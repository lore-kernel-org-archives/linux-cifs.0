From: =?UTF-8?Q?F=C3=A9lix_C=2E_Morency?= <felix.morency-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: CIFS multiuser without active user session
Date: Fri, 7 Apr 2017 12:15:41 -0400
Message-ID: <CAG=jP7j_GRD0v=eq=iDWCC9LHG3=7CEZDU6ds4Bre2_wBhjFPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

Is there a way to use the CIFS multiuser feature on computers without
an active user session (ie. cron or compute nodes running jobs)?

So far, I attempted to use `cifscreds`, but the credentials expire if
I'm not actively logged on all computers. I also attempted to mount
using `-o credentials=/someCredFile,uid=$UID,gid=$GID,multiuser` but
it doesn't work either.

Thanks,
-F
