From: Long Li <longli@microsoft.com>
Subject: RE: [[PATCH v1] 12/37] [CIFS] SMBD: Handle send completion from CQ
Date: Mon, 14 Aug 2017 18:16:28 +0000
Message-ID: <CY4PR21MB01825EDE87042ABC428F6691CE8C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-13-git-send-email-longli@exchange.microsoft.com>
 <20170813101945.GE17287@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170813101945.GE17287@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Sunday, August 13, 2017 3:20 AM
> To: Long Li <longli@microsoft.com>
> Cc: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-
> technical@lists.samba.org; linux-kernel@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: Re: [[PATCH v1] 12/37] [CIFS] SMBD: Handle send completion from
> CQ
>=20
> You seem to be doing memory allocations and frees for every packet on the
> write.  At least for other RDMA protocols that would have been a major
> performance issue.

The size of SGE array passed to IB is unknown, so I don't know how much to =
pre-allocate in advance. But it seems this size is not big when passed down=
 from CIFS. I will look at pre-allocating buffer if this is an issue.

>=20
> Do you have any performance numbers and/or profiles of the code?

I will look into profiling.
