From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v6 00/22] CIFS: Implement SMB Direct protocol
Date: Sat,  4 Nov 2017 22:43:42 -0700
Message-ID: <20171105054404.23886-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Starting with SMB2 dialect 3.0, Microsoft introduced SMB Direct transport
protocol for transferring upper layer (SMB2) payload over RDMA via Infiniband,
RoCE or iWARP. The prococol is published in [MS-SMBD]
(https://msdn.microsoft.com/en-us/library/hh536346.aspx).

Patch v2 added RDMA read/write via memory registration, and addressed
feedbacks on v1.

Patch v3 improved performance by introducing an additional queue for handling
empty packets and reducing lock contention on IRQ path. Also added light
weight profiling by reading TSC and addressed feedbacks on v2.

Patch v4 fixed connectivity issues with iWAPR devices and addressed comments.

Patch v5 fixed compiling errors on ia64, i386 and when INFINIBAND is not
configured, and addressed comments. Profiling is removed and will be
introduced in a seperate patch.

Patch v6 addressed comments.

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
 fs/cifs/cifsglob.h   |   23 +-
 fs/cifs/cifssmb.c    |   16 +-
 fs/cifs/connect.c    |   64 +-
 fs/cifs/file.c       |   19 +-
 fs/cifs/smb1ops.c    |    4 +-
 fs/cifs/smb2ops.c    |   26 +-
 fs/cifs/smb2pdu.c    |  129 ++-
 fs/cifs/smbdirect.c  | 2618 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smbdirect.h  |  315 ++++++
 fs/cifs/transport.c  |   14 +-
 14 files changed, 3359 insertions(+), 28 deletions(-)
 create mode 100644 fs/cifs/smbdirect.c
 create mode 100644 fs/cifs/smbdirect.h

-- 
2.7.4
