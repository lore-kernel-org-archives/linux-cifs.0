Return-Path: <SRS0=xEhF=ST=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81184C282DA
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 06:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F20B20835
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 06:37:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SO+bnceG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbfDQGg7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Apr 2019 02:36:59 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:39595 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfDQGg7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Apr 2019 02:36:59 -0400
Received: by mail-it1-f193.google.com with SMTP id 139so2659351ita.4
        for <linux-cifs@vger.kernel.org>; Tue, 16 Apr 2019 23:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=STmsc8huRghGEZKHqsb9Oic3K+QDQaKzBbh9GFYEV0w=;
        b=SO+bnceGdal/zOlCc7H0W06XlFOxgIMXbDWPBHOIOpE/tICHZ7QreMxXvww7JDaBDH
         cIqxn3HCChGCGNXCXxK4kIoghvQg1/xdl8kbX4jK8yOEDcXtpg9qKWbvnR5oxaYh0A3T
         39eSJ6B2mNSxPsWUlbQxhC1IPOoQw5BMQ1mtFbxPXSaqvyrndUhqezMYY5o4hLbk/+zJ
         B7E0iElGCqxonO32xCTfkflj5VdcXXGlpKfk3nsRH8wVyJe6zwJvhHE7zgAbWy5w3ORL
         HQIF1vdYOCtkics1BmXXD2T+Bbabrel7gCfTSVkIUFFzrEcF+y3JmbaN2VQ6IZozolsy
         h65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=STmsc8huRghGEZKHqsb9Oic3K+QDQaKzBbh9GFYEV0w=;
        b=bndeXVH1krIdkJCVkaaLZ2OlAU+mb9muvYt22HmqRz6TBUEvoP8amuRpRNu89CWCFM
         og+ZElkYJfldcFQso4qMRn9ZIl5hWr/ktkmBkNon0/RNaFbheodVXZeIRwHHxP9wdn3Q
         5dHALISvIv3eaWOQrlH8lq4zTKQ6rAPlcA57oDrfAF0y+YJbRQoAZvP+CSxrAHlFCcQh
         e1W3edyrb79TdOTHiFaGIikBDw5gLc4CF03OB5vzdNLkFyrNY8HVl5nPF3WbbwpejWke
         hXLE8NkId0Vrz4dh87lnQtzPL3liPYrEkFKE7UvZqKE7vISU2PIM1NJexM7KgwuHOn1z
         0Y3Q==
X-Gm-Message-State: APjAAAV7R3/QPhls7RBI4DVFgOc+Wi19rugDo/Am5Tzf31dfru21/VMP
        LQpUHQMv/9K08RHmC7shjEkXcgk7MektXXGmQWs=
X-Google-Smtp-Source: APXvYqxNoamYHMtykZnBiEnACuvAXPeoPuHp8qj35Q98fuF9TjB1sUMph7HzP+i1n82n4ih1r86+Is23YB3ap9dr36Y=
X-Received: by 2002:a24:650d:: with SMTP id u13mr21795029itb.1.1555483018582;
 Tue, 16 Apr 2019 23:36:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190415021352.30854-1-lsahlber@redhat.com> <20190415021352.30854-2-lsahlber@redhat.com>
 <BN8PR21MB11867D56B51DB9EA88747F68A0240@BN8PR21MB1186.namprd21.prod.outlook.com>
In-Reply-To: <BN8PR21MB11867D56B51DB9EA88747F68A0240@BN8PR21MB1186.namprd21.prod.outlook.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 17 Apr 2019 16:36:47 +1000
Message-ID: <CAN05THRrjbcD670+w+QbYOPEVu3hniBfUNnxYfEm-Fv=rgE=5w@mail.gmail.com>
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

On Wed, Apr 17, 2019 at 6:31 AM Tom Talpey <ttalpey@microsoft.com> wrote:
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

Yes. It will always land in rsp_iov[1].

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
