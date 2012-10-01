From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS merge
Date: Mon, 1 Oct 2012 17:01:57 -0500
Message-ID: <CAH2r5msYKXiQ4eNJnRj50TiKktYfJJV0rOZSZHhXpHTXSqmX-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is the final section of the SMB2.1 support merge for
cifs.ko. It also includes improvements to the cifs socket handling
from Jeff, and also fixes a few cifs bug fixes. It adds SMB2 support for
file and inode operations as well as moves some existing cifs
code to use ops server struct of protocol specific callbacks.
Most of this code is SMB2 specific.  When enabled SMB2.1 does
pass various functional tests including most of the connectathon
test suite,  For SMB2.1, Connectathon test 4 and some related tests fail
due to not updating mode bits remotely (cifsacl support where mode
bits are approximated with the cifs acl is not enable for smb2),
and test8 (symlink) support is not completed for SMB2 yet (note
that we will likely have a "Unix Extensions" eventually, at least for Samba,
so in the long run posix locks won't have to be emulated when mounting
Linux to Linux, but for most NAS and for Windows mounts posix lock
emulation will still used for SMB2 in a similar fashion as we do for cifs).
SMB2.1 dialect is supported.  Although additional fixes to
enable smb2 (the original smb2.02) dialect and to add various optional
features of the smb3 dialect are expected to be added in the future
as testing progresses, currently mounting with the "vers=2.1" is
supported (in order to mount using  SMB2.1 to servers like Samba 4,
and Windows 7, Windows 2008R2).

The following changes since commit 56d27adcb536b7430d5f8a6240df8ad261eb00bd:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile
(2012-09-24 16:17:17 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to 1d4ab9077681b7cce60ff46e3a42fe2dafa0b83d:

  [CIFS] Fix indentation of fs/cifs/Kconfig entries (2012-10-01 12:48:03 -0500)

----------------------------------------------------------------
Jeff Layton (20):
      cifs: change signing routines to deal with smb_rqst structs
      cifs: change smb2 signing routines to use smb_rqst structs
      cifs: convert send code to use smb_rqst structs
      cifs: cork the socket before a send and uncork it afterward
      cifs: teach smb_send_rqst how to handle arrays of pages
      cifs: teach signing routines how to deal with arrays of pages in
a smb_rqst
      cifs: change cifs_call_async to use smb_rqst structs
      cifs: convert async write code to pass in data via rq_pages array
      cifs: remove the kmap size limit from wsize
      cifs: add deprecation warning to sockopt=TCP_NODELAY option
      cifs: allocate kvec array for cifs_readdata as a separate allocation
      cifs: turn the pages list in cifs_readdata into an array
      cifs: convert async read code to use pages array without kmapping
      cifs: replace kvec array in readdata with a single kvec
      cifs: remove kmap lock and rsize limit
      cifs: cleanups for cifs_mkdir_qinfo
      cifs: add FL_CLOSE to fl_flags mask in cifs_read_flock
      cifs: remove support for CIFS_IOC_CHECKUMOUNT ioctl
      cifs: remove support for deprecated "forcedirectio" and
"strictcache" mount options
      cifs: change DOS/NT/POSIX mapping of ERRnoresource

Pavel Shilovsky (54):
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
      CIFS: Add NTLMSSP sec type to defaults
      CIFS: Remove spinlock dependence in brlock processing
      CIFS: Move brlock code to ops struct
      CIFS: Handle SMB2 lock flags
      CIFS: Add brlock support for SMB2
      CIFS: Use brlock cache for SMB2
      CIFS: Turn lock mutex into rw semaphore
      CIFS: Check for mandatory brlocks on read/write
      CIFS: Request SMB2.1 leases
      CIFS: Fix cache coherency for read oplock case
      CIFS: Add SMB2.1 lease break support
      CIFS: Fix fast lease break after open problem
      CIFS: Fix endian conversion of IndexNumber
      CIFS: Fix possible memory leaks in SMB2 code
      CIFS: Make ops->close return void
      CIFS: Fix possible freed pointer dereference in SMB2_sess_setup
      CIFS: Fix possible freed pointer dereference in CIFS_SessSetup

Sachin Prabhu (1):
      cifs: Mangle string used for unc in /proc/mounts

Shirish Pargaonkar (1):
      cifs: obtain file access during backup intent lookup (resend)

Steve French (6):
      CIFS: Move hardlink to ops struct
      Update cifs version number
      MARK SMB2 support EXPERIMENTAL
      Trivial endian fixes
      [CIFS] Fix SMB2 negotiation support to select only one dialect
(based on vers=)
      [CIFS] Fix indentation of fs/cifs/Kconfig entries

 fs/cifs/Kconfig         |   38 +-
 fs/cifs/Makefile        |    2 +-
 fs/cifs/cifsacl.c       |    2 +-
 fs/cifs/cifsencrypt.c   |   67 ++-
 fs/cifs/cifsfs.c        |   63 ++-
 fs/cifs/cifsfs.h        |    2 +-
 fs/cifs/cifsglob.h      |  268 +++++++++-
 fs/cifs/cifspdu.h       |    2 +-
 fs/cifs/cifsproto.h     |  136 +++---
 fs/cifs/cifssmb.c       |  289 +++++------
 fs/cifs/connect.c       |  198 +-------
 fs/cifs/dir.c           |  124 +++--
 fs/cifs/file.c          | 1055 +++++++++++++++++++++++-----------------
 fs/cifs/inode.c         |  441 ++++++++---------
 fs/cifs/ioctl.c         |   32 +-
 fs/cifs/link.c          |   74 +--
 fs/cifs/misc.c          |   32 +-
 fs/cifs/netmisc.c       |    9 +-
 fs/cifs/readdir.c       |  167 ++++---
 fs/cifs/sess.c          |    3 +-
 fs/cifs/smb1ops.c       |  328 ++++++++++++-
 fs/cifs/smb2file.c      |  302 ++++++++++++
 fs/cifs/smb2glob.h      |   14 +
 fs/cifs/smb2inode.c     |   98 +++-
 fs/cifs/smb2maperror.c  |    6 +-
 fs/cifs/smb2misc.c      |  240 ++++++++-
 fs/cifs/smb2ops.c       |  346 ++++++++++++-
 fs/cifs/smb2pdu.c       | 1235 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/smb2pdu.h       |  284 ++++++++++-
 fs/cifs/smb2proto.h     |   87 +++-
 fs/cifs/smb2transport.c |  204 +++++++-
 fs/cifs/transport.c     |  283 +++++++----
 32 files changed, 4884 insertions(+), 1547 deletions(-)
 create mode 100644 fs/cifs/smb2file.c


-- 
Thanks,

Steve
