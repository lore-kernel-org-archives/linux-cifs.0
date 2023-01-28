Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A76C38142
	for <linux-cifs@archiver.kernel.org>; Sat, 28 Jan 2023 00:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjA1Apn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Jan 2023 19:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjA1Apn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 Jan 2023 19:45:43 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D457BBE4
        for <linux-cifs@vger.kernel.org>; Fri, 27 Jan 2023 16:45:41 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id u12so203052lfq.0
        for <linux-cifs@vger.kernel.org>; Fri, 27 Jan 2023 16:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r37dXDZKaRF3FARrN+bHODY+DziKzTV7hLGuPUTnt0g=;
        b=oGErNVDIAWaCRQXNn3n8OthLIaOoHUouFEJc1zg32DAME1NaWdYCo0Pj/Enog7nOlH
         FqF1rZXjE1ArCZGroyEUFNOSmvZSF8r3viY7Fcm5oiXrmiS43/9LEcGrrScA/hc0+3oq
         Rs0kT1QHDC3+Mglduu90I+2tDJDY8O+6h0E6FUFZUQl5XMK+XBNBNyfsOxhzBgwtqaYT
         6Q72zNSveRw9vRvdMZimyouKFC9vB77UE16NOXBpQWUpWt2mJv9L3ph0m9TKGkO0cNb2
         lSHmAzrAnQg4ZKy0euE6kRZO95Y2K3aU+2oaF2KOYeUeD2lQjcDOCMuwPmRfMfC6kweU
         GMbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r37dXDZKaRF3FARrN+bHODY+DziKzTV7hLGuPUTnt0g=;
        b=l8Mc6HYcpP0lxgEKtgWJGYCSzaSQ0enmxLDMhav9+ZgcOQ4xm8eFy+EIZao/6OdRbn
         UL8UAzaqTJwkaW8/kEaS27+O7Ea0xR1oV4TJ1Xt5nAHLB11JuG/YAFI+0rnqrv/WsZlm
         rSBukWRs25WfOuvCiALFbo5OAgeqR0joNya3mhCfwR/rchvjruZL1KBbjQ9NdXElqmi1
         58jhiR8cfgVRFUPd/agWZOqNkBiFS+8pk0Hiauf/dQdUIicx+hJjxP9mMOSYlec5Wrh3
         8QWst+xD5mWIcDBAHCKxphj4fwpc05COBLEGb6UKcy8X/4jOsuPlzonjCg8CXvRpRJiB
         nu9A==
X-Gm-Message-State: AFqh2kpIv1suA8tys/Rx+cIAmiUHFs+PqSq5FHWNsbgxpZWIbgYirRb5
        9Jhx7M83EzG61D9ghdgsadhcZbDnU3Nl++7Q2INmcPbrevA=
X-Google-Smtp-Source: AMrXdXvBF8bbSbnGJF6zlV1jfmrAOsMu+Qaos9zVseyr0xKmLh8vb1ez0rJwSzbl8Y8Lkgh5zlwg/UtuxSD65ZXx/Ls=
X-Received: by 2002:a05:6512:2804:b0:4d5:869f:c5d0 with SMTP id
 cf4-20020a056512280400b004d5869fc5d0mr4724073lfb.115.1674866739887; Fri, 27
 Jan 2023 16:45:39 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 27 Jan 2023 18:45:28 -0600
Message-ID: <CAH2r5mvPn-B8Lqy4Dh3kYRpMtEXCpUrChpE65ddzDy-W1oZ=4Q@mail.gmail.com>
Subject: [GIT PULL] smb3 client fix
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
2241ab53cbb5cdb08a6b2d4688feb13971058f65:

  Linux 6.2-rc5 (2023-01-21 16:27:01 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.2-rc5-smb3-client-fixes

for you to fetch changes up to b7ab9161cf5ddc42a288edf9d1a61f3bdffe17c7:

  cifs: Fix oops due to uncleared server->smbd_conn in reconnect
(2023-01-25 09:57:48 -0600)

----------------------------------------------------------------
Fix for reconnect oops in smbdirect (RDMA), also is marked for stable

----------------------------------------------------------------
David Howells (1):
      cifs: Fix oops due to uncleared server->smbd_conn in reconnect

 fs/cifs/smbdirect.c | 1 +
 1 file changed, 1 insertion(+)


-- 
Thanks,

Steve
