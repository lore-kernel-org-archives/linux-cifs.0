Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF450C001B0
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Aug 2023 07:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjHJHVT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Aug 2023 03:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjHJHVS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Aug 2023 03:21:18 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E40310C
        for <linux-cifs@vger.kernel.org>; Thu, 10 Aug 2023 00:21:16 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6bd04558784so569260a34.3
        for <linux-cifs@vger.kernel.org>; Thu, 10 Aug 2023 00:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=har.mn; s=google; t=1691652076; x=1692256876;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HvH42dUlubBMm0ryqS2TOIl7aBw86JJE8vPn9bwwG24=;
        b=MirwHyY7kkvPWQptfoHmqteiZbK7KcIosd2/SDu5Pe1Ou7CiU/RHnVu4YpH10N8mDc
         tmJbEMiqScOIhPeqrhjaOPyi8ugcHV0X9ZUON3gob0LqSxAyEbBsr/d+MqMrrEKxqWQL
         sknBx4uhbvlNRVdS8w/AxkjONyn6D4SCh1EivZ+X3ue3RrV2OJPl39B6mJMOH+JAWcIh
         //uy/Pk3DLYLbKwjcMyYamm+T0y2b5LBXpsT0BBkYTtT+eCNvgNtlOSHJbivuRWLbZLM
         JKGoE7rFx2O79djUf1AdaYKq5hksVLLp9qop7AVXbmUNMli3mceLwyv8abWTVMyCZvcZ
         zhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691652076; x=1692256876;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HvH42dUlubBMm0ryqS2TOIl7aBw86JJE8vPn9bwwG24=;
        b=FbOBpX7hZLGyanHmvgsiOGMshNmThKp3M+AC726Lb6mhJOGKXmGWdZi7VUxL1bKaln
         QlPFz2L1aWmQtBInADXiBHdSqSD5U+yKtIrnDVbVweKniBmwFmOAXuxsx+IWVi+NhCGo
         BKlR29D+NBWaqiAve3jGezj+5sqaiUtZNWNA0yvJxolycTOgZa7+zkzb9cbze8TcLaHy
         848Z1AtkeZVNls6itnok+i/6Xun2dqqR7JKvEO4ByYDhtNKUKp87Z92D5/0r1kWsyRuM
         t5TsNVt5b9FpXWclpR7ZYKYXbB+LS8xAefqsn17gZc2jRlTZZQ5+mLrul1K8fJa9E4ES
         tfQg==
X-Gm-Message-State: AOJu0YxlXeQXePt1zHQITyj8tTQBONkwgLoRWa4AugY6WbPIic6Z9p27
        krJdrYY8ZnvVC4bDotbiTrgwag==
X-Google-Smtp-Source: AGHT+IEWudtIuZuTvRG8Jeh7+YS9QDl+hW1X+NxXO+5DqighQw2IlAJSuIZBvKoWO+I4zQxL+PErkA==
X-Received: by 2002:aca:2818:0:b0:3a7:b5ea:f5e8 with SMTP id 24-20020aca2818000000b003a7b5eaf5e8mr1609870oix.27.1691652075831;
        Thu, 10 Aug 2023 00:21:15 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
        by smtp.gmail.com with ESMTPSA id g5-20020a170902868500b001bb9f104333sm880561plo.12.2023.08.10.00.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 00:21:15 -0700 (PDT)
From:   Russell Harmon <russ@har.mn>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Russell Harmon <russ@har.mn>
Subject: [PATCH v1 0/1] cifs: Release folio lock on fscache read hit.
Date:   Thu, 10 Aug 2023 00:19:21 -0700
Message-Id: <20230810071922.30229-1-russ@har.mn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Here's a patch that fixes what seems to be a showstopping bug in
cifs-fscache. *Any time* that a fscache read hit occurs on a mounted
cifs filesystem (and therefore cifs_readpage_worker is called), the page
lock on the read page is leaked, causing subsequent accesses to the page
to deadlock.

I've been running my machine for the past week with this change and it
seems to work, but I'm a little concerned that this may mean
cifs-fscache has no users (besides me). Up to you (maintainers) whether
that means you should accept this patch... or delete the fscache
support.

Russell Harmon (1):
  cifs: Release folio lock on fscache read hit.

 fs/smb/client/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.34.1

