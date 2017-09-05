From: Long Li <longli@microsoft.com>
Subject: RE: [Patch v2 00/19] CIFS: Implement SMBDirect
Date: Tue, 5 Sep 2017 17:42:06 +0000
Message-ID: <MWHPR21MB019029EE2B55A72AB14EFA7DCE960@MWHPR21MB0190.namprd21.prod.outlook.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
 <01ff01d31ab1$ca836a60$5f8a3f20$@opengridcomputing.com>
 <MWHPR21MB019081F64C50E08043286EE3CE870@MWHPR21MB0190.namprd21.prod.outlook.com>
 <027d01d31ab7$85adbed0$91093c70$@opengridcomputing.com>
 <MWHPR21MB0190AD423095EEA25CA6CD81CE870@MWHPR21MB0190.namprd21.prod.outlook.com>
 <MWHPR21MB0190050F3699CDF6F52B51A2CE9F0@MWHPR21MB0190.namprd21.prod.outlook.com>
 <001b01d32664$5640f8c0$02c2ea40$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: 'Venkatesh Pottem' <venkatesh@chelsio.com>
To: Steve Wise <swise@opengridcomputing.com>,
        'Steve French' <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        'Christoph Hellwig' <hch@infradead.org>,
        "Tom Talpey" <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <001b01d32664$5640f8c0$02c2ea40$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> Hey Long, how do I request a CIFS RDMA mount from the Linux client?  Is
> there a mount.cifs option?  If so, where can I get the mount.cifs code th=
at
> enables this?  Or is there some other way?

You can use "-o rdma" in the mount option to connect to RDMA.
For example: "mount.cifs -o rdma,vers=3D3.02"

The change to the mount option is in the patch series.

>=20
> Thanks,
>=20
> Steve.
