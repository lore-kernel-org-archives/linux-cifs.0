From: Long Li <longli@microsoft.com>
Subject: RE: [[PATCH v1] 15/37] [CIFS] SMBD: Post a SMBD data transfer message
 with data payload
Date: Wed, 30 Aug 2017 18:17:03 +0000
Message-ID: <MWHPR21MB0190190191D33EA77F561910CE9C0@MWHPR21MB0190.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-16-git-send-email-longli@exchange.microsoft.com>
 <20170813102345.GG17287@infradead.org>
 <MWHPR21MB0190E9E8303EADE6A6C84D90CE9C0@MWHPR21MB0190.namprd21.prod.outlook.com>
 <20170830085138.GA4761@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170830085138.GA4761@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, August 30, 2017 1:52 AM
> To: Long Li <longli@microsoft.com>
> Cc: Christoph Hellwig <hch@infradead.org>; Steve French
> <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-
> technical@lists.samba.org; linux-kernel@vger.kernel.org
> Subject: Re: [[PATCH v1] 15/37] [CIFS] SMBD: Post a SMBD data transfer
> message with data payload
>=20
> On Wed, Aug 30, 2017 at 02:17:56AM +0000, Long Li wrote:
> > I partially addressed this issue in the V3 patch. Most of the
> > duplicate code on sending path is merged.
> >
> > The difficulty with translating the buffer to pages is that: I don't
> > know how many pages will be translated, and how many struct page I
> > need to allocate in advance to hold them. I try to avoid memory
> > allocation in the I/O path as much as possible. So I keep two
> > functions of sending data: one for buffer and one for pages.
>=20
> You do: you'll always need speace for  (len + PAGE_SIZE - 1) >> PAGE_SIZE
> pages.
>=20
> That being said: what callers even send you buffers?  In general we shoul=
d
> aim to work with pages for all allocations that aren't tiny.

I'll look through the code allocating the buffers, it probably can fit into=
 one page. Will fix this.
