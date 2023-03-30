Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F254DC761AF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Mar 2023 22:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjC3W7h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Mar 2023 18:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjC3W7g (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Mar 2023 18:59:36 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FA5DBE3
        for <linux-cifs@vger.kernel.org>; Thu, 30 Mar 2023 15:59:35 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id a44so2590910ljr.10
        for <linux-cifs@vger.kernel.org>; Thu, 30 Mar 2023 15:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680217174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=99+FXi2iFhd1HvRErBbm//dCX166+orgRXWNzsptQwI=;
        b=BvEhigwnZrabRVcVqdsqsqQK9Hek8/DwEsoNNVReH3hld7Y+NAfyxArdTMOBlMMBgs
         dQmw6VflSFEIyUpi90mlFy1nO5q8DWWMc+MzehwpcElHVQiipPP2W+Fpkoj+mbXw3YnS
         Mno5ZKulZ8j3ABN1hCo/TCXGoQaw/7rmecQ9k03hUnE55+kipb5GFbjwb+yzr+8yiFSz
         DwMEHVut2JaqH2Gr2b1dzurWkymt8EA7teBMXMdFqevZlr0vm9fWS5x8XlhWTHZjwSvK
         4d4ChqMwriDth90I4ndxnTZ24jFkobPzTjIiLUAV/UiY8RG5D1W8lEa8M6SBjG14R2Lt
         MIRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680217174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=99+FXi2iFhd1HvRErBbm//dCX166+orgRXWNzsptQwI=;
        b=dCZjJlJ7iymdmxBH9W9x71tiI/QxkKBR2mKEnX62aiFcKq9SdCQ+8ZoP7muveuJQ5e
         oiAImNfl9oGNLhS1yGf5/gnnUxDMJHN06ebnKLYaUkuwgsBE0kxUcHhxmi4pftnKGosv
         PBl9KCCRaWClHxrMvWfLZKWUAmhzScb3e55xbLiVlxBjnahAF6w28oBYub3Nzm4t/rg5
         4T2rRDs+Bt8nznCG21mMYrjguPhmZBjIVq/nULkTk4nMgmahZi1VwkoaehgBDiw5kkvy
         TmmDy7zPnb4SncV0rf6yV42Rj7ijkYgXG5oGB91cIaU+ZZSt5KK0wwODNSU0ztMuNPNA
         ydiw==
X-Gm-Message-State: AAQBX9eE7Tko162IWEX7F1fLK6zowrkqFbmO4fNYjhGgWHEGn0608fPW
        oeegLdlUkPmqHjeHHOXZcIkAmY/kjVJk1q50rhkbNUYEQfQ=
X-Google-Smtp-Source: AKy350YV7HzktZhbhVOYq85RKrl2hq65fVz1xBdFKS2l6/Y6IqrGHI8/BSkZrrW+ggmWYzUaSbKky5l8Rk2BPoY033k=
X-Received: by 2002:a2e:84c1:0:b0:2a5:f850:c356 with SMTP id
 q1-20020a2e84c1000000b002a5f850c356mr4955044ljh.2.1680217173808; Thu, 30 Mar
 2023 15:59:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230329201423.32134-1-pc@manguebit.com> <20230329201423.32134-4-pc@manguebit.com>
In-Reply-To: <20230329201423.32134-4-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 30 Mar 2023 17:59:22 -0500
Message-ID: <CAH2r5mtrU30K+45rG2X6++A+3+izGHcS8whWJVUCgvNQFwtz4w@mail.gmail.com>
Subject: Re: [PATCH 4/5] cifs: prevent infinite recursion in CIFSGetDFSRefer()
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added cc:stable and added ronnie's RB and merged into cifs-2.6.git for-next

On Wed, Mar 29, 2023 at 3:14=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> We can't call smb_init() in CIFSGetDFSRefer() as cifs_reconnect_tcon()
> may end up calling CIFSGetDFSRefer() again to get new DFS referrals
> and thus causing an infinite recursion.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/cifs/cifssmb.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index c9d57ba84be4..0d30b17494e4 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4382,8 +4382,13 @@ CIFSGetDFSRefer(const unsigned int xid, struct cif=
s_ses *ses,
>                 return -ENODEV;
>
>  getDFSRetry:
> -       rc =3D smb_init(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc, (void **=
) &pSMB,
> -                     (void **) &pSMBr);
> +       /*
> +        * Use smb_init_no_reconnect() instead of smb_init() as
> +        * CIFSGetDFSRefer() may be called from cifs_reconnect_tcon() and=
 thus
> +        * causing an infinite recursion.
> +        */
> +       rc =3D smb_init_no_reconnect(SMB_COM_TRANSACTION2, 15, ses->tcon_=
ipc,
> +                                  (void **)&pSMB, (void **)&pSMBr);
>         if (rc)
>                 return rc;
>
> --
> 2.40.0
>


--=20
Thanks,

Steve
