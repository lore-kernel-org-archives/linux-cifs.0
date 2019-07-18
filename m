Return-Path: <SRS0=TF3n=VP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DC5C76191
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Jul 2019 07:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B26C20880
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Jul 2019 07:55:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f9PPh9WV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfGRHzU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Jul 2019 03:55:20 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34724 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfGRHzU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Jul 2019 03:55:20 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so13461846plt.1
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jul 2019 00:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Oc3C6O96+1cIv6WwMQv+UrhPzUuDm+FfTNBW2E1sZ+U=;
        b=f9PPh9WVswzsOD/DhmxWsMBJJmaJyPmJ56cRn8+X6FK91YsWfOK3YQhQJ6a6bf7YT/
         yDU8d5HJzdCHXlNZYN79y/SlSGO0l1oyZcEDhvPJOV8oJoyj/isP2bofKxIdT1doKrqr
         GFzzCPhoPHncKyBd92NmSVmxyTQqlQ3E9BvRCoC1Sy6QQ6W8HswalMt+ZTXPcZNan1M8
         PcRaAVK0mbyg3I9qpkReoaugWmGYvZ12oWg9VMPd3mF7/kEOgIxz35DUsyg2FCpH76Su
         1RjwyIvn7N3ac0qBWPoKjVIFC69gfOXxSwaYF6OxDOmXCgoK0qAYro6/KtvnfCVHDfKj
         h1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Oc3C6O96+1cIv6WwMQv+UrhPzUuDm+FfTNBW2E1sZ+U=;
        b=suFUjv+wkr8hr5wsrTcJjOHyOCCBqLtsqDywZVS0HgsgpsNWNLsfoXdmquoDVbLs8v
         Zvzehgep/74sBrJP4zvzyV1VdFmkdmYvvwg75DbXaVWOOXS9OjfVdAOzbv/irSKgH41A
         1eoHROhVROTiCRcp/LQVuImJ1wpwJh8b988gutyXMctvl4RBp1O7BzASs49AjTb+Q3Z8
         sJDwcfP8xPKCX8yuPRZNxMi12Uqp2PdDN1eTRsuswm5pqS5YMlvSXGGjQSOQm0HAromg
         Rl2Vh5NobbArZyVCoJBBdN7eXT1qQEgHiDk+fUrCZxVIEWVzZr6gVnXbagZAwniRv1k/
         B2Uw==
X-Gm-Message-State: APjAAAUY99vOt8Y1XZ8ojvbAFYf0K5zIXI+JjMvvoQLjY3FFce4mjadp
        /QtzR7D7jnMC+CYjpFA7Adc6kAdL+KRdeUG2ErDcadTK
X-Google-Smtp-Source: APXvYqz6FiboA1pmk8NdpPoq+TNYTThcmQbm/iBH+9N5kLH345bc3AleEZHRu/cyoTG4S2HGBfJQ5ZEPRHcZThipoPM=
X-Received: by 2002:a17:902:2a29:: with SMTP id i38mr48861956plb.46.1563436519296;
 Thu, 18 Jul 2019 00:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190717104628.21400-1-aaptel@suse.com> <CAKywueQqyb7r_pDvrxYv7btTuvUBV7DjEZJWdNt-n_np5T80ww@mail.gmail.com>
In-Reply-To: <CAKywueQqyb7r_pDvrxYv7btTuvUBV7DjEZJWdNt-n_np5T80ww@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 18 Jul 2019 02:55:07 -0500
Message-ID: <CAH2r5mtDSMTX1wAc3T9k980fv93yHOWcQ9id+rkv04QCcbR_xg@mail.gmail.com>
Subject: Re: [PATCH v1] CIFS: fix deadlock in cached root handling
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Aurelien Aptel <aaptel@suse.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added cc: stable and made minor cleanup of missing tab

On Wed, Jul 17, 2019 at 1:38 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> Looks good.
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D1=81=D1=80, 17 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 03:46, Aurelien =
Aptel <aaptel@suse.com>:
> >
> > Prevent deadlock between open_shroot() and
> > cifs_mark_open_files_invalid() by releasing the lock before entering
> > SMB2_open, taking it again after and checking if we still need to use
> > the result.
> >
> > Link: https://lore.kernel.org/linux-cifs/684ed01c-cbca-2716-bc28-b0a59a=
0f8521@prodrive-technologies.com/T/#u
> > Fixes: 3d4ef9a15343 ("smb3: fix redundant opens on root")
> > Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> > ---
> >
> > this is the for-next version of the patch I sent in the thread
> > https://lore.kernel.org/linux-cifs/684ed01c-cbca-2716-bc28-b0a59a0f8521=
@prodrive-technologies.com/T/#u
> >
> >
> >  fs/cifs/smb2ops.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 45 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 6cb4def11ebe..8202c996b55e 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -694,8 +694,51 @@ int open_shroot(unsigned int xid, struct cifs_tcon=
 *tcon, struct cifs_fid *pfid)
> >
> >         smb2_set_related(&rqst[1]);
> >
> > +       /*
> > +        * We do not hold the lock for the open because in case
> > +        * SMB2_open needs to reconnect, it will end up calling
> > +        * cifs_mark_open_files_invalid() which takes the lock again
> > +        * thus causing a deadlock
> > +        */
> > +
> > +       mutex_unlock(&tcon->crfid.fid_mutex);
> >         rc =3D compound_send_recv(xid, ses, flags, 2, rqst,
> >                                 resp_buftype, rsp_iov);
> > +       mutex_lock(&tcon->crfid.fid_mutex);
> > +
> > +       /*
> > +        * Now we need to check again as the cached root might have
> > +        * been successfully re-opened from a concurrent process
> > +        */
> > +
> > +       if (tcon->crfid.is_valid) {
> > +               /* work was already done */
> > +
> > +               /* stash fids for close() later */
> > +               struct cifs_fid fid =3D {
> > +                       .persistent_fid =3D pfid->persistent_fid,
> > +                       .volatile_fid =3D pfid->volatile_fid,
> > +               };
> > +
> > +               /*
> > +                * caller expects this func to set pfid to a valid
> > +                * cached root, so we copy the existing one and get a
> > +                * reference.
> > +                */
> > +               memcpy(pfid, tcon->crfid.fid, sizeof(*pfid));
> > +               kref_get(&tcon->crfid.refcount);
> > +
> > +               mutex_unlock(&tcon->crfid.fid_mutex);
> > +
> > +               if (rc =3D=3D 0) {
> > +                       /* close extra handle outside of crit sec */
> > +                       SMB2_close(xid, tcon, fid.persistent_fid, fid.v=
olatile_fid);
> > +               }
> > +              goto oshr_free;
> > +       }
> > +
> > +       /* Cached root is still invalid, continue normaly */
> > +
> >         if (rc)
> >                 goto oshr_exit;
> >
> > @@ -729,8 +772,9 @@ int open_shroot(unsigned int xid, struct cifs_tcon =
*tcon, struct cifs_fid *pfid)
> >                                 (char *)&tcon->crfid.file_all_info))
> >                 tcon->crfid.file_all_info_is_valid =3D 1;
> >
> > - oshr_exit:
> > +oshr_exit:
> >         mutex_unlock(&tcon->crfid.fid_mutex);
> > +oshr_free:
> >         SMB2_open_free(&rqst[0]);
> >         SMB2_query_info_free(&rqst[1]);
> >         free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> > --
> > 2.16.4
> >



--=20
Thanks,

Steve
