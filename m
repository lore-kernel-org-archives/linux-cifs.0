Return-Path: <SRS0=foj0=DW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F102BC433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 16:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86EA322210
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 16:33:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mO8Z7DHa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389756AbgJOQdp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Oct 2020 12:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389578AbgJOQdp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Oct 2020 12:33:45 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3278C061755
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 09:33:44 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 77so4339479lfl.2
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 09:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t/w6DeNWp20WufPlUuVAQokuPZmsnwIJanIcrkwbYFo=;
        b=mO8Z7DHabd4cPEOpRTbDpHx5VVCdXckeIJjHQylHKPsMwLdM2ghwmSUG7bxW2D+qF2
         7oP7RtZ7EMVi/D10IFWZsACMZrI+okkvrybmCvNSZPrydBolJQ68gRyhLbAm6ff3qCgK
         K1YLkAKFsT2Ac52ch+ZjW1qy/noR6BbqWbbnJSlQdHyI0JVJLyftzjoS4gXn0KYKq8YW
         kyAQjAWyC/GoudTR/gu3Y0AStjdmoB4XbyoRP1Z7rJkDkjcJ+ZufXDHC0aXfZelVpRFO
         hhH5OaDf8D6R5rORYF+qwfuORLX+bE579mq2dtqVOVmqYIxezNP6BL/ff0akY9zoTJx6
         WBtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t/w6DeNWp20WufPlUuVAQokuPZmsnwIJanIcrkwbYFo=;
        b=QmNkYGN++6pzaCfJ4sDtriSKqJswkKYHcabmlISCVJg4WqBH5YrKVulC+CE5tQHFz/
         DOgSQNCrO8pvEcs+TasniJLiib/wU+WU/fumJRGFTnsE+eODckkQR3032y9OApICHFoe
         /IKHm2yDFN3pqDMXdugEb7JXkwO2ciULB6mIIQMQVqsor0Ftr4d+6H5/yADOpGa3utta
         hVgkZYoCBCKgejCUFRvbDodprrMIbslIAWrZe8mdqyBNbrhAb+6nXkDuu3KB2waf5Vwy
         JUMHBlQpeC0shJhiNBNxjcA/u7MvR0RfNvcjaUrGRhwQ7lTRqsOcQZlV+QBYRp4PzxKq
         GTHQ==
X-Gm-Message-State: AOAM531opdDtpH6xFLnN181tmVmcdmg/c3wk98MGeqC+Q4Dgc/ip5pFW
        9KUb/xL2uIqTX6TKlb4yiiuDMpDLzW72Dm2/jfdNUKWMW1Q=
X-Google-Smtp-Source: ABdhPJzd5O784lojt6i81ihQ86fKeFztGghh1+9TLQWRLyjL1G2R1Mph32AclPtxR/3fO4EuHZ+8uhrHUf4hmKAwwIQ=
X-Received: by 2002:a19:c68a:: with SMTP id w132mr1317861lff.106.1602779622968;
 Thu, 15 Oct 2020 09:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtAOxF=PCndMTXxj_dZVLc-NQJfoawOvMeS3FbxiCU6xw@mail.gmail.com>
 <87eelzho1b.fsf@suse.com>
In-Reply-To: <87eelzho1b.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 15 Oct 2020 11:33:32 -0500
Message-ID: <CAH2r5mvdOBeLJsPZRqj1O8UU24aUxhc-cWEWO+8RAW9fPzYSJg@mail.gmail.com>
Subject: Re: Add support for GCM256 encryption
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000014b43d05b1b83616"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000014b43d05b1b83616
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good point.  Updated patches attached.  Also added a one line comment
to smb2pdu.h mentioning why we don't request AES_256_CCM


