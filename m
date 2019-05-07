Return-Path: <SRS0=vQ6B=TH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0634EC004C9
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 18:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA1B320656
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 18:28:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hjEGDLuO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfEGS2w (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 May 2019 14:28:52 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41978 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfEGS2w (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 May 2019 14:28:52 -0400
Received: by mail-lf1-f67.google.com with SMTP id d8so12562439lfb.8;
        Tue, 07 May 2019 11:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uAxHVQCsBo1b5PlzfwAXI4RufhZYGzT/dUPxeSN4rRc=;
        b=hjEGDLuO2QkLFE8Scimbk32wX+OqUolVirFNhseP74IGhXIAWEtuYU5TRLGFPXeMoy
         V99BKgFguxrWHHkqwFK3m4I9tpkLvyr49I0nLrWvzgCN9IEmfvRRD313pFeeajY+dG88
         VDec2lVe5xV+COKmhh8tuB/yR9jlX6Y1xSW/DscySsqLUNspbvMG6IpTkgE2vyUqIWLh
         WhLUCP/qh3zrcwy1PGZReAeZu/bEG3YP8jmDJHw7z8Pa/ZQt/HwaizKaB1PfyAR7Xy6X
         m8qV5vv4DgonM+sp1SuNzIPUGQehozrnPS1S48fcfic4emtxfvT1oycRfAJZTbbAuj2C
         MKog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uAxHVQCsBo1b5PlzfwAXI4RufhZYGzT/dUPxeSN4rRc=;
        b=lWaE6hh0juyFLPMgnbl42J41HZC1Jic9OMxaa6PWcgIhgqnaYFhrBYv69z0t0IcZ9i
         C785ILoeYmlhjjjiLf7SgvR+HBLLQ2QhRFpW1yK71X4rkdN5JFIebiuaTSf0bjvPBV6M
         rF10eTHLOtUezfmFx/ibePbNtTed91Of/wFmam0mrqXCeDVhU6Xx13S3tBqHsw/9YU8d
         nX853wDPlFPIb53bS7R0UX5nqcL7tBbrkFC+n45zeMWuqIlC2JkW/C2AKJFGlb2vlFhc
         wQw7kTDkyLXWJoe8EUeUkowl3w36BgYDSj2Iz6ShOFlOO7AdeoetKEYw94HpA+Vqud5v
         qf1Q==
X-Gm-Message-State: APjAAAX406jKXJ8aixBqhLb1e2oEZjv+513Lpd8KVPPf/wOinXlBvngO
        Kz3Qpg6iKD4ZZAEmN7FVTudKC9CxKgUsbblq3YHD9Bw=
X-Google-Smtp-Source: APXvYqwWE8j/YwpgzAJc07ZnEdvmNMqpEjiJgo/l8eCz+eM3VRlwhGXZEJL4TCGOh/ka/80d1PC8L4zwgaWBO1jEVxQ=
X-Received: by 2002:a19:655a:: with SMTP id c26mr13965657lfj.97.1557253730334;
 Tue, 07 May 2019 11:28:50 -0700 (PDT)
MIME-Version: 1.0
References: <1557242200-26194-1-git-send-email-kernel@probst.it> <CAH2r5mtqkHYbHJkf_LbAjhujnNRQP6Zmkmqhj1dUHomwsc3e=w@mail.gmail.com>
In-Reply-To: <CAH2r5mtqkHYbHJkf_LbAjhujnNRQP6Zmkmqhj1dUHomwsc3e=w@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 7 May 2019 11:28:39 -0700
Message-ID: <CAKywueSJCs2B2cGmZvGNfxDU7KNvkBOsuyuaOSV=3GWG80f+kw@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: fix strcat buffer overflow and reduce raciness
 in smb21_set_oplock_level()
To:     Steve French <smfrench@gmail.com>
Cc:     Christoph Probst <kernel@probst.it>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 7 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 09:13, Steve French =
via samba-technical
<samba-technical@lists.samba.org>:
>
> merged into cifs-2.6.git for-next
>
> On Tue, May 7, 2019 at 10:17 AM Christoph Probst via samba-technical
> <samba-technical@lists.samba.org> wrote:
> >
> > Change strcat to strncpy in the "None" case to fix a buffer overflow
> > when cinode->oplock is reset to 0 by another thread accessing the same
> > cinode. It is never valid to append "None" to any other message.
> >
> > Consolidate multiple writes to cinode->oplock to reduce raciness.
> >
> > Signed-off-by: Christoph Probst <kernel@probst.it>
> > ---
> >  fs/cifs/smb2ops.c | 14 ++++++++------
> >  1 file changed, 8 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index c36ff0d..aa61dcf 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -2917,26 +2917,28 @@ smb21_set_oplock_level(struct cifsInodeInfo *ci=
node, __u32 oplock,
> >                        unsigned int epoch, bool *purge_cache)
> >  {
> >         char message[5] =3D {0};
> > +       unsigned int new_oplock =3D 0;
> >
> >         oplock &=3D 0xFF;
> >         if (oplock =3D=3D SMB2_OPLOCK_LEVEL_NOCHANGE)
> >                 return;
> >
> > -       cinode->oplock =3D 0;
> >         if (oplock & SMB2_LEASE_READ_CACHING_HE) {
> > -               cinode->oplock |=3D CIFS_CACHE_READ_FLG;
> > +               new_oplock |=3D CIFS_CACHE_READ_FLG;
> >                 strcat(message, "R");
> >         }
> >         if (oplock & SMB2_LEASE_HANDLE_CACHING_HE) {
> > -               cinode->oplock |=3D CIFS_CACHE_HANDLE_FLG;
> > +               new_oplock |=3D CIFS_CACHE_HANDLE_FLG;
> >                 strcat(message, "H");
> >         }
> >         if (oplock & SMB2_LEASE_WRITE_CACHING_HE) {
> > -               cinode->oplock |=3D CIFS_CACHE_WRITE_FLG;
> > +               new_oplock |=3D CIFS_CACHE_WRITE_FLG;
> >                 strcat(message, "W");
> >         }
> > -       if (!cinode->oplock)
> > -               strcat(message, "None");
> > +       if (!new_oplock)
> > +               strncpy(message, "None", sizeof(message));
> > +
> > +       cinode->oplock =3D new_oplock;
> >         cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
> >                  &cinode->vfs_inode);
> >  }
> > --
> > 2.1.4
> >
> >
>

Thanks for cleaning it up!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
