Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97457C4361B
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 01:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 620C122C7E
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 01:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437360AbgLNBVL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 13 Dec 2020 20:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731420AbgLNBVC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 13 Dec 2020 20:21:02 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B953FC0613CF
        for <linux-cifs@vger.kernel.org>; Sun, 13 Dec 2020 17:20:21 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id u18so26067438lfd.9
        for <linux-cifs@vger.kernel.org>; Sun, 13 Dec 2020 17:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=d7JvA8Nv7iH1ZVMJ8mFDtnTgcKZcU2R5Yr5wBpx5tao=;
        b=eUVPJap10UlFCoWUVZ/0ozHkqjM2yroS43ra9NRBt2lDRbRJREX+FqEhDVpKGOwsSY
         +uVskOC3MWNh+ev3PF3wlbq/WnLCBd1tx8+z8kUMHdSBmHq1p2DxomLOSq2v80/NTamU
         uF/xuoQGZUqajFloHNCEs9IN+BjlvPnbEUA4KblpP082TL+7kMDu4zt8FiW1flr6gIIY
         wCNSYyt8pFMwRaBEuTw+rT05yzcDLZhkM0pAvOcdUXSHSK8+qkS//Oc/zomRtMAqVFAy
         XHbln1LMx1g4cGvf2a/KZ3GUERAP86oYJNN63BhEY1IdbjSJPY2C9KEyzdCNbl4fowXR
         5zDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=d7JvA8Nv7iH1ZVMJ8mFDtnTgcKZcU2R5Yr5wBpx5tao=;
        b=TDt8GT2CImlfEzrkRHTE7jD7MOJwalxXwnIYpCFBFF4WnTG6SDZd1SWSm3Elb+e2Bi
         P6ZWuqxYuuqzPF+cEy/fCMKOy1Q93gzbFuHjYaUVaqLkVC0I/9Fw/ilGxmG3k1+RzCsv
         BrfHIBZ2S7YQlEnAAPhd4pZWzD+jou5AMJSoMFfkD+1D4sDDjpGqeU95laHx5ciquypo
         xRCxlOtVZ6rhk3uFJlJO0chQrvMz41Cb1YUtyu6LY0LOQXccAl0nrdSxI08MdQMiwe+o
         lRbyeoasNOgjy/8LywVCiGD/vP4Bk0QD3nqQnrlNJq6/k1e7C2xQYNjH398aHuHNsj0D
         GXVQ==
X-Gm-Message-State: AOAM531r5PL1GqLH4pgMRL22O858zi2UtBDUBbBq4GlhseO/0Tx9Th5R
        WLF6dOrItn1d85kr/kA+3PE3YfJKxniRGZ3G96o=
X-Google-Smtp-Source: ABdhPJz5d7Pb1uATsZd40cCwHUf+9EeBMnd9hycXTRTuFQ3qz7gEIDGURVZL3xMIKWcaCeq0fVdhS57/tPBvAkOTCEY=
X-Received: by 2002:a2e:87cb:: with SMTP id v11mr9220646ljj.218.1607908820034;
 Sun, 13 Dec 2020 17:20:20 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 13 Dec 2020 19:20:09 -0600
Message-ID: <CAH2r5muRCUzvKOv1xWRZL4t-7Pifz-nsL_Sn4qmbX0o127tnGA@mail.gmail.com>
Subject: updated ksmbd (cifsd)
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I just rebased https://github.com/smfrench/smb3-kernel/tree/cifsd-for-next
ontop of 5.10 kernel. Let me know if you see any problems.   xfstest
results (and recent improvements) running Linux cifs.ko->ksmbd look
very promising.



-- 
Thanks,

Steve
