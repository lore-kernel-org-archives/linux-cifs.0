Return-Path: <SRS0=eHRh=CH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF148C433E6
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Aug 2020 00:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C6E22098B
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Aug 2020 00:22:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N6xD8cGu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgH2AWt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Aug 2020 20:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgH2AWr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Aug 2020 20:22:47 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2FDC061264
        for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2020 17:22:46 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id o18so1330093eje.7
        for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2020 17:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FV66oZFnM/PuzKG4bGrTqO+D8Qg3WClYhcge1woA7nQ=;
        b=N6xD8cGuam7ZdJ8C+UmEEqTVE+86bNmBiZzPTX+AWc6AVlpLcIcth6JgE806INiN2j
         p3EAprACCuggA1HiLxDyB/73xObRRkXbTN61+qDXgNkj84qCZzudFwePJaerrpsovwem
         jCoUpidIhdRe5L5jf+kw09bPm4T+kCTSOmg5pRI3/XK0qv8e8BheY0B6u6TaANZeKw/g
         aKl3e1QRwIPN3QYXB0enxmClQEbRFcqymbNxehW4B9xOlkx519uaPg2V5Y0V/0L6QLWe
         gnFf0bdaN6omoJNBj/EtF9pMF9qKNAz1qiCWQo389NULwVBVIg4gbPUnCeU5Ah9NUG/X
         Fd8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FV66oZFnM/PuzKG4bGrTqO+D8Qg3WClYhcge1woA7nQ=;
        b=hoc7bSStqt/ngTYSFSoKUXTe1C8adfgEk5QFiXHgSGZHKFs9+AHp+8klkkP7gc5Ash
         5Oza5CxZ645UrUhYVJdgpdgFgPqy1jnsUQlZ4Kdsxz5SGOLBUwP9iRUk9LnAwHQZrG2e
         hAAFgSYgEiQMgJjm2qUXsjy+x/iXwu4qK/HOjz42aeFetf2uhAd9sEadwr5tcr1YlVed
         3XRTfqmF4aWMlusEBZPHxvTCizz08qcftTXu1yh2Mfb/4OiUbW732lNKLVsVUwBBFguw
         8uSIZ/T+T9q29eSuKOdGMplF4erIZeoPVTdjQ9mRFa+4MUcdXpbiVxSqC7EkyN8yVaKB
         jXUA==
X-Gm-Message-State: AOAM5315/243glIuHkiguUlOL4uqgwrdM2Ngwi5R77qqLoVHioeEN1zd
        zrT6fqF066zcGtTC1sc1lDJRPlzM2jq3yqkXMA==
X-Google-Smtp-Source: ABdhPJy/P8zLV/GmZ4Q7fpavDvFe2Wm+cq2JAT35QTmPFCN6v3fiBC8i+2GBvRK+kUJDtaYNp5oLM90FYbUol8Mdeog=
X-Received: by 2002:a17:907:7249:: with SMTP id ds9mr1288479ejc.271.1598660564587;
 Fri, 28 Aug 2020 17:22:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200526035411.102588-1-lizhe67@huawei.com>
In-Reply-To: <20200526035411.102588-1-lizhe67@huawei.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 28 Aug 2020 17:22:33 -0700
Message-ID: <CAKywueTo_Ssx0SEAGn=hBRGbz8n_itLZKoJHo5ndGQ0Zc+XqAA@mail.gmail.com>
Subject: Re: [PATCH] cifs-utils: fix probabilistic compiling error
To:     lizhe67@huawei.com
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged. Thanks!
--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 25 =D0=BC=D0=B0=D1=8F 2020 =D0=B3. =D0=B2 20:54, <lizhe67@hua=
wei.com>:
>
> From: lizhe <lizhe67@huawei.com>
>
> When we compile cifs-utils, we may probabilistic
> encounter install error like:
> cd ***/sbin && ln -sf mount.cifs mount.smb3
> ***/sbin: No such file or directory
>
> The reason of this problem is that if we compile
> cifs-utils using multithreading, target
> 'install-sbinPROGRAMS' may be built after
> target 'install-exec-hook' of the main Makefile.
> Target 'install-sbinPROGRAMS' will copy the
> executable file 'mount.cifs' to the $(ROOTSBINDIR),
> which target 'install-exec-hook' will do the
> 'ln' command on.
>
> This patch add the dependency of target
> 'install-exec-hook' to ensure the correct order
> of the compiling.
>
> Signed-off-by: lizhe <lizhe67@huawei.com>
> ---
>  Makefile.am | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile.am b/Makefile.am
> index fe9cd34..f0a69e9 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -118,7 +118,7 @@ endif
>
>  SUBDIRS =3D contrib
>
> -install-exec-hook:
> +install-exec-hook: install-sbinPROGRAMS
>         (cd $(ROOTSBINDIR) && ln -sf mount.cifs mount.smb3)
>
>  install-data-hook:
> --
> 2.12.3
>
>
