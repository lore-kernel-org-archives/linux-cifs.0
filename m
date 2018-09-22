From: Tom Talpey <tom@talpey.com>
Subject: Re: [Patch v7 21/22] CIFS: SMBD: Upper layer performs SMB read via
 RDMA write through memory registration
Date: Sat, 22 Sep 2018 10:16:51 -0700
Message-ID: <699de6ba-201a-fd4f-bcac-234e13f33afc@talpey.com>
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
 <20171107085514.12693-22-longli@exchange.microsoft.com>
 <9b02dadb-d21b-7a8d-7803-910041f66047@talpey.com>
 <a7680efb-6ecf-0f70-2fde-55c2b69b534b@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Stefan Metzmacher <metze@samba.org>,
        Long Li <longli@exchange.microsoft.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a7680efb-6ecf-0f70-2fde-55c2b69b534b@samba.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 9/21/2018 8:56 PM, Stefan Metzmacher wrote:
> Hi,
> 
>>> +        req->Channel = SMB2_CHANNEL_RDMA_V1_INVALIDATE;
>>> +        if (need_invalidate)
>>> +            req->Channel = SMB2_CHANNEL_RDMA_V1;
>>> +        req->ReadChannelInfoOffset =
>>> +            offsetof(struct smb2_read_plain_req, Buffer);
>>> +        req->ReadChannelInfoLength =
>>> +            sizeof(struct smbd_buffer_descriptor_v1);
>>> +        v1 = (struct smbd_buffer_descriptor_v1 *) &req->Buffer[0];
>>> +        v1->offset = rdata->mr->mr->iova;
>>
>> It's unnecessary, and possibly leaking kernel information, to use
>> the IOVA as the offset of a memory region which is registered using
>> an FRWR. Because such regions are based on the exact bytes targeted
>> by the memory handle, the offset can be set to any value, typically
>> zero, but nearly arbitrary. As long as the (offset + length) does
>> not wrap or otherwise overflow, offset can be set to anything
>> convenient.
>>
>> Since SMB reads and writes range up to 8MB, I'd suggest zeroing the
>> least significant 23 bits, which should guarantee it. The other 41
>> bits, party on. You could randomize them, pass some clever identifier
>> such as MID sequence, whatever.
> 
> I just tested that setting:
> 
> mr->iova &= (PAGE_SIZE - 1);
> mr->iova |= 0xFFFFFFFF00000000;
> 
> after the ib_map_mr_sg() and before doing the IB_WR_REG_MR, seems to work.

Good! As you know, we were concerned about it after seeing that
the ib_dma_map_sg() code was unconditionally setting it to the
dma_mapped address. By salting those FFFF's with varying data,
this should give your FRWR regions stronger integrity in addition
to not leaking kernel "addresses" to the wire.

Tom.
