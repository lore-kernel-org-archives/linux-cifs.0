Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B402C433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 30 Jan 2022 20:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356252AbiA3U6e (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 Jan 2022 15:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240703AbiA3U6d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 30 Jan 2022 15:58:33 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DC2C061714
        for <linux-cifs@vger.kernel.org>; Sun, 30 Jan 2022 12:58:33 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id n8so22817862lfq.4
        for <linux-cifs@vger.kernel.org>; Sun, 30 Jan 2022 12:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=pErbJCZ6WAjLj9/cRKvZdCFnuMaW66cGhQZaxSq8z8g=;
        b=IXzIB9oEAc7j0fPA8LKIrgMGAOPE8efp7v1f7uANKFjMJawXjJ4OnfC8D0NMQzFqZb
         9DaVFIk7xtrD2mdGQWaQR9Yrm0hrQS3aZFhD8WkubbOjIwOzmQrMUEbgPlEOroJJnLCz
         zyrmBiCwKTVn+ZSUt/m/cMdg4LTXy16XN1UpNsF4h4IQc9wFvVMIREhs8IHWWmM04AEX
         u7Y+IuSI1ydxVnEpvICY7wLfyqVSbtOi0GN/wQr+pTO+6QgAeJBwr6kkwa7Yi+b3DiL/
         uIrb3jUaJgsLgS4peAJR45cBPmTLW1YYAigbmFhK36kTzRDnRv4I9eac36HbbsWVfGD1
         6EFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=pErbJCZ6WAjLj9/cRKvZdCFnuMaW66cGhQZaxSq8z8g=;
        b=L1+25z9QvP6YIKqH6LKSkqjQGbxw3gRU+cbR8+Xf+J9dFmwrKuSZTYkXW6dwMH630R
         7mIUFogaiC/3NIs89ko81XWfhbx8SgOMiZ4gyE9JWDzkDi8EAL0mq9hqXPlk8tHD8eFH
         oHRwnd2L33pOWendY66T1hRTuQxVoEBp7l4cesARPTP0loWZCe8GIY4zxBiwOEeUeMCx
         7wVIOMTNos1f4+s0UhsSmcrEjgJ3Rbr5ERcBoqvROfNN6yI45JhigJ/OPfvozGac3TdK
         S5fPSEVooTYqDWCBKU1BO09+jdoDS+m4qP13Qpvmg0F10wVAHmw2vltXr+iCgkrdZaNp
         pVQQ==
X-Gm-Message-State: AOAM532xayks9tfCRlh54BeWCPaFgDXbm1K4d5KVbM9dkCPt5jCsNgKq
        hCULG7tVI7Gpoe2aOKZyvYBH/7vqc534JBc2pHUCDimWDpg=
X-Google-Smtp-Source: ABdhPJzI14Q+ZK4gqomPNAcbQ6U8b1tZO6JhzxoS7TUr7Tcjls27osVt+Prgo8i+UHzdoo1ntNLurxQlBtB41OGykLs=
X-Received: by 2002:ac2:456c:: with SMTP id k12mr13959667lfm.234.1643576311509;
 Sun, 30 Jan 2022 12:58:31 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 30 Jan 2022 14:58:20 -0600
Message-ID: <CAH2r5mv8pEt7Msx0=2BPFciu8gPGLyMLPvOAzyiKg7=W=6ehOw@mail.gmail.com>
Subject: additional regression tests added for cifs.ko (to the buildbot)
To:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added 10 additional regression tests to the buildbot (mostly to Samba
exporting over btrfs)

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/876

Will also need updates to the corresponding xfstest pages on
wiki.samba.org later this week

-- 
Thanks,

Steve
