From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Tue, 13 Mar 2012 12:46:39 -0500
Message-ID: <CAH2r5msbpae9eZc3ZW5Z8zcUS9LeayQD9PYdBPenOkj08VuUwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 55062d061790b43aee01ab3f9ac57b8596254f19:
  Linus Torvalds (1):
        x86: fix typo in recent find_vma_prev purge

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Pavel Shilovsky (1):
      CIFS: Do not kmalloc under the flocks spinlock

Santosh Nayak (1):
      cifs: possible memory leak in xattr.

 fs/cifs/file.c  |   69 ++++++++++++++++++++++++++++++++++++++++++++----------
 fs/cifs/xattr.c |    6 ++--
 2 files changed, 59 insertions(+), 16 deletions(-)

-- 
Thanks,

Steve
