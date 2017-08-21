From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [Patch v2 00/19] CIFS: Implement SMBDirect
Date: Mon, 21 Aug 2017 14:56:04 -0500
Message-ID: <027d01d31ab7$85adbed0$91093c70$@opengridcomputing.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com> <01ff01d31ab1$ca836a60$5f8a3f20$@opengridcomputing.com> <MWHPR21MB019081F64C50E08043286EE3CE870@MWHPR21MB0190.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "'Long Li'" <longli@microsoft.com>,
        "'Steve French'" <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Tom Talpey'" <ttalpey@microsoft.com>,
        "'Matthew Wilcox'" <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR21MB019081F64C50E08043286EE3CE870@MWHPR21MB0190.namprd21.prod.outlook.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> >
> > Hey Long,
> >
> > What testing have you done with this on the various rdma transports?  Does
> > it work over IB, RoCE, and iWARP providers?
> 
> Hi Steve,
> 
> Currently all the tests have been done over Infiniband. We haven't tested on
RoCE
> or iWARP, but planned to do it in the following weeks.
> 
> Long

Ok, good.

Is this series available on github or somewhere so we can clone it and review it
as it is applied to the kernel src?

Thanks,

Steve.
