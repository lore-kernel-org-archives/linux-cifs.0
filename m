Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E1CC64E7C
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Dec 2020 10:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79193221FC
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Dec 2020 10:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgLBKod (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Dec 2020 05:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLBKob (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Dec 2020 05:44:31 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BECDC0613CF;
        Wed,  2 Dec 2020 02:43:51 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id r127so1158279yba.10;
        Wed, 02 Dec 2020 02:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9DFjZAdrwyZk2YQ7OkLyRHwrSQpCncG9hZ9zBWhHgDs=;
        b=QIAwqiQ3gUySWZAon+96z2Ae9kQK44KBS3BjTABbfgEKg/sDjKNpA6BZKS6Ps1WjA9
         KQsZJ4nFJo7+1yhSL2zBmjWLVE/QF87ObQCKkj6XXKLuXn37YeKfgyL0nIJ66nsmEqlm
         HgFqjYKCDA/RWTgjnvckXczJGJVmPWSBLtItAsaOyw7mUyKOHD4DbuKzzr7kL1xyOyYx
         maaB430hfG+3FClPEQ/xI6UGw9YzRdcFL3HQrrItcmP/PSlv++yKqIQ5ZaCPJnR9HjVs
         UUuSywkxsAZ0OoA+sf13P9ie45F45Z6Q8vrMD+dAxfGmOiV8nDkM485Gy4PwPtryW1zb
         rmbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9DFjZAdrwyZk2YQ7OkLyRHwrSQpCncG9hZ9zBWhHgDs=;
        b=PbWNldiYMk6OHQ1QxNI8sibRgzHyGgH08vfs9OVpDdPTi6YKhTilfI8g9xb8+iCDQu
         gXUTC1ZCFikuyxkt52l4r+MiWvPkTMogGctc8GWenL0qiKtxICeYsAUYABlAbwflWpKd
         CXWimPZcToeSvelyxKM8JKN8piWFC+1L7BYS5yV3xY2FujSmBRG4lbK6vZ3NrIn2jNNO
         oElpfjRAv24OsZBNMm5dwAq/pLIZljcyvv7T+WluBqr0xkzdIS7YB3824gxYnvrNgBaq
         Poqs547rWwbjtcq6YaerBdA5Ho5VHDyeNA5x2pVXM7xHIZWkJBqXZBSqc59DDAHQixXF
         oAiA==
X-Gm-Message-State: AOAM532jy6XRxlRyKHwSj3dB2VeHEl4Jd94WKyqkiL32SW/DM7g4btER
        jclY75r42pOXiGUQ5cAfRD+70ANJOI1QlrXyL0J8JGg7FzUIMD5PByU=
X-Google-Smtp-Source: ABdhPJz8v6Ej1xn7oEpvOSGtJ0kNYG3CoGEc8UoAwv1aFk2K7PXt92btzvd9mqyFZfcZkr9mx0yrlLEw6aVO3eOXjpk=
X-Received: by 2002:a5b:149:: with SMTP id c9mr2369419ybp.3.1606905830376;
 Wed, 02 Dec 2020 02:43:50 -0800 (PST)
MIME-Version: 1.0
References: <20201027204226.26906-1-pboris@amazon.com> <CAHhKpQ7v_nPwBx2czk7rVXK3ZrmsZrAkcxDFOgq0ABTOVc7iSA@mail.gmail.com>
In-Reply-To: <CAHhKpQ7v_nPwBx2czk7rVXK3ZrmsZrAkcxDFOgq0ABTOVc7iSA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 2 Dec 2020 16:13:39 +0530
Message-ID: <CANT5p=q2YvkEOEa4bS=-nbPOc9Xwa=4gnc09csCcszMmMjYSPg@mail.gmail.com>
Subject: Re: [PATCH] Add support for getting and setting SACLs
To:     Boris Protopopov <boris.v.protopopov@gmail.com>
Cc:     Boris Protopopov <pboris@amazon.com>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Boris,

At a high level, the changes look good to me. Will go through the
changes in more detail tomorrow morning.

On a related note, we may need more test coverage in this area.
Can you please share your testing output against your changes?
Or even better, if you can contribute some xfstests for this use case:
https://wiki.samba.org/index.php/Xfstesting-cifs

Regards,
Shyam

On Wed, Dec 2, 2020 at 12:24 AM Boris Protopopov
<boris.v.protopopov@gmail.com> wrote:
>
> Hello,
> I am checking in to see if anyone had a chance to take a look at this
> patch. I would appreciate any feedback.
> Thanks!
>
> On Tue, Oct 27, 2020 at 5:01 PM Boris Protopopov via samba-technical
> <samba-technical@lists.samba.org> wrote:
> >
> > Add SYSTEM_SECURITY access flag and use with smb2 when opening
> > files for getting/setting SACLs. Add "system.cifs_ntsd_full"
> > extended attribute to allow user-space access to the functionality.
> > Avoid multiple server calls when setting owner, DACL, and SACL.
> >
> > Signed-off-by: Boris Protopopov <pboris@amazon.com>
> > ---
> ...



-- 
-Shyam
