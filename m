Return-Path: <SRS0=iY7O=R7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 081AAC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 19:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE3FA2173C
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 19:06:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilpnuumy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfC1TGS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Mar 2019 15:06:18 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37704 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfC1TGS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Mar 2019 15:06:18 -0400
Received: by mail-lj1-f196.google.com with SMTP id v13so18667455ljk.4
        for <linux-cifs@vger.kernel.org>; Thu, 28 Mar 2019 12:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iQXIWr+0Yp4jCVJobMT6euHjChhXEfgs7SEzZ2bZBSo=;
        b=ilpnuumyUG1Pg6nS8eTG/zJi01s0vbemPB1TQBqsXtFVQ8ikJatBaLV7jT4F66rAFM
         L1xLqvvTfDmoubAc5c5SCTM3BDJDIBGDy3gR5kAWgzM8bxkd1JviQnTWCR7E4qwhL4te
         9DW+JKVwnQRBmbWAwasHvcV1H/wx5nmvIcbCLZ3u1mSP67D7FdjxYhhyAP3g5TaOtlW9
         Akqz5amqCs2lu3YihJCQii3345AsTreCvWcpMLFhGxR5hJuqR8jYFXwofixdzcr3K9pe
         jlPCDsX6HRbqe02REokwwbo0hwXzqgjEzbZah/HjSY+CjNSoIVOz/J2IWHjxVgK8+Lmy
         SfXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iQXIWr+0Yp4jCVJobMT6euHjChhXEfgs7SEzZ2bZBSo=;
        b=S6yTb2NFxPvQrF98OhvZWSZCP4ehQAgm5RQ5RJTkpRUXVKEW6e5Zl9Aiqt7IezhdGA
         v8Xn7MesFyllA+JjcN9bhlhPZGunPwdNMXrcAEHkumINiWB/FpForEcO4lLw1cr4Ddah
         UVCsjd9LAzFGb79E2uwKIz7jMs6j8/WzWkeHhKx+Ga58duR5HWipXzsV+vsEoGbFiIQx
         ab8fslkOC1ZAeskjRL345An1gVSnxmMWv0qj3VCj84rr+Bm+8PHceGU0S2/TMI6RORbU
         rGV9JPSk07KBmxVtb3+KpegdKOHtCb5wNf0Zo18G8SmI7wSEIJXdAok1k14nsnYC3RcU
         sHdw==
X-Gm-Message-State: APjAAAVkbpnqHM+zmCNOryRHVDtmNH0xwUfWypiLSetLXtYj3+IyMs7r
        jdN4svb5gFXqqlCUCqmrG63gWxtyjaKAI0tkww==
X-Google-Smtp-Source: APXvYqyyVNNSVpdbxWvJ9R6/DquwAnMhI86Ygrk4aslFlli8u/1L6FwTVeciKWaNEe8NVS0oKCPqsD/Tf1j8co5hAvc=
X-Received: by 2002:a2e:5bdb:: with SMTP id m88mr22609151lje.9.1553799975973;
 Thu, 28 Mar 2019 12:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190328012002.842-1-lsahlber@redhat.com> <CAH2r5mvCC95ve_VFGoE+4ckujA8eXcSGFj6qs+jzpeZVrJ-Gpg@mail.gmail.com>
 <CAN05THTubng_fpT=m7waayzVRz2sd9Utqt=5fNgwSBgm7n-zaA@mail.gmail.com>
In-Reply-To: <CAN05THTubng_fpT=m7waayzVRz2sd9Utqt=5fNgwSBgm7n-zaA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 28 Mar 2019 12:06:04 -0700
Message-ID: <CAKywueRuRA+=0JLZwVYNGM5wUvt9qq9Nb_ohKni0QLfX9OTYng@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix kref underflow in close_shroot()
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 27 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 22:27, ronnie sahl=
berg <ronniesahlberg@gmail.com>:
>
> Yeah, probably
>
> On Thu, Mar 28, 2019 at 3:11 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Should this be CC:stable?
> >
> > On Wed, Mar 27, 2019 at 8:21 PM Ronnie Sahlberg <lsahlber@redhat.com> w=
rote:
> > >
> > > Fix a bug where we used to not initialize the cached fid structure at=
 all
> > > in open_shroot() if the open was successful but we did not get a leas=
e.
> > > This would leave the structure uninitialized and later when we close =
the handle
> > > we would in close_shroot() try to kref_put() an uninitialized refcoun=
t.
> > >
> > > Fix this by always initializing this structure if the open was succes=
sful
> > > but only do the extra get() if we got a lease.
> > > This extra get() is only used to hold the structure until we get a le=
ase
> > > break from the server at which point we will kref_put() it during lea=
se
> > > processing.
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/smb2ops.c | 16 +++++++---------
> > >  1 file changed, 7 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > > index 1022a3771e14..7cfafac255aa 100644
> > > --- a/fs/cifs/smb2ops.c
> > > +++ b/fs/cifs/smb2ops.c
> > > @@ -717,20 +717,18 @@ int open_shroot(unsigned int xid, struct cifs_t=
con *tcon, struct cifs_fid *pfid)
> > >         oparms.fid->mid =3D le64_to_cpu(o_rsp->sync_hdr.MessageId);
> > >  #endif /* CIFS_DEBUG2 */
> > >
> > > -       if (o_rsp->OplockLevel =3D=3D SMB2_OPLOCK_LEVEL_LEASE)
> > > -               oplock =3D smb2_parse_lease_state(server, o_rsp,
> > > -                                               &oparms.fid->epoch,
> > > -                                               oparms.fid->lease_key=
);
> > > -       else
> > > -               goto oshr_exit;
> > > -
> > > -
> > >         memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
> > >         tcon->crfid.tcon =3D tcon;
> > >         tcon->crfid.is_valid =3D true;
> > >         kref_init(&tcon->crfid.refcount);
> > > -       kref_get(&tcon->crfid.refcount);
> > >
> > > +       if (o_rsp->OplockLevel =3D=3D SMB2_OPLOCK_LEVEL_LEASE) {
> > > +               kref_get(&tcon->crfid.refcount);
> > > +               oplock =3D smb2_parse_lease_state(server, o_rsp,
> > > +                                               &oparms.fid->epoch,
> > > +                                               oparms.fid->lease_key=
);
> > > +       } else
> > > +               goto oshr_exit;
> > >
> > >         qi_rsp =3D (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> > >         if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct s=
mb2_file_all_info))
> > > --
> > > 2.13.6
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve

This part of the fix looks good but there is another piece remaining:

rc =3D smb2_validate_and_copy_iov(
    le16_to_cpu(qi_rsp->OutputBufferOffset),
    sizeof(struct smb2_file_all_info),
    &rsp_iov[1], sizeof(struct smb2_file_all_info),
    (char *)&tcon->crfid.file_all_info);
if (rc)
    goto oshr_exit;
    ^^^
here RC is non-zero, but we are returning with 2 references on the
handle. The caller will assume that the open failed and doesn't call
close_shroot thus leaking one reference.

The result of smb2_validate_and_copy_iov only affects file_all_info
caching but doesn't affect the handle validity. So, RC needs to be
reset to 0 unconditionally here before returning from the function.

I checked v5.0 kernel and it doesn't seem it is affected by this bug
but it has the problem that it doesn't check whether server granted
the lease or not - probably it is not that bad to keep the reference
forever for non-leased opens, so leaving it for your choice to fix it
or not.

--
Best regards,
Pavel Shilovsky
