Return-Path: <SRS0=A+kX=BE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B81C3C433E1
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Jul 2020 02:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EA18206C1
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Jul 2020 02:38:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SV77cQg9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgGYCit (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgGYCis (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Jul 2020 22:38:48 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E08EC0619D3
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2020 19:38:48 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id t15so2815923iob.3
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2020 19:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=o794EiQiHI48xFQ97S2rbpeehuhIi4LW6BdAu5VxA6g=;
        b=SV77cQg9i/bM/EOuHmOhtiqLgo/R4R5wDgtwZWcAK42wvVwd1XQkSQUz9L9TFqcsQk
         qzAXZcw8BdyF6auBZkEfD62pIyMrepMMwF/hgxNd0L1Y7B+RV9cznwnVJ0G5BcxXAwFe
         RzCCHw8UXQL7b+/MzwAPbWR4pWuEyLdE/OptPtq/kIXqpoi04b2udpVoCJFn1K4o4bI9
         DylbQ0xNXvShdWolsENSMPu+DmDv4TUkt/zFREshpyAjlLaN5yJiibbMKhmKTbCRHrRh
         kiNe1LzMCqljTSV187zFv/zR7KNQk6BW2AuU9e84958T6FD11XhM9WsV6L5BFN1b2fnX
         Ritw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=o794EiQiHI48xFQ97S2rbpeehuhIi4LW6BdAu5VxA6g=;
        b=kEbBzOiCaO/VFjVqFYs2Pi3Ax8ITPmh31ixmBZDr2aIiQ1M+ONA9j+PmZw57v79Fub
         pKs8AsQwX79AMWE69K2rZBjmqdlny5jftpaZIUU4dYJgosAYULVLA3yluZMLIrzuSIf0
         TjZvYGdgYS1WZAir7JNZbEzQ2N2y4yn2ppdPh2fKZZD7UzS7mJzlbVfVAysrdKxrNOte
         fpVzbJ41Hv/aAbDUYpASLabxY68f9dAbZw9ajSmsaYYcKfHEFQksx8cxO/6zw0gG2pY/
         97k6YErAcfhk23kpezfGeS8EQwD9gbg95tdSVjqDqB0LQSMcOTtZmgqxPRUgs4LkUMJf
         LQsg==
X-Gm-Message-State: AOAM532tVOXSRUbr6QhK31J7GqGcTOSHzaHH/xstCBWoweTmY8MojgRc
        3SWHkLNwsZBYbXeLZo8RMl2NMYsfgN/AgxpVar9ORDPeHWk=
X-Google-Smtp-Source: ABdhPJywMwwGlsObRdNowJ5NZPbzW/5GnqsS6gXViflmTSC8nn+qnv1rLZy0e3FUZsByuGRK8FGJ0byaROi/CcDelyA=
X-Received: by 2002:a05:6638:1414:: with SMTP id k20mr13897767jad.76.1595644727705;
 Fri, 24 Jul 2020 19:38:47 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 24 Jul 2020 21:38:36 -0500
Message-ID: <CAH2r5mt_fhSnNDaCdn=DKE9_TkLMZQtCZ9hTTDVQmk5RL9PTbg@mail.gmail.com>
Subject: [GIT PULL] CIFS Fix
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
ba47d845d715a010f7b51f6f89bae32845e6acb7:

  Linux 5.8-rc6 (2020-07-19 15:41:18 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.8-rc6-cifs-fix

for you to fetch changes up to 0e6705182d4e1b77248a93470d6d7b3013d59b30:

  Revert "cifs: Fix the target file was deleted when rename failed."
(2020-07-23 15:44:11 -0500)

----------------------------------------------------------------
Fix for a recently discovered regression in rename to older servers
caused by a recent patch

Build verification test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/375
----------------------------------------------------------------
Steve French (1):
      Revert "cifs: Fix the target file was deleted when rename failed."

 fs/cifs/inode.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)


-- 
Thanks,

Steve
