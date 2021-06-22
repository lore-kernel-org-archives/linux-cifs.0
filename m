Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDFDC2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 17:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 056766109E
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 17:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhFVRsk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 13:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbhFVRs1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 13:48:27 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B1BC061766
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 10:46:11 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id x24so37281685lfr.10
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 10:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=FxPWnM2nzBESBSeVwKSFWY5yV1Am4IvV6hH/h/iwhHU=;
        b=Oy8xrawud2O6hsSaAF/CLRkiw4tuPVDUJSYD+X57LKdrstGc5buwoV2Q5IKJa89s6i
         ipBDuUlydi8pajAKs1q5BAjNN7fPVmf2YNWN61VrxsWYmZp97HHR+Z8d8IRwzg6Mw6F7
         p2dYIP0WkR1BLi5TEuQCSZb1UHNxr5iQgznRU+hdgA6c8bjKj4dp6e80sLi6tZH2usYo
         r93aEtuUinRCmtLeVJqw8ua3tVid/ZgRc/HxVJCl6wzsX7Izi+94yw6GDg4o09SlgR+y
         u6eKo0Cx0+s1D6to7jmQNWd36xb49xOuX+ZxWuVxuaImo+ZSs9kELFIrkdfphZCps19w
         1VoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=FxPWnM2nzBESBSeVwKSFWY5yV1Am4IvV6hH/h/iwhHU=;
        b=Sbth5WPetQARllKryXZ/A/EfpAPtAJgA3UgEUPtCaL4VhEYQtnrz+IaLuNLyfBvXY5
         gGmTIMjWuZDQVCYbfhjVid7ZeMN9hAa8heFmD9yAtXZqwh0KeIHpt/09f7NiPtQK7/TL
         gesr4Oom2FBySIdU4SaRbXpI3rRPl9Y15pyYsuzhu0iQ+ZnwwoTnkbyIN95bSvimAssC
         BE/xzUuIh8k2s1YhSjesr7nsTcApGsUJLhfohpmrMvqFkAAjujTHFHtHYgqenVZniaQu
         rw4IL4nJLtCD2V5U/WBOTBJ57jByJs2YAam4uyTydRIaAdvct3NLv1AiGAOgJAl8A9RS
         uevA==
X-Gm-Message-State: AOAM530UOVs9KSdl18o3VbMb0kNHocIJYvz36wShCrFC7KW6KZoAqW53
        So7FxPehHJG0gpofsCYXL0RaHoMIs0vPG1T5XGeF6LZAd5xB8w==
X-Google-Smtp-Source: ABdhPJzqrSj65fqXRPu74W0R6djEKT8FC7BNjM/WLrPP8jS4kzm3wFoPrV4db2Y08ahORHZPQduyruI3AFMtAVoUheU=
X-Received: by 2002:a19:f705:: with SMTP id z5mr3676245lfe.395.1624383969085;
 Tue, 22 Jun 2021 10:46:09 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 22 Jun 2021 12:45:58 -0500
Message-ID: <CAH2r5mvUXZtY3=LNzt8_icDfUAAeZpzjUK3sEErzpCksFDX2WA@mail.gmail.com>
Subject: Processing ASYNC responses
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I noticed that the client isn't checking for SMB2_FLAGS_ASYNC_COMMAND
in the header flags field in the response processing.   Are there
cases where we should be checking for this?  See section 3.2.5.1.5 of
MS-SMB2



-- 
Thanks,

Steve
