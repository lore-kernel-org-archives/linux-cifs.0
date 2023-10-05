Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1764AE92700
	for <linux-cifs@archiver.kernel.org>; Thu,  5 Oct 2023 13:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbjJEN5c (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 5 Oct 2023 09:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243882AbjJENzb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 5 Oct 2023 09:55:31 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C804202
        for <linux-cifs@vger.kernel.org>; Wed,  4 Oct 2023 21:36:25 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2c022ce8114so6435281fa.1
        for <linux-cifs@vger.kernel.org>; Wed, 04 Oct 2023 21:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696480583; x=1697085383; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rcY2yxK/c5+RfMTKsi0B1UxobYWufoyncDkUmsQoSyM=;
        b=mJveoZS5z4VPHCRjVpLu2RdT20QHHA3hbxKiOV6UKywMe5dAr5p4ZMkGd3EYe540Kj
         bHTuvGgN4BnxaOQXyMtZC2OduLiObPU0j8CIsznoJR+p+KPFJPAkIjVnYlascE1neEiA
         lhO3hPkV++VAP3HSksVOqPKQOGSEEBgqVKu6KHWjz9NtiTi3mDhW9sjhGV0beEyTAH48
         rPq89RfIkPwMCmPBQH6Qa2Tjm32p4AyywyvalpdaTpyyuQomMNvbuiYQuMSA4NCGZBmn
         he3Q4NbNh+gJJsT059ucktMLq+Gbt7ZQjn+644KUIn8EpPyGvlu5nLtubXuJloMgSLAF
         CziA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696480583; x=1697085383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rcY2yxK/c5+RfMTKsi0B1UxobYWufoyncDkUmsQoSyM=;
        b=vUFk+xnvEolhX8LhFvztyAeQaBuwd9haLRDTW2v6QoaIp6zBJTYm+5duZrt4mlPUeE
         b3Fsfg6UZKRMvBvFrciAeA5AmMexxQSWa9mV0i9OcpGErkpGKgrdqwClYzmUNm5VGMi3
         +WHfXUr8uM5ZySxJA3rEHmPyfHAq6G4rgayzrwDYSNXuQaoHAeyaCBbiL4hZwyzI6Tof
         Jo2WvX2zT21lEnvOYmvAwwN6cLamGQ6fDA0tfqN6vFlHnFm5aY0OSxgU5sOd6hLlBnmS
         A6hyUQQACbMyeSKoFfC0ChgKsLsOQQvzmdAJj0iF4vvy/u1uXiZKgI4QQ5Hn2Vl3W5JG
         IBXw==
X-Gm-Message-State: AOJu0Yyh6CWCjrArvu6GtQdcYAyBKcqYqSQKOBrrZQnpiHPDdNY4+Mnj
        ELwGmTMZ3mzDcz5jt6B+iiESmaJWmQx/RNRfJHTqxsHEsJ8=
X-Google-Smtp-Source: AGHT+IH9lGsURAD+yTH61jtwgz2OKlaM/TXV6f24oF6ueiWVuSUB6adEFJKuMU00vzNl918ceQ/4fp9kQPnhZanNtzo=
X-Received: by 2002:a05:6512:1307:b0:500:7f71:e46b with SMTP id
 x7-20020a056512130700b005007f71e46bmr3772142lfu.1.1696480582905; Wed, 04 Oct
 2023 21:36:22 -0700 (PDT)
MIME-Version: 1.0
References: <20231004111755.25338-1-meetakshisetiyaoss@gmail.com> <CAH2r5mtDp3=5pc_CyThX=jJcXd98btAXArdF1Ept3OCVqrebcw@mail.gmail.com>
In-Reply-To: <CAH2r5mtDp3=5pc_CyThX=jJcXd98btAXArdF1Ept3OCVqrebcw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 5 Oct 2023 10:06:11 +0530
Message-ID: <CANT5p=r8LC6MwZdZCt7JwrF04ve1hUUbvWL8EipP_0J4kL33fQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add client version details to NTLM authenticate message
To:     Steve French <smfrench@gmail.com>
Cc:     meetakshisetiyaoss@gmail.com, linux-cifs@vger.kernel.org,
        bharathsm.hsk@gmail.com, pc@cjr.nz,
        Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Oct 4, 2023 at 10:44=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> tentatively merged into cifs-2.6.git for-next pending review/testing
>
> On Wed, Oct 4, 2023 at 6:18=E2=80=AFAM <meetakshisetiyaoss@gmail.com> wro=
te:
> >
> > From: Meetakshi Setiya <msetiya@microsoft.com>
> >
> > The NTLM authenticate message currently sets the NTLMSSP_NEGOTIATE_VERS=
ION
> > flag but does not populate the VERSION structure. This commit fixes thi=
s
> > bug by ensuring that the flag is set and the version details are includ=
ed
> > in the message.
> >
> > Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
> > ---
> >  fs/smb/client/ntlmssp.h |  4 ++--
> >  fs/smb/client/sess.c    | 12 +++++++++---
> >  2 files changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/smb/client/ntlmssp.h b/fs/smb/client/ntlmssp.h
> > index 2c5dde2ece58..875de43b72de 100644
> > --- a/fs/smb/client/ntlmssp.h
> > +++ b/fs/smb/client/ntlmssp.h
> > @@ -133,8 +133,8 @@ typedef struct _AUTHENTICATE_MESSAGE {
> >         SECURITY_BUFFER WorkstationName;
> >         SECURITY_BUFFER SessionKey;
> >         __le32 NegotiateFlags;
> > -       /* SECURITY_BUFFER for version info not present since we
> > -          do not set the version is present flag */
> > +       struct  ntlmssp_version Version;
> > +       /* SECURITY_BUFFER */
> >         char UserString[];
> >  } __attribute__((packed)) AUTHENTICATE_MESSAGE, *PAUTHENTICATE_MESSAGE=
;
> >
> > diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> > index 79f26c560edf..919ace2d13d4 100644
> > --- a/fs/smb/client/sess.c
> > +++ b/fs/smb/client/sess.c
> > @@ -1060,10 +1060,16 @@ int build_ntlmssp_auth_blob(unsigned char **pbu=
ffer,
> >         memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
> >         sec_blob->MessageType =3D NtLmAuthenticate;
> >
> > +       /* send version information in ntlmssp authenticate also */
> >         flags =3D ses->ntlmssp->server_flags | NTLMSSP_REQUEST_TARGET |
> > -               NTLMSSP_NEGOTIATE_TARGET_INFO | NTLMSSP_NEGOTIATE_WORKS=
TATION_SUPPLIED;
> > -       /* we only send version information in ntlmssp negotiate, so do=
 not set this flag */
> > -       flags =3D flags & ~NTLMSSP_NEGOTIATE_VERSION;
> > +               NTLMSSP_NEGOTIATE_TARGET_INFO | NTLMSSP_NEGOTIATE_VERSI=
ON |
> > +               NTLMSSP_NEGOTIATE_WORKSTATION_SUPPLIED;
> > +
> > +       sec_blob->Version.ProductMajorVersion =3D LINUX_VERSION_MAJOR;
> > +       sec_blob->Version.ProductMinorVersion =3D LINUX_VERSION_PATCHLE=
VEL;
> > +       sec_blob->Version.ProductBuild =3D cpu_to_le16(SMB3_PRODUCT_BUI=
LD);
> > +       sec_blob->Version.NTLMRevisionCurrent =3D NTLMSSP_REVISION_W2K3=
;
> > +
> >         tmp =3D *pbuffer + sizeof(AUTHENTICATE_MESSAGE);
> >         sec_blob->NegotiateFlags =3D cpu_to_le32(flags);
> >
> > --
> > 2.39.2
> >
>
>
> --
> Thanks,
>
> Steve

Looks good to me.
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

--=20
Regards,
Shyam