On Thu, Oct 15, 2020 at 3:49 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Hi Steve,
>
> Patch 2:
>
> > From 3897b440fd14dfc7b2ad2b0a922302ea7705b5d9 Mon Sep 17 00:00:00 2001
> > From: Steve French <stfrench@microsoft.com>
> > Date: Wed, 14 Oct 2020 20:24:09 -0500
> > Subject: [PATCH 2/5] smb3.1.1: add new module load parm enable_gcm_256
> > --- a/fs/cifs/smb2pdu.h
> > +++ b/fs/cifs/smb2pdu.h
> > @@ -361,8 +361,9 @@ struct smb2_encryption_neg_context {
> >       __le16  ContextType; /* 2 */
> >       __le16  DataLength;
> >       __le32  Reserved;
> > -     __le16  CipherCount; /* AES-128-GCM and AES-128-CCM */
> > -     __le16  Ciphers[2];
> > +     /* CipherCount usally 2, but can be 3 when AES256-GCM enabled */
> > +     __le16  CipherCount; /* AES128-GCM and AES128-CCM by defalt */
>
> Typo defalt =3D> default
>
> > +     __le16  Ciphers[3];
> >  } __packed;
> >
> >  /* See MS-SMB2 2.2.3.1.3 */
> > --
> > 2.25.1
> >
>
> Patch 5:
>
> > From 314d7476e404c37acb77c3f9ecc142122e7afbfd Mon Sep 17 00:00:00 2001
> > From: Steve French <stfrench@microsoft.com>
> > Date: Fri, 11 Sep 2020 16:47:09 -0500
> > Subject: [PATCH 5/5] smb3.1.1: set gcm256 when requested
> >
> > update code to set 32 byte key length and to set gcm256 when requested
> > on mount.
> >
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > ---
> >  fs/cifs/smb2glob.h      |  1 +
> >  fs/cifs/smb2ops.c       | 20 ++++++++++++--------
> >  fs/cifs/smb2transport.c | 16 ++++++++--------
> >  3 files changed, 21 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index dd1edabec328..d8e74954d101 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -3954,7 +3954,12 @@ crypt_message(struct TCP_Server_Info *server, in=
t num_rqst,
> >
> >       tfm =3D enc ? server->secmech.ccmaesencrypt :
> >                                               server->secmech.ccmaesdec=
rypt;
> > -     rc =3D crypto_aead_setkey(tfm, key, SMB3_SIGN_KEY_SIZE);
> > +
> > +     if (require_gcm_256)
> > +             rc =3D crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_=
SIZE);
>
> Shouldn't the check be on server->cipher_type?
>
> > +     else
> > +             rc =3D crypto_aead_setkey(tfm, key, SMB3_SIGN_KEY_SIZE);
> > +
> >       if (rc) {
> >               cifs_server_dbg(VFS, "%s: Failed to set aead key %d\n", _=
_func__, rc);
> >               return rc;
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
Thanks,

Steve

--00000000000014b43d05b1b83616
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-smb3.1.1-add-new-module-load-parm-enable_gcm_256.patch"
Content-Disposition: attachment; 
	filename="0002-smb3.1.1-add-new-module-load-parm-enable_gcm_256.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kgb1la081>
X-Attachment-Id: f_kgb1la081

RnJvbSBhZTdkOWI2YTVhNGEyYjA1MWE0OTA2NjBmMGJmZmVhNjY1MWVkMzg1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTQgT2N0IDIwMjAgMjA6MjQ6MDkgLTA1MDAKU3ViamVjdDogW1BBVENIIDIv
NV0gc21iMy4xLjE6IGFkZCBuZXcgbW9kdWxlIGxvYWQgcGFybSBlbmFibGVfZ2NtXzI1NgoKQWRk
IG5ldyBtb2R1bGUgbG9hZCBwYXJhbWV0ZXIgZW5hYmxlX2djbV8yNTYuIElmIHNldCwgdGhlbiBh
ZGQKQUVTLTI1Ni1HQ00gKHN0cm9uZ2VzdCBlbmNyeXB0aW9uIHR5cGUpIHRvIHRoZSBsaXN0IG9m
IGVuY3J5cHRpb24KdHlwZXMgcmVxdWVzdGVkLiBQdXQgaXQgaW4gdGhlIGxpc3QgYXMgdGhlIHNl
Y29uZCBjaG9pY2UgKHNpbmNlCkFFUy0xMjgtR0NNIGlzIGZhc3RlciBhbmQgbXVjaCBtb3JlIGJy
b2FkbHkgc3VwcG9ydGVkIGJ5ClNNQjMgc2VydmVycykuICBUbyBtYWtlIHRoaXMgc3Ryb25nZXIg
ZW5jcnlwdGlvbiB0eXBlLCBHQ00tMjU2LApyZXF1aXJlZCAodGhlIGZpcnN0IGFuZCBvbmx5IGNo
b2ljZSwgeW91IHdvdWxkIHVzZSBtb2R1bGUgcGFyYW1ldGVyCiJyZXF1aXJlX2djbV8yNTYuIgoK
UmV2aWV3ZWQtYnk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4KU2lnbmVk
LW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2Np
ZnMvY2lmc2ZzLmMgICB8IDQgKysrKwogZnMvY2lmcy9jaWZzZ2xvYi5oIHwgMSArCiBmcy9jaWZz
L3NtYjJwZHUuYyAgfCA2ICsrKysrKwogZnMvY2lmcy9zbWIycGR1LmggIHwgNSArKystLQogNCBm
aWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvY2lmc2ZzLmMgYi9mcy9jaWZzL2NpZnNmcy5jCmluZGV4IDQ2MmRiYmQxN2M1
Zi4uNDcyY2I3Nzc3ZTNlIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNmcy5jCisrKyBiL2ZzL2Np
ZnMvY2lmc2ZzLmMKQEAgLTcxLDYgKzcxLDcgQEAgYm9vbCBlbmFibGVfb3Bsb2NrcyA9IHRydWU7
CiBib29sIGxpbnV4RXh0RW5hYmxlZCA9IHRydWU7CiBib29sIGxvb2t1cENhY2hlRW5hYmxlZCA9
IHRydWU7CiBib29sIGRpc2FibGVfbGVnYWN5X2RpYWxlY3RzOyAvKiBmYWxzZSBieSBkZWZhdWx0
ICovCitib29sIGVuYWJsZV9nY21fMjU2OyAgLyogZmFsc2UgYnkgZGVmYXVsdCwgY2hhbmdlIHdo
ZW4gbW9yZSBzZXJ2ZXJzIHN1cHBvcnQgaXQgKi8KIGJvb2wgcmVxdWlyZV9nY21fMjU2OyAvKiBm
YWxzZSBieSBkZWZhdWx0ICovCiB1bnNpZ25lZCBpbnQgZ2xvYmFsX3NlY2ZsYWdzID0gQ0lGU1NF
Q19ERUY7CiAvKiB1bnNpZ25lZCBpbnQgbnRsbXYyX3N1cHBvcnQgPSAwOyAqLwpAQCAtMTA1LDYg
KzEwNiw5IEBAIE1PRFVMRV9QQVJNX0RFU0Moc2xvd19yc3BfdGhyZXNob2xkLCAiQW1vdW50IG9m
IHRpbWUgKGluIHNlY29uZHMpIHRvIHdhaXQgIgogbW9kdWxlX3BhcmFtKGVuYWJsZV9vcGxvY2tz
LCBib29sLCAwNjQ0KTsKIE1PRFVMRV9QQVJNX0RFU0MoZW5hYmxlX29wbG9ja3MsICJFbmFibGUg
b3IgZGlzYWJsZSBvcGxvY2tzLiBEZWZhdWx0OiB5L1kvMSIpOwogCittb2R1bGVfcGFyYW0oZW5h
YmxlX2djbV8yNTYsIGJvb2wsIDA2NDQpOworTU9EVUxFX1BBUk1fREVTQyhlbmFibGVfZ2NtXzI1
NiwgIkVuYWJsZSByZXF1ZXN0aW5nIHN0cm9uZ2VzdCAoMjU2IGJpdCkgR0NNIGVuY3J5cHRpb24u
IERlZmF1bHQ6IG4vTi8wIik7CisKIG1vZHVsZV9wYXJhbShyZXF1aXJlX2djbV8yNTYsIGJvb2ws
IDA2NDQpOwogTU9EVUxFX1BBUk1fREVTQyhyZXF1aXJlX2djbV8yNTYsICJSZXF1aXJlIHN0cm9u
Z2VzdCAoMjU2IGJpdCkgR0NNIGVuY3J5cHRpb24uIERlZmF1bHQ6IG4vTi8wIik7CiAKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRleCBlYzIx
YWY4MzM3NDkuLmExYTFhMTZhY2IzOCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisr
KyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtMTk1Niw2ICsxOTU2LDcgQEAgZXh0ZXJuIGJvb2wg
bG9va3VwQ2FjaGVFbmFibGVkOwogZXh0ZXJuIHVuc2lnbmVkIGludCBnbG9iYWxfc2VjZmxhZ3M7
CS8qIGlmIG9uLCBzZXNzaW9uIHNldHVwIHNlbnQKIAkJCQl3aXRoIG1vcmUgc2VjdXJlIG50bG1z
c3AyIGNoYWxsZW5nZS9yZXNwICovCiBleHRlcm4gdW5zaWduZWQgaW50IHNpZ25fQ0lGU19QRFVz
OyAgLyogZW5hYmxlIHNtYiBwYWNrZXQgc2lnbmluZyAqLworZXh0ZXJuIGJvb2wgZW5hYmxlX2dj
bV8yNTY7IC8qIGFsbG93IG9wdGlvbmFsIG5lZ290aWF0ZSBvZiBzdHJvbmdlc3Qgc2lnbmluZyAo
YWVzLWdjbS0yNTYpICovCiBleHRlcm4gYm9vbCByZXF1aXJlX2djbV8yNTY7IC8qIHJlcXVpcmUg
dXNlIG9mIHN0cm9uZ2VzdCBzaWduaW5nIChhZXMtZ2NtLTI1NikgKi8KIGV4dGVybiBib29sIGxp
bnV4RXh0RW5hYmxlZDsvKmVuYWJsZSBMaW51eC9Vbml4IENJRlMgZXh0ZW5zaW9ucyovCiBleHRl
cm4gdW5zaWduZWQgaW50IENJRlNNYXhCdWZTaXplOyAgLyogbWF4IHNpemUgbm90IGluY2x1ZGlu
ZyBoZHIgKi8KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1
LmMKaW5kZXggZmNhZTFlM2RmY2M1Li44Y2ZjMzEyMmFlNWMgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
c21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC00NTMsNiArNDUzLDEyIEBAIGJ1
aWxkX2VuY3J5cHRfY3R4dChzdHJ1Y3Qgc21iMl9lbmNyeXB0aW9uX25lZ19jb250ZXh0ICpwbmVn
X2N0eHQpCiAJCXBuZWdfY3R4dC0+RGF0YUxlbmd0aCA9IGNwdV90b19sZTE2KDQpOyAvKiBDaXBo
ZXIgQ291bnQgKyAxIGNpcGhlciAqLwogCQlwbmVnX2N0eHQtPkNpcGhlckNvdW50ID0gY3B1X3Rv
X2xlMTYoMSk7CiAJCXBuZWdfY3R4dC0+Q2lwaGVyc1swXSA9IFNNQjJfRU5DUllQVElPTl9BRVMy
NTZfR0NNOworCX0gZWxzZSBpZiAoZW5hYmxlX2djbV8yNTYpIHsKKwkJcG5lZ19jdHh0LT5EYXRh
TGVuZ3RoID0gY3B1X3RvX2xlMTYoOCk7IC8qIENpcGhlciBDb3VudCArIDMgY2lwaGVycyAqLwor
CQlwbmVnX2N0eHQtPkNpcGhlckNvdW50ID0gY3B1X3RvX2xlMTYoMyk7CisJCXBuZWdfY3R4dC0+
Q2lwaGVyc1swXSA9IFNNQjJfRU5DUllQVElPTl9BRVMxMjhfR0NNOworCQlwbmVnX2N0eHQtPkNp
cGhlcnNbMV0gPSBTTUIyX0VOQ1JZUFRJT05fQUVTMjU2X0dDTTsKKwkJcG5lZ19jdHh0LT5DaXBo
ZXJzWzJdID0gU01CMl9FTkNSWVBUSU9OX0FFUzEyOF9DQ007CiAJfSBlbHNlIHsKIAkJcG5lZ19j
dHh0LT5EYXRhTGVuZ3RoID0gY3B1X3RvX2xlMTYoNik7IC8qIENpcGhlciBDb3VudCArIDIgY2lw
aGVycyAqLwogCQlwbmVnX2N0eHQtPkNpcGhlckNvdW50ID0gY3B1X3RvX2xlMTYoMik7CmRpZmYg
LS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuaCBiL2ZzL2NpZnMvc21iMnBkdS5oCmluZGV4IDU5MzJm
YzBkYzYyYy4uNmY2NWYxY2VjOGFkIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuaAorKysg
Yi9mcy9jaWZzL3NtYjJwZHUuaApAQCAtMzYxLDggKzM2MSw5IEBAIHN0cnVjdCBzbWIyX2VuY3J5
cHRpb25fbmVnX2NvbnRleHQgewogCV9fbGUxNglDb250ZXh0VHlwZTsgLyogMiAqLwogCV9fbGUx
NglEYXRhTGVuZ3RoOwogCV9fbGUzMglSZXNlcnZlZDsKLQlfX2xlMTYJQ2lwaGVyQ291bnQ7IC8q
IEFFUy0xMjgtR0NNIGFuZCBBRVMtMTI4LUNDTSAqLwotCV9fbGUxNglDaXBoZXJzWzJdOworCS8q
IENpcGhlckNvdW50IHVzYWxseSAyLCBidXQgY2FuIGJlIDMgd2hlbiBBRVMyNTYtR0NNIGVuYWJs
ZWQgKi8KKwlfX2xlMTYJQ2lwaGVyQ291bnQ7IC8qIEFFUzEyOC1HQ00gYW5kIEFFUzEyOC1DQ00g
YnkgZGVmYXVsdCAqLworCV9fbGUxNglDaXBoZXJzWzNdOwogfSBfX3BhY2tlZDsKIAogLyogU2Vl
IE1TLVNNQjIgMi4yLjMuMS4zICovCi0tIAoyLjI1LjEKCg==
--00000000000014b43d05b1b83616
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0005-smb3.1.1-set-gcm256-when-requested.patch"
Content-Disposition: attachment; 
	filename="0005-smb3.1.1-set-gcm256-when-requested.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kgb1la010>
X-Attachment-Id: f_kgb1la010

RnJvbSA5MTYwYTU2Y2QxODQ5YTBhMDEwYzE3ODQyMzgxZmVkNTY4MjhhZDRkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTEgU2VwIDIwMjAgMTY6NDc6MDkgLTA1MDAKU3ViamVjdDogW1BBVENIIDUv
NV0gc21iMy4xLjE6IHNldCBnY20yNTYgd2hlbiByZXF1ZXN0ZWQKCnVwZGF0ZSBjb2RlIHRvIHNl
dCAzMiBieXRlIGtleSBsZW5ndGggYW5kIHRvIHNldCBnY20yNTYgd2hlbiByZXF1ZXN0ZWQKb24g
bW91bnQuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvY2lmcy9zbWIyZ2xvYi5oICAgICAgfCAgMSArCiBmcy9jaWZzL3NtYjJvcHMu
YyAgICAgICB8IDIwICsrKysrKysrKysrKy0tLS0tLS0tCiBmcy9jaWZzL3NtYjJwZHUuaCAgICAg
ICB8ICAxICsKIGZzL2NpZnMvc21iMnRyYW5zcG9ydC5jIHwgMTYgKysrKysrKystLS0tLS0tLQog
NCBmaWxlcyBjaGFuZ2VkLCAyMiBpbnNlcnRpb25zKCspLCAxNiBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9mcy9jaWZzL3NtYjJnbG9iLmggYi9mcy9jaWZzL3NtYjJnbG9iLmgKaW5kZXggY2Yy
MGYwYjVkODM2Li45OWExOTUxYTAxZWMgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMmdsb2IuaAor
KysgYi9mcy9jaWZzL3NtYjJnbG9iLmgKQEAgLTU4LDYgKzU4LDcgQEAKICNkZWZpbmUgU01CMl9I
TUFDU0hBMjU2X1NJWkUgKDMyKQogI2RlZmluZSBTTUIyX0NNQUNBRVNfU0laRSAoMTYpCiAjZGVm
aW5lIFNNQjNfU0lHTktFWV9TSVpFICgxNikKKyNkZWZpbmUgU01CM19HQ00yNTZfQ1JZUFRLRVlf
U0laRSAoMzIpCiAKIC8qIE1heGltdW0gYnVmZmVyIHNpemUgdmFsdWUgd2UgY2FuIHNlbmQgd2l0
aCAxIGNyZWRpdCAqLwogI2RlZmluZSBTTUIyX01BWF9CVUZGRVJfU0laRSA2NTUzNgpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCBkZDFlZGFi
ZWMzMjguLmM2ZWMxNjFiOTZlNCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIv
ZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTM4MjAsMTAgKzM4MjAsMTAgQEAgZmlsbF90cmFuc2Zvcm1f
aGRyKHN0cnVjdCBzbWIyX3RyYW5zZm9ybV9oZHIgKnRyX2hkciwgdW5zaWduZWQgaW50IG9yaWdf
bGVuLAogCXRyX2hkci0+UHJvdG9jb2xJZCA9IFNNQjJfVFJBTlNGT1JNX1BST1RPX05VTTsKIAl0
cl9oZHItPk9yaWdpbmFsTWVzc2FnZVNpemUgPSBjcHVfdG9fbGUzMihvcmlnX2xlbik7CiAJdHJf
aGRyLT5GbGFncyA9IGNwdV90b19sZTE2KDB4MDEpOwotCWlmIChjaXBoZXJfdHlwZSA9PSBTTUIy
X0VOQ1JZUFRJT05fQUVTMTI4X0dDTSkKLQkJZ2V0X3JhbmRvbV9ieXRlcygmdHJfaGRyLT5Ob25j
ZSwgU01CM19BRVNfR0NNX05PTkNFKTsKLQllbHNlCisJaWYgKGNpcGhlcl90eXBlID09IFNNQjJf
RU5DUllQVElPTl9BRVMxMjhfQ0NNKQogCQlnZXRfcmFuZG9tX2J5dGVzKCZ0cl9oZHItPk5vbmNl
LCBTTUIzX0FFU19DQ01fTk9OQ0UpOworCWVsc2UgLyogQUVTIDEyOCBhbmQgMjU2IEdDTSAqLwor
CQlnZXRfcmFuZG9tX2J5dGVzKCZ0cl9oZHItPk5vbmNlLCBTTUIzX0FFU19HQ01fTk9OQ0UpOwog
CW1lbWNweSgmdHJfaGRyLT5TZXNzaW9uSWQsICZzaGRyLT5TZXNzaW9uSWQsIDgpOwogfQogCkBA
IC0zOTU0LDcgKzM5NTQsMTIgQEAgY3J5cHRfbWVzc2FnZShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZv
ICpzZXJ2ZXIsIGludCBudW1fcnFzdCwKIAogCXRmbSA9IGVuYyA/IHNlcnZlci0+c2VjbWVjaC5j
Y21hZXNlbmNyeXB0IDoKIAkJCQkJCXNlcnZlci0+c2VjbWVjaC5jY21hZXNkZWNyeXB0OwotCXJj
ID0gY3J5cHRvX2FlYWRfc2V0a2V5KHRmbSwga2V5LCBTTUIzX1NJR05fS0VZX1NJWkUpOworCisJ
aWYgKHNlcnZlci0+Y2lwaGVyX3R5cGUgPT0gU01CMl9FTkNSWVBUSU9OX0FFUzI1Nl9DQ00pCisJ
CXJjID0gY3J5cHRvX2FlYWRfc2V0a2V5KHRmbSwga2V5LCBTTUIzX0dDTTI1Nl9DUllQVEtFWV9T
SVpFKTsKKwllbHNlCisJCXJjID0gY3J5cHRvX2FlYWRfc2V0a2V5KHRmbSwga2V5LCBTTUIzX1NJ
R05fS0VZX1NJWkUpOworCiAJaWYgKHJjKSB7CiAJCWNpZnNfc2VydmVyX2RiZyhWRlMsICIlczog
RmFpbGVkIHRvIHNldCBhZWFkIGtleSAlZFxuIiwgX19mdW5jX18sIHJjKTsKIAkJcmV0dXJuIHJj
OwpAQCAtMzk5MiwxMiArMzk5NywxMSBAQCBjcnlwdF9tZXNzYWdlKHN0cnVjdCBUQ1BfU2VydmVy
X0luZm8gKnNlcnZlciwgaW50IG51bV9ycXN0LAogCQlnb3RvIGZyZWVfc2c7CiAJfQogCi0JaWYg
KHNlcnZlci0+Y2lwaGVyX3R5cGUgPT0gU01CMl9FTkNSWVBUSU9OX0FFUzEyOF9HQ00pCi0JCW1l
bWNweShpdiwgKGNoYXIgKil0cl9oZHItPk5vbmNlLCBTTUIzX0FFU19HQ01fTk9OQ0UpOwotCWVs
c2UgeworCWlmIChzZXJ2ZXItPmNpcGhlcl90eXBlID09IFNNQjJfRU5DUllQVElPTl9BRVMxMjhf
Q0NNKSB7CiAJCWl2WzBdID0gMzsKIAkJbWVtY3B5KGl2ICsgMSwgKGNoYXIgKil0cl9oZHItPk5v
bmNlLCBTTUIzX0FFU19DQ01fTk9OQ0UpOwotCX0KKwl9IGVsc2UgLyogQUVTMTI4IGFuZCAyNTYg
R0NNICovCisJCW1lbWNweShpdiwgKGNoYXIgKil0cl9oZHItPk5vbmNlLCBTTUIzX0FFU19HQ01f
Tk9OQ0UpOwogCiAJYWVhZF9yZXF1ZXN0X3NldF9jcnlwdChyZXEsIHNnLCBzZywgY3J5cHRfbGVu
LCBpdik7CiAJYWVhZF9yZXF1ZXN0X3NldF9hZChyZXEsIGFzc29jX2RhdGFfbGVuKTsKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5oIGIvZnMvY2lmcy9zbWIycGR1LmgKaW5kZXggMDViMDEw
ZTVhMDYxLi44NTFjNmNkNDc0MmEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5oCisrKyBi
L2ZzL2NpZnMvc21iMnBkdS5oCkBAIC0zNTIsNiArMzUyLDcgQEAgc3RydWN0IHNtYjJfcHJlYXV0
aF9uZWdfY29udGV4dCB7CiAvKiBFbmNyeXB0aW9uIEFsZ29yaXRobXMgQ2lwaGVycyAqLwogI2Rl
ZmluZSBTTUIyX0VOQ1JZUFRJT05fQUVTMTI4X0NDTQljcHVfdG9fbGUxNigweDAwMDEpCiAjZGVm
aW5lIFNNQjJfRU5DUllQVElPTl9BRVMxMjhfR0NNCWNwdV90b19sZTE2KDB4MDAwMikKKy8qIHdl
IGN1cnJlbnRseSBkbyBub3QgcmVxdWVzdCBBRVMyNTZfQ0NNIHNpbmNlIHByZXN1bWFibHkgR0NN
IGZhc3RlciAqLwogI2RlZmluZSBTTUIyX0VOQ1JZUFRJT05fQUVTMjU2X0NDTSAgICAgIGNwdV90
b19sZTE2KDB4MDAwMykKICNkZWZpbmUgU01CMl9FTkNSWVBUSU9OX0FFUzI1Nl9HQ00gICAgICBj
cHVfdG9fbGUxNigweDAwMDQpCiAKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnRyYW5zcG9ydC5j
IGIvZnMvY2lmcy9zbWIydHJhbnNwb3J0LmMKaW5kZXggYzAzNDhlM2IxNjk1Li4yZTgxMGJhOTFm
M2IgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnRyYW5zcG9ydC5jCisrKyBiL2ZzL2NpZnMvc21i
MnRyYW5zcG9ydC5jCkBAIC04NDksMTIgKzg0OSwxMiBAQCBzbWIzX2NyeXB0b19hZWFkX2FsbG9j
YXRlKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKIAlzdHJ1Y3QgY3J5cHRvX2FlYWQg
KnRmbTsKIAogCWlmICghc2VydmVyLT5zZWNtZWNoLmNjbWFlc2VuY3J5cHQpIHsKLQkJaWYgKHNl
cnZlci0+Y2lwaGVyX3R5cGUgPT0gU01CMl9FTkNSWVBUSU9OX0FFUzEyOF9HQ00pCi0JCQl0Zm0g
PSBjcnlwdG9fYWxsb2NfYWVhZCgiZ2NtKGFlcykiLCAwLCAwKTsKLQkJZWxzZQorCQlpZiAoc2Vy
dmVyLT5jaXBoZXJfdHlwZSA9PSBTTUIyX0VOQ1JZUFRJT05fQUVTMTI4X0NDTSkKIAkJCXRmbSA9
IGNyeXB0b19hbGxvY19hZWFkKCJjY20oYWVzKSIsIDAsIDApOworCQllbHNlIC8qIEFFUyAxMjgg
YW5kIDI1NiBHQ00gKi8KKwkJCXRmbSA9IGNyeXB0b19hbGxvY19hZWFkKCJnY20oYWVzKSIsIDAs
IDApOwogCQlpZiAoSVNfRVJSKHRmbSkpIHsKLQkJCWNpZnNfc2VydmVyX2RiZyhWRlMsICIlczog
RmFpbGVkIHRvIGFsbG9jIGVuY3J5cHQgYWVhZFxuIiwKKwkJCWNpZnNfc2VydmVyX2RiZyhWRlMs
ICIlczogRmFpbGVkIGFsbG9jIGVuY3J5cHQgYWVhZFxuIiwKIAkJCQkgX19mdW5jX18pOwogCQkJ
cmV0dXJuIFBUUl9FUlIodGZtKTsKIAkJfQpAQCAtODYyLDE0ICs4NjIsMTQgQEAgc21iM19jcnlw
dG9fYWVhZF9hbGxvY2F0ZShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpCiAJfQogCiAJ
aWYgKCFzZXJ2ZXItPnNlY21lY2guY2NtYWVzZGVjcnlwdCkgewotCQlpZiAoc2VydmVyLT5jaXBo
ZXJfdHlwZSA9PSBTTUIyX0VOQ1JZUFRJT05fQUVTMTI4X0dDTSkKLQkJCXRmbSA9IGNyeXB0b19h
bGxvY19hZWFkKCJnY20oYWVzKSIsIDAsIDApOwotCQllbHNlCisJCWlmIChzZXJ2ZXItPmNpcGhl
cl90eXBlID09IFNNQjJfRU5DUllQVElPTl9BRVMxMjhfQ0NNKQogCQkJdGZtID0gY3J5cHRvX2Fs
bG9jX2FlYWQoImNjbShhZXMpIiwgMCwgMCk7CisJCWVsc2UgLyogQUVTIDEyOCBhbmQgMjU2IEdD
TSAqLworCQkJdGZtID0gY3J5cHRvX2FsbG9jX2FlYWQoImdjbShhZXMpIiwgMCwgMCk7CiAJCWlm
IChJU19FUlIodGZtKSkgewogCQkJY3J5cHRvX2ZyZWVfYWVhZChzZXJ2ZXItPnNlY21lY2guY2Nt
YWVzZW5jcnlwdCk7CiAJCQlzZXJ2ZXItPnNlY21lY2guY2NtYWVzZW5jcnlwdCA9IE5VTEw7Ci0J
CQljaWZzX3NlcnZlcl9kYmcoVkZTLCAiJXM6IEZhaWxlZCB0byBhbGxvYyBkZWNyeXB0IGFlYWRc
biIsCisJCQljaWZzX3NlcnZlcl9kYmcoVkZTLCAiJXM6IEZhaWxlZCBhbGxvYyBkZWNyeXB0IGFl
YWRcbiIsCiAJCQkJIF9fZnVuY19fKTsKIAkJCXJldHVybiBQVFJfRVJSKHRmbSk7CiAJCX0KLS0g
CjIuMjUuMQoK
--00000000000014b43d05b1b83616--
