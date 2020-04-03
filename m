Return-Path: <SRS0=FgSA=5T=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8B8C43331
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Apr 2020 18:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D30ED206F5
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Apr 2020 18:04:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EQkVykhi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404111AbgDCSEm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Apr 2020 14:04:42 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35700 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728552AbgDCSEm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Apr 2020 14:04:42 -0400
Received: by mail-lj1-f196.google.com with SMTP id k21so7934246ljh.2
        for <linux-cifs@vger.kernel.org>; Fri, 03 Apr 2020 11:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zdFz49in2yhNLSYJJfmzEbFBG0zgUKBdrFx3Q3OW1BE=;
        b=EQkVykhiKD9hjNLXv7YImMoHsli241EM8nEBEZEumhgxAKtaz7Va6/or84xnnpnob4
         9g5xdotNJXp8y3ZUrYS2t1HjtWTeSLVQsEru5RH7LGzxfcEG15UCHqRUPIaMYZuVKHbQ
         v0iuDApsgz5y+pDGw2G/8xaVw1mKJDG6Z6tLid0j5xjbPoWSthmupY4kCLrharH2XOB4
         lHy1jtIN7Sem/IqESwgppRgwXU0xJq4JrKxvzcebc1mK5ZbpQV6AsiZuRRQLa4ZbDPXf
         +IKqYyiOZr2fcqBHZVELbSaaCX/qO6WUUbEvSugWdoHLVoNWBLimydjwDkOjALOeOjW0
         kfFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zdFz49in2yhNLSYJJfmzEbFBG0zgUKBdrFx3Q3OW1BE=;
        b=qnwQFHnM80hT1zMdjcUZzsmMGn0pBP0eAR3uw1piRR3WXqoUgyx0LNhu7WhdBlJiV5
         H7DH9ljlRO37zVAEXYZJDl/lH3LrLzCI8dWMwGxwZhvfpm0GDtPfd4Yw0R51lZePjmKh
         O1c+F7XvXxqKkh824R9MVrl9Rkg+yQf5ATTICsrumVIX8vqSaqYoj+Z2f5bYFxK4NaWQ
         Oh962sZSSZ6ugwGEvJ9sY+0uRGKXQPZJa/75CbkVjI+TsY1uQ+ce8c4GJAi/YY1Ejk6N
         /bTuKFcuP3lFWSLhRAJeXEL7ICsf0UAvzwTFBn2uowbho9lPIAv2fCigc3gj2RRY5AXn
         BcVw==
X-Gm-Message-State: AGi0PubCBbE9/L5v6TXRBNLvH1Kr3aib3sKtAwRHbHCL0SzIaiFAEfXL
        +hVqEF+I2GPZ3k7E4eWkv9C9FTcS5HXRvyJdW20+tf8=
X-Google-Smtp-Source: APiQypIT6VqjD/fWzEOwvQw1LN2F36YAgLx4jtxgTliMAkNXlYafQiR20R7yPUYMcgo3Qe8zOhRgbOq+u4MyREYyc6g=
X-Received: by 2002:a2e:914b:: with SMTP id q11mr5488756ljg.291.1585937080729;
 Fri, 03 Apr 2020 11:04:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200401125026.4899-1-aaptel@suse.com>
In-Reply-To: <20200401125026.4899-1-aaptel@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 3 Apr 2020 11:04:29 -0700
Message-ID: <CAKywueSjjN+w6v76BSNLW4EFmSi4WAma4XTL2H2xQYhnes63+g@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: ignore cached share root handle closing errors
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 1 =D0=B0=D0=BF=D1=80. 2020 =D0=B3. =D0=B2 05:50, Aurelien Apt=
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
> * If closing a handle is interupted, SMB2_close() will
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
>     close_shroot_lease_locked =3D> if cached root has lease && refcount r=
each 0
>      smb2_close_cached_fid    =3D> if cached root valid
>       SMB2_close              =3D> retry close in a worker thread if inte=
rrupted
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
> ---
>  fs/cifs/smb2misc.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 0511aaf451d4..965276aeffcf 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -766,6 +766,12 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, =
__u64 persistent_fid,
>
>         cifs_dbg(FYI, "%s: tc_count=3D%d\n", __func__, tcon->tc_count);
>         spin_lock(&cifs_tcp_ses_lock);
> +       if (tcon->tc_count <=3D 0) {
> +               spin_unlock(&cifs_tcp_ses_lock);
> +               cifs_dbg(VFS, "tcon is closing, skipping async close retr=
y of fid %llu %llu\n",

Thanks for a good catch! Some suggestions below:

- Why VFS? Share is being disconnected anyway, so all associated
handles should be closed by the server eventually. I think FYI is
sufficient here.
- cifs_dbg_server may be better than cifs_dbg and please include tcon
ID here otherwise FIDs may be meaningless if there are several shares
mounted on a host.
- May be WARN_ONCE if tc_count is negative since it is a possible bug?

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
