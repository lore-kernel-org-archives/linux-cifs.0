Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDE6C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jul 2022 14:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiGMO5K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Jul 2022 10:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiGMO5J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Jul 2022 10:57:09 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3F73DF23
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jul 2022 07:57:04 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id dn9so20305147ejc.7
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jul 2022 07:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=m109Ub3L5I4q+qxtMJDCHO1OXJtJ5Sf3Mj/TvL1IJAo=;
        b=g2NTuXquWSTkPsQHXqZM1UXANKoZgomic2tB0UVViDSkxPxHDd+pHwnzbg17bmobvg
         LsbvWMAVd/IGJBbaUvk2ff/aUl4BIDAXtyRwMmxXt1gsL0E2CkaXTG1vuC+13LD3INkA
         CNq3qZs8Eou8+3BPfmZd3/u3+6RLDpKeLMkwCRX4k/NoBgC2ChTg9cXTUdGF+XoIB3Pf
         AOiBRMnlHvU4lW4RyvgLZoNd1D6JthbL8xFqxA7Xv/jGBgCALToSKcHuChXqDlt8M9wF
         o0LrPb5cGKAI91MXG0rI9b+bicV0Cf0PG7h6ktEY7VKZUagM7kXrHPCkBpDkEKLDeM67
         gZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m109Ub3L5I4q+qxtMJDCHO1OXJtJ5Sf3Mj/TvL1IJAo=;
        b=SythbovSKo5pVjFc6l5NKwH3dGz2IiLP/uwyFbrYSeF047ZDh+FyN+vn6lEaO7kjCQ
         rJn4OAF+2WkEKcPrskR1ZPhXwSrlNl8P6s7ShPkMFlY0eBXo7EZNF0Cm+pLcTC/3IIH9
         jKt1UQe3yjv0dg0ps90aGE+jvy/OXCcm7XMfRHvDIXSv0PFW5qt/LLr9L/xpnfDuHe3U
         y3+VTw3adlwNgNAQcnGcToSH3jlStlbIb270NaahtoNbHzO1QrGsU07D0/M1k4RtF+aU
         K7Tr1/PYlsXogwwq8HLyVy5Hdgc98+hP11V7vaK3ETXGMEi+x66NYn8pI1v0BHqotdxE
         7JbA==
X-Gm-Message-State: AJIora8g0fZ3Djd1XhEZ4kKvUcwqUQ9BniXIORLlijupRpnnxgypejc6
        fRt+AD4JfgrHLVZNxHCoYjkGAVfvE0LJBg==
X-Google-Smtp-Source: AGRyM1vfEHA3LyfpjwEGrLZTeMHv2JQipRuLW/AQS9ZwPDlCFsDtgOt5Z+qTDN7q2nU8kisdGs95ng==
X-Received: by 2002:a17:907:3f9f:b0:72b:5af2:bc06 with SMTP id hr31-20020a1709073f9f00b0072b5af2bc06mr3866475ejc.381.1657724223571;
        Wed, 13 Jul 2022 07:57:03 -0700 (PDT)
Received: from ?IPV6:2a02:908:1987:1a80::323a? ([2a02:908:1987:1a80::323a])
        by smtp.gmail.com with ESMTPSA id i8-20020a170906a28800b0072b13fa5e4csm5098986ejz.58.2022.07.13.07.57.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 07:57:02 -0700 (PDT)
Message-ID: <ed25591c-e62e-dcee-6df3-0530ef2ac555@gmail.com>
Date:   Wed, 13 Jul 2022 16:57:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH][SMB3] workaround negprot bug in some Samba servers by
 changing order of negcontexts sent by Linux kernel client
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Brian Caine <brian.d.caine@gmail.com>
References: <CAH2r5mtuN-yswT5VTbNPzj02fwiHYOCe2eR8mcgRgRE8Qpkjgw@mail.gmail.com>
From:   Julian Sikorski <belegdol@gmail.com>
In-Reply-To: <CAH2r5mtuN-yswT5VTbNPzj02fwiHYOCe2eR8mcgRgRE8Qpkjgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Am 12.07.22 um 07:34 schrieb Steve French:
> Starting with 5.18.8 (and 5.19-rc4) mount can now fail to older Samba
> servers due to a server bug handling padding at the end of the last
> negotiate context (negotiate contexts typically round up to 8 byte
> lengths by adding padding if needed). This server bug can be avoided
> by switching the order of negotiate contexts, placing a negotiate
> context at the end that does not require padding (prior to the recent
> netname context fix this was the case on the client).
> 
> Fixes: 73130a7b1ac9 ("smb3: fix empty netname context on secondary channels")
> 
> See attached fix to cifs.ko

This patch fixes the issue for me when applied on top of 5.18.11. Thanks!

Best regards,
Julian

Tested-by: Julian Sikorski <belegdol+github@gmail.com>
