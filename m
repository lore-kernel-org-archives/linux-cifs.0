Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5CEC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Sep 2021 05:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C95E360E76
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Sep 2021 05:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237175AbhIMFzu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Sep 2021 01:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237174AbhIMFzt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Sep 2021 01:55:49 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881B9C061574
        for <linux-cifs@vger.kernel.org>; Sun, 12 Sep 2021 22:54:34 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id g14so15124753ljk.5
        for <linux-cifs@vger.kernel.org>; Sun, 12 Sep 2021 22:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=nPaVM4nuerCyKhy7YhWO3pVPOwuYDb9l6mxQFhXd91g=;
        b=Dp//r2xz0rJtj04sC856PRw0ex0St3xXd7ChwkSdNfizZffYYtZWCZGe3+iZBktdOq
         3dSA3e2xw8lpFcQYCb7rEUU1dfgeUG5GPaYf4SI66PPBdSSeACxo0Fh66FR1c9qgJGLP
         +JZheuz0OFr9HDrLSVjGsiiskih0gtVU/X0WyVjXdhzUNKWWNoM2CdKW4NbbPl62bpKw
         Eiz4+8LThf9++60SjnVHec+N1DQltrjUosNLNaJoV83iTyj87duyapQoXs3JWHacqofF
         MYszPag65+4M8Thy5sa1+r441cZQ0IswvQjcGM6fqD4BFYvGck/w+GQRiFwSWhgo6UR8
         XXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=nPaVM4nuerCyKhy7YhWO3pVPOwuYDb9l6mxQFhXd91g=;
        b=z+kXOO+sQGaa65m+yXeZKeT4yrFQwpIDY9hb8e4jw3BY/FgD4nSuyf/BCBmYil0Oqx
         0gCgmuevAijGMpZYnSnVuc0G8JYlNSIgMlISS0HBPkS51bBbe/vt9Rp/SzZP/vlwXE0a
         yPE3OP2InlP9bBhQNo15hqetRoRHF6Zm/sNmnBAW+Wwkxd8/r+ChYqrtesu/K+4hOuse
         GiGawZsX7F4MevPl5kCEjEQBVmRl94Vzqb40qdztHgi6VsoX89fhzRUxIBAe9KHwpQXF
         vzB0XqA5c+1cZOlLCifi58ZMd2CD+PXPf6Bc7mw6KvEX42eSRDY3hiz6J2lbxwy6t7tX
         bTmg==
X-Gm-Message-State: AOAM5323SDVPGdQaOn98GxMd5eET5IFDj7Bxgn62TQyvSeYpnqbjjxl+
        JWO5gyfAi3+idHpmigeG6QMq7K30mRe05HH2G1xphDdh
X-Google-Smtp-Source: ABdhPJzxozUMAnwkTBcbAwvflauOla2gGfx1H45897b6GnCj1DRuY6U0jGujaDzmO+Ku3Tlbz3Rn3h2BG/PtU4EK36k=
X-Received: by 2002:a2e:a549:: with SMTP id e9mr9324961ljn.500.1631512472785;
 Sun, 12 Sep 2021 22:54:32 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 13 Sep 2021 00:54:22 -0500
Message-ID: <CAH2r5msfMxY5NSULfUr91j-QLJV7U0CD_BsyzvuNDRvBF7pcTA@mail.gmail.com>
Subject: newly passing xfstests
To:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Do you notice additional xfstests that we should be adding to the
ksmbd buildbot group?

e.g. I noticed xfstests generic/115 116 and 121 passing ... do you see
those passing in your test setups as well?

-- 
Thanks,

Steve
