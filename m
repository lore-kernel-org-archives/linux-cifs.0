From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] Various SMB3 fixes for 4.16
Date: Mon, 29 Jan 2018 10:59:08 -0600
Message-ID: <CAH2r5ms3LVxa2u13vEfAkCuYPRxRfc=nioYoYRQi-W-s+50S+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
5b7d27967dabfb17c21b0d98b29153b9e3ee71e5:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
(2018-01-24 17:24:30 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/4.16-rc-SMB3

for you to fetch changes up to 36c7ce4a17f220398e12e588ea3484265df4c41c:

  fs/cifs/cifsacl.c Fixes typo in a comment (2018-01-28 09:19:45 -0600)

----------------------------------------------------------------
4.16 fixes for SMB3

Some fixes for stable, fixed SMB3 DFS support, SMB3 Direct (RDMA) and vario=
us
bug fixes and cleanup.

----------------------------------------------------------------
Achilles Gaikwad (1):
      fs/cifs/cifsacl.c Fixes typo in a comment

Andr=C3=A9s Souto (1):
      cifs: add .splice_write

Arnd Bergmann (1):
      CIFS: SMBD: work around gcc -Wmaybe-uninitialized warning

Aurelien Aptel (5):
      CIFS: make IPC a regular tcon
      CIFS: use tcon_ipc instead of use_ipc parameter of SMB2_ioctl
      CIFS: dump IPC tcon in debug proc file
      CIFS: zero sensitive data when freeing
      CIFS: document tcon/ses/server refcount dance

Colin Ian King (1):
      cifs: remove redundant duplicated assignment of pointer 'node'

Daniel N Pettersson (1):
      cifs: Fix autonegotiate security settings mismatch

Long Li (23):
      CIFS: SMBD: Add parameter rdata to smb2_new_read_req
      CIFS: SMBD: Introduce kernel config option CONFIG_CIFS_SMB_DIRECT
      CIFS: SMBD: Add rdma mount option
      CIFS: SMBD: Add SMB Direct protocol initial values and constants
      CIFS: SMBD: Establish SMB Direct connection
      CIFS: SMBD: Implement function to create a SMB Direct connection
      CIFS: SMBD: export protocol initial values
      CIFS: SMBD: Upper layer connects to SMBDirect session
      CIFS: SMBD: Implement function to reconnect to a SMB Direct transport
      CIFS: SMBD: Upper layer reconnects to SMB Direct session
      CIFS: SMBD: Implement function to destroy a SMB Direct connection
      CIFS: SMBD: Upper layer destroys SMB Direct session on shutdown or um=
ount
      CIFS: SMBD: Set SMB Direct maximum read or write size for I/O
      CIFS: SMBD: Implement function to receive data via RDMA receive
      CIFS: SMBD: Upper layer receives data via RDMA receive
      CIFS: SMBD: Implement function to send data via RDMA send
      CIFS: SMBD: Upper layer sends data via RDMA send
      CIFS: SMBD: Implement RDMA memory registration
      CIFS: SMBD: Upper layer performs SMB write via RDMA read through
memory registration
      CIFS: SMBD: Read correct returned data length for RDMA write
(SMB read) I/O
      CIFS: SMBD: Upper layer performs SMB read via RDMA write through
memory registration
      CIFS: SMBD: Add SMB Direct debug counters
      CIFS: SMBD: Disable signing on SMB direct transport

Matthew Wilcox (1):
      cifs: Fix missing put_xid in cifs_file_strict_mmap

Randy Dunlap (1):
      cifs: fix build errors for SMB_DIRECT

Ronnie Sahlberg (21):
      cifs: Add smb2_send_recv
      cifs: remove rfc1002 header from smb2_negotiate_req
      cifs: remove rfc1002 header from smb2_logoff_req
      cifs: remove rfc1002 header from smb2_tree_disconnect_req
      cifs: remove rfc1002 header from smb2_close_req
      cifs: remove rfc1002 header from smb2_ioctl_req
      cifs: remove rfc1002 header from smb2_echo_req
      cifs: remove rfc1002 header from smb2_tree_connect_req
      cifs: remove rfc1002 header from smb2_sess_setup_req
      cifs: remove rfc1002 header from smb2_create_req
      cifs: remove rfc1002 header from smb2_flush_req
      cifs: remove rfc1002 header from smb2_lock_req
      cifs: remove rfc1002 header from smb2 read/write requests
      cifs: remove rfc1002 header from smb2_set_info_req
      cifs: remove rfc1002 header from smb2_query_directory_req
      cifs: remove rfc1002 header from smb2_query_info_req
      cifs: remove rfc1002 header from smb2_oplock_break we get from server
      cifs: remove unused variable from SMB2_read
      cifs: remove rfc1002 header from smb2_lease_ack
      cifs: remove small_smb2_init
      cifs: avoid a kmalloc in smb2_send_recv/SendReceive2 for the common c=
ase

Steve French (3):
      Cleanup some minor endian issues in smb3 rdma
      move a few externs to smbdirect.h to eliminate warning
      update internal version number for cifs.ko

kbuild test robot (1):
      CIFS: SMBD: _smbd_get_connection() can be static

 fs/cifs/Kconfig       |    8 +
 fs/cifs/Makefile      |    2 +
 fs/cifs/cifs_debug.c  |  199 +++-
 fs/cifs/cifsacl.c     |    2 +-
 fs/cifs/cifsencrypt.c |    3 +-
 fs/cifs/cifsfs.c      |    8 +
 fs/cifs/cifsfs.h      |    2 +-
 fs/cifs/cifsglob.h    |   35 +-
 fs/cifs/cifsproto.h   |    4 +
 fs/cifs/cifssmb.c     |   22 +-
 fs/cifs/connect.c     |  251 ++++-
 fs/cifs/file.c        |   43 +-
 fs/cifs/inode.c       |    2 +-
 fs/cifs/misc.c        |   14 +-
 fs/cifs/smb1ops.c     |    4 +-
 fs/cifs/smb2file.c    |    2 +-
 fs/cifs/smb2misc.c    |    2 +-
 fs/cifs/smb2ops.c     |   77 +-
 fs/cifs/smb2pdu.c     |  578 ++++++-----
 fs/cifs/smb2pdu.h     |   60 +-
 fs/cifs/smb2proto.h   |    3 +-
 fs/cifs/smbdirect.c   | 2610 +++++++++++++++++++++++++++++++++++++++++++++=
++++
 fs/cifs/smbdirect.h   |  338 +++++++
 fs/cifs/transport.c   |   69 +-
 24 files changed, 3896 insertions(+), 442 deletions(-)
 create mode 100644 fs/cifs/smbdirect.c
 create mode 100644 fs/cifs/smbdirect.h

--=20
Thanks,

Steve
