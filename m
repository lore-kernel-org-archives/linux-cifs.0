From: Long Li <longli@microsoft.com>
Subject: RE: [Patch v2 00/19] CIFS: Implement SMBDirect
Date: Mon, 21 Aug 2017 20:23:38 +0000
Message-ID: <MWHPR21MB0190AD423095EEA25CA6CD81CE870@MWHPR21MB0190.namprd21.prod.outlook.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
 <01ff01d31ab1$ca836a60$5f8a3f20$@opengridcomputing.com>
 <MWHPR21MB019081F64C50E08043286EE3CE870@MWHPR21MB0190.namprd21.prod.outlook.com>
 <027d01d31ab7$85adbed0$91093c70$@opengridcomputing.com>
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
In-Reply-To: <027d01d31ab7$85adbed0$91093c70$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> > > Hey Long,
> > >
> > > What testing have you done with this on the various rdma transports?
> > > Does it work over IB, RoCE, and iWARP providers?
> >
> > Hi Steve,
> >
> > Currently all the tests have been done over Infiniband. We haven't
> > tested on
> RoCE
> > or iWARP, but planned to do it in the following weeks.
> >
> > Long
>=20
> Ok, good.
>=20
> Is this series available on github or somewhere so we can clone it and re=
view
> it as it is applied to the kernel src?

Unfortunately they are not on github. I will look into putting them there f=
or review. Will update soon.

Thanks for helping out!

>=20
> Thanks,
>=20
> Steve.
