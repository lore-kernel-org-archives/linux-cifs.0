Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26CDC433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 13:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55BD564F01
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 13:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhCQNFP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Mar 2021 09:05:15 -0400
Received: from p3plsmtpa06-06.prod.phx3.secureserver.net ([173.201.192.107]:51492
        "EHLO p3plsmtpa06-06.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230006AbhCQNEp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 17 Mar 2021 09:04:45 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id MVqulSHgrEYmdMVqulC3eW; Wed, 17 Mar 2021 06:04:45 -0700
X-CMAE-Analysis: v=2.4 cv=adukITkt c=1 sm=1 tr=0 ts=6051fe6d
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=4KVoC04R1W0GfWevb_0A:9 a=QEXdDO2ut3YA:10
 a=5oRCH6oROnRZc2VpWJZ3:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: xfstest 614 and allocation size should not be 0
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mvD4CRP_iZRNhS+809wxOj8FSc4FHbN+UVFp8+pMJcpyg@mail.gmail.com>
 <fef5a851-6ce2-457d-ccf9-3d8a13193193@talpey.com>
 <CAH2r5mu97zZ_PXMAxyqFrNVEXv2Y=3cp0MkJSHR0ATXeFWzQsw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <c58a56e5-3190-c470-dc98-bfd76e764314@talpey.com>
Date:   Wed, 17 Mar 2021 09:04:45 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5mu97zZ_PXMAxyqFrNVEXv2Y=3cp0MkJSHR0ATXeFWzQsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfE2KOfakLGZLkoq6OodyXJ2/SHks2mnvzcjbqVlnTSwmGuTZb9IIYAm94iK+xYn23xIO0y4JFLZbEpnvRxuCrVUhnZ4CBwsXMHbx3s+R7vHr8UBURp99
 1Mz+stVPHD2tU74IYM0oQWRI4KfnmIbtqYaRYH0NXWLF4PDH2WNUQJ/pp+m1xU+rISHp4DXw6vIkbp7TZITJ9U3wmDouOBhsRiSk4wWtkNPujHB57Wu7TAWx
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


On 3/17/2021 8:18 AM, Steve French wrote:
> On Wed, Mar 17, 2021 at 6:25 AM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 3/17/2021 2:10 AM, Steve French wrote:
>>> Was examining why xfstest 614 failed (smb3.1.1 mount to Windows), and
>>> noticed a couple of problems:
>>>
>>> 1) we don't requery the allocation size (number of blocks) in all
>>> cases we should. This small fix should address that
>>>
>>> --- a/fs/cifs/inode.c
>>> +++ b/fs/cifs/inode.c
>>> @@ -2390,15 +2390,16 @@ int cifs_getattr(struct user_namespace
>>> *mnt_userns, const struct path *path,
>>>           struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
>>>           struct inode *inode = d_inode(dentry);
>>>           int rc;
>>>           /*
>>>            * We need to be sure that all dirty pages are written and the server
>>>            * has actual ctime, mtime and file length.
>>>            */
>>> -       if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE)) &&
>>> +       if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE |
>>> STATX_BLOCKS)) &&
>>
>> Seems obviously enough correct.
>>
>>> and 2) we don't set the allocation size on the case where a cached
>>> file on this client is written, and to make it worse if we queried
>>
>> Also obviously the cache needs to be kept in sync, but is it accurate to
>> set the allocation size before writing? That's the server's field, so
>> shouldn't it be written, then queried?
>>
>>> (post query attributes flag) at SMB3 close for compounded operations -
>>> the Windows server (not sure about others) apparently doesn't update
>>> the allocation size until the next open/queryinfo so we still end up
>>> with an allocation size of 0 for a 64K file which breaks the test.
>>>
>>> What the test is doing is quite simple:
>>>
>>> xfs_io -f -c "truncate 64K" -c "mmap -w 0 64K" -c "mwrite -S 0xab 0
>>> 64K" -c "munmap" foo1 ; stat -c %b foo1
>>>
>>> And it fails - due to seeing a number of blocks 0 rather than the
>>> correct value (128).  With actimeo=0 we do a subsequent open/query
>>> operation which would cause it to pass since the second open/query
>>> does show the correct allocation size.
>>>
>>> Any ideas?
>>
>> What actually goes on the wire diring the test? It looks like the
>> munmap step should be msync'ing - does cifs.ko not write the data?
> 
> Oddly enough this works to Azure but not Windows. What we see
> on the wire is simple enough:
> 
> 1) create/getinfo foo1 --> file not found
> 2) create foo1
> 3) oplock break of root's cached handle
> 4) close root handle
> 6) open of root/getinfo("FileFsFullSizeInformation")/Close
> 6) Flush foo1
> 7) ioctl set sparse foo1
> 8) setinfo FILE_ENDOFFILE_INFO foo1
> 9) create/setinfo(FILE_BASIC_INFO)/close of foo1
> 10) read 64K foo1 (all zeros)
> 11) write 64K foo1
> 12) close foo1   (post query attributes of close show size 64K,
> allocation size 0  ---> should be allocation size 64K)
> 
> But it works to Azure ...

Wait, let me find my Spock ears.

Faaascinating.

Obviously the backend is doing some kind of deferred allocation.
Assuming this is NTFS, have you tried an alternative? I guess I'd
also suggest asking Neal, if you can reach him easily.

If it is deferring the block decision, I'd be cautious about
implementing a workaround like launching a second query attributes.
There's little guarantee it will be always correct.

If you can establish that the client is doing the right thing,
personally I'd implement some sort of waiver. Maybe make it dependent
on the server and its FS type, even.

I looked at MS-FSA and it explicitly states the AllocationSize is
updated as part of processing every write. Section 2.1.5.3:

> If ((ByteOffset+ ByteCount) > Open.Stream.AllocationSize), the object
> store MUST increase Open.Stream.AllocationSize to
> BlockAlign(ByteOffset+ ByteCount, Open.File.Volume.ClusterSize). If
> there is not enough disk space, the operation MUST be failed with
> STATUS_DISK_FULL.

So this might be worth a message to dochelp.

Tom.
