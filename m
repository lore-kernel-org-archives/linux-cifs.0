Return-Path: <SRS0=BRhE=RO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7611C43381
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 22:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0C522148D
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 22:37:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DFCH2TzW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbfCKWhB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Mar 2019 18:37:01 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37714 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfCKWhA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Mar 2019 18:37:00 -0400
Received: by mail-lf1-f65.google.com with SMTP id u2so538940lfd.4
        for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2019 15:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yOGxrND5FtXTCK3muZn3GHmuyJNAF1nsAGdIl8lnhOE=;
        b=DFCH2TzW1jirV8bTzgxAFwuraic3WXPvdPZiCZN4J1Bvg0Ew09xzWyTpQMYkvz5bub
         PESlsua90JFQXdXB2t7KoKleHDRJuhJCoR+XURuHV4WPg7Lb4AoFzNNISU3usLPlUjLa
         LNM/c+yhtBIZBkFpNBYmFuej+zw14SA+8eAqZiLdOcq6VGpSP+m29WbTaqH3rVt4jkWb
         7Zm3KOr1ns+FdonDuITKMP2CXLObzIRuLAdJmGTQKwii5ZhFUgpzAxS4wmbgCHN6UD6c
         ySxYvJnFxD7GqywK7z89qHalTkFKfujGj+7bUc4eWT3oLAPq27qSE+PXgrIx+u+2Jxy8
         wNnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yOGxrND5FtXTCK3muZn3GHmuyJNAF1nsAGdIl8lnhOE=;
        b=l+Gh5+Aq52omJ8Bu1SYbxhM41nLJWd0oSZ4DhrevoWRlt9fXFJd84QfHWFlyKskP5E
         NwJd2W5LwdRKBedfnsoxKnW2e643tF8pwi8Sp/fClNEkLYEwOwiCvbLwPU0r8EATXHNI
         qqGGtC62ezTNE/UWDquOlWvpdljt1xtNa2o0lg7PKlDHtN8MF77tlcgUmnVtlti3+DDH
         xHgL2vQG8wRvKA2p8D2sknGL7431YODCq7nHPFu/Agt0IYihWiRb2kYmkLO8uHeb10nQ
         l2/MqnUmkdPBTKqx68nOWiW7GJuBYOoiEx0MyK3GL3Jn1aXgmleQA9GZBjIeoY0pzFLu
         rEOg==
X-Gm-Message-State: APjAAAV98lBnx/fGuKXqzTQFHfokH5ZrieD1i6QnAfIPhV5AOkFeuOPz
        T8yLxd6XTovuFzkGTEzjmYPkmNpHyG/oFN8BRg==
X-Google-Smtp-Source: APXvYqw8Z7z5TMWxvdw2xSOb54hZqR5uo+5bIlTEtT0xfUZ2fbOf3wvTRRcSfG0CpxHW9VTeex/SvhtkDHuVv/MRMW4=
X-Received: by 2002:a19:4d84:: with SMTP id a126mr18123878lfb.75.1552343817767;
 Mon, 11 Mar 2019 15:36:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190311060025.9750-1-lsahlber@redhat.com> <20190311060025.9750-2-lsahlber@redhat.com>
 <CAN05THRzCvh-yq8Z3p2iearCtsr0O8gWQNJC804eZspZTcWwoQ@mail.gmail.com> <CAH2r5mvCf1+ec-6Cg3gB7MqDbDtD1xOeU_kgEU4yXyg3rXgkKg@mail.gmail.com>
In-Reply-To: <CAH2r5mvCf1+ec-6Cg3gB7MqDbDtD1xOeU_kgEU4yXyg3rXgkKg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 11 Mar 2019 15:36:46 -0700
Message-ID: <CAKywueTmfDxJ7wB-9qDv24W6Pr+MEDtOe4FG_CmLg7qY4bBuVA@mail.gmail.com>
Subject: Re: [PATCH] cifs: cache FILE_ALL_INFO for the shared root handle
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I like the idea of tracing compound chain as one logical operation
because it correlates with a particular action in the user space.
Individual operations like SMB2_open() should also be traced as one
logical operation for the same reason.

With tracing we need to be able to match a particular system call with
logical operations (open, remove, setinfo) and PDU(s) (sid, tid,
mid(s)).

