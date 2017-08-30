From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [Patch v3 00/19] CIFS: Implement SMB Direct
Date: Wed, 30 Aug 2017 18:40:25 +0000
Message-ID: <MWHPR21MB019007BEC7B087555EB0627CCE9C0@MWHPR21MB0190.namprd21.prod.outlook.com>
References: <20170829192915.26251-1-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829192915.26251-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

> -----Original Message-----
> From: Long Li [mailto:longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org]
> Sent: Tuesday, August 29, 2017 12:29 PM
> To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-
> technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>; Tom Talpey
> <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Subject: [Patch v3 00/19] CIFS: Implement SMB Direct
>=20
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>=20
> Starting with SMB2 dialect 3.0, Microsoft introduced SMBDirect transport
> protocol for transferring upper layer (SMB2) payload over RDMA via
> Infiniband, RoCE or iWARP. The prococol is published in [MS-SMBD]
> (https://na01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fmsdn
> .microsoft.com%2Fen-
> us%2Flibrary%2Fhh536346.aspx&data=3D02%7C01%7Clongli%40microsoft.com
> %7C73e721d48ac0402f414208d4ef1470f2%7C72f988bf86f141af91ab2d7cd011
> db47%7C1%7C0%7C636396318489728526&sdata=3D3ES4XY3qXqUVEJ37YUHlMJ
> QWuxFeljzOEMhGXhmO2i0%3D&reserved=3D0).
>=20
> Patch v2 added RDMA read/write via memory registration, and addressed
> feedbacks on v1.
>=20
> Patch v3 improved performance by introducing an additional queue for
> handling empty packets and reducing lock contention on IRQ path. Also
> added light weight profiling by reading TSC and addressed feedbacks on v2=
.

I received some requests about testing the patch. Thank you for help testin=
g.

A snapshot of the development kernel with the patch set is at:
https://github.com/longlimsft/linux-next/tree/patch_v3

During development, it is tested on Infiniband with Mellanox ConnectX-3.

>=20
> Long Li (19):
>   CIFS: Add rdma mount option
>   CIFS: SMBD: Add SMBDirect protocol and transport constants
>   CIFS: SMBD: Implement SMBDirect transport
>   CIFS: SMBD: Add SMBDirect transport to SMB connection and Makefile
>   CIFS: SMBD: Connect to SMBDirect session
>   CIFS: SMBD: Reconnect to SMBDirect session
>   CIFS: SMBD: Destroy SMBDirect session on shutdown or umount
>   CIFS: SMBD: Set SMBDirect maximum read or write size for I/O
>   CIFS: SMBD: Receive data from SMBDirect
>   CIFS: SMBD: Send data through SMBDirect
>   CIFS: SMBD: Define memory registration for I/O data
>   CIFS: SMBD: Fix the definition for SMB2_CHANNEL_RDMA_V1_INVALIDATE
>   CIFS: SMBD: Implement SMB write via RDMA read through memory
>     registration
>   CIFS: SMBD: Deregister memory on finishing SMB write
>   CIFS: SMBD: Add parameter rdata to smb2_new_read_req
>   CIFS: SMBD: Read correct returned data length for RDMA write (SMB
>     read) I/O
>   CIFS: SMBD: Implement SMB read via RDMA write through memory
>     registration
>   CIFS: SMBD: Deregister memory when finishing SMB read
>   CIFS: SMBD: Add SMBDirect debug counters
>=20
>  fs/cifs/Makefile     |    2 +-
>  fs/cifs/cifs_debug.c |   84 ++
>  fs/cifs/cifsfs.c     |    2 +
>  fs/cifs/cifsglob.h   |   17 +-
>  fs/cifs/cifssmb.c    |   10 +-
>  fs/cifs/connect.c    |   46 +-
>  fs/cifs/file.c       |   10 +
>  fs/cifs/smb1ops.c    |    2 +-
>  fs/cifs/smb2ops.c    |   21 +-
>  fs/cifs/smb2pdu.c    |  114 ++-
>  fs/cifs/smb2pdu.h    |    2 +-
>  fs/cifs/smbdirect.c  | 2639
> ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smbdirect.h  |  324 +++++++
>  fs/cifs/transport.c  |    7 +
>  14 files changed, 3260 insertions(+), 20 deletions(-)  create mode 10064=
4
> fs/cifs/smbdirect.c  create mode 100644 fs/cifs/smbdirect.h
>=20
> --
> 2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
