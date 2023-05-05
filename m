Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4A6C7EE24
	for <linux-cifs@archiver.kernel.org>; Fri,  5 May 2023 15:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbjEEPPF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 May 2023 11:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjEEPPE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 May 2023 11:15:04 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6A41BCA
        for <linux-cifs@vger.kernel.org>; Fri,  5 May 2023 08:15:03 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4ec8133c59eso2202132e87.0
        for <linux-cifs@vger.kernel.org>; Fri, 05 May 2023 08:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683299701; x=1685891701;
        h=content-transfer-encoding:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G2Fhl/8xaRw80SS/8jJuxAz6zcjXeBnc7VV9nqdCNUc=;
        b=eUcTPPAlx6iuI8pJdJcDe269uyIc4qbpV19qLhEgQ4gbaUVrYyNpLNeI9TEw/SsC+H
         EKfOhi0dLifb0e+YwtDZj32rtqv8lu7pDJiSqQ0QrJW50HDDsKYKqf53r0JmtsOCPBCk
         BaKGiM51WwEheUP/xefAfMoaEHrBL/NOY6cefS4mVr5iph6NjWj6u924eCXnvQGa14AR
         HZluuNCT+DMzUbvnRRKFKQJKfLdMW7YMV6sT0Ea1u3jMVCpU3bPZ0PgG2bOpRrE9VpFa
         lR614iwbs2K83SsaZLGb78OyHgDJz7HLiBO+QxZ3hD1zWoQhG8LussjQvyYqpPYSNqPU
         XfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683299701; x=1685891701;
        h=content-transfer-encoding:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=G2Fhl/8xaRw80SS/8jJuxAz6zcjXeBnc7VV9nqdCNUc=;
        b=Ef4el96wQO2NyGaqmawE2JAJi12pENRaBoxX7YF00BvFFDR6WTnqOnETsLafd3zJ6q
         Jroxbrho6pV/HuSZE8AEbhvmxNFf81fCO8zjyjV/rFOGlzVzuRfavs4Ec1CHf+ZMoexv
         7Br3xisIhlL6yM7C/1HPCA7ancw7CyyyLOb02ZBSARy313nT95S+9IuHKzYjlP1r/LW6
         qzDCI3Ktb6ebd/zaDysQo8udhoxCA4CqXGMRHvnzTBZgKu/Jb+soSvnmSKOG4pvKu5j8
         52kV6m3S8BOJf1eHDnCbvfSV2C3aw2k3v5up+WkudOqOaB2qEf2wOZhODwhOlMSv0sRo
         vB4A==
X-Gm-Message-State: AC+VfDzNkS2/PKnxWRLZhjBpnRaAunIzHLXLBo+hL6vWCFNj1yZbgBl5
        LCi4+9o3yZZr04YtmoZ3iEADeJMAVXU=
X-Google-Smtp-Source: ACHHUZ5j/KExXhVhR9ptaYium42mg8Gy3beDGQQB9cMpEctT1Y/qV7eSHi1OiKeWxTHo4eDvju7LyQ==
X-Received: by 2002:ac2:520a:0:b0:4f1:2142:5540 with SMTP id a10-20020ac2520a000000b004f121425540mr639437lfl.6.1683299701061;
        Fri, 05 May 2023 08:15:01 -0700 (PDT)
Received: from [10.10.10.110] ([94.231.1.83])
        by smtp.gmail.com with ESMTPSA id w11-20020ac2598b000000b004f14591a942sm318176lfn.271.2023.05.05.08.15.00
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 May 2023 08:15:00 -0700 (PDT)
Message-ID: <4b402539-1b98-bfe6-fa60-d73d13794077@gmail.com>
Date:   Fri, 5 May 2023 17:14:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Content-Language: en-US
From:   Pawel Witek <pawel.ireneusz.witek@gmail.com>
Subject: [PATCH] cifs: fix pcchunk length type in smb2_copychunk_range
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Change type of pcchunk->Length from u32 to u64 to match
smb2_copychunk_range arguments type. Fixes the problem where performing
server-side copy with CIFS_IOC_COPYCHUNK_FILE ioctl resulted in incomplete
copy of large files while returning -EINVAL.

Signed-off-by: Pawel Witek <pawel.ireneusz.witek@gmail.com>
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a81758225fcd..35c7c35882c9 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1682,7 +1682,7 @@ smb2_copychunk_range(const unsigned int xid,
 		pcchunk->SourceOffset = cpu_to_le64(src_off);
 		pcchunk->TargetOffset = cpu_to_le64(dest_off);
 		pcchunk->Length =
-			cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk));
+			cpu_to_le64(min_t(u64, len, tcon->max_bytes_chunk));
 
 		/* Request server copy to target from src identified by key */
 		kfree(retbuf);
-- 
2.40.1


