Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F30C433B4
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 22:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A446613C4
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 22:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbhDFW4I convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Apr 2021 18:56:08 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:49460 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhDFW4H (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Apr 2021 18:56:07 -0400
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 136MtltV095407;
        Tue, 6 Apr 2021 15:55:50 -0700
Message-ID: <606CE6F3.3010701@tlinx.org>
Date:   Tue, 06 Apr 2021 15:55:47 -0700
From:   "L. A. Walsh" <linux-cifs@tlinx.org>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     =?UTF-8?B?QXVyw6lsaWVuIEFwdGVs?= <aaptel@suse.com>
CC:     Dan Carpenter <dan.carpenter@oracle.com>, namjae.jeon@samsung.com,
        linux-cifs@vger.kernel.org
Subject: Re: cifsd: introduce <SMB2n3> kernel server
References: <YFNRsYSWw77UMxw1@mwanda> <606C1DD6.80606@tlinx.org> <87h7kj4t4c.fsf@suse.com>
In-Reply-To: <87h7kj4t4c.fsf@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2021/04/06 03:14, Aurélien Aptel wrote:
> "L. A. Walsh" <linux-cifs@tlinx.org> writes:
>   
>> On 2021/03/18 06:12, Dan Carpenter wrote:
>>     
>>> [ cifsd: introduce SMB3 kernel server"
>>>       
>> Is it to be Linux policy that it will give in-kernel
>> support for only for smb3, or is it planned to move the rest of the proto
>> into the kernel as well?  It sorta seems like earlier parts of the protocol,
>> still dominant on home networks, though it seems linux not supporting
>> all of linux's smb devices, from smb2.1 and before.
>>     
>
> smb1 (aka cifs) is unsecure, out of support and being actively
> deprecated for over 10 years. Microsoft is uninstalling the smb1 server
> on Windows updates. That's how hard they want to kill it. Samba is
> planning to drop smb1 too eventually.
>   
Dropping Smb1 support for linux-serving would seem to be a reasonable
step, since I would be hard-pressed to find a client that still
only talked Smb1 (clients from XP-era).

I am more concerned about the more secure smb2 & smb2.1 dialects. 
I have heard there is a security difference even between 2 & 2.1,
though, I don't often see a breakout between 2.0(only)+2.1, with both
seeming to be lumped in under Smb2. 

So lets say dropping smb1 isn't an issue...
>
>   
>> Isn't the base of an smb3 server the same functions
>> of an smb2.x server with the new smb3 extensions?
>>     
>
> AFAICT Namjae's ksmbd support smb2 and above.
>   
---
    Then would it be a problem if it is called something like
"smb2n3" so it can be readily understood to support both?

    It's just a small comfort issue, since 'smb3' really doesn't
seem to be very convincing about its smb2-support.

> Cheers,
>   
Likewise!


