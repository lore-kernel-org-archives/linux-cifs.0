Return-Path: <SRS0=9NYC=VO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03616C7618F
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Jul 2019 18:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B893F205ED
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Jul 2019 18:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UMTg1wkZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfGQSsZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Jul 2019 14:48:25 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41617 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfGQSsZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Jul 2019 14:48:25 -0400
Received: by mail-lj1-f194.google.com with SMTP id d24so24684427ljg.8
        for <linux-cifs@vger.kernel.org>; Wed, 17 Jul 2019 11:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wC6e1gqckAEGxYGc2qhiMok5YPEvy0gkQgbY0/C9gs8=;
        b=UMTg1wkZlwUmWVk8TQmiIyR//N3yf0lAlKdp/+m3HFysRe4b0OALqcmKtzE1N8X4ez
         KLCtwAd7yFDvQn8o79NgPzDg30EZPIMQ1i9JjA8CeS8bf8Vlq6IrcKDYP4+8qu/XM+RQ
         DnBr19qHRSsUa14Os90vssxhvBzztywNXcrRISQDSn8ow5EOzcl2cCF/UBGh7HTKJaRT
         YMkePIbKQ2ITwGl+thCWneq1FJ7WidFDkWU6cEF6jdskSaoK59qzGnZ1IgZ7aeoi9Iti
         jF92yvCcd/ziM09BHWPww/f5bP4iFI8DYwEGmjKDeKC5q8md6QZ/aCBELX2HsaHooVyi
         qMfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wC6e1gqckAEGxYGc2qhiMok5YPEvy0gkQgbY0/C9gs8=;
        b=WX6yFxY1WOBWI8c87CmIT/tM0MfMd/N8NxD4qiKPFUQahscBgB6oj5aaXCAQlXFjTl
         ty9ayjR1ffB9yQHivkGliXAw9n9vekZmmVfd63e2rragxVen6gOYNxv9KeehgLikD8i3
         sAw5QsuESfga64Ih/sUC7AnEtXLj7+G9ibHjbpcmpmRINI2g+zrh8CRb+u5YIn5DMbKx
         GoRJ/V1xVmyLtcc6jahHXUrX8mQsc0/BILN8y2D2NbBhE4ErLDQaNE17IYpYZxs2WyDQ
         /XFvuGRInHbbtgE2tonscqbn74FAcWsaUWUH8HdOYrb0SjuzofTki8sbtM9AvqNccEBs
         6Qlw==
X-Gm-Message-State: APjAAAVRq08dktnaj4jRxuqqwVvW/XNXJHAo2+s6+WjUt5Hd9U+csrBB
        BxbyWXv4aDNIPAdzWGJmescVTFVLLQAw2G8+nqw1tm0=
X-Google-Smtp-Source: APXvYqxpAV/dwZfHqGByypeseDfYuxUjJY3/pia7qyhGO6F1CMUWzK/CXqisUn2D4ji+wUcVU0I3WDFERpdbJbNRAxg=
X-Received: by 2002:a05:651c:87:: with SMTP id 7mr14216225ljq.184.1563389302269;
 Wed, 17 Jul 2019 11:48:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190716050708.14482-1-lsahlber@redhat.com>
