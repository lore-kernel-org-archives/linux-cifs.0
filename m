From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 22 Oct 2010 11:37:53 -0500
Message-ID: <AANLkTik6v__86qDwVpU=LZdxxe_-YabSXmXYAeavfZoJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 6b0cd00bc396daf5c2dcf17a8d82055335341f46:

  Merge branch 'hwpoison-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6
(2010-10-07 13:59:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Ben Greear (1):
      cifs: Allow binding to local IP address.

Jeff Layton (31):
      cifs: add tcon field to cifsFileInfo struct
      cifs: allow matching of tcp sessions in CifsNew state
      cifs: make various routines use the cifsFileInfo->tcon pointer
      cifs: add function to get a tcon from cifs_sb
      cifs: temporarily rename cifs_sb->tcon to ptcon to catch stragglers
      cifs: add cifs_sb_master_tcon and convert some callers to use it
      cifs: have cifs_new_fileinfo take a tcon arg
      cifs: fix handling of signing with writepages (try #6)
      cifs: add refcounted and timestamped container for holding tcons
      cifs: have cifsFileInfo hold a reference to a tlink rather than
tcon pointer
      cifs: have find_readable/writable_file filter by fsuid
      cifs: fix cifs_show_options to show "username=" or "multiuser"
      cifs: add routines to build sessions and tcons on the fly
      cifs: add "multiuser" mount option
      cifs: on multiuser mount, set ownership to
current_fsuid/current_fsgid (try #5)
      cifs: implement recurring workqueue job to prune old tcons
      cifs: fix module refcount leak in find_domain_name
      cifs: initialize tlink_tree_lock and tlink_tree
      cifs: on multiuser mount, set ownership to
current_fsuid/current_fsgid (try #7)
      cifs: keep dentry reference in cifsFileInfo instead of inode reference
      cifs: don't use vfsmount to pin superblock for oplock breaks
      cifs: eliminate cifs_posix_open_inode_helper
      cifs: fix flags handling in cifs_posix_open
      cifs: eliminate oflags option from cifs_new_fileinfo
      cifs: eliminate the inode argument from cifs_new_fileinfo
      cifs: clean up cifs_reopen_file
      cifs: cifs_write argument change and cleanup
      cifs: eliminate pfile pointer from cifsFileInfo
      cifs: move cifs_new_fileinfo to file.c
      cifs: convert GlobalSMBSeslock from a rwlock to regular spinlock
      cifs: move cifsFileInfo_put to file.c

Shirish Pargaonkar (6):
      cifs NTLMv2/NTLMSSP Change variable name mac_key to session key
to reflect the key it holds
      cifs NTLMv2/NTLMSSP ntlmv2 within ntlmssp autentication code
      ntlm authentication and signing - Correct response length for
ntlmv2 authentication without extended security
      CIFS ntlm authentication and signing - Build a proper av/ti pair
blob for ntlmv2 without extended security authentication
      NTLM authentication and signing - Calculate auth response per smb session
      Clean up two declarations of blob_len

Stefan Metzmacher (7):
      cifs: implement CIFSParseMFSymlink()
      cifs: implement CIFSCouldBeMFSymlink() and CIFSCheckMFSymlink()
      cifs: implement CIFSQueryMFSymLink()
      cifs: implement CIFSFormatMFSymlink()
      cifs: implement CIFSCreateMFSymLink()
      cifs: use Minshall+French symlink functions
      cifs: add "mfsymlinks" mount option

Steve French (7):
      [CIFS] Remove obsolete header
      [CIFS] Fix ordering of cleanup on module init failure
      [CIFS] Various small checkpatch cleanups
      [CIFS] Remove build warning
      Merge branch 'for-next'
      [CIFS] Fix minor checkpatch warning and update cifs version
      [CIFS] move close processing  from cifs_close to cifsFileInfo_put

Suresh Jayaraman (4):
      cifs: use type __u32 instead of int for the oplock parameter
      cifs: fix broken oplock handling
      cifs: handle FindFirst failure gracefully
      cifs: convert cifs_tcp_ses_lock from a rwlock to a spinlock

Tejun Heo (1):
      cifs: cancel_delayed_work() + flush_scheduled_work() ->
cancel_delayed_work_sync()

 fs/cifs/README         |    5 +
 fs/cifs/cifs_debug.c   |   12 +-
 fs/cifs/cifs_debug.h   |    2 +-
 fs/cifs/cifs_dfs_ref.c |   24 +-
 fs/cifs/cifs_fs_sb.h   |   13 +-
 fs/cifs/cifsacl.c      |   46 +++-
 fs/cifs/cifsencrypt.c  |  214 ++++++++++++--
 fs/cifs/cifsfs.c       |   92 ++++--
 fs/cifs/cifsfs.h       |   10 +-
 fs/cifs/cifsglob.h     |   91 ++++--
 fs/cifs/cifspdu.h      |    1 -
 fs/cifs/cifsproto.h    |   22 +-
 fs/cifs/cifssmb.c      |   30 +-
 fs/cifs/cn_cifs.h      |   37 ---
 fs/cifs/connect.c      |  534 +++++++++++++++++++++++++++++----
 fs/cifs/dir.c          |  212 +++----------
 fs/cifs/file.c         |  791 +++++++++++++++++++++++-------------------------
 fs/cifs/fscache.c      |   13 +-
 fs/cifs/inode.c        |  237 +++++++++++----
 fs/cifs/ioctl.c        |   17 +-
 fs/cifs/link.c         |  372 +++++++++++++++++++++--
 fs/cifs/misc.c         |   32 +--
 fs/cifs/ntlmssp.h      |   15 +
 fs/cifs/readdir.c      |   79 +++--
 fs/cifs/sess.c         |  167 +++++++----
 fs/cifs/transport.c    |    6 +-
 fs/cifs/xattr.c        |   60 +++--
 27 files changed, 2091 insertions(+), 1043 deletions(-)
 delete mode 100644 fs/cifs/cn_cifs.h



-- 
Thanks,

Steve
