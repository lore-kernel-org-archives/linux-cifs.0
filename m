Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 782A9C38BE0
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 20:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36B7920656
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 20:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="omLt9buM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgBXUWW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 15:22:22 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:44735 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbgBXUWV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Feb 2020 15:22:21 -0500
Received: by mail-io1-f65.google.com with SMTP id z16so11617217iod.11
        for <linux-cifs@vger.kernel.org>; Mon, 24 Feb 2020 12:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IINHdkV6GTBcVwOjLmrfmdoahy/08EeUCK+EYR9pP7Y=;
        b=omLt9buMQT9ke/CgBYP6m90k5nNjRXLaJV3OlUktzd1c5LqzOyWPA43kJ9dv2YUFHK
         Gkr5CiIKhBct+kfyzYRnnKhpHMlz94r3plw3tQ37rdDFTgO5g2zB+DzjpqS6UpSwPl+L
         FDe1+ueNfU/fmifQKeh3ieVx8B+mu1g7bsKncaSTjdDqAExRbZiWYMO8OUEuoX3U+yKA
         Sk3LMjZwLfi0LNb6MX7hgYbvqwy6dJlQx2YCaREUU3E4ugrVR5JA95DgXdn0B3++YGhr
         vY4rrjwk4a6qJcjXWd8830J2hLHs0VYyK4ahHIDW5JVk9oAYqC+EMOfyJr5bSGNdG82d
         x0qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IINHdkV6GTBcVwOjLmrfmdoahy/08EeUCK+EYR9pP7Y=;
        b=KR7dWhPgA1ONjs74xlB/S7UGtqn21kV2jPh90/Il6/2QeO00ayNo3ss7Un5AZqaFZr
         PuddsubvZQG+CZkAZybXW47AT21g1Sq1b4LUusTI/QFqFEk2f166eIYQpC0FQ1MCcmTB
         z0Ih9o4zGtSYAZ030nvSnESVDlQsTrz8BxVwo/Qbyx3Tme/IJPi6XwbzdLDZMfNEKNYQ
         C5g2+vb9diUil0Dl9gVMNWszMAHFFXoLTW4rzdwaQM6jn3nTYrmomXLC77EzejxRibj/
         y/rTh+uKKBFCrLstbSQRe1NbGyqQgrch2O7zbncpUij/HXOIpakxJCMqHsGtfz4/CEQ6
         3qNA==
X-Gm-Message-State: APjAAAVZ6fJtXcF27cC4CT9ORx+5ulPB/oTGXE5D1A1Csc7qqugsTPix
        tCVjqEd/HZiVGQkCoZFldm7YrpcdapOqvDCsW6g=
X-Google-Smtp-Source: APXvYqxSS3kGkaHdfSGde7f9uYvIja6Q3CKhVpB4htuD98VEqCvp3rwb+hlFIJLFTrbT5OsVHXbpqt3Set/hY98iqgY=
X-Received: by 2002:a6b:cd0e:: with SMTP id d14mr51233116iog.272.1582575740784;
 Mon, 24 Feb 2020 12:22:20 -0800 (PST)
MIME-Version: 1.0
References: <20200218200103.12574-1-lsahlber@redhat.com> <CAH2r5mvXp_KvT5CmpmsbNbb2bVD+qKRu22QPw3_KTq38UURFTA@mail.gmail.com>
 <CAKywueSsso_n_KM5qv9kuLVEPyjUaqh3u973EJ_+RLRaGwBFtg@mail.gmail.com>
In-Reply-To: <CAKywueSsso_n_KM5qv9kuLVEPyjUaqh3u973EJ_+RLRaGwBFtg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 24 Feb 2020 14:22:09 -0600
Message-ID: <CAH2r5ms35H2miJ=tHFXQfAfoD0AE+CxX8xhVMrJWmK9sG_Z6Vw@mail.gmail.com>
Subject: Re: [PATCH] cifs: don't leak -EAGAIN for stat() during reconnect
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000dcbe63059f5820e3"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000dcbe63059f5820e3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated Ronnie's patch and remerged to cifs-2.6.git for-next

Let me know if any objections

