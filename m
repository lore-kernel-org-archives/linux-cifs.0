From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fix
Date: Wed, 19 Apr 2017 18:09:29 -0500
Message-ID: <CAH2r5ms93eWY5+YnGbMn4n1Qh6iCj_O7crCi3Dye-Ek-u+6nhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

One more cifs fix for stable.

Please pull the following changes since commit
4f7d029b9bf009fbee76bb10c0c4351a1870d2f3:

  Linux 4.11-rc7 (2017-04-16 13:00:18 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 62a6cfddcc0a5313e7da3e8311ba16226fe0ac10:

  cifs: Do not send echoes before Negotiate is complete (2017-04-17
15:44:23 -0500)

----------------------------------------------------------------
Sachin Prabhu (1):
      cifs: Do not send echoes before Negotiate is complete

 fs/cifs/smb1ops.c | 10 ++++++++++
 1 file changed, 10 insertions(+)


-- 
Thanks,

Steve
