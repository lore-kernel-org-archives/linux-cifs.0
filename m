Return-Path: <SRS0=zOxz=T7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D7BC04AB6
	for <linux-cifs@archiver.kernel.org>; Fri, 31 May 2019 21:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC48826F43
	for <linux-cifs@archiver.kernel.org>; Fri, 31 May 2019 21:20:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e/0bD2lm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfEaVUo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 31 May 2019 17:20:44 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:41729 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbfEaVUo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 31 May 2019 17:20:44 -0400
Received: by mail-pf1-f182.google.com with SMTP id q17so6929936pfq.8
        for <linux-cifs@vger.kernel.org>; Fri, 31 May 2019 14:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=yOfM/eP5V0tmMsJWcsbIasKxs8cUNTiAZWjGKTWd218=;
        b=e/0bD2lmxNoDr4bEQ2gx0tbaDkmvwO8z8JkgBzaOP0TvMqn/pqns/Zan5lwgfeJZkJ
         aYH9us5N0drSu8aUgteVaN0dQNEf1UuT9b6BYTa8yyEtwvlXkt/4MHON5+80d3kHDkr4
         jZQzYkjy0FIky9+a5AN+bsAtGnuWGlP/vbPZzTX1AEuyxh5KSdRyM7/ohReYuSWb6dQz
         azyROqrohCzHlHDAFgh0C0ijUUFHp4gWvhrLfpwcXayx1HHLHNMPk9rmS0IBBk0M1nLj
         aKvf75u6bHxpumF+eefDu/0V78wjTLAVb3+ZuEJgyk4y4dhdXFsxinTnRCl0743Bb989
         HqUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=yOfM/eP5V0tmMsJWcsbIasKxs8cUNTiAZWjGKTWd218=;
        b=WE/vxUxgMi9tcli3hAJ3X4EwnzUJ6j5S8KbRTRrL0PMtV6QD2YjeLwVM4vYG4LzrGc
         i3kEYXpdM66uGeoU8NvIwjcRpSJcLHE79qKsVcHcZ7s0e/OxcXsKaCLuAyLjbM6h4cR3
         eyIx5BeJdD+nIZbxgabOp/mJBr1eU0exNM84FozGoYCj3MLPDHV0q8v75f3mPV0y7toE
         NeYbk3otkOhPlfJaQtI/0id9Ykwp3e/UF6qpbJfbNO52CzdVDfMQAd3XpwyckuiR46/k
         qOe35oTsVTyLIK+AGlTZFZQsyJiNU7LNVuhGgxCg5flCbJQbAJuHhWZO9Q+7zCLFHqSZ
         aumA==
X-Gm-Message-State: APjAAAVRvuy6BnjmAFzNRVGw1khLiIJRa41b3zm4MinGLVI9NmkWXCfh
        v7aoiEI711ebLRLVU7Pf5prfOlW3bDqRD5/ncs+M5oMc
X-Google-Smtp-Source: APXvYqwQPZ7hQyivhKsuddTVedunFMPvbGdcP85Qt4oz3VRdKyf3+UhTdKX5QrV3jGjCJfm0gQQDGAc2NAbHpTqXF9E=
X-Received: by 2002:a62:6456:: with SMTP id y83mr12829572pfb.71.1559337643543;
 Fri, 31 May 2019 14:20:43 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 31 May 2019 16:20:30 -0500
Message-ID: <CAH2r5mv_xgWmFfSanMxo4LUmEBRuQZtKGRvFqFD285DkyD2PZg@mail.gmail.com>
Subject: Added test 091, and updated github tree with current 5.2-rc mainline,
 rerunning buildbot
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/169

Buildbot run with updated kernel (5.2-rc) and added test 091

-- 
Thanks,

Steve
