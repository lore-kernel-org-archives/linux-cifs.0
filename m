Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8F9C433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 19:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A16764E0A
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 19:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238039AbhBBTND (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:13:03 -0500
Received: from p3plsmtpa08-08.prod.phx3.secureserver.net ([173.201.193.109]:45146
        "EHLO p3plsmtpa08-08.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239362AbhBBTGC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Feb 2021 14:06:02 -0500
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id 70z9l1JAqHMLa70z9lA9T7; Tue, 02 Feb 2021 12:05:12 -0700
X-CMAE-Analysis: v=2.4 cv=eq0acqlX c=1 sm=1 tr=0 ts=6019a268
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8
 a=yLneV2YlTdIBTJ7mUKcA:9 a=lwB08IF-Vn_DRAte:21 a=d9CYx2sHN4TzE1CL:21
 a=QEXdDO2ut3YA:10 a=5oRCH6oROnRZc2VpWJZ3:22 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH] CIFS: Wait for credits if at least one request is in
 flight
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
References: <20210202010105.236700-1-pshilov@microsoft.com>
 <40f473ff-bdd5-059c-36f1-d181eaa71200@talpey.com>
 <CAKywueRkvEjaZ+u4QhG+aVKFKUf-smWRqLmeeRC-2=4xU=zmDA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <578dfbe3-18cd-3193-828f-54ddfdb9ffea@talpey.com>
Date:   Tue, 2 Feb 2021 14:05:12 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAKywueRkvEjaZ+u4QhG+aVKFKUf-smWRqLmeeRC-2=4xU=zmDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfM+VnYvEMaQd3hbPavAaZQdNjBBM3jAMc2Yiy+03ga0PkqFVY6u5gXWsFJot/iDibAuuJE0QsZEHiz0UhxnFXozbP1MpRgBJS3uJRhKqBHOaGJeLag3T
 /lP4oFPdNXZf+zEz26GLWOOeuLLvOH7Vkxmg3yI0OHFTH/wBZFmnvZqnbmpB/Kdl4bZjnIg7MVeW/cYKHQ1P2rIXVGisg7vjoh5k4ZfieWks3y8e/63Ye5Dr
 1v3sLV3gGLphK6113Him2QhzeyLbEh+sgubK44r1h1gXMoYU8MD+9phCJvxTjggTF3iaQpvQ+sbubbVca7YwbA==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2/2/2021 1:17 PM, Pavel Shilovsky wrote:
> I agree that the error code may not be ideal. Shyam has a WIPto
> replace it with EBUSY but EDEADLK may be a good alternative too. For
> this patch I would prefer not to change the error code and only fix
> the bug to allow less ricky backporting.

Sounds good to consider separately.

> Yes. If the server is tight on resources or just gives us less credits
> for other reasons (e.g. requests are coming out of order and the
> server delays granting more credits until it receives a missing mid)
> and we exhausted most available credits there may be situations when
> we try to send a compound request but we don't have enough credits. At
> this point the client needs to decide if it should wait for credits or
> fail a request. If at least one request is in flight there is a high
> probability that the server returns enough credits to satisfy the
> compound request (which are usually 3-4 credits long). So, we don't
> want to fail the request in this case.

Ah, yes it's true that with no requests in flight, the wait would be
unbounded, and uncertain to gain credits even then. I think that is
well worth capturing in a code comment where the failure is returned.

It's still a concern that large requests may fall victim to being
locked out by small ones, in the low-credit case. A "scheduler", or
at least a credit reservation, would seem important in future. Or,
as mentioned, modifying the requests to consume fewer credits each.

It's easy to envision a situation where a low-credit server can be
up, but a credit-greedy client might refuse to send it any requests
at all.

Tom.

> --
> Best regards,
> Pavel Shilovsky
> 
> пн, 1 февр. 2021 г. в 19:39, Tom Talpey <tom@talpey.com>:
>>
>> It's reasonable to fail a request that can never have sufficient
>> credits to send, but EOPNOTSUPP is a really strange error to return.
>> The operation might work if the payload were smaller, right? So,
>> would a resource error such as EDEADLK be more meaningful, and allow
>> the caller to recover, even?
>>
>> Also, can you elaborate on why this is only triggered when no
>> requests at all are in flight? Or is this some kind of corner
>> case for requests that need every credit the server currently
>> is offering?
>>
>> Tom.
>>
>> On 2/1/2021 8:01 PM, Pavel Shilovsky wrote:
>>> Currently we try to guess if a compound request is going to succeed
>>> waiting for credits or not based on the number of requests in flight.
>>> This approach doesn't work correctly all the time because there may
>>> be only one request in flight which is going to bring multiple credits
>>> satisfying the compound request.
>>>
>>> Change the behavior to fail a request only if there are no requests
>>> in flight at all and proceed waiting for credits otherwise.
>>>
>>> Cc: <stable@vger.kernel.org> # 5.1+
>>> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
>>> ---
>>>    fs/cifs/transport.c | 6 +++---
>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>>> index 4ffbf8f965814..84f33fdd1f4e0 100644
>>> --- a/fs/cifs/transport.c
>>> +++ b/fs/cifs/transport.c
>>> @@ -659,10 +659,10 @@ wait_for_compound_request(struct TCP_Server_Info *server, int num,
>>>        spin_lock(&server->req_lock);
>>>        if (*credits < num) {
>>>                /*
>>> -              * Return immediately if not too many requests in flight since
>>> -              * we will likely be stuck on waiting for credits.
>>> +              * Return immediately if no requests in flight since
>>> +              * we will be stuck on waiting for credits.
>>>                 */
>>> -             if (server->in_flight < num - *credits) {
>>> +             if (server->in_flight == 0) {
>>>                        spin_unlock(&server->req_lock);
>>>                        return -ENOTSUPP;
>>>                }
>>>
> 
