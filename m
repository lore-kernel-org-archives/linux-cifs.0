From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v7 00/22] CIFS: Implement SMB Direct protocol
Date: Tue,  7 Nov 2017 01:54:52 -0700
Message-ID: <20171107085514.12693-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Starting with SMB2 dialect 3.0, Microsoft introduced SMB Direct transport
protocol for transferring upper layer (SMB2) payload over RDMA via Infiniband,
RoCE or iWARP. The prococol is published in [MS-SMBD]
(https://msdn.microsoft.com/en-us/library/hh536346.aspx).

Change log:
v2:
Implemented RDMA read/write via memory registration.
Re-arranged patches for review [Christoph Hellwig <hch@infradead.org>].
Restructured the code and fixed bugs on protocol timer and keepalive
[Tom Talpey <ttalpey@microsoft.com>].

v3:
Improved performance by introducing an additional queue for handling
empty packets and reducing lock contention on IRQ path.
Added light weight profiling by reading TSC.
Improved the code for checking SMB versions when mounting with rdma option
[Leon Romanovsky <leon@kernel.org>]. 
Moved to use pages instead of buffers for passing I/O for RDMA
[Christoph Hellwig <hch@infradead.org>].
Removed redundant code and refactored I/O code paths
[Christoph Hellwig <hch@infradead.org>, Tom Talpey <ttalpey@microsoft.com>].

v4:
Fixed connectivity issues with iWAPR devices.
Exported configurable protocol parameters to /proc/fs/cifs
[Steve French <sfrench@samba.org>]
Re-arranged patches for review
[Pavel Shilovsky <piastryyy@gmail.com>].

v5:
Fixed compiling errors on ia64, i386 and when INFINIBAND is not
configured. [kbuild test robot]
Profiling is removed and will be introduced in a seperate patch.

v6:
Report internal code error via WARN_ON(). Change description in
Kconfig [Pavel Shilovsky <piastryyy@gmail.com>].

v7:
Removed the use of #ifdef CONFIG_CIFS_SMB_DIRECT in upper layer
code calling transport I/O. [Matthew Wilcox <mawilcox@microsoft.com>,
Tom Talpey <ttalpey@microsoft.com>]

Long Li (22):
  CIFS: SMBD: Add parameter rdata to smb2_new_read_req
  CIFS: SMBD: Introduce kernel config option CONFIG_CIFS_SMB_DIRECT
  CIFS: SMBD: Add rdma mount option
  CIFS: SMBD: Add SMB Direct protocol initial values and constants
  CIFS: SMBD: Establish SMB Direct connection
  CIFS: SMBD: export protocol initial values
  CIFS: SMBD: Implement function to create a SMB Direct connection
  CIFS: SMBD: Upper layer connects to SMBDirect session
  CIFS: SMBD: Implement function to reconnect to a SMB Direct transport
  CIFS: SMBD: Upper layer reconnects to SMB Direct session
  CIFS: SMBD: Implement function to destroy a SMB Direct connection
  CIFS: SMBD: Upper layer destroys SMB Direct session on shutdown or
    umount
  CIFS: SMBD: Set SMB Direct maximum read or write size for I/O
  CIFS: SMBD: Implement function to receive data via RDMA receive
  CIFS: SMBD: Upper layer receives data via RDMA receive
  CIFS: SMBD: Implement function to send data via RDMA send
  CIFS: SMBD: Upper layer sends data via RDMA send
  CIFS: SMBD: Implement RDMA memory registration
  CIFS: SMBD: Upper layer performs SMB write via RDMA read through
    memory registration
  CIFS: SMBD: Read correct returned data length for RDMA write (SMB
    read) I/O
  CIFS: SMBD: Upper layer performs SMB read via RDMA write through
    memory registration
  CIFS: SMBD: Add SMB Direct debug counters

 fs/cifs/Kconfig      |    8 +
 fs/cifs/Makefile     |    2 +
 fs/cifs/cifs_debug.c |  147 +++
 fs/cifs/cifsfs.c     |    2 +
 fs/cifs/cifsglob.h   |   21 +-
 fs/cifs/cifssmb.c    |   15 +-
 fs/cifs/connect.c    |   53 +-
 fs/cifs/file.c       |   17 +-
 fs/cifs/smb1ops.c    |    4 +-
 fs/cifs/smb2ops.c    |   24 +-
 fs/cifs/smb2pdu.c    |  127 ++-
 fs/cifs/smbdirect.c  | 2617 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smbdirect.h  |  330 +++++++
 fs/cifs/transport.c  |    8 +-
 14 files changed, 3344 insertions(+), 31 deletions(-)
 create mode 100644 fs/cifs/smbdirect.c
 create mode 100644 fs/cifs/smbdirect.h

-- 
2.7.4
