Return-Path: <SRS0=T6pO=QX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645E7C43381
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Feb 2019 19:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D80E222E0
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Feb 2019 19:37:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="USgjvbdz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732787AbfBPThg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 Feb 2019 14:37:36 -0500
Received: from mail-pl1-f178.google.com ([209.85.214.178]:33167 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfBPThg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 16 Feb 2019 14:37:36 -0500
Received: by mail-pl1-f178.google.com with SMTP id y10so6677860plp.0;
        Sat, 16 Feb 2019 11:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ey6LnuSjK3ZKUEle/cCFtxpWJrpSR2D8bb/S4bTusoI=;
        b=USgjvbdzc0tz3Os3NQomSpXMUK8q/ZhYIxAHfREHQhUcbS/CpJE6fdusRgA7Xr0YyJ
         QNpnJ1tch3wtYHfA+kTzIq9jcSeMKDUbOquefIF0CbLjTijF2GGR4Jnt+a+A4pF9gIOK
         r6H8kaFqtNMOGrskyAIpHKDR3uPbD/QZ9AHYrFxT/eSaTphOK8WIOWCLVwGrfRI1UEpG
         6UmXg9HWQXEoutD5lHGuBLsPAUIVmWRYvAjEsMc+DbK6QAbpjfoQAioE44sFyMXQ65SO
         WySSuyTpFFbPLqdIh9l/QKqiKvUhbQIFs4xZJfOVVY2gcEfBD5MrQkD44XqGwHThnjpk
         rKVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ey6LnuSjK3ZKUEle/cCFtxpWJrpSR2D8bb/S4bTusoI=;
        b=DNfYSFc8AsQwP0nBqB/8gXY0lfTB23nGLyGWGZAI/TLJ/DGbJtNlYr7x26Pu8hRPdS
         ewcZ4N1qNMAhKqtIg2l49iuSiGCSwhyjRAE3BSkbS/ABAOybqeMU8pQg29Vk2wKzJM2h
         UXYqzPd8jYGrqpZDG2n3BM4E0DZ5uRGWpMV1QNRq8RW4+ZDIl4FqRynL0aI8EJ/pJ3nD
         S1J5+xMREL/+RUIjk4tn3tja7zGKltH5Sd7eOS90f0PwEUFwNLYKb7p+nqqMUnC+p0R+
         rwu1d79FRQAbtZxMfFHTie78uQQR5md8OGQecBSpfYNCFSTVbq/E3NIwrRMvzicq7Itn
         /5zA==
X-Gm-Message-State: AHQUAuafh6ZGMkaYLPRDqME4GSmFPyz4F/4EEPp66dUtkYPASRKcFm15
        Y9Hm3tuB5ZJOKi9HNX+lmnan+WEpx5QkG2swxfgDHDTp
X-Google-Smtp-Source: AHgI3IbbPIWrXdx1DdmLTGuDAN9znjhWRDIss2qVnKOVmOn0ItGXruCzyMM7pNQyNHffLjRlYi+Z8V9z6GI21UUn+Mw=
X-Received: by 2002:a17:902:822:: with SMTP id 31mr14997649plk.290.1550345855371;
 Sat, 16 Feb 2019 11:37:35 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 16 Feb 2019 13:37:24 -0600
Message-ID: <CAH2r5mvZYgEsvhRqpYOnmdCbuXwkW2-wEmqAJR1yWGA2=H7wfg@mail.gmail.com>
Subject: xfstest status update - possible regression outside cifs in rc6
To:     CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Have been looking at the cifs buildbot's automated xfstest results
(azure test bucket in this case), and noticed possible regression
outside cifs with  5.0-rc6.  Various xfstests started to fail on rc6
(didn't fail on rc5 or earlier, and no cifs changes involved).
Presumably someone else caught more of these these in testing another
fs since I noticed various mm/fs patches were reverted a few days ago
and these did fix most of the xfstest regressions with one exception -
I still see xfstest 422 fail on rc6 as of a couple of days ago
(although backing up to rc5 it didn't fail, and it wasn't obvious to
me at first which fs or mm change regressed this, and there were no
cifs changes).

Will see if I can narrow it down, or repro it in quicker environment.

-- 
Thanks,

Steve
