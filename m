Return-Path: <SRS0=pabO=SN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C03C10F13
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 18:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6491820663
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 18:57:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MG9B/T6y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbfDKS5J (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Apr 2019 14:57:09 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38254 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfDKS5I (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Apr 2019 14:57:08 -0400
Received: by mail-pg1-f194.google.com with SMTP id j26so3942961pgl.5
        for <linux-cifs@vger.kernel.org>; Thu, 11 Apr 2019 11:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qN6u6nTJZAsQzch+A9vsDxGD0swOy8MkNcVREH6uSwA=;
        b=MG9B/T6yR6pzDCqY5yrKOo9rY3NzTgMWF7NhZTTGbNeeJpaEwatgcePkPjfLetkUjB
         YnxL2vRRQIYgWFwBfugFOdQAvRHMXVRvJmNk7ZkS2+IojgJ0k33YyIDGJMFC10UWPI+u
         c60m+yTCHwcv4R27KtBWQ9hNf4IeVayhq2Jnj+i+rSDuIhMNKxeaAuq3/m6aOYlL5KkI
         X3VCceS22s2pWzTJb3EOuaC16GUxgaIOKBY4jxPoNT3XlDYyrf6wJFO/5IxgCYnUFfmr
         6dp4wfFpbwEUtePxt/PlU5x77WLOObyyj0tpo+PE/Pi1zFJG+Yu2VTyHtlNCFwVmHKKq
         fdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qN6u6nTJZAsQzch+A9vsDxGD0swOy8MkNcVREH6uSwA=;
        b=HottJq6MHZONtHMPhLDbgpIlANWZq32B8/FqY7kXOkYCoal6M+7RCvAFZPhVi5saEq
         ktQVjP5AY89gLLVgjemvbImU7dZG0BrBPOlLDMBFCM6U84Hj3CBjuRhdSgobbAc5pw0I
         7o1XFgHRnkLGJ8qhCrP8lDs9jfXPXaoxhPIoYg5iQoQdbYsXasa1GE3+FbvXrlcnQE1f
         C5GjRbtaJNkOndvWoC+MfH/KA1PLV3WucSnaoB5EkCObC+Y4oMNExZlRW1UsZEsNrjE3
         tzxpyAf3jZpFGSZZMemqT/50ICVwX7uDQKEfKSawEaxLq2NL/8rfaALSWNjnvFbXHGGK
         GRYg==
X-Gm-Message-State: APjAAAVk5aR+OMQ1wcQVuaqsZfGkhbwd5tR+UYg1qwK//wY9M7p+HLfy
        xvzFAwV6xsRC+kzZLEfZzWcUlgUqYl31PeFRSUA=
X-Google-Smtp-Source: APXvYqy1zYvn5CgVW4H/dvnDHlFzp7r/kiYc3AJYQHCtftpKS9YUuvD6p5uDtCkrznPCZprSX39zpd1CLAoxrkOdh6Y=
X-Received: by 2002:a62:76c1:: with SMTP id r184mr48293266pfc.229.1555009028196;
 Thu, 11 Apr 2019 11:57:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190411022017.24942-1-lsahlber@redhat.com> <20190411022017.24942-2-lsahlber@redhat.com>
 <CAKywueQOJd__BpyF_eki0_KbLvZFYRhtKRkaDo_oWwU6080OYg@mail.gmail.com>
In-Reply-To: <CAKywueQOJd__BpyF_eki0_KbLvZFYRhtKRkaDo_oWwU6080OYg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 11 Apr 2019 13:56:56 -0500
Message-ID: <CAH2r5mtvQgiit-s_YQLksOmmcJ5AMb4_uYQNfcm2ubBeZS_Ukg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add support for FSCTL passthrough that write data
 to the server
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000bfae5d058645c007"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000bfae5d058645c007
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

How about this small followon patch to address this?


On Thu, Apr 11, 2019 at 12:49 PM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
>
> =D1=81=D1=80, 10 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 19:21, Ronnie Sa=
hlberg <lsahlber@redhat.com>:
> >
> > Add support to pass a blob to the server in FSCTL passthrough.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/smb2ops.c  | 17 +++++++++++++++--
> >  fs/cifs/smbfsctl.h | 27 +++++++++++++++++++++++++++
> >  2 files changed, 42 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 83a100dd2497..bb7522b882ea 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -1382,6 +1382,18 @@ smb2_ioctl_query_info(const unsigned int xid,
> >         oparms.fid =3D &fid;
> >         oparms.reconnect =3D false;
> >
> > +       /*
> > +        * FSCTL codes encode the special access they need in the fsctl=
 code.
> > +        */
> > +       if (qi.flags & PASSTHRU_FSCTL) {
> > +               switch (qi.info_type & FSCTL_DEVICE_ACCESS_MASK) {
> > +               case FSCTL_DEVICE_ACCESS_FILE_READ_WRITE_ACCESS:
> > +                       oparms.desired_access =3D FILE_READ_DATA | FILE=
_WRITE_DATA | FILE_READ_ATTRIBUTES | SYNCHRONIZE;
> > +                       ;
>
> This extra ":" looks unnecessary. Don't we need to add cases for
> +#define FSCTL_DEVICE_ACCESS_FILE_ANY_ACCESS        (0x00 << 14)
> +#define FSCTL_DEVICE_ACCESS_FILE_READ_ACCESS       (0x01 << 14)
> +#define FSCTL_DEVICE_ACCESS_FILE_WRITE_ACCESS      (0x02 << 14)
> ?
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve

--000000000000bfae5d058645c007
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Add-handling-for-different-FSCTL-access-flags.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Add-handling-for-different-FSCTL-access-flags.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jud07tz60>
X-Attachment-Id: f_jud07tz60

RnJvbSAyZjE0OTBmNTA2YjU4M2YxNTMzZTcxNjVhZGM3ZjIxZWFhMDFkZjIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTEgQXByIDIwMTkgMTM6NTM6MTcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBBZGQgaGFuZGxpbmcgZm9yIGRpZmZlcmVudCBGU0NUTCBhY2Nlc3MgZmxhZ3MKCkRlc2ly
ZWRBY2Nlc3MgZmllbGQgaW4gU01CMyBvcGVuIHJlcXVlc3QgbmVlZHMKdG8gYmUgc2V0IGRpZmZl
cmVudGx5IGZvciBSRUFEIHZzLiBXUklURSBpb2N0bHMKKG5vdCBqdXN0IG9uZXMgdGhhdCByZXF1
ZXN0IGJvdGgpLgoKT3JpZ2luYWxseSBub3RpY2VkIGJ5IFBhdmVsCgpTaWduZWQtb2ZmLWJ5OiBT
dGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyb3Bz
LmMgfCAxMCArKysrKysrKystCiAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJv
cHMuYwppbmRleCBlZDhjMmJhOTU5MGIuLjA4ZmYwNDRmYmI0YiAxMDA2NDQKLS0tIGEvZnMvY2lm
cy9zbWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTEzODksNyArMTM4OSwxNSBA
QCBzbWIyX2lvY3RsX3F1ZXJ5X2luZm8oY29uc3QgdW5zaWduZWQgaW50IHhpZCwKIAkJc3dpdGNo
IChxaS5pbmZvX3R5cGUgJiBGU0NUTF9ERVZJQ0VfQUNDRVNTX01BU0spIHsKIAkJY2FzZSBGU0NU
TF9ERVZJQ0VfQUNDRVNTX0ZJTEVfUkVBRF9XUklURV9BQ0NFU1M6CiAJCQlvcGFybXMuZGVzaXJl
ZF9hY2Nlc3MgPSBGSUxFX1JFQURfREFUQSB8IEZJTEVfV1JJVEVfREFUQSB8IEZJTEVfUkVBRF9B
VFRSSUJVVEVTIHwgU1lOQ0hST05JWkU7Ci0JCQk7CisJCQlicmVhazsKKwkJY2FzZSBGU0NUTF9E
RVZJQ0VfQUNDRVNTX0ZJTEVfQU5ZX0FDQ0VTUzoKKwkJCW9wYXJtcy5kZXNpcmVkX2FjY2VzcyA9
IEdFTkVSSUNfQUxMOworCQkJYnJlYWs7CisJCWNhc2UgRlNDVExfREVWSUNFX0FDQ0VTU19GSUxF
X1JFQURfQUNDRVNTOgorCQkJb3Bhcm1zLmRlc2lyZWRfYWNjZXNzID0gR0VORVJJQ19SRUFEOwor
CQkJYnJlYWs7CisJCWNhc2UgRlNDVExfREVWSUNFX0FDQ0VTU19GSUxFX1dSSVRFX0FDQ0VTUzoK
KwkJCW9wYXJtcy5kZXNpcmVkX2FjY2VzcyA9IEdFTkVSSUNfV1JJVEU7CiAJCQlicmVhazsKIAkJ
fQogCX0KLS0gCjIuMTcuMQoK
--000000000000bfae5d058645c007--
