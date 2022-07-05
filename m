Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2A1C43334
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Jul 2022 10:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbiGEK4z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Jul 2022 06:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbiGEK4V (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Jul 2022 06:56:21 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A3A167E5
        for <linux-cifs@vger.kernel.org>; Tue,  5 Jul 2022 03:56:00 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id lg18so1143314ejb.0
        for <linux-cifs@vger.kernel.org>; Tue, 05 Jul 2022 03:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Q31He0N/yEzVpT1tCN0ycgAoynpjToL2FMOU6dBZlyk=;
        b=qpjnsscCqdRZTWBYTV4rdvUPMXKTnFSJQj6StfF7816blvZQb52pWnm6zQ/z+WbNSM
         lstx/cshmchCWQp+xvSbfv5zHhqd2fEzEQzSsPm+CTfHSGT2tdNakLVp4v+oeW7EfVp5
         trd8BuR0XOpWW2gIGUdyFQkDVK2Adiriv+SnNDa+MV5dtlq1Jn93IZ8PE3CPkfk+x6c9
         sBOcRMPnto0hrhBWjHvu4wTQDtpPa8s/ZfHrY1ovGh06lGSs+5Qb4lcoKJ3AbGPBgKPr
         +aphlk7ADlmU6oBpxoZvXW5CJ86wV6lUQEyFqjCGm35NTpK5uFYePwGrUuk2ybbbiQhZ
         HCAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q31He0N/yEzVpT1tCN0ycgAoynpjToL2FMOU6dBZlyk=;
        b=B7pd+vZ2CaVcBKzJywtFEthK/7a7pQ09PBBPx6gxvQNVEKRBcmVM6qY+FQ/B+BCinY
         Cr9v+SHGzsFsHT40tpMKWbJbNXwPJyAOtjKctkw6a5q36hxy1SgygIyTomGMPhxk968J
         0qCAB/7OwBKRGpyYNUSyaQcQdhLPo7Yv50e8ATqtjmz7AeRfCB23i1YGF1TjIH7nKzHS
         HBonyFhMQVI4vmdKfo0rIlmuj5dmz77cWkLXBi3j5zhTJgHi43PNZIIs6ZqeUGuuM4VC
         anOM4gBc+MezX4FD+OJ8CWFN+MlKRDg/5IGk7X1tB+5vMiAW1B2RM02DO4MRd4cEVQO+
         mrvQ==
X-Gm-Message-State: AJIora9K4axhm//ZcHEUKNOAuUSI46VURhY5exIWJF0BV/45m3WLYfEc
        YaqoIa40LFgJA8/dK5KgN8k=
X-Google-Smtp-Source: AGRyM1tuJavDaw2ZeB5uJ0MHKMNqboTFs62CD95DkaZOXlPzjryT/Zc+5J9PrnHXUmyjkWrAfUiKYw==
X-Received: by 2002:a17:906:8292:b0:723:5473:b2cf with SMTP id h18-20020a170906829200b007235473b2cfmr33329397ejx.378.1657018558713;
        Tue, 05 Jul 2022 03:55:58 -0700 (PDT)
Received: from ?IPV6:2a02:908:1987:1a80::835b? ([2a02:908:1987:1a80::835b])
        by smtp.gmail.com with ESMTPSA id d11-20020a170906304b00b0072abb95c9f4sm3238352ejd.193.2022.07.05.03.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 03:55:58 -0700 (PDT)
Message-ID: <8ccad303-7489-d90a-2255-ca36b7253810@gmail.com>
Date:   Tue, 5 Jul 2022 12:55:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: kernel-5.18.8 breaks cifs mounts
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>,
        Jeremy Allison <jra@samba.org>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <211885e7-1823-9118-836b-169c7163d7c2@gmail.com>
 <CAN05THTbuBSF6HXh5TAThchJZycU1AwiQkA0W7hDwCwKOF+4kw@mail.gmail.com>
 <fee59438-7b4a-0a24-f116-07c2ac39a3ad@gmail.com> <87h7423ukh.fsf@cjr.nz>
 <10efd255-16ea-6993-5e58-2d70e452a019@gmail.com> <87edz63t11.fsf@cjr.nz>
 <4c28c2f8-cda6-d9b4-d80f-1ffa3a3be14c@gmail.com>
 <20220630203207.ewmdgnzzjauofgru@cyberdelia>
 <CAH2r5mtVwZggJ9Fi0zsK5hCci4uxee-kOSC3brb56xpb0_xn7w@mail.gmail.com>
 <56afe80b-bf6a-2508-063a-7b091cdbbe0f@gmail.com>
 <CAH2r5mvoyhZGjf_wgvjgmkCz=+2iDxCSpbyJ79NMtpE1Ecjdnw@mail.gmail.com>
 <fccdb4af-697e-b7fc-6421-f16e9b35bb8e@samba.org>
 <11b3feeb-7ddb-1297-5080-7c2fc986475a@gmail.com>
 <CANT5p=oG9je_uY+6O6qdm_4HPKpZs0ZNZFrNFvSkeL+W4Gb67Q@mail.gmail.com>
From:   Julian Sikorski <belegdol@gmail.com>
In-Reply-To: <CANT5p=oG9je_uY+6O6qdm_4HPKpZs0ZNZFrNFvSkeL+W4Gb67Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



Am 05.07.22 um 07:28 schrieb Shyam Prasad N:
> On Mon, Jul 4, 2022 at 10:03 PM Julian Sikorski <belegdol@gmail.com> wrote:
>>
>>
>>
>> Am 03.07.22 um 19:51 schrieb Stefan Metzmacher:
>>> Am 03.07.22 um 07:01 schrieb Steve French:
>>>> I lean toward thinking that this is a Samba bug (although I don't see
>>>> it on my local system - it works to samba for me, although I was
>>>> trying against a slightly different version, Samba 4.15.5-Ubuntu).
>>>>
>>>> Looking at the traces in more detail they look the same (failing vs.
>>>> working) other than the order of the negotiate context, which fails
>>>> with POSIX as the 3rd context, and netname as the 4th, but works with
>>>> the order reversed (although same contexts, and same overall length)
>>>> ie with POSIX context as the fourth one and netname context as the
>>>> third one.
>>>>
>>>> The failing server code in Samba is in
>>>> smbd_smb2_request_process_negprot but I don't see changes to it
>>>> recently around this error.
>>>>
>>>> Does this fail to anyone else's Samba version?
>>>>
>>>> This is probably a Samba server bug but ... seems odd since it doesn't
>>>> fail to Samba for me.
>>>>
>>>> Jeremy/Metze,
>>>> Does this look familiar?
>>>
>>> Maybe this one:
>>>
>>> https://git.samba.org/?p=samba.git;a=commitdiff;h=147dd9d58a429695a3b6c6e45c8b0eaafc67908a
>>>
>>>
>>> that went only into 4.15 and higher.
>>>
>>> metze
>>
>> Nice catch, I can confirm that adding this patch to debian samba
>> 2:4.13.13+dfsg-1~deb11u3 package makes the mounts work again. How do we
>> get this patch into debian?
>>
>> Best regards,
>> Julian
> 
> Hi Metze,
> I went through the above patch, and it looks like an issue with
> parsing garbage at the end of the buffer, rather than negotiate count.
> I'm not sure how the netname negotiate context patches above are being
> affected by this samba server patch. The only difference from the
> client side for single channel is that the netname context appears as
> the 4th element in the list of 4, rather than the 3rd element in the
> list of 4. Do you have a possible explanation?
> 
> Julian,
> Thanks for the repro attempt. So I assume that with the latest samba
> server, things work as expected without reverting any changes in
> 5.18.8 kernel, correct?
> 
I have no way of testing a newer samba server unfortunately, but several 
people in this email discussion have mentioned that newer servers work 
for them:
- Paulo with W22
- Enzo and Steve with 4.15
- Steve with 4.16 without 
https://git.samba.org/?p=samba.git;a=commitdiff;h=147dd9d58a429695a3b6c6e45c8b0eaafc67908a

Best regards,
Julian
