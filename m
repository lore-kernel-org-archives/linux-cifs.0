Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6E2C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 22:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DF4760233
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 22:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbhBXWNU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 17:13:20 -0500
Received: from p3plsmtpa11-03.prod.phx3.secureserver.net ([68.178.252.104]:50245
        "EHLO p3plsmtpa11-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231790AbhBXWNT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 24 Feb 2021 17:13:19 -0500
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id F2OVl37UiKEOAF2OWlaJWk; Wed, 24 Feb 2021 15:12:33 -0700
X-CMAE-Analysis: v=2.4 cv=erwacqlX c=1 sm=1 tr=0 ts=6036cf52
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=pGLkceISAAAA:8 a=d8ZeDRgG4ehVQMTp9-4A:9
 a=QEXdDO2ut3YA:10 a=5oRCH6oROnRZc2VpWJZ3:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH] convert revalidate of directories to using directory
 metadata cache timeout
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5msdUQ=CVM6s7ENeH7SP-teYAOioOGq7zY5sDXZFrFYiCA@mail.gmail.com>
 <CAH2r5mv6Oo5UUMOyFmKO_6xmdXZvQa_TtmFjgdN_ZoBcgSbJkA@mail.gmail.com>
 <10881e42-9632-30b0-344d-66ed8e9cb340@talpey.com>
 <CAH2r5mvGG1-DOZq1Eby3jfX86YLgpCihmYgV=EPJoR16PhEN7Q@mail.gmail.com>
 <CAH2r5muLz67kjmxiboeW3DwJ2KhEQgJs_U6MCAxzVZ+TY+ucCA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <05b2482a-e499-9239-a956-0b322fa7d800@talpey.com>
Date:   Wed, 24 Feb 2021 17:12:31 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5muLz67kjmxiboeW3DwJ2KhEQgJs_U6MCAxzVZ+TY+ucCA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfBaMHXjN1iNhMZFwTniEWOVHmWemdSBmdBpxS2KplgG9t4qEqZjUoPCpqlALe4Oxm8iI4B49nrdSKeSubgWYKxE4zh5whlNDq1TvDnXayIL8iS8z1fUH
 BFd6Xa2A1DcrURLNCnbzquId+8i3dSEtUt/+K4ogqrKJlQyaSGfizCSi783ZgyaGGpdF3rQjGiiG+X9BpGxuLmww1crb7ybigig1ytuCJMlBmuawto9SZZae
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2/24/2021 1:20 PM, Steve French wrote:
> Added additional patch to add "acregmax" so now behavior is more similar to nfs.
> 
> "acregmax" changes file metadata caching timeout
> "acdirmax" changes directory metadata caching
> "actimeo" does what it did before - and changes both.

Clever. It's a little weird that specifying either max with
actimeo will kick a warning, and maybe surprising to someone
who sets both maxes to the same value will see actimeo instead.
But they'll get over that. :)

You can add to all three, my
Reviewed-By: Tom Talpey <tom@talpey.com>

> On Wed, Feb 24, 2021 at 11:31 AM Steve French <smfrench@gmail.com> wrote:
>>
>> On Wed, Feb 24, 2021 at 10:11 AM Tom Talpey <tom@talpey.com> wrote:
>>>
>>> On 2/23/2021 8:03 PM, Steve French wrote:
>>>> Updated version incorporates Ronnie's suggestion of leaving the
>>>> default (for directory caching) the same as it is today, 1 second, to
>>>> avoid
>>>> unnecessary risk.   Most users can safely improve performance by
>>>> mounting with acdirmax to a higher value (e.g. 60 seconds as NFS
>>>> defaults to).
>>>>
>>>> nfs and cifs on Linux currently have a mount parameter "actimeo" to control
>>>> metadata (attribute) caching but cifs does not have additional mount
>>>> parameters to allow distinguishing between caching directory metadata
>>>> (e.g. needed to revalidate paths) and that for files.
>>>
>>> The behaviors seem to be slightly different with this change.
>>> With NFS, the actimeo option overrides the four min/max options,
>>> and by default the directory ac timers range between 30 and 60.
>>>
>>> The CIFS code I see below seems to completely separate actimeo
>>> and acdirmax, and if not set, uses the historic 1 second value.
>>> That's fine, but it's completely different from NFS. Shouldn't we
>>> use a different mount option, to avoid confusing the admin?
>>
>> Ugh ... You are probably right.  I was trying to avoid two problems:
>> 1) (a minor one) adding a second mount option rather than just one (to
>> solve the same problem).  But reducing confusion is worth an extra
>> mount option
>>
>> 2) how to avoid the user specifying *both* actimeo and acregmax -
>> which one 'wins' (presumably the last one in the mount line)
>> We could check for this and warn the user in mount.cifs so maybe not
>> important to worry about in the kernel though.
>>
>> I will add the acregmax mount option and change actimeo to mean
>>      if (actimeo is set)
>>              acregmax = acdirmax = actimeo
>>
>>
>> --
>> Thanks,
>>
>> Steve
> 
> 
> 
