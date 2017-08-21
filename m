From: Long Li <longli@microsoft.com>
Subject: RE: [Patch v2 00/19] CIFS: Implement SMBDirect
Date: Mon, 21 Aug 2017 19:50:40 +0000
Message-ID: <MWHPR21MB019081F64C50E08043286EE3CE870@MWHPR21MB0190.namprd21.prod.outlook.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
 <01ff01d31ab1$ca836a60$5f8a3f20$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Steve Wise <swise@opengridcomputing.com>,
        'Steve French' <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        'Christoph Hellwig' <hch@infradead.org>,
        "Tom Talpey" <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <01ff01d31ab1$ca836a60$5f8a3f20$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org



> -----Original Message-----
> From: Steve Wise [mailto:swise@opengridcomputing.com]
> Sent: Monday, August 21, 2017 12:15 PM
> To: Long Li <longli@microsoft.com>; 'Steve French' <sfrench@samba.org>;
> linux-cifs@vger.kernel.org; samba-technical@lists.samba.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; 'Christoph Hellwig'
> <hch@infradead.org>; Tom Talpey <ttalpey@microsoft.com>; Matthew
> Wilcox <mawilcox@microsoft.com>
> Cc: Long Li <longli@microsoft.com>
> Subject: RE: [Patch v2 00/19] CIFS: Implement SMBDirect
>=20
> [You don't often get email from SWISE@OPENGRIDCOMPUTING.COM. Learn
> why this is important at http://aka.ms/LearnAboutSenderIdentification.]
>=20
> >
> > From: Long Li <longli@microsoft.com>
> >
> > Starting with SMB2 dialect 3.0, Microsoft introduced SMBDirect
> > transport
> protocol
> > for transferring upper layer (SMB2) payload over RDMA via Infiniband,
> > RoCE or iWARP. The prococol is published in [MS-SMBD]
> >
> (https://na01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fmsdn
> > .microsoft.com%2Fen-
> &data=3D02%7C01%7Clongli%40microsoft.com%7C6082b57a9
> >
> 13844901b5b08d4e8c8ec1d%7C72f988bf86f141af91ab2d7cd011db47%7C1%7
> C0%7C6
> >
> 36389397044862458&sdata=3DMnF3ljWT9cTEfFZWmj7zVADgNSYdMFROK%2B
> WXAdfG%2FB
> > I%3D&reserved=3D0
> > us/library/hh536346.aspx).
> >
> > The patch v2 added RDMA read/write via memory registration, and
> > addressed feedbacks on v1.
> >
>=20
> Hey Long,
>=20
> What testing have you done with this on the various rdma transports?  Doe=
s
> it work over IB, RoCE, and iWARP providers?

Hi Steve,

Currently all the tests have been done over Infiniband. We haven't tested o=
n RoCE or iWARP, but planned to do it in the following weeks.

Long

>=20
> Thanks,
>=20
> Steve.
>=20
