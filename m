Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06C1C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Jan 2021 05:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70FD9239FC
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Jan 2021 05:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbhAOF5Z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Jan 2021 00:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbhAOF5Y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Jan 2021 00:57:24 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2715DC061575
        for <linux-cifs@vger.kernel.org>; Thu, 14 Jan 2021 21:56:44 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id f11so9123004ljm.8
        for <linux-cifs@vger.kernel.org>; Thu, 14 Jan 2021 21:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+3//egwjfD1k1IzQJX81UNFmtpBO/6XaKmT/MXPv07A=;
        b=ZRzUh+jSsOgaNDYq0UPfNZD9SEFGfLOoqwhhFHBOd47QoUTx33UHENHqQQmOF8NwlF
         I8L5wVOrVJTvzPSDghgRxIaJPCnlYXAg+wSLQim+cUks1kpGaF88BNO1ZcYHB0QIcZBJ
         3KWuNi2F8mBdnuB5I9dN/llP0YW3+7iFdrn95IzCa9hbZDUa5qnYA3gCccw1ls3fJTbT
         k9MB0LTftjk2TF6OhxEezro/YzzS5SqzKkVNrQGroS67xxIq5LbsEFGvY7NHkNdSv4is
         Cz3IyrlYVEvLTz5b2pDW1QpcqoQ+F2oXHQRDrpGBo7yKQ/mpv+Gr9plPqyDsiVS3ePW1
         1raQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+3//egwjfD1k1IzQJX81UNFmtpBO/6XaKmT/MXPv07A=;
        b=QvGyj5N6JQCyWhj073r3aPsSJUIXNl62M9+PcISwuyVJSU5iYLetIsGbbes3MwgKqO
         RzmEmVnKvVp202CQUu10BU9M3wG+BdC2CeW2nfWTIaX/RTE65az2bAYYsxiXlxtmvl/J
         ATGUBnkxrTew1Oi70CS2FdktAj/996ZX5E80QBnIL6WK2xinlskwjv/qFKlcAARtCQnk
         ZT9TrpbhQ9PrRK4F4sAiBe4IJKhHmuL9VWuQKAt2v3j2KArzOckSunD9DeZCh6QrU69q
         3eFDlhFNwPwZ+sdEYMMbes6bPykAr+Ty3lcFwg2DDaEVAJlveK37oTym/+Mxj69DP8Bk
         eL3w==
X-Gm-Message-State: AOAM530ARBAwoWvdWTYlzrMQCj7XBp6FGfUb/LcCbva+19SUEENn2jIU
        E7cEP+b0ZPGLur0zGMahgltHXOEyFgzwfWtrckFntbVOLMtmyA==
X-Google-Smtp-Source: ABdhPJznciyWcy680YrZhHzKNb70jchNLqiyiOWBF0Nj/nSB/mbfQJUXitJJEbl8nxUO24RT6qcIsvmBwspj2z8wFJU=
X-Received: by 2002:a2e:8eda:: with SMTP id e26mr4673169ljl.272.1610690202424;
 Thu, 14 Jan 2021 21:56:42 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 14 Jan 2021 23:56:31 -0600
Message-ID: <CAH2r5mv163xBnRSDV24YJwtxtJJn2zjC4TY1-RS8=G7dLTskFw@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
7c53f6b671f4aba70ff15e1b05148b10d58c2837:

  Linux 5.11-rc3 (2021-01-10 14:34:50 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.11-rc3-smb3

for you to fetch changes up to e54fd0716c3db20c0cba73fee2c3a4274b08c24e:

  cifs: style: replace one-element array with flexible-array
(2021-01-13 13:36:45 -0600)

----------------------------------------------------------------
2 small cifs fixes for stable (including an important handle leak fix)
and 3 small cleanup patches

Test results: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/476
----------------------------------------------------------------
Menglong Dong (1):
      fs: cifs: remove unneeded variable in smb3_fs_context_dup

Paulo Alcantara (1):
      cifs: fix interrupted close commands

Tom Rix (1):
      cifs: check pointer before freeing

YANG LI (2):
      cifs: connect: style: Simplify bool comparison
      cifs: style: replace one-element array with flexible-array

 fs/cifs/connect.c    | 2 +-
 fs/cifs/dfs_cache.c  | 3 ++-
 fs/cifs/fs_context.c | 4 +---
 fs/cifs/smb2pdu.c    | 2 +-
 fs/cifs/smb2pdu.h    | 2 +-
 5 files changed, 6 insertions(+), 7 deletions(-)

-- 
Thanks,

Steve
