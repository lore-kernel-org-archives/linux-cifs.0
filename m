From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v2 00/19] CIFS: Implement SMBDirect
Date: Sun, 20 Aug 2017 12:04:24 -0700
Message-ID: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
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

Starting with SMB2 dialect 3.0, Microsoft introduced SMBDirect transport protocol for transferring upper layer (SMB2) payload over RDMA via Infiniband, RoCE or iWARP. The prococol is published in [MS-SMBD] (https://msdn.microsoft.com/en-us/library/hh536346.aspx).

The patch v2 added RDMA read/write via memory registration, and addressed feedbacks on v1.

Long Li (19):
  CIFS: Add rdma mount option
  CIFS: SMBD: Add SMBDirect protocol and transport constants
  CIFS: SMBD: Implement SMBDirect transport
  CIFS: SMBD: Add SMBDirect transport to SMB connection and Makefile
  CIFS: SMBD: Connect to SMBDirect session
  CIFS: SMBD: Reconnect to SMBDirect session
  CIFS: SMBD: Destroy SMBDirect session on shutdown or umount
  CIFS: SMBD: Set SMBDirect maximum read or write size for I/O
  CIFS: SMBD: Read data from SMBDirect
  CIFS: SMBD: Send data through SMBDirect
  CIFS: SMBD: Define memory registration for I/O data
  CIFS: SMBD: Fix the definition for SMB2_CHANNEL_RDMA_V1_INVALIDATE
  CIFS: SMBD: Use registered memory RDMA read for SMB write
  CIFS: SMBD: Deregister memory when finishing SMB write
  CIFS: SMBD: Add parameter rdata to smb2_new_read_req
  CIFS: SMBD: Read correct returned data length for RDMA write (SMB
    READ) I/O
  CIFS: SMBD: Do not read from transport on registered memory RDMA write
    (SMB READ)
  CIFS: SMBD: Deregister memory when finishing SMB read
  CIFS: SMBD: Add SMBDirect debug counters

 fs/cifs/Makefile     |    2 +-
 fs/cifs/cifs_debug.c |   48 ++
 fs/cifs/cifsfs.c     |    2 +
 fs/cifs/cifsglob.h   |   17 +-
 fs/cifs/cifssmb.c    |    4 +-
 fs/cifs/connect.c    |   62 +-
 fs/cifs/file.c       |    5 +
 fs/cifs/smb1ops.c    |    2 +-
 fs/cifs/smb2ops.c    |   21 +-
 fs/cifs/smb2pdu.c    |  114 ++-
 fs/cifs/smb2pdu.h    |    2 +-
 fs/cifs/smbdirect.c  | 2328 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smbdirect.h  |  300 +++++++
 fs/cifs/transport.c  |    7 +
 14 files changed, 2895 insertions(+), 19 deletions(-)
 create mode 100644 fs/cifs/smbdirect.c
 create mode 100644 fs/cifs/smbdirect.h

-- 
2.7.4
