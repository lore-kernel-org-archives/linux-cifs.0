Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B58C4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 18:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3460A60E90
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 18:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhHRSdx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Aug 2021 14:33:53 -0400
Received: from p3plsmtpa07-06.prod.phx3.secureserver.net ([173.201.192.235]:46533
        "EHLO p3plsmtpa07-06.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229448AbhHRSdr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 18 Aug 2021 14:33:47 -0400
Received: from [192.168.0.100] ([68.239.50.225])
        by :SMTPAUTH: with ESMTPSA
        id GQNDmsqnKI6mhGQNEmyR2C; Wed, 18 Aug 2021 11:33:12 -0700
X-CMAE-Analysis: v=2.4 cv=fKL8YbWe c=1 sm=1 tr=0 ts=611d5268
 a=Rhw2r8FBodfaBxRKvGSZLA==:117 a=Rhw2r8FBodfaBxRKvGSZLA==:17
 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=SEc3moZ4AAAA:8 a=yMhMjlubAAAA:8
 a=RWeMe08pKjP06uc15VEA:9 a=QEXdDO2ut3YA:10 a=5oRCH6oROnRZc2VpWJZ3:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: Disable key exchange if ARC4 is not available
To:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
References: <20210818041021.1210797-1-lsahlber@redhat.com>
 <815daf08-7569-59ce-0318-dfe2b16e1d96@talpey.com>
 <CAN05THR_Y+uoER=iNiwoiZ0yPcJ2T-LvRqOew59G53SafUMg3g@mail.gmail.com>
 <CAH2r5mvj5w1NxkyH4XE6S6J0O7VFJ-XWB_Og_JsmA0M8i=AW2A@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <da151f08-bd19-9bbe-8e4b-9d7a698a9c4d@talpey.com>
Date:   Wed, 18 Aug 2021 14:33:11 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5mvj5w1NxkyH4XE6S6J0O7VFJ-XWB_Og_JsmA0M8i=AW2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfJRP5a8XBjEWDlAzSjfReYDOmu+8ssn6cBsz+diEqAtlyYZ9FxxviglVbAZKj/33BUqJWWi1dHnkKmqj8Dck1StXe94p5Hr0qpSMEBpUavd7IMF2Asna
 uSt7aUKoYJh/0NuRopRzIr8PE9o3GRN36EtUY4IPaVaYzGJ4bgvMFnCsYScxHR6reqgJWIJYTkMSm1hPflmvyqAznH7Ku0nOLLUZQy1dWFca5aLEjkYdzOsi
 xhVPop1h7Gpm8vcnqU+GumpoaIo/kGBN9r0HB5C5c1ycoUW6uBeQKvxGgagzmaw4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/18/2021 12:51 PM, Steve French wrote:
> On Wed, Aug 18, 2021 at 11:29 AM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
>>
>> On Wed, Aug 18, 2021 at 11:18 PM Tom Talpey <tom@talpey.com> wrote:
>>>
>>> On 8/18/2021 12:10 AM, Ronnie Sahlberg wrote:
>>>> Steve,
>>>>
>>>> We depend on ARC4 for generating the encrypted session key in key exchange.
>>>> This patch disables the key exchange/encrypted session key for ntlmssp
>>>> IF the kernel does not have any ARC4 support.
>>>>
>>>> This allows to build the cifs module even if ARC4 has been removed
>>>> though with a weaker type of NTLMSSP support.
>>>
>>> It's a good goal but it seems wrong to downgrade the security
>>> so silently. Wouldn't it be a better approach to select ARC4,
>>> and thereby force the build to succeed or fail? Alternatively,
>>> change the #ifndef ARC4 to a positive option named (for example)
>>> DOWNGRADED_NTLMSSP or something equally foreboding?
>>
>> Good point.
>> Maybe we should drop this patch and instead copy ARC4 into fs/cifs
>> so we have a private version of the code in cifs.ko.
>> And do the same for md4 and md5.

Copying such code makes me uneasy. It's going to confuse everyone
who tries to turn off one and misses the other. To say nothing of
the risk of testing and addressing bugs.

BTW, are we sure that servers even work if the client selects
something other than ARC4, or whatever?

Tom.

> Yes ... and allow a build option where ARC4/MD4 are removed from the
> build and NTLMSSP disabled,
> forcing kerberos in the short term, and then we need to get working
> ASAP on adding some choices in the future,
> perhaps something similar to
> 
> https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/jj852232(v=ws.11)
> 
> where Windows allows plugging in additional auth mechanisms to SPNEGO
> (and pick at least one new mechanism beyond
> KRB5 to support in the kernel client ...)
> 
