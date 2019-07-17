Return-Path: <SRS0=9NYC=VO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96C2C7618F
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Jul 2019 21:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A87852173E
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Jul 2019 21:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MUMf6W9O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfGQVkW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Jul 2019 17:40:22 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44921 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbfGQVkW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Jul 2019 17:40:22 -0400
Received: by mail-io1-f66.google.com with SMTP id s7so48077154iob.11
        for <linux-cifs@vger.kernel.org>; Wed, 17 Jul 2019 14:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EPdBLyHeuxd44JNpMqh3BE6pHmSM3ZU1zHSdXyPsOuM=;
        b=MUMf6W9OdR1XqgxcknSxjUvldCH5roGvEf0I2k0c3Gb4PnZxJgK8PwqoDeQTCQDTKM
         LXR3Q1NwUuRdZMS4Fjdsf0IHa1U5+gicu1aIURrvIKQw4Bnwuujs5pZG2pDzoqosGCLU
         1hxGCzvYFKTDce3LbxxHAK9SFZyK91pnnwYfBxa2vdzZSZXUHgG2DH8R/i1VOZ+M71Cf
         wuzZTV3S4azazI2P5mJX3ezNTgnXt/ielk4ea6Fye5zvztuBjKcJHnocTMIFnxwISzks
         MY2EiFCRtFmNq/AN1gzGvt2VwUkCYkdqeFfjHRxhOe8Ptq1Yp9JhPDUHjP8Uo9NDFCHF
         m5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EPdBLyHeuxd44JNpMqh3BE6pHmSM3ZU1zHSdXyPsOuM=;
        b=qXN23A4Ij+WR0lkAeCTc208omUB1SRd2VqoYyEXB5tNcLSiZzxcFDCHaTK7rB/MLMi
         qxNPcSQktknU5MLEdd1AhJp2dnbPGKPfcFkjMTOTHpRll3C3h0/ctmCxhfEE//oH4dqe
         l2sWtyQluo8FJLHBRh7yaymX5Rgn9Px1rfubBBCFdMzQDPIWz9/dzLZ3Q+FExlOzgDBm
         lylp1ebZaYuxbi/QKnW66Jmir7QxOkTHW/53jP/AsgWdZLhYW4CANIOfLCFvotRYGQk/
         21K2RgcWTafLGFVbFuEMcfdZAXLSCZZAjZtx9U+YWcYQ3U1cVsHFpQp1Sjh4dpqDARdL
         iTeA==
X-Gm-Message-State: APjAAAXbIMtUaiZ7qI5JHO0A2XLWkd251zK/5U/UXlrafPMqAA+AMLDN
        AHNY7at+OEoHOY81U95MdTz0QVORON9ToL7zEOg=
X-Google-Smtp-Source: APXvYqwcepkEnG5gusQOWOMRXWcigTU4LfHsVeER9K2EFrdbMqaRTKbv24EyDrVsOikafvcBLAyk7wMpsR3oYjCONXU=
X-Received: by 2002:a05:6638:5:: with SMTP id z5mr45387308jao.58.1563399620813;
 Wed, 17 Jul 2019 14:40:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190716050708.14482-1-lsahlber@redhat.com> <CAKywueRkV6uB3494b8LCuuRvqiXE2VzxEHx3a2B7sw5goxB7UA@mail.gmail.com>
