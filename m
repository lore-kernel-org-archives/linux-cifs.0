Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40D3C433B4
	for <linux-cifs@archiver.kernel.org>; Sun,  9 May 2021 14:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A758F610CD
	for <linux-cifs@archiver.kernel.org>; Sun,  9 May 2021 14:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhEIOif (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 May 2021 10:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhEIOif (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 May 2021 10:38:35 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178B7C061573;
        Sun,  9 May 2021 07:37:31 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2so19618926lft.4;
        Sun, 09 May 2021 07:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=eR+qIrsc6puQFKGRLPujBb09dj7L2kKkd3JJNgcefe8=;
        b=KenUXs/+on5KOyFi5K8qMK6YXR7Gw0clCM18fHLJCJ+gdGsiSu3eAj82Pgbz53vaL+
         vbPaVZafPRWS1tpFDqZAS955A1ESnlCsnhY+xVeyCZqrYLse3lpluBHt+kKOgkvrhB2W
         04AjuKLy+ZfcZLalQkLz2UoHwX5iyQvBXQQfAPEbJrHy4lVlKM0wGbzcEx0j8fPNOLTJ
         lSMr+jz//sg0AiHw3ypRMqO/39QpF7b7HuQK8tEWfCD41UDu33otoblXzhAcF1jfPzVl
         CBcNdrE6GW1lxa9l6b/TjAW5oKDKdgPlOwDxb8m4/AY0QEJ/dZebeRqPRqveVQoklQM0
         +viw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=eR+qIrsc6puQFKGRLPujBb09dj7L2kKkd3JJNgcefe8=;
        b=iK+Cno3xUqchDQahaLpunB5SWb2sb0PX0ESHGClZFugsluxWd92ILKHOHumLuxdfp7
         firbBDhNRiAj/Np6zozJnfQfmsmafSAM7vCibX71EG+kHS28TeU5Fwqin8i1xv9v0wjU
         5QuLfyF9PZ1AKMxY+KQq3n1wziCeNdEirnc4zioX3SYmMu4PVCr9rP2JHLbHP97uWTIU
         6ckDqpdcOa/hXvqkliUSFoe063T+pnBVHrG4m0qqPxoU+p4BaL8XquNr27qbyCYoQZjs
         2qEyvTdfa5MujdkGHtVTLJPZ7wGTgbLqn7OtY3FGaQxZ87DySNxxzvi+CxzVl9Af0pns
         VlvQ==
X-Gm-Message-State: AOAM533xSntPO+pBGYAmgKx2dHTK/pADNOHKBItatSAimJ9yezrS3qcG
        sR88/YG5wI6kAmSBvAI0toqDINQGvW2d7mWL1YzMP6RyDb8=
X-Google-Smtp-Source: ABdhPJwnDFjkRVKvU4HqMS4qNIBRHtKdHZVzCe6yQSYEACwRfSg3FHCVeGYcoiFq/NP6Xu2N41p7fCMEy9ljlxhd2HA=
X-Received: by 2002:a05:6512:142:: with SMTP id m2mr14219059lfo.313.1620571049295;
 Sun, 09 May 2021 07:37:29 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 9 May 2021 09:37:17 -0500
Message-ID: <CAH2r5mspgQ7Xh22vuiSVbfJ00QGeQNJL_J1V4u+Mt=-U5jK+Pw@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
7c9e41e0ef7d44a0818a3beec30634f3f588a23d:

  Merge tag '5.13-rc-smb3-part2' of
git://git.samba.org/sfrench/cifs-2.6 (2021-05-05 13:37:07 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.13-rc-smb3-part3

for you to fetch changes up to c1f8a398b6d661b594556a91224b096d92293061:

  smb3: if max_channels set to more than one channel request
multichannel (2021-05-08 10:51:06 -0500)

----------------------------------------------------------------
3 small SMB3 multichannel related changesets (also for stable) from
the SMB3 test event this week.  The other fixes are still in
review/testing

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/634
----------------------------------------------------------------
Steve French (3):
      smb3: when mounting with multichannel include it in requested capabilities
      smb3: do not attempt multichannel to server which does not support it
      smb3: if max_channels set to more than one channel request multichannel

 fs/cifs/fs_context.c | 3 +++
 fs/cifs/sess.c       | 6 ++++++
 fs/cifs/smb2pdu.c    | 5 +++++


--
Thanks,

Steve
