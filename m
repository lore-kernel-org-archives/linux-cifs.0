From: Steve French <smfrench@gmail.com>
Subject: Re: [Patch v2 2/6] cifs: Allocate validate negotiation request
 through kmalloc
Date: Tue, 17 Apr 2018 15:37:10 -0500
Message-ID: <CAH2r5muTc79_PLn=O1ZQfzMQLQO9JkW4yvEZyp1O9qTFRWS8ig@mail.gmail.com>
References: <20180417191710.14855-1-longli@linuxonhyperv.com>
 <20180417191710.14855-2-longli@linuxonhyperv.com> <VI1PR0502MB30080A26FFC2A6132397C549D1B70@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <MWHPR2101MB0729D25984E4C57E79355794CEB70@MWHPR2101MB0729.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Parav Pandit <parav@mellanox.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
To: Long Li <longli@microsoft.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <MWHPR2101MB0729D25984E4C57E79355794CEB70@MWHPR2101MB0729.namprd21.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Apr 17, 2018 at 3:11 PM, Long Li via samba-technical
<samba-technical@lists.samba.org> wrote:
>> Subject: RE: [Patch v2 2/6] cifs: Allocate validate negotiation request through
>> kmalloc
>>
>>
>>
>> > -----Original Message-----
>> > From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
>> > owner@vger.kernel.org] On Behalf Of Long Li
>> > Sent: Tuesday, April 17, 2018 2:17 PM
>> > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org;
>> > samba- technical@lists.samba.org; linux-kernel@vger.kernel.org; linux-
>> > rdma@vger.kernel.org
>> > Cc: longli <longli@microsoft.com>; stable@vger.kernel.org
>> > Subject: [Patch v2 2/6] cifs: Allocate validate negotiation request
>> > through kmalloc
>> >
>> > From: Long Li <longli@microsoft.com>
>> >
>> > The data buffer allocated on the stack can't be DMA'ed, and hence
>> > can't send through RDMA via SMB Direct.
>> >
>> > Fix this by allocating the request on the heap in smb3_validate_negotiate.
>> >
>> > Fixes: ff1c038addc4f205d5f1ede449426c7d316c0eed "Check SMB3 dialects
>> > against downgrade attacks"
>> >
>>
>> Format is:
>> Fixes: ff1c038addc4 ("Check SMB3 dialects against downgrade attacks") It
>> should be right above Signed-off signature.
>
> I will fix up and resend this patch.
>
> How about the rest patches (1, 3-6) in the series? If they don't need any changes, is it okay that I resend this one only?

Doesn't matter to me either way - I already merged patch 1 in any case.

>> > Changes in v2:
>> > Removed duplicated code on freeing buffers on function exit.
>> > (Thanks to Parav Pandit <parav@mellanox.com>)



-- 
Thanks,

Steve
