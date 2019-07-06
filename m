Return-Path: <SRS0=8y/q=VD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD8EC0650E
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 19:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FB3120838
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 19:30:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u4eJC4Y5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfGFTa3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Jul 2019 15:30:29 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36432 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfGFTa3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 Jul 2019 15:30:29 -0400
Received: by mail-lj1-f193.google.com with SMTP id i21so12213200ljj.3
        for <linux-cifs@vger.kernel.org>; Sat, 06 Jul 2019 12:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hP5RLr3eaQQQSZE6bOsGLxJBX0coHPY35Xqmc25E4rY=;
        b=u4eJC4Y5hA3FQlF7wHFW7ajsMvfyB8hCsWowTCNZ6XNVHhr1Sx7UCMrUHZAh8NhewA
         jHggCXdxb2itpFI3Amcg5rwFDXo4mLYaLrDKt7GWKZMhMyVq7aaivMOImu4rjOk5cWjh
         7Xqa16pTUAl837M5M3DCcKgYj7kaWK1H3EaMrWYi1hI81Z+Xw8we5TK7/1FNg/Z56FBp
         MLstu7ukchgSW/DE79DfZznct+H5ApjuGiy6d6sEbaOJnXRw5e39UY/SRNqKRChPV8UO
         96Dwr1RK6zvOsCFtN5HgkNDuadQKqciYqriRFRuXf4O0v9ghqhmP+St6c4jxG+7PXvI9
         0Rjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hP5RLr3eaQQQSZE6bOsGLxJBX0coHPY35Xqmc25E4rY=;
        b=ez7JBQBv9YJpMQJ+N4hfvMvraq01WnYuldUPlmZKTEy7vYsdwOCZLwPsI1LLNu0Hzs
         Pmxm6fOZvP4hR4bmz4m2yKmWZql+C2DU3H/W85Vq+TaPUyp8UWcSxabCogjO/o4xIPiY
         5cu27vANFousWsYhR2UvI0MCMGgyjUK3OHFPOXMqoIU2uk+g+QQtOrs9oHP9Qo7tbGur
         fWdygfGdgYjm0q5w3UxHDoKxSaJr1slRHcnIahKrDTuomEaKLrbPuyiID1mIVaDp1+qw
         Kocp/lYZkhsadxfm47s/Z+OSe91zezskUckDY2pgce6sS+ImIWi3D298/E8OMC7W4rTG
         KdXw==
X-Gm-Message-State: APjAAAU2MViceHD2v5jnNjeYxW0t9l1ZkM1iaM0sJ8NpZHDqvatOs43F
        SQiv+/l0TTzJ0NPo8cHOihrXJheqIzOQYovJmBldU10=
X-Google-Smtp-Source: APXvYqx5TnNP7j+LY6p+eo5TO8s87vFekVFOrnEC1Mhh1mhn94AkSD6Zn0lfuUwH9cKkMEEJqNaABTUDHDkQiVaB27k=
X-Received: by 2002:a2e:8945:: with SMTP id b5mr5465213ljk.93.1562441427641;
 Sat, 06 Jul 2019 12:30:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAKywueScmnouPGgaEkpH3pfXCzSnddz-qCZqYPjBQLGX5c__ng@mail.gmail.com>
 <20190706191731.31150-1-aaptel@suse.com>
In-Reply-To: <20190706191731.31150-1-aaptel@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Sat, 6 Jul 2019 12:30:16 -0700
Message-ID: <CAKywueS6VDje+BAVOfdUuACdayoFz1-Q-fqtEOWP9jVp_SvvTA@mail.gmail.com>
Subject: Re: [PATCH v1 4.20.y stable] CIFS: fix deadlock in cached root handling
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D0=B1, 6 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 12:17, Aurelien Apt=
el <aaptel@suse.com>:
>
> Prevent deadlock between open_shroot() and
> cifs_mark_open_files_invalid() by releasing the lock before entering
> SMB2_open, taking it again after and checking if we still need to use
> the result.
>
> Link: https://lore.kernel.org/linux-cifs/684ed01c-cbca-2716-bc28-b0a59a0f=
8521@prodrive-technologies.com/T/#u
> Fixes: 3d4ef9a15343 ("smb3: fix redundant opens on root")
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>
> This patch applies on top of the 4.20 stable tree.
>
> Please review this carefuly, I have not tested it.
>
>  XXX: do we need to call SMB2_close() when the work was already done
>       concurrently?  if yes we need to do it outside the critical
>       section otherwise we hit the same issue again

Yes, we do need to close a handle we just opened. Otherwise it will
leak a handle on the server.

>
>  fs/cifs/smb2ops.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index aa71e620f3cd..55991e43d74f 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -609,7 +609,27 @@ int open_shroot(unsigned int xid, struct cifs_tcon *=
tcon, struct cifs_fid *pfid)
>         oparams.fid =3D pfid;
>         oparams.reconnect =3D false;
>
> +       /*
> +        * We do not hold the lock for the open because in case
> +        * SMB2_open needs to reconnect, it will end up calling
> +        * cifs_mark_open_files_invalid() which takes the lock again
> +        * thus causing a deadlock
> +        */
> +       mutex_unlock(&tcon->crfid.fid_mutex);
>         rc =3D SMB2_open(xid, &oparams, &srch_path, &oplock, NULL, NULL, =
NULL);
> +       mutex_lock(&tcon->crfid.fid_mutex);
> +
> +       /*
> +        * Now we need to check again as the cached root might have
> +        * been successfully re-opened from a concurrent process
> +        */
> +
> +       if (tcon->crfid.is_valid) {
> +               /* work was already done */
> +               rc =3D 0;
> +               goto out;
> +       }
> +
>         if (rc =3D=3D 0) {
>                 memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
>                 tcon->crfid.tcon =3D tcon;
> @@ -617,6 +637,8 @@ int open_shroot(unsigned int xid, struct cifs_tcon *t=
con, struct cifs_fid *pfid)
>                 kref_init(&tcon->crfid.refcount);
>                 kref_get(&tcon->crfid.refcount);
>         }
> +
> +out:
>         mutex_unlock(&tcon->crfid.fid_mutex);
>         return rc;
>  }
> --
> 2.16.4
>


--
Best regards,
Pavel Shilovsky
