From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Patch v7 00/22] CIFS: Implement SMB Direct protocol
Date: Mon, 20 Nov 2017 23:16:20 -0600
Message-ID: <CAH2r5mswDyvdmgsM9+rae1vy6JdxN8-YHUs67vywqDxqcp5YNA@mail.gmail.com>
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107085514.12693-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

Have remerged (to cifs-2.6.git for-next) the first seven in this
series - after he incorporated the fixes for the recent feedback on
the series to a few (and I cleaned up a few minor checkpatch nits).

On Tue, Nov 7, 2017 at 2:54 AM, Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org> wrote:
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> Starting with SMB2 dialect 3.0, Microsoft introduced SMB Direct transport
> protocol for transferring upper layer (SMB2) payload over RDMA via Infiniband,
> RoCE or iWARP. The prococol is published in [MS-SMBD]
> (https://msdn.microsoft.com/en-us/library/hh536346.aspx).
>
> Change log:
> v2:
> Implemented RDMA read/write via memory registration.
> Re-arranged patches for review [Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>].
> Restructured the code and fixed bugs on protocol timer and keepalive
> [Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>].
>
> v3:
> Improved performance by introducing an additional queue for handling
> empty packets and reducing lock contention on IRQ path.
> Added light weight profiling by reading TSC.
> Improved the code for checking SMB versions when mounting with rdma option
> [Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>].
> Moved to use pages instead of buffers for passing I/O for RDMA
> [Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>].
> Removed redundant code and refactored I/O code paths
> [Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>].
>
> v4:
> Fixed connectivity issues with iWAPR devices.
> Exported configurable protocol parameters to /proc/fs/cifs
> [Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>]
> Re-arranged patches for review
> [Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>].
>
> v5:
> Fixed compiling errors on ia64, i386 and when INFINIBAND is not
> configured. [kbuild test robot]
> Profiling is removed and will be introduced in a seperate patch.
>
> v6:
> Report internal code error via WARN_ON(). Change description in
> Kconfig [Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>].
>
> v7:
> Removed the use of #ifdef CONFIG_CIFS_SMB_DIRECT in upper layer
> code calling transport I/O. [Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
> Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>]
>
> Long Li (22):
>   CIFS: SMBD: Add parameter rdata to smb2_new_read_req
>   CIFS: SMBD: Introduce kernel config option CONFIG_CIFS_SMB_DIRECT
>   CIFS: SMBD: Add rdma mount option
>   CIFS: SMBD: Add SMB Direct protocol initial values and constants
>   CIFS: SMBD: Establish SMB Direct connection
>   CIFS: SMBD: export protocol initial values
>   CIFS: SMBD: Implement function to create a SMB Direct connection
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
>
>  fs/cifs/Kconfig      |    8 +
>  fs/cifs/Makefile     |    2 +
>  fs/cifs/cifs_debug.c |  147 +++
>  fs/cifs/cifsfs.c     |    2 +
>  fs/cifs/cifsglob.h   |   21 +-
>  fs/cifs/cifssmb.c    |   15 +-
>  fs/cifs/connect.c    |   53 +-
>  fs/cifs/file.c       |   17 +-
>  fs/cifs/smb1ops.c    |    4 +-
>  fs/cifs/smb2ops.c    |   24 +-
>  fs/cifs/smb2pdu.c    |  127 ++-
>  fs/cifs/smbdirect.c  | 2617 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smbdirect.h  |  330 +++++++
>  fs/cifs/transport.c  |    8 +-
>  14 files changed, 3344 insertions(+), 31 deletions(-)
>  create mode 100644 fs/cifs/smbdirect.c
>  create mode 100644 fs/cifs/smbdirect.h
>
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
