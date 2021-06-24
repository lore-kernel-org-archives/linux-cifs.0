Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF73C48BC2
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 00:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B1D461289
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 00:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhFXAaX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 20:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFXAaX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Jun 2021 20:30:23 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01980C061574
        for <linux-cifs@vger.kernel.org>; Wed, 23 Jun 2021 17:28:04 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id f13so5334545ljp.10
        for <linux-cifs@vger.kernel.org>; Wed, 23 Jun 2021 17:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tLl+ar/h6Qsa+CRQPaNUxOkoq8Drpm4+UQLa73tXSqA=;
        b=Y25Ui+g/ciDwLhm3X/L4G0L1lyCFDUCZRM7nvJqWd3Q45YBaOOCk2mgZCYxqoyeopN
         Lv5A3X22hurnLMKw2BwBwDGaANxIYbPy20qpQcHJVENQl7ieXibQQFEN3tdiQ8JPafTc
         uzoDQWmIT6aOTJH1MNfNzIvKvSw5hB6MMxOZOAItZI61WptsWIYPlsk7O6Fr5Up22kCO
         zATQ5HZgV+ZJXWo/0zLrXOH5wMfpzsq3EIY2qr9KfvB8HVdrn/miy8z2K04ZY07wciV8
         Mqgv0mnCR9BlSJpoNT13HVdzkUdMCtZn5Ym91/cE7HjWCboy45HV5n3rYVaZrpML9aIa
         u2qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tLl+ar/h6Qsa+CRQPaNUxOkoq8Drpm4+UQLa73tXSqA=;
        b=BYXjKsKmSxNgc+Qxpyo6frODwuI1EO065Q1WG9n4QsrefF2bvY8c88Gz0bedqZPhvS
         tHf8THgcc0rC2JzyHUon8DIdvT6YOP7t1GA5mFxTuD4gYnk1zziaFZQdIHohclSud8P2
         lR6G0cKlrQRdjqbnnFXB3AGaJMWQRZHKnfKtyG1FfJpepl5ggzkJLMjqgvclueEiNRFt
         sjy62p83+Uc6cwqoLMVRK7K/HhWb1qvphppuGozRkJnfoeBGV0EKXw4silbCTqbB0/VC
         ylE9mf3L1sJNuMuSlYuNvIJs87zTkarpcW/QtYhkvDKKM+F64cLBL38GU9qYTRc5IHIY
         m34w==
X-Gm-Message-State: AOAM531RKmpT7yBjXgV04Z4ZRccZRjrYD0OsY2rP1PxGU6wviqcQ1Uqx
        rLj4afeJ89FdrP+Joysg3wdjU9M2NW7VM86nQpo=
X-Google-Smtp-Source: ABdhPJwDFkJne6Xvxm/VyE1HGwS2V+SGJeZTWKGwdAFHUB/zD1UkYCOR9iNdgJsZZ5vqD/33CtZ2sXisQJ63gCUsCyg=
X-Received: by 2002:a2e:a234:: with SMTP id i20mr1754613ljm.272.1624494482311;
 Wed, 23 Jun 2021 17:28:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms_paV2a7KZwWkmz25pn4iS2kEDErGpNapOWZ5Kd_bUNw@mail.gmail.com>
 <87bl7wreou.fsf@suse.com> <CAH2r5msXgL5PZB8k99MJW-u5bNbHY9QxS8hKUasRqYTYR-z0bQ@mail.gmail.com>
In-Reply-To: <CAH2r5msXgL5PZB8k99MJW-u5bNbHY9QxS8hKUasRqYTYR-z0bQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 23 Jun 2021 19:27:51 -0500
Message-ID: <CAH2r5mswQTfoBODrC_P7wYuiXJpUvR-22uHfH0KSL-CcQFasnw@mail.gmail.com>
Subject: Re: [PATCH][CIFS] Fix uninitialized pointer access to dacl_ptr in build_sec_desc
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000008ee04905c578188e"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000008ee04905c578188e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

just changed the one place you noted (to keep the patch smaller) - see atta=
ched.


