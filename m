From: Long Li <longli@microsoft.com>
Subject: RE: [[PATCH v1] 15/37] [CIFS] SMBD: Post a SMBD data transfer message
 with data payload
Date: Wed, 30 Aug 2017 02:17:56 +0000
Message-ID: <MWHPR21MB0190E9E8303EADE6A6C84D90CE9C0@MWHPR21MB0190.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-16-git-send-email-longli@exchange.microsoft.com>
 <20170813102345.GG17287@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170813102345.GG17287@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Sunday, August 13, 2017 3:24 AM
> To: Long Li <longli@microsoft.com>
> Cc: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-
> technical@lists.samba.org; linux-kernel@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: Re: [[PATCH v1] 15/37] [CIFS] SMBD: Post a SMBD data transfer
> message with data payload
>=20
> You can always get the struct page for kernel allocations using virt_to_p=
age
> (or vmalloc_to_page, but this code would not handle the vmalloc case eith=
er),
> so I don't think you need this helper and can always use the one added in=
 the
> previous patch.

I partially addressed this issue in the V3 patch. Most of the duplicate cod=
e on sending path is merged.

The difficulty with translating the buffer to pages is that: I don't know h=
ow many pages will be translated, and how many struct page I need to alloca=
te in advance to hold them. I try to avoid memory allocation in the I/O pat=
h as much as possible. So I keep two functions of sending data: one for buf=
fer and one for pages.
