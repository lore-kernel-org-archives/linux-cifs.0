From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [SMB3] Updates for 4.15
Date: Wed, 22 Nov 2017 14:35:28 -0600
Message-ID: <CAH2r5msieYWn-5_9OX+OYpvVOdsEAjG8aCuSFzi1Mcb3A+x9gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
ed30b147e1f6e396e70a52dbb6c7d66befedd786:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide
(2017-11-19 08:04:41 -1000)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/4.15-smb3-updates

for you to fetch changes up to cfb6a953bfce3ece5f25af28d1cde762c328ae9d:

  cifs: avoid a kmalloc in smb2_send_recv/SendReceive2 for the common
case (2017-11-21 18:29:11 -0600)

----------------------------------------------------------------
SMB3 updates for 4.15

Includes cleanup of the RFC1001 length handling, and
experimentalSMB3  RDMA support and a few additional misc fixes (one for stable).

I expect to have another set of SMB3 RDMA patches from Long Li and Pavel in
a few days after additional testing, as well as a few SMB3.1.1 fixes
(improve security).

----------------------------------------------------------------
Aurelien Aptel (1):
      CIFS: don't log STATUS_NOT_FOUND errors for DFS

Long Li (7):
      CIFS: SMBD: Add parameter rdata to smb2_new_read_req
      CIFS: SMBD: Introduce kernel config option CONFIG_CIFS_SMB_DIRECT
      CIFS: SMBD: Add rdma mount option
      CIFS: SMBD: Add SMB Direct protocol initial values and constants
      CIFS: SMBD: Establish SMB Direct connection
      CIFS: SMBD: Implement function to create a SMB Direct connection
      CIFS: SMBD: export protocol initial values

Ronnie Sahlberg (22):
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
      cifs: fix NULL deref in SMB2_read
      cifs: remove unused variable from SMB2_read
      cifs: remove rfc1002 header from smb2_lease_ack
      cifs: remove small_smb2_init
      cifs: avoid a kmalloc in smb2_send_recv/SendReceive2 for the common case

 fs/cifs/Kconfig      |    8 +
 fs/cifs/Makefile     |    2 +
 fs/cifs/cifs_debug.c |   81 +++
 fs/cifs/cifsfs.c     |    2 +
 fs/cifs/cifsglob.h   |    5 +
 fs/cifs/cifsproto.h  |    4 +
 fs/cifs/connect.c    |   15 +-
 fs/cifs/smb2misc.c   |    2 +-
 fs/cifs/smb2ops.c    |    3 +-
 fs/cifs/smb2pdu.c    |  456 +++++++-------
 fs/cifs/smb2pdu.h    |   46 +-
 fs/cifs/smbdirect.c  | 1665 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smbdirect.h  |  257 ++++++++
 fs/cifs/transport.c  |   61 +-
 14 files changed, 2350 insertions(+), 257 deletions(-)
 create mode 100644 fs/cifs/smbdirect.c
 create mode 100644 fs/cifs/smbdirect.h

-- 
Thanks,

Steve