On Wed, Jun 23, 2021 at 9:17 AM Steve French <smfrench@gmail.com> wrote:
>
> On Wed, Jun 23, 2021 at 6:41 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wro=
te:
> >
> > Steve French <smfrench@gmail.com> writes:
> >
> > >     smb3: fix possible access to uninitialized pointer to DACL
> > >
> > >     dacl_ptr can be null so we must check for it (ie if dacloffset is
> > > set) everywhere dacl_ptr is
> > >     used in build_sec_desc - and we were missing one check
> > >
> > >     Addresses-Coverity: 1475598 ("Explicit null dereference")
> >
> > Looks OK since dacl_ptr is only set if dacloffset is set but it would
> > be clearer if you check for dacl_ptr directly no? Any reason you are
> > checking this way?
> >
> > I think this is clearer, unless I'm missing something:
> >
> > ndacl_ptr->num_aces =3D dacl_ptr ? dacl_ptr->num_aces : 0;
>
> I agree that your suggestion is clearer but I was trying to match the
> existing checks in the same code.
> Will change both to your suggestion which is clearer.
>
>
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> > > From ec06cb04376e5abc927a9b85dd768ce8728965bb Mon Sep 17 00:00:00 200=
1
> > > From: Steve French <stfrench@microsoft.com>
> > > Date: Tue, 22 Jun 2021 17:54:50 -0500
> > > Subject: [PATCH] smb3: fix possible access to uninitialized pointer t=
o DACL
> > >
> > > dacl_ptr can be null so we must check for it everywhere it is
> > > used in build_sec_desc.
> > >
> > > Addresses-Coverity: 1475598 ("Explicit null dereference")
> > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > ---
> > >  fs/cifs/cifsacl.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> > > index 784407f9280f..25a8139336fa 100644
> > > --- a/fs/cifs/cifsacl.c
> > > +++ b/fs/cifs/cifsacl.c
> > > @@ -1308,7 +1308,7 @@ static int build_sec_desc(struct cifs_ntsd *pnt=
sd, struct cifs_ntsd *pnntsd,
> > >               ndacl_ptr =3D (struct cifs_acl *)((char *)pnntsd + ndac=
loffset);
> > >               ndacl_ptr->revision =3D
> > >                       dacloffset ? dacl_ptr->revision : cpu_to_le16(A=
CL_REVISION);
> > > -             ndacl_ptr->num_aces =3D dacl_ptr->num_aces;
> > > +             ndacl_ptr->num_aces =3D dacloffset ? dacl_ptr->num_aces=
 : 0;
> > >
> > >               if (uid_valid(uid)) { /* chown */
> > >                       uid_t id;
> > > --
> > > 2.30.2
> > >
> >
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
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

--0000000000008ee04905c578188e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0003-smb3-fix-possible-access-to-uninitialized-pointer-to.patch"
Content-Disposition: attachment; 
	filename="0003-smb3-fix-possible-access-to-uninitialized-pointer-to.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kqa623e30>
X-Attachment-Id: f_kqa623e30

RnJvbSBkYjMxMGM1NjJlMmZmMzI3NWE0ZWYxM2Q2NDgwNzVhMjkwNjQ4MTU5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjIgSnVuIDIwMjEgMTc6NTQ6NTAgLTA1MDAKU3ViamVjdDogW1BBVENIIDMv
NV0gc21iMzogZml4IHBvc3NpYmxlIGFjY2VzcyB0byB1bmluaXRpYWxpemVkIHBvaW50ZXIgdG8K
IERBQ0wKCmRhY2xfcHRyIGNhbiBiZSBudWxsIHNvIHdlIG11c3QgY2hlY2sgZm9yIGl0IGV2ZXJ5
d2hlcmUgaXQgaXMKdXNlZCBpbiBidWlsZF9zZWNfZGVzYy4KCkFkZHJlc3Nlcy1Db3Zlcml0eTog
MTQ3NTU5OCAoIkV4cGxpY2l0IG51bGwgZGVyZWZlcmVuY2UiKQpTaWduZWQtb2ZmLWJ5OiBTdGV2
ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzYWNsLmMg
fCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRp
ZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNhY2wuYyBiL2ZzL2NpZnMvY2lmc2FjbC5jCmluZGV4IDVl
YzVkOWQyNDAzMi4uMzM1NmQ3NjJjZGY1IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNhY2wuYwor
KysgYi9mcy9jaWZzL2NpZnNhY2wuYwpAQCAtMTI5NCw3ICsxMjk0LDcgQEAgc3RhdGljIGludCBi
dWlsZF9zZWNfZGVzYyhzdHJ1Y3QgY2lmc19udHNkICpwbnRzZCwgc3RydWN0IGNpZnNfbnRzZCAq
cG5udHNkLAogCQluZGFjbF9wdHIgPSAoc3RydWN0IGNpZnNfYWNsICopKChjaGFyICopcG5udHNk
ICsgbmRhY2xvZmZzZXQpOwogCQluZGFjbF9wdHItPnJldmlzaW9uID0KIAkJCWRhY2xvZmZzZXQg
PyBkYWNsX3B0ci0+cmV2aXNpb24gOiBjcHVfdG9fbGUxNihBQ0xfUkVWSVNJT04pOwotCQluZGFj
bF9wdHItPm51bV9hY2VzID0gZGFjbF9wdHItPm51bV9hY2VzOworCQluZGFjbF9wdHItPm51bV9h
Y2VzID0gZGFjbF9wdHIgPyBkYWNsX3B0ci0+bnVtX2FjZXMgOiAwOwogCiAJCWlmICh1aWRfdmFs
aWQodWlkKSkgeyAvKiBjaG93biAqLwogCQkJdWlkX3QgaWQ7Ci0tIAoyLjMwLjIKCg==
--0000000000008ee04905c578188e--
