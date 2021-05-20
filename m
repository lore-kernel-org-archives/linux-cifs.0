Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C289AC433ED
	for <linux-cifs@archiver.kernel.org>; Thu, 20 May 2021 18:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AF3E6101B
	for <linux-cifs@archiver.kernel.org>; Thu, 20 May 2021 18:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbhETSCP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 May 2021 14:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbhETSCP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 May 2021 14:02:15 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DC2C061574
        for <linux-cifs@vger.kernel.org>; Thu, 20 May 2021 11:00:53 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id n83so13138636ybg.0
        for <linux-cifs@vger.kernel.org>; Thu, 20 May 2021 11:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=4mQ7/De/TeVIgjViCeBvJUtR38B3yoAGeS4hhqBvCG0=;
        b=CQEF+vaQ0pODrP3UUIpoHSrrkkH12yIPq3J25YHGXW75Hs6EiYrTCgQim2TAsCFWPG
         r29qJ8qYfHUCGTK3eopWqWYBDwt0hGA6M/FS64qbrLhJjLJKswjABOJwR/YkNKBcriw9
         uw43H/HHhCS5b8L5kk6PR7kP4yKIPMFuaHI4e1Y9C31vt2vNtiePxE+pIxJsWNh2272u
         /MzTG+rxXoQqWPHfl1JAiL5iUKW4/z+iHTDudfo6rORl0XUdDaNZL7KUFj6uc24KQjNC
         dTjDQbO1H5DPuFimSoMhARNJ8tvB3nUkVsOeeEB1yWUfnuuLSEtv4DEmGKvq3ALZY4zf
         Qi4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4mQ7/De/TeVIgjViCeBvJUtR38B3yoAGeS4hhqBvCG0=;
        b=ui6xcoiYRFzfH4oz6tW+d01uNXlp1NqLmOn/7VawXV4CrK2wDswo9Ardvk4lMGhtSM
         K+mowwTNIIdNxJHAzglc27pMWxUtjzp3hmSpcvsB4Q8IRS/tY1rHPepu/S8T907taxZk
         mVqYfbFjuhyatjj6Lybl6lOTVicpqJIEhebC4FkzDs9Qn+Bki2uCULjrkJ4qrGhBi67P
         IlVWzn0dX1p3dYVkr+ZljCzdbmMmdGSfqJDWEfrEVSWtzW1/wLAHBWIROQ+Y63onAFWJ
         PhJdqr3DzQl44GPRN5X0GL06npVwQgKFuEIz30YRegRLANggo3i5bw7k6eMnTwWwk1gz
         IrMA==
X-Gm-Message-State: AOAM533YDtmHL5+zThEGB2oM3Zc0v4xU57eN2z87rhv4GGzLkAAkrUpz
        LOY6npiWgm5yOdeuHsUGVMuS9sAeVXLFLOGdH4k=
X-Google-Smtp-Source: ABdhPJzcG3b4SbgB7jlwdIWi258fXfGwWvM2OdKQgKTTmPVkHpQFZPOmPZAheCy5l8uVrsUIYS0xgG8S/5kbhqhU5v4=
X-Received: by 2002:a25:ae24:: with SMTP id a36mr9397797ybj.97.1621533652785;
 Thu, 20 May 2021 11:00:52 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 20 May 2021 23:30:42 +0530
Message-ID: <CANT5p=qzxhOjAY_s9NMsiS5F4FtsNJXytHbihF+esv+n4ytDvw@mail.gmail.com>
Subject: [PATCH] cifs: use the expiry output of dns_query to schedule next resolution
To:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

We recently fixed DNS resolution of the server hostname during reconnect.
However, server IP address may change, even when the old one continues
to server (although sub-optimally).

We should schedule the next DNS resolution based on the TTL of
the DNS record used for the last resolution. This way, we resolve the
server hostname again when a DNS record expires.

Please review the changes.

@Paulo Alcantara I know this can create merge conflicts when your
patch gets merged.
I can rebase my changes on top of yours when it gets merged.

@David Howells
Something worth noting here is that the keyutils key.dns_resolver
upcall resolves the hostname, but does not return the expiry time. I'm
falling back to a default value of 600s for now.

I assumed that this commit of yours was a workaround to this exact
problem in getaddrinfo().
https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/commit/?id=75e7568dc516db698093b33ea273e1b4a30b70be
Have you since been able derive the TTL field from the DNS records?

https://github.com/sprasad-microsoft/smb-kernel-client/pull/1

-- 
Regards,
Shyam
