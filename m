From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 27 Jun 2016 13:06:12 -0500
Message-ID: <CAH2r5munp2gEW+Fc=6XiQH0NJ=hGB7pFAXQgMPqG+jDetjBbeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Various small cifs/smb3 fixes, include some for stable, and some from
the recent SMB3 test event.

Please pull the following changes since commit
da01e18a37a57f360222d3a123b8f6994aa1ad14:

  x86: avoid avoid passing around 'thread_info' in stack dumping code
(2016-06-23 12:20:01 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 45e8a2583d97ca758a55c608f78c4cef562644d1:

  File names with trailing period or space need special case
conversion (2016-06-24 12:05:52 -0500)

----------------------------------------------------------------
Jeff Layton (1):
      cifs: stuff the fl_owner into "pid" field in the lock request

Jerome Marchand (2):
      cifs: use CIFS_MAX_DOMAINNAME_LEN when converting the domain name
      cifs: dynamic allocation of ntlmssp blob

Luis de Bethencourt (1):
      cifs: check hash calculating succeeded

Steve French (2):
      Fix reconnect to not defer smb3 session reconnect long after
socket reconnect
      File names with trailing period or space need special case conversion

 fs/cifs/cifs_unicode.c | 33 ++++++++++++++++++---
 fs/cifs/cifs_unicode.h |  2 ++
 fs/cifs/cifsfs.c       |  3 ++
 fs/cifs/cifsglob.h     |  1 +
 fs/cifs/connect.c      |  4 ++-
 fs/cifs/file.c         | 14 +++++++--
 fs/cifs/ntlmssp.h      |  2 +-
 fs/cifs/sess.c         | 80 ++++++++++++++++++++++++++++----------------------
 fs/cifs/smb2pdu.c      | 37 ++++++++++++++++++-----
 9 files changed, 124 insertions(+), 52 deletions(-)

-- 
Thanks,

Steve
