Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B02C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Mar 2021 13:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6BA364F98
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Mar 2021 13:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhCKNsB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbhCKNrq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Mar 2021 08:47:46 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC894C061574
        for <linux-cifs@vger.kernel.org>; Thu, 11 Mar 2021 05:47:46 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id p186so21793924ybg.2
        for <linux-cifs@vger.kernel.org>; Thu, 11 Mar 2021 05:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w4dRnwN5WELYn2RIDGo5SM+4OkTlIU2sdeTHdjQ2Jpc=;
        b=dJ6VDl3VntXTadXHVADkNLXUTUiGDvXaY5fswZa5iWvNEvt773aFs/WvvWqzL/hxNk
         9bwUJpXDRvjGw7rcyrSsQ7aBZP0vxTvRXt5zH08hUfATaDRg6rR/d1fGL9NLSjwhPuWO
         gmg2xpG5N2+5gk1tfB0eGbRGPZW5F6O0dc1EJTAKpFsaXTEnW+odLFTFI4a5MmDsV/Ab
         vyL8o6A7OWPo3JpgffuTOs8RthcJB7fRfM2HOS+es9fytSkeFPyxf8wF+KZO7O6PD1hn
         avy+ukFCjFd5RK2GpZn+WMo3up/X5ML8n2XhiV8qxFXrVOQgdUqCG703iPZjiWqqvfxq
         XyZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w4dRnwN5WELYn2RIDGo5SM+4OkTlIU2sdeTHdjQ2Jpc=;
        b=iuz9YNom0KoQTx4Q2Iej9fr9OjSUHKBPK7Dc4Lmjm5MGIkSGOq2I7lpJX3jy8VmyKs
         TiqWFyTEDg2IWI0ssxJs4yeps/1GssK0FBb39tZpk/AF/tBkgYBlFeIlUdiCSTp4uu0b
         DGcMg6hU/PKDBdssJiFPEKVqZ6eOMyvYEoDAXXn/94oEET6O0IvcUjZotw7oIY49ZSSC
         7xcRnsPUTdji1uoRrVj0SaNM3nzvk3Cypbwe1YnG8EEZtuUUizUQmcHJWD+altq1EKyX
         Fz/D3Nv9bFI3ukGLv9uwzEEaGuf+xykJ2Xpi/QQlnva8Xi6MTjphGO/xRJQdVc0hGv7e
         aAmA==
X-Gm-Message-State: AOAM531dem2QvoGesaGUPdahPyWdq/2dENrZx7eD96206gRQWlqz4V8n
        2fPKmH7CUBEJb6e14+4owGXL93Ru0G4yR3G9Am4=
X-Google-Smtp-Source: ABdhPJzLPenjrTHMYrWEtPrg589U8vkKmOczfbDOmKJjVP7dvyjha4zka3U5xMuK+vf3f+LnCbYxS9Cw9KP+6YudIUA=
X-Received: by 2002:a5b:3d0:: with SMTP id t16mr11662610ybp.293.1615470466032;
 Thu, 11 Mar 2021 05:47:46 -0800 (PST)
MIME-Version: 1.0
References: <CACdtm0Y1NeC0jNTOtjhTtGRt0sfyhyxC=wNfMu1eqibe6qJbwA@mail.gmail.com>
In-Reply-To: <CACdtm0Y1NeC0jNTOtjhTtGRt0sfyhyxC=wNfMu1eqibe6qJbwA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 11 Mar 2021 19:17:35 +0530
Message-ID: <CANT5p=pFU=1OKiBA0m0_Pqms4Vsxz7omEgvfDDAb8U3M4-3qbA@mail.gmail.com>
Subject: Re: cifs: Deferred close for files
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>, sribhat.msa@outlook.com,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Rohith,

The changes look good at a high level.

Just a few points worth checking:
1. In cifs_open(), should be perform deferred close for certain cases
like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
perform less data caching. By deferring close, aren't we delaying
flushing dirty pages? @Steve French ?
2. I see that you're maintaining a new list of files for deferred
closing. Since there could be a large number of such files for a big
share with sufficient I/O, maybe we should think of a structure with
faster lookups (rb trees?).
I know we already have a bunch of linked lists in cifs.ko, and we need
to review perf impact for all those lists. But this one sounds like a
candidate for faster lookups.
3. Minor comment. Maybe change the field name oplock_deferred_close to
oplock_break_received?

Regards,
Shyam

On Tue, Mar 9, 2021 at 2:41 PM Rohith Surabattula
<rohiths.msft@gmail.com> wrote:
>
> Hi All,
>
> Please find the attached patch which will defer the close to server.
> So, performance can be improved.
>
> i.e When file is open, write, close, open, read, close....
> As close is deferred and oplock is held, cache will not be invalidated
> and same handle can be used for second open.
>
> Please review the changes and let me know your thoughts.
>
> Regards,
> Rohith



-- 
Regards,
Shyam
