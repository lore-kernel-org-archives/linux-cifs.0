Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE50EC433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 05:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F7D064DBD
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 05:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbhCSFxH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 01:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbhCSFwj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Mar 2021 01:52:39 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4BAC06174A
        for <linux-cifs@vger.kernel.org>; Thu, 18 Mar 2021 22:52:38 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id g8so1092606lfv.12
        for <linux-cifs@vger.kernel.org>; Thu, 18 Mar 2021 22:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZuDTEVlmsc1G1XeamRhw8f0Asf1nygL71LykZCWq1lY=;
        b=LThnh7tj/JXDp1SySeHzX2LymuqEc6yF2INzLwPvVGSa2Rl7erzfsIbeN+V5Np/Xdx
         7eBKw1H9a1k2FzEnN524+OWFLJEQt0dc/gO0kEFKc2Ii//gv3oDfkMwXn3HmqxBdPwIe
         IQnDktDS/E+oO+oaJnHVIGLFa94vpajk/9M1WqTuAIDdFuyEwn8Tku6NSVKhafts4sHM
         Pc7pxAs44nQubtoZWJVO5oFT8LP/lKMdEIav8u81f7uISUDMez3uZTZUtrI51w+mxuE1
         LrD8ltInLiiPzveGBNHHfSQWEbT0HFDoanv2zFTTMs998VVy7dnqiDlpqcvnfqfC0Cr6
         x4zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZuDTEVlmsc1G1XeamRhw8f0Asf1nygL71LykZCWq1lY=;
        b=UNEUX9V6d/piYOhxOeUlLUS4sYJe05IvijiaS5RbdkF5bqQoOpxf6PMOREu7eS8Vh8
         UVXm1vpOAzw4fcwpfq6DIjm7jIpnZEouXqrLp5/gZwnChrPtMveJecwVrgFHTV0F3KOg
         EUNpiGWN81nahtHHm3xLSBUY6KqA/xeLl8imzLOkH1xZAru27c71Giuuhm4rRRPc+YTh
         fEiQgUyg9vaowRAJEcbeAwMrW4yhJE2Rcrc2+bI9qphV00IRCDG/lxA4m+1rrcZ1AhLV
         QaOIIvbdUx52LC6S20tnJrkgzyY7gjv7T3z3uBbNzy7ugjC8RzWb9o76IFz67l8J2bZw
         nLmQ==
X-Gm-Message-State: AOAM532PN/4ZQAajRxK4CGBpun086tI/I4zkSWFW2ANyxSYxCrb2H2Vr
        HR7xi57zLcWaGbzPz8KtU5wR6Kg7hplftFupzVA=
X-Google-Smtp-Source: ABdhPJylQsUg9L8UHG2LXHYH34z0w61w0+39OmwoRWkAIdZ6nTS2MWexdbMHsEHJ2+H+GhHHkDmvRryqBsQwMaRK6Bk=
X-Received: by 2002:a19:7515:: with SMTP id y21mr7603831lfe.282.1616133157476;
 Thu, 18 Mar 2021 22:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210318181710.9003-1-aaptel@suse.com>
In-Reply-To: <20210318181710.9003-1-aaptel@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Mar 2021 00:52:26 -0500
Message-ID: <CAH2r5msdofNV9um=-YkzcRiJdRVi6L-P8ejrLUuouW-YGmmgGw@mail.gmail.com>
Subject: Re: [PATCH] cifs: warn and fail if trying to use rootfs without the
 config option
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Mar 18, 2021 at 1:17 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> From: Aurelien Aptel <aaptel@suse.com>
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/fs_context.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 9b0e82bc584f..d0580e2d1f32 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -1197,9 +1197,11 @@ static int smb3_fs_context_parse_param(struct fs_c=
ontext *fc,
>                 pr_warn_once("Witness protocol support is experimental\n"=
);
>                 break;
>         case Opt_rootfs:
> -#ifdef CONFIG_CIFS_ROOT
> -               ctx->rootfs =3D true;
> +#ifndef CONFIG_CIFS_ROOT
> +               cifs_dbg(VFS, "rootfs support requires CONFIG_CIFS_ROOT c=
onfig option\n");
> +               goto cifs_parse_mount_err;
>  #endif
> +               ctx->rootfs =3D true;
>                 break;
>         case Opt_posixpaths:
>                 if (result.negated)
> --
> 2.30.0
>


--=20
Thanks,

Steve
