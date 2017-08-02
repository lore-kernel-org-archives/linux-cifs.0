From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [[PATCH v1] 00/37] Implement SMBD protocol: Series 1
Date: Wed,  2 Aug 2017 13:10:11 -0700
Message-ID: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

SMB3 defines a protocol for transfer data over RDMA transport such as Infiniband, RoCE and iWARP. The prococol is published in [MS-SMBD] (https://msdn.microsoft.com/en-us/library/hh536346.aspx).

This is the series 1 of two patch sets. This patch set implements the SMBD transport for doing RDMA send/recv.

This patch set is the foundation of series 2 patch set, which implements sending upper layer RDMA read/write via memory registration.

Long Li (37):
  [CIFS] SMBD: Add parsing for new rdma mount option
  [CIFS] SMBD: Add structure for SMBD transport
  [CIFS] SMBD: Add logging functions for debug
  [CIFS] SMBD: Define per-channel SMBD transport parameters and default
    values
  [CIFS] SMBD: Implement API for upper layer to create SMBD transport
    and establish RDMA connection
  [CIFS] SMBD: Add definition and cache for SMBD response
  [CIFS] SMBD: Implement receive buffer for handling SMBD response
  [CIFS] SMBD: Define packet format for SMBD data transfer message
  [CIFS] SMBD: Add SMBD request and cache
  [CIFS] SMBD: Introduce wait queue when sending SMBD request
  [CIFS] SMBD: Post a receive request
  [CIFS] SMBD: Handle send completion from CQ
  [CIFS] SMBD: Implement SMBD protocol negotiation
  [CIFS] SMBD: Post a SMBD data transfer message with page payload
  [CIFS] SMBD: Post a SMBD data transfer message with data payload
  [CIFS] SMBD: Post a SMBD message with no payload
  [CIFS] SMBD: Track status for transport
  [CIFS] SMBD: Implement API for upper layer to send data
  [CIFS] SMBD: Manage credits on SMBD client and server
  [CIFS] SMBD: Implement reassembly queue for receiving data
  [CIFS] SMBD: Implement API for upper layer to receive data
  [CIFS] SMBD: Implement API for upper layer to receive data to page
  [CIFS] SMBD: Implement API for upper layer to reconnect transport
  [CIFS] SMBD: Support for SMBD keep alive protocol
  [CIFS] SMBD: Support SMBD idle connection timer
  [CIFS] SMBD: Send an immediate packet when it's needed
  [CIFS] SMBD: Destroy transport when RDMA channel is disconnected
  [CIFS] SMBD: Implement API for upper layer to destroy the transport
  [CIFS] SMBD: Disconnect RDMA connection on QP errors
  [CIFS] SMBD: Add SMBDirect transport to Makefile
  [CIFS] Add SMBD transport to SMB session context
  [CIFS] Add SMBD debug couters to CIFS debug exports
  [CIFS] Connect to SMBD transport when specified in mount option
  [CIFS] Reconnect to SMBD transport when it's used
  [CIFS] Destroy SMBD transport on exit
  [CIFS] Read from SMBD transport when it's used
  [CIFS] Write to SMBD transport when it's used

 fs/cifs/Makefile     |    2 +-
 fs/cifs/cifs_debug.c |   25 +
 fs/cifs/cifsfs.c     |    2 +
 fs/cifs/cifsglob.h   |    3 +
 fs/cifs/cifsrdma.c   | 1833 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsrdma.h   |  243 +++++++
 fs/cifs/connect.c    |   56 +-
 fs/cifs/transport.c  |    7 +
 8 files changed, 2164 insertions(+), 7 deletions(-)
 create mode 100644 fs/cifs/cifsrdma.c
 create mode 100644 fs/cifs/cifsrdma.h

-- 
2.7.4
