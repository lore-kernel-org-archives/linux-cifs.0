Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE76C636CC
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Feb 2023 09:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjBPJKi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Feb 2023 04:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjBPJKi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Feb 2023 04:10:38 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A929E38651
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 01:10:36 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id bi36so1936221lfb.8
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 01:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=itpmqCRSbaIVC7wZtfr9HbCli3IWfUbTikhRIPulXqo=;
        b=ehpbVRDY3uFTXff1WZrb6WzdSKIUhNZKsSYQj+UUJ9tM4zj5sKYMMEnr2n0/mMzn/o
         IecrjHyF7rqlAAAr0WXGO/Ou4CQWwvq4ZdaGLW6n9piiT0pmaBCHTJARw3TxpUoZfwim
         ASsW9LVa9EB64amERKkSIZrA4RkOAajtj/XTJlY+n2AOWieHVDCD5B5Ret+Gxsg7mFVV
         Vry1hqxCXl1i4WP+jUXmGt3XZLHNge0QPVZG+WCZjm2ONoixoQpWa21B9LY92Lu2UvJU
         0OT1aL4himfNuIXrdFYrwOeOtzCie75xXunGHoVbinRum48bgpgsmeWgYM9ONIqtcZqJ
         Fyzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=itpmqCRSbaIVC7wZtfr9HbCli3IWfUbTikhRIPulXqo=;
        b=LYvZRA3ajBQILD9M780MWoQezIcDufDodNN3qagb4ohcvurd1XEDr0GNsBkpCteEV3
         02hHUrWqEvb2l3THwPHr11eBpTy+7il2lLQxpdBOwHxNpseVFfW9NWWGVa7gaXLWwBJe
         VZQypPTO7FJEGNB7yw+77DcvF9xX5G11sYpdP8VSnIaS3PWv/srvw5i2qc+22KQ2hUA0
         8HmxKFGL4DqM+d1jNZRRZ0Ga+HzJc0qGlo6ruXNBl+upuZ0l3CfFRgg6pgH+cfpWTklU
         esX4tOVhMTnvXVry7kEhufX83Nv6MGMAwAhhMMjtoGPnUxX9I0LRoGPe5rqEOBvNnkyL
         GJrQ==
X-Gm-Message-State: AO0yUKWyq48vdSI00UkDoIV6RGI6xIFM7t4T/JHLkcFunoeX4wrBP1U9
        C8ImkGKFAtqPaWgYwWyHzUax5Q==
X-Google-Smtp-Source: AK7set8ACLYGt8o/dN9L05F77GXMyAo0T/IhKox4F0xKScHW5FBT6vZ462WamvK/b6Hz9W8WtuuerQ==
X-Received: by 2002:ac2:5ec8:0:b0:4cc:7ff3:ab4d with SMTP id d8-20020ac25ec8000000b004cc7ff3ab4dmr1530785lfq.20.1676538634978;
        Thu, 16 Feb 2023 01:10:34 -0800 (PST)
Received: from [192.168.1.101] (abxh117.neoplus.adsl.tpnet.pl. [83.9.1.117])
        by smtp.gmail.com with ESMTPSA id q14-20020ac246ee000000b004d6ebbad989sm220855lfo.1.2023.02.16.01.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 01:10:34 -0800 (PST)
Message-ID: <71078188-1443-d84e-658c-967991f3b590@linaro.org>
Date:   Thu, 16 Feb 2023 10:10:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 2/2] Revert "splice: Do splice read from a buffered file
 without using ITER_PIPE"
To:     David Howells <dhowells@redhat.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-mm@kvack.org
References: <20230215-topic-next-20230214-revert-v1-2-c58cd87b9086@linaro.org>
 <20230215-topic-next-20230214-revert-v1-0-c58cd87b9086@linaro.org>
 <3055589.1676466118@warthog.procyon.org.uk>
Content-Language: en-US
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <3055589.1676466118@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



On 15.02.2023 14:01, David Howells wrote:
> Konrad Dybcio <konrad.dybcio@linaro.org> wrote:
> 
>> next-20230213 introduced commit d9722a475711 ("splice: Do splice read from
>> a buffered file without using ITER_PIPE") which broke booting on any
>> Qualcomm ARM64 device I grabbed, dereferencing a null pointer in
>> generic_filesplice_read+0xf8/x598. Revert it to make the devices
>> bootable again.
>>
>> This reverts commit d9722a47571104f7fa1eeb5ec59044d3607c6070.
>> Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> 
> Commit d9722a47571104f7fa1eeb5ec59044d3607c6070 was part of v13 of my
> patches.  This got replaced yesterday by a newer version which may or may not
> have made it into linux-next.
> 
> This is probably a known bug fixed in the v14 by making shmem have its own
> splice-read function.
> 
> Can you try this?
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=iov-extract
next-20230216 boots fine again, thanks!

> 
> (Also, can you include me in the cc list as I'm the author of the patch you
> reverted?)
Ugh.. I thought b4 would have done that for me.. weird..

Konrad
> 
> Thanks,
> David
> 
