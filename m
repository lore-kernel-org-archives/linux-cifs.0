From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Pavel's async i/o CIFS/SMB3 patches
Date: Mon, 20 Feb 2017 16:11:36 -0600
Message-ID: <CAH2r5muZqhZV9TO5CxuhvnDpfhN0u1CAwP-HT9nZBEfqX9Kx=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The two async i/o improvement patches that Pavel posted a week ago:

CIFS: Add asynchronous write support through kernel AIO
and
CIFS: Add asynchronous read support through kernel AIO

at https://github.com/piastry/linux/commits/async

are intriguing.  The performance improvements are fantastic for SMB3
large read/write, and not just to Samba server (look great to Windows,
and should also be great to Mac).   Any review feedback would be
appreciated because async i/o can be complex, yet the value in getting
near maximal i/o performance end to end (over a network fs) is huge
(even to normal users).

I would like to merge these as soon as possible, but want more time
for testing and review feedback - so any feedback on Pavel's patches
would be appreciated.

-- 
Thanks,

Steve
