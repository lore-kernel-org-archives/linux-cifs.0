Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D69BEC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA8066056B
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236318AbhITQJh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 12:09:37 -0400
Received: from p3plsmtpa06-03.prod.phx3.secureserver.net ([173.201.192.104]:34317
        "EHLO p3plsmtpa06-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234422AbhITQJh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 20 Sep 2021 12:09:37 -0400
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id SLpwmtEomjeJoSLpwmxrsN; Mon, 20 Sep 2021 09:08:08 -0700
X-CMAE-Analysis: v=2.4 cv=aNA1FZxm c=1 sm=1 tr=0 ts=6148b1e8
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=GOb1M4fhWrcVJtAEjNIA:9 a=QEXdDO2ut3YA:10
 a=5oRCH6oROnRZc2VpWJZ3:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH] ksmbd: add default data stream name in
 FILE_STREAM_INFORMATION
To:     Steve French <smfrench@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
References: <20210918120239.96627-1-linkinjeon@kernel.org>
 <ac18e062-e835-b575-66af-72631df7ef7d@talpey.com>
 <CAH2r5msa4XeaLy=_HY9RrLpK0NyS9n3iMdYnvX7F4n2zNQNXgQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <2cf8a2d1-41df-eef4-dfe0-dca076e8db54@talpey.com>
Date:   Mon, 20 Sep 2021 12:08:09 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5msa4XeaLy=_HY9RrLpK0NyS9n3iMdYnvX7F4n2zNQNXgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfINLhxpS129+pLxUMG6xhE3vtzwl9hwpwTagYhxJQ1DL4NwX+4UkdbrMbgHaaNPZBHJtrRZLXF21F9tv9sPHlJkFtiXv0G/XLDZrXaE2YbWs0Xe/1mFH
 jQU3dGdacRoDbytCmV41uZsR9HfahVF1BiALW6hI2MzBjWle1d4wf0eWyjeE1bMgjENDU7nWF4GveVSBMJ4PrSVEX0xUP3f78zTGk2Vk7y23uak42HywmTsT
 ppeY1wqmJY3zVQCxtrGnQA==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/20/2021 12:47 AM, Steve French wrote:
> On Sat, Sep 18, 2021 at 9:06 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> This doesn't appear to be what's documented in MS-FSA section 2.1.5.11.29.
>> There, it appears to call for returning an empty stream list,
>> and STATUS_SUCCESS, when no streams are present.
> 
> I tried a quick test to Windows and it does appear to return $DATA
> stream by default:
> 
> # ./smbinfo filestreaminfo /mnt/junk
> Name: ::$DATA
> Size: 179765 bytes
> Allocation size: 196608 bytes

Ok, so the implication is that the default stream is indeed always
present, if the filesystem supports streams. The language in MS-FSA
would therefore be correct, but a bit vague. I agree that returning
a ::$DATA for ordinary files is appropriate.

> when I tried the same thing to a directory on a share mounted to Windows 10
> (NTFS), I get no streams returned.
> 
> So it does look like default stream ($DATA) is only returned for files


My concern here is, what's so special about directories? A special file
or fifo, a symlink or reparse/junction, etc. Is it appropriate to cons
up a ::$DATA for these? What should the size values be, if so?

Tom.


>> Also, why does the code special-case directories? The conditionals
>> on StreamSize and StreamAllocation size are entirely redundant,
>> after the top-level if (!S_ISDIR...), btw.
>>
>> I'd suggest asking Microsoft dochelp for clarification before
>> implementing this.
>>
>> Tom.
>>
>> On 9/18/2021 8:02 AM, Namjae Jeon wrote:
>>> Windows client expect to get default stream name(::DATA) in
>>> FILE_STREAM_INFORMATION response even if there is no stream data in file.
>>> This patch fix update failure when writing ppt or doc files.
> 
> 
> 
> 
