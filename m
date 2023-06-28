Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CA9EB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jun 2023 03:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbjF1DvW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 23:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjF1DvU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 23:51:20 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9068E2D75
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 20:51:19 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4fb5bcb9a28so4822551e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 20:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687924278; x=1690516278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eSKTTTgyXKeDCVzR/GXnDTyTU8ahYX/IPrhkvfaKMSk=;
        b=IEMafbePa1CpIHuhbjAZ1LqO2Z/voep6zST9NJ5domNbnFrXHbprPJLHF5NOx252uX
         +ZSe9a2tHdN3hd4NsKQi/Da1o8J5nu6cp6DUjYYtSjsWsJn0cyFVNiwUcyPlmBD7X3m4
         zERSxzEuit7Ek715kCeEq4/LrM84O8x2OPr2cxEBuKnrirkk6bdwEJtB/hI9eWyhfqK2
         A0+1/JnXpQjbmsRSzV96g6eESRzwYfKLNtnCOFmA4PQij/QCJZ+3DHktXyyjcHhZjDij
         AWQ4Mj2kCnIoNtmKGYWLDXhOVkH+d4xVUivdnx+JcF0Vg4EwEFWSDCdkrIxMzFvgcDfm
         OPag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687924278; x=1690516278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eSKTTTgyXKeDCVzR/GXnDTyTU8ahYX/IPrhkvfaKMSk=;
        b=FJ+NH5jIXQiEItsy2a7PiIiBFCFC0pKTlRvDfjMnep5ZjpzojHAd9EkCbBOab+r8Sr
         R6xIGfIGhwBFPiuDrKWqMPAIzxprlsJmzWM6gWVSiOKdOYgSYK8I66ZX/5SxkiR2210B
         doD1OgcbU4P0DqOevvvYLH6Htwd7jULOd6EA2aAi6I5obGIRdr9DQ/JIxaLJfL9Uns2L
         ssx1vu30JK81ns10SRG0x7kFtumkJG8og20BOnPUdPnlqIFyVDOxBimKWlrbaPl9q14T
         U1uu9hpOhlzDMpEXrGIfBeNeUx+msRobta1rrqJr6B+Eu5f+IFEyC3GNwhoNZMhII103
         9Y4Q==
X-Gm-Message-State: AC+VfDyWJKoLeS1WYEn3hFZw+fqxJMU2+6JGjOwZjBO6vEwgygX5u9Um
        vigrDyJDNbaEOPZKgWSRXOdf1YZ7p82V077gH2zgPPXt
X-Google-Smtp-Source: ACHHUZ6iutdNdukIvf0MoMun4t0kjBIIuDf1FzQrpRIGxWQkzducKNlCBFi7T/cX8e/qlDfzPQQ+T/BiL+nv1XR77Rc=
X-Received: by 2002:a05:6512:401e:b0:4f9:a232:f09c with SMTP id
 br30-20020a056512401e00b004f9a232f09cmr7235685lfb.63.1687924277521; Tue, 27
 Jun 2023 20:51:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230628002450.18781-1-pc@manguebit.com> <20230628002450.18781-4-pc@manguebit.com>
In-Reply-To: <20230628002450.18781-4-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 27 Jun 2023 22:51:06 -0500
Message-ID: <CAH2r5muvsac+DCRu3GPaqzBzA4earezeubGvwE5hZEDoKHDtBg@mail.gmail.com>
Subject: Re: [PATCH 4/4] smb: client: improve DFS mount check
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged all 4 into cifs-2.6.git for-next pending additional
review and testing

On Tue, Jun 27, 2023 at 7:25=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Some servers may return error codes from REQ_GET_DFS_REFERRAL requests
> that are unexpected by the client, so to make it easier, assume
> non-DFS mounts when the client can't get the initial DFS referral of
> @ctx->UNC in dfs_mount_share().
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/smb/client/dfs.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
> index afbaef05a1f1..a7f2e0608adf 100644
> --- a/fs/smb/client/dfs.c
> +++ b/fs/smb/client/dfs.c
> @@ -264,8 +264,9 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, b=
ool *isdfs)
>         if (!nodfs) {
>                 rc =3D dfs_get_referral(mnt_ctx, ctx->UNC + 1, NULL, NULL=
);
>                 if (rc) {
> -                       if (rc !=3D -ENOENT && rc !=3D -EOPNOTSUPP && rc =
!=3D -EIO)
> -                               return rc;
> +                       cifs_dbg(FYI, "%s: no dfs referral for %s: %d\n",
> +                                __func__, ctx->UNC + 1, rc);
> +                       cifs_dbg(FYI, "%s: assuming non-dfs mount...\n", =
__func__);
>                         nodfs =3D true;
>                 }
>         }
> --
> 2.41.0
>


--=20
Thanks,

Steve