On Mon, Feb 24, 2020 at 1:36 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D0=B2=D1=82, 18 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 15:27, Ste=
ve French <smfrench@gmail.com>:
> >
> > merged into cifs-2.6.git for-next
> >
> > On Tue, Feb 18, 2020 at 2:07 PM Ronnie Sahlberg <lsahlber@redhat.com> w=
rote:
> > >
> > > If from cifs_revalidate_dentry_attr() the SMB2/QUERY_INFO call fails =
with an
> > > error, such as STATUS_SESSION_EXPIRED, causing the session to be reco=
nnected
> > > it is possible we will leak -EAGAIN back to the application even for
> > > system calls such as stat() where this is not a valid error.
> > >
> > > Fix this by re-trying the operation from within cifs_revalidate_dentr=
y_attr()
> > > if cifs_get_inode_info*() returns -EAGAIN.
> > >
> > > This fixes stat() and possibly also other system calls that uses
> > > cifs_revalidate_dentry*().
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/inode.c | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > > index b5e6635c578e..1212ace05258 100644
> > > --- a/fs/cifs/inode.c
> > > +++ b/fs/cifs/inode.c
> > > @@ -2073,6 +2073,7 @@ int cifs_revalidate_dentry_attr(struct dentry *=
dentry)
> > >         struct inode *inode =3D d_inode(dentry);
> > >         struct super_block *sb =3D dentry->d_sb;
> > >         char *full_path =3D NULL;
> > > +       int count =3D 0;
> > >
> > >         if (inode =3D=3D NULL)
> > >                 return -ENOENT;
> > > @@ -2094,15 +2095,18 @@ int cifs_revalidate_dentry_attr(struct dentry=
 *dentry)
> > >                  full_path, inode, inode->i_count.counter,
> > >                  dentry, cifs_get_time(dentry), jiffies);
> > >
> > > +again:
> > >         if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
> > >                 rc =3D cifs_get_inode_info_unix(&inode, full_path, sb=
, xid);
> > >         else
> > >                 rc =3D cifs_get_inode_info(&inode, full_path, NULL, s=
b,
> > >                                          xid, NULL);
> > > -
> > > +       if (is_retryable_error(rc) && count++ < 10)
> > > +               goto again;
>
> If there is interrupt error, you will end up doing 10 attempts with
> the same outcome - interrupt error. Such errors should be returned to
> the upper layers to be handled correctly (restart of a system call or
> return of EINTR error to the user space).
>
> Please revert to your original version that handles EAGAIN only.
>
> --
> Best regards,
> Pavel Shilovsky
>
> > >  out:
> > >         kfree(full_path);
> > >         free_xid(xid);
> > > +
> > >         return rc;
> > >  }
> > >
> > > --
> > > 2.13.6
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve

--000000000000dcbe63059f5820e3
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-don-t-leak-EAGAIN-for-stat-during-reconnect.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-don-t-leak-EAGAIN-for-stat-during-reconnect.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k70wq0rz0>
X-Attachment-Id: f_k70wq0rz0

