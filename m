From: Tom Talpey <tom@talpey.com>
Subject: Re: [Patch v3 2/6] cifs: Allocate validate negotiation request
 through kmalloc
Date: Wed, 18 Apr 2018 13:40:16 -0400
Message-ID: <568a36d2-29a1-442f-f725-58a02b8a90e5@talpey.com>
References: <20180418003358.25098-1-longli@linuxonhyperv.com>
 <d7e569b6-d268-b8c1-e91d-d6dc0e7cdfc2@talpey.com>
 <e9e7f77032c5402e848de0293e4db3ee@AcuMS.aculab.com>
 <b8e56b14-a746-2a22-cb8d-94f1ba7d646b@talpey.com>
 <MWHPR2101MB072909460F3898C6D13B4D4CCEB60@MWHPR2101MB0729.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>
To: Long Li <longli@microsoft.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR2101MB072909460F3898C6D13B4D4CCEB60@MWHPR2101MB0729.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 4/18/2018 1:11 PM, Long Li wrote:
>> Subject: Re: [Patch v3 2/6] cifs: Allocate validate negotiation request through
>> kmalloc
>>
>> On 4/18/2018 9:08 AM, David Laight wrote:
>>> From: Tom Talpey
>>>> Sent: 18 April 2018 12:32
>>> ...
>>>> On 4/17/2018 8:33 PM, Long Li wrote:
>>>>> From: Long Li <longli@microsoft.com>
>>>>>
>>>>> The data buffer allocated on the stack can't be DMA'ed, and hence
>>>>> can't send through RDMA via SMB Direct.
>>>>
>>>> This comment is confusing. Any registered memory can be DMA'd, need
>>>> to state the reason for the choice here more clearly.
>>>
>>> The stack could be allocated with vmalloc().
>>> In which case the pages might not be physically contiguous and there
>>> is no
>>> (sensible) call to get the physical address required by the dma
>>> controller (or other bus master).
>>
>> Memory registration does not requires pages to be physically contiguous.
>> RDMA Regions can and do support very large physical page scatter/gather,
>> and the adapter DMA's them readily. Is this the only reason?
> 
> ib_dma_map_page will return an invalid DMA address for a buffer on stack. Even worse, this incorrect address can't be detected by ib_dma_mapping_error. Sending data from this address to hardware will not fail, but the remote peer will get junk data.
> 
> I think it makes sense as stack is dynamic and can shrink as I/O proceeds, so the buffer is gone. Other kernel code use only data on the heap for DMA, e.g. BLK/SCSI layer never use buffer on the stack to send data.

I totally agree that registering the stack is a bad idea. I mainly
suggest that you capture these fundamental ib_dma* reasons in the
commit. There's no other practical reason why the original approach
would not work.

Tom.
