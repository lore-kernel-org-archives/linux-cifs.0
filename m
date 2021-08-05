Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90767C4338F
	for <linux-cifs@archiver.kernel.org>; Thu,  5 Aug 2021 05:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B0EC60F14
	for <linux-cifs@archiver.kernel.org>; Thu,  5 Aug 2021 05:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbhHEFSE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 5 Aug 2021 01:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhHEFSD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 5 Aug 2021 01:18:03 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A29C061765
        for <linux-cifs@vger.kernel.org>; Wed,  4 Aug 2021 22:17:48 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x90so6582265ede.8
        for <linux-cifs@vger.kernel.org>; Wed, 04 Aug 2021 22:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=PyRrewuJ0U6YAtAX57XedS14f0zYSYUoi3L/blteh40=;
        b=KPpYunwFftIyDqbcvErbvYYNEapiy15vJspLtf/tqWiU4hU4QH431SuCodFH+QjtWf
         ggd9DokTg0O8jZBO3U7umTJfTBWe+PH2dO/5y59gZg9GwvXZiL38theKVCUTK0/q+cnB
         eYoSB5OsGkaeb7w8dE9y3GWUDi2+Mq59MbG6hfDNKTEwtSscUV+MtChRSEgMfNj9+7Gi
         s2AQ2fBbx/nXPnscjezxr6nDSuOngDnXOr00ybtBtFBeT9X1p1qvBgcqjTlPJZVTuZza
         On/MMk2i+vfW9nRcS/iZqd9zTEgILyGVYGDwmrZGiyOHsRRRMp5h7HkhfyAY1Y96Ity+
         4RKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=PyRrewuJ0U6YAtAX57XedS14f0zYSYUoi3L/blteh40=;
        b=QqTgGSkIjA3nYSyUIAXgvuny3wfhHjTA8r+YMVTnBgpO8ipDTsG9rl42TyShAgmV48
         jlZfHwDoebclrApDcbhz1cxh/B4E6FLVqM1+u4ehnIGVY8eqREGVvzl8+1tjohPnVaka
         2cUlQrgcGbIQ6aYZxGlOjkzlYyDMYTkL6KUy/xU/f8xbxdVoso4MThEajGsAS+qZF46/
         8UzOeUJOmUexPg+zJMBmacLHmwE7DWjsyM1rFq3J9L3S9iEUgagolz0p868uTAkgguTX
         43cOCaLiRhDngO4KSXHwHjK5ThS6zEpPsZSqvEveUpJ6xOrVdb9VJYRWu0n3ZSY5oXNQ
         1sJQ==
X-Gm-Message-State: AOAM531tM07pP3p/uNCfTASXIwgHAfQ14sRzRSIqPvMTiRKXc4ivV9AE
        S3g25Eu1URlOM6t/Sd+TudP9dBPotdpB92ahTPY=
X-Google-Smtp-Source: ABdhPJyD7xoneyZqaQuannabCgZfOxLDbiJn34OBmv+0RP2R3j9sEamo8be/Rvv61SR73WqANs0iVs4I66zXS6FvlKU=
X-Received: by 2002:a05:6402:898:: with SMTP id e24mr4115172edy.197.1628140667267;
 Wed, 04 Aug 2021 22:17:47 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 5 Aug 2021 10:47:36 +0530
Message-ID: <CANT5p=ouksRAiRLLexVhPZU1=iWwhiRUxw8dBRj-a_f2vjnEDw@mail.gmail.com>
Subject: [PATCH] cifs: create sd context must be a multiple of 8
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Please review the fix for the bug reported at:
https://bugzilla.kernel.org/show_bug.cgi?id=213927

The issue was misalignment of create context caused by one of our
earlier commit:
commit ea64370bcae126a88cd26a16f1abcc23ab2b9a55 (tag: 5.10-rc6-smb3-fixes-part2)
Author: Ronnie Sahlberg <lsahlber@redhat.com>
Date:   Mon Nov 30 11:29:20 2020 +1000

    cifs: refactor create_sd_buf() and and avoid corrupting the buffer

    When mounting with "idsfromsid" mount option, Azure
    corrupted the owner SIDs due to excessive padding
    caused by placing the owner fields at the end of the
    security descriptor on create.  Placing owners at the
    front of the security descriptor (rather than the end)
    is also safer, as the number of ACEs (that follow it)
    are variable.

    Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
    Suggested-by: Rohith Surabattula <rohiths@microsoft.com>
    CC: Stable <stable@vger.kernel.org> # v5.8
    Signed-off-by: Steve French <stfrench@microsoft.com>

The fix can be found at:
https://github.com/sprasad-microsoft/smb3-kernel-client/pull/4

I think this should be marked for stable as well, with a "fixes" tag.

-- 
Regards,
Shyam
