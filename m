From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Tue, 9 Oct 2012 10:21:44 -0500
Message-ID: <CAH2r5mvY9SqZ0A7UQ5zmTL99v_YJfv2rxF+bd+D3XXR+foML_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 612a9aab56a93533e76e3ad91642db7033e03b69:

  Merge branch 'drm-next' of
git://people.freedesktop.org/~airlied/linux (2012-10-03 23:29:23
-0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to 72bd481f860f0125c810bb43d878ce5f9c060c58:

  cifs: reinstate the forcegid option (2012-10-07 20:05:47 -0500)

----------------------------------------------------------------
Frediano Ziglio (1):
      Convert properly UTF-8 to UTF-16

Jeff Layton (1):
      cifs: reinstate the forcegid option

Steve French (1):
      [CIFS] WARN_ON_ONCE if kernel_sendmsg() returns -ENOSPC

 fs/cifs/cifs_unicode.c | 22 ++++++++++++++++++++++
 fs/cifs/connect.c      |  9 +++++++++
 fs/cifs/transport.c    |  6 ++++++
 3 files changed, 37 insertions(+)

-- 
Thanks,

Steve
