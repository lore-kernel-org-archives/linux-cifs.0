From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Thu, 7 Nov 2013 13:37:41 -0600
Message-ID: <CAH2r5ms4VkAK5-Lof6d8gfMeQMhdAZBADCLKCNZHwxGb2Vy_eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Includes a couple of fixes, plus changes to make multiplex identifiers
easier to read and correlate with network traces, and a set of
enhancements for SMB3 dialect.  Also adds support for per-file
compression for both cifs and smb2/smb3 ("chattr +c filename").

Should have at least one other merge request ready by next week with
some new SMB3 security features and copy offload support.

The following changes since commit 959f58544b7f20c92d5eb43d1232c96c15c01bfb:

  Linux 3.12-rc7 (2013-10-27 16:12:03 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to c481e9feee78c6ce1ba0a1c8c892049f6514f6cf:

  Query network adapter info at mount time for debugging (2013-11-02
12:53:45 -0500)

----------------------------------------------------------------
Shirish Pargaonkar (1):
      cifs: Send a logoff request before removing a smb session

Steve French (6):
      Fix corrupt SMB2 ioctl requests
      Allow setting per-file compression via SMB2/3
      Query file system attributes from server on SMB2, not just cifs, mounts
      Allow setting per-file compression via CIFS protocol
      Fix unused variable warning when CIFS POSIX disabled
      Query network adapter info at mount time for debugging

Steven French (2):
      Query device characteristics at mount time from server on SMB2/3
not just on cifs mounts
      Query File System Alignment

Tim Gardner (2):
      cifs: Remove redundant multiplex identifier check from check_smb_hdr()
      cifs: Make big endian multiplex ID sequences monotonic on the wire

 fs/cifs/cifsglob.h      |  29 +++++++++++-
 fs/cifs/cifspdu.h       |  34 +++++++++++++-
 fs/cifs/cifsproto.h     |   2 +
 fs/cifs/cifssmb.c       |  54 +++++++++++++++++++++++
 fs/cifs/connect.c       |  25 ++++++++---
 fs/cifs/ioctl.c         |  57 ++++++++++++++++--------
 fs/cifs/misc.c          |  22 ++++-----
 fs/cifs/smb1ops.c       |  12 ++++-
 fs/cifs/smb2ops.c       | 114 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c       | 115 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/smb2pdu.h       |  28 ++++++++++--
 fs/cifs/smb2proto.h     |   4 ++
 fs/cifs/smb2transport.c |  12 +++--
 fs/cifs/transport.c     |  13 ++++--
 14 files changed, 464 insertions(+), 57 deletions(-)

-- 
Thanks,

Steve
