Return-Path: <SRS0=pabO=SN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF94C10F13
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 20:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A83D420850
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 20:00:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u2YnjHa5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfDKUA6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Apr 2019 16:00:58 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40336 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfDKUA6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Apr 2019 16:00:58 -0400
Received: by mail-io1-f67.google.com with SMTP id d201so6461909iof.7;
        Thu, 11 Apr 2019 13:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XrhKXToSmWA8/tFTsAB5YxjWBJ7VOwo0i3TP4IqzLxs=;
        b=u2YnjHa5qHRjHR6QXE8mfGOMQPf2Yuem5L83eT0dl2fI6RlvZJpdLQmsAmmDobtfOx
         TD6+1BteVVTNV0E8vPx25+IQ1vxSMBmcuU1km9IuR3QP1i5CX2Dqs+gdvpedpuO9kxPa
         iKDzF0OjuflHmeah3+SP8JEDSM97XnJTinx6mYqEdpiK/t0qLzgFz51KcBfvIvxN31vX
         q47sMHsnCgLWG00CESZ321gloXS5+SJDAIIwtopsnk/ke68u08cI6WcxgM5R95s3WGEA
         jKM5hp3wepbVuYSkzMpCxfxh7QLpGqGS+B1IQeuV5AAK+gKN8Sw2gNRAqJuE5UpvHba6
         Ko9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XrhKXToSmWA8/tFTsAB5YxjWBJ7VOwo0i3TP4IqzLxs=;
        b=B5ag+ch9ghDq0mB4beJ4tbWWosygFpkhcqzofZa6KLnII/8ZPd9Od6f7Sz1asMvCD8
         z1Vtrx5BMhANXkzmQtcGA5zML+sU6ROnMcgPyL3zaOssUPcanksoDPGh1tvyfOLbmDdw
         R87wDZsfTKBbrr32D35BqYZqIeark1P4hww4kil01Ae8WST0CmsLp1XgSBOLni7RVRNE
         JJv4xZ7nVodwhTfCaiUXc1OuBGuLFyR/xbAp43kwqulaWqHGMu1pd/qIoTbhYYSsWgZu
         LQ4AgVAHFeU43UvJpwQBXpc6SdhGnNczQqtqjAKk1zF7bcUsVoJCu8Xj5fTQWbbgIoap
         uyfw==
X-Gm-Message-State: APjAAAUBFkjaUl/PNN40He8JnERdD3D5giSVGL0qyRtT6IHw05ZXIqZK
        8HV+PJDWWzqWSst8qXijOu5VLrgDDokSVvPc+xY=
X-Google-Smtp-Source: APXvYqylgV27gnakF0BW7XANHlbAtbvq9cgT/uS6q3TA71qn0tDZzQf585M4YCKF5XaNj2zoUHvWjhVVWc7UjowTE/E=
X-Received: by 2002:a6b:790c:: with SMTP id i12mr24724279iop.265.1555012857225;
 Thu, 11 Apr 2019 13:00:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190411022017.24942-1-lsahlber@redhat.com> <20190411022017.24942-2-lsahlber@redhat.com>
 <CAKywueQOJd__BpyF_eki0_KbLvZFYRhtKRkaDo_oWwU6080OYg@mail.gmail.com>
In-Reply-To: <CAKywueQOJd__BpyF_eki0_KbLvZFYRhtKRkaDo_oWwU6080OYg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 12 Apr 2019 06:00:45 +1000
Message-ID: <CAN05THSfvHozfdZuDDZqKH-eS2EmvY2yz1Z6DmRhu6+t=X_GuA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add support for FSCTL passthrough that write data
 to the server
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Apr 12, 2019 at 3:49 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D1=81=D1=80, 10 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 19:21, Ronnie Sa=
hlberg <lsahlber@redhat.com>:
> >
> > Add support to pass a blob to the server in FSCTL passthrough.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/smb2ops.c  | 17 +++++++++++++++--
> >  fs/cifs/smbfsctl.h | 27 +++++++++++++++++++++++++++
> >  2 files changed, 42 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 83a100dd2497..bb7522b882ea 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -1382,6 +1382,18 @@ smb2_ioctl_query_info(const unsigned int xid,
> >         oparms.fid =3D &fid;
> >         oparms.reconnect =3D false;
> >
> > +       /*
> > +        * FSCTL codes encode the special access they need in the fsctl=
 code.
> > +        */
> > +       if (qi.flags & PASSTHRU_FSCTL) {
> > +               switch (qi.info_type & FSCTL_DEVICE_ACCESS_MASK) {
> > +               case FSCTL_DEVICE_ACCESS_FILE_READ_WRITE_ACCESS:
> > +                       oparms.desired_access =3D FILE_READ_DATA | FILE=
_WRITE_DATA | FILE_READ_ATTRIBUTES | SYNCHRONIZE;
> > +                       ;
>
> This extra ":" looks unnecessary. Don't we need to add cases for
> +#define FSCTL_DEVICE_ACCESS_FILE_ANY_ACCESS        (0x00 << 14)
> +#define FSCTL_DEVICE_ACCESS_FILE_READ_ACCESS       (0x01 << 14)
> +#define FSCTL_DEVICE_ACCESS_FILE_WRITE_ACCESS      (0x02 << 14)
> ?

Thanks, yeah that ';' should go.
We should add cases for the other three DEVICE_ACCESS cases but
i don't know yet how these are mapped on windows.
READ_WRITE was based on what win16 used as desired_access for this.

We can add the others later when we start adding other fsctl types
when we compare to what windows uses.

>
> --
> Best regards,
> Pavel Shilovsky
