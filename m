Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF44C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 15:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF2F46147F
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 15:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345139AbhI2P3w (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 11:29:52 -0400
Received: from p3plsmtpa12-03.prod.phx3.secureserver.net ([68.178.252.232]:57392
        "EHLO p3plsmtpa12-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345237AbhI2P3v (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 29 Sep 2021 11:29:51 -0400
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id VbVAmGFGQ3ZUOVbVBmEFn1; Wed, 29 Sep 2021 08:28:10 -0700
X-CMAE-Analysis: v=2.4 cv=bJ7TnNyZ c=1 sm=1 tr=0 ts=6154860a
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=hGzw-44bAAAA:8 a=NEAV23lmAAAA:8 a=v5VsTHXFrz0c6gJItiMA:9
 a=QEXdDO2ut3YA:10 a=HvKuF1_PTVFglORKqfwH:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
To:     Jeremy Allison <jra@samba.org>, Ralph Boehme <slow@samba.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20210926135543.119127-1-linkinjeon@kernel.org>
 <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org>
 <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
 <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org>
 <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
 <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
 <79ed52be-c92e-1c62-423f-ee126b3da409@samba.org>
 <YVNR6w7dq0HMIcFA@jeremy-acer>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <76fcdc45-0a94-d9e6-14c8-1c638d0bd00f@talpey.com>
Date:   Wed, 29 Sep 2021 11:28:09 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YVNR6w7dq0HMIcFA@jeremy-acer>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfLYuwYcD8kxCkB3HZ8Gji8hFu9IUdTaX53AptLB9paiybzoakDzWwubhgiSijvRfl2vJyufoQymQyk5W1oOWq1Nl0DpDHqjq9upsHFrdxw8gaIeVrGyB
 8nhOD/ORiOcpo91CG03LEp2z6ToBRA2S23nbc0+6s0moXwnEEGnSN+anIgYbuL6RE1mYdjCHdrg/9XhiJ+NcgpcbyFqyf7KBES39T5X8gAX31YO/iqgXMh5n
 8QpbizRsEqsLwaJszDhujlSHgGzRqrFUKzFWYLtnLWCDwNJSxXPTcCxWBMEES48Zp4+ylzFs+prQBRlnaxwAYPGnv/YxUry6GUXqiUrPS5MHoSR6C5N9hMvZ
 cALTsZvm5Rlncxdj540gnlJsTh2rMWxMo9u7rKWXYmi7ZvLcpvo=
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/28/2021 1:33 PM, Jeremy Allison wrote:
> On Tue, Sep 28, 2021 at 06:33:46PM +0200, Ralph Boehme wrote:
>> Am 28.09.21 um 16:23 schrieb Namjae Jeon:
>>> 2021-09-28 22:43 GMT+09:00, Ralph Boehme <slow@samba.org>:
>>>> Am 28.09.21 um 05:26 schrieb Ralph Boehme:
>>>>> both: there are issues with the patch and I have changes on-top. :) It
>>>>> just takes a bit of time due to other stuff going on currently like 
>>>>> SDC.
>>>>
>>>> finally... :)
>>>>
>>>> Please check my branch
>>>> <https://github.com/slowfranklin/smb3-kernel/commits/ksmbd-for-next-pending> 
>>>>
>>>>
>>>> for added commits and two SQUASHes. Remaining commits reviewed-by: me.
>>> Yep, looks good, I will update them in patches. And thanks for your 
>>> review!
>>
>> thanks!
>>
>>>> Oh, and I also split out the setinfo basic infolevel changes into its
>>>> own commit.
>>> If you want to add clean-up patch first, we can change
>>> get_file_basic_info() together in patch. I will update it also.
>>>>
>>>> Let me know what you think of the additional checks I've added.
>>> You should submit patches to the list to be checked by other developers.
>>
>> everyone can fetch from that branch. And as I'm not merely doing patch 
>> review, but am changing, expanding, fixing patches, an email patch 
>> workflow doesn't work.
> 
> +1 on this. email-based patch workflow is fine when patches
> don't go through many iterations or have many people working
> on them, but when those things are true a repository-based
> workflow is far better (IMHO). Everyone knows how to use
> git (these days :-).

I completely agree that email is inefficient, but git is a terrible
way to have a discussion. We should attempt to be sure we have
those, and that everybody has a chance to see the proposals without
having to go to the web five times a day.

Please take this as a request for regular git-send-email updates to
this list, so I can see them if I'm not online. Maybe add a boilerplate
line to direct to the git repo webui. I'm sure a few others will
appreciate it too.

Tom.

> It would be good to get to the point where the list is
> used as a "release management" tool where patches that
> have already been completely reviewed and signed-off
> are sent and archived.
> 
