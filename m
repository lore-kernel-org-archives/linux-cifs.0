From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] CIFS Fixes
Date: Tue, 9 Dec 2014 09:18:00 -0600
Message-ID: <CAH2r5muu_0byHxGJeKxmFinRSv4Aiduj=7U5ysyP-3MzK7e+HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Mostly cifs cleanup but also a few cifs fixes.   Please pull the
following changes since commit
b2776bf7149bddd1f4161f14f79520f17fc1d71d:

  Linux 3.18 (2014-12-07 14:21:05 -0800)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to 15d987063348c93adb3e7c7378226abea03608e2:

  cifs: remove unneeded condition check (2014-12-07 23:43:10 -0600)

----------------------------------------------------------------
Andy Shevchenko (3):
      cifs: call strtobool instead of custom implementation
      cifs: convert to print_hex_dump() instead of custom implementation
      cifs: convert printk(LEVEL...) to pr_<level>

Kevin Cernekee (1):
      Update MAINTAINERS entry

Namjae Jeon (1):
      cifs: remove unneeded condition check

Sachin Prabhu (1):
      Set UID in sess_auth_rawntlmssp_authenticate too

Steve French (4):
      Add support for original fallocate
      Add missing defines for ACL query support
      decode_negTokenInit had wrong calling sequence
      Update modinfo cifs version for cifs.ko

 MAINTAINERS          |  3 +-
 fs/cifs/cifs_debug.c | 77 ++++++++++++++++++++++------------------------------
 fs/cifs/cifs_debug.h |  7 ++---
 fs/cifs/cifsfs.h     |  2 +-
 fs/cifs/connect.c    | 51 ++++++++++++----------------------
 fs/cifs/misc.c       | 32 ++--------------------
 fs/cifs/readdir.c    |  4 ---
 fs/cifs/sess.c       |  5 ++++
 fs/cifs/smb2ops.c    | 63 +++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2pdu.c    |  3 +-

-- 
Thanks,

Steve
