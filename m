From: Steve French <smfrench@gmail.com>
Subject: Re: [Patch v3 02/19] CIFS: SMBD: Add SMBDirect protocol and transport constants
Date: Fri, 1 Sep 2017 10:48:41 -0500
Message-ID: <CAH2r5msrKKaPbRsq5e-tHLk-zqM7g882wR3YurFywieAe9DYoA@mail.gmail.com>
References: <20170829192915.26251-1-longli@exchange.microsoft.com>
 <20170829192915.26251-3-longli@exchange.microsoft.com> <CAKywueQ3Vz9NUwfqgk36pnaXN=r3DDrrNAumMP418EkcXQPT9g@mail.gmail.com>
 <MWHPR21MB0190D3CB134749B54A0F709ECE9F0@MWHPR21MB0190.namprd21.prod.outlook.com>
 <CAKywueTyhmP+p=bLCmvK8pzGNKRfeh1x_B9OGWKzt77eAz3Sdg@mail.gmail.com>
 <MWHPR21MB01907DFB1D1CBEDB17FD995ECE9C0@MWHPR21MB0190.namprd21.prod.outlook.com>
 <CAKywueTX83Y35tyXM=zQSVeCBFE-Z3ANNkbZ-XhTF6fYdFfaaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Long Li <longli@microsoft.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        samba-technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>
To: Pavel Shilovsky <piastryyy@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKywueTX83Y35tyXM=zQSVeCBFE-Z3ANNkbZ-XhTF6fYdFfaaA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Probably easier to configure in /proc/fs/cifs than as module param

