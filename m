Return-Path: <SRS0=HHpq=RQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9348C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 18:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94A232075C
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 18:18:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cTZKOdoT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfCMSSD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 14:18:03 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45010 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfCMSSD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Mar 2019 14:18:03 -0400
Received: by mail-lj1-f193.google.com with SMTP id n18so533720ljg.11
        for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2019 11:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g59NIMz/ZzrIjFmw0ovWwDWdTEqryyW0VIN0fJMLJbc=;
        b=cTZKOdoTXfec+x3laLkQt5YCR2fI9Hc9+MrAhv8d3vB7RxukvoODJWwTAncsK3gYYm
         ikhFzs3s2SlGylD1kMCPQPxPd+Xh8c0nRCgYnLNgJXA/T6XkQ4SD//6T3sWuHir3c4hK
         P0/5x03SdzFtiWGQUbWNC2jgyohL77NUjUSTk+Y7XtW1xBL1a0tE3Bv4Ppi/kWBpjrIf
         iwPMlYh8J4Rp5G/7PimwnD78IFJdjRslEQu/F6KDGrTFrDuE7yllC/WXcJTEkzlqLMT8
         mTIfJBz/cvMV/LUActndY9If+fJcQrhdjPNzF1tq8N406SfxM3/bL0byVtXwOHyOKMhc
         agcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g59NIMz/ZzrIjFmw0ovWwDWdTEqryyW0VIN0fJMLJbc=;
        b=ev26NdmvJ0ObRFul3FEdO0Z45w3jXPGK3ERKDbfmNdOs//K4RbALedkVaSjFf+8S+e
         wIBwPAL8dY7yl1Z31iAl4GS6Db2hdxIKCyaQ2nIv9t6dSgcnYfurvE7PJnYgSL4mLVyU
         qthqO46LgFrZOsCwV+DgSmxcR3iUjfbQhyKNKqVVEa0wPdpsWnGgGIc0IIzgo/uxulQa
         tP2LPqHLp6HQS6Xwthbycr0PX8kmv1MsxLcuYU1RxPEg4DNC1KOT9IRmiAyvFc16m7zi
         Dz1alaP3lWSILIArMsuDWFhXSnfyueOOu0FK71cmv8aax3BKZQqLfElEl98SRtx8ljX9
         mI/Q==
X-Gm-Message-State: APjAAAWc7VtyPjUh/p3IOEyTiEDkVEwZVxVdfl+ivpYsus03pLxGuzei
        KW6g45CeUIZMOaSZGIU2ow7i4AhUDtRqQKPP0g==
X-Google-Smtp-Source: APXvYqy9z6bF9ARShWtSktZPjjWaRbn1SEmGkDrW9k3GGCmUz2jY6uR/81CO6nGjLJUledEoE+V4IEEvFew7ljR2SIM=
X-Received: by 2002:a2e:9b15:: with SMTP id u21mr23911543lji.82.1552501080047;
 Wed, 13 Mar 2019 11:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190312035831.2691-1-lsahlber@redhat.com>
