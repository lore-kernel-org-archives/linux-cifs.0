Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A34C4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Nov 2023 03:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjKADag (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Oct 2023 23:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjKADae (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Oct 2023 23:30:34 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEDFB9
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 20:30:31 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-507b96095abso9120977e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 20:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698809430; x=1699414230; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1w+A+Y7vAyEUSxzUUH3ttu6AnCktzZEmWLeostJbBXM=;
        b=Z5acprlBm8mHTSDIzSoRhDT0r2boN+27qTglVAmIYxow/Lcu9TI98A92okAbX+C7m4
         JRc2XXe7jUmjQoq7Ox9NNqGV3RiCsl143iFCiyH52BK6HgMnUHNw1vf9t/GuKjWZYScR
         IfKAi5IngJhzBNYBo12u5iLH1QcleYC55Fyb0ECUGBl9a5tZFK0+fFgIPvIbMgvScpSB
         XnnpDXbIWyfyQ+FGGFYu7QPSZLLamO86IHZi9ThEiJaqiwMDQpo80Yiyztc9YRELCG2/
         +bX+XQ2kxwjc4VlipPttEebVA/mMItZyMIQ8+aVuUVMWr/DwasDuneNE7MV+qPbIESP+
         SveA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698809430; x=1699414230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1w+A+Y7vAyEUSxzUUH3ttu6AnCktzZEmWLeostJbBXM=;
        b=Iqic2OhXro7Q6m4qP/P8qMB0swixyc3klaZmrrwzUE7zg2uHFnOnudP3qI5cpYikvq
         TlqTnJbxwtYoMtM6os3EMRC+Qj1MFct6Iac9jLGXYXWI7K3YMacYDuqnL8XX0jOflYQF
         RSJwXw2+rrOcVqON+79z5+9VVjqWYjy6+R+yl3JVZzpzf2oFT9vMP6r2yYmHw0mAyqZB
         1omyb1n6yRnRCqxULE9cCC+f5y0EiuvmsQhnPaZEDLA4QsAQ/8Bbw1VCqLYIIUUfD596
         s/aslZogWYwvkziKNsRdjOY4Avw8Jlc3zYzLW5kktkzxEV+sXNf05DpGk9gS8hKPKDNt
         KVfA==
X-Gm-Message-State: AOJu0Yw8UfLeb4ZxZC+2rq7W2onkIbMrFBMuRIfWCQtFO2r493uO0QWV
        Hbem1pCmo24rwOx+if3lo/B/yLARvmJwXmtwVAA=
X-Google-Smtp-Source: AGHT+IFjq/TuOC4saa2EKikrUIsEW9tCElB+OWcXxVjA+DeundYIFdB0Ptb0k4n+yNmdZKUzvyLcNEhl2Mt1YfsFxrs=
X-Received: by 2002:a05:6512:2345:b0:507:a766:ad29 with SMTP id
 p5-20020a056512234500b00507a766ad29mr13604932lfu.12.1698809429122; Tue, 31
 Oct 2023 20:30:29 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-9-sprasad@microsoft.com>
In-Reply-To: <20231030110020.45627-9-sprasad@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 Oct 2023 22:30:17 -0500
Message-ID: <CAH2r5mvHPRjWwY9vVaFtEiOHh87vttNCUnkGpx3tH+XsXyMiFw@mail.gmail.com>
Subject: Re: [PATCH 09/14] cifs: add a back pointer to cifs_sb from tcon
To:     nspmangalore@gmail.com
Cc:     pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next pending more testing

added cc:stable

On Mon, Oct 30, 2023 at 6:00=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Today, we have no way to access the cifs_sb when we
> just have pointers to struct tcon. This is very
> limiting as many functions deal with cifs_sb, and
> these calls do not directly originate from VFS.
>
> This change introduces a new cifs_sb field in cifs_tcon
> that points to the cifs_sb for the tcon. The assumption
> here is that a tcon will always map to this cifs_sb and
> will never change.
>
> Also, refcounting should not be necessary, since cifs_sb
> will never be freed before tcon.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsglob.h | 1 +
>  fs/smb/client/connect.c  | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 81e7a45f413d..cdbc2cd207dc 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1134,6 +1134,7 @@ struct cifs_tcon {
>         int tc_count;
>         struct list_head rlist; /* reconnect list */
>         spinlock_t tc_lock;  /* protect anything here that is not protect=
ed */
> +       struct cifs_sb_info *cifs_sb; /* back pointer to cifs super block=
 */
>         atomic_t num_local_opens;  /* num of all opens including disconne=
cted */
>         atomic_t num_remote_opens; /* num of all network opens on server =
*/
>         struct list_head openFileList;
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 8393977e21ee..184075da5c6e 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -3355,6 +3355,7 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_=
ctx)
>                 tcon =3D NULL;
>                 goto out;
>         }
> +       tcon->cifs_sb =3D cifs_sb;
>
>         /* if new SMB3.11 POSIX extensions are supported do not remap / a=
nd \ */
>         if (tcon->posix_extensions)
> @@ -3986,6 +3987,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, k=
uid_t fsuid)
>                 cifs_put_smb_ses(ses);
>                 goto out;
>         }
> +       tcon->cifs_sb =3D cifs_sb;
>
>  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>         if (cap_unix(ses))
> --
> 2.34.1
>


--=20
Thanks,

Steve
