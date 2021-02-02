Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF4EC433DB
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 18:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 549EA64F96
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 18:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237976AbhBBSBp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Feb 2021 13:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237958AbhBBR4S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Feb 2021 12:56:18 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC507C06174A
        for <linux-cifs@vger.kernel.org>; Tue,  2 Feb 2021 09:55:38 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id f2so24987103ljp.11
        for <linux-cifs@vger.kernel.org>; Tue, 02 Feb 2021 09:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=MppbbXzJ0digsWPG2GM5CfCZPDAoLJBBZ6Gid6/7IIQ=;
        b=PL5Re/GONLGjrymoF3l0SAHN5WFFWMCciZBZArV/7iVY2DaTJ2TrZIzKqXiDxT1LcQ
         sGx60q48HPwi2d9VHgPj5D8g4S7oF0w7X6Xh8znKN4YWR578wVgTlj9QQj4WL3DuSeeH
         RwX1wdxJ0hS/roVmAT3JxzxjVnZbBgIBgOeSpI90RR0yamrk80wT/LiPiHNdef4yQHnP
         9zYULSKMnnYMGCo3bi67ivNESHrTPAH4Go4DfDYAN44geOu7Zh5KTwTNKKYiCH4MaHL1
         f9WAt+QU20xC5qMxLUVeF5ff2aqg+GIer+mFRAn9lPFeaD5ERGVhtSVOWXjBa4QSHb8i
         C22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=MppbbXzJ0digsWPG2GM5CfCZPDAoLJBBZ6Gid6/7IIQ=;
        b=IQVxVL9kMA3IksZmQOI/XABCczHVKyp4B2XNFaIoJ3e31ay2cTodgS7LVFeA6cvnrO
         27ScJzD28AHRpcXCA3eUtQXhr6h2bY1o/Q0kPs9AIyHcv84uOP+9pmmeJKsMb9Omp/4Z
         4TapjTW1Twv9+vh23w33GmqGC7FRmwYm3DXVOL3/zGBS1Jz1SWd2OiN2aFILQQTpewab
         v0qbCf/mbjU44cQxw0ZDvvio3of7mcQ1L3yguBXSOdwp3CUHP9PbfLDs1tKnrsHIXXhh
         6+7chOvGnymYsYHamOA/SqClq0POMEa31PghQxbDsr2kGWP7Qo/BGdfdiYS5sbHyFDIK
         CLxw==
X-Gm-Message-State: AOAM530g0qIL7/+UN5uF2xHAI+o3LCVm386chRoPcqBjgUSht1reYN3M
        dW3ijKj/DMFrCTn+lCCpWC1UtZLlf1yzMaUnlaScPX5tAK4=
X-Google-Smtp-Source: ABdhPJyWitcjU1huZdzKXmdZw80s+tdef59LlRyoPZKa6eGEnd4p4u5GKbGSijmfhxRcYcjZLGsAjgyNbv4uHDWqUcE=
X-Received: by 2002:a2e:9d8e:: with SMTP id c14mr14212694ljj.477.1612288537179;
 Tue, 02 Feb 2021 09:55:37 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=pK3hQNTvsR-WUmtrQFuKngx+A1iYfd0JXyb0WHqpfKMA@mail.gmail.com>
 <20210202174255.4269-1-aaptel@suse.com>
In-Reply-To: <20210202174255.4269-1-aaptel@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 2 Feb 2021 11:55:26 -0600
Message-ID: <CAH2r5muLRXp_VhaPRVYZNpYoRc9Qpyko9doSmzMm4JgE1bAoSg@mail.gmail.com>
Subject: Re: [PATCH v3] cifs: report error instead of invalid when
 revalidating a dentry fails
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

presumably cc:stable?

On Tue, Feb 2, 2021 at 11:43 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> From: Aurelien Aptel <aaptel@suse.com>
>
> Assuming
> - //HOST/a is mounted on /mnt
> - //HOST/b is mounted on /mnt/b
>
> On a slow connection, running 'df' and killing it while it's
> processing /mnt/b can make cifs_get_inode_info() returns -ERESTARTSYS.
>
> This triggers the following chain of events:
> =3D> the dentry revalidation fail
> =3D> dentry is put and released
> =3D> superblock associated with the dentry is put
> =3D> /mnt/b is unmounted
>
> This patch makes cifs_d_revalidate() return the error instead of
> 0 (invalid) when cifs_revalidate_dentry() fails, except for ENOENT
> where that error means the dentry is invalid.
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> Suggested-by: Shyam Prasad N <nspmangalore@gmail.com>
> ---
>  fs/cifs/dir.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 68900f1629bff..868c0b7263ec0 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -737,6 +737,7 @@ static int
>  cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
>  {
>         struct inode *inode;
> +       int rc;
>
>         if (flags & LOOKUP_RCU)
>                 return -ECHILD;
> @@ -746,8 +747,11 @@ cifs_d_revalidate(struct dentry *direntry, unsigned =
int flags)
>                 if ((flags & LOOKUP_REVAL) && !CIFS_CACHE_READ(CIFS_I(ino=
de)))
>                         CIFS_I(inode)->time =3D 0; /* force reval */
>
> -               if (cifs_revalidate_dentry(direntry))
> -                       return 0;
> +               rc =3D cifs_revalidate_dentry(direntry);
> +               if (rc) {
> +                       cifs_dbg(FYI, "cifs_revalidate_dentry failed with=
 rc=3D%d", rc);
> +                       return rc =3D=3D -ENOENT ? 0 : rc;
> +               }
>                 else {
>                         /*
>                          * If the inode wasn't known to be a dfs entry wh=
en
> --
> 2.29.2
>


--=20
Thanks,

Steve
