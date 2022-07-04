Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B9EC43334
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Jul 2022 16:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiGDQ3M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Jul 2022 12:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiGDQ3L (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Jul 2022 12:29:11 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7938A26E5
        for <linux-cifs@vger.kernel.org>; Mon,  4 Jul 2022 09:29:10 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id sb34so17524780ejc.11
        for <linux-cifs@vger.kernel.org>; Mon, 04 Jul 2022 09:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/4Bifa5BdsfufpTLzFN6BDd7T9pso0UEF3fKeZEJGSk=;
        b=XvGIhixKqrSNLGW1ErhR9eCIK8eFGAck8q0VshnTVKnAbwNTHW6W3Fl8IYRa5Cm2kk
         UZMmj2UDdWyyrHF0EnFoU2Hjtd6mBV7QxwG/LDjffZc6uwb/K1JlF73Jz33XjZz0KXQz
         fawq8P0fJ+uZ/2DJD0RBz3KuuCP5JgV1qYj7BwpBPaRFQ882Wsi82E3o7HfhEx8i0eod
         j0TSYP3fRENbHM/ySw0DWRBFDVm0X016YK0x6kC6BBaNC3X41pVlI44bidWPllrZbCvv
         RNPTC11qF6vZZ8r5J2IPcrhFFtkilyBPKzCHvWVn1mwD6htgueOECNGd4lIwijvkhgqJ
         DrTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/4Bifa5BdsfufpTLzFN6BDd7T9pso0UEF3fKeZEJGSk=;
        b=V8vmAK/lSGZuOtPQGBqds4w1mGDKbq9P7uyC/IrR3t3JQKuIjzulz4bqGXN+1nFMcB
         7Z9kWc7D1ESBpF5EBnxI7nH41HRSzVGUYrj1fkGUv5rePFC5Jue/B54hiGyXrYq2wTyg
         PuHU8USOugpwvh3Sq/oJweZyHABGwrIai45uddh2k5mCY1rMvCWUTZvNhzL0qRGya89G
         zxF4BG2svkyDHyUmzyg2HuQFcnkk8Lxo7x0RNkl/A2H9e+QOJjXEfo0hOlMocHukgCpF
         pNd5N8UYYpRFC6tmr7CIQ2U83j+aDreHr+EUyr3PPi1m7wHvkxAJfjvNclOJ/z4RuyV0
         /fFg==
X-Gm-Message-State: AJIora+hj5VmIKoxRGRjCFnUGlPs+77YVlgEPzl8ww/JS5A8ZP3fBKG4
        VNEG70hvdQQ4EocZqbWYfkM=
X-Google-Smtp-Source: AGRyM1tYU85mURMZRQnjWmZCUeO73oEsHskxOvbN71rdxPT9fUR/yOscleL9h0V0IWFHcaelP70cKQ==
X-Received: by 2002:a17:907:9605:b0:6f5:c66:7c13 with SMTP id gb5-20020a170907960500b006f50c667c13mr30083658ejc.66.1656952149012;
        Mon, 04 Jul 2022 09:29:09 -0700 (PDT)
Received: from ?IPV6:2a02:908:1987:1a80::835b? ([2a02:908:1987:1a80::835b])
        by smtp.gmail.com with ESMTPSA id g4-20020a17090669c400b006fe9f9d0938sm14581531ejs.175.2022.07.04.09.29.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 09:29:08 -0700 (PDT)
Message-ID: <11b3feeb-7ddb-1297-5080-7c2fc986475a@gmail.com>
Date:   Mon, 4 Jul 2022 18:29:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: kernel-5.18.8 breaks cifs mounts
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>,
        Jeremy Allison <jra@samba.org>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>, Paulo Alcantara <pc@cjr.nz>,
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
From:   Julian Sikorski <belegdol@gmail.com>
In-Reply-To: <fccdb4af-697e-b7fc-6421-f16e9b35bb8e@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



Am 03.07.22 um 19:51 schrieb Stefan Metzmacher:
> Am 03.07.22 um 07:01 schrieb Steve French:
>> I lean toward thinking that this is a Samba bug (although I don't see
>> it on my local system - it works to samba for me, although I was
>> trying against a slightly different version, Samba 4.15.5-Ubuntu).
>>
>> Looking at the traces in more detail they look the same (failing vs.
>> working) other than the order of the negotiate context, which fails
>> with POSIX as the 3rd context, and netname as the 4th, but works with
>> the order reversed (although same contexts, and same overall length)
>> ie with POSIX context as the fourth one and netname context as the
>> third one.
>>
>> The failing server code in Samba is in
>> smbd_smb2_request_process_negprot but I don't see changes to it
>> recently around this error.
>>
>> Does this fail to anyone else's Samba version?
>>
>> This is probably a Samba server bug but ... seems odd since it doesn't
>> fail to Samba for me.
>>
>> Jeremy/Metze,
>> Does this look familiar?
> 
> Maybe this one:
> 
> https://git.samba.org/?p=samba.git;a=commitdiff;h=147dd9d58a429695a3b6c6e45c8b0eaafc67908a 
> 
> 
> that went only into 4.15 and higher.
> 
> metze

Nice catch, I can confirm that adding this patch to debian samba 
2:4.13.13+dfsg-1~deb11u3 package makes the mounts work again. How do we 
get this patch into debian?

Best regards,
Julian
