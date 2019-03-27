Return-Path: <SRS0=fS5U=R6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13492C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Mar 2019 22:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C09252082F
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Mar 2019 22:36:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gEgiUNmL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbfC0Wgh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Mar 2019 18:36:37 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40098 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727723AbfC0Wgh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Mar 2019 18:36:37 -0400
Received: by mail-lf1-f66.google.com with SMTP id u68so12562286lff.7
        for <linux-cifs@vger.kernel.org>; Wed, 27 Mar 2019 15:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rmpmnL8pXZ6o8wFvofJEs23V9yHtXYqMdyWZRut2o5A=;
        b=gEgiUNmLZQaCoBbGjLcLEzA4hcaqbXC6u//PdzeFlrFnlEcv+VP6d+dJuWNUoVrCz8
         kZrMWFZ6BE8OwHS7QxstCew4gsjlkqghkeKcNAjynsdMiDiLCk8AYQC5dJ3z0xztiFZi
         MiAZ/8AOc072rJsEKevciHfroxWm+SsVPyPkHGm7xdjuHbmMsNloqTndok+40cSJiKAv
         KhqpxUhUfrp6Z9LLXdxRd8t+F6KvE3CaCaT8aDHvARGDTGWV5ZkyGjuZOi7ei54KTkdD
         nGhlsZzgcjfPciHX/vonZkQPXXIMSxdutK0sYeshudAJstu2XlGHG2vA/Qca3ZQbePbo
         4Q4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rmpmnL8pXZ6o8wFvofJEs23V9yHtXYqMdyWZRut2o5A=;
        b=GQ7lCL6yGMrth5dwTLwPYxaqVoAwZ4i16YySpSonjVN8/upXT631sPFB+J1s58SX8/
         +xpE35ZQYJYgeZdHP1Fz34C9uW9Ornh786+XylFuU9eeqcjFEIMFNyocN8/cNxXXkfH4
         yjZfpyONbNEZOOLUTgNthAT901VnMDbVfhHKOR6OgrXqTlPjd/KudA+TkicYW8UKJ7N6
         gNCH8Gn9eflIwJMOy37p2ioa2EZroADyseTnPh2vgSMPsWtxTkXIXqzRygz9lgzxtWyc
         TMGYx02QzXho40YUTHTm7nD3Ul564Uav7BWqryBCy5c70WqoYQ8zEMHEBg2MERB6/27N
         7PzA==
X-Gm-Message-State: APjAAAV7PJq1ARhiStZGtHfx2e+11YUl6pi5PtOQ67uexp0hzXGxiHLj
        q1dUOzr2in1v/y60I0Jrp/Fo26D/c6e3gOBTgA==
X-Google-Smtp-Source: APXvYqwjJMgP9dAWwDwLWIh+Mgu5ukGYSoeWakqUTDwSCKGTrABuQjLgG2TvYjoLQ2qnWd4fxdHGMKDt1Ts1sgTDW5g=
X-Received: by 2002:a19:5506:: with SMTP id n6mr7869317lfe.119.1553726193859;
 Wed, 27 Mar 2019 15:36:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190326071819.GA10639@light.dominikbrodowski.net> <20190326123921.4116-1-aaptel@suse.com>
