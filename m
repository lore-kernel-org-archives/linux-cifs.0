Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFC1EB64D9
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Jun 2023 04:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjFSEyb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Jun 2023 00:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjFSEya (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Jun 2023 00:54:30 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFC7E44
        for <linux-cifs@vger.kernel.org>; Sun, 18 Jun 2023 21:54:29 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4f004cc54f4so3821908e87.3
        for <linux-cifs@vger.kernel.org>; Sun, 18 Jun 2023 21:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687150467; x=1689742467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VGlmGAQALcp4eo1vI6XOkbJUMqo5iwO8RiEPk7UYslY=;
        b=c9SYO2Z1o9NMGalKWAP1jZyjviUeEpwMM3Jl8OhSqIH/9wXBkwcFctW7yQ3zGSAc22
         /8H0beKF4Nz/jUxuMgsree8BwDu76lRLABtgi/OEGATAv/yo6W8b2qt2sE0TzEWtquB0
         RjZHwJcp4lMf0kfGxEekYJjjcuDvMBNVolLCOpz6QEvoGyxVSh3OB6Qts+/noc0QTH1C
         ksH1tlt9fytzlGsTMSmPikO4yDJPkK9VX+Ekmn+rzvNh0jnvg8Wb4tT8yL4YYsbJ8vVg
         EgSY47epVJK0amAf34Oh+5E9k7Ov5UGkc1+zd76t5zEl2sVVlpeh7GrftNpv3kfZ87Ny
         KmeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687150467; x=1689742467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VGlmGAQALcp4eo1vI6XOkbJUMqo5iwO8RiEPk7UYslY=;
        b=PQchMLF99ympprR68r56vL2IksNW04khMRuB70/CquLZMh8gJ+dJ7026z2SUnaNWup
         f4L1aUTvFXe0BAqcifREZxw2GOIfMxV/DxyRKzrfGgu9IYjlVYuAKVVES0smbkQ7oX3Y
         j8gxBkDmxOexClkNWTcsXxPF0wkLka8rc8/T7WbwRisRm/5jpefgLmavDrT5KPiZUOI9
         5BJa232V/JG8I5AP98pjqBgz/AGF3HBBneRxF7BrCrlUIMHBL668iGMLeGaL7E+AA1eg
         gij51n/GeQXOG2QMvFdgf50Yp2uOtBSHWZfDt0d9g/ShPpEaRwWEA3cDTZQW6UZyEZXA
         VamA==
X-Gm-Message-State: AC+VfDykWlBNQ7wtQwRUUpZVvThU05BTwRZC9WFx9nMu+/00Lda08REo
        K5NIbFVC3lwpMt8kuZLfVSWDYaf/4FpnlJhm+24=
X-Google-Smtp-Source: ACHHUZ7MScB/6waDl1Eo+D9bJNo95nz+Uqe5RVFCAX7AAyegtrZx9HG5JrdSPiy8dVvzsOIdWLkVDfDVnu809sysPBA=
X-Received: by 2002:a2e:848a:0:b0:2b4:6c76:332f with SMTP id
 b10-20020a2e848a000000b002b46c76332fmr2484898ljh.9.1687150467183; Sun, 18 Jun
 2023 21:54:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230619033436.808928-1-bharathsm@microsoft.com>
In-Reply-To: <20230619033436.808928-1-bharathsm@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 18 Jun 2023 23:54:16 -0500
Message-ID: <CAH2r5msQ_FXVuhhp6FzeVr3rVR5pw=_dQ2da=k+jtqqpouKWZg@mail.gmail.com>
Subject: Re: [PATCH] SMB3: Do not send lease break acknowledgment if all file
 handles have been closed
To:     Bharath SM <bharathsm.hsk@gmail.com>
Cc:     sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        bharathsm@microsoft.com, nspmangalore@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending more testing

On Sun, Jun 18, 2023 at 10:57=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.co=
m> wrote:
>
> In case if all existing file handles are deferred handles and if all of
> them gets closed due to handle lease break then we dont need to send
> lease break acknowledgment to server, because last handle close will be
> considered as lease break ack.
> After closing deferred handels, we check for openfile list of inode,
> if its empty then we skip sending lease break ack.
>
> Fixes: 59a556aebc43 ("SMB3: drop reference to cfile before sending oplock=
 break")
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/file.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 051283386e22..b8a3d60e7ac4 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -4941,7 +4941,9 @@ void cifs_oplock_break(struct work_struct *work)
>          * not bother sending an oplock release if session to server stil=
l is
>          * disconnected since oplock already released by the server
>          */
> -       if (!oplock_break_cancelled) {
> +       spin_lock(&cinode->open_file_lock);
> +       if (!oplock_break_cancelled && !list_empty(&cinode->openFileList)=
) {
> +               spin_unlock(&cinode->open_file_lock);
>                 /* check for server null since can race with kill_sb call=
ing tree disconnect */
>                 if (tcon->ses && tcon->ses->server) {
>                         rc =3D tcon->ses->server->ops->oplock_response(tc=
on, persistent_fid,
> @@ -4949,7 +4951,8 @@ void cifs_oplock_break(struct work_struct *work)
>                         cifs_dbg(FYI, "Oplock release rc =3D %d\n", rc);
>                 } else
>                         pr_warn_once("lease break not sent for unmounted =
share\n");
> -       }
> +       } else
> +               spin_unlock(&cinode->open_file_lock);
>
>         cifs_done_oplock_break(cinode);
>  }
> --
> 2.34.1
>


--=20
Thanks,

Steve
