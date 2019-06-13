Return-Path: <SRS0=0jCz=UM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C20C31E45
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Jun 2019 19:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BA872147A
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Jun 2019 19:32:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vMO/JMQI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfFMTcq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Jun 2019 15:32:46 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37802 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfFMTcq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Jun 2019 15:32:46 -0400
Received: by mail-pg1-f194.google.com with SMTP id 20so88081pgr.4
        for <linux-cifs@vger.kernel.org>; Thu, 13 Jun 2019 12:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZSbuIR5tsadviZbN3Gh+mwgutJ4llCQ7pyXgJmKAkUs=;
        b=vMO/JMQIvDllpiJUSN4eiHTYyoJ66ZEfT9F4dz8d/48nPIXea/OfJSkwjxQbPXMuKK
         9jIBS+LONTsMhWUB9TPoNnqZX4eqpV9t5wKfOmixlZ2kTUQMq3wcsVKIKD5KErRbbjjn
         OZfyMjCv0H/xW+K4GFuwzbzO/0VibQQLSqQu6LEcDnFmaWJVuVp46QolQk1bdQvUWFlM
         OLf5e2QWd7TCbRnOeqhP7PJPCI0wTCPXtav1S+NXjwmNI5OjogPScND1XhQe93Y0PBs4
         SZ+v5hpA4RD95uAdgmPGaQL5IRf/ckVDLVbsP7ipGDJm3O1UhsUZFHimfjvBjrAQcNOs
         RLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZSbuIR5tsadviZbN3Gh+mwgutJ4llCQ7pyXgJmKAkUs=;
        b=PeHNOm96IwodSHi83ncXuZa0TAXL0FEhkkgbcwWIeaHMJLolkoTnkws85RqMGI+hne
         H1OKcLTLW4CwEZLksnNKbM1/6XqHPP4BiXGghldFbJZzLyDCDkWMJqOeRNrZ5ry6w394
         9vAKnvBjGkGEW/RVI3nRvwZ3TmIEt0l5UOmcgUT9wXDdAItWontgNwzRlrIYFgEHiX6f
         JRIRPS+0cB1tmuwqNuksnJdviIJO8Ac4xoPNEtBUhe6sS9aolhU4ZKMJofnPUYuXobIU
         AlsWOyt3qAQfc56VGDV3Zk3o9a1vkDYPF6yWKGASHFovfFz2f/sg7lCSzg9WSu4gB62u
         VYTA==
X-Gm-Message-State: APjAAAWnQ7OXhGu0wgTlKlGgEUls0xbXgRIQlV2q7jVKcX7NCqGuVYNg
        AmxwhPjX2MfHDTIMyOcr0cVznonSKBMlki5ONsA=
X-Google-Smtp-Source: APXvYqwilADDUW8wRo6I4pkOsOw1TP1PfcOv29VARJ0cUD7yGOKWcJE0+s/ptfdcrC7bag3zG9a3EjZ3jrKtTc6XG/I=
X-Received: by 2002:a62:7552:: with SMTP id q79mr75226402pfc.71.1560454365308;
 Thu, 13 Jun 2019 12:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvRQj1hyDbBY8DTMtDShr2uxmJqYWWJg+H=iO3RUDc3oQ@mail.gmail.com>
 <CAKywueRHrFjuJOxPv=L1H2Ju4_A7SPUQ15VzH8DKn9sh3LeCzw@mail.gmail.com>
In-Reply-To: <CAKywueRHrFjuJOxPv=L1H2Ju4_A7SPUQ15VzH8DKn9sh3LeCzw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 13 Jun 2019 14:32:33 -0500
Message-ID: <CAH2r5msPGVUXWytnaUEnks-rTphCStwx706GToCfQkTKi=t9=Q@mail.gmail.com>
Subject: Re: [PATCH][CIFS] Fix match_server check to allow for multidialect negotiate
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000221d83058b3998d4"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000221d83058b3998d4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Updated version with your suggestion - see attached

