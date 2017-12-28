From: Pavel Shilovskiy <pshilov@microsoft.com>
Subject: RE: [Patch v8 00/16] CIFS: Implement SMB Direct protocol
Date: Thu, 28 Dec 2017 21:57:26 +0000
Message-ID: <CY4PR21MB0135AF340F4DDE4E992F9316B6040@CY4PR21MB0135.namprd21.prod.outlook.com>
References: <20171123003849.17093-1-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>, Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171123003849.17093-1-longli@exchange.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2017-11-22 16:38 GMT-08:00 Long Li <longli@exchange.microsoft.com>:
> From: Long Li <longli@microsoft.com>
>
> Starting with SMB2 dialect 3.0, Microsoft introduced SMB Direct transport
> protocol for transferring upper layer (SMB2) payload over RDMA via Infini=
band,
> RoCE or iWARP. The prococol is published in [MS-SMBD]
> (https://msdn.microsoft.com/en-us/library/hh536346.aspx).
>
> Change log:
> v2:
> Implemented RDMA read/write via memory registration.
> Re-arranged patches for review [Christoph Hellwig <hch@infradead.org>].
> Restructured the code and fixed bugs on protocol timer and keepalive
> [Tom Talpey <ttalpey@microsoft.com>].
>
> v3:
> Improved performance by introducing an additional queue for handling
> empty packets and reducing lock contention on IRQ path.
> Added light weight profiling by reading TSC.
> Improved the code for checking SMB versions when mounting with rdma optio=
n
> [Leon Romanovsky <leon@kernel.org>].
> Moved to use pages instead of buffers for passing I/O for RDMA
> [Christoph Hellwig <hch@infradead.org>].
> Removed redundant code and refactored I/O code paths
> [Christoph Hellwig <hch@infradead.org>, Tom Talpey <ttalpey@microsoft.com=
>].
>
> v4:
> Fixed connectivity issues with iWAPR devices.
> Exported configurable protocol parameters to /proc/fs/cifs
> [Steve French <sfrench@samba.org>]
> Re-arranged patches for review
> [Pavel Shilovsky <piastryyy@gmail.com>].
>
> v5:
> Fixed compiling errors on ia64, i386 and when INFINIBAND is not
> configured. [kbuild test robot]
> Profiling is removed and will be introduced in a seperate patch.
>
> v6:
> Report internal code error via WARN_ON(). Change description in
> Kconfig [Pavel Shilovsky <piastryyy@gmail.com>].
>
> v7:
> Removed the use of #ifdef CONFIG_CIFS_SMB_DIRECT in upper layer
> code calling transport I/O. [Matthew Wilcox <mawilcox@microsoft.com>,
> Tom Talpey <ttalpey@microsoft.com>]
>
> v8:
> Fixed comment typos and removed unused code
> [Ronnie Sahlberg <lsahlber@redhat.com>]
> Removed the first 7 patches in v7, which have been merged.
> Restructed the code to move relevant function definitions to later patche=
s.
> [Pavel Shilovsky <piastryyy@gmail.com>]
> Added a patch to disable signing when RDMA is in use. Signing will be
> enabled after it is properly implemented in SMB Direct code paths.
> Fixed an issue on passing the incorrect offset to smbd_buffer_descriptor_=
v1
> when RDMA read is used for SMB write. This was caused by recent CIFS
> patches to remove packet length from SMB2 packet header.
>
> Long Li (16):
>   CIFS: SMBD: Upper layer connects to SMBDirect session
>   CIFS: SMBD: Implement function to reconnect to a SMB Direct transport
>   CIFS: SMBD: Upper layer reconnects to SMB Direct session
>   CIFS: SMBD: Implement function to destroy a SMB Direct connection
>   CIFS: SMBD: Upper layer destroys SMB Direct session on shutdown or
>     umount
>   CIFS: SMBD: Set SMB Direct maximum read or write size for I/O
>   CIFS: SMBD: Implement function to receive data via RDMA receive
>   CIFS: SMBD: Upper layer receives data via RDMA receive
>   CIFS: SMBD: Implement function to send data via RDMA send
>   CIFS: SMBD: Upper layer sends data via RDMA send
>   CIFS: SMBD: Implement RDMA memory registration
>   CIFS: SMBD: Upper layer performs SMB write via RDMA read through
>     memory registration
>   CIFS: SMBD: Read correct returned data length for RDMA write (SMB
>     read) I/O
>   CIFS: SMBD: Upper layer performs SMB read via RDMA write through
>     memory registration
>   CIFS: SMBD: Add SMB Direct debug counters
>   CIFS: SMBD: Disable signing on SMB direct transport
>
>  fs/cifs/cifs_debug.c |  66 ++++
>  fs/cifs/cifsglob.h   |  16 +-
>  fs/cifs/cifssmb.c    |  15 +-
>  fs/cifs/connect.c    |  46 ++-
>  fs/cifs/file.c       |  17 +-
>  fs/cifs/smb1ops.c    |   4 +-
>  fs/cifs/smb2ops.c    |  24 +-
>  fs/cifs/smb2pdu.c    | 117 ++++++-
>  fs/cifs/smbdirect.c  | 947 +++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/cifs/smbdirect.h  |  72 ++++
>  fs/cifs/transport.c  |   8 +-
>  11 files changed, 1308 insertions(+), 24 deletions(-)
>
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
