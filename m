Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E03C433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 17:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AA786197E
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 17:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhCSRwN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 13:52:13 -0400
Received: from p3plsmtpa09-08.prod.phx3.secureserver.net ([173.201.193.237]:37275
        "EHLO p3plsmtpa09-08.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230203AbhCSRwB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 19 Mar 2021 13:52:01 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id NJI0lbvvFvmOLNJI0lfs5C; Fri, 19 Mar 2021 10:52:00 -0700
X-CMAE-Analysis: v=2.4 cv=I6Wg+Psg c=1 sm=1 tr=0 ts=6054e4c0
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=SEc3moZ4AAAA:8 a=yMhMjlubAAAA:8
 a=VwQbUJbxAAAA:8 a=SkVciOcpV3lPsQsjn_0A:9 a=bCxlKJO9ITRO049f:21
 a=xOZaIu_1Vp0SOrBw:21 a=QEXdDO2ut3YA:10 a=5oRCH6oROnRZc2VpWJZ3:22
 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH] cifs: fix allocation size on newly created files
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mv0kMa__3-KvRRE20OZ3R=cnOFVbrAzVyRA0zpXsbaBiw@mail.gmail.com>
 <750943d3-9717-fcd8-71ec-986a07e7eca0@talpey.com>
 <CAH2r5muawhYVa7a=TEmaDgH1t6fvubEJvaUP1-XscNq9Qjy4rw@mail.gmail.com>
 <CAH2r5muLbbyhPzjD_Uk_XPd=A4dsuf4uT8X-YjrN616g=ENDBQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <0537089f-edd6-1c75-8695-055f37e022f8@talpey.com>
Date:   Fri, 19 Mar 2021 13:52:01 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5muLbbyhPzjD_Uk_XPd=A4dsuf4uT8X-YjrN616g=ENDBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfKQBQAwwWWY99+8hRckifOFISP/0Hv2xYg8N3izYozj1oR7eIaE4WPNUjd23keG6inBGVhF+W5AnOXW7OikuY9phDJTm68pMFQf6rMVJHjuInbUgSIQt
 KTby7Rv5wTkMqbUmVmE8570XAVBAVY3IEwl96LGzOX+4/+MldTmNmvu8/cImDRiMMKfZMf0WAXvulB5GIUS8wPDiu/5ugIPMQfujA7/0gDMd72drSW6HV3zI
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

But it's not the block size here, it's the cluster size. Block
size is the per-io hunk, allocation size is the number of blocks
lined up to receive it.

Perhaps the safest number is the file size itself, unrounded.

On 3/19/2021 1:46 PM, Steve French wrote:
> e.g. stat reports much larger than 512 byte block size over SMB3
> 
> # stat /mnt2/foo
>    File: /mnt2/foo
>    Size: 65536      Blocks: 128        IO Block: 1048576 regular file
> Device: 34h/52d Inode: 88946092640651991  Links: 1
> 
> and local file systems do the same ie "blocks" is unrelated to block size
> the fs reports.  Here is an example to XFS locally
> 
> # stat Makefile
>    File: Makefile
>    Size: 66247      Blocks: 136        IO Block: 4096   regular file
> Device: 10302h/66306d Inode: 1076242180  Links: 1
> 
> On Fri, Mar 19, 2021 at 12:42 PM Steve French <smfrench@gmail.com> wrote:
>>
>> We report the block size properly (typically much larger) - but the
>> kernel API returns allocation size in 512 byte units no matter what the
>> block size is.   Number of blocks returned for the kernel API
>>       inode->i_blocks
>> is unrelated to the block size (simply allocation_size/512 rounded up by 1).
>>
>> On Fri, Mar 19, 2021 at 12:38 PM Tom Talpey <tom@talpey.com> wrote:
>>>
>>> On 3/19/2021 1:25 AM, Steve French wrote:
>>>> Applications that create and extend and write to a file do not
>>>> expect to see 0 allocation size.  When file is extended,
>>>> set its allocation size to a plausible value until we have a
>>>> chance to query the server for it.  When the file is cached
>>>> this will prevent showing an impossible number of allocated
>>>> blocks (like 0).  This fixes e.g. xfstests 614 which does
>>>>
>>>>       1) create a file and set its size to 64K
>>>>       2) mmap write 64K to the file
>>>>       3) stat -c %b for the file (to query the number of allocated blocks)
>>>>
>>>> It was failing because we returned 0 blocks.  Even though we would
>>>> return the correct cached file size, we returned an impossible
>>>> allocation size.
>>>>
>>>> Signed-off-by: Steve French <stfrench@microsoft.com>
>>>> CC: <stable@vger.kernel.org>
>>>> ---
>>>>    fs/cifs/inode.c | 12 ++++++++++--
>>>>    1 file changed, 10 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>>>> index 7c61bc9573c0..17a2c87b811c 100644
>>>> --- a/fs/cifs/inode.c
>>>> +++ b/fs/cifs/inode.c
>>>> @@ -2395,7 +2395,7 @@ int cifs_getattr(struct user_namespace
>>>> *mnt_userns, const struct path *path,
>>>>     * We need to be sure that all dirty pages are written and the server
>>>>     * has actual ctime, mtime and file length.
>>>>     */
>>>> - if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE)) &&
>>>> + if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE |
>>>> STATX_BLOCKS)) &&
>>>>         !CIFS_CACHE_READ(CIFS_I(inode)) &&
>>>>         inode->i_mapping && inode->i_mapping->nrpages != 0) {
>>>>     rc = filemap_fdatawait(inode->i_mapping);
>>>> @@ -2585,6 +2585,14 @@ cifs_set_file_size(struct inode *inode, struct
>>>> iattr *attrs,
>>>>     if (rc == 0) {
>>>>     cifsInode->server_eof = attrs->ia_size;
>>>>     cifs_setsize(inode, attrs->ia_size);
>>>> + /*
>>>> + * i_blocks is not related to (i_size / i_blksize),
>>>> + * but instead 512 byte (2**9) size is required for
>>>> + * calculating num blocks. Until we can query the
>>>> + * server for actual allocation size, this is best estimate
>>>> + * we have for the blocks allocated for this file
>>>> + */
>>>> + inode->i_blocks = (512 - 1 + attrs->ia_size) >> 9;
>>>
>>> I don't think 512 is a very robust choice, no server uses anything
>>> so small any more. MS-FSA requires the allocation quantum to be the
>>> volume cluster size. Is that value available locally?
>>>
>>> Tom.
>>>
>>>>     /*
>>>>     * The man page of truncate says if the size changed,
>>>> @@ -2912,7 +2920,7 @@ cifs_setattr_nounix(struct dentry *direntry,
>>>> struct iattr *attrs)
>>>>     sys_utimes in which case we ought to fail the call back to
>>>>     the user when the server rejects the call */
>>>>     if ((rc) && (attrs->ia_valid &
>>>> - (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
>>>> +     (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
>>>>     rc = 0;
>>>>     }
>>>>
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
> 
> 
> 
