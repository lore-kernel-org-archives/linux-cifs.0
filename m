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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910C1C433DB
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Feb 2021 04:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DB5664D99
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Feb 2021 04:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBCEGd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Feb 2021 23:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhBCEGb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Feb 2021 23:06:31 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFAEC061573
        for <linux-cifs@vger.kernel.org>; Tue,  2 Feb 2021 20:05:50 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id m22so31366228lfg.5
        for <linux-cifs@vger.kernel.org>; Tue, 02 Feb 2021 20:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D95Egpur8zGJ5VckFf5R734+ATOgk3MjSM3Zyq7uQtY=;
        b=uO9RfvMzmTWmH6nKRbytpWTLRfkYJ1y/9FcRzi/w6VEjnLskZvp5TKPfw1kKqBSqi3
         YtH+f86l5V2+JNwkcY23MsIwvTqY53hceA12+SjeYTZQsf87K0M4VhYxEY0VPr/6gqBB
         0L793LjkDHWY5nBGf441Qt+MCjiZhDkskOKcboEO2UBdyCKxKJnkUjm2F/kPrOrJpYSd
         rO255KjP5YSnvDycoRiCejgUGu4GIn2uj8H5XRWlyFWqBs7yvufqgu3IgGwUpVzGn6E6
         p3D+BVjc+VQeJsoqEp8WKYcZIw24GajimjKVM8t2VoVkqvfxGe3dgknKGox30cydhMMp
         3gcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D95Egpur8zGJ5VckFf5R734+ATOgk3MjSM3Zyq7uQtY=;
        b=QbLuFb8zoEphY3KpMtU6jBu0bBgudz15oJMRR4mL4/oCP9hsYdkblgJCu7h+m9iMtA
         9KJ4R3JCxV0zbibeHpQYDaW0WzK9fFbmzmbFaopR/IVs1daaAcmQkbelKjVOldxWdxkZ
         2vXEw5atKKPsoPRrFblFX/MHEGwlVDgcEOh9JmpwjZWK8MpyA/3lmVvGjA8lfmkyjRrf
         zD7TtAMGhoHdyMABNV2/7KQdkkuRyVipnwoPv/htLcI/TSgzkug83/FdGEI5PDXiqERa
         fWvfHv4PvlG+/toJRTtkRXAiKptT/uXLMTYJ6Q1HadPTeSoRnUo+rroaiNBtG6FC3oVg
         PCSw==
X-Gm-Message-State: AOAM531k9ZIaodrDpGbpl1hx3dgc93OlKJnuZbocNxgCXN/7+6O+IvIY
        bf6dyNfPgg5coximFkXAm2K1z8lEkcVIdtHpuyH8RZiD3yQ=
X-Google-Smtp-Source: ABdhPJyuuQtk/eukc8bYR/EOl6BId3Q7lK/YY+7qPLHF+F1s4BuMpz9312V9WHsOoa/jvwgpJg5usR/v3pQsKMn8WQQ=
X-Received: by 2002:ac2:592c:: with SMTP id v12mr644154lfi.133.1612325149166;
 Tue, 02 Feb 2021 20:05:49 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mt7Z2wJTLFp1T0qtsrJb95FPKoffBN9WBM=JAi=HcyiOg@mail.gmail.com>
 <CAKywueTvFL7GA3he21XjX8fig73iT5OCAd=JjBq6OOwOavcehA@mail.gmail.com>
In-Reply-To: <CAKywueTvFL7GA3he21XjX8fig73iT5OCAd=JjBq6OOwOavcehA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 2 Feb 2021 22:05:37 -0600
Message-ID: <CAH2r5mv82FGWtU4PuojFuhYfYS61VX8trtihj8Zk1N5aG3Driw@mail.gmail.com>
Subject: Re: PATCH] smb3: include current dialect (SMB3.1.1) when version 3 or
 greater requested on mount
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000c76d6605ba66b303"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c76d6605ba66b303
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated as suggested (see attached) and merged into cifs-2.6.git for-next

