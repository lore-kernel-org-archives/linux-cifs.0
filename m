Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28822C43334
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Jul 2022 11:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiGFLSR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Jul 2022 07:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiGFLSQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Jul 2022 07:18:16 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFBA27FC8
        for <linux-cifs@vger.kernel.org>; Wed,  6 Jul 2022 04:18:16 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v16so10140291wrd.13
        for <linux-cifs@vger.kernel.org>; Wed, 06 Jul 2022 04:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=BPDCCNOkuTCgcYg/RqnixstMMzarWd4yVjUrwP32HsY=;
        b=bQAzTC6Q1/XBs7Ftb9eUpfOxHpK8s53TXaW6kuAcscq+1UKU8PhPD/IlXmalmY/K1e
         aVan+mdoy2Cru+F2gN0NUCTd8ysuM4/4LadNyvGdWVLnYmsduQEQm1i+o+mTEk/iBavZ
         L/R742epZoXQBIBloDmrVf9qq4n2iErpsL11DfpHKczRFB0sqY8/cJpsas1NBPmaH4wM
         fMJPi1ew6O4Gt/Ttuip5Sl6hsRG9AGp65Z86vApdgSmTSC0vJ4nNKvm2EwzTEnxAs4qW
         +gUOmUr4ws01405kCnU66CjCZLBgQBtwTMXTNO1KIFYqJ6n5FsDGWAXLSaozXPTsFSIw
         Du0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=BPDCCNOkuTCgcYg/RqnixstMMzarWd4yVjUrwP32HsY=;
        b=QmqwqnHZcwq8KtjPAO7fx1P1d2g08Am5MrD6ofYWwTGRUI+ZI2GNgwsrWDzfrn72W+
         7lGDJCCbHBmcqBt/husEpGAp4RSSV0+LVQcPlV2sAkq3xx2Ij08JPBeksc7pQWZpslQb
         PQ7M0aEKx8RxXfNMjJjGgjv8wX66nUV9CUIMVbXzjJPxXpfWJleq0opmwapWAda2QdPu
         rSqAL9bUnyeKePPKiwO/7DWrkva+6aB/e45NeFGOc1SH/eTM2oxwIGORWTBlISQC0jdE
         PqZRJsfXJ1xIixJ+8dJcKqjic0QJdr71MBZgXj1siteVjX6ZCyEWKr6Opfbkzae+93GN
         uDag==
X-Gm-Message-State: AJIora8l/vQYFibbqey7GuN5FMYa0+OmHTjZv3JkPSwSumrxsmU3pXl6
        bLPh3bq1dOrhf9RJhZ1RJ10=
X-Google-Smtp-Source: AGRyM1tpXkVAsdWa7rEw/Yboq+3a7L3V/XQF5bnluuhjBBdtJh+HBXovlYWqrttfh1Ac8IMLaXHBLg==
X-Received: by 2002:a5d:4344:0:b0:21d:578a:d8b7 with SMTP id u4-20020a5d4344000000b0021d578ad8b7mr21155420wrr.108.1657106294443;
        Wed, 06 Jul 2022 04:18:14 -0700 (PDT)
Received: from ?IPV6:2a02:908:1987:1a80::835b? ([2a02:908:1987:1a80::835b])
        by smtp.gmail.com with ESMTPSA id f2-20020a7bcd02000000b003a0499df21asm26590930wmj.25.2022.07.06.04.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 04:18:13 -0700 (PDT)
Message-ID: <5936fdc6-3ab2-35d7-ff79-19a4a3768f19@gmail.com>
Date:   Wed, 6 Jul 2022 13:18:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: kernel-5.18.8 breaks cifs mounts
Content-Language: en-US
From:   Julian Sikorski <belegdol@gmail.com>
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
 <11b3feeb-7ddb-1297-5080-7c2fc986475a@gmail.com>
In-Reply-To: <11b3feeb-7ddb-1297-5080-7c2fc986475a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Am 04.07.22 um 18:29 schrieb Julian Sikorski:
> 
> 
> Am 03.07.22 um 19:51 schrieb Stefan Metzmacher:
>> Am 03.07.22 um 07:01 schrieb Steve French:
>>> I lean toward thinking that this is a Samba bug (although I don't see
>>> it on my local system - it works to samba for me, although I was
>>> trying against a slightly different version, Samba 4.15.5-Ubuntu).
>>>
>>> Looking at the traces in more detail they look the same (failing vs.
>>> working) other than the order of the negotiate context, which fails
>>> with POSIX as the 3rd context, and netname as the 4th, but works with
>>> the order reversed (although same contexts, and same overall length)
>>> ie with POSIX context as the fourth one and netname context as the
>>> third one.
>>>
>>> The failing server code in Samba is in
>>> smbd_smb2_request_process_negprot but I don't see changes to it
>>> recently around this error.
>>>
>>> Does this fail to anyone else's Samba version?
>>>
>>> This is probably a Samba server bug but ... seems odd since it doesn't
>>> fail to Samba for me.
>>>
>>> Jeremy/Metze,
>>> Does this look familiar?
>>
>> Maybe this one:
>>
>> https://git.samba.org/?p=samba.git;a=commitdiff;h=147dd9d58a429695a3b6c6e45c8b0eaafc67908a 
>>
>>
>> that went only into 4.15 and higher.
>>
>> metze
> 
> Nice catch, I can confirm that adding this patch to debian samba 
> 2:4.13.13+dfsg-1~deb11u3 package makes the mounts work again. How do we 
> get this patch into debian?
> 
> Best regards,
> Julian
I have now filed a bug against debian samba package:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1014453

Best regards,
Julian
