Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69750C4332F
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Nov 2022 05:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiKSFCj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Nov 2022 00:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiKSFCh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Nov 2022 00:02:37 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2B2BB9D7;
        Fri, 18 Nov 2022 21:02:35 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id b9so9143590ljr.5;
        Fri, 18 Nov 2022 21:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4k/covGSr73zkI5EsrvQHDY4drFpR3B+fDbIpB2isnA=;
        b=KLbl2SKLS+8CVnKIPH3BjgJgzh0Btscbfj1XTMramCSQwmU4BxujUDD34FG4rwmVAd
         IY2RDCCfhwEZPEFxsmaAI6KvLNQt8ajsCMtkZZOpOYOzT+3vX2ZS5Y23bpGrvnrPt0kP
         YvcMZjGf95XqPSaGDMZ82eDGAgtfK/csvNijs82LwsX5RyDRJ5ZaN+XHiL2O4A6TyZqM
         74KPAcD8kwAV6n+34CczzWsov0RaSDch93BYgfLBCJ1U/pnDd2QprBQj5sk28fXoX6nz
         gyuG/CdDJQH4xSrqVAh1V29Rt336EL69LjzwWuYH1c+15l9pz4XRN0gQsrEYm3i8bbp1
         3fnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4k/covGSr73zkI5EsrvQHDY4drFpR3B+fDbIpB2isnA=;
        b=3xL55Pd7fK0IEcQW5R9niiufPb/TmlHnihSofiAY63WLOE8eQ/sHkwms4rGQbsgdPo
         i3XO3ZDoeTBwuEkxzVWh7QqAYj17wcsOAxiQlJTCB3syvSHyzzmLAr2MZN10JrR66/SS
         /DgIhVtCHiqeyEYjLtEe1OzMSSwR/EQ+JB1CXt8iKYyOIhd7nk6Ww5BCVYNHax1yRSnR
         LT/Le44HV5rLeewzfo+r2TDr3vnajBiQcYVBYmZjcmaI5BUX6uPTn+vJd/fCf3r5ctUe
         sgtpnoi9S+soELEWI/0IWejr26ieVZYhmRL8IXZ3p6YWK4n+KM0CQgNTYLoprDIvlczD
         +tJw==
X-Gm-Message-State: ANoB5pm6h2b71/KIxXzxz7TO//tG+80VsHO/NxjxilVlHgP4O7sDZbXO
        Tro6ceLDjP9boZNdiI2QDjZQDrRXazizEtKuGnc5oNVM6uOUmg==
X-Google-Smtp-Source: AA0mqf4gIEemOFeslu8LSLayzhkbUiB6rQuAyIsbfMIgu7p/r8SG6fMhbIKgmjkkczvH2WZ4h8AmxGSTyPKO3jd3KXE=
X-Received: by 2002:a05:651c:894:b0:277:3e1:297c with SMTP id
 d20-20020a05651c089400b0027703e1297cmr58848ljq.109.1668834153851; Fri, 18 Nov
 2022 21:02:33 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 18 Nov 2022 23:02:22 -0600
Message-ID: <CAH2r5mvp4qcfELt+W9khm=LH3TjyPDY7fhhMSA06cJdQfEQ23Q@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
f0c4d9fc9cc9462659728d168387191387e903cc:

  Linux 6.1-rc4 (2022-11-06 15:07:11 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.1-rc5-smb3-fixes

for you to fetch changes up to a51e5d293dd1c2e7bf6f7be788466cd9b5d280fb:

  cifs: add check for returning value of SMB2_set_info_init
(2022-11-16 12:24:26 -0600)

----------------------------------------------------------------
4 small cifs/smb3 client fixes:
- two missing and one incorrect return value checks
- fix leak on tlink mount failure

----------------------------------------------------------------
Anastasia Belova (2):
      cifs: add check for returning value of SMB2_close_init
      cifs: add check for returning value of SMB2_set_info_init

Zhang Xiaoxu (2):
      cifs: Fix connections leak when tlink setup failed
      cifs: Fix wrong return value checking when GETFLAGS

 fs/cifs/connect.c | 14 +++++++++++---
 fs/cifs/ioctl.c   |  4 ++--
 fs/cifs/smb2ops.c |  4 ++++
 3 files changed, 17 insertions(+), 5 deletions(-)

-- 
Thanks,

Steve