--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 11 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 08:39, Steve Frenc=
h <smfrench@gmail.com>:
>
> Pavel and I had talked about adding tracing in smb2_compound_op for
> enter/exit since it allows more granularity (and with dynamic tracing,
> overhead is small).  Thoughts?
>
> On Mon, Mar 11, 2019 at 7:02 AM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > As a followup discussion.
> >
> > We do tracing in SMB2_open() but not in SMB2_open_init().  Perhaps we
> > should change this to do the actual tracing in SMB2_open_init()
> > instead and catch ALL places where we try to open a file.
> > Though, we don't actually have the result of the operation in
> > _open_init() which means we may need to reconsider how we trace these
> > things.
> >
> > As we will likely switch more and more things to be compounds, maybe
> > we should not have tracing in SMB2_open() and have it trace
> > trace_smb3_open_err()
> >
> > Maybe we should trace "smb2_init : constructing compound"
> > and have trace_smb3_compound_error()
> >
> >
> > We restructure the tracing to be focused around compounds instead of
> > individual PDUs.
> > I.e. tracing in all the _init() functions, then tracing in
> > compound_send_recv() for success/error.
> >
> > Tracing success/error on pdu/compound level instead of individual
> > open/close/read/...  operations.
> > For individual non-compounded commands we can still treat these the
> > same. They are just trivial compounds of one single SMB2 PDU.
> >
> >
> > On Mon, Mar 11, 2019 at 4:01 PM Ronnie Sahlberg <lsahlber@redhat.com> w=
rote:
> > >
> > > When we open the shared root handle also ask for FILE_ALL_INFORMATION=
 since
> > > we can do this at zero cost as part of a compound.
> > > Cache this information as long as the lease is return and serve any
> > > future requests from cache.
> > >
> > > This allows us to serve "stat /<mountpoint>" directly from cache and =
avoid
> > > a network roundtrip.  Since clients ofthen need to do this quite a lo=
t
> > > this improve performance slightly.
> > >
> > > As an example: xfstest generic/533 performs 43 stat operations on the=
 root
