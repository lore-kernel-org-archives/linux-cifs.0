From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 7 Nov 2011 11:45:07 -0600
Message-ID: <CAH2r5mtTYYHato2J2ZxNGvArNqEJ-CrUf4-p7+7Z8a0Zx0fe6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 1a67a573b8d9f02211f36fbab50f6265dc49384a:
  Linus Torvalds (1):
        Merge git://git.samba.org/sfrench/cifs-2.6

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Pavel Shilovsky (2):
      CIFS: Simplify setlk error handling for mandatory locking
      CIFS: Cleanup byte-range locking code style

 fs/cifs/file.c |  105 ++++++++++++++++++++++++++-----------------------------
 1 files changed, 50 insertions(+), 55 deletions(-)


--
Thanks,

Steve
