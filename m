Return-Path: <SRS0=lstS=SO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF8FC10F0E
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Apr 2019 13:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E2852084D
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Apr 2019 13:37:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JizSncB+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfDLNh7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:37:59 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:55871 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbfDLNh7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Apr 2019 09:37:59 -0400
Received: by mail-it1-f194.google.com with SMTP id y134so15675244itc.5
        for <linux-cifs@vger.kernel.org>; Fri, 12 Apr 2019 06:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VLp3sIxPEN8anzjZieLMxjeT9aTp4S/FGCxB2ieG2WQ=;
        b=JizSncB+8Yq32yDOfmAcIuspSC0WxD0+qwnIf5bZkTZt5xuzmWnIxFqIVM6/r7vGEW
         MRfVh32myq5Ka4Ptj/1kSt2hclHyX//y1jnVLiQPB135OZh3cKl3GGBgxDKVWHiqSyWk
         hGYf4vkuiuhRO8tsrcxmYRU20NkWGsBBgoiBlei2qw9YzPVAUtIsaZQAl9k/SdlLRqG2
         AWzwQnasZs+BP6dQPoDumon3A6ZEg0JG2Dw/vjOnDG/yer5kcYDxh2Z+N/0D04hR6XMn
         wXPJjedv6EdP4etCfvWC84SIAYKGU3hNYTwyNT4in64iuJLkNTbk6rAFGDY3gwPa/jCD
         eY+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VLp3sIxPEN8anzjZieLMxjeT9aTp4S/FGCxB2ieG2WQ=;
        b=XHJSEfXLX3ceDonhXB6kDQO5FtdFF6J15DuuNFhn/HnttAtpZKjZFnkwubpJpTxopv
         oABnFdZU9eFRaFn/whP/erBU46WSo62tfadnuVFq6gv2zv+LzbixiUNsDhosKIIz4mEi
         2gkxDvtJf9G+ZlEkaxNkIsoeluWFPKE4LdY3CSgNrmU2gmoWApNj3qXvyBziRL0D+mKC
         v719xwfaoLsjZAVuHxAwL/pYWDS3nv/6yDQIywho5X21Zeg1HLg8PZTOJAKc8dUB9sGu
         y06w9EaX2ldxiG+wXSSyG9yvu2zRt4ChYV8U6MrpBibQ+9XvFyH5y9kCEmZmTv19x7Z0
         OTMw==
X-Gm-Message-State: APjAAAW/Hs+PaZ6929YNqJWKgoTooS+89UHFQV6zOWeXhCBDsMglRkPL
        uResaMMxE8tum675W/8kKetgWEsynv0JC4An62g=
X-Google-Smtp-Source: APXvYqyIB0fM3+V3N2EHaDgozaz1P5lszXldAFXreJZt6G0SiauskUqcvaAqw36H+hWgjbPip0nzbdoioXK43utKurA=
X-Received: by 2002:a24:6e01:: with SMTP id w1mr12103604itc.15.1555076278476;
 Fri, 12 Apr 2019 06:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190412030534.23402-1-lsahlber@redhat.com> <DM5PR2101MB0727698C9899BE431CFB1D6CA0280@DM5PR2101MB0727.namprd21.prod.outlook.com>
In-Reply-To: <DM5PR2101MB0727698C9899BE431CFB1D6CA0280@DM5PR2101MB0727.namprd21.prod.outlook.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 12 Apr 2019 23:37:47 +1000
Message-ID: <CAN05THQBUrimNWbBqVWsKL18eMDiWSyYryYS1PaMJ9P2R6AjGg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix bi-directional fsctl passthrough calls
To:     Tom Talpey <ttalpey@microsoft.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Apr 12, 2019 at 10:51 PM Tom Talpey <ttalpey@microsoft.com> wrote:
>
> > -----Original Message-----
> > From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.org> On
> > Behalf Of Ronnie Sahlberg
> > Sent: Thursday, April 11, 2019 11:06 PM
> > To: linux-cifs <linux-cifs@vger.kernel.org>
> > Cc: Steve French <smfrench@gmail.com>; Ronnie Sahlberg
> > <lsahlber@redhat.com>
> > Subject: [PATCH] cifs: fix bi-directional fsctl passthrough calls
> >
> > SMB2 Ioctl responses from servers may respond with both the request blob
> > from
> > the client followed by the actual reply blob for ioctls that are bi-directional.
> >
> > In that case we can not assume that the reply blob comes immediately after
> > the
> > ioctl response structure.
> >
> > This fixes FSCTLs such as SMB2:FSCTL_QUERY_ALLOCATED_RANGES
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/smb2ops.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 0b7e2be2a781..768f35ea63cf 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -1467,7 +1467,9 @@ smb2_ioctl_query_info(const unsigned int xid,
> >                       rc = -EFAULT;
> >                       goto iqinf_exit;
> >               }
> > -             if (copy_to_user(pqi + 1, &io_rsp[1], qi.input_buffer_length)) {
> > +             if (copy_to_user((char *)pqi + sizeof(struct smb_query_info),
> > +                              (char *)io_rsp + le32_to_cpu(io_rsp-
> > >OutputOffset),
> > +                              qi.input_buffer_length)) {
>
> Shouldn't this validate that OutputOffset, for a length of input_buffer_length, falls completely within the bounds of the response, before copying?

I think copy_to_user handles that

>
>
> >                       rc = -EFAULT;
> >                       goto iqinf_exit;
> >               }
> > --
> > 2.13.6
>