In-Reply-To: <20190716050708.14482-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 17 Jul 2019 11:48:10 -0700
Message-ID: <CAKywueRkV6uB3494b8LCuuRvqiXE2VzxEHx3a2B7sw5goxB7UA@mail.gmail.com>
Subject: Re: [PATCH] cifs: prepare SMB2_Flush to be usable in compounds
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 15 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 22:07, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> Create smb2_flush_init() and smb2_flush_free() so we can use the flush co=
mmand
> in compounds.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2pdu.c   | 58 ++++++++++++++++++++++++++++++++++++-----------=
------
>  fs/cifs/smb2proto.h |  4 ++++
>  2 files changed, 44 insertions(+), 18 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index f58e4dc3987b..b352f453a6d2 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3262,44 +3262,64 @@ SMB2_echo(struct TCP_Server_Info *server)
>         return rc;
>  }
>
> +void
> +SMB2_flush_free(struct smb_rqst *rqst)
> +{
> +       if (rqst && rqst->rq_iov)
> +               cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* requ=
est */
> +}
> +
>  int
> -SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persisten=
t_fid,
> -          u64 volatile_fid)
> +SMB2_flush_init(const unsigned int xid, struct smb_rqst *rqst,
> +               struct cifs_tcon *tcon, u64 persistent_fid, u64 volatile_=
fid)
>  {
> -       struct smb_rqst rqst;
>         struct smb2_flush_req *req;
> -       struct cifs_ses *ses =3D tcon->ses;
> -       struct kvec iov[1];
> -       struct kvec rsp_iov;
> -       int resp_buftype;
> -       int rc =3D 0;
> -       int flags =3D 0;
> +       struct kvec *iov =3D rqst->rq_iov;
>         unsigned int total_len;
> -
> -       cifs_dbg(FYI, "Flush\n");
> -
> -       if (!ses || !(ses->server))
> -               return -EIO;
> +       int rc;
>
>         rc =3D smb2_plain_req_init(SMB2_FLUSH, tcon, (void **) &req, &tot=
al_len);
>         if (rc)
>                 return rc;
>
> -       if (smb3_encryption_required(tcon))
> -               flags |=3D CIFS_TRANSFORM_REQ;
> -
>         req->PersistentFileId =3D persistent_fid;
>         req->VolatileFileId =3D volatile_fid;
>
>         iov[0].iov_base =3D (char *)req;
>         iov[0].iov_len =3D total_len;
>
> +       return 0;
> +}
> +
> +int
> +SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persisten=
t_fid,
> +          u64 volatile_fid)
> +{
> +       struct cifs_ses *ses =3D tcon->ses;
> +       struct smb_rqst rqst;
> +       struct kvec iov[1];
> +       struct kvec rsp_iov =3D {NULL, 0};
> +       int resp_buftype =3D CIFS_NO_BUFFER;
> +       int flags =3D 0;
> +       int rc =3D 0;
> +
> +       cifs_dbg(FYI, "flush\n");
> +       if (!ses || !(ses->server))
> +               return -EIO;
> +
> +       if (smb3_encryption_required(tcon))
> +               flags |=3D CIFS_TRANSFORM_REQ;
> +
>         memset(&rqst, 0, sizeof(struct smb_rqst));
> +       memset(&iov, 0, sizeof(iov));
>         rqst.rq_iov =3D iov;
>         rqst.rq_nvec =3D 1;
>
> +       rc =3D SMB2_flush_init(xid, &rqst, tcon, persistent_fid, volatile=
_fid);
> +       if (rc)
> +               goto flush_exit;
> +
>         rc =3D cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp=
_iov);
> -       cifs_small_buf_release(req);
>
>         if (rc !=3D 0) {
>                 cifs_stats_fail_inc(tcon, SMB2_FLUSH_HE);
> @@ -3307,6 +3327,8 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon=
 *tcon, u64 persistent_fid,
>                                      rc);
>         }
>
> + flush_exit:

The extra space before the label is not needed.

> +       SMB2_flush_free(&rqst);
>         free_rsp_buf(resp_buftype, rsp_iov.iov_base);
>         return rc;
>  }
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 52df125e9189..e4ca98cf3af3 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -158,6 +158,10 @@ extern int SMB2_close_init(struct cifs_tcon *tcon, s=
truct smb_rqst *rqst,
>  extern void SMB2_close_free(struct smb_rqst *rqst);
>  extern int SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon,
>                       u64 persistent_file_id, u64 volatile_file_id);
> +extern int SMB2_flush_init(const unsigned int xid, struct smb_rqst *rqst=
,
> +                          struct cifs_tcon *tcon,
> +                          u64 persistent_file_id, u64 volatile_file_id);
> +extern void SMB2_flush_free(struct smb_rqst *rqst);
>  extern int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tco=
n,
>                            u64 persistent_file_id, u64 volatile_file_id,
>                            struct smb2_file_all_info *data);
> --
> 2.13.6
>

Just wondering how are you going to use this? Compound flush and
setattr to be sent together?

--
Best regards,
Pavel Shilovsky
