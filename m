Return-Path: <SRS0=PjUO=Q3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED62C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 19:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CFE62086A
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 19:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfBTTsP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Feb 2019 14:48:15 -0500
Received: from ishtar.tlinx.org ([173.164.175.65]:38570 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfBTTsP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Feb 2019 14:48:15 -0500
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id x1KJmBGW041192;
        Wed, 20 Feb 2019 11:48:13 -0800
Message-ID: <5C6DAEFC.2060909@tlinx.org>
Date:   Wed, 20 Feb 2019 11:48:12 -0800
From:   L A Walsh <cifs@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To:     Pavel Shilovsky <piastryyy@gmail.com>
CC:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: regressions & flakiness make for ugly symlink links
References: <5C6B997B.8050203@tlinx.org> <CAKywueSgMhDzKOx04_C8X3HEhn_0w6cwM43c3=FXdjCsZ3x9UA@mail.gmail.com>
In-Reply-To: <CAKywueSgMhDzKOx04_C8X3HEhn_0w6cwM43c3=FXdjCsZ3x9UA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2/19/2019 11:46 AM, Pavel Shilovsky wrote:
> пн, 18 февр. 2019 г. в 22:16, L A Walsh <cifs@tlinx.org>:
>   
>> In my Windows root directory I have several links...
>> lrwxrwxrwx   1           17 Jun 13  2016 Documents -> //Bliss/Documents/    
>> lrwxrwxrwx   1           20 Nov  6  2014 Prog -> /Program Files (x86)/
>> lrwxrwxrwx   1           13 Apr 21  2013 Prog64 -> Program Files/
>> lrwxrwxrwx   1           12 Aug  9  2015 ProgD -> /ProgramData/
>>     
...
>> ---
>>
>> Now, I'm getting flaki results -- with them not resolving 1 time,
>> then resolving,  then not again...etc
>>
>> # ll|more
>> ls: cannot access 'Documents': Operation not supported
>> ...
>> ls: cannot access 'Prog64': Operation not supported
>> ...
---
>> d????????? ?       ?            ? Documents/
>> ...
>> d????????? ?       ?            ? Prog64/
>> ...
>> Depending on timing, Sometimes I will get most or all of
>> them appearing the same as they would on windows.
>>
>> If I can't resolve them more quickly, is there a know
>> or two to increase cache size and item lifetime?
>>     
>
> Which kernel version shows symlinks right and which - wrong?
>   
I only recently switched on getting the access info 'live',
vs. mounting it all as 1 user.  Since it works and doesn't
work based on what's in the cache, the same kernel can provide
both symptoms.

I don't remember the exact date I switched, maybe in the 4.19.xx
series, but at the moment, am running 4.20.3.

Sometimes after a client reboot, I'll see question marks for all
files or about 60 entries in the root dir.  Vs. only the symlinks
where it has to do 2 lookups -- the item and the one pointed to,
and see about 10-15 entries.

I figured that it's a timing prob related to whether or not the entries
are in some cache, so I need to look more closely at that
UID<->RID resolution path, but meanwhile, I thought I'd increase
the cache size and maybe look at the timeout value and if I could
tolerate a longer timeout.

So -- don't think it is the kernel version, but the fact that it's
going a long path to do the lookups -- especially the links --
and that optimizing that path would likely bring the most benefits.

There used to be documentation about doing the resolution through
a separate program, but that documenation disappeared as someone
wrote a .dll to do the resolving, which got plopped in there after
an accidental system update attempt (long story -- power outage,
ups needs new batteries, and more).

Anyway, UID/GID<=>RID map is relatively small (<10-15K) with
long-lived entries.  The server has >100GB mem and the
client, 92GB.

That's why I wanted to increase the UID<->RID cache size &
raise the timeout to a long value.  Maybe ideally with a way
to manually invalidate the cache and/or 1 entry for rare updates.

Thanks!



