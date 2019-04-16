Return-Path: <SRS0=txT2=SS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D676C10F13
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 20:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0030520693
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 20:41:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="REFAkeMR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbfDPUll (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Apr 2019 16:41:41 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46210 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbfDPUll (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Apr 2019 16:41:41 -0400
Received: by mail-pl1-f194.google.com with SMTP id y6so10884245pll.13
        for <linux-cifs@vger.kernel.org>; Tue, 16 Apr 2019 13:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hSuJQbq1zy8vgfJVXjZhGFKGyvrdamldLRl495VQ+So=;
        b=REFAkeMRci+5r76ZnNzbRU9K2O12sK98NgxhNT0ac12F62xOm5hjkNst6gyjd6d6qz
         A7EVLAq3tUDk1798kVoE6T1md1NvCkAxsK/bT9VxZmt4+j8i+xCYEXyBYejejtGKX4UP
         H3oD8SYnHeUcUbDoH6GUA1RCZX8269s0lrGtjhb3CIsbNfW5Pfc89yTIVBQpDmodZlbu
         880M7TfB2/VqNVZ5qxM7HS5zI6SbE89YEpaiUFWsiuG6x8W0A1yOf7MmchVTY9SQnoDr
         5WSXH/0LCNBgTjtTQR7aEEcnxoiGUlx0UANxBtxpipnf+SbhmQEQSZOW/DiMlsHid1mr
         YJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hSuJQbq1zy8vgfJVXjZhGFKGyvrdamldLRl495VQ+So=;
        b=pLIGV1yhHX5gdKlMfgVOVjMP749b0vGl5OAgwD+Upw4B/JxyfngDW4sXrNrdqVINoR
         jG983IFY2cTh/j9qrSS9hGInJCqyiovVMunsGLXQml2qnOSUR9+tjbapwDbZ1hUXrCad
         AbU4XsVA/3GGnBIShAyuAmkZn9CCuNipR3iY86zY/XDJz0RHMK9B3AgyTUYZBXovdKBp
         vauBvQR8s20xJMaWq9W2NCccXJ0FrJYIjc7TXXKqc3DeOuAr5WV/llEH0K08N3+SSWA4
         ANwPbyO29U5MYYnkjiySA6d7u57iO8pO3Nsnpoaw/kjfxMsjotw0UpbqT58joyeeh4PO
         wgQg==
X-Gm-Message-State: APjAAAWM6Y5giBY7LYcRRY/+F2WqZJYMCYqzSES+uFDEWku5uiJVsARU
        Qh8K4dAOCOlO9DAe95jbPg/9fgFkUwARxkyG3Q0=
X-Google-Smtp-Source: APXvYqwMZPW00z7VAtasobbYZdGTiheLuIUr9Nsa2FErwVJTV5VL0g+Wfn83Vc4FDKZMjxB2IR8Mc+uy/+0NzcieHsI=
X-Received: by 2002:a17:902:28e9:: with SMTP id f96mr62406915plb.190.1555447300497;
 Tue, 16 Apr 2019 13:41:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190415021352.30854-1-lsahlber@redhat.com> <20190415021352.30854-2-lsahlber@redhat.com>
 <BN8PR21MB11867D56B51DB9EA88747F68A0240@BN8PR21MB1186.namprd21.prod.outlook.com>
In-Reply-To: <BN8PR21MB11867D56B51DB9EA88747F68A0240@BN8PR21MB1186.namprd21.prod.outlook.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 16 Apr 2019 15:41:28 -0500
Message-ID: <CAH2r5ms4ibpwbTdEMfCMe7DCaW8b=eOjDoLTXeSgV1Y2r1MR4g@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix bi-directional fsctl passthrough calls
To:     Tom Talpey <ttalpey@microsoft.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

le32_to_cpu() returns unsigned - see below from
uapi/linux/byteorder/little_endian.h:

     #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))

On Tue, Apr 16, 2019 at 3:30 PM Tom Talpey <ttalpey@microsoft.com> wrote:
>
> > -----Original Message-----
> > From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.org> On
> > Behalf Of Ronnie Sahlberg
> > Sent: Sunday, April 14, 2019 10:14 PM
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
> >  fs/cifs/smb2ops.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 0b7e2be2a781..2824b97c5869 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -1462,12 +1462,19 @@ smb2_ioctl_query_info(const unsigned int xid,
> >               io_rsp = (struct smb2_ioctl_rsp *)rsp_iov[1].iov_base;
> >               if (le32_to_cpu(io_rsp->OutputCount) <
> > qi.input_buffer_length)
> >                       qi.input_buffer_length = le32_to_cpu(io_rsp-
> > >OutputCount);
> > +             if (qi.input_buffer_length > 0 &&
> > +                 le32_to_cpu(io_rsp->OutputOffset) + qi.input_buffer_length
> > > rsp_iov[1].iov_len) {
>
> I hope this isn't a dumb question, but I can't readily figure it out due to
> multiple layers of #include nesting. Is le32_to_cpu() signed or unsigned?
> If it's signed, this validation could still be attacked.
>
> And second question, is the fsctl output payload always guaranteed to land
> in rsp_iov[1]?
>
> Tom.
>
> > +                     rc = -EFAULT;
> > +                     goto iqinf_exit;
> > +             }
> >               if (copy_to_user(&pqi->input_buffer_length,
> > &qi.input_buffer_length,
> >                                sizeof(qi.input_buffer_length))) {
> >                       rc = -EFAULT;
> >                       goto iqinf_exit;
> >               }
> > -             if (copy_to_user(pqi + 1, &io_rsp[1], qi.input_buffer_length)) {
> > +             if (copy_to_user((char *)pqi + sizeof(struct smb_query_info),
> > +                              (char *)io_rsp + le32_to_cpu(io_rsp-
> > >OutputOffset),
> > +                              qi.input_buffer_length)) {
> >                       rc = -EFAULT;
> >                       goto iqinf_exit;
> >               }
> > --
> > 2.13.6
>


-- 
Thanks,

Steve
