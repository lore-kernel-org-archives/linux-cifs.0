Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9D9C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Mar 2021 17:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 906F664FEE
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Mar 2021 17:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhCKR4C (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Mar 2021 12:56:02 -0500
Received: from p3plsmtpa07-10.prod.phx3.secureserver.net ([173.201.192.239]:38033
        "EHLO p3plsmtpa07-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229868AbhCKRzn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 11 Mar 2021 12:55:43 -0500
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id KPXCl88HlukyLKPXClbob0; Thu, 11 Mar 2021 10:55:43 -0700
X-CMAE-Analysis: v=2.4 cv=Od9dsjfY c=1 sm=1 tr=0 ts=604a599f
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=0tAdd_bFJCXRXIrWwb4A:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: cifs: Deferred close for files
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>, sribhat.msa@outlook.com,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>
References: <CACdtm0Y1NeC0jNTOtjhTtGRt0sfyhyxC=wNfMu1eqibe6qJbwA@mail.gmail.com>
 <CANT5p=pFU=1OKiBA0m0_Pqms4Vsxz7omEgvfDDAb8U3M4-3qbA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <461d79c3-1b32-b0f8-157c-b5d4b25507d7@talpey.com>
Date:   Thu, 11 Mar 2021 12:55:42 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CANT5p=pFU=1OKiBA0m0_Pqms4Vsxz7omEgvfDDAb8U3M4-3qbA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfMPx3ph32/FEO0+byM4NtDWB4L4pbzmYYGloeTQH2ckvzjQaiwBpjWvO1DY/FbtnDV0ZDBSRFJ5wExFw9+cru+a7WCNcajQB6K15vPBUUYwRv3jv3Of0
 1P/6yDqHl9ryG3xukT0pFpmIhY/v7GqTjPDi5YRguNTJMBX3FTbW+gqnjoD79ZcNQIxUwRFXDks3wVGoaI5YYH9NXsjV3bPOugkBawNv5RdDtmWu/UcCFHIS
 UD2Aj27zwGFzzzdEJHCavGrHvt3TCk6sy+v2vokADZ6ReVdP79E0E4DE3SqEZF4iao+nw0dslXHjJMMaiRiHgEhVK3l72uymdOQHbo+Xt0pJCvH2v1CYBaoT
 s1YdE3zyNo/4ZOR092ptNW4izbvm36oxOX20lFKksZRhsPFFEvae5EaUlb1zdcq/K28sPEjk
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/11/2021 8:47 AM, Shyam Prasad N wrote:
> Hi Rohith,
> 
> The changes look good at a high level.
> 
> Just a few points worth checking:
> 1. In cifs_open(), should be perform deferred close for certain cases
> like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
> perform less data caching. By deferring close, aren't we delaying
> flushing dirty pages? @Steve French ?
> 2. I see that you're maintaining a new list of files for deferred
> closing. Since there could be a large number of such files for a big
> share with sufficient I/O, maybe we should think of a structure with
> faster lookups (rb trees?).
> I know we already have a bunch of linked lists in cifs.ko, and we need
> to review perf impact for all those lists. But this one sounds like a
> candidate for faster lookups.
> 3. Minor comment. Maybe change the field name oplock_deferred_close to
> oplock_break_received?
> 
> Regards,
> Shyam

I wonder why the choice of 5 seconds? It seems to me a more natural
interval on the order of one or more of
- attribute cache timeout
- lease time
- echo_interval

Also, this wording is rather confusing:

> When file is closed, SMB2 close request is not sent to server
> immediately and is deferred for 5 seconds interval. When file is
> reopened by same process for read or write, previous file handle
> can be used until oplock is held.

It's not a "previous" filehandle if it's open, and "can be used" is
a rather passive statement. A better wording may be "the filehandle
is reused".

And, "until oplock is held" is similarly awkward. Do you mean "*if*
an oplock is held", or "*provided" an oplock is held"?

> When same file is reopened by another client during 5 second
> interval, oplock break is sent by server and file is closed immediately
> if reference count is zero or else oplock is downgraded.

Only the second part of the sentence is relevant to the patch. Also,
what about lease break?

What happens if the handle is durable or persistent, and the connection
to the server times out? Is the handle recovered, then closed?

Tom.


> On Tue, Mar 9, 2021 at 2:41 PM Rohith Surabattula
> <rohiths.msft@gmail.com> wrote:
>>
>> Hi All,
>>
>> Please find the attached patch which will defer the close to server.
>> So, performance can be improved.
>>
>> i.e When file is open, write, close, open, read, close....
>> As close is deferred and oplock is held, cache will not be invalidated
>> and same handle can be used for second open.
>>
>> Please review the changes and let me know your thoughts.
>>
>> Regards,
>> Rohith
> 
> 
> 
