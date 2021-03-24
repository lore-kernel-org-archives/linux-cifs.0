Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0075AC433C1
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Mar 2021 14:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF4AE619F3
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Mar 2021 14:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbhCXOVC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:21:02 -0400
Received: from p3plsmtpa11-05.prod.phx3.secureserver.net ([68.178.252.106]:39418
        "EHLO p3plsmtpa11-05.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236166AbhCXOUc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 24 Mar 2021 10:20:32 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id P4N4lUfohopD5P4N4lqJ6H; Wed, 24 Mar 2021 07:20:31 -0700
X-CMAE-Analysis: v=2.4 cv=ONDiYQWB c=1 sm=1 tr=0 ts=605b4aaf
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=pGLkceISAAAA:8 a=RCc5xYXWKdBN-iShi_QA:9
 a=QEXdDO2ut3YA:10 a=5oRCH6oROnRZc2VpWJZ3:22 a=fCgQI5UlmZDRPDxm0A3o:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: cifs: Deferred close for files
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>, sribhat.msa@outlook.com,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>
References: <CACdtm0Y1NeC0jNTOtjhTtGRt0sfyhyxC=wNfMu1eqibe6qJbwA@mail.gmail.com>
 <CANT5p=pFU=1OKiBA0m0_Pqms4Vsxz7omEgvfDDAb8U3M4-3qbA@mail.gmail.com>
 <461d79c3-1b32-b0f8-157c-b5d4b25507d7@talpey.com>
 <CACdtm0agzeVRiQg1zZjm=jFrf-gSQ-+YGc1Zm1xN1Pd9tJia4Q@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <49874720-dc76-2660-17e7-f7157a9725d4@talpey.com>
Date:   Wed, 24 Mar 2021 10:20:30 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CACdtm0agzeVRiQg1zZjm=jFrf-gSQ-+YGc1Zm1xN1Pd9tJia4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfHG5Rz1Fs0UKvp9dTZUYv7Wyat6imfPOVqlHOidYxPFkwG7KcolujvVJONJed7M9lYa/ZhHX4IUHxFTccmR6wWCYV+Dt3UEjFbGgEdlXvMoawuyX/vec
 s8JM+4uixfGgNtXUWBY9K+0jy5jPw5Eb3M+tL6ZqnvHUqE1eI44xNc5GyCITsJgVPLRCO1l9lOK1SZMyFKTOiUs2tmn4j9zFbJNNKYlUucv9+cEyOKmrvl5K
 hQxYffQ2762VA+CBcvKro8HDX+FUyjqdTeKZxMSii07XvVtMg5n4ny64rwD1WxNL2LKU1bR1BMx5QZz0V+7aUirP5/66kvte/kEi8nw4SpkDXPXpiD6d9CVX
 VhxbU0LOcTKgQkkztfUfu8PRuAGXcQzatmvoeo5aBWT8rvOaHs1M3dsrWEmoCEQd+EGkFxXH
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/22/2021 1:07 PM, Rohith Surabattula wrote:
> On 3/11/2021 8:47 AM, Shyam Prasad N wrote:
>> Hi Rohith,
>>
>> The changes look good at a high level.
>>
>> Just a few points worth checking:
>> 1. In cifs_open(), should be perform deferred close for certain cases
>> like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
>> perform less data caching. By deferring close, aren't we delaying
>> flushing dirty pages? @Steve French ?
> 
> With O_DIRECT flag, data is not cached locally and will be sent to
> server immediately.
> 
>> 2. I see that you're maintaining a new list of files for deferred
>> closing. Since there could be a large number of such files for a big
>> share with sufficient I/O, maybe we should think of a structure with
>> faster lookups (rb trees?).
>> I know we already have a bunch of linked lists in cifs.ko, and we need
>> to review perf impact for all those lists. But this one sounds like a
>> candidate for faster lookups.
> 
> Entries will be added into this list only once file is closed and will
> remain for acregmax amount interval.

I think you mean once the "file descriptor" is closed, right? But now
that you mention it, caching the attributes sounds a lot like the
NFS close-to-open semantic, which is itself optional with the "nocto"
mount option.

Because some applications use close() to perform flush, there may be
some silent side effects as well. I don't see anything special in the
patch regarding this. Have you considered it?

> So,  Will this affect performance i.e during lookups ?
> 
>> 3. Minor comment. Maybe change the field name oplock_deferred_close to
>> oplock_break_received?
> 
> Addressed. Attached the patch.
>>
>> Regards,
>> Shyam
> 
>> I wonder why the choice of 5 seconds? It seems to me a more natural
>> interval on the order of one or more of
>> - attribute cache timeout
>> - lease time
>> - echo_interval
> 
> Yes, This sounds good. I modified the patch to defer by attribute
> cache timeout interval.
> 
>> Also, this wording is rather confusing:
> 
>>> When file is closed, SMB2 close request is not sent to server
>>> immediately and is deferred for 5 seconds interval. When file is
>>> reopened by same process for read or write, previous file handle
>>> can be used until oplock is held.
> 
>> It's not a "previous" filehandle if it's open, and "can be used" is
>> a rather passive statement. A better wording may be "the filehandle
>> is reused".
> 
>> And, "until oplock is held" is similarly awkward. Do you mean "*if*
>> an oplock is held", or "*provided" an oplock is held"?
> 
>>> When same file is reopened by another client during 5 second
>>> interval, oplock break is sent by server and file is closed immediately
>>> if reference count is zero or else oplock is downgraded.
> 
>> Only the second part of the sentence is relevant to the patch. Also,
>> what about lease break?
> 
> Modified the patch.

The change to promptly close the handle on oplock or lease break looks
reasonable. The rewording in the patch description is better too.

>> What happens if the handle is durable or persistent, and the connection
>> to the server times out? Is the handle recovered, then closed?
> 
> Do you mean when the session gets reconnected, the deferred handle
> will be recovered and closed?

Yes, because I expect the client to attempt to reclaim its handles upon
reconnection. I don't see any particular code change regarding this.

My question is, if there's a deferred close pending, should it do that,
or should it simply cut to the chase and close any such handle(s)?

Tom.

> Regards,
> Rohith
> 
> On Thu, Mar 11, 2021 at 11:25 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 3/11/2021 8:47 AM, Shyam Prasad N wrote:
>>> Hi Rohith,
>>>
>>> The changes look good at a high level.
>>>
>>> Just a few points worth checking:
>>> 1. In cifs_open(), should be perform deferred close for certain cases
>>> like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
>>> perform less data caching. By deferring close, aren't we delaying
>>> flushing dirty pages? @Steve French ?
>>> 2. I see that you're maintaining a new list of files for deferred
>>> closing. Since there could be a large number of such files for a big
>>> share with sufficient I/O, maybe we should think of a structure with
>>> faster lookups (rb trees?).
>>> I know we already have a bunch of linked lists in cifs.ko, and we need
>>> to review perf impact for all those lists. But this one sounds like a
>>> candidate for faster lookups.
>>> 3. Minor comment. Maybe change the field name oplock_deferred_close to
>>> oplock_break_received?
>>>
>>> Regards,
>>> Shyam
>>
>> I wonder why the choice of 5 seconds? It seems to me a more natural
>> interval on the order of one or more of
>> - attribute cache timeout
>> - lease time
>> - echo_interval
>>
>> Also, this wording is rather confusing:
>>
>>> When file is closed, SMB2 close request is not sent to server
>>> immediately and is deferred for 5 seconds interval. When file is
>>> reopened by same process for read or write, previous file handle
>>> can be used until oplock is held.
>>
>> It's not a "previous" filehandle if it's open, and "can be used" is
>> a rather passive statement. A better wording may be "the filehandle
>> is reused".
>>
>> And, "until oplock is held" is similarly awkward. Do you mean "*if*
>> an oplock is held", or "*provided" an oplock is held"?
>>
>>> When same file is reopened by another client during 5 second
>>> interval, oplock break is sent by server and file is closed immediately
>>> if reference count is zero or else oplock is downgraded.
>>
>> Only the second part of the sentence is relevant to the patch. Also,
>> what about lease break?
>>
>> What happens if the handle is durable or persistent, and the connection
>> to the server times out? Is the handle recovered, then closed?
>>
>> Tom.
>>
>>
>>> On Tue, Mar 9, 2021 at 2:41 PM Rohith Surabattula
>>> <rohiths.msft@gmail.com> wrote:
>>>>
>>>> Hi All,
>>>>
>>>> Please find the attached patch which will defer the close to server.
>>>> So, performance can be improved.
>>>>
>>>> i.e When file is open, write, close, open, read, close....
>>>> As close is deferred and oplock is held, cache will not be invalidated
>>>> and same handle can be used for second open.
>>>>
>>>> Please review the changes and let me know your thoughts.
>>>>
>>>> Regards,
>>>> Rohith
>>>
>>>
>>>
