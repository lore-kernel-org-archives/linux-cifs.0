Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0D2C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Sep 2021 21:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A822F611BF
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Sep 2021 21:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhIJVDK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Sep 2021 17:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbhIJVDK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Sep 2021 17:03:10 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7929DC061574
        for <linux-cifs@vger.kernel.org>; Fri, 10 Sep 2021 14:01:58 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id s3so5220955ljp.11
        for <linux-cifs@vger.kernel.org>; Fri, 10 Sep 2021 14:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=V+m98sTOYnGHlotAZ57AQBtoDpHKNOS02cYGwx2u4pY=;
        b=c8MtnxpFsvtRYG3Cq1Ph0LJJQ2mIny/oFtEOZz7Yde1s/1FbU7wTNEiJkvyLM2xq3T
         x+z1BhjfmsSkqWZ4YzK1XVo7M7IdHE9zJxPYyFZsi9pp0yzrh+Anr8T44SNpRWyj7ijM
         WlOIe0HpFOcODVIOSrh4xlntG4122ACugOGFysdoQFwGXa1dcdIOfsta+vUGaac8FTKY
         qWpPDs4SMfCK1kuoT33LLY0EOxmdZdCyoLJ1BrOA/Ja2/5Il+AP9L9Zw2qtD66b3wtCF
         rXxiCuiSmDZBM4/kP8k0MIRdtkeesHu3QmLLIlkBwuPWeshHwFU96hSpuzTFJ0YXEf8C
         VLDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=V+m98sTOYnGHlotAZ57AQBtoDpHKNOS02cYGwx2u4pY=;
        b=aUEWOzQ4hnyqWO9XxblAqjciIANBnLiw9zMXpBh9KKHtgMTdrfHSJIHk9p5176shnf
         kFAqjK/nYwydKK1viCcFQAo4vfUlXMfyMdDaXsQR+DJvoHaJD/aKNAirjQm67Tusy0g/
         zK+21NpewwzsCD3KQOoFKAT+M8pt7phjnS9zWWoKTdbd7R/7oKiD+WA/DcYFVZVS46Eo
         f4LkZx4IepdVwr4/YQr3YwxY9tIvv+qL8z4t3FuSqblok4KzdDDyjwNxjLiETigWbBi+
         CUWMHDZlXtcAEGgsnq2vk87CBhHaLTExnoOpUVznO9YE3uGYRcbFSCcs86xP0xUYuv6K
         +biA==
X-Gm-Message-State: AOAM533z5ycX5vTED/UrH0BEkSwYWg+yPvY51AfVwZz/uVS4FoGHf/QQ
        irUWUGPuDZ6s/glzbQF+6fjs8gugWOMNDVjMayJeO4pS5IE=
X-Google-Smtp-Source: ABdhPJxvX+0OzQ/J5z6taurHNWBu7cxyn8ozskufOmUHY6VwtjE3Z0WtsWaPgUCscxg6+10XG//lcCf8xRglmuzvXdc=
X-Received: by 2002:a2e:7c10:: with SMTP id x16mr5566594ljc.398.1631307716746;
 Fri, 10 Sep 2021 14:01:56 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 10 Sep 2021 17:01:46 -0400
Message-ID: <CAH2r5ms=JWqG4FXoDE8SKtYxTPbMfvfSVUVGmNskshwpxOHDvw@mail.gmail.com>
Subject: typo in ksmbd-utils README
To:     Namjae Jeon <linkinjeon@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

        For Fedora, RHEL:
        sudo yum install autoconf automake libtool glib2-devl libnl3-devl

Should be:
        For Fedora, RHEL:
        sudo yum install autoconf automake libtool glib2-devel libnl3-devel

-- 
Thanks,

Steve
