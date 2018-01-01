From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch v8 00/16] CIFS: Implement SMB Direct protocol
Date: Mon, 1 Jan 2018 18:28:12 -0500 (EST)
Message-ID: <268646755.2430987.1514849292814.JavaMail.zimbra@redhat.com>
References: <20171123003849.17093-1-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171123003849.17093-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


----- Original Message -----
From: "Long Li" <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
To: "Steve French" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Christoph Hellwig" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Tom Talpey" <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "Matthew Wilcox" <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "Stephen Hemminger" <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: "Long Li" <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sent: Thursday, 23 November, 2017 11:38:33 AM
Subject: [Patch v8 00/16] CIFS: Implement SMB Direct protocol

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Starting with SMB2 dialect 3.0, Microsoft introduced SMB Direct transport
protocol for transferring upper layer (SMB2) payload over RDMA via Infiniband,
RoCE or iWARP. The prococol is published in [MS-SMBD]
(https://msdn.microsoft.com/en-us/library/hh536346.aspx).

Change log:
v2:
Implemented RDMA read/write via memory registration.
Re-arranged patches for review [Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>].
Restructured the code and fixed bugs on protocol timer and keepalive
[Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>].

v3:
Improved performance by introducing an additional queue for handling
empty packets and reducing lock contention on IRQ path.
Added light weight profiling by reading TSC.
Improved the code for checking SMB versions when mounting with rdma option
[Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>].
Moved to use pages instead of buffers for passing I/O for RDMA
[Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>].
Removed redundant code and refactored I/O code paths
[Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>].

v4:
Fixed connectivity issues with iWAPR devices.
Exported configurable protocol parameters to /proc/fs/cifs
[Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>]
Re-arranged patches for review
[Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>].

v5:
Fixed compiling errors on ia64, i386 and when INFINIBAND is not
configured. [kbuild test robot]
Profiling is removed and will be introduced in a seperate patch.

v6:
Report internal code error via WARN_ON(). Change description in
Kconfig [Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>].

v7:
Removed the use of #ifdef CONFIG_CIFS_SMB_DIRECT in upper layer
code calling transport I/O. [Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>]

v8:
Fixed comment typos and removed unused code
[Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>]
Removed the first 7 patches in v7, which have been merged.
Restructed the code to move relevant function definitions to later patches.
[Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>]
Added a patch to disable signing when RDMA is in use. Signing will be
enabled after it is properly implemented in SMB Direct code paths.
Fixed an issue on passing the incorrect offset to smbd_buffer_descriptor_v1
when RDMA read is used for SMB write. This was caused by recent CIFS
patches to remove packet length from SMB2 packet header.

Long Li (16):
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
  CIFS: SMBD: Disable signing on SMB direct transport

 fs/cifs/cifs_debug.c |  66 ++++
 fs/cifs/cifsglob.h   |  16 +-
 fs/cifs/cifssmb.c    |  15 +-
 fs/cifs/connect.c    |  46 ++-
 fs/cifs/file.c       |  17 +-
 fs/cifs/smb1ops.c    |   4 +-
 fs/cifs/smb2ops.c    |  24 +-
 fs/cifs/smb2pdu.c    | 117 ++++++-
 fs/cifs/smbdirect.c  | 947 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smbdirect.h  |  72 ++++
 fs/cifs/transport.c  |   8 +-
 11 files changed, 1308 insertions(+), 24 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