On Wed, Aug 30, 2017 at 1:30 PM, Pavel Shilovsky via samba-technical
<samba-technical@lists.samba.org> wrote:
> 2017-08-30 11:24 GMT-07:00 Long Li <longli@microsoft.com>:
>>> -----Original Message-----
>>> From: Pavel Shilovsky [mailto:piastryyy@gmail.com]
>>> Sent: Wednesday, August 30, 2017 11:19 AM
>>> To: Long Li <longli@microsoft.com>
>>> Cc: Steve French <sfrench@samba.org>; linux-cifs <linux-
>>> cifs@vger.kernel.org>; samba-technical <samba-technical@lists.samba.org>;
>>> Kernel Mailing List <linux-kernel@vger.kernel.org>; linux-
>>> rdma@vger.kernel.org; Christoph Hellwig <hch@infradead.org>; Tom Talpey
>>> <ttalpey@microsoft.com>; Matthew Wilcox <mawilcox@microsoft.com>
>>> Subject: Re: [Patch v3 02/19] CIFS: SMBD: Add SMBDirect protocol and
>>> transport constants
>>>
>>> 2017-08-29 16:00 GMT-07:00 Long Li <longli@microsoft.com>:
>>> >> -----Original Message-----
>>> >> From: Pavel Shilovsky [mailto:piastryyy@gmail.com]
>>> >> Sent: Tuesday, August 29, 2017 3:45 PM
>>> >> To: Long Li <longli@microsoft.com>
>>> >> Cc: Steve French <sfrench@samba.org>; linux-cifs <linux-
>>> >> cifs@vger.kernel.org>; samba-technical
>>> >> <samba-technical@lists.samba.org>;
>>> >> Kernel Mailing List <linux-kernel@vger.kernel.org>; linux-
>>> >> rdma@vger.kernel.org; Christoph Hellwig <hch@infradead.org>; Tom
>>> >> Talpey <ttalpey@microsoft.com>; Matthew Wilcox
>>> >> <mawilcox@microsoft.com>; Long Li <longli@microsoft.com>
>>> >> Subject: Re: [Patch v3 02/19] CIFS: SMBD: Add SMBDirect protocol and
>>> >> transport constants
>>> >>
>>> >> 2017-08-29 12:28 GMT-07:00 Long Li <longli@exchange.microsoft.com>:
>>> >> > From: Long Li <longli@microsoft.com>
>>> >> >
>>> >> > To prepare for protocol implementation, add constants and
>>> >> > user-configurable values in the SMBDirect protocol.
>>> >> >
>>> >> > Signed-off-by: Long Li <longli@microsoft.com>
>>> >> > ---
>>> >> >  fs/cifs/smbdirect.c | 78
>>> >> > +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>> >> >  fs/cifs/smbdirect.h | 20 ++++++++++++++
>>> >> >  2 files changed, 98 insertions(+)
>>> >> >  create mode 100644 fs/cifs/smbdirect.c  create mode 100644
>>> >> > fs/cifs/smbdirect.h
>>> >> >
>>> >> > diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c new file
>>> >> > mode
>>> >> > 100644 index 0000000..d785bc1
>>> >> > --- /dev/null
>>> >> > +++ b/fs/cifs/smbdirect.c
>>> >> > @@ -0,0 +1,78 @@
>>> >> > +/*
>>> >> > + *   Copyright (C) 2017, Microsoft Corporation.
>>> >> > + *
>>> >> > + *   Author(s): Long Li <longli@microsoft.com>
>>> >> > + *
>>> >> > + *   This program is free software;  you can redistribute it and/or modify
>>> >> > + *   it under the terms of the GNU General Public License as published
>>> by
>>> >> > + *   the Free Software Foundation; either version 2 of the License, or
>>> >> > + *   (at your option) any later version.
>>> >> > + *
>>> >> > + *   This program is distributed in the hope that it will be useful,
>>> >> > + *   but WITHOUT ANY WARRANTY;  without even the implied warranty
>>> of
>>> >> > + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
>>> >> > + *   the GNU General Public License for more details.
>>> >> > + */
>>> >> > +#include <linux/module.h>
>>> >> > +#include "smbdirect.h"
>>> >> > +#include "cifs_debug.h"
>>> >> > +
>>> >> > +/* SMBD version number */
>>> >> > +#define SMBD_V1        0x0100
>>> >> > +
>>> >> > +/* Port numbers for SMBD transport */
>>> >> > +#define SMB_PORT       445
>>> >> > +#define SMBD_PORT      5445
>>> >> > +
>>> >> > +/* Address lookup and resolve timeout in ms */
>>> >> > +#define RDMA_RESOLVE_TIMEOUT   5000
>>> >> > +
>>> >> > +/* SMBD negotiation timeout in seconds */ #define
>>> >> > +SMBD_NEGOTIATE_TIMEOUT 120
>>> >> > +
>>> >> > +/* SMBD minimum receive size and fragmented sized defined in [MS-
>>> >> SMBD] */
>>> >> > +#define SMBD_MIN_RECEIVE_SIZE          128
>>> >> > +#define SMBD_MIN_FRAGMENTED_SIZE       131072
>>> >> > +
>>> >> > +/*
>>> >> > + * Default maximum number of RDMA read/write outstanding on this
>>> >> > +connection
>>> >> > + * This value is possibly decreased during QP creation on hardware
>>> >> > +limit  */
>>> >> > +#define SMBD_CM_RESPONDER_RESOURCES    32
>>> >> > +
>>> >> > +/* Maximum number of retries on data transfer operations */
>>> >> > +#define SMBD_CM_RETRY                  6
>>> >> > +/* No need to retry on Receiver Not Ready since SMBD manages
>>> >> > +credits
>>> >> */
>>> >> > +#define SMBD_CM_RNR_RETRY              0
>>> >> > +
>>> >> > +/*
>>> >> > + * User configurable initial values per SMBD transport connection
>>> >> > + * as defined in [MS-SMBD] 3.1.1.1
>>> >> > + * Those may change after a SMBD negotiation  */
>>> >>
>>> >> Since these value are per transport connection, why they are global?
>>> >> Shouldn't they be inside a some structure that is created for a
>>> >> particular connection? Also the constants below should be defines.
>>> >
>>> > Those are configurable initial values (default values) for all connections.
>>> >
>>> > Each connection has its own values based on those initial values. But
>>> connection-based values can change after negotiation is done, or after
>>> RDMA hardware capabilities are probed.
>>>
>>> If these are configurable values, let's add a way to actually configure them.
>>> Through /proc?
>>
>> You mean putting them in /proc/fs/cifs?
>>
>> Or how about module_param?
>
> I am ok with either way. If it is safe to change them without
> reloading the module let's do /proc/fs/cifs which would make it easier
> to use. Otherwise - module_param is also good.
>
> --
> Best regards,
> Pavel Shilovsky
>



-- 
Thanks,

Steve
