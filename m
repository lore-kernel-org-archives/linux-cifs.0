From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v4 00/22] CIFS: Implement SMBDirect
Date: Sun,  1 Oct 2017 19:30:08 -0700
Message-ID: <20171002023030.3582-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Starting with SMB2 dialect 3.0, Microsoft introduced SMBDirect transport
protocol for transferring upper layer (SMB2) payload over RDMA via Infiniband,
RoCE or iWARP. The prococol is published in [MS-SMBD]
(https://msdn.microsoft.com/en-us/library/hh536346.aspx).

Patch v2 added RDMA read/write via memory registration, and addressed
feedbacks on v1.

Patch v3 improved performance by introducing an additional queue for handling
empty packets and reducing lock contention on IRQ path. Also added light
weight profiling by reading TSC and addressed feedbacks on v2.

Patch v4 fixed connectivity issues with iWAPR devices and addressed comments.

Long Li (22):
  CIFS: SMBD: Add SMBDirect protocol initial values and constants
  CIFS: SMBD: Establish SMBDirect connection
  CIFS: SMBD: export protocol initial values
  CIFS: SMBD: Add rdma mount option
  CIFS: SMBD: Implement function to create a SMBDirect connection
  CIFS: SMBD: Upper layer connects to SMBDirect session
  CIFS: SMBD: Implement function to reconnect to a SMBDirect transport
  CIFS: SMBD: Upper layer reconnects to SMBDirect session
  CIFS: SMBD: Implement function to destroy a SMBDirect connection
  CIFS: SMBD: Upper layer destroys SMBDirect session on shutdown or
    umount
  CIFS: SMBD: Set SMBDirect maximum read or write size for I/O
  CIFS: SMBD: Implement function to receive data via RDMA receive
  CIFS: SMBD: Upper layer receives data via RDMA receive
  CIFS: SMBD: Implement function to send data via RDMA send
  CIFS: SMBD: Upper layer sends data via RDMA send
  CIFS: SMBD: Fix the definition for SMB2_CHANNEL_RDMA_V1_INVALIDATE
  CIFS: SMBD: Implement RDMA memory registration
  CIFS: SMBD: Upper layer performs SMB write via RDMA read through
    memory registration
  CIFS: SMBD: Add parameter rdata to smb2_new_read_req
  CIFS: SMBD: Read correct returned data length for RDMA write (SMB
    read) I/O
  CIFS: SMBD: Upper layer performs SMB read via RDMA write through
    memory registration
  CIFS: SMBD: Add SMBDirect debug counters

 fs/cifs/Makefile     |    2 +-
 fs/cifs/cifs_debug.c |  159 +++
 fs/cifs/cifsfs.c     |    2 +
 fs/cifs/cifsglob.h   |   17 +-
 fs/cifs/cifssmb.c    |   10 +-
 fs/cifs/connect.c    |   46 +-
 fs/cifs/file.c       |   10 +
 fs/cifs/smb1ops.c    |    2 +-
 fs/cifs/smb2ops.c    |   21 +-
 fs/cifs/smb2pdu.c    |  114 ++-
 fs/cifs/smb2pdu.h    |    2 +-
 fs/cifs/smbdirect.c  | 2651 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smbdirect.h  |  325 +++++++
 fs/cifs/transport.c  |    7 +
 14 files changed, 3348 insertions(+), 20 deletions(-)
 create mode 100644 fs/cifs/smbdirect.c
 create mode 100644 fs/cifs/smbdirect.h

-- 
2.7.4
