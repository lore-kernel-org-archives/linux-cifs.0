From: Tom Talpey <ttalpey@microsoft.com>
Subject: RE: [PATCH v5] cifs: Allocate validate negotiation request through
 kmalloc
Date: Thu, 26 Apr 2018 18:45:53 +0000
Message-ID: <MWHPR2101MB08097B137B0C9CCEC2E902BDA08E0@MWHPR2101MB0809.namprd21.prod.outlook.com>
References: <20180425183005.9347-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Long Li <longli@microsoft.com>, Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425183005.9347-1-longli@linuxonhyperv.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> -----Original Message-----
> From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.org>=
 On
> Behalf Of Long Li
> Sent: Wednesday, April 25, 2018 2:30 PM
> To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-
> technical@lists.samba.org; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org
> Cc: Long Li <longli@microsoft.com>
> Subject: [PATCH v5] cifs: Allocate validate negotiation request through k=
malloc
>=20
> From: Long Li <longli@microsoft.com>
>=20
> The data buffer allocated on the stack can't be DMA'ed, ib_dma_map_page w=
ill
> return an invalid DMA address for a buffer on stack. Even worse, this
> incorrect address can't be detected by ib_dma_mapping_error. Sending data
> from this address to hardware will not fail, but the remote peer will get
> junk data.
>=20
> Fix this by allocating the request on the heap in smb3_validate_negotiate=
.
>=20

Looks good.

Reviewed-By: Tom Talpey <ttalpey@microsoft.com>
=20
