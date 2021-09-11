Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C77CC433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 11 Sep 2021 01:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6029460FDA
	for <linux-cifs@archiver.kernel.org>; Sat, 11 Sep 2021 01:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbhIKB1a (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Sep 2021 21:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234989AbhIKB13 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Sep 2021 21:27:29 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A8EC061574
        for <linux-cifs@vger.kernel.org>; Fri, 10 Sep 2021 18:26:17 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id f18so7643093lfk.12
        for <linux-cifs@vger.kernel.org>; Fri, 10 Sep 2021 18:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+LWuvYQjspTz03CsbT+ZJbsC2l6xIZAAQm/3dQlc4AI=;
        b=pZLGLeGoLM54mdbHL/iQwReCIbLJGYHleWwJFiHlLzPENai1V0oaOBLPoMtQ/J4WxU
         jzGjT7m29wWG+y812IlBiEmCUinI9NNMFeMlxAWNdox0eCxWvdY/zt5ATL6GmNBWX19f
         cTkO+89CRUk3kNssys9CX2I0x/5kmUx6P2TdTYL53v0NkmrakQblUON481/EGrz8aOZF
         e+C0c2+U95tJqJuWIUmv3ug41x7SOik6yTNAvvdTtHSQXbYkncPVZw2SZ7BBnhpSz1PR
         N+HHatILmCGaLiGzqbTDj9bEkT2lRX6BIyR2PueQVxYhmoSYmeFm0+msotY0Ms3Fbqxs
         Wdcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+LWuvYQjspTz03CsbT+ZJbsC2l6xIZAAQm/3dQlc4AI=;
        b=vdNce9Ie0iRc+TdCUnx11i7z/aIq7yEdiz0KtdqTs+aRqCD5Xqe7Pq3rYb7LIMuley
         KP1sIya6T+N3/89G8Uopf9ReV8QknmlyOwaRfjZtQBVFNj70K+XVZ+jFc/OY/19EfsrV
         dCFLK5wjdVAQfhTqHPz8gq0gyC3kFd6+XAzPeZQs4hhnAbQxoeTqMq1ndeuLiO6cGwAL
         bLevQNJjQV3BIDldtKZ67etO74obf3R092O+Bf/hg6qAXTP7pI/T2F7/J1O/R48SkX35
         7sRpSw1pHialq+93xkODsZiDJcaEXYOIz+WCm9gLrkuDoH7aas5SswsUAAU3H/A+PWvE
         8Mqw==
X-Gm-Message-State: AOAM532Jne+2bj6+NKqlBhWWh4craCl3QcmBTfNhUkTxt9+eTagS9ksp
        LpmXAs7Nhsct6a+E4FxSnPTAwJWpTBRz4St9xfUKJNvVWys=
X-Google-Smtp-Source: ABdhPJw5pUGhT49nakfxUZekG7vjlGz70yEkMDaZ9g7KyY4y97zVyfMzbpS/izCpF6as7pJAShZU8L51dVCe7oBzqeg=
X-Received: by 2002:ac2:41c9:: with SMTP id d9mr323319lfi.667.1631323575798;
 Fri, 10 Sep 2021 18:26:15 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 10 Sep 2021 20:26:04 -0500
Message-ID: <CAH2r5muuG8vnUbPFadcJeCOugt5zEwxh0LMmnkp8gOHab+1Dug@mail.gmail.com>
Subject: xfstest detailed results
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I am trying to put much more detailed xfstest results out more visibly
(see the link below for tests of current mainline, with default mount
options to ksmbd in current mainline, 5.15-rc)

I am hopeful that this will make it easier to track work items
(bugs like some fallocate related items, and new "features" like
O_TMPFILE and freezing support e.g.) and also make it more clear what
tests people should run against what servers with what mount options
...

https://wiki.samba.org/index.php/Xfstest-results-ksmbd

-- 
Thanks,

Steve