On Mon, Jun 10, 2019 at 1:41 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D1=81=D0=B1, 8 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 02:06, Steve Fren=
ch <smfrench@gmail.com>:
> >
> > When using multidialect negotiate (default or allowing any smb3
> > dialect via vers=3D3)
> > allow matching on existing server session.  Before this fix if you moun=
t
> > a second time to a different share on the same server, we will only reu=
se
> > the existing smb session if a single dialect is requested (e.g. specify=
ing
> > vers=3D2.1 or vers=3D3.0 or vers=3D3.1.1 on the mount command). If a de=
fault mount
> > (e.g. not specifying vers=3D) is done then we will create a new socket
> > connection and SMB3 (or SMB3.1.1) session each time we connect to a
> > different share
> > on the same server rather than reusing the existing one.
> >
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > ---
> >  fs/cifs/connect.c | 21 +++++++++++++++++++--
> >  1 file changed, 19 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 8c4121da624e..6200207565db 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -2542,8 +2542,25 @@ static int match_server(struct TCP_Server_Info
> > *server, struct smb_vol *vol)
> >      if (vol->nosharesock)
> >          return 0;
> >
> > -    /* BB update this for smb3any and default case */
> > -    if ((server->vals !=3D vol->vals) || (server->ops !=3D vol->ops))
> > +    /* If multidialect negotiation see if existing sessions match one =
*/
> > +    if (strcmp(vol->vals->version_string, SMB3ANY_VERSION_STRING) =3D=
=3D 0) {
> > +        if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
> > +            return 0;
> > +        else if (server->vals->protocol_id =3D=3D SMB21_PROT_ID)
> > +            return 0;
> > +        else if (strcmp(server->vals->version_string,
> > +             SMB1_VERSION_STRING) =3D=3D 0)
> > +            return 0;
> > +        /* else SMB3 or later, which is fine */
>
> May be better to check
>
> if (server->vals->protocol_id < SMB30_PROT_ID)
>     return 0;
>
> ? SMB1 case should work too because protocol_id is 0.
>
>
> > +    } else if (strcmp(vol->vals->version_string,
> > +           SMBDEFAULT_VERSION_STRING) =3D=3D 0) {
> > +        if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
> > +            return 0;
> > +        else if (strcmp(server->vals->version_string,
> > +             SMB1_VERSION_STRING) =3D=3D 0)
> > +            return 0;
>
> and here the same way:
>
> if (server->vals->protocol_id < SMB21_PROT_ID)
>     return 0;
>
> > +        /* else SMB2.1 or later, which is fine */
> > +    } else if ((server->vals !=3D vol->vals) || (server->ops !=3D vol-=
>ops))
> >          return 0;
> >
> >      if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns))
> > --
> > 2.20.1
>
> In this case we can avoid nested IFs - should be cleaner I guess.
>
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve

--000000000000221d83058b3998d4
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-CIFS-Fix-match_server-check-to-allow-for-auto-dialec.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Fix-match_server-check-to-allow-for-auto-dialec.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jwv28bxs0>
X-Attachment-Id: f_jwv28bxs0