RnJvbSA5MjU1ZjFjNTc4OGMwZDk3ZDBlZjMxYjBmYWJiNjQ1Nzc4N2NlNjgwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFdlZCwgMTkgRmViIDIwMjAgMDY6MDE6MDMgKzEwMDAKU3ViamVjdDogW1BBVENIIDAx
LzEwXSBjaWZzOiBkb24ndCBsZWFrIC1FQUdBSU4gZm9yIHN0YXQoKSBkdXJpbmcgcmVjb25uZWN0
CgpJZiBmcm9tIGNpZnNfcmV2YWxpZGF0ZV9kZW50cnlfYXR0cigpIHRoZSBTTUIyL1FVRVJZX0lO
Rk8gY2FsbCBmYWlscyB3aXRoIGFuCmVycm9yLCBzdWNoIGFzIFNUQVRVU19TRVNTSU9OX0VYUElS
RUQsIGNhdXNpbmcgdGhlIHNlc3Npb24gdG8gYmUgcmVjb25uZWN0ZWQKaXQgaXMgcG9zc2libGUg
d2Ugd2lsbCBsZWFrIC1FQUdBSU4gYmFjayB0byB0aGUgYXBwbGljYXRpb24gZXZlbiBmb3IKc3lz
dGVtIGNhbGxzIHN1Y2ggYXMgc3RhdCgpIHdoZXJlIHRoaXMgaXMgbm90IGEgdmFsaWQgZXJyb3Iu
CgpGaXggdGhpcyBieSByZS10cnlpbmcgdGhlIG9wZXJhdGlvbiBmcm9tIHdpdGhpbiBjaWZzX3Jl
dmFsaWRhdGVfZGVudHJ5X2F0dHIoKQppZiBjaWZzX2dldF9pbm9kZV9pbmZvKigpIHJldHVybnMg
LUVBR0FJTi4KClRoaXMgZml4ZXMgc3RhdCgpIGFuZCBwb3NzaWJseSBhbHNvIG90aGVyIHN5c3Rl
bSBjYWxscyB0aGF0IHVzZXMKY2lmc19yZXZhbGlkYXRlX2RlbnRyeSooKS4KClNpZ25lZC1vZmYt
Ynk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTog
U3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgpSZXZpZXdlZC1ieTogUGF2ZWwg
U2hpbG92c2t5IDxwc2hpbG92QG1pY3Jvc29mdC5jb20+ClJldmlld2VkLWJ5OiBBdXJlbGllbiBB
cHRlbCA8YWFwdGVsQHN1c2UuY29tPgpDQzogU3RhYmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3Jn
PgotLS0KIGZzL2NpZnMvaW5vZGUuYyB8IDYgKysrKystCiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9pbm9kZS5jIGIv
ZnMvY2lmcy9pbm9kZS5jCmluZGV4IGI1ZTY2MzVjNTc4ZS4uMTIxMmFjZTA1MjU4IDEwMDY0NAot
LS0gYS9mcy9jaWZzL2lub2RlLmMKKysrIGIvZnMvY2lmcy9pbm9kZS5jCkBAIC0yMDczLDYgKzIw
NzMsNyBAQCBpbnQgY2lmc19yZXZhbGlkYXRlX2RlbnRyeV9hdHRyKHN0cnVjdCBkZW50cnkgKmRl
bnRyeSkKIAlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gZF9pbm9kZShkZW50cnkpOwogCXN0cnVjdCBz
dXBlcl9ibG9jayAqc2IgPSBkZW50cnktPmRfc2I7CiAJY2hhciAqZnVsbF9wYXRoID0gTlVMTDsK
KwlpbnQgY291bnQgPSAwOwogCiAJaWYgKGlub2RlID09IE5VTEwpCiAJCXJldHVybiAtRU5PRU5U
OwpAQCAtMjA5NCwxNSArMjA5NSwxOCBAQCBpbnQgY2lmc19yZXZhbGlkYXRlX2RlbnRyeV9hdHRy
KHN0cnVjdCBkZW50cnkgKmRlbnRyeSkKIAkJIGZ1bGxfcGF0aCwgaW5vZGUsIGlub2RlLT5pX2Nv
dW50LmNvdW50ZXIsCiAJCSBkZW50cnksIGNpZnNfZ2V0X3RpbWUoZGVudHJ5KSwgamlmZmllcyk7
CiAKK2FnYWluOgogCWlmIChjaWZzX3NiX21hc3Rlcl90Y29uKENJRlNfU0Ioc2IpKS0+dW5peF9l
eHQpCiAJCXJjID0gY2lmc19nZXRfaW5vZGVfaW5mb191bml4KCZpbm9kZSwgZnVsbF9wYXRoLCBz
YiwgeGlkKTsKIAllbHNlCiAJCXJjID0gY2lmc19nZXRfaW5vZGVfaW5mbygmaW5vZGUsIGZ1bGxf
cGF0aCwgTlVMTCwgc2IsCiAJCQkJCSB4aWQsIE5VTEwpOwotCisJaWYgKHJjID09IC1FQUdBSU4g
JiYgY291bnQrKyA8IDEwKQorCQlnb3RvIGFnYWluOwogb3V0OgogCWtmcmVlKGZ1bGxfcGF0aCk7
CiAJZnJlZV94aWQoeGlkKTsKKwogCXJldHVybiByYzsKIH0KIAotLSAKMi4yMC4xCgo=
--000000000000dcbe63059f5820e3--
