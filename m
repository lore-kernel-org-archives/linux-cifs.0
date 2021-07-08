Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B20C07E96
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 18:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BEA36191E
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 18:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhGHSM2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 14:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhGHSM1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 14:12:27 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDB1C061574;
        Thu,  8 Jul 2021 11:09:44 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id r20so3809577ljd.10;
        Thu, 08 Jul 2021 11:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=1iraYLpUq9aYVHxS+mi4Nh+zv82/1tjfwvrxxs5cgR0=;
        b=i7/eaKoMGC/8BlyHfRZiZM0z3+uYMYT+Qqpn/esaweRyGXdDRud8JPe+yv7/dGhXme
         FAr9+qX4A3Sw5phYJ7gQXs/FdiZrMIugHDOtdd7lPX/LDnMhbVp7IsqhgVwGq2g3teRg
         NeKp6JJth2y+QExZNvdj0WdM0ai8ace3ORV53SmbEJTaOCcT1gHc7op2oW3Q/eaZi+BL
         plRygnz7590zw2i0PYK8xh/L6+3eMtnGnlhzITmHIF2+NyEQoaoXzZEoJaGBMVa3s2F/
         Mrj9I+Qwh24EVFi0iQkO0Aa8vcgqlhr01WpPCT4iDQUPBdYTJbKztnK1Fbk6XqaHEv71
         x9CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=1iraYLpUq9aYVHxS+mi4Nh+zv82/1tjfwvrxxs5cgR0=;
        b=RmdsaG5ljr9ZD7rQONUnPuWelMD2kr2zf9ANwqiZj2oI9xI85PyolwN8DcAhstjyK8
         bTHILFcZN7rIkCw23CCih99Wmux9oAFfH45mI5MOhgFiltqAiPrH3e2Igkp0+9iw0LLJ
         VLc6XphieuNnPsnHGkcvQTcegh1Zj7lCwbT7tSU1Cj3uiBgjYnPjkoKVgBxeG4wNNBP1
         xyLsXNYs826F25K8diyxF4FAvki0o/9jcsXKuRvhA+8djina1ZUDpS8wcMEnAzuC2Zft
         yvdMKGtvtmOwGZv08zzs0fIxwHsFQPFUVczj3W54I5+EQLTtj+S2zcjjSHGjkFL+WMdb
         CWNw==
X-Gm-Message-State: AOAM530UEss95BjZfxGP75GHweiqxyjh9CV96HA+RWaPG+8Npz0g+PQN
        rj2y6MDplasQfosKkhssHppTVOeqyfP2Yb+iKgo=
X-Google-Smtp-Source: ABdhPJzgsvxjb+skIQlwEGg2rqSDb341RLAXZFYLEgXuw6ZzSR/amWGoNhVrTzc6JjOfsMHxsA3n2FRIkwoEKDyexD4=
X-Received: by 2002:a2e:b746:: with SMTP id k6mr23333898ljo.6.1625767782263;
 Thu, 08 Jul 2021 11:09:42 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 8 Jul 2021 13:09:29 -0500
Message-ID: <CAH2r5mvm5ZTyGmyuNzxWhc5ynb5LpjtdADtHVjFeF46Q5MUsFQ@mail.gmail.com>
Subject: confusing fscache path
To:     David Howells <dhowells@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Coverity complains about a double lock in fscache code and it may be
right.  Can you explain this path? Or is there a double lock bug?

line 190 of fs/cifs/fscache.c calls fscache_uncache_all_inode_pages
(which locks cifsi->fscache->lock) but then immediately calls
fscache_relinquish_cookie which locks it again.

Is Coverity ((and I) missing something?

The path from fscache_uncache_all_inode_pages is:
   fscache_uncache_all_inode_pages-->__fscache_uncache_all_inode_pages
(line 132 of fs/fscache/page.c) -->__fscache_uncache_page (locks on
line 1120 and then on line 1141 "goto done" without unlocking it)

But it gets locked again in:
    __fscache_relinquish_cookie-->__fscache_disable_cookie
    (on line 749 of fs/fscache/cookie.c)
-- 
Thanks,

Steve
