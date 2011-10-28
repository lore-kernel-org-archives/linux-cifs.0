From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 28 Oct 2011 10:46:42 -0500
Message-ID: <CAH2r5mv8TJ1eeS9nXgkMTzDXQ2oyoBiE=tART8SjqkZ3Hih-=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 65112dccf8a113737684366349d7f9ec373ddc47:

  Merge git://git.samba.org/sfrench/cifs-2.6 (2011-10-10 14:53:11 +1200)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git 3.2-without-smb2

Dan Carpenter (1):
      CIFS: cleanup min_t() cast in cifs_read()

Gerlando Falauto (1):
      CIFS: fix automount for DFS shares

Jeff Layton (27):
      cifs: switch CIFSSMBQAllEAs to use memcmp
      cifs: use memcpy for magic string in cifs signature generation BSRSPYL
      cifs: get rid of unused xid in cifs_get_root
      cifs: untangle server->maxBuf and CIFSMaxBufSize
      cifs: clean up checkSMB
      cifs: consolidate signature generating code
      cifs: trivial: remove obsolete comment
      cifs: make smb_msg local to read_from_socket
      cifs: check for unresponsive server every time we call kernel_recvmsg
      cifs: simplify read_from_socket
      cifs: clean up check_rfc1002_header
      cifs: turn read_from_socket into a wrapper around a vectorized version
      cifs: keep a reusable kvec array for receives
      cifs: add a third receive phase to cifs_demultiplex_thread
      cifs: move mid finding into separate routine
      cifs: eliminate is_multi_rsp parm to find_cifs_mid
      cifs: move buffer pointers into TCP_Server_Info
      cifs: find mid earlier in receive codepath
      cifs: break out 3rd receive phase into separate function
      cifs: add a callback function to receive the rest of the frame
      cifs: fix protocol definition for READ_RSP
      cifs: add cifs_async_readv
      cifs: convert cifs_readpages to use async reads
      cifs: allow for larger rsize= options and change defaults
      cifs: tune bdi.ra_pages in accordance with the rsize
      cifs: allow cifs_max_pending to be readable under
/sys/module/cifs/parameters
      cifs, freezer: add wait_event_freezekillable and have cifs use it

Paul Bolle (1):
      cifs: Fix typo 'CIFS_NFSD_EXPORT'

Pavel Shilovsky (9):
      CIFS: Fix incorrect max RFC1002 write size value
      CIFS: Simplify byte range locking code
      CIFS: Move byte range lock list from fd to inode
      CIFS: Fix error handling in cifs_readv_complete
      CIFS: Fix DFS handling in cifs_get_file_info
      CIFS: Implement caching mechanism for mandatory brlocks
      CIFS: Implement caching mechanism for posix brlocks
      CIFS: Send as many mandatory unlock ranges at once as possible
      CIFS: Make cifs_push_locks send as many locks at once as possible

Sachin Prabhu (1):
      cifs: Display strictcache mount option in /proc/mounts

Shirish Pargaonkar (4):
      cifs: Add mount options for backup intent (try #6)
      cifs: clean up unused encryption code
      cifs: Add data structures and functions for uid/gid to SID
mapping (try #4)
      cifs: Call id to SID mapping functions to change owner/group
(try #4 repost)

Steve French (7):
      add new module parameter 'enable_oplocks'
      Typo in cifs readme in name of module parm directory
      [CIFS] Show nostrictsync and noperm mount options in /proc/mounts
      Merge branch 'cifs-3.2' of git://git.samba.org/jlayton/linux
into temp-3.2-jeff
      [CIFS] Fixup trivial checkpatch warning
      Add definition for share encryption
      Fix build break when freezer not configured

Suresh Jayaraman (2):
      cifs: update README about the kernel module parameters
      cifs: warn about deprecation of /proc/fs/cifs/OplockEnabled interface

 fs/cifs/README          |   14 +
 fs/cifs/cifs_debug.c    |    9 +-
 fs/cifs/cifs_fs_sb.h    |    4 +
 fs/cifs/cifsacl.c       |  347 ++++++++++++---
 fs/cifs/cifsencrypt.c   |  105 +----
 fs/cifs/cifsfs.c        |   24 +-
 fs/cifs/cifsfs.h        |    4 +-
 fs/cifs/cifsglob.h      |   55 ++-
 fs/cifs/cifspdu.h       |   48 ++-
 fs/cifs/cifsproto.h     |   48 ++-
 fs/cifs/cifssmb.c       |  454 ++++++++++++++++++--
 fs/cifs/connect.c       |  697 ++++++++++++++++++------------
 fs/cifs/dir.c           |   22 +-
 fs/cifs/export.c        |    4 +-
 fs/cifs/file.c          | 1126 ++++++++++++++++++++++++++++++++---------------
 fs/cifs/inode.c         |   54 ++-
 fs/cifs/link.c          |   17 +-
 fs/cifs/misc.c          |   66 ++--
 fs/cifs/sess.c          |    4 +-
 fs/cifs/smbencrypt.c    |  121 -----
 fs/cifs/transport.c     |   19 +-
 fs/cifs/xattr.c         |    2 +-
 include/linux/freezer.h |   22 +-
 23 files changed, 2249 insertions(+), 1017 deletions(-)

-- 
Thanks,

Steve