In-Reply-To: <20190326123921.4116-1-aaptel@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 27 Mar 2019 15:36:22 -0700
Message-ID: <CAKywueSKRgF3tUtqjrfOkae+LUq717FvvoNCkkjGZmDBMyJO2w@mail.gmail.com>
Subject: Re: [PATCH v1] CIFS: prevent refcount underflow
To:     Aurelien Aptel <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>, linux@dominikbrodowski.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 26 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 05:39, Aurelien Ap=
tel <aaptel@suse.com>:
>
> Replace kref_t by a simple refcount. We do not care about the
> atomicity of the operation as long as the mutex is held.
>
> This fixes a false-positive memory leak warning from kref_put() where
> we close the cached fid twice and make the kref underflow.
>
> Link: https://lore.kernel.org/linux-cifs/20190319115151.GA2092@light.domi=
nikbrodowski.net/
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/cifsglob.h |  2 +-
>  fs/cifs/smb2ops.c  | 34 ++++++++++++++--------------------
>  2 files changed, 15 insertions(+), 21 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 38feae812b47..256cd48fb4c7 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -972,7 +972,7 @@ struct cached_fid {
>         bool is_valid:1;        /* Do we have a useable root fid */
>         bool file_all_info_is_valid:1;
>
> -       struct kref refcount;
> +       refcount_t refcount;
>         struct cifs_fid *fid;
>         struct mutex fid_mutex;
>         struct cifs_tcon *tcon;
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 1022a3771e14..062c081a298c 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -608,25 +608,21 @@ SMB3_request_interfaces(const unsigned int xid, str=
uct cifs_tcon *tcon)
>         return rc;
>  }
>
> -static void
> -smb2_close_cached_fid(struct kref *ref)
> -{
> -       struct cached_fid *cfid =3D container_of(ref, struct cached_fid,
> -                                              refcount);
> -
> -       if (cfid->is_valid) {
> -               cifs_dbg(FYI, "clear cached root file handle\n");
> -               SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
> -                          cfid->fid->volatile_fid);
> -               cfid->is_valid =3D false;
> -               cfid->file_all_info_is_valid =3D false;
> -       }
> -}
> -
>  void close_shroot(struct cached_fid *cfid)
>  {
> +       unsigned int n;
>         mutex_lock(&cfid->fid_mutex);
> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +       n =3D refcount_read(&cfid->refcount);
> +       if (n > 0) {
> +               refcount_dec(&cfid->refcount);
> +               if (n =3D=3D 1 && cfid->is_valid) {
> +                       cifs_dbg(FYI, "clear cached root file handle\n");
> +                       SMB2_close(0, cfid->tcon, cfid->fid->persistent_f=
id,
> +                                  cfid->fid->volatile_fid);
> +                       cfid->is_valid =3D false;
> +                       cfid->file_all_info_is_valid =3D false;
> +               }
> +       }
>         mutex_unlock(&cfid->fid_mutex);
>  }
>
> @@ -662,7 +658,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *t=
con, struct cifs_fid *pfid)
>         if (tcon->crfid.is_valid) {
>                 cifs_dbg(FYI, "found a cached root file handle\n");
>                 memcpy(pfid, tcon->crfid.fid, sizeof(struct cifs_fid));
> -               kref_get(&tcon->crfid.refcount);
> +               refcount_inc(&tcon->crfid.refcount);
>                 mutex_unlock(&tcon->crfid.fid_mutex);
>                 return 0;
>         }
> @@ -728,9 +724,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *t=
con, struct cifs_fid *pfid)
>         memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
>         tcon->crfid.tcon =3D tcon;
>         tcon->crfid.is_valid =3D true;
> -       kref_init(&tcon->crfid.refcount);
> -       kref_get(&tcon->crfid.refcount);
> -
> +       refcount_set(&tcon->crfid.refcount, 1);
>
>         qi_rsp =3D (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
>         if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_=
file_all_info))
> --
> 2.16.4
>

I looked at the usage of cached root handle: we call open_shroot in
two places (https://github.com/smfrench/smb3-kernel/search?q=3Dopen_shroot&=
unscoped_q=3Dopen_shroot):

1) smb3_qfs_tcon
2) smb2_query_path_info

In both places we call close_shroot() after we use the handle. Another
extra reference (that keeps the file handle opened) is being acquired
by open_shroot itself:

kref_init(&tcon->crfid.refcount);   <--- initialize to 1
kref_get(&tcon->crfid.refcount);   <--- bump to 2

So, once we stopped using the handle, there should be one reference
left. This reference is being put by the lease break handling code
when such a lease break comes. But here is the problem:

--------------------------------open_shroot()------------------------------=
--
rc =3D compound_send_recv(xid, ses, flags, 2, rqst,
                                            resp_buftype, rsp_iov);
if (rc)
    goto oshr_exit;

o_rsp =3D (struct smb2_create_rsp *)rsp_iov[0].iov_base;
oparms.fid->persistent_fid =3D o_rsp->PersistentFileId;
oparms.fid->volatile_fid =3D o_rsp->VolatileFileId;
#ifdef CONFIG_CIFS_DEBUG2
oparms.fid->mid =3D le64_to_cpu(o_rsp->sync_hdr.MessageId);
#endif /* CIFS_DEBUG2 */

if (o_rsp->OplockLevel =3D=3D SMB2_OPLOCK_LEVEL_LEASE)
    oplock =3D smb2_parse_lease_state(server, o_rsp,
                                                            &oparms.fid->ep=
och,

oparms.fid->lease_key);
else
    goto oshr_exit;
     ^^^
---------------------------------------------------------------------------=
---------

if we the server doesn't respond with a lease, we return with rc=3D0
immediately without marking such a handle as cached and without
holding any reference to the handle (even the one that were
requested). Then we call close_shroot() trying to put non-existing
reference -- BUG that was reported.

The proper fix would be to continue initializing the cached root
handle but skip getting the extra reference (see kref_get call
explained above) if the server didn't give a lease. It doesn't seem
that any other changes are needed here.

--
Best regards,
Pavel Shilovsky
