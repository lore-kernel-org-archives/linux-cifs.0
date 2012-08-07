From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] [CIFS] Finishup of merge of basic SMB2 support
Date: Tue, 7 Aug 2012 15:49:58 -0500
Message-ID: <CAH2r5mszjEvgeaxNM8CCj1aiVC3n11RkQQ75faUFSwtfQfagiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is the final section of the SMB2 support merge for cifs.ko.
It adds SMB2 support for file and inode operations as well as moves
some existing cifs code to use ops server struct of protocol specific
callbacks.   Most of this code is SMB2 specific, and still within a
"CONFIG_BROKEN" ifdef, but when enabled it does pass various functional tests
including most of the connectathon test suite, and we will likely change
SMB2 support from CONFIG_BROKEN to CONFIG_EXPERIMENTAL
as we get broader test feedback.  For SMB2, Connectathon test 4
and some related tests fail due to not updating mode bits
remotely, and test8 (symlink) and posix byte range locking
tests are not completed for SMB2 yet (note that we will likely have
a "Unix Extensions" eventually, at least for Samba,
so posix locks won't have to be emulated when mounting Linux to Linux,
but for most NAS and for Windows mounts posix lock emulation will
still used for SMB2 as it is for cifs).  Although Pavel has written
patches for POSIX lock emulation for SMB2, they are targeted for 3.7.
Most of the cifs changes here are straightforward - simply finishing the
restructuring to use protocol specific function pointers.  Looking forward,
there are at least two cifs updates (relatively small) that are important and
being worked now, and expected to be merge ready in the next few weeks
(neither is related to these patches)
- one to address a problem with nlink count after unlink (cifs specific) which
Jeff discovered
- one to update "sec=" default to ntlmv2 (which was delayed last
releases due to difficulty testing against some older servers).
In addition there are approximately 4 other cifs patches from the list
under review
including a Unicode update and one relating to BACKUP_INTENT, and one additional
patch to remove some minor sparse warnings is also expected.  Of the
remaining patch series posted to list, Jeff asked that his updates to
cifs socket handling
be considered for 3.7 rather than 3.6.

The following changes since commit fc6bdb59a501740b28ed3b616641a22c8dc5dd31:

  Merge branch 'for-linus-3.6' of
git://dev.laptop.org/users/dilinger/linux-olpc (2012-08-02 11:52:39
-0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 30e59137af17b3d560c20ac199acc41c83dc1480:

  Remove sparse warning in cifsfs.c (2012-08-05 20:50:56 -0500)

----------------------------------------------------------------
Pavel Shilovsky (38):
      CIFS: Move unlink code to ops struct
      CIFS: Add SMB2 support for unlink
      CIFS: Replace netfid with cifs_fid struct in cifsFileInfo
      CIFS: Move open code to ops struct
      CIFS: Move close code to ops struct
      CIFS: Add open/close file support for SMB2
      CIFS: Move guery file info code to ops struct
      CIFS: Add SMB2 support for query_file_info
      CIFS: Move create code use ops struct
      CIFS: Move reopen code to ops struct
      CIFS: Make flush code use ops struct
      CIFS: Add SMB2 support for flush
      CIFS: Move r/wsize negotiating to ops struct
      CIFS: Add SMB2 r/wsize negotiating
      CIFS: Move async read to ops struct
      CIFS: Add SMB2 support for cifs_iovec_read
      CIFS: Move async write to ops struct
      CIFS: Add SMB2 support for cifs_iovec_write
      CIFS: Move readpage code to ops struct
      CIFS: Add readpage support for SMB2
      CIFS: Move writepage to ops struct
      CIFS: Add writepage support for SMB2
      CIFS: Enable signing in SMB2
      CIFS: Move rename to ops struct
      CIFS: Add SMB2 support for rename operation
      CIFS: Add SMB2 support for hardlink operation
      CIFS: Move set_file_size to ops struct
      CIFS: Add SMB2 support for set_file_size
      CIFS: Move set_file_info to ops struct
      CIFS: Add set_file_info support for SMB2
      CIFS: Move readdir code to ops struct
      CIFS: Add readdir support for SMB2
      CIFS: Process oplocks for SMB2
      CIFS: Move oplock break to ops struct
      CIFS: Add oplock break support for SMB2
      CIFS: Move statfs to ops struct
      CIFS: Add statfs support for SMB2
      CIFS: Fix log messages in packet checking for SMB2

Steve French (4):
      CIFS: Protect i_nlink from being negative
      CIFS: Move hardlink to ops struct
      print error code if smb signature verification fails
      Remove sparse warning in cifsfs.c

 fs/cifs/Kconfig         |   1 +
 fs/cifs/Makefile        |   2 +-
 fs/cifs/cifsacl.c       |   2 +-
 fs/cifs/cifsencrypt.c   |  30 +-
 fs/cifs/cifsfs.c        |  33 +-
 fs/cifs/cifsglob.h      | 221 ++++++++++-
 fs/cifs/cifsproto.h     |  85 ++---
 fs/cifs/cifssmb.c       | 151 ++++----
 fs/cifs/connect.c       | 148 +-------
 fs/cifs/dir.c           | 105 +++---
 fs/cifs/file.c          | 444 ++++++++++++----------
 fs/cifs/inode.c         | 347 ++++++++----------
 fs/cifs/ioctl.c         |  13 +-
 fs/cifs/link.c          |  76 ++--
 fs/cifs/misc.c          |   2 +-
 fs/cifs/netmisc.c       |   3 +-
 fs/cifs/readdir.c       | 165 +++++----
 fs/cifs/smb1ops.c       | 324 +++++++++++++++-
 fs/cifs/smb2file.c      | 106 ++++++
 fs/cifs/smb2glob.h      |  14 +
 fs/cifs/smb2inode.c     |  98 ++++-
 fs/cifs/smb2maperror.c  |   3 +-
 fs/cifs/smb2misc.c      | 102 +++++-
 fs/cifs/smb2ops.c       | 282 +++++++++++++-
 fs/cifs/smb2pdu.c       | 956 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2pdu.h       | 185 +++++++++-
 fs/cifs/smb2proto.h     |  63 +++-
 fs/cifs/smb2transport.c | 157 +++++++-
 fs/cifs/transport.c     |  33 +-
 29 files changed, 3236 insertions(+), 915 deletions(-)
 create mode 100644 fs/cifs/smb2file.c

-- 
Thanks,

Steve
