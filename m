Return-Path: <SRS0=R2WM=DX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BE0C433E7
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Oct 2020 04:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 694092073A
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Oct 2020 04:45:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E/RU7mbD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732990AbgJPEpl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Oct 2020 00:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732985AbgJPEpk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Oct 2020 00:45:40 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C43AC061755
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 21:45:40 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id l28so1237423lfp.10
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 21:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DPcEwRcdx4gnaeE+5D749oMHsjSq+mJU9b+LSRES9dI=;
        b=E/RU7mbDY7tAyV/6kVcltTHruV/H6wHErWRFhwpSoaZnjqGXP3hyp5+3ax610a//UH
         Yy68QbFYRULkFvsgsonCtMySqPOkTWvCyUusSuFil5J7X2VJeEbW0RWEcTDyTIsceJku
         BBNWoTcetB6Xf0pCWTdFYyoDV427CeS3nSJl0llC/ZtURtKH27p8IXqnACtvh99NC5h5
         2Zjk/UG1cSPkGLDwe8ldSNOu/yKDEZ3GSiUCSsszmbvJ6YLMDeRKgfOLmy620UvFhd7d
         rI45HQSzgs8K0XGpDelg/c4RAVKAhBIKkUFqiY74QbrCIU1HYO6rhPN13ciw4c0Nvrh/
         kxEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DPcEwRcdx4gnaeE+5D749oMHsjSq+mJU9b+LSRES9dI=;
        b=W6zOYucgdaj39FT65ae4Xt1WKarqyZmYsneEMbcCBSMwADS8fQaencqfY1T1JFqfRh
         4Q7U5x9hjJYAIBjvAmtiIZw+RvLmw+XcQ9/7SnjhNq/V9XeiU+YXU2ElJnKfSxjd2cEc
         u9e8V6ML+hkgxIqJHsrde6/hfRZ6CvDfhf0Hp1E2b76HoNP/w3byrfK6dLGyHBmjjove
         eSatPO/jkdzvS+RnvOvmTcq2+x+bR3ebNASAvbbCYs3BSmgqpW3iSWjEjgIpoeknGT3C
         +maaX1V99gtYCE6Jp5pzEdC84LMjRzYmglJqTI30bxsPGrGtHno34JOeK4Texscv+AFS
         Ms4Q==
X-Gm-Message-State: AOAM531YlMgfRyDb8v0xRVbzO0svOFs2fEZFGJz6z+y0lhslxg/lQXys
        K8jnS3aRr3ZHBkeHLWNHkwvBbIRNupVLTKu5DD8=
X-Google-Smtp-Source: ABdhPJyKdh3gpToF+RWqETN+srLHegEGVegl0ntszAbenXj4TeUPueI+PFup/HheMDJSj2hbj1faaTmVgQzOlJgkUPM=
X-Received: by 2002:a19:7d0b:: with SMTP id y11mr654609lfc.305.1602823538504;
 Thu, 15 Oct 2020 21:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtAOxF=PCndMTXxj_dZVLc-NQJfoawOvMeS3FbxiCU6xw@mail.gmail.com>
 <87eelzho1b.fsf@suse.com> <CAH2r5mvdOBeLJsPZRqj1O8UU24aUxhc-cWEWO+8RAW9fPzYSJg@mail.gmail.com>
 <CAH2r5msGP-=qow2A3eJPiHg-CaNCM+6cvfbP9=_z3ZJSeU9UKw@mail.gmail.com>
In-Reply-To: <CAH2r5msGP-=qow2A3eJPiHg-CaNCM+6cvfbP9=_z3ZJSeU9UKw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 15 Oct 2020 23:45:27 -0500
Message-ID: <CAH2r5muN34JRZOxsG2+jvh9F8X9E7Lb85gmQud6MJKR43qKZyA@mail.gmail.com>
Subject: Re: Add support for GCM256 encryption
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000a7b2c505b1c26f3b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a7b2c505b1c26f3b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Redid patch 5 (includes Aurelien's suggestion, fixes a typo and fixes
a problem with vers=3D3.0 mounts) - attached.

