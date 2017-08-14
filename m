From: Tom Talpey <ttalpey@microsoft.com>
Subject: RE: [[PATCH v1] 22/37] [CIFS] SMBD: Implement API for upper layer to
 receive data to page
Date: Mon, 14 Aug 2017 20:59:50 +0000
Message-ID: <CY4PR21MB01829AB77CFC2120457DDB67A08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-23-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Long Li <longli@microsoft.com>, Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-23-git-send-email-longli@exchange.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> -----Original Message-----
> From: linux-cifs-owner@vger.kernel.org [mailto:linux-cifs-
> owner@vger.kernel.org] On Behalf Of Long Li
> Sent: Wednesday, August 2, 2017 4:11 PM
> To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-
> technical@lists.samba.org; linux-kernel@vger.kernel.org
> Cc: Long Li <longli@microsoft.com>
> Subject: [[PATCH v1] 22/37] [CIFS] SMBD: Implement API for upper layer to
> receive data to page
>=20
>  /*
> + * Read a page from receive reassembly queue
> + * page: the page to read data into
> + * to_read: the length of data to read
> + * return value: actual data read
> + */
> +int cifs_rdma_read_page(struct cifs_rdma_info *info,
> +               struct page *page, unsigned int to_read)
> +{

Same comment as for cifs_rdma_write() - this name is confusing as it
does not perform an RDMA Read. Needs to be changed.

Tom.