RnJvbSAzM2ZlOTI0YzQ5YzRlMjdlNGVmMjNlNmY2Yzg0NGRkYWU5MDc4MDQ0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTMgSnVuIDIwMTkgMTQ6MjY6NDkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBb
Q0lGU10gRml4IG1hdGNoX3NlcnZlciBjaGVjayB0byBhbGxvdyBmb3IgYXV0byBkaWFsZWN0CiBu
ZWdvdGlhdGUKCldoZW4gdXNpbmcgbXVsdGlkaWFsZWN0IG5lZ290aWF0ZSAoZGVmYXVsdCBvciBz
cGVjaWZpbmcgdmVycz0zLjAgd2hpY2gKYWxsb3dzIGFueSBzbWIzIGRpYWxlY3QpLCBmaXggaG93
IHdlIGNoZWNrIGZvciBhbiBleGlzdGluZyBzZXJ2ZXIgc2Vzc2lvbi4KQmVmb3JlIHRoaXMgZml4
IGlmIHlvdSBtb3VudGVkIGEgc2Vjb25kIHRpbWUgdG8gdGhlIHNhbWUgc2VydmVyIChlLmcuIGEK
ZGlmZmVyZW50IHNoYXJlIG9uIHRoZSBzYW1lIHNlcnZlcikgd2Ugd291bGQgb25seSByZXVzZSB0
aGUgZXhpc3Rpbmcgc21iCnNlc3Npb24gaWYgYSBzaW5nbGUgZGlhbGVjdCB3ZXJlIHJlcXVlc3Rl
ZCAoZS5nLiBzcGVjaWZ5aW5nIHZlcnM9Mi4xIG9yIHZlcnM9My4wCm9yIHZlcnM9My4xLjEgb24g
dGhlIG1vdW50IGNvbW1hbmQpLiBJZiBhIGRlZmF1bHQgbW91bnQgKGUuZy4gbm90CnNwZWNpZnlp
bmcgdmVycz0pIGlzIGRvbmUgdGhlbiB3b3VsZCBhbHdheXMgY3JlYXRlIGEgbmV3IHNvY2tldCBj
b25uZWN0aW9uCmFuZCBTTUIzIChvciBTTUIzLjEuMSkgc2Vzc2lvbiBlYWNoIHRpbWUgd2UgY29u
bmVjdCB0byBhIGRpZmZlcmVudCBzaGFyZQpvbiB0aGUgc2FtZSBzZXJ2ZXIgcmF0aGVyIHRoYW4g
cmV1c2luZyB0aGUgZXhpc3Rpbmcgb25lLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxz
dGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY29ubmVjdC5jIHwgMTEgKysrKysr
KysrLS0KIGZzL2NpZnMvc21iMW9wcy5jIHwgIDEgKwogZnMvY2lmcy9zbWIycGR1LmggfCAgMSAr
CiAzIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCA4YzQx
MjFkYTYyNGUuLjg1NGRkMDc3ZjJmYyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysr
IGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTI1NDIsOCArMjU0MiwxNSBAQCBzdGF0aWMgaW50IG1h
dGNoX3NlcnZlcihzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIHN0cnVjdCBzbWJfdm9s
ICp2b2wpCiAJaWYgKHZvbC0+bm9zaGFyZXNvY2spCiAJCXJldHVybiAwOwogCi0JLyogQkIgdXBk
YXRlIHRoaXMgZm9yIHNtYjNhbnkgYW5kIGRlZmF1bHQgY2FzZSAqLwotCWlmICgoc2VydmVyLT52
YWxzICE9IHZvbC0+dmFscykgfHwgKHNlcnZlci0+b3BzICE9IHZvbC0+b3BzKSkKKwkvKiBJZiBt
dWx0aWRpYWxlY3QgbmVnb3RpYXRpb24gc2VlIGlmIGV4aXN0aW5nIHNlc3Npb25zIG1hdGNoIG9u
ZSAqLworCWlmIChzdHJjbXAodm9sLT52YWxzLT52ZXJzaW9uX3N0cmluZywgU01CM0FOWV9WRVJT
SU9OX1NUUklORykgPT0gMCkgeworCQlpZiAoc2VydmVyLT52YWxzLT5wcm90b2NvbF9pZCA8IFNN
QjMwX1BST1RfSUQpCisJCQlyZXR1cm4gMDsKKwl9IGVsc2UgaWYgKHN0cmNtcCh2b2wtPnZhbHMt
PnZlcnNpb25fc3RyaW5nLAorCQkgICBTTUJERUZBVUxUX1ZFUlNJT05fU1RSSU5HKSA9PSAwKSB7
CisJCWlmIChzZXJ2ZXItPnZhbHMtPnByb3RvY29sX2lkIDwgU01CMjFfUFJPVF9JRCkKKwkJCXJl
dHVybiAwOworCX0gZWxzZSBpZiAoKHNlcnZlci0+dmFscyAhPSB2b2wtPnZhbHMpIHx8IChzZXJ2
ZXItPm9wcyAhPSB2b2wtPm9wcykpCiAJCXJldHVybiAwOwogCiAJaWYgKCFuZXRfZXEoY2lmc19u
ZXRfbnMoc2VydmVyKSwgY3VycmVudC0+bnNwcm94eS0+bmV0X25zKSkKZGlmZiAtLWdpdCBhL2Zz
L2NpZnMvc21iMW9wcy5jIGIvZnMvY2lmcy9zbWIxb3BzLmMKaW5kZXggYzRlNzVhZmEzMjU4Li43
M2E5NGJiNDE3MDQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMW9wcy5jCisrKyBiL2ZzL2NpZnMv
c21iMW9wcy5jCkBAIC0xMjQ1LDYgKzEyNDUsNyBAQCBzdHJ1Y3Qgc21iX3ZlcnNpb25fb3BlcmF0
aW9ucyBzbWIxX29wZXJhdGlvbnMgPSB7CiAKIHN0cnVjdCBzbWJfdmVyc2lvbl92YWx1ZXMgc21i
MV92YWx1ZXMgPSB7CiAJLnZlcnNpb25fc3RyaW5nID0gU01CMV9WRVJTSU9OX1NUUklORywKKwku
cHJvdG9jb2xfaWQgPSBTTUIxMF9QUk9UX0lELAogCS5sYXJnZV9sb2NrX3R5cGUgPSBMT0NLSU5H
X0FORFhfTEFSR0VfRklMRVMsCiAJLmV4Y2x1c2l2ZV9sb2NrX3R5cGUgPSAwLAogCS5zaGFyZWRf
bG9ja190eXBlID0gTE9DS0lOR19BTkRYX1NIQVJFRF9MT0NLLApkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9zbWIycGR1LmggYi9mcy9jaWZzL3NtYjJwZHUuaAppbmRleCBkM2E2NGNmODEyZDkuLjIzNTI0
ZmU5NDdkZSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmgKKysrIGIvZnMvY2lmcy9zbWIy
cGR1LmgKQEAgLTIyNyw2ICsyMjcsNyBAQCBzdHJ1Y3Qgc21iMl9uZWdvdGlhdGVfcmVxIHsKIH0g
X19wYWNrZWQ7CiAKIC8qIERpYWxlY3RzICovCisjZGVmaW5lIFNNQjEwX1BST1RfSUQgMHgwMDAw
IC8qIGxvY2FsIG9ubHksIG5vdCBzZW50IG9uIHdpcmUgdy9DSUZTIG5lZ3Byb3QgKi8KICNkZWZp
bmUgU01CMjBfUFJPVF9JRCAweDAyMDIKICNkZWZpbmUgU01CMjFfUFJPVF9JRCAweDAyMTAKICNk
ZWZpbmUgU01CMzBfUFJPVF9JRCAweDAzMDAKLS0gCjIuMjAuMQoK
--000000000000221d83058b3998d4--
