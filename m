Return-Path: <SRS0=IUEB=5X=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27744C2BA80
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Apr 2020 16:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1D2520771
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Apr 2020 16:17:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DEDVa2nT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgDGQRv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Apr 2020 12:17:51 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43788 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbgDGQRu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Apr 2020 12:17:50 -0400
Received: by mail-lj1-f194.google.com with SMTP id g27so4354174ljn.10
        for <linux-cifs@vger.kernel.org>; Tue, 07 Apr 2020 09:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=geopfqS8ibKYILySOnbN22cU+cp39KoYhQDtOXDWF1Y=;
        b=DEDVa2nTDysY/kTUAVaQ9M2bnNwBLPmUbw//QPRaEnEkQBGZNThilxch2bonSTJ5Gx
         +o+OrjIZXw7tAeQsRxt50prIzMVFRS44iV3K0VQw/Ei1v2ByfCvmzcwENm5XcnQXsSR9
         EZD0y0NuWmNlrjg/W+K0knkMOVS+4uz2zZBgYxqAn0Ai9NngEExRSp3Q8cOs/A+4yNtm
         rGJeDJukzmpXi1RTNrvenAxFd/lwO/La3kwslD51iX+8YU+haSXUrx0bNoLHPqXnk2LZ
         xMrvDssx0K8aYVWrRSxk1XAz8mkdqt6K/LWj8Px8w/GmoxiVn8BqrPngK008dtVTNOyc
         jI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=geopfqS8ibKYILySOnbN22cU+cp39KoYhQDtOXDWF1Y=;
        b=KsBGTumyYImJAHvxTSbK5jR3/lEUlV6DJumNfRi9TJrZftr21gvm32ArM/PqSU6Y6K
         /WVwHBslwhqmznkzyvjijlHE2UrG9FdjSegz/HHe0JD0MXAZpR2yZzGCOpQDLAjc6VMo
         409etkzyKVR1zuwY8kcdc/EPGnf57ii7CvUVeBLtCUG9HdTpmDCeCAjS6J7OC5WW45F0
         Y8L0U3b/g4Vlqr7FDNdhYRCwlbYtH2vy0MxpC+rOqroszZ5sk0InmiRB5ahGgmj984O5
         UvS0xJ8M56DsOkqCgntY3ThwVIp4ykpyRF2LVpCcAi7Ql/J7epaT+P0bFtlI7tbPwKDB
         nifw==
X-Gm-Message-State: AGi0PuZO23r4ccHXPGeHlU0PsOdvPMnRlUq79/KtcG/1hS9QDQE1F1GN
        gqb81Sh9wy/wqC13uNBDb4gMxB1Wsnz1MQ4pug==
X-Google-Smtp-Source: APiQypJeECp7bsBnlsfhjWDYcHQlfjW464UiSkpgYUGQsJTNk9xzRgvhj1YpKjotUvmoSSMWY+SCy0cL3ahGS3x+TB8=
X-Received: by 2002:a2e:8652:: with SMTP id i18mr2325378ljj.265.1586276268290;
 Tue, 07 Apr 2020 09:17:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAKywueQ=N70sRytDR5PeeHiL1rRH9SfKOV23SdNchs4eWDmzmg@mail.gmail.com>
 <20200407094955.12956-1-aaptel@suse.com>
