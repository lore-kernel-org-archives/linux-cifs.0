Return-Path: <SRS0=9NYC=VO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F29C7618F
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Jul 2019 18:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EACE721743
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Jul 2019 18:38:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UoJVX/Tr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfGQSiF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Jul 2019 14:38:05 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35310 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727271AbfGQSiF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Jul 2019 14:38:05 -0400
Received: by mail-lf1-f68.google.com with SMTP id p197so17244413lfa.2
        for <linux-cifs@vger.kernel.org>; Wed, 17 Jul 2019 11:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VB1G3pCaUULAGooLNr9VIqPraYsMXILmS3Zmdg/gOiA=;
        b=UoJVX/TreSCn3s9QTWbesqUWS2Baj7S+IZ8sWJbcnlhiVqlk9nMOe9B+PY0alvEEKj
         6WZtvFZ/M+oVP53blPYe6H87IW8pZ9N/EGyHv/orasdtPK3pwSLRV4vjX41MxiTegcOx
         YFwt2f9aZZ3QfrBomDW6DQ1VK6fLc6jOzr98ilfwH+gtiXX8pqDXUyvWo1Zo2POiozQl
         lu2G7qLvZ2EfsyzBzHYuKIzu+7fPSVZcrT/1iSNtepTdk9DK5Sy9i439yI0ctGZLoUi4
         y0uKzb2JeV6OGQpmUGlx4RlW7Qg2s420xHBNuX9LOwnCVLdcjFRZt2aP62ek8pmT8YbY
         fdsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VB1G3pCaUULAGooLNr9VIqPraYsMXILmS3Zmdg/gOiA=;
        b=bniTn//7fvpb6U8TIl1N101jNI32Tz/Sunc4mb2evyWe9H/+Mmvj0mHZX+Llv5eat+
         Wuo4UvISV3RlQFZBlaYpCz5r9YumYKqpP3Es2+yd6wn6ni5lgzyztkzT5RTw/JmJ7T8t
         eMeiuIIrUncGgHmklfMQtDj16nESEWvJMCQLjd6higumW8xNNw14vZbpvY8whtF4GcgS
         t5lgyPRhY7ptEv7z22N/pwGqnf3O21LesK/KX27eZUOzX2fmeTivaPw1/T8azLM/sBAH
         +jwxQjZPk+D6cybpE3Vo8wj9xCBbdd2U2BWPVVJttTY6PDBiorGy3jqYzm33OmV+DTfn
         bA2A==
X-Gm-Message-State: APjAAAUUR3IwlEy6R1uMXUjdOcxi5MCVsZmUoXaLHWm+/XRD+JBMK4eM
        xYtQrw//hZXncMM3XGRKbRaN1XvDsd7gWbRmDw==
X-Google-Smtp-Source: APXvYqywO8Rqjxpx8PeTShOoc+Vflz7toA9Pfmtls94b6hzpF8uoiS/uAbtneJXJ86Ujf4a9b/mC5lXkVXYmi4iSQNM=
X-Received: by 2002:ac2:50cd:: with SMTP id h13mr19147673lfm.36.1563388683213;
 Wed, 17 Jul 2019 11:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190717104628.21400-1-aaptel@suse.com>
In-Reply-To: <20190717104628.21400-1-aaptel@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 17 Jul 2019 11:37:52 -0700
Message-ID: <CAKywueQqyb7r_pDvrxYv7btTuvUBV7DjEZJWdNt-n_np5T80ww@mail.gmail.com>
Subject: Re: [PATCH v1] CIFS: fix deadlock in cached root handling
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 17 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 03:46, Aurelien Ap=
tel <aaptel@suse.com>:
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
> this is the for-next version of the patch I sent in the thread
> https://lore.kernel.org/linux-cifs/684ed01c-cbca-2716-bc28-b0a59a0f8521@p=
rodrive-technologies.com/T/#u
>
>
>  fs/cifs/smb2ops.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 45 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 6cb4def11ebe..8202c996b55e 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -694,8 +694,51 @@ int open_shroot(unsigned int xid, struct cifs_tcon *=
tcon, struct cifs_fid *pfid)
>
>         smb2_set_related(&rqst[1]);
>
> +       /*
> +        * We do not hold the lock for the open because in case
> +        * SMB2_open needs to reconnect, it will end up calling
> +        * cifs_mark_open_files_invalid() which takes the lock again
> +        * thus causing a deadlock
> +        */
> +
> +       mutex_unlock(&tcon->crfid.fid_mutex);
>         rc =3D compound_send_recv(xid, ses, flags, 2, rqst,
>                                 resp_buftype, rsp_iov);
> +       mutex_lock(&tcon->crfid.fid_mutex);
> +
> +       /*
> +        * Now we need to check again as the cached root might have
> +        * been successfully re-opened from a concurrent process
> +        */
> +
> +       if (tcon->crfid.is_valid) {
> +               /* work was already done */
> +
> +               /* stash fids for close() later */
> +               struct cifs_fid fid =3D {
> +                       .persistent_fid =3D pfid->persistent_fid,
> +                       .volatile_fid =3D pfid->volatile_fid,
> +               };
> +
> +               /*
> +                * caller expects this func to set pfid to a valid
> +                * cached root, so we copy the existing one and get a
> +                * reference.
> +                */
> +               memcpy(pfid, tcon->crfid.fid, sizeof(*pfid));
> +               kref_get(&tcon->crfid.refcount);
> +
> +               mutex_unlock(&tcon->crfid.fid_mutex);
> +
> +               if (rc =3D=3D 0) {
> +                       /* close extra handle outside of crit sec */
> +                       SMB2_close(xid, tcon, fid.persistent_fid, fid.vol=
atile_fid);
> +               }
> +              goto oshr_free;
> +       }
> +
> +       /* Cached root is still invalid, continue normaly */
> +
>         if (rc)
>                 goto oshr_exit;
>
> @@ -729,8 +772,9 @@ int open_shroot(unsigned int xid, struct cifs_tcon *t=
con, struct cifs_fid *pfid)
>                                 (char *)&tcon->crfid.file_all_info))
>                 tcon->crfid.file_all_info_is_valid =3D 1;
>
> - oshr_exit:
> +oshr_exit:
>         mutex_unlock(&tcon->crfid.fid_mutex);
> +oshr_free:
>         SMB2_open_free(&rqst[0]);
>         SMB2_query_info_free(&rqst[1]);
>         free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> --
> 2.16.4
>
