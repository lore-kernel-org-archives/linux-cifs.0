From: Long Li <longli@microsoft.com>
Subject: RE: [RFC PATCH 09/09] Introduce cache=rdma moutning option
Date: Fri, 18 May 2018 19:00:39 +0000
Message-ID: <MWHPR2101MB07297B07D495D66A1C9416FACE900@MWHPR2101MB0729.namprd21.prod.outlook.com>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
 <20180518002214.5657-10-longli@linuxonhyperv.com>
 <20180518072631.GA19250@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518072631.GA19250@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> Subject: Re: [RFC PATCH 09/09] Introduce cache=3Drdma moutning option
>=20
> On Thu, May 17, 2018 at 05:22:14PM -0700, Long Li wrote:
> > From: Long Li <longli@microsoft.com>
> >
> > When cache=3Drdma is enabled on mount options, CIFS do not allocate
> > internal data buffer pages for I/O, data is read/writen directly to use=
r
> memory via RDMA.
>=20
> I don't think this should be an option.  For direct I/O without signing o=
r
> encryption CIFS should always use get_user_pages, with or without RDMA.

Yes this should be done for all transport. If there are no objections, I'll=
 send patches to change this.