In-Reply-To: <20200407094955.12956-1-aaptel@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 7 Apr 2020 09:17:36 -0700
Message-ID: <CAKywueRie1aexL3cBjCrtY2J53+tV5Fh+vR_kwNGxY0BFgVcyg@mail.gmail.com>
Subject: Re: [PATCH v4] cifs: ignore cached share root handle closing errors
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 7 =D0=B0=D0=BF=D1=80. 2020 =D0=B3. =D0=B2 02:50, Aurelien Apt=
el <aaptel@suse.com>:
>
> Fix tcon use-after-free and NULL ptr deref.
>
> Customer system crashes with the following kernel log:
>
> [462233.169868] CIFS VFS: Cancelling wait for mid 4894753 cmd: 14       =
=3D> a QUERY DIR
> [462233.228045] CIFS VFS: cifs_put_smb_ses: Session Logoff failure rc=3D-=
4
> [462233.305922] CIFS VFS: cifs_put_smb_ses: Session Logoff failure rc=3D-=
4
> [462233.306205] CIFS VFS: cifs_put_smb_ses: Session Logoff failure rc=3D-=
4
> [462233.347060] CIFS VFS: cifs_put_smb_ses: Session Logoff failure rc=3D-=
4
> [462233.347107] CIFS VFS: Close unmatched open
> [462233.347113] BUG: unable to handle kernel NULL pointer dereference at =
0000000000000038
> ...
>     [exception RIP: cifs_put_tcon+0xa0] (this is doing tcon->ses->server)
>  #6 [...] smb2_cancelled_close_fid at ... [cifs]
>  #7 [...] process_one_work at ...
>  #8 [...] worker_thread at ...
>  #9 [...] kthread at ...
>
> The most likely explanation we have is:
>
> * When we put the last reference of a tcon (refcount=3D0), we close the
>   cached share root handle.
> * If closing a handle is interrupted, SMB2_close() will
>   queue a SMB2_close() in a work thread.
> * The queued object keeps a tcon ref so we bump the tcon
>   refcount, jumping from 0 to 1.
> * We reach the end of cifs_put_tcon(), we free the tcon object despite
>   it now having a refcount of 1.
> * The queued work now runs, but the tcon, ses & server was freed in
>   the meantime resulting in a crash.
>
> THREAD 1
> =3D=3D=3D=3D=3D=3D=3D=3D
> cifs_put_tcon                 =3D> tcon refcount reach 0
>   SMB2_tdis
>    close_shroot_lease
>     close_shroot_lease_locked =3D> if cached root has lease && refcount =
=3D 0
>      smb2_close_cached_fid    =3D> if cached root valid
>       SMB2_close              =3D> retry close in a thread if interrupted
>        smb2_handle_cancelled_close
>         __smb2_handle_cancelled_close    =3D> !! tcon refcount bump 0 =3D=
> 1 !!
>          INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
>          queue_work(cifsiod_wq, &cancelled->work) =3D> queue work
>  tconInfoFree(tcon);    =3D=3D> freed!
>  cifs_put_smb_ses(ses); =3D=3D> freed!
>
> THREAD 2 (workqueue)
> =3D=3D=3D=3D=3D=3D=3D=3D
> smb2_cancelled_close_fid
>   SMB2_close(0, cancelled->tcon, ...); =3D> use-after-free of tcon
>   cifs_put_tcon(cancelled->tcon);      =3D> tcon refcount reach 0 second =
time
>   *CRASH*
>
> Fixes: d9191319358d ("CIFS: Close cached root handle only if it has a lea=
se")
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/smb2misc.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 0511aaf451d4..497afb0b9960 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -766,6 +766,20 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, =
__u64 persistent_fid,
>
>         cifs_dbg(FYI, "%s: tc_count=3D%d\n", __func__, tcon->tc_count);
>         spin_lock(&cifs_tcp_ses_lock);
> +       if (tcon->tc_count <=3D 0) {
> +               struct TCP_Server_Info *server =3D NULL;
> +
> +               WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative"=
);
> +               spin_unlock(&cifs_tcp_ses_lock);
> +
> +               if (tcon->ses)
> +                       server =3D tcon->ses->server;
> +
> +               cifs_server_dbg(FYI, "tid=3D%u: tcon is closing, skipping=
 async close retry of fid %llu %llu\n",
> +                               tcon->tid, persistent_fid, volatile_fid);
> +
> +               return 0;
> +       }
>         tcon->tc_count++;
>         spin_unlock(&cifs_tcp_ses_lock);
>
> --
> 2.16.4
>

Looks good, thanks!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
