Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F1CC433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Nov 2021 03:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C2696108B
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Nov 2021 03:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhKFDkz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Nov 2021 23:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhKFDky (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Nov 2021 23:40:54 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2843FC061570
        for <linux-cifs@vger.kernel.org>; Fri,  5 Nov 2021 20:38:14 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id ee33so39823730edb.8
        for <linux-cifs@vger.kernel.org>; Fri, 05 Nov 2021 20:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2X7enviVAVdlZXTa5hblPoTfRcczKOpDmPrGxqo5xWk=;
        b=VTSaB4/lcZmmdHT3N7Eh3NbJlhcG1JrsYavFDrTXf+ZvCrcaZe6PxpxhBcn5CLjS7Q
         ZgDJzAGDih/Cw737tAANjTdCVC8YCLiVtq+g4oa9smC4tBYbI57rOz6hlbwEFpEpiOV/
         MUBCIZOQzrjxLtCI+XIbml9O04UnKkUMvKwYwen15un9Eul0oyqjoHS1zLekPvIsfhhN
         EVSZ1tBK4oydQzab5mLqDM6/nYYBy0gnv0kW1MKZ+L9W7B3hcVOSOS+NGIMM3x8qpd7m
         cS7Q6T/Bi/P7oIdZiCFqxmmWgsuVuhY8IrK6aYk0Dmev8BREiN1n0bSFTEiAYDngyRZx
         zUNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2X7enviVAVdlZXTa5hblPoTfRcczKOpDmPrGxqo5xWk=;
        b=7ach/RxvrgERCbgOMvZFEAmAHrVTYLWVQ+1JKqikdkWw64NtmxcMtLrZ9yCddDmhgd
         ElWzcs+lxx9+ThQPXKsW3+cD28untiR3vrM+O9NSYKZuViP38BBHvzcP04NOgpCFcQuj
         psG2iT/bcawCEx/9++6sUuW59vped14gTQuPvrlUTdyVZLk3k2R8DAysmCrePtie6OXB
         r20mrbGOxhpbLk1eIwFBKhkMpk08mUC2L+H+UfLjFNFWq2pMdLlEl3vsSRpa1ADSLap1
         3/b1XBhF+2hdP7yiZ69P4So9F1Mb7D4dCq4e/DCfqFQdPaTAuLAC4VJdh6ryOy6LHsn5
         wtIA==
X-Gm-Message-State: AOAM533Fjr0CYfznu4fZDdVa6Akpu8yy0ZwRCPLI0I8/HjiMH0VxG/VU
        cnOr6gNHVK85y8yp9eDYiN8zFISjtKfarM32mJk=
X-Google-Smtp-Source: ABdhPJyQ9/jvYWnNZvYCVD9ZDHbYC9UGDOVRwQD9uUjvc+0dFAr+iq/LrP0t6pI+Au7ZQmKZ+O3f+xb0qyUSDWq7Jm8=
X-Received: by 2002:a17:906:a4e:: with SMTP id x14mr75114518ejf.1.1636169892719;
 Fri, 05 Nov 2021 20:38:12 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=rgHn59NVvH32FSKtNv_cyKi4ATSAExBmWT_qjb7km7Fw@mail.gmail.com>
 <20211106013854.6qx3tz53pvayqcgm@cyberdelia> <CAH2r5mvQG0DFmMdzojH2u_w2=_9oGRV++AnEt_d7WJzj=-uTKA@mail.gmail.com>
In-Reply-To: <CAH2r5mvQG0DFmMdzojH2u_w2=_9oGRV++AnEt_d7WJzj=-uTKA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 6 Nov 2021 09:08:05 +0530
Message-ID: <CANT5p=qOQDg4xDbx6oZafJc+gnM0pN+aYOgjokU54ZeLXq_uDQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: send workstation name during ntlmssp session setup
To:     Steve French <smfrench@gmail.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks for the reviews, Paulo and Enzo. Please read my replies below:

On Sat, Nov 6, 2021 at 7:10 AM Steve French <smfrench@gmail.com> wrote:
>
> Interesting suggestions, probably worth experimenting with but even the original patch could help a lot eg help server to understand type of client connecting to it when debugging
>
> On Fri, Nov 5, 2021, 21:38 Enzo Matsumiya <ematsumiya@suse.de> wrote:
>>
>> Hi Shyam,
>>
>> I have some observations/suggestions regarding your patch:
>>
>> On 11/06, Shyam Prasad N wrote:
>> >Hi Steve,
>> >
>> >Please review this patch, and let me know what you think.
>> >Having this info in the workstation field of session setup helps
>> >server debugging in two ways.
>> >1. It helps identify the client by node name.
>> >2. It helps get the kernel release running on the client side.
>> >
>> >https://github.com/sprasad-microsoft/smb3-kernel-client/commit/d988e704dd9170c19ff94d9421c017e65dbbaac1.patch
>>
>> - AFAICS it doesn't consider runtime hostname changes. Is it important
>>    to keep track of it? Would changing it mid-auth steps break it
>>    somehow?
I think that's okay. AFAIK, that's only used for
debugging/troubleshooting purposes. So it doesn't need to be a 100%
accurate.

>>
>> - I didn't understand the purpose of CIFS_DEFAULT_WORKSTATION_NAME. Why
>>    not simply use utsname()->nodename? Or even init_utsname()->nodename, which
>>    is supposed to be always valid.
I initially did not have the utsname changes. That idea was an afterthought.
Sure. I'll update the patch to fix this.

>>
>> - Ditto for CIFS_MAX_WORKSTATION_LEN. utsname()->nodename has at most 65
>>    bytes (__NEW_UTS_LEN + 1) anyway. Perhaps using MAXHOSTNAMELEN from
>>    <asm/param.h> would be a more generic approach.
>>    (btw this is because nodename is the unqualified hostname, sans-domain)
Noted.

>>
>> - Instead of setting workstation_name to "nodename:release", why not
>>    implement the VERSION structure (MS-NLMP 2.2.2.10)? Then use
>>    LINUX_VERSION_* from <linux/version.h> or parse utsname()->release.
That's a good idea. Let me explore that too.

>>
>> >I ran some basic testing with the patch. Seems to serve the purpose.
>> >Please let me know if I'm missing something.
>>
>> I hope I didn't miss anything.
>>
>>
>> Cheers,
>>
>> Enzo



-- 
Regards,
Shyam
