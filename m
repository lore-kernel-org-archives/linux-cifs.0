Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD17DC433DB
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 08:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7459F64E31
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 08:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhBDII6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Feb 2021 03:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbhBDII5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Feb 2021 03:08:57 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39020C061573
        for <linux-cifs@vger.kernel.org>; Thu,  4 Feb 2021 00:08:17 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id e132so2299043ybh.8
        for <linux-cifs@vger.kernel.org>; Thu, 04 Feb 2021 00:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Fw+wH8EUYv1di9oBpN6mosm3H2wk3jr37Tr6OKE9+nM=;
        b=UL2h/SteEn1+YhAkCwBF6KTpNc/0TF6xL7tOCq5fBLC+3ych9VCo5HCFrxblXkLXl4
         5QjTzXP6ZrW5WNky31m6rcnBZ5b71hIb1pRtfBz7KiqfXiveilDNdSxa7cUM9cjtK7Xa
         A0w1kj+kEToXxc89WHc/xLx5Mp0vgLHpu1s+00sZOFle8Zj/nG6xYYCFrFeskct5qEcg
         AxWVDexzbPqvuzJja9cvLED+IXgJ8mVhYY2DWpk2YliFA+zPpR27G8z1wLdMkLY7VO9w
         tlA8MNiC1l2H0kbjRv9xiwwIRgM8ETcW66Zxi622djGsJ877cwTracb2xHo5C8oInKtQ
         rdaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Fw+wH8EUYv1di9oBpN6mosm3H2wk3jr37Tr6OKE9+nM=;
        b=pfAYAc4WtA2dmmDzcBfDDWUSZpqDEXUGhx6ekrHU4f/6MI/OkWzyR6FcHg6nSgwG6I
         lwmLFdb2eMIoML4eKVxPwbt65Fb2rrMM9kTYU5nNI8Os4o9151/RahsXw83XwBMGOBIK
         1dw0fu9mSPRGbXAdwhUS29v+5+V9D8cfCTgJ413l9V7xaVrmunuZVB8f54YK4xH97HQm
         pTuCc48ghG3wbcJ6tlXKtjoJHgNkPl0E2ct7pwhznMCR4MZstyucMHxgOzXMtAiedfrf
         e9UO/jhtjzHgYxEYdCM+nLsYl/QRyDPNMo+1MQhtk7JqO611HExaoIhjguiwjIIjx6vN
         zcbA==
X-Gm-Message-State: AOAM5300CcDvRnTMbd+ljSSUoT+agxZCwjKQDGORIS4nyJJH+zJsTkQt
        t3rUfbXWJdzksY/3aCet+5AV3GUm98n46+hUWsI=
X-Google-Smtp-Source: ABdhPJzHiFP0Ro7ciuAAxunw+hAtRFedn56WEFQ9DMOwTWE+0qkM55BrkKGksZCfjhYURsPJ0ORIEZpmLCAr2IAIekM=
X-Received: by 2002:a25:380e:: with SMTP id f14mr10346733yba.185.1612426096548;
 Thu, 04 Feb 2021 00:08:16 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 4 Feb 2021 00:08:06 -0800
Message-ID: <CANT5p=qFrK960mVaHD_zESh6prnHRLU1KeudOnbS+nqSXwiBjw@mail.gmail.com>
Subject: [PATCH 2/4] cifs: Fix in error types returned for out-of-credit situations.
To:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>, tom@talpey.com,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

-- 
Regards,
Shyam
