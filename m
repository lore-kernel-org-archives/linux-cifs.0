From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Tue, 12 Apr 2011 13:26:44 -0500
Message-ID: <BANLkTim8iTdmMjLGMYVtFhWEzdR1KQyQng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit a6360dd37e1a144ed11e6548371bade559a1e4df:

  Linux 2.6.39-rc3 (2011-04-11 17:21:51 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (9):
      cifs: check for private_data before trying to put it
      cifs: replace /proc/fs/cifs/Experimental with a module parm
      cifs: always do is_path_accessible check in cifs_mount
      cifs: fix broken BCC check in is_valid_oplock_break
      cifs: set ra_pages in backing_dev_info
      cifs: clean up length checks in check2ndT2
      cifs: clean up various nits in unicode routines (try #2)
      cifs: wrap received signature check in srv_mutex
      cifs: don't allow mmap'ed pages to be dirtied while under
writeback (try #3)

Steve French (6):
      Allow user names longer than 32 bytes
      Max share size is too small
      Elminate sparse __CHECK_ENDIAN__ warnings on port conversion
      various endian fixes to cifs
      [CIFS] cifs: clarify the meaning of tcpStatus == CifsGood
      [CIFS] Warn on requesting default security (ntlm) on mount

 fs/cifs/README         |   16 -----------
 fs/cifs/cache.c        |    2 +-
 fs/cifs/cifs_debug.c   |   43 -----------------------------
 fs/cifs/cifs_spnego.c  |    4 +-
 fs/cifs/cifs_unicode.c |   35 +++++++++++------------
 fs/cifs/cifs_unicode.h |    2 +-
 fs/cifs/cifsencrypt.c  |   21 ++++++++------
 fs/cifs/cifsfs.c       |    6 ++--
 fs/cifs/cifsglob.h     |   13 ++++-----
 fs/cifs/cifssmb.c      |   14 +++++-----
 fs/cifs/connect.c      |   68 ++++++++++++++++++++++++++++------------------
 fs/cifs/file.c         |   70 +++++++++++++++++++++++++----------------------
 fs/cifs/link.c         |    4 +-
 fs/cifs/misc.c         |    3 +-
 fs/cifs/sess.c         |   23 +++++++--------
 15 files changed, 143 insertions(+), 181 deletions(-)


-- 
Thanks,

Steve