On Tue, Feb 2, 2021 at 11:58 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D0=BF=D0=BD, 1 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 22:15, Stev=
e French <smfrench@gmail.com>:
> >
> > SMB3.1.1 is the newest, and preferred dialect, and is included in
> > the requested dialect list by default (ie if no vers=3D is specified
> > on mount) but it should also be requested if SMB3 or later is requested
> > (vers=3D3 instead of a specific dialect: vers=3D2.1, vers=3D3.02 or ver=
s=3D3.0).
> >
> > Currently specifying "vers=3D3" only requests smb3.0 and smb3.02 but th=
is
> > patch fixes it to also request smb3.1.1 dialect, as it is the newest
> > and most secure dialect and is a "version 3 or later" dialect (the inte=
nt
> > of "vers=3D3").
> >
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
> > ---
> >  fs/cifs/fs_context.c |  2 +-
> >  fs/cifs/smb2pdu.c    | 19 +++++++++++++------
> >  2 files changed, 14 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> > index 5111aadfdb6b..479c24695281 100644
> > --- a/fs/cifs/fs_context.c
> > +++ b/fs/cifs/fs_context.c
> > @@ -391,7 +391,7 @@ cifs_parse_smb_version(char *value, struct
> > smb3_fs_context *ctx, bool is_smb3)
> >   ctx->vals =3D &smb3any_values;
> >   break;
> >   case Smb_default:
> > - ctx->ops =3D &smb30_operations; /* currently identical with 3.0 */
> > + ctx->ops =3D &smb30_operations;
> >   ctx->vals =3D &smbdefault_values;
> >   break;
> >   default:
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index 794fc3b68b4f..52625549c3b5 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -814,8 +814,9 @@ SMB2_negotiate(const unsigned int xid, struct cifs_=
ses *ses)
> >      SMB3ANY_VERSION_STRING) =3D=3D 0) {
> >   req->Dialects[0] =3D cpu_to_le16(SMB30_PROT_ID);
> >   req->Dialects[1] =3D cpu_to_le16(SMB302_PROT_ID);
> > - req->DialectCount =3D cpu_to_le16(2);
> > - total_len +=3D 4;
> > + req->Dialects[2] =3D cpu_to_le16(SMB311_PROT_ID);
> > + req->DialectCount =3D cpu_to_le16(3);
> > + total_len +=3D 6;
> >   } else if (strcmp(server->vals->version_string,
> >      SMBDEFAULT_VERSION_STRING) =3D=3D 0) {
> >   req->Dialects[0] =3D cpu_to_le16(SMB21_PROT_ID);
> > @@ -848,6 +849,8 @@ SMB2_negotiate(const unsigned int xid, struct cifs_=
ses *ses)
> >   memcpy(req->ClientGUID, server->client_guid,
> >   SMB2_CLIENT_GUID_SIZE);
> >   if ((server->vals->protocol_id =3D=3D SMB311_PROT_ID) ||
> > +     (strcmp(server->vals->version_string,
> > +      SMB3ANY_VERSION_STRING) =3D=3D 0) ||
> >       (strcmp(server->vals->version_string,
> >        SMBDEFAULT_VERSION_STRING) =3D=3D 0))
> >   assemble_neg_contexts(req, server, &total_len);
> > @@ -883,6 +886,9 @@ SMB2_negotiate(const unsigned int xid, struct cifs_=
ses *ses)
> >   cifs_server_dbg(VFS,
> >   "SMB2.1 dialect returned but not requested\n");
> >   return -EIO;
> > + } else if (rsp->DialectRevision =3D=3D cpu_to_le16(SMB311_PROT_ID)) {
>
> I think we should include comment "/* ops set to 3.0 by default for
> default so update */" as in smbdefault case to improve readability.
>
> > + server->ops =3D &smb311_operations;
> > + server->vals =3D &smb311_values;
> >   }
> >   } else if (strcmp(server->vals->version_string,
> >      SMBDEFAULT_VERSION_STRING) =3D=3D 0) {
> > @@ -1042,10 +1048,11 @@ int smb3_validate_negotiate(const unsigned int
> > xid, struct cifs_tcon *tcon)
> >   SMB3ANY_VERSION_STRING) =3D=3D 0) {
> >   pneg_inbuf->Dialects[0] =3D cpu_to_le16(SMB30_PROT_ID);
> >   pneg_inbuf->Dialects[1] =3D cpu_to_le16(SMB302_PROT_ID);
> > - pneg_inbuf->DialectCount =3D cpu_to_le16(2);
> > - /* structure is big enough for 3 dialects, sending only 2 */
> > + pneg_inbuf->Dialects[2] =3D cpu_to_le16(SMB311_PROT_ID);
> > + pneg_inbuf->DialectCount =3D cpu_to_le16(3);
> > + /* SMB 2.1 not included so subtract one dialect from len */
> >   inbuflen =3D sizeof(*pneg_inbuf) -
> > - (2 * sizeof(pneg_inbuf->Dialects[0]));
> > + (sizeof(pneg_inbuf->Dialects[0]));
> >   } else if (strcmp(server->vals->version_string,
> >   SMBDEFAULT_VERSION_STRING) =3D=3D 0) {
> >   pneg_inbuf->Dialects[0] =3D cpu_to_le16(SMB21_PROT_ID);
> > @@ -1053,7 +1060,7 @@ int smb3_validate_negotiate(const unsigned int
> > xid, struct cifs_tcon *tcon)
> >   pneg_inbuf->Dialects[2] =3D cpu_to_le16(SMB302_PROT_ID);
> >   pneg_inbuf->Dialects[3] =3D cpu_to_le16(SMB311_PROT_ID);
> >   pneg_inbuf->DialectCount =3D cpu_to_le16(4);
> > - /* structure is big enough for 3 dialects */
> > + /* structure is big enough for 4 dialects */
> >   inbuflen =3D sizeof(*pneg_inbuf);
> >   } else {
> >   /* otherwise specific dialect was requested */
> >
> > --
> > Thanks,
> >
> > Steve
>
> Looks good overall.
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve

--000000000000c76d6605ba66b303
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-negotiate-current-dialect-SMB3.1.1-when-version.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-negotiate-current-dialect-SMB3.1.1-when-version.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kkowr7rr0>
X-Attachment-Id: f_kkowr7rr0

RnJvbSBiZmQyMjYyMDM1ZjQzZjhmZTQ0Zjk4YTliZjNjZjMyNmQ3YTVmZDViIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMiBGZWIgMjAyMSAwMDowMzo1OCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IG5lZ290aWF0ZSBjdXJyZW50IGRpYWxlY3QgKFNNQjMuMS4xKSB3aGVuIHZlcnNpb24gMyBv
cgogZ3JlYXRlciByZXF1ZXN0ZWQKClNNQjMuMS4xIGlzIHRoZSBuZXdlc3QsIGFuZCBwcmVmZXJy
ZWQgZGlhbGVjdCwgYW5kIGlzIGluY2x1ZGVkIGluCnRoZSByZXF1ZXN0ZWQgZGlhbGVjdCBsaXN0
IGJ5IGRlZmF1bHQgKGllIGlmIG5vIHZlcnM9IGlzIHNwZWNpZmllZApvbiBtb3VudCkgYnV0IGl0
IHNob3VsZCBhbHNvIGJlIHJlcXVlc3RlZCBpZiBTTUIzIG9yIGxhdGVyIGlzIHJlcXVlc3RlZAoo
dmVycz0zIGluc3RlYWQgb2YgYSBzcGVjaWZpYyBkaWFsZWN0OiB2ZXJzPTIuMSwgdmVycz0zLjAy
IG9yIHZlcnM9My4wKS4KCkN1cnJlbnRseSBzcGVjaWZ5aW5nICJ2ZXJzPTMiIG9ubHkgcmVxdWVz
dHMgc21iMy4wIGFuZCBzbWIzLjAyIGJ1dCB0aGlzCnBhdGNoIGZpeGVzIGl0IHRvIGFsc28gcmVx
dWVzdCBzbWIzLjEuMSBkaWFsZWN0LCBhcyBpdCBpcyB0aGUgbmV3ZXN0CmFuZCBtb3N0IHNlY3Vy
ZSBkaWFsZWN0IGFuZCBpcyBhICJ2ZXJzaW9uIDMgb3IgbGF0ZXIiIGRpYWxlY3QgKHRoZSBpbnRl
bnQKb2YgInZlcnM9MyIpLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBt
aWNyb3NvZnQuY29tPgpTdWdnZXN0ZWQtYnk6IFBhdmVsIFNoaWxvdnNreSA8cHNoaWxvdkBtaWNy
b3NvZnQuY29tPgpSZXZpZXdlZC1ieTogUGF2ZWwgU2hpbG92c2t5IDxwc2hpbG92QG1pY3Jvc29m
dC5jb20+Ci0tLQogZnMvY2lmcy9mc19jb250ZXh0LmMgfCAgMiArLQogZnMvY2lmcy9zbWIycGR1
LmMgICAgfCAyMCArKysrKysrKysrKysrKy0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAxNSBpbnNl
cnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZnNfY29udGV4
dC5jIGIvZnMvY2lmcy9mc19jb250ZXh0LmMKaW5kZXggNTExMWFhZGZkYjZiLi40NzljMjQ2OTUy
ODEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZnNfY29udGV4dC5jCisrKyBiL2ZzL2NpZnMvZnNfY29u
dGV4dC5jCkBAIC0zOTEsNyArMzkxLDcgQEAgY2lmc19wYXJzZV9zbWJfdmVyc2lvbihjaGFyICp2
YWx1ZSwgc3RydWN0IHNtYjNfZnNfY29udGV4dCAqY3R4LCBib29sIGlzX3NtYjMpCiAJCWN0eC0+
dmFscyA9ICZzbWIzYW55X3ZhbHVlczsKIAkJYnJlYWs7CiAJY2FzZSBTbWJfZGVmYXVsdDoKLQkJ
Y3R4LT5vcHMgPSAmc21iMzBfb3BlcmF0aW9uczsgLyogY3VycmVudGx5IGlkZW50aWNhbCB3aXRo
IDMuMCAqLworCQljdHgtPm9wcyA9ICZzbWIzMF9vcGVyYXRpb25zOwogCQljdHgtPnZhbHMgPSAm
c21iZGVmYXVsdF92YWx1ZXM7CiAJCWJyZWFrOwogCWRlZmF1bHQ6CmRpZmYgLS1naXQgYS9mcy9j
aWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IDc5NGZjM2I2OGI0Zi4uZTEz
OTFiZDkyNzY4IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3Nt
YjJwZHUuYwpAQCAtODE0LDggKzgxNCw5IEBAIFNNQjJfbmVnb3RpYXRlKGNvbnN0IHVuc2lnbmVk
IGludCB4aWQsIHN0cnVjdCBjaWZzX3NlcyAqc2VzKQogCQkgICBTTUIzQU5ZX1ZFUlNJT05fU1RS
SU5HKSA9PSAwKSB7CiAJCXJlcS0+RGlhbGVjdHNbMF0gPSBjcHVfdG9fbGUxNihTTUIzMF9QUk9U
X0lEKTsKIAkJcmVxLT5EaWFsZWN0c1sxXSA9IGNwdV90b19sZTE2KFNNQjMwMl9QUk9UX0lEKTsK
LQkJcmVxLT5EaWFsZWN0Q291bnQgPSBjcHVfdG9fbGUxNigyKTsKLQkJdG90YWxfbGVuICs9IDQ7
CisJCXJlcS0+RGlhbGVjdHNbMl0gPSBjcHVfdG9fbGUxNihTTUIzMTFfUFJPVF9JRCk7CisJCXJl
cS0+RGlhbGVjdENvdW50ID0gY3B1X3RvX2xlMTYoMyk7CisJCXRvdGFsX2xlbiArPSA2OwogCX0g
ZWxzZSBpZiAoc3RyY21wKHNlcnZlci0+dmFscy0+dmVyc2lvbl9zdHJpbmcsCiAJCSAgIFNNQkRF
RkFVTFRfVkVSU0lPTl9TVFJJTkcpID09IDApIHsKIAkJcmVxLT5EaWFsZWN0c1swXSA9IGNwdV90
b19sZTE2KFNNQjIxX1BST1RfSUQpOwpAQCAtODQ4LDYgKzg0OSw4IEBAIFNNQjJfbmVnb3RpYXRl
KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3NlcyAqc2VzKQogCQltZW1jcHko
cmVxLT5DbGllbnRHVUlELCBzZXJ2ZXItPmNsaWVudF9ndWlkLAogCQkJU01CMl9DTElFTlRfR1VJ
RF9TSVpFKTsKIAkJaWYgKChzZXJ2ZXItPnZhbHMtPnByb3RvY29sX2lkID09IFNNQjMxMV9QUk9U
X0lEKSB8fAorCQkgICAgKHN0cmNtcChzZXJ2ZXItPnZhbHMtPnZlcnNpb25fc3RyaW5nLAorCQkg
ICAgIFNNQjNBTllfVkVSU0lPTl9TVFJJTkcpID09IDApIHx8CiAJCSAgICAoc3RyY21wKHNlcnZl
ci0+dmFscy0+dmVyc2lvbl9zdHJpbmcsCiAJCSAgICAgU01CREVGQVVMVF9WRVJTSU9OX1NUUklO
RykgPT0gMCkpCiAJCQlhc3NlbWJsZV9uZWdfY29udGV4dHMocmVxLCBzZXJ2ZXIsICZ0b3RhbF9s
ZW4pOwpAQCAtODgzLDYgKzg4NiwxMCBAQCBTTUIyX25lZ290aWF0ZShjb25zdCB1bnNpZ25lZCBp
bnQgeGlkLCBzdHJ1Y3QgY2lmc19zZXMgKnNlcykKIAkJCWNpZnNfc2VydmVyX2RiZyhWRlMsCiAJ
CQkJIlNNQjIuMSBkaWFsZWN0IHJldHVybmVkIGJ1dCBub3QgcmVxdWVzdGVkXG4iKTsKIAkJCXJl
dHVybiAtRUlPOworCQl9IGVsc2UgaWYgKHJzcC0+RGlhbGVjdFJldmlzaW9uID09IGNwdV90b19s
ZTE2KFNNQjMxMV9QUk9UX0lEKSkgeworCQkJLyogb3BzIHNldCB0byAzLjAgYnkgZGVmYXVsdCBm
b3IgZGVmYXVsdCBzbyB1cGRhdGUgKi8KKwkJCXNlcnZlci0+b3BzID0gJnNtYjMxMV9vcGVyYXRp
b25zOworCQkJc2VydmVyLT52YWxzID0gJnNtYjMxMV92YWx1ZXM7CiAJCX0KIAl9IGVsc2UgaWYg
KHN0cmNtcChzZXJ2ZXItPnZhbHMtPnZlcnNpb25fc3RyaW5nLAogCQkgICBTTUJERUZBVUxUX1ZF
UlNJT05fU1RSSU5HKSA9PSAwKSB7CkBAIC0xMDQyLDEwICsxMDQ5LDExIEBAIGludCBzbWIzX3Zh
bGlkYXRlX25lZ290aWF0ZShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uKQogCQlTTUIzQU5ZX1ZFUlNJT05fU1RSSU5HKSA9PSAwKSB7CiAJCXBuZWdfaW5idWYt
PkRpYWxlY3RzWzBdID0gY3B1X3RvX2xlMTYoU01CMzBfUFJPVF9JRCk7CiAJCXBuZWdfaW5idWYt
PkRpYWxlY3RzWzFdID0gY3B1X3RvX2xlMTYoU01CMzAyX1BST1RfSUQpOwotCQlwbmVnX2luYnVm
LT5EaWFsZWN0Q291bnQgPSBjcHVfdG9fbGUxNigyKTsKLQkJLyogc3RydWN0dXJlIGlzIGJpZyBl
bm91Z2ggZm9yIDMgZGlhbGVjdHMsIHNlbmRpbmcgb25seSAyICovCisJCXBuZWdfaW5idWYtPkRp
YWxlY3RzWzJdID0gY3B1X3RvX2xlMTYoU01CMzExX1BST1RfSUQpOworCQlwbmVnX2luYnVmLT5E
aWFsZWN0Q291bnQgPSBjcHVfdG9fbGUxNigzKTsKKwkJLyogU01CIDIuMSBub3QgaW5jbHVkZWQg
c28gc3VidHJhY3Qgb25lIGRpYWxlY3QgZnJvbSBsZW4gKi8KIAkJaW5idWZsZW4gPSBzaXplb2Yo
KnBuZWdfaW5idWYpIC0KLQkJCQkoMiAqIHNpemVvZihwbmVnX2luYnVmLT5EaWFsZWN0c1swXSkp
OworCQkJCShzaXplb2YocG5lZ19pbmJ1Zi0+RGlhbGVjdHNbMF0pKTsKIAl9IGVsc2UgaWYgKHN0
cmNtcChzZXJ2ZXItPnZhbHMtPnZlcnNpb25fc3RyaW5nLAogCQlTTUJERUZBVUxUX1ZFUlNJT05f
U1RSSU5HKSA9PSAwKSB7CiAJCXBuZWdfaW5idWYtPkRpYWxlY3RzWzBdID0gY3B1X3RvX2xlMTYo
U01CMjFfUFJPVF9JRCk7CkBAIC0xMDUzLDcgKzEwNjEsNyBAQCBpbnQgc21iM192YWxpZGF0ZV9u
ZWdvdGlhdGUoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbikK
IAkJcG5lZ19pbmJ1Zi0+RGlhbGVjdHNbMl0gPSBjcHVfdG9fbGUxNihTTUIzMDJfUFJPVF9JRCk7
CiAJCXBuZWdfaW5idWYtPkRpYWxlY3RzWzNdID0gY3B1X3RvX2xlMTYoU01CMzExX1BST1RfSUQp
OwogCQlwbmVnX2luYnVmLT5EaWFsZWN0Q291bnQgPSBjcHVfdG9fbGUxNig0KTsKLQkJLyogc3Ry
dWN0dXJlIGlzIGJpZyBlbm91Z2ggZm9yIDMgZGlhbGVjdHMgKi8KKwkJLyogc3RydWN0dXJlIGlz
IGJpZyBlbm91Z2ggZm9yIDQgZGlhbGVjdHMgKi8KIAkJaW5idWZsZW4gPSBzaXplb2YoKnBuZWdf
aW5idWYpOwogCX0gZWxzZSB7CiAJCS8qIG90aGVyd2lzZSBzcGVjaWZpYyBkaWFsZWN0IHdhcyBy
ZXF1ZXN0ZWQgKi8KLS0gCjIuMjcuMAoK
--000000000000c76d6605ba66b303--
