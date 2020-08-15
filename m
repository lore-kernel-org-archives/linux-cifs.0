Return-Path: <SRS0=YrR0=BZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC53DC433E3
	for <linux-cifs@archiver.kernel.org>; Sat, 15 Aug 2020 21:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 830392053B
	for <linux-cifs@archiver.kernel.org>; Sat, 15 Aug 2020 21:54:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fb8P7apw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgHOVyx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 15 Aug 2020 17:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729091AbgHOVw3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 15 Aug 2020 17:52:29 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599A4C061232;
        Fri, 14 Aug 2020 22:32:58 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id q75so12887456iod.1;
        Fri, 14 Aug 2020 22:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+uvK5xyS2jsYMowW54FGXjWCo1ZPVzf5OQMcA+nZWjU=;
        b=Fb8P7apwQoGsHPtaXb5dSo5RR/ByS4YqN9w1L9SLoNREnc5tUpqgRtPoF5JP1XCHKz
         ZqS8JALkerVr1yokT29OvYe3psLKWNDDd8XlUHAgx933NWvAZZfA/iv3wLtwZ1i9UbZH
         k4o1yUSqjAKxVSB4GliQhsirO6oOg1yfPH/cQpnvh7hRPCpAQFQ/NvzOb8hBS05AKmPI
         YReGyPtKaxClLLwSTWzaiCJKFCvBIzT3dHL47DEcimgiEsbexRzYPI1tHdVU5LBif6pu
         7cE/ohLMNehvoUsRmq5oTSK1XwzbGBxcRkXuZ07GbSOUNx4pnm8jKy5NFK24RiEXXXvn
         49Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+uvK5xyS2jsYMowW54FGXjWCo1ZPVzf5OQMcA+nZWjU=;
        b=bpid0bCuOHEOT7JeUWo7565I3ocLVxZyhYT8RxS0ehCW/uvgQb2NMM9Nwm9ttYwVeL
         41DJqN1+W4gKbKzJ54lzgtQmpCUIjXikFC5rUlxxzmXpbgC8uhDBvgzOAiEgBK3Wft1O
         ZuJaDUDKN7ZTFAkabrTDxkewpM/Hb4rfhQLKV1Pa1BSgkVs3V1QfzW3MoXc/pwbGK3o1
         DWGVpHx1h2EgWtprVKxWeEADDXV/izGit+ChnAxNbRdRBszXJm9SSXI3wQfXPcWfrOFs
         OBDu4yjTUt1T+J9GWUSYkP1g4MANrZy46zm5QWMo7ZmpyKCpPDWiEkLuG2lGzTs3Wz2d
         diEg==
X-Gm-Message-State: AOAM533iFFTe1YbOoDzkxM1szX7zf1QRiNd5csGr9SJqijRn+lXCUTlY
        KBfS1Q5qm3xvF+Wc7v0gvt0d/cU9CM9j5geYJ6c0ZCYi/HJl6g==
X-Google-Smtp-Source: ABdhPJzCQ5WCbCigax+HkCKLc4Nw6kcGYCSH3+w5/uVgttRscO15FaumbLuaks6h1UgQCOhYv9L1HF/VSxp5IBihRFU=
X-Received: by 2002:a05:6602:2801:: with SMTP id d1mr4740187ioe.201.1597469577329;
 Fri, 14 Aug 2020 22:32:57 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 15 Aug 2020 00:32:46 -0500
Message-ID: <CAH2r5mvJ=EZ2mC6LTnTmML5tCKpcKCOM7+nbbFSzpATBWh9Y_A@mail.gmail.com>
Subject: [GIT PULL] SMB3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
327a8d76b1ac2037f87bf041f3bc076407284ffc:

  Merge tag '5.9-rc-smb3-fixes-part1' of
git://git.samba.org/sfrench/cifs-2.6 (2020-08-06 19:21:04 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.9-rc-smb3-fixes-part2

for you to fetch changes up to c8c412f976124d85b8ded85c6ac3f760c12b63a3:

  SMB3: Fix mkdir when idsfromsid configured on mount (2020-08-13
19:41:01 -0500)

----------------------------------------------------------------
3 small cifs/smb3 fixes, one for stable fixing a mkdir path when using
idsfromsid mount option

The update for cifs.ko to use the new mount API isn't complete so
isn't included in this set.

Build verification test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/381
----------------------------------------------------------------
Dan Carpenter (1):
      cifs: Fix an error pointer dereference in cifs_mount()

Miaohe Lin (1):
      cifs: Convert to use the fallthrough macro

Steve French (1):
      SMB3: Fix mkdir when idsfromsid configured on mount

 fs/cifs/connect.c   | 1 +
 fs/cifs/smb2inode.c | 1 +
 fs/cifs/smb2pdu.c   | 4 ++--
 3 files changed, 4 insertions(+), 2 deletions(-)

-- 
Thanks,

Steve
