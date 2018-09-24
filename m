From: Tom Talpey <tom@talpey.com>
Subject: Re: [Patch v7 21/22] CIFS: SMBD: Upper layer performs SMB read via
 RDMA write through memory registration
Date: Sun, 23 Sep 2018 21:00:03 -0700
Message-ID: <de042465-e9b9-3782-00ce-38943053c7b6@talpey.com>
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
 <20171107085514.12693-22-longli@exchange.microsoft.com>
 <9b02dadb-d21b-7a8d-7803-910041f66047@talpey.com>
 <a7680efb-6ecf-0f70-2fde-55c2b69b534b@samba.org>
 <699de6ba-201a-fd4f-bcac-234e13f33afc@talpey.com>
 <f9c791af-28d0-5107-e41a-31eee03cbda0@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Stefan Metzmacher <metze@samba.org>,
        Long Li <longli@exchange.microsoft.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f9c791af-28d0-5107-e41a-31eee03cbda0@samba.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 9/23/2018 2:24 PM, Stefan Metzmacher wrote:
> Hi Tom,
> 
>>> I just tested that setting:
>>>
>>> mr->iova &= (PAGE_SIZE - 1);
>>> mr->iova |= 0xFFFFFFFF00000000;
>>>
>>> after the ib_map_mr_sg() and before doing the IB_WR_REG_MR, seems to
>>> work.
>>
>> Good! As you know, we were concerned about it after seeing that
>> the ib_dma_map_sg() code was unconditionally setting it to the
>> dma_mapped address. By salting those FFFF's with varying data,
>> this should give your FRWR regions stronger integrity in addition
>> to not leaking kernel "addresses" to the wire.
> 
> Just wondering... Isn't the thing we use called FRMR?

They're basically the same concept, it's a subtle difference.

FRMR = Fast Register Memory Region
FRWR = Fast Register Work Request

The memory region is the mr itself, this is created early on.

The work request is built when actually binding the physical
pages to the region, and setting the offset, length, etc, which
is what's happening in the routine that I made the comment on.

So, for this discussion I chose to say FRWR. Sorry for any
confusion!

Tom.
