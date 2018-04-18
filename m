From: Tom Talpey <tom@talpey.com>
Subject: Re: [Patch v3 2/6] cifs: Allocate validate negotiation request
 through kmalloc
Date: Wed, 18 Apr 2018 10:07:52 -0400
Message-ID: <b8e56b14-a746-2a22-cb8d-94f1ba7d646b@talpey.com>
References: <20180418003358.25098-1-longli@linuxonhyperv.com>
 <d7e569b6-d268-b8c1-e91d-d6dc0e7cdfc2@talpey.com>
 <e9e7f77032c5402e848de0293e4db3ee@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>
To: David Laight <David.Laight@ACULAB.COM>,
        "longli@microsoft.com" <longli@microsoft.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <e9e7f77032c5402e848de0293e4db3ee@AcuMS.aculab.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 4/18/2018 9:08 AM, David Laight wrote:
> From: Tom Talpey
>> Sent: 18 April 2018 12:32
> ...
>> On 4/17/2018 8:33 PM, Long Li wrote:
>>> From: Long Li <longli@microsoft.com>
>>>
>>> The data buffer allocated on the stack can't be DMA'ed, and hence can't send
>>> through RDMA via SMB Direct.
>>
>> This comment is confusing. Any registered memory can be DMA'd, need to
>> state the reason for the choice here more clearly.
> 
> The stack could be allocated with vmalloc().
> In which case the pages might not be physically contiguous and there is no
> (sensible) call to get the physical address required by the dma controller
> (or other bus master).

Memory registration does not requires pages to be physically contiguous.
RDMA Regions can and do support very large physical page scatter/gather,
and the adapter DMA's them readily. Is this the only reason?

Tom.