On Thu, Oct 15, 2020 at 12:41 PM Steve French <smfrench@gmail.com> wrote:
>
> found another typo in patch 5 ccm instead of gcm - fixing it now
>
> On Thu, Oct 15, 2020 at 11:33 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Good point.  Updated patches attached.  Also added a one line comment
> > to smb2pdu.h mentioning why we don't request AES_256_CCM
> >
> >
> > On Thu, Oct 15, 2020 at 3:49 AM Aur=C3=A9lien Aptel <aaptel@suse.com> w=
rote:
> > >
> > > Hi Steve,
> > >
> > > Patch 2:
> > >
> > > > From 3897b440fd14dfc7b2ad2b0a922302ea7705b5d9 Mon Sep 17 00:00:00 2=
001
> > > > From: Steve French <stfrench@microsoft.com>
> > > > Date: Wed, 14 Oct 2020 20:24:09 -0500
> > > > Subject: [PATCH 2/5] smb3.1.1: add new module load parm enable_gcm_=
256
> > > > --- a/fs/cifs/smb2pdu.h
> > > > +++ b/fs/cifs/smb2pdu.h
> > > > @@ -361,8 +361,9 @@ struct smb2_encryption_neg_context {
> > > >       __le16  ContextType; /* 2 */
> > > >       __le16  DataLength;
> > > >       __le32  Reserved;
> > > > -     __le16  CipherCount; /* AES-128-GCM and AES-128-CCM */
> > > > -     __le16  Ciphers[2];
> > > > +     /* CipherCount usally 2, but can be 3 when AES256-GCM enabled=
 */
> > > > +     __le16  CipherCount; /* AES128-GCM and AES128-CCM by defalt *=
/
> > >
> > > Typo defalt =3D> default
> > >
> > > > +     __le16  Ciphers[3];
> > > >  } __packed;
> > > >
> > > >  /* See MS-SMB2 2.2.3.1.3 */
> > > > --
> > > > 2.25.1
> > > >
> > >
> > > Patch 5:
> > >
> > > > From 314d7476e404c37acb77c3f9ecc142122e7afbfd Mon Sep 17 00:00:00 2=
001
> > > > From: Steve French <stfrench@microsoft.com>
> > > > Date: Fri, 11 Sep 2020 16:47:09 -0500
> > > > Subject: [PATCH 5/5] smb3.1.1: set gcm256 when requested
> > > >
> > > > update code to set 32 byte key length and to set gcm256 when reques=
ted
> > > > on mount.
> > > >
> > > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > > ---
> > > >  fs/cifs/smb2glob.h      |  1 +
> > > >  fs/cifs/smb2ops.c       | 20 ++++++++++++--------
> > > >  fs/cifs/smb2transport.c | 16 ++++++++--------
> > > >  3 files changed, 21 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > > > index dd1edabec328..d8e74954d101 100644
> > > > --- a/fs/cifs/smb2ops.c
> > > > +++ b/fs/cifs/smb2ops.c
> > > > @@ -3954,7 +3954,12 @@ crypt_message(struct TCP_Server_Info *server=
, int num_rqst,
> > > >
> > > >       tfm =3D enc ? server->secmech.ccmaesencrypt :
> > > >                                               server->secmech.ccmae=
sdecrypt;
> > > > -     rc =3D crypto_aead_setkey(tfm, key, SMB3_SIGN_KEY_SIZE);
> > > > +
> > > > +     if (require_gcm_256)
> > > > +             rc =3D crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPT=
KEY_SIZE);
> > >
> > > Shouldn't the check be on server->cipher_type?
> > >
> > > > +     else
> > > > +             rc =3D crypto_aead_setkey(tfm, key, SMB3_SIGN_KEY_SIZ=
E);
> > > > +
> > > >       if (rc) {
> > > >               cifs_server_dbg(VFS, "%s: Failed to set aead key %d\n=
", __func__, rc);
> > > >               return rc;
> > >
> > > --
> > > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnb=
erg, DE
> > > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--000000000000a7b2c505b1c26f3b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0005-smb3.1.1-set-gcm256-when-requested.patch"
Content-Disposition: attachment; 
	filename="0005-smb3.1.1-set-gcm256-when-requested.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kgbrqmaz0>
X-Attachment-Id: f_kgbrqmaz0

RnJvbSAzMzQ1OWE2MjBkN2IzZWUyYzcwN2VmOWQyZjE0MTE4YmVmODE0YjMxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTUgT2N0IDIwMjAgMjM6NDE6NDAgLTA1MDAKU3ViamVjdDogW1BBVENIIDUv
NV0gc21iMy4xLjE6IHNldCBnY20yNTYgd2hlbiByZXF1ZXN0ZWQKCnVwZGF0ZSBzbWIgZW5jcnlw
dGlvbiBjb2RlIHRvIHNldCAzMiBieXRlIGtleSBsZW5ndGggYW5kIHRvCnNldCBnY20yNTYgd2hl
biByZXF1ZXN0ZWQgb24gbW91bnQuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJl
bmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyZ2xvYi5oICAgICAgfCAgMSArCiBm
cy9jaWZzL3NtYjJvcHMuYyAgICAgICB8IDEzICsrKysrKysrKystLS0KIGZzL2NpZnMvc21iMnBk
dS5oICAgICAgIHwgIDEgKwogZnMvY2lmcy9zbWIydHJhbnNwb3J0LmMgfCAgOCArKysrKy0tLQog
NCBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvc21iMmdsb2IuaCBiL2ZzL2NpZnMvc21iMmdsb2IuaAppbmRleCBjZjIw
ZjBiNWQ4MzYuLjk5YTE5NTFhMDFlYyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyZ2xvYi5oCisr
KyBiL2ZzL2NpZnMvc21iMmdsb2IuaApAQCAtNTgsNiArNTgsNyBAQAogI2RlZmluZSBTTUIyX0hN
QUNTSEEyNTZfU0laRSAoMzIpCiAjZGVmaW5lIFNNQjJfQ01BQ0FFU19TSVpFICgxNikKICNkZWZp
bmUgU01CM19TSUdOS0VZX1NJWkUgKDE2KQorI2RlZmluZSBTTUIzX0dDTTI1Nl9DUllQVEtFWV9T
SVpFICgzMikKIAogLyogTWF4aW11bSBidWZmZXIgc2l6ZSB2YWx1ZSB3ZSBjYW4gc2VuZCB3aXRo
IDEgY3JlZGl0ICovCiAjZGVmaW5lIFNNQjJfTUFYX0JVRkZFUl9TSVpFIDY1NTM2CmRpZmYgLS1n
aXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4IGRkMWVkYWJl
YzMyOC4uNDg2NTdkZGJkNzVlIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9m
cy9jaWZzL3NtYjJvcHMuYwpAQCAtMzgyMCw3ICszODIwLDggQEAgZmlsbF90cmFuc2Zvcm1faGRy
KHN0cnVjdCBzbWIyX3RyYW5zZm9ybV9oZHIgKnRyX2hkciwgdW5zaWduZWQgaW50IG9yaWdfbGVu
LAogCXRyX2hkci0+UHJvdG9jb2xJZCA9IFNNQjJfVFJBTlNGT1JNX1BST1RPX05VTTsKIAl0cl9o
ZHItPk9yaWdpbmFsTWVzc2FnZVNpemUgPSBjcHVfdG9fbGUzMihvcmlnX2xlbik7CiAJdHJfaGRy
LT5GbGFncyA9IGNwdV90b19sZTE2KDB4MDEpOwotCWlmIChjaXBoZXJfdHlwZSA9PSBTTUIyX0VO
Q1JZUFRJT05fQUVTMTI4X0dDTSkKKwlpZiAoKGNpcGhlcl90eXBlID09IFNNQjJfRU5DUllQVElP
Tl9BRVMxMjhfR0NNKSB8fAorCSAgICAoY2lwaGVyX3R5cGUgPT0gU01CMl9FTkNSWVBUSU9OX0FF
UzI1Nl9HQ00pKQogCQlnZXRfcmFuZG9tX2J5dGVzKCZ0cl9oZHItPk5vbmNlLCBTTUIzX0FFU19H
Q01fTk9OQ0UpOwogCWVsc2UKIAkJZ2V0X3JhbmRvbV9ieXRlcygmdHJfaGRyLT5Ob25jZSwgU01C
M19BRVNfQ0NNX05PTkNFKTsKQEAgLTM5NTQsNyArMzk1NSwxMiBAQCBjcnlwdF9tZXNzYWdlKHN0
cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgaW50IG51bV9ycXN0LAogCiAJdGZtID0gZW5j
ID8gc2VydmVyLT5zZWNtZWNoLmNjbWFlc2VuY3J5cHQgOgogCQkJCQkJc2VydmVyLT5zZWNtZWNo
LmNjbWFlc2RlY3J5cHQ7Ci0JcmMgPSBjcnlwdG9fYWVhZF9zZXRrZXkodGZtLCBrZXksIFNNQjNf
U0lHTl9LRVlfU0laRSk7CisKKwlpZiAoc2VydmVyLT5jaXBoZXJfdHlwZSA9PSBTTUIyX0VOQ1JZ
UFRJT05fQUVTMjU2X0dDTSkKKwkJcmMgPSBjcnlwdG9fYWVhZF9zZXRrZXkodGZtLCBrZXksIFNN
QjNfR0NNMjU2X0NSWVBUS0VZX1NJWkUpOworCWVsc2UKKwkJcmMgPSBjcnlwdG9fYWVhZF9zZXRr
ZXkodGZtLCBrZXksIFNNQjNfU0lHTl9LRVlfU0laRSk7CisKIAlpZiAocmMpIHsKIAkJY2lmc19z
ZXJ2ZXJfZGJnKFZGUywgIiVzOiBGYWlsZWQgdG8gc2V0IGFlYWQga2V5ICVkXG4iLCBfX2Z1bmNf
XywgcmMpOwogCQlyZXR1cm4gcmM7CkBAIC0zOTkyLDcgKzM5OTgsOCBAQCBjcnlwdF9tZXNzYWdl
KHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgaW50IG51bV9ycXN0LAogCQlnb3RvIGZy
ZWVfc2c7CiAJfQogCi0JaWYgKHNlcnZlci0+Y2lwaGVyX3R5cGUgPT0gU01CMl9FTkNSWVBUSU9O
X0FFUzEyOF9HQ00pCisJaWYgKChzZXJ2ZXItPmNpcGhlcl90eXBlID09IFNNQjJfRU5DUllQVElP
Tl9BRVMxMjhfR0NNKSB8fAorCSAgICAoc2VydmVyLT5jaXBoZXJfdHlwZSA9PSBTTUIyX0VOQ1JZ
UFRJT05fQUVTMjU2X0dDTSkpCiAJCW1lbWNweShpdiwgKGNoYXIgKil0cl9oZHItPk5vbmNlLCBT
TUIzX0FFU19HQ01fTk9OQ0UpOwogCWVsc2UgewogCQlpdlswXSA9IDM7CmRpZmYgLS1naXQgYS9m
cy9jaWZzL3NtYjJwZHUuaCBiL2ZzL2NpZnMvc21iMnBkdS5oCmluZGV4IDA1YjAxMGU1YTA2MS4u
ODUxYzZjZDQ3NDJhIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuaAorKysgYi9mcy9jaWZz
L3NtYjJwZHUuaApAQCAtMzUyLDYgKzM1Miw3IEBAIHN0cnVjdCBzbWIyX3ByZWF1dGhfbmVnX2Nv
bnRleHQgewogLyogRW5jcnlwdGlvbiBBbGdvcml0aG1zIENpcGhlcnMgKi8KICNkZWZpbmUgU01C
Ml9FTkNSWVBUSU9OX0FFUzEyOF9DQ00JY3B1X3RvX2xlMTYoMHgwMDAxKQogI2RlZmluZSBTTUIy
X0VOQ1JZUFRJT05fQUVTMTI4X0dDTQljcHVfdG9fbGUxNigweDAwMDIpCisvKiB3ZSBjdXJyZW50
bHkgZG8gbm90IHJlcXVlc3QgQUVTMjU2X0NDTSBzaW5jZSBwcmVzdW1hYmx5IEdDTSBmYXN0ZXIg
Ki8KICNkZWZpbmUgU01CMl9FTkNSWVBUSU9OX0FFUzI1Nl9DQ00gICAgICBjcHVfdG9fbGUxNigw
eDAwMDMpCiAjZGVmaW5lIFNNQjJfRU5DUllQVElPTl9BRVMyNTZfR0NNICAgICAgY3B1X3RvX2xl
MTYoMHgwMDA0KQogCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJ0cmFuc3BvcnQuYyBiL2ZzL2Np
ZnMvc21iMnRyYW5zcG9ydC5jCmluZGV4IGMwMzQ4ZTNiMTY5NS4uZWJjY2Q3MWNjNjBhIDEwMDY0
NAotLS0gYS9mcy9jaWZzL3NtYjJ0cmFuc3BvcnQuYworKysgYi9mcy9jaWZzL3NtYjJ0cmFuc3Bv
cnQuYwpAQCAtODQ5LDEyICs4NDksMTMgQEAgc21iM19jcnlwdG9fYWVhZF9hbGxvY2F0ZShzdHJ1
Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpCiAJc3RydWN0IGNyeXB0b19hZWFkICp0Zm07CiAK
IAlpZiAoIXNlcnZlci0+c2VjbWVjaC5jY21hZXNlbmNyeXB0KSB7Ci0JCWlmIChzZXJ2ZXItPmNp
cGhlcl90eXBlID09IFNNQjJfRU5DUllQVElPTl9BRVMxMjhfR0NNKQorCQlpZiAoKHNlcnZlci0+
Y2lwaGVyX3R5cGUgPT0gU01CMl9FTkNSWVBUSU9OX0FFUzEyOF9HQ00pIHx8CisJCSAgICAoc2Vy
dmVyLT5jaXBoZXJfdHlwZSA9PSBTTUIyX0VOQ1JZUFRJT05fQUVTMjU2X0dDTSkpCiAJCQl0Zm0g
PSBjcnlwdG9fYWxsb2NfYWVhZCgiZ2NtKGFlcykiLCAwLCAwKTsKIAkJZWxzZQogCQkJdGZtID0g
Y3J5cHRvX2FsbG9jX2FlYWQoImNjbShhZXMpIiwgMCwgMCk7CiAJCWlmIChJU19FUlIodGZtKSkg
ewotCQkJY2lmc19zZXJ2ZXJfZGJnKFZGUywgIiVzOiBGYWlsZWQgdG8gYWxsb2MgZW5jcnlwdCBh
ZWFkXG4iLAorCQkJY2lmc19zZXJ2ZXJfZGJnKFZGUywgIiVzOiBGYWlsZWQgYWxsb2MgZW5jcnlw
dCBhZWFkXG4iLAogCQkJCSBfX2Z1bmNfXyk7CiAJCQlyZXR1cm4gUFRSX0VSUih0Zm0pOwogCQl9
CkBAIC04NjIsNyArODYzLDggQEAgc21iM19jcnlwdG9fYWVhZF9hbGxvY2F0ZShzdHJ1Y3QgVENQ
X1NlcnZlcl9JbmZvICpzZXJ2ZXIpCiAJfQogCiAJaWYgKCFzZXJ2ZXItPnNlY21lY2guY2NtYWVz
ZGVjcnlwdCkgewotCQlpZiAoc2VydmVyLT5jaXBoZXJfdHlwZSA9PSBTTUIyX0VOQ1JZUFRJT05f
QUVTMTI4X0dDTSkKKwkJaWYgKChzZXJ2ZXItPmNpcGhlcl90eXBlID09IFNNQjJfRU5DUllQVElP
Tl9BRVMxMjhfR0NNKSB8fAorCQkgICAgKHNlcnZlci0+Y2lwaGVyX3R5cGUgPT0gU01CMl9FTkNS
WVBUSU9OX0FFUzI1Nl9HQ00pKQogCQkJdGZtID0gY3J5cHRvX2FsbG9jX2FlYWQoImdjbShhZXMp
IiwgMCwgMCk7CiAJCWVsc2UKIAkJCXRmbSA9IGNyeXB0b19hbGxvY19hZWFkKCJjY20oYWVzKSIs
IDAsIDApOwotLSAKMi4yNS4xCgo=
--000000000000a7b2c505b1c26f3b--
