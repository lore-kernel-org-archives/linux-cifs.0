Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8299C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 10:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 917066113A
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 10:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhJEKPi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 06:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbhJEKPa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 06:15:30 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04685C061753
        for <linux-cifs@vger.kernel.org>; Tue,  5 Oct 2021 03:13:38 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id 66so6726961vsd.11
        for <linux-cifs@vger.kernel.org>; Tue, 05 Oct 2021 03:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mk0S2v/SneqQ/XV3M+A6gCZAs7bjUDuYCpmH1grwiVM=;
        b=nm1B+D/1YTBK7QKRA5tofTKvV0yb5TNw7VmUMAkip0atcYNXtDaki7uwf+BNuqYxX7
         TNiUaFbGXLMTJrLJjvm5HfuP9PQevZ5XBH4WtZDz5ZG9+oKdbGvKxYyd2exAOlRuQ5fx
         +yXElLZQcBw+71VhKoLMrH3RcyCbm5Vy5XZfUBgw0ajhck2iPa2CIU2HR9sDW6Cs35TA
         Av+Vh1dBafxdyEM952sY4pf/6JJra8mjmw8MTuIVzgX0nrub6jVUMobiJFyIYIVqAd+t
         khEtcgjuAPVovH0ZkFWCfhvqnHj1IIWGA778kqLWCUT4c4H9YQ84wfytZZ81dpwIL+gV
         a2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mk0S2v/SneqQ/XV3M+A6gCZAs7bjUDuYCpmH1grwiVM=;
        b=vmhWmUIYlExDdxLVC0e9I6Zq/gFI4V52XClro1BLj+W+jv/ZszFD70uqjQqyFWWkTH
         SfsM2HzEdGMEY3eghtUn2tbUY9ebqk2d7cIO2uanDJ7XQi2Mt7XPoKHcTAk0fKx4eaN5
         sC3JeS0rizHzdw1st1g14lxhU/rlGYxN3FxArb0dBfcBYdxc2M3Go1fMz9pxgwqM/nHw
         EXPpN51rCTDshuGUL/1pqM0rmFObJSVjhvob9VeQ5o3SKsmoXbIQFUKKW1xGvv732578
         dSjxtQandG+eJvOBygoYPSit2haQOXmlZuu+TaU+ipmMJmyw1a+c05naWtSo+1nXC8VG
         rZtw==
X-Gm-Message-State: AOAM532tAcqGtyVJEbR8tY2TPvCR+KMSFU1Ec2Vzm+Dzk8gt5rU306AJ
        EP2T+kYXPUikG/bWaGOKcZBmoXID5DEgXOyvBRM=
X-Google-Smtp-Source: ABdhPJwpOW9pfImIRlYmy4o1Abs+q2mKjHoVcChMoZ5f/Y5g/0oXKB8mBJVWbJe/+4P/Z3cWumuxmgWrjh63uFodXHQ=
X-Received: by 2002:a67:e11c:: with SMTP id d28mr9658868vsl.44.1633428817157;
 Tue, 05 Oct 2021 03:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <20211003043105.10453-1-linkinjeon@kernel.org> <20211003043105.10453-3-linkinjeon@kernel.org>
In-Reply-To: <20211003043105.10453-3-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Tue, 5 Oct 2021 19:13:26 +0900
Message-ID: <CANFS6bbvUpjLCEYEz4zprV5vbS7V=GaBkE1a9U57kPbsbEEJhA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ksmbd: fix oops from fuse driver
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Marios Makassikis <mmakassikis@freebox.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me.
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

2021=EB=85=84 10=EC=9B=94 3=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 1:31, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Marios reported kernel oops from fuse driver when ksmbd call
> mark_inode_dirty(). This patch directly update ->i_ctime after removing
> mark_inode_ditry() and notify_change will put inode to dirty list.
>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Reported-by: Marios Makassikis <mmakassikis@freebox.fr>
> Tested-by: Marios Makassikis <mmakassikis@freebox.fr>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb2pdu.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 4d1be224dd8e..ed8324f9c2bd 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -5483,7 +5483,6 @@ static int set_file_basic_info(struct ksmbd_file *f=
p,
>                                struct ksmbd_share_config *share)
>  {
>         struct iattr attrs;
> -       struct timespec64 ctime;
>         struct file *filp;
>         struct inode *inode;
>         struct user_namespace *user_ns;
> @@ -5505,13 +5504,11 @@ static int set_file_basic_info(struct ksmbd_file =
*fp,
>                 attrs.ia_valid |=3D (ATTR_ATIME | ATTR_ATIME_SET);
>         }
>
> -       if (file_info->ChangeTime) {
> +       attrs.ia_valid |=3D ATTR_CTIME;
> +       if (file_info->ChangeTime)
>                 attrs.ia_ctime =3D ksmbd_NTtimeToUnix(file_info->ChangeTi=
me);
> -               ctime =3D attrs.ia_ctime;
> -               attrs.ia_valid |=3D ATTR_CTIME;
> -       } else {
> -               ctime =3D inode->i_ctime;
> -       }
> +       else
> +               attrs.ia_ctime =3D inode->i_ctime;
>
>         if (file_info->LastWriteTime) {
>                 attrs.ia_mtime =3D ksmbd_NTtimeToUnix(file_info->LastWrit=
eTime);
> @@ -5557,11 +5554,9 @@ static int set_file_basic_info(struct ksmbd_file *=
fp,
>                         return -EACCES;
>
>                 inode_lock(inode);
> +               inode->i_ctime =3D attrs.ia_ctime;
> +               attrs.ia_valid &=3D ~ATTR_CTIME;
>                 rc =3D notify_change(user_ns, dentry, &attrs, NULL);
> -               if (!rc) {
> -                       inode->i_ctime =3D ctime;
> -                       mark_inode_dirty(inode);
> -               }
>                 inode_unlock(inode);
>         }
>         return rc;
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