In-Reply-To: <CAKywueRkV6uB3494b8LCuuRvqiXE2VzxEHx3a2B7sw5goxB7UA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 18 Jul 2019 07:40:09 +1000
Message-ID: <CAN05THS72jrOZ3f2nOrVcz3DcYvPPOz7Jg92m27h0hrWVcJQHA@mail.gmail.com>
Subject: Re: [PATCH] cifs: prepare SMB2_Flush to be usable in compounds
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jul 18, 2019 at 4:48 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D0=BF=D0=BD, 15 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 22:07, Ronnie Sa=
hlberg <lsahlber@redhat.com>:
> >
> > Create smb2_flush_init() and smb2_flush_free() so we can use the flush =
command
> > in compounds.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/smb2pdu.c   | 58 ++++++++++++++++++++++++++++++++++++---------=
--------
> >  fs/cifs/smb2proto.h |  4 ++++
> >  2 files changed, 44 insertions(+), 18 deletions(-)
> >
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index f58e4dc3987b..b352f453a6d2 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -3262,44 +3262,64 @@ SMB2_echo(struct TCP_Server_Info *server)
> >         return rc;
> >  }
> >
> > +void
> > +SMB2_flush_free(struct smb_rqst *rqst)
> > +{
> > +       if (rqst && rqst->rq_iov)
> > +               cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* re=
quest */
> > +}
> > +
> >  int
> > -SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persist=
ent_fid,
> > -          u64 volatile_fid)
> > +SMB2_flush_init(const unsigned int xid, struct smb_rqst *rqst,
> > +               struct cifs_tcon *tcon, u64 persistent_fid, u64 volatil=
e_fid)
> >  {
> > -       struct smb_rqst rqst;
> >         struct smb2_flush_req *req;
> > -       struct cifs_ses *ses =3D tcon->ses;
> > -       struct kvec iov[1];
> > -       struct kvec rsp_iov;
> > -       int resp_buftype;
> > -       int rc =3D 0;
> > -       int flags =3D 0;
> > +       struct kvec *iov =3D rqst->rq_iov;
> >         unsigned int total_len;
> > -
> > -       cifs_dbg(FYI, "Flush\n");
> > -
> > -       if (!ses || !(ses->server))
> > -               return -EIO;
> > +       int rc;
> >
> >         rc =3D smb2_plain_req_init(SMB2_FLUSH, tcon, (void **) &req, &t=
otal_len);
> >         if (rc)
> >                 return rc;
> >
> > -       if (smb3_encryption_required(tcon))
> > -               flags |=3D CIFS_TRANSFORM_REQ;
> > -
> >         req->PersistentFileId =3D persistent_fid;
> >         req->VolatileFileId =3D volatile_fid;
> >
> >         iov[0].iov_base =3D (char *)req;
> >         iov[0].iov_len =3D total_len;
> >
> > +       return 0;
> > +}
> > +
> > +int
> > +SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persist=
ent_fid,
> > +          u64 volatile_fid)
> > +{
> > +       struct cifs_ses *ses =3D tcon->ses;
> > +       struct smb_rqst rqst;
> > +       struct kvec iov[1];
> > +       struct kvec rsp_iov =3D {NULL, 0};
> > +       int resp_buftype =3D CIFS_NO_BUFFER;
> > +       int flags =3D 0;
> > +       int rc =3D 0;
> > +
> > +       cifs_dbg(FYI, "flush\n");
> > +       if (!ses || !(ses->server))
> > +               return -EIO;
> > +
> > +       if (smb3_encryption_required(tcon))
> > +               flags |=3D CIFS_TRANSFORM_REQ;
> > +
> >         memset(&rqst, 0, sizeof(struct smb_rqst));
> > +       memset(&iov, 0, sizeof(iov));
> >         rqst.rq_iov =3D iov;
> >         rqst.rq_nvec =3D 1;
> >
> > +       rc =3D SMB2_flush_init(xid, &rqst, tcon, persistent_fid, volati=
le_fid);
> > +       if (rc)
> > +               goto flush_exit;
> > +
> >         rc =3D cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &r=
sp_iov);
> > -       cifs_small_buf_release(req);
> >
> >         if (rc !=3D 0) {
> >                 cifs_stats_fail_inc(tcon, SMB2_FLUSH_HE);
> > @@ -3307,6 +3327,8 @@ SMB2_flush(const unsigned int xid, struct cifs_tc=
on *tcon, u64 persistent_fid,
> >                                      rc);
> >         }
> >
> > + flush_exit:
>
> The extra space before the label is not needed.
>
> > +       SMB2_flush_free(&rqst);
> >         free_rsp_buf(resp_buftype, rsp_iov.iov_base);
> >         return rc;
> >  }
> > diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> > index 52df125e9189..e4ca98cf3af3 100644
> > --- a/fs/cifs/smb2proto.h
> > +++ b/fs/cifs/smb2proto.h
> > @@ -158,6 +158,10 @@ extern int SMB2_close_init(struct cifs_tcon *tcon,=
 struct smb_rqst *rqst,
> >  extern void SMB2_close_free(struct smb_rqst *rqst);
> >  extern int SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon,
> >                       u64 persistent_file_id, u64 volatile_file_id);
> > +extern int SMB2_flush_init(const unsigned int xid, struct smb_rqst *rq=
st,
> > +                          struct cifs_tcon *tcon,
> > +                          u64 persistent_file_id, u64 volatile_file_id=
);
> > +extern void SMB2_flush_free(struct smb_rqst *rqst);
> >  extern int SMB2_query_info(const unsigned int xid, struct cifs_tcon *t=
con,
> >                            u64 persistent_file_id, u64 volatile_file_id=
,
> >                            struct smb2_file_all_info *data);
> > --
> > 2.13.6
> >
>
> Just wondering how are you going to use this? Compound flush and
> setattr to be sent together?

Yeah, I was thinking about expeprimenting in that direction.
>
> --
> Best regards,
> Pavel Shilovsky
