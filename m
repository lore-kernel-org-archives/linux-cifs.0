Return-Path: <SRS0=Q1a1=5W=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A351BC2BA1E
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Apr 2020 17:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D1DB249EE
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Apr 2020 17:22:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XPqMvXMI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgDFRW0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Apr 2020 13:22:26 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35886 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728634AbgDFRWZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Apr 2020 13:22:25 -0400
Received: by mail-lf1-f68.google.com with SMTP id w145so141151lff.3
        for <linux-cifs@vger.kernel.org>; Mon, 06 Apr 2020 10:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aPWG9aIZxcay74FMe2pK/iu8HzjV+pnfsXrf5PChzT8=;
        b=XPqMvXMImntCL5NV+40lU8HprFvIlxVupOmZChWicpKUcGqcp/iehCZapr+fAzL86f
         uAtBdAuOGZn+dSynv+1/sQ3/03zv5kvF6Sg6A3Wc433z3WCcQC7LvlfQrB9ev2qeib3A
         NbRAnHkU311h9DM6NuI1RQ5MkVilhR6uXxKTWRORmiQ5Jq87KXrRvwlraATbS5JIUw5O
         TcdH7266CU48mTzD1CwXGv8n9jzi1uSyeBJLim1UsBL/w9029VhtTvd2sOSaQQWL6RZC
         XKl7okPXDNrf+Wh42+xRbyD3AXQ/D8Cm1DqGsmeLeAcpTfEMq6YW7vWcHVVHb08kuVOw
         gDQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aPWG9aIZxcay74FMe2pK/iu8HzjV+pnfsXrf5PChzT8=;
        b=cqVsrujdOGFRkuBt1lPOR+HpBYddfIr8dCoPfP8++wRVamnBZ4FCQQ3zdwEtdOwBES
         OH38V7AVSUNC5q9V7j8tUxNm9+YkO66q2yhglpYh1Gx9Wi4HB/dxp5mHnXqdYFcKXkcD
         X+2YytdUjgwyQ5b7fzwV1UtGovlp21cmczzEATCI0RHqAjPQkhB6WEHQE/mhY/SUSBfv
         m2/mmXH/CcxAWc18uWMUfa+8EQZf1CpsHuwmYKf5C2z74+CyrcdnuEHxNAXK6zAFJNRd
         PRccUoDsgLA1kYlbwwpTur+vxxE3Z+mS2FcgcVc3IWv/UiyMOM2ZIljQlVoBrrsaVUHV
         +W5g==
X-Gm-Message-State: AGi0PuZjI+59WRzecNiINT7ZsgjYvPozU4WgedLWM1DsXGAwLXDv6o+B
        uhbcPmaj9NM3v9arUwpBWZbDSfKkKf7YBJEi1Q==
X-Google-Smtp-Source: APiQypKrT9eSxffsriPueG28xKsd1ITtiZhpSbNWw4tZyvESu71wQEfXnS/3Qxr6iwblLckS3cTpi8hl6ohACBzwRWg=
X-Received: by 2002:ac2:54ba:: with SMTP id w26mr6650341lfk.22.1586193742322;
 Mon, 06 Apr 2020 10:22:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200406113426.20699-1-aaptel@suse.com>
In-Reply-To: <20200406113426.20699-1-aaptel@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 6 Apr 2020 10:22:10 -0700
Message-ID: <CAKywueQ=N70sRytDR5PeeHiL1rRH9SfKOV23SdNchs4eWDmzmg@mail.gmail.com>
Subject: Re: [PATCH v3] cifs: ignore cached share root handle closing errors
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

=D0=BF=D0=BD, 6 =D0=B0=D0=BF=D1=80. 2020 =D0=B3. =D0=B2 04:34, Aurelien Apt=
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
> changes since v2:
> * add WARN_ONCE
> * show server hostname & tid
> * VFS -> FYI
>
>  fs/cifs/smb2misc.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 0511aaf451d4..cfa57e3ad352 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -766,6 +766,21 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, =
__u64 persistent_fid,
>
>         cifs_dbg(FYI, "%s: tc_count=3D%d\n", __func__, tcon->tc_count);
>         spin_lock(&cifs_tcp_ses_lock);
> +       if (tcon->tc_count <=3D 0) {
> +               const char *host =3D "(null)";
> +
> +               WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative"=
);
> +               spin_unlock(&cifs_tcp_ses_lock);
> +
> +               if (tcon->ses && tcon->ses->server
> +                   && tcon->ses->server->hostname)
> +                       host =3D tcon->ses->server->hostname;
> +
> +               cifs_dbg(FYI, "\\\\%s tid=3D%u: tcon is closing, skipping=
 async close retry of fid %llu %llu\n",
> +                        host, tcon->tid, persistent_fid, volatile_fid);

You can use cifs_server_dbg() directly - it is adding prefix with
server name automatically, you just need a server variable in the
calling function.

> +
> +               return 0;
> +       }
>         tcon->tc_count++;
>         spin_unlock(&cifs_tcp_ses_lock);
>
> --
> 2.16.4
>


--
Best regards,
Pavel Shilovsky
