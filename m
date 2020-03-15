Return-Path: <SRS0=CwqD=5A=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 536A9C10DCE
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Mar 2020 04:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 267C220724
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Mar 2020 04:57:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CjRWWlZx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgCOE54 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 15 Mar 2020 00:57:56 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43866 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgCOE54 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 15 Mar 2020 00:57:56 -0400
Received: by mail-qk1-f193.google.com with SMTP id x18so193538qki.10
        for <linux-cifs@vger.kernel.org>; Sat, 14 Mar 2020 21:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YgvqzCECWIMsbIsnmlrb8pVYiD9uTFtgc8DdYahUIcU=;
        b=CjRWWlZxFio2rs88yuwxb05TigPsaBoSGDCUZKn5RVSKF/Dkdils8Im0fwb/66NVFe
         lwUcN8KSroUu3NCHIdAuWNmV/uq3u7Ef4ukX6iGIW8zZtqxMItBW5xSV1UFvltOovb0+
         JOjkEln9Wd17Gd9CRNW2J7BIrD9rwhTNGa7jJCEqxzbwVhfj+eT8ppVj/ZHkrfxtdBku
         a1oc4VMJj0Z6wboNrStZTHy0bX1z1LRZVK99LdopLKPnkXTHaciHLusNYrcdGmX+taPf
         ArtNINCMHjya1/u/yHcRZkzR1tzESUaomPF9yoOXkskTAJhsQglcLeTrVAGv6+HfmKzA
         CBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YgvqzCECWIMsbIsnmlrb8pVYiD9uTFtgc8DdYahUIcU=;
        b=Te7hSPN6lz2XqsXO2ZmRFnvmJrQh6C2Ymuo+TuNP4NLYXuCoY+khA12XsIfdnaJkJf
         VejMv1P5xrFvR82GPs7mnGeL5434Zxjb6GJNbOzp/cM17I0rz6t+yuBYMbjBBnM4kPG/
         6i6jdp3DhqvBm/QjJFnB6Eil0vVnUZZC0DBcJ3HcC1Y8eRfUYOqxMf2vgvQi2jeweuu8
         3xttcPS0n5DccoSFPK8QDk+nE+OeEjxMt+KeuJLvBPh6GLQGNbzmwkRl81O0ePgAY8q8
         viRlEcOWhNnazCNaJ2wYVvoQKwKTITXkgNcqNaLtLRjlIt/GPh/Z36ii4OMPMZ7zyFKw
         whcQ==
X-Gm-Message-State: ANhLgQ3+gLqUSBPoULTecQtOMcjoaos7UESOuKCeokzjb/pb17YqqHQK
        605OK0RL+wWlTI8DArzZ0qUxFb1kOR4Vi3twT5M=
X-Google-Smtp-Source: ADFU+vs4A5zet82tYn1v6bOKqxE9mPEQnHwF8wQdvpKCoylxc2xEdjwX9C2SORlepifqD5lc6K5vZVZReeTELbkD134=
X-Received: by 2002:a05:6902:685:: with SMTP id i5mr17477142ybt.376.1584248275184;
 Sat, 14 Mar 2020 21:57:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200314033831.wm7uwy33j3brdgjp@xzhoux.usersys.redhat.com> <CAKywueQpONLLM2Z15HNDFTLm9feTpRo+i3E93MPkAPEDog4yTw@mail.gmail.com>
In-Reply-To: <CAKywueQpONLLM2Z15HNDFTLm9feTpRo+i3E93MPkAPEDog4yTw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 14 Mar 2020 23:57:44 -0500
Message-ID: <CAH2r5mvrV=cF2zRzP8mQ17a6CV_41aAe+0-TQPGVBOjjpVNtDQ@mail.gmail.com>
Subject: Re: [PATCH] CIFS: fiemap: do not return EINVAL if get nothing
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Sat, Mar 14, 2020 at 8:30 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=BF=D1=82, 13 =D0=BC=D0=B0=D1=80. 2020 =D0=B3. =D0=B2 20:40, Murphy Zh=
ou <jencce.kernel@gmail.com>:
> >
> > If we call fiemap on a truncated file with none blocks allocated,
> > it makes sense we get nothing from this call. No output means
> > no blocks have been counted, but the call succeeded. It's a valid
> > response.
> >
> > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > ---
> >  fs/cifs/smb2ops.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index c31e84ee3c39..32b7f9795d4a 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -3417,7 +3417,7 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
> >         if (rc)
> >                 goto out;
> >
> > -       if (out_data_len < sizeof(struct file_allocated_range_buffer)) =
{
> > +       if (out_data_len && out_data_len < sizeof(struct file_allocated=
_range_buffer)) {
> >                 rc =3D -EINVAL;
> >                 goto out;
> >         }
> > --
> > 2.20.1



--=20
Thanks,

Steve
