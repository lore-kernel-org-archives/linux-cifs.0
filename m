From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Patch v3 02/19] CIFS: SMBD: Add SMBDirect protocol and transport constants
Date: Wed, 30 Aug 2017 11:30:15 -0700
Message-ID: <CAKywueTX83Y35tyXM=zQSVeCBFE-Z3ANNkbZ-XhTF6fYdFfaaA@mail.gmail.com>
References: <20170829192915.26251-1-longli@exchange.microsoft.com>
 <20170829192915.26251-3-longli@exchange.microsoft.com> <CAKywueQ3Vz9NUwfqgk36pnaXN=r3DDrrNAumMP418EkcXQPT9g@mail.gmail.com>
 <MWHPR21MB0190D3CB134749B54A0F709ECE9F0@MWHPR21MB0190.namprd21.prod.outlook.com>
 <CAKywueTyhmP+p=bLCmvK8pzGNKRfeh1x_B9OGWKzt77eAz3Sdg@mail.gmail.com> <MWHPR21MB01907DFB1D1CBEDB17FD995ECE9C0@MWHPR21MB0190.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <MWHPR21MB01907DFB1D1CBEDB17FD995ECE9C0-saRRjQKJ25M/hL2NnenhuM1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-08-30 11:24 GMT-07:00 Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>:
>> -----Original Message-----
>> From: Pavel Shilovsky [mailto:piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> Sent: Wednesday, August 30, 2017 11:19 AM
>> To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs <linux-
>> cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>;
>> Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; linux-
>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>; Tom Talpey
>> <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>> Subject: Re: [Patch v3 02/19] CIFS: SMBD: Add SMBDirect protocol and
>> transport constants
>>
>> 2017-08-29 16:00 GMT-07:00 Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>:
>> >> -----Original Message-----
>> >> From: Pavel Shilovsky [mailto:piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> >> Sent: Tuesday, August 29, 2017 3:45 PM
>> >> To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>> >> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs <linux-
>> >> cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; samba-technical
>> >> <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>;
>> >> Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; linux-
>> >> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>; Tom
>> >> Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Matthew Wilcox
>> >> <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>> >> Subject: Re: [Patch v3 02/19] CIFS: SMBD: Add SMBDirect protocol and
>> >> transport constants
>> >>
>> >> 2017-08-29 12:28 GMT-07:00 Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>:
>> >> > From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>> >> >
>> >> > To prepare for protocol implementation, add constants and
>> >> > user-configurable values in the SMBDirect protocol.
>> >> >
>> >> > Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>> >> > ---
>> >> >  fs/cifs/smbdirect.c | 78
>> >> > +++++++++++++++++++++++++++++++++++++++++++++++++++++
>> >> >  fs/cifs/smbdirect.h | 20 ++++++++++++++
>> >> >  2 files changed, 98 insertions(+)
>> >> >  create mode 100644 fs/cifs/smbdirect.c  create mode 100644
>> >> > fs/cifs/smbdirect.h
>> >> >
>> >> > diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c new file
>> >> > mode
>> >> > 100644 index 0000000..d785bc1
>> >> > --- /dev/null
>> >> > +++ b/fs/cifs/smbdirect.c
>> >> > @@ -0,0 +1,78 @@
>> >> > +/*
>> >> > + *   Copyright (C) 2017, Microsoft Corporation.
>> >> > + *
>> >> > + *   Author(s): Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>> >> > + *
>> >> > + *   This program is free software;  you can redistribute it and/or modify
>> >> > + *   it under the terms of the GNU General Public License as published
>> by
>> >> > + *   the Free Software Foundation; either version 2 of the License, or
>> >> > + *   (at your option) any later version.
>> >> > + *
>> >> > + *   This program is distributed in the hope that it will be useful,
>> >> > + *   but WITHOUT ANY WARRANTY;  without even the implied warranty
>> of
>> >> > + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
>> >> > + *   the GNU General Public License for more details.
>> >> > + */
>> >> > +#include <linux/module.h>
>> >> > +#include "smbdirect.h"
>> >> > +#include "cifs_debug.h"
>> >> > +
>> >> > +/* SMBD version number */
>> >> > +#define SMBD_V1        0x0100
>> >> > +
>> >> > +/* Port numbers for SMBD transport */
>> >> > +#define SMB_PORT       445
>> >> > +#define SMBD_PORT      5445
>> >> > +
>> >> > +/* Address lookup and resolve timeout in ms */
>> >> > +#define RDMA_RESOLVE_TIMEOUT   5000
>> >> > +
>> >> > +/* SMBD negotiation timeout in seconds */ #define
>> >> > +SMBD_NEGOTIATE_TIMEOUT 120
>> >> > +
>> >> > +/* SMBD minimum receive size and fragmented sized defined in [MS-
>> >> SMBD] */
>> >> > +#define SMBD_MIN_RECEIVE_SIZE          128
>> >> > +#define SMBD_MIN_FRAGMENTED_SIZE       131072
>> >> > +
>> >> > +/*
>> >> > + * Default maximum number of RDMA read/write outstanding on this
>> >> > +connection
>> >> > + * This value is possibly decreased during QP creation on hardware
>> >> > +limit  */
>> >> > +#define SMBD_CM_RESPONDER_RESOURCES    32
>> >> > +
>> >> > +/* Maximum number of retries on data transfer operations */
>> >> > +#define SMBD_CM_RETRY                  6
>> >> > +/* No need to retry on Receiver Not Ready since SMBD manages
>> >> > +credits
>> >> */
>> >> > +#define SMBD_CM_RNR_RETRY              0
>> >> > +
>> >> > +/*
>> >> > + * User configurable initial values per SMBD transport connection
>> >> > + * as defined in [MS-SMBD] 3.1.1.1
>> >> > + * Those may change after a SMBD negotiation  */
>> >>
>> >> Since these value are per transport connection, why they are global?
>> >> Shouldn't they be inside a some structure that is created for a
>> >> particular connection? Also the constants below should be defines.
>> >
>> > Those are configurable initial values (default values) for all connections.
>> >
>> > Each connection has its own values based on those initial values. But
>> connection-based values can change after negotiation is done, or after
>> RDMA hardware capabilities are probed.
>>
>> If these are configurable values, let's add a way to actually configure them.
>> Through /proc?
>
> You mean putting them in /proc/fs/cifs?
>
> Or how about module_param?

I am ok with either way. If it is safe to change them without
reloading the module let's do /proc/fs/cifs which would make it easier
to use. Otherwise - module_param is also good.

--
Best regards,
Pavel Shilovsky
