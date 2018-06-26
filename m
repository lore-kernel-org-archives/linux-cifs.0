From: Tom Talpey <tom@talpey.com>
Subject: Re: [Patch v2 02/15] CIFS: Add support for direct pages in rdata
Date: Tue, 26 Jun 2018 11:13:46 -0400
Message-ID: <f940d126-237c-963f-f64e-e1eb1e8c6c85@talpey.com>
References: <20180530194807.31657-1-longli@linuxonhyperv.com>
 <20180530194807.31657-3-longli@linuxonhyperv.com>
 <67b8afe7-f5e0-b36a-fcc1-87f1ae08eaa4@talpey.com>
 <20180625210132.GB5381@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: longli@microsoft.com, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180625210132.GB5381@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 6/25/2018 5:01 PM, Jason Gunthorpe wrote:
> On Sat, Jun 23, 2018 at 09:50:20PM -0400, Tom Talpey wrote:
>> On 5/30/2018 3:47 PM, Long Li wrote:
>>> From: Long Li <longli@microsoft.com>
>>>
>>> Add a function to allocate rdata without allocating pages for data
>>> transfer. This gives the caller an option to pass a number of pages
>>> that point to the data buffer.
>>>
>>> rdata is still reponsible for free those pages after it's done.
>>
>> "Caller" is still responsible? Or is the rdata somehow freeing itself
>> via another mechanism?
>>
>>>
>>> Signed-off-by: Long Li <longli@microsoft.com>
>>>   fs/cifs/cifsglob.h |  2 +-
>>>   fs/cifs/file.c     | 23 ++++++++++++++++++++---
>>>   2 files changed, 21 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>>> index 8d16c3e..56864a87 100644
>>> +++ b/fs/cifs/cifsglob.h
>>> @@ -1179,7 +1179,7 @@ struct cifs_readdata {
>>>   	unsigned int			tailsz;
>>>   	unsigned int			credits;
>>>   	unsigned int			nr_pages;
>>> -	struct page			*pages[];
>>> +	struct page			**pages;
>>
>> Technically speaking, these are syntactically equivalent. It may not
>> be worth changing this historic definition.
> 
> [] is a C99 'flex array', it has a different allocation behavior than
> ** and is not interchangeable..

In that case, it's an even better reason to not change the declaration.

Tom.
