Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61FFC433ED
	for <linux-cifs@archiver.kernel.org>; Mon, 10 May 2021 01:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81513613B6
	for <linux-cifs@archiver.kernel.org>; Mon, 10 May 2021 01:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhEJBxU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 May 2021 21:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhEJBxT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 May 2021 21:53:19 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE6CC061573
        for <linux-cifs@vger.kernel.org>; Sun,  9 May 2021 18:52:15 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id f12so6252506ljp.2
        for <linux-cifs@vger.kernel.org>; Sun, 09 May 2021 18:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=9aUe7NOn+caUBMLc8vLfdWJteR614E3Q5fxCfIWMMsw=;
        b=ANTp81Uftnq4z4tj4sdPItti+PzWq4aAvl+OKgV3UkC/lH0CZHINrHV6jM4zpcdc+n
         SETzftf8o/3A7I1RbNmFToE9J2TbXSv6qrq7RbiQf7jgtTDTby89EdvEfx7N3QCQuy40
         nbuPVgV8M3V9J1u3bYS52+Z9xxTS9loIugz8Nu1nWuiwV1k4rFIS5GhJxsYBloom+zZ5
         XDpyjFFeJtqWEML+YSSVqDatZEGDxCGB8yXMyjNYljgM065uK+LIQXJZFQtRO73GeylO
         JugCk61/kdJRPiPf2vRwtBTL8uSc2ZalfIDs6y+CTenb8ur57yzdN7GWjxtQX7Xhvrds
         PGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9aUe7NOn+caUBMLc8vLfdWJteR614E3Q5fxCfIWMMsw=;
        b=htjVxmgr1EapR57jP9wCSKKb5OQdIw0iCcG84qiICiNOWsKzxBDYCkxNlykIt+/dWZ
         Rvd07AAy6PAACRi2q77lG+AipVJstJ+CioXTU+0RsSJ0H7OwaVQnxPzgvJ+3Zli+XWMU
         RsnlCs/LikiDmJ/aC4KBGZzzvTDUKSDWOSP2bWYo8pYpXsXomF7kzlmokZzbmKytLxYz
         70I8aPdvLiLi+J0o4FEZWlbLhrE2xVY9LSt1P25hv5MCWkl53QmA7sXybzmOGjy2WIlY
         NowRbV4T2Gj6p5MNVKwvkqw2qyrIVos2hbqu/sQlCY+qK02LS+vLYXJuRdRF91KmoJSZ
         CPDA==
X-Gm-Message-State: AOAM533sRoXJxpBviugb3x2BJOGg5Kaxrvxc6/uI5HwD/fShIZQ6qu38
        r6r6VqMKYXhA7aR6M0X8T/T22xuj+wO7MkKg/pENOs5Y5n4=
X-Google-Smtp-Source: ABdhPJzE6bSwVWYaay5Z9IRq/QtujLlriabA4aEBSvTiZl+usFHdTbhw1Md0H9VNxIRRehcDvVXfvBr69ihBFbpGzQ8=
X-Received: by 2002:a2e:b8d2:: with SMTP id s18mr18366291ljp.148.1620611533090;
 Sun, 09 May 2021 18:52:13 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 9 May 2021 20:52:02 -0500
Message-ID: <CAH2r5mvEySqFgn66+OON+vV2r3RrBNSfvmMeeMm-u3vPPikABA@mail.gmail.com>
Subject: rapages mount option and xfstests
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Interesting to see tests where setting rapages (4 x rsize seems fine)
seems to help with xfstests - e.g. improves the run of test
generic/310 a lot from 197 seconds down to 153 (with multichannel, 4
channels to Azure) - but most xfstests don't do a lot of sequential
reads from the page cache apparently.

-- 
Thanks,

Steve
