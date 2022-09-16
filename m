Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4320BC54EE9
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Sep 2022 05:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiIPFZP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Sep 2022 01:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiIPFZO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Sep 2022 01:25:14 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0928276F
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 22:25:13 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id o123so21568884vsc.3
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 22:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=Sa3Z0fZXwN05d22orNyRUP3vLx9yrPD+vOj+S6s/4pg=;
        b=F2CbE57mXvwL7gLuRHrvyf9m7RIJGvDAWIyJX1wcrXlnhwvFhMVvQo906wnhP2YAC0
         wqffEIAofbriDgxdgTlqyD+kGrbjnid+Rt+RC8I5Cnwat+KVdNa4Drm4u303wYlGM/Bu
         m6rY0W9wNC4TPLhfIK40u8+FxYkcNW41o1CCI6XAzQF3ANGzfIWXiOT0bOZH3Yj6tq9I
         bkPoEETJD0B1ksn1RdRFvu3CFq/vmTTX2tqepdHvwnzGJRguJDZiseuWPy56VaF+MsbT
         M1EzEGaALnx8OwEXgbXUouqdG8DL54cIKwwWHsUy7bFa84neBMatGpYUtmKZEML3XPQ0
         4Xwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=Sa3Z0fZXwN05d22orNyRUP3vLx9yrPD+vOj+S6s/4pg=;
        b=mHGe4SNkE3Z8ObKNqOk5MNLiJHPfEX9ukU+99dd8199TVcY6zeJkqbLm1Ujs+k1iBM
         jDDzBtWx4uYkNgzhnWeQDzmlTRSYUFCIfM9prDn/gu7N+PfJGvsL7igXU20YB2AE3Tjs
         nAUSAuFCBoVw86pok/D0URfIBvPrPrbCgGGamueHdZElIIB2EiXYQB6jXlDQkSWka9zH
         /3rvetaU8qvdaJny9sC4794dW1PIQreSy6AQUVxmABWwRmXITDqY1xzRCVrWZ3Mtne3T
         klXLoVuVlEu9NOzni5LEHy5vYbFU3WiSumsnLE63o4rYqvqZpXrtRQFzVE20/1vXyhK4
         OpzQ==
X-Gm-Message-State: ACrzQf3s4vg1DZKfHiLIJWosa9cuoIacNbOfkLEC5xZQ/coXxwDetAUL
        m6zNDI1DQDo8ZgtXbKyNwErlfD7+Abxms/fK38g+e1hYZ3o=
X-Google-Smtp-Source: AMsMyM6ssurN6Dh9Naa7RrLFpBaWyD0UBOSi9FEtNKUBnXsfnoawPXZmvmBbtMmrXchLxhCXJmnsTOsEi/hEzkOJuhQ=
X-Received: by 2002:a67:ad15:0:b0:398:6aef:316b with SMTP id
 t21-20020a67ad15000000b003986aef316bmr1672796vsl.17.1663305912784; Thu, 15
 Sep 2022 22:25:12 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 16 Sep 2022 00:25:02 -0500
Message-ID: <CAH2r5ms3vpm_h3NgzNkoOUCJM+jJYzifMCyZeCyBAtSbDLfXRA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
80e78fcce86de0288793a0ef0f6acf37656ee4cf:

  Linux 6.0-rc5 (2022-09-11 16:22:01 -0400)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.0-rc5-smb3-fixes

for you to fetch changes up to 8af8aed97bebe8b26a340da5236e277c3d84a8ec:

  cifs: update internal module number (2022-09-14 04:00:06 -0500)

----------------------------------------------------------------
Four fixes for stable
- important fix to revalidate mapping when doing direct writes
- missing spinlock
- two fixes to socket handling
- and trivial change to update internal version number for cifs.ko

----------------------------------------------------------------
Paulo Alcantara (1):
      cifs: add missing spinlock around tcon refcount

Ronnie Sahlberg (1):
      cifs: revalidate mapping when doing direct writes

Stefan Metzmacher (2):
      cifs: don't send down the destination address to sendmsg for a SOCK_STREAM
      cifs: always initialize struct msghdr smb_msg completely

Steve French (1):
      cifs: update internal module number

 fs/cifs/cifsfs.h    |  4 ++--
 fs/cifs/connect.c   | 14 ++++++--------
 fs/cifs/file.c      |  3 +++
 fs/cifs/transport.c |  6 +-----
 4 files changed, 12 insertions(+), 15 deletions(-)


-- 
Thanks,

Steve
