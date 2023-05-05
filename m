Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DB9C7EE24
	for <linux-cifs@archiver.kernel.org>; Fri,  5 May 2023 19:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbjEETcb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 May 2023 15:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbjEETba (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 May 2023 15:31:30 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2998C4490
        for <linux-cifs@vger.kernel.org>; Fri,  5 May 2023 12:31:29 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4efd6e26585so2506949e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 05 May 2023 12:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683315087; x=1685907087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rb+xxIf4QJsBCq0kEY0dRryuXTwQxfLN+pndzOyOuFU=;
        b=J8sxBTtGivEHrQfQGGerwRKJZVz/Fzli+F06zyKBLabv+9gCEb0bymrnVLP3mbHj3b
         3zJ2I2VofPpkaUABzhTgnlAPJ7ZrFBPO/JD9cc+bv4AqD7/IRMQosHH04fTkLySy98vE
         2Q7NmhqR7317XMZAaBHxTkYSN0hKUaAScOivcYhZ+vnkXhdCqRX6UqiSFzBQSr3DVvva
         VavWzQB1atmW7VGhNpExevWwm8nxc9KtdCSHmV2OXl3HzZ9Dm2b92gegq/HH8HQAGzQf
         kt5jGboXTLBhKa60y61ZwSNfCkxfyTjktPg+o2u/GnGR0pbulORG6ZLawJqwlN//s9Gp
         QMHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683315087; x=1685907087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rb+xxIf4QJsBCq0kEY0dRryuXTwQxfLN+pndzOyOuFU=;
        b=gM6LVUlgU17Z6v/Ic5/mERF7sVy3pV78+5E01zK/sMWn2n3FSZqjZiwXvldw0xLlqr
         ZPrK+bjkOQeHID1DIg70/wBV0vDt594FnhBxyzJ482/rvOiK4OzwdWDB9U92659UU3xa
         6J8Otf5lToWlPrgoIjyanG1oBCjU1PKA2YePWN7J6/Mq027Ko7QpjOhBKJ6sZzbMnkkU
         YwzY611BLN4eWSswaT3+88wvdw0x+jyCra5vK+AEiMWyMXIZpWvm7y87vq82t0ewbAT7
         Ay4Kmn2sgTJV1c/d4s55NN1hkqeTEDqB6P/P1iOKIofqllYbnGK86jxPwFJGlwmzWZuj
         ceMw==
X-Gm-Message-State: AC+VfDxvbs9W7UPfUIJb+zheK+e0xXkkS+y+PmMy4HOX3yStaCGUWkVS
        hpFbfzF/l5BkyzqMjaTZlTNRfWuxbD8=
X-Google-Smtp-Source: ACHHUZ6FVqU3meyzmaT4ZGl6HsQ1BYi/CPTpcn9OpXQwwKqEADkJuKb+WAUdyf0vDnBM0m7BNNvEpQ==
X-Received: by 2002:ac2:55b6:0:b0:4f1:3ae6:20bf with SMTP id y22-20020ac255b6000000b004f13ae620bfmr674234lfg.1.1683315087071;
        Fri, 05 May 2023 12:31:27 -0700 (PDT)
Received: from [10.10.10.110] ([94.231.1.83])
        by smtp.gmail.com with ESMTPSA id w16-20020a05651c103000b002a76bb6bce0sm91231ljm.37.2023.05.05.12.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 May 2023 12:31:26 -0700 (PDT)
Message-ID: <824c8a05-4c68-119e-45a9-504ea0aa8583@gmail.com>
Date:   Fri, 5 May 2023 21:31:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH] cifs: fix pcchunk length type in smb2_copychunk_range
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org
References: <4b402539-1b98-bfe6-fa60-d73d13794077@gmail.com>
 <CAH2r5mszw6sayQfJqiYwTjPCqKDB7Dk-Hmtr0-Z3fXf=e3t0aQ@mail.gmail.com>
From:   Pawel Witek <pawel.ireneusz.witek@gmail.com>
In-Reply-To: <CAH2r5mszw6sayQfJqiYwTjPCqKDB7Dk-Hmtr0-Z3fXf=e3t0aQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I've tried to copy a 5 GB file which resulted in -EINVAL (same for larger
files). After wiresharking the protocol I've observed that one packet
requests ioctl with 'Transfer Length: 0', to which the server responded
with an error. Some investigation showed, that this happens when
len=4294967296.

On 5/5/23 18:47, Steve French wrote:
> since pcchunk->Length is a 32 bit field doing cpu_to_le64 seems wrong.
> 
> Perhaps one option is to split this into two lines do the minimum(u64, len, tcon->max_bytes_chunk) on one line and the cpu_to_le32 of the result on the next
> 
> What is "len" in the example you see failing?
> 
> On Fri, May 5, 2023 at 10:15 AM Pawel Witek <pawel.ireneusz.witek@gmail.com <mailto:pawel.ireneusz.witek@gmail.com>> wrote:
> 
>     Change type of pcchunk->Length from u32 to u64 to match
>     smb2_copychunk_range arguments type. Fixes the problem where performing
>     server-side copy with CIFS_IOC_COPYCHUNK_FILE ioctl resulted in incomplete
>     copy of large files while returning -EINVAL.
> 
>     Signed-off-by: Pawel Witek <pawel.ireneusz.witek@gmail.com <mailto:pawel.ireneusz.witek@gmail.com>>
>     ---
>      fs/cifs/smb2ops.c | 2 +-
>      1 file changed, 1 insertion(+), 1 deletion(-)
> 
>     diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>     index a81758225fcd..35c7c35882c9 100644
>     --- a/fs/cifs/smb2ops.c
>     +++ b/fs/cifs/smb2ops.c
>     @@ -1682,7 +1682,7 @@ smb2_copychunk_range(const unsigned int xid,
>                     pcchunk->SourceOffset = cpu_to_le64(src_off);
>                     pcchunk->TargetOffset = cpu_to_le64(dest_off);
>                     pcchunk->Length =
>     -                       cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk));
>     +                       cpu_to_le64(min_t(u64, len, tcon->max_bytes_chunk));
> 
>                     /* Request server copy to target from src identified by key */
>                     kfree(retbuf);
>     -- 
>     2.40.1
> 
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
