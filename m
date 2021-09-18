Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C41E8C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 17:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91F7E6101B
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 17:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235575AbhIRR7c (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 13:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbhIRR7c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Sep 2021 13:59:32 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDF1C061574
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 10:58:08 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t8so13712797wri.1
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 10:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K/F0zbw7dmFEnaRjTC5v0My6bBvEK1oz+d07Z/T1Rz8=;
        b=FrbHdp3YswarDONc27SwfbKEbglm8FnyL/zl/Z5zNw8XNRkXTU6qMT6CPzAM0eHuMk
         f7EZcWEbMd6CUMk3u2Tu07QpTU1MkAdSEBv5f9KiNaE6geby1wvtQnknNbBNsNCLYluJ
         H5kpArDlu16fLeDj1kU7dC4/FvHj8UMH/SWuSdwGLOT5iK2/VqbbRIllTpPwq0BLRofg
         zWmiFp3yA6aD7Py9g3kz+flX4AsBUMkzNEmDxHyP9Qo7Y3vChmWFv9mH/IKqnipmnMe+
         GnpqERQ64qJR7FjwRCmKFRvhJTBiZyKeEQwZVHDqMfB/kQPqdh4Ax8LA8WSumr2K5Joh
         gvTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K/F0zbw7dmFEnaRjTC5v0My6bBvEK1oz+d07Z/T1Rz8=;
        b=IPC+weF/zyK6dNa7QCTqazo1oMsh5geO439BeqaomTvFA1j+/nGqdtsMGn+XvIVUat
         irR/auwAJBaqPvl8QpJMap+J/ecKxKZXAXTzaNWNxFoK8DvW2RrtzdFJXgGkMpMoPy1x
         5QpA+cTLXsFrxJFQL+djEa5X6dVtUSBgVh8EpnIVEG0QVRqqzpjgi7zSdxH+xyg8Ox2U
         CiWbh37Vm9XzxYbtwqMKM86hG3jwfn0f/oIhRqB8U/2N3S1uJ6kDr7GxycXVe7CjC3sg
         Q9E3FqvOzh+Vb4G21WpxvBeAypnVG7PE5+8y/Yagz6huRSow8AlbtLVIWn2W154VdtDS
         28rg==
X-Gm-Message-State: AOAM530XPeOS6DLQVYXSslWWgdIPU3+MZ2x4CNrA1TdF2Qo10Bs7Mrka
        k+QAV0NsDpNhBI+jGQtLkzUi5fbIHgNrupiaxO92OjsVVI4=
X-Google-Smtp-Source: ABdhPJzG4Am5KrvD9MFmNjDOGFmYKNAE9JHlibEl9mzQsNlBQY7IzRTXSlqltOyk+Y9argnUrZKd/f3F3ShUW+GxgjQ=
X-Received: by 2002:adf:fcca:: with SMTP id f10mr19104863wrs.304.1631987886524;
 Sat, 18 Sep 2021 10:58:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210918094513.89480-1-linkinjeon@kernel.org> <20210918094513.89480-3-linkinjeon@kernel.org>
 <CAH2r5mumOAqEgkitSK4yrxithPUUF1d9GihTLQAOdrX8-kK2Eg@mail.gmail.com>
In-Reply-To: <CAH2r5mumOAqEgkitSK4yrxithPUUF1d9GihTLQAOdrX8-kK2Eg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 18 Sep 2021 12:57:55 -0500
Message-ID: <CAH2r5muy+yA+B0hD8iTXm+s2VWj86Fb5F3A0WqdkPp7tfuay_g@mail.gmail.com>
Subject: Re: [PATCH 3/4] ksmbd: add validatioin for FILE_FULL_EA_INFORMATION
 of smb2_get_info
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Regression tests with the three in linux-next passed ...
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/bui=
lds/67

On Sat, Sep 18, 2021 at 10:55 AM Steve French <smfrench@gmail.com> wrote:
>
> Merged into cifsd-for-next (smbd-for-next) after fixing typo in title.
> The other three look promising but want to look in more detail at
> those unless others have review feedback on those - those patches
> include some potentially very important checks.
>
> On Sat, Sep 18, 2021 at 4:45 AM Namjae Jeon <linkinjeon@kernel.org> wrote=
:
> >
> > Add validation to check whether req->InputBufferLength is smaller than
> > smb2_ea_info_req structure size.
> >
> > Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> > Cc: Ralph B=C3=B6hme <slow@samba.org>
> > Cc: Steve French <smfrench@gmail.com>
> > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> > ---
> >  fs/ksmbd/smb2pdu.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> > index e589e8cc389f..e92af212583e 100644
> > --- a/fs/ksmbd/smb2pdu.c
> > +++ b/fs/ksmbd/smb2pdu.c
> > @@ -4059,6 +4059,10 @@ static int smb2_get_ea(struct ksmbd_work *work, =
struct ksmbd_file *fp,
> >         path =3D &fp->filp->f_path;
> >         /* single EA entry is requested with given user.* name */
> >         if (req->InputBufferLength) {
> > +               if (le32_to_cpu(req->InputBufferLength) <
> > +                   sizeof(struct smb2_ea_info_req))
> > +                       return -EINVAL;
> > +
> >                 ea_req =3D (struct smb2_ea_info_req *)req->Buffer;
> >         } else {
> >                 /* need to send all EAs, if no specific EA is requested=
*/
> > --
> > 2.25.1
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