In-Reply-To: <20190312035831.2691-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 13 Mar 2019 11:17:48 -0700
Message-ID: <CAKywueR6x=ATiFT4RvwXcKfnX-ZkqQ2X1ZUW7_Rxx1q6dqcQnQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: cache FILE_ALL_INFO for the shared root handle
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 11 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 20:59, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> When we open the shared root handle also ask for FILE_ALL_INFORMATION sin=
ce
> we can do this at zero cost as part of a compound.
> Cache this information as long as the lease is held and return and serve =
any
> future requests from cache.
>
> This allows us to serve "stat /<mountpoint>" directly from cache and avoi=
d
> a network roundtrip.  Since clients often want to do this quite a lot
> this improve performance slightly.
>
> As an example: xfstest generic/533 performs 43 stat operations on the roo=
t
> of the share while it is run. Which are eliminated with this patch.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsglob.h  |   3 ++
>  fs/cifs/smb2inode.c |  15 ++++---
>  fs/cifs/smb2ops.c   | 113 +++++++++++++++++++++++++++++++++++++++++++---=
------
>  fs/cifs/smb2pdu.c   |  12 +++---
>  fs/cifs/smb2proto.h |   3 ++
>  5 files changed, 118 insertions(+), 28 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index f293e052e351..b8360ca221eb 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -962,11 +962,14 @@ cap_unix(struct cifs_ses *ses)
>
>  struct cached_fid {
>         bool is_valid:1;        /* Do we have a useable root fid */
> +       bool file_all_info_is_valid:1;
> +
>         struct kref refcount;
>         struct cifs_fid *fid;
>         struct mutex fid_mutex;
>         struct cifs_tcon *tcon;
>         struct work_struct lease_break;
> +       struct smb2_file_all_info file_all_info;
>  };
>
>  /*
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 01a76bccdb8d..b6e07e2eed10 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -309,12 +309,17 @@ smb2_query_path_info(const unsigned int xid, struct=
 cifs_tcon *tcon,
>                 rc =3D open_shroot(xid, tcon, &fid);
>                 if (rc)
>                         goto out;
> -               rc =3D SMB2_query_info(xid, tcon, fid.persistent_fid,
> -                                    fid.volatile_fid, smb2_data);
> +
> +               if (tcon->crfid.file_all_info_is_valid) {
> +                       move_smb2_info_to_cifs(data,
> +                                              &tcon->crfid.file_all_info=
);
> +               } else {
> +                       rc =3D SMB2_query_info(xid, tcon, fid.persistent_=
fid,
> +                                            fid.volatile_fid, smb2_data)=
;
> +                       if (!rc)
> +                               move_smb2_info_to_cifs(data, smb2_data);
> +               }
>                 close_shroot(&tcon->crfid);
> -               if (rc)
> -                       goto out;
> -               move_smb2_info_to_cifs(data, smb2_data);
>                 goto out;
>         }
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 085e91436da7..5f2487e88c9d 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -619,6 +619,7 @@ smb2_close_cached_fid(struct kref *ref)
>                 SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
>                            cfid->fid->volatile_fid);
>                 cfid->is_valid =3D false;
> +               cfid->file_all_info_is_valid =3D false;
>         }
>  }
>
> @@ -643,9 +644,18 @@ smb2_cached_lease_break(struct work_struct *work)
>   */
>  int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fi=
d *pfid)
>  {
> -       struct cifs_open_parms oparams;
> -       int rc;
> -       __le16 srch_path =3D 0; /* Null - since an open of top of share *=
/
> +       struct cifs_ses *ses =3D tcon->ses;
> +       struct TCP_Server_Info *server =3D ses->server;
> +       struct cifs_open_parms oparms;
> +       struct smb2_create_rsp *o_rsp =3D NULL;
> +       struct smb2_query_info_rsp *qi_rsp =3D NULL;
> +       int resp_buftype[2];
> +       struct smb_rqst rqst[2];
> +       struct kvec rsp_iov[2];
> +       struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> +       struct kvec qi_iov[1];
> +       int rc, flags =3D 0;
> +       __le16 utf16_path =3D 0; /* Null - since an open of top of share =
*/
>         u8 oplock =3D SMB2_OPLOCK_LEVEL_II;
>
>         mutex_lock(&tcon->crfid.fid_mutex);
> @@ -657,22 +667,89 @@ int open_shroot(unsigned int xid, struct cifs_tcon =
*tcon, struct cifs_fid *pfid)
>                 return 0;
>         }
>
> -       oparams.tcon =3D tcon;
> -       oparams.create_options =3D 0;
> -       oparams.desired_access =3D FILE_READ_ATTRIBUTES;
> -       oparams.disposition =3D FILE_OPEN;
> -       oparams.fid =3D pfid;
> -       oparams.reconnect =3D false;
> -
> -       rc =3D SMB2_open(xid, &oparams, &srch_path, &oplock, NULL, NULL, =
NULL);
> -       if (rc =3D=3D 0) {
> -               memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
> -               tcon->crfid.tcon =3D tcon;
> -               tcon->crfid.is_valid =3D true;
> -               kref_init(&tcon->crfid.refcount);
> -               kref_get(&tcon->crfid.refcount);
> -       }
> +       if (smb3_encryption_required(tcon))
> +               flags |=3D CIFS_TRANSFORM_REQ;
> +
> +       memset(rqst, 0, sizeof(rqst));
> +       resp_buftype[0] =3D resp_buftype[1] =3D CIFS_NO_BUFFER;
> +       memset(rsp_iov, 0, sizeof(rsp_iov));
> +
> +       /* Open */
> +       memset(&open_iov, 0, sizeof(open_iov));
> +       rqst[0].rq_iov =3D open_iov;
> +       rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
> +
> +       oparms.tcon =3D tcon;
> +       oparms.create_options =3D 0;
> +       oparms.desired_access =3D FILE_READ_ATTRIBUTES;
> +       oparms.disposition =3D FILE_OPEN;
> +       oparms.fid =3D pfid;
> +       oparms.reconnect =3D false;
> +
> +       rc =3D SMB2_open_init(tcon, &rqst[0], &oplock, &oparms, &utf16_pa=
th);
> +       if (rc)
> +               goto oshr_exit;
> +       smb2_set_next_command(tcon, &rqst[0]);
> +
> +       memset(&qi_iov, 0, sizeof(qi_iov));
> +       rqst[1].rq_iov =3D qi_iov;
> +       rqst[1].rq_nvec =3D 1;
> +
> +       rc =3D SMB2_query_info_init(tcon, &rqst[1], COMPOUND_FID,
> +                                 COMPOUND_FID, FILE_ALL_INFORMATION,
> +                                 SMB2_O_INFO_FILE, 0,
> +                                 sizeof(struct smb2_file_all_info) +
> +                                 PATH_MAX * 2, 0, NULL);
> +       if (rc)
> +               goto oshr_exit;
> +
> +       smb2_set_related(&rqst[1]);
> +
> +       rc =3D compound_send_recv(xid, ses, flags, 2, rqst,
> +                               resp_buftype, rsp_iov);
> +       if (rc)
> +               goto oshr_exit;
> +
> +       o_rsp =3D (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> +       oparms.fid->persistent_fid =3D o_rsp->PersistentFileId;
> +       oparms.fid->volatile_fid =3D o_rsp->VolatileFileId;
> +#ifdef CONFIG_CIFS_DEBUG2
> +       oparms.fid->mid =3D le64_to_cpu(o_rsp->sync_hdr.MessageId);
> +#endif /* CIFS_DEBUG2 */
> +
> +       if (o_rsp->OplockLevel =3D=3D SMB2_OPLOCK_LEVEL_LEASE)
> +               oplock =3D smb2_parse_lease_state(server, o_rsp,
> +                                               &oparms.fid->epoch,
> +                                               oparms.fid->lease_key);
> +       else
> +               goto oshr_exit;
> +
> +
> +       memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
> +       tcon->crfid.tcon =3D tcon;
> +       tcon->crfid.is_valid =3D true;
> +       kref_init(&tcon->crfid.refcount);
> +       kref_get(&tcon->crfid.refcount);
> +
> +
> +       qi_rsp =3D (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> +       if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_=
file_all_info))
> +               goto oshr_exit;
> +       rc =3D smb2_validate_and_copy_iov(
> +                               le16_to_cpu(qi_rsp->OutputBufferOffset),
> +                               sizeof(struct smb2_file_all_info),
> +                               &rsp_iov[1], sizeof(struct smb2_file_all_=
info),
> +                               (char *)&tcon->crfid.file_all_info);
> +       if (rc)
> +               goto oshr_exit;
> +       tcon->crfid.file_all_info_is_valid =3D 1;
> +
> + oshr_exit:
>         mutex_unlock(&tcon->crfid.fid_mutex);
> +       SMB2_open_free(&rqst[0]);
> +       SMB2_query_info_free(&rqst[1]);
> +       free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> +       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
>         return rc;
>  }
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 60fbe306f604..cfe9fe41ccf5 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1797,9 +1797,10 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
>         return buf;
>  }
>
> -static __u8
> -parse_lease_state(struct TCP_Server_Info *server, struct smb2_create_rsp=
 *rsp,
> -                 unsigned int *epoch, char *lease_key)
> +__u8
> +smb2_parse_lease_state(struct TCP_Server_Info *server,
> +                      struct smb2_create_rsp *rsp,
> +                      unsigned int *epoch, char *lease_key)
>  {
>         char *data_offset;
>         struct create_context *cc;
> @@ -2456,8 +2457,9 @@ SMB2_open(const unsigned int xid, struct cifs_open_=
parms *oparms, __le16 *path,
>         }
>
>         if (rsp->OplockLevel =3D=3D SMB2_OPLOCK_LEVEL_LEASE)
> -               *oplock =3D parse_lease_state(server, rsp, &oparms->fid->=
epoch,
> -                                           oparms->fid->lease_key);
> +               *oplock =3D smb2_parse_lease_state(server, rsp,
> +                                                &oparms->fid->epoch,
> +                                                oparms->fid->lease_key);
>         else
>                 *oplock =3D rsp->OplockLevel;
>  creat_exit:
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 87733b27a65f..72cc563c32fe 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -223,6 +223,9 @@ extern int smb3_validate_negotiate(const unsigned int=
, struct cifs_tcon *);
>
>  extern enum securityEnum smb2_select_sectype(struct TCP_Server_Info *,
>                                         enum securityEnum);
> +extern __u8 smb2_parse_lease_state(struct TCP_Server_Info *server,
> +                                  struct smb2_create_rsp *rsp,
> +                                  unsigned int *epoch, char *lease_key);
>  extern int smb3_encryption_required(const struct cifs_tcon *tcon);
>  extern int smb2_validate_iov(unsigned int offset, unsigned int buffer_le=
ngth,
>                              struct kvec *iov, unsigned int min_buf_size)=
;
> --
> 2.13.6
>

Looks good now.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
