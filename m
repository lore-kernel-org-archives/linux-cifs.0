From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Tue, 11 Dec 2012 22:58:23 -0600
Message-ID: <CAH2r5muQzObR+sKCd-Q87ONxkuX-coLe0tN+WfKCpQgZc5YhzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This includes a set of misc. cifs fixes (most importantly some byte range
lock related write fixes from Pavel, and some ACL and idmap related
fixes from Jeff)
but also includes the SMB2.02 dialect enablement, and a key fix for SMB3 mounts.
Default authentication upgraded to ntlmv2 for cifs (it was already ntlmv2
for smb2)

The following changes since commit 27d7c2a006a81c04fab00b8cd81b99af3b32738d:

  vfs: clear to the end of the buffer on partial buffer reads
(2012-12-05 10:32:59 -0800)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to c299dd0e2d3dd61d0048a9d9b021aa01f023ed0c:

  CIFS: Fix write after setting a read lock for read oplock files
(2012-12-11 11:48:50 -0600)

----------------------------------------------------------------
Jeff Layton (25):
      cifs: fix types on module parameters
      cifs: clean up id_mode_to_cifs_acl
      cifs: move num_subauth check inside of CONFIG_CIFS_DEBUG2 check
in parse_sid()
      cifs: use the NUM_AUTHS and NUM_SUBAUTHS constants in cifsacl code
      cifs: make compare_sids static
      cifs: make cifs_copy_sid handle a source sid with variable size
subauth arrays
      cifs: redefine NUM_SUBAUTH constant from 5 to 15
      cifs: fix the format specifiers in sid_to_str
      cifs: remove uneeded __KERNEL__ block from cifsacl.h
      cifs: don't override the uid/gid in getattr when cifsacl is enabled
      cifs: make error on lack of a unc= option more explicit
      cifs: ensure we revalidate the inode after readdir if cifsacl is enabled
      cifs: get rid of smb_vol->UNCip and smb_vol->port
      cifs: remove unneeded address argument from
cifs_find_tcp_session and match_server
      cifs: always zero out smb_vol before parsing options
      cifs: rename cifs_readdir_lookup to cifs_prime_dcache and make
it void return
      cifs: simplify id_to_sid and sid_to_id mapping code
      cifs: avoid extra allocation for small cifs.idmap keys
      cifs: extra sanity checking for cifs.idmap keys
      cifs: fix hardcoded default security descriptor length
      cifs: deal with id_to_sid embedded sid reply corner case
      cifs: fix SID binary to string conversion
      cifs: clean up handling of unc= option
      cifs: fix up handling of prefixpath= option
      cifs: parse the device name into UNC and prepath

Jesper Nilsson (1):
      cifs: Add handling of blank password option

Joe Perches (3):
      cifs: Remove unused cEVENT macro
      cifs: Make CIFS_DEBUG possible to undefine
      cifs: Add CONFIG_CIFS_DEBUG and rename use of CIFS_DEBUG

Pavel Shilovsky (7):
      CIFS: Separate pushing posix locks and lock_sem handling
      CIFS: Separate pushing mandatory locks and lock_sem handling
      CIFS: Implement cifs_relock_file
      CIFS: Fix lock consistensy bug in cifs_setlk
      CIFS: Do not permit write to a range mandatory locked with a read lock
      CIFS: Fix possible data coherency problem after oplock break to None
      CIFS: Fix write after setting a read lock for read oplock files

Steve French (7):
      default authentication needs to be at least ntlmv2 security for
cifs mounts
      CIFS: Make use of common cifs_build_path_to_root for CIFS and SMB2
      Add SMB2.02 dialect support
      make convert_delimiter use strchr instead of open-coding it
      SMB3 mounts fail with access denied to some servers
      Do not send SMB2 signatures for SMB3 frames
      fix "disabling echoes and oplocks" on SMB2 mounts

 fs/cifs/Kconfig         |  10 +-
 fs/cifs/cifs_debug.h    |  72 +++--
 fs/cifs/cifsacl.c       | 746 +++++++++++++++---------------------------------
 fs/cifs/cifsacl.h       |  66 +++--
 fs/cifs/cifsfs.c        |  17 +-
 fs/cifs/cifsglob.h      |  36 +--
 fs/cifs/cifsproto.h     |  10 +-
 fs/cifs/connect.c       | 310 ++++++++++----------
 fs/cifs/dir.c           |  32 +++
 fs/cifs/file.c          | 200 ++++++++-----
 fs/cifs/inode.c         |   7 +-
 fs/cifs/netmisc.c       |  14 +-
 fs/cifs/readdir.c       |  52 ++--
 fs/cifs/smb1ops.c       |  32 ---
 fs/cifs/smb2file.c      |  12 -
 fs/cifs/smb2ops.c       | 103 +++++--
 fs/cifs/smb2pdu.c       |   5 +-
 fs/cifs/smb2proto.h     |   4 +
 fs/cifs/smb2transport.c |  13 +-
 19 files changed, 787 insertions(+), 954 deletions(-)

-- 
Thanks,

Steve
