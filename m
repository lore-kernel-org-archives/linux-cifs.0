From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Wed, 8 Jun 2011 14:41:30 -0500
Message-ID: <BANLkTikO-tCFQ1PehMfi1jHRDy1eDTbsGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 1fa7b6a29c61358cc2ca6f64cef4aa0e1a7ca74c:

  Revert "mm: fail GFP_DMA allocations when ZONE_DMA is not
configured" (2011-06-02 06:11:24 +0900)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Darren Salt (1):
      CIFS ACL support needs CONFIG_KEYS, so depend on it

Jeff Layton (2):
      cifs: silence printk when establishing first session on socket
      cifs: trivial: add space in fsc error message

Suresh Jayaraman (2):
      cifs: fix the kernel release version in the default security
warning message
      cifs: make CIFS depend on CRYPTO_ECB

Vasily Averin (1):
      possible memory corruption in cifs_parse_mount_options()

 fs/cifs/Kconfig       |    3 ++-
 fs/cifs/cifsencrypt.c |    2 +-
 fs/cifs/connect.c     |    6 +++---
 3 files changed, 6 insertions(+), 5 deletions(-)

-- 
Thanks,

Steve
