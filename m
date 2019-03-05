Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702F8C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 23:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E36D20661
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 23:52:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AT0jTYOv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbfCEXwE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 18:52:04 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39225 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfCEXwE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 18:52:04 -0500
Received: by mail-pf1-f194.google.com with SMTP id i20so6935749pfo.6
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2019 15:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=F55QE73tzi+cg+Rt5JLaKYwhXFYL09nXNAf8Kcu9PdM=;
        b=AT0jTYOv/GHfB6bYP3k88sb3WTDxWhz+y+8AdTZE4S9JQDTgqL1SIjrsnyeYfsdbw+
         RRazSjQRPH/JGwRSw+NVsuYhhi4+n9pUI1o35KBFs6TCBLPnGx+wFvyUWOMf8Vo4fUBY
         zdyoqlWDj1zidOxL/vvmZE7Sh26Hu4h8l2btQOe7gV96FrTJWPAdJPV3Ljins3MLffle
         KI/2newFnIHv9yVs8OZKnRqZwjVhCVuOhtxXIYWZfTfxgBHUgC2W9rsgV7jAWuT6P+XO
         B884DlgCFjK8yo4/80lh3znqMjz3BjTKSw9Z2WvoxznrvNdxFeqla/0ytZ/fIiee2YOY
         gVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=F55QE73tzi+cg+Rt5JLaKYwhXFYL09nXNAf8Kcu9PdM=;
        b=YoyFhWylKOZzoEfv46dIS3IbzqtnEm1w7jqTk7bcSZtiU81zfn0u2NxetBfnn8+z3O
         aDL+Gds9xS9k1Th5dy1j7rY8ARDO2p7V+7LXBG9oBRieLdHWrhSf64J5kcAXs1aD/P87
         I7ELxpE65UaBGKTPE0+lvlaK5v0rLFLoNG18bxVyQFuZC0B1QUO4fGzfAIUzbHJK4pQl
         yEyF6lYCbYnMQT/p9hU+WBBThNp6nELO0Idn9TrRRLn5UdjrRbAzthv9w6BZiaAySTO5
         8RUWBdxa6UIA6PW7rH60bEP+VMpbQd2xHMI41rH19jtbjPXFMF5oDN5CaRJLgVo065Sc
         A6YA==
X-Gm-Message-State: APjAAAWaPmMy95hd2woDntl1whUammM2+hhe4qFs2P1Lo7jYI4Ru/vKP
        Nsvi5vgvQV/8COPvp2zbslIUnls=
X-Google-Smtp-Source: APXvYqzd+/3c5r+D3AYpb57yWYlHXr7Xei0vZiecL2f4lDwrHR23gUq2KciR/Fz8xHHCEAjKJeXAmg==
X-Received: by 2002:a17:902:4203:: with SMTP id g3mr3788888pld.99.1551829923585;
        Tue, 05 Mar 2019 15:52:03 -0800 (PST)
Received: from ubuntu-vm.corp.microsoft.com ([2001:4898:80e8:1:a18d:4e9f:6b7c:507d])
        by smtp.gmail.com with ESMTPSA id l64sm50342pga.87.2019.03.05.15.52.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 05 Mar 2019 15:52:02 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Subject: [PATCH 0/3] more reconnect fixes
Date:   Tue,  5 Mar 2019 15:51:53 -0800
Message-Id: <1551829917-48772-1-git-send-email-pshilov@microsoft.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The patchset has 3 patches that fix some problems related to network reconnects.

The first patch fixes out-of-order requests sent over newly established TCP connections, in particular it prevents sending anything rather than SMB2_NEGOTIATE.

The second patch changes the return code from -ENOTSOCK to -EAGAIN for TCP connections that are in the middle of reconnect.

The third patch is a new version of the patch posted previously. Since we are doing socket sends in the same thread with a syscall we might experience interrupts due to signals. If such signals come while we are in the middle of sending SMB packet to the server, we may end up with partial sends and unnecessary network reconnects thus overloading the server. The patch masks off signals during the whole packet send thus avoiding interrupts and reconnects.

Pavel Shilovsky (3):
  CIFS: Only send SMB2_NEGOTIATE command on new TCP connections
  CIFS: Return -EAGAIN instead of -ENOTSOCK
  CIFS: Mask off signals when sending SMB packets

 fs/cifs/smb2transport.c |  8 ++++++++
 fs/cifs/transport.c     | 44 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 48 insertions(+), 4 deletions(-)

-- 
2.7.4

