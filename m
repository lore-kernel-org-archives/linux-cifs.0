From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 29 Oct 2010 12:26:13 -0500
Message-ID: <AANLkTi=+OLU1LDFfcFKMAnfYksaguPVCNmTJrM+TN3hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 229aebb873e29726b91e076161649cf45154b0bf:

  Merge branch 'for-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
(2010-10-24 13:41:39 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Dan Carpenter (2):
      cifs: cifs_convert_address() returns zero on error
      cifs: add kfree() on error path

Jeff Layton (3):
      cifs: convert cifsFileInfo->count to non-atomic counter
      cifs: wait for writeback to complete in cifs_flush
      cifs: eliminate cifsInodeInfo->write_behind_rc (try #6)

Shirish Pargaonkar (6):
      NTLM auth and sign - Allocate session key/client response dynamically
      NTLM auth and sign - Define crypto hash functions and create and
send keys needed for key exchange
      NTLM auth and sign - Use kernel crypto apis to calculate hashes
and smb signatures
      NTLM auth and sign - minor error corrections and cleanup
      NTLM auth and sign - Use appropriate server challenge
      cifs: Cleanup and thus reduce smb session structure and fields
used during authentication

Steve French (1):
      [CIFS] Fix checkpatch warnings and bump cifs version number

Suresh Jayaraman (1):
      cifs: update comments - [s/GlobalSMBSesLock/cifs_file_list_lock/g]

 fs/cifs/Kconfig       |    3 +
 fs/cifs/cifsencrypt.c |  427 ++++++++++++++++++++++++++++++++++++------------
 fs/cifs/cifsfs.c      |    1 -
 fs/cifs/cifsfs.h      |    2 +-
 fs/cifs/cifsglob.h    |   55 +++++--
 fs/cifs/cifspdu.h     |   13 ++-
 fs/cifs/cifsproto.h   |   14 +-
 fs/cifs/cifssmb.c     |    4 +-
 fs/cifs/connect.c     |   51 ++++--
 fs/cifs/file.c        |   57 ++-----
 fs/cifs/inode.c       |   15 +--
 fs/cifs/misc.c        |    2 +-
 fs/cifs/sess.c        |  166 +++++++++----------
 fs/cifs/transport.c   |    6 +-
 14 files changed, 526 insertions(+), 290 deletions(-)


--
Thanks,

Steve