> > > of the share while it is run. Which are eliminated with this patch.
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/cifsglob.h  |   3 ++
> > >  fs/cifs/smb2inode.c |  15 ++++---
> > >  fs/cifs/smb2ops.c   | 111 ++++++++++++++++++++++++++++++++++++++++++=
+---------
> > >  fs/cifs/smb2pdu.c   |  12 +++---
> > >  fs/cifs/smb2proto.h |   3 ++
> > >  5 files changed, 116 insertions(+), 28 deletions(-)
> > >
> > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > index f293e052e351..b8360ca221eb 100644
> > > --- a/fs/cifs/cifsglob.h
> > > +++ b/fs/cifs/cifsglob.h
> > > @@ -962,11 +962,14 @@ cap_unix(struct cifs_ses *ses)
> > >
> > >  struct cached_fid {
> > >         bool is_valid:1;        /* Do we have a useable root fid */
> > > +       bool file_all_info_is_valid:1;
> > > +
> > >         struct kref refcount;
> > >         struct cifs_fid *fid;
> > >         struct mutex fid_mutex;
> > >         struct cifs_tcon *tcon;
> > >         struct work_struct lease_break;
> > > +       struct smb2_file_all_info file_all_info;
> > >  };
> > >
> > >  /*
> > > diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> > > index 01a76bccdb8d..b6e07e2eed10 100644
> > > --- a/fs/cifs/smb2inode.c
> > > +++ b/fs/cifs/smb2inode.c
> > > @@ -309,12 +309,17 @@ smb2_query_path_info(const unsigned int xid, st=
ruct cifs_tcon *tcon,
> > >                 rc =3D open_shroot(xid, tcon, &fid);
> > >                 if (rc)
> > >                         goto out;
> > > -               rc =3D SMB2_query_info(xid, tcon, fid.persistent_fid,
> > > -                                    fid.volatile_fid, smb2_data);
> > > +
> > > +               if (tcon->crfid.file_all_info_is_valid) {
> > > +                       move_smb2_info_to_cifs(data,
> > > +                                              &tcon->crfid.file_all_=
info);
> > > +               } else {
> > > +                       rc =3D SMB2_query_info(xid, tcon, fid.persist=
ent_fid,
> > > +                                            fid.volatile_fid, smb2_d=
ata);
> > > +                       if (!rc)
> > > +                               move_smb2_info_to_cifs(data, smb2_dat=
a);
> > > +               }
> > >                 close_shroot(&tcon->crfid);
> > > -               if (rc)
> > > -                       goto out;
> > > -               move_smb2_info_to_cifs(data, smb2_data);
> > >                 goto out;
> > >         }
> > >
> > > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > > index 085e91436da7..0d8bf87592ff 100644
> > > --- a/fs/cifs/smb2ops.c
> > > +++ b/fs/cifs/smb2ops.c
> > > @@ -619,6 +619,7 @@ smb2_close_cached_fid(struct kref *ref)
> > >                 SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
> > >                            cfid->fid->volatile_fid);
> > >                 cfid->is_valid =3D false;
> > > +               cfid->file_all_info_is_valid =3D false;
> > >         }
> > >  }
> > >
> > > @@ -643,9 +644,18 @@ smb2_cached_lease_break(struct work_struct *work=
)
> > >   */
> > >  int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cif=
s_fid *pfid)
> > >  {
> > > -       struct cifs_open_parms oparams;
> > > -       int rc;
> > > -       __le16 srch_path =3D 0; /* Null - since an open of top of sha=
re */
> > > +       struct cifs_ses *ses =3D tcon->ses;
> > > +       struct TCP_Server_Info *server =3D ses->server;
> > > +       struct cifs_open_parms oparms;
> > > +       struct smb2_create_rsp *o_rsp =3D NULL;
> > > +       struct smb2_query_info_rsp *qi_rsp =3D NULL;
> > > +       int resp_buftype[2];
> > > +       struct smb_rqst rqst[2];
> > > +       struct kvec rsp_iov[2];
> > > +       struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> > > +       struct kvec qi_iov[1];
> > > +       int rc, flags =3D 0;
> > > +       __le16 utf16_path =3D 0; /* Null - since an open of top of sh=
are */
> > >         u8 oplock =3D SMB2_OPLOCK_LEVEL_II;
> > >
> > >         mutex_lock(&tcon->crfid.fid_mutex);
> > > @@ -657,22 +667,87 @@ int open_shroot(unsigned int xid, struct cifs_t=
con *tcon, struct cifs_fid *pfid)
> > >                 return 0;
> > >         }
> > >
> > > -       oparams.tcon =3D tcon;
> > > -       oparams.create_options =3D 0;
> > > -       oparams.desired_access =3D FILE_READ_ATTRIBUTES;
> > > -       oparams.disposition =3D FILE_OPEN;
> > > -       oparams.fid =3D pfid;
> > > -       oparams.reconnect =3D false;
> > > -
> > > -       rc =3D SMB2_open(xid, &oparams, &srch_path, &oplock, NULL, NU=
LL, NULL);
> > > -       if (rc =3D=3D 0) {
> > > -               memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid)=
);
> > > -               tcon->crfid.tcon =3D tcon;
> > > -               tcon->crfid.is_valid =3D true;
> > > -               kref_init(&tcon->crfid.refcount);
> > > -               kref_get(&tcon->crfid.refcount);
> > > -       }
> > > +       if (smb3_encryption_required(tcon))
> > > +               flags |=3D CIFS_TRANSFORM_REQ;
> > > +
> > > +       memset(rqst, 0, sizeof(rqst));
> > > +       resp_buftype[0] =3D resp_buftype[1] =3D CIFS_NO_BUFFER;
> > > +       memset(rsp_iov, 0, sizeof(rsp_iov));
> > > +
> > > +       /* Open */
> > > +       memset(&open_iov, 0, sizeof(open_iov));
> > > +       rqst[0].rq_iov =3D open_iov;
> > > +       rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
> > > +
> > > +       oparms.tcon =3D tcon;
> > > +       oparms.create_options =3D 0;
> > > +       oparms.desired_access =3D FILE_READ_ATTRIBUTES;
> > > +       oparms.disposition =3D FILE_OPEN;
> > > +       oparms.fid =3D pfid;
> > > +       oparms.reconnect =3D false;
> > > +
> > > +       rc =3D SMB2_open_init(tcon, &rqst[0], &oplock, &oparms, &utf1=
6_path);
> > > +       if (rc)
> > > +               goto oshr_exit;
> > > +       smb2_set_next_command(tcon, &rqst[0]);
> > > +
> > > +       memset(&qi_iov, 0, sizeof(qi_iov));
> > > +       rqst[1].rq_iov =3D qi_iov;
> > > +       rqst[1].rq_nvec =3D 1;
> > > +
> > > +       rc =3D SMB2_query_info_init(tcon, &rqst[1], COMPOUND_FID,
> > > +                                 COMPOUND_FID, FILE_ALL_INFORMATION,
> > > +                                 SMB2_O_INFO_FILE, 0,
> > > +                                 sizeof(struct smb2_file_all_info) +
> > > +                                 PATH_MAX * 2, 0, NULL);
> > > +       if (rc)
> > > +               goto oshr_exit;
> > > +
> > > +       smb2_set_related(&rqst[1]);
> > > +
> > > +       rc =3D compound_send_recv(xid, ses, flags, 2, rqst,
> > > +                               resp_buftype, rsp_iov);
> > > +       if (rc)
> > > +               goto oshr_exit;
> > > +
> > > +       o_rsp =3D (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> > > +       oparms.fid->persistent_fid =3D o_rsp->PersistentFileId;
> > > +       oparms.fid->volatile_fid =3D o_rsp->VolatileFileId;
> > > +#ifdef CONFIG_CIFS_DEBUG2
> > > +       oparms.fid->mid =3D le64_to_cpu(o_rsp->sync_hdr.MessageId);
> > > +#endif /* CIFS_DEBUG2 */
> > > +
> > > +       if (o_rsp->OplockLevel =3D=3D SMB2_OPLOCK_LEVEL_LEASE)
> > > +               oplock =3D smb2_parse_lease_state(server, o_rsp,
> > > +                                               &oparms.fid->epoch,
> > > +                                               oparms.fid->lease_key=
);
> > > +       else
> > > +               goto oshr_exit;
> > > +
> > > +
> > > +       memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
> > > +       tcon->crfid.tcon =3D tcon;
> > > +       tcon->crfid.is_valid =3D true;
> > > +       kref_init(&tcon->crfid.refcount);
> > > +       kref_get(&tcon->crfid.refcount);
> > > +
> > > +
> > > +       qi_rsp =3D (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> > > +       rc =3D smb2_validate_and_copy_iov(
> > > +                               le16_to_cpu(qi_rsp->OutputBufferOffse=
t),
> > > +                               le32_to_cpu(qi_rsp->OutputBufferLengt=
h),
> > > +                               &rsp_iov[1], sizeof(struct smb2_file_=
all_info),
> > > +                               (char *)&tcon->crfid.file_all_info);
> > > +       if (rc)
> > > +               goto oshr_exit;
> > > +       tcon->crfid.file_all_info_is_valid =3D 1;
> > > +
> > > + oshr_exit:
> > >         mutex_unlock(&tcon->crfid.fid_mutex);
> > > +       SMB2_open_free(&rqst[0]);
> > > +       SMB2_query_info_free(&rqst[1]);
> > > +       free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> > > +       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> > >         return rc;
> > >  }
> > >
> > > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > > index 60fbe306f604..cfe9fe41ccf5 100644
> > > --- a/fs/cifs/smb2pdu.c
> > > +++ b/fs/cifs/smb2pdu.c
> > > @@ -1797,9 +1797,10 @@ create_reconnect_durable_buf(struct cifs_fid *=
fid)
> > >         return buf;
> > >  }
> > >
> > > -static __u8
> > > -parse_lease_state(struct TCP_Server_Info *server, struct smb2_create=
_rsp *rsp,
> > > -                 unsigned int *epoch, char *lease_key)
> > > +__u8
> > > +smb2_parse_lease_state(struct TCP_Server_Info *server,
> > > +                      struct smb2_create_rsp *rsp,
> > > +                      unsigned int *epoch, char *lease_key)
> > >  {
> > >         char *data_offset;
> > >         struct create_context *cc;
> > > @@ -2456,8 +2457,9 @@ SMB2_open(const unsigned int xid, struct cifs_o=
pen_parms *oparms, __le16 *path,
> > >         }
> > >
> > >         if (rsp->OplockLevel =3D=3D SMB2_OPLOCK_LEVEL_LEASE)
> > > -               *oplock =3D parse_lease_state(server, rsp, &oparms->f=
id->epoch,
> > > -                                           oparms->fid->lease_key);
> > > +               *oplock =3D smb2_parse_lease_state(server, rsp,
> > > +                                                &oparms->fid->epoch,
> > > +                                                oparms->fid->lease_k=
ey);
> > >         else
> > >                 *oplock =3D rsp->OplockLevel;
> > >  creat_exit:
> > > diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> > > index 87733b27a65f..72cc563c32fe 100644
> > > --- a/fs/cifs/smb2proto.h
> > > +++ b/fs/cifs/smb2proto.h
> > > @@ -223,6 +223,9 @@ extern int smb3_validate_negotiate(const unsigned=
 int, struct cifs_tcon *);
> > >
> > >  extern enum securityEnum smb2_select_sectype(struct TCP_Server_Info =
*,
> > >                                         enum securityEnum);
> > > +extern __u8 smb2_parse_lease_state(struct TCP_Server_Info *server,
> > > +                                  struct smb2_create_rsp *rsp,
> > > +                                  unsigned int *epoch, char *lease_k=
ey);
> > >  extern int smb3_encryption_required(const struct cifs_tcon *tcon);
> > >  extern int smb2_validate_iov(unsigned int offset, unsigned int buffe=
r_length,
> > >                              struct kvec *iov, unsigned int min_buf_s=
ize);
> > > --
> > > 2.13.6
> > >
>
>
>
> --
> Thanks,
>
> Steve
