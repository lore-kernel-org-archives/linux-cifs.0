Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB1E1F583E
	for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 21:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742246983; cv=none; b=QK38A/riOAPvnz6/vHV7WMxgGPLJkOI2asXy38t9s9xXgoxIdT4KnwlJLg2CSCx8eRJj4akX+JajNqXo9h6VN+NG8kFV7QLTGERAPoulwanrrneNQ9pPP/l1YOP+zzv1sXEJbe65bWV7YqqhuNG+exLKlAHIloH2YU0nO20H0ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742246983; c=relaxed/simple;
	bh=gDV3QzuZRojxv49UOqkWUMI4lsI3UME7Y6VXfTxnnag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CuQvsfLkllL9euO+xeCQtmg92NjXkeTL7UbpPfUu5D1kh3gAVQbOFIs07T6bZ1NVVEaf0apb2fvH8+wzcAoVEVPKQZhAGGMYigw0nyAIWF+dvtAHn2UB6hqgLhYKkumxmGLXz3Ile5bS3qxN1IiWgYRpyaF4yo7QLyvXuY7msHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jQ5RFiTT; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jQ5RFiTT"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-30bf5d7d107so44755011fa.2
        for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 14:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742246980; x=1742851780; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l3jLRI4fPAPnbbd7bi+1L0HtZEbIiZmXbHWcDRW8WyI=;
        b=jQ5RFiTTzo8sdbB2c/eNo77Ni1kCL+iMhAkRXQzGCzFYsgLTZZrL9S4PSI5mXqZuVN
         3uvhLwGCiJ7h9pKI8QlQu5MkNLyyMmsE9nlpn0UvkyKS7NudhAfovFoxw4obAjwAbjjE
         uFGRTwDK2/27Af2aZ8h2fHvdl1kvRSLNE5KQtnuD+mVyFJE1qAhOKwzEV2187OFBsaJ9
         Gc2AxFAV/53fmk2b48owqKFTQUnF6PEglmqKi09UPenmXS5fCrD4cNmO3KirsBMQ7YPi
         vGB1ky6ITiI9YVfTkL90gA97nzD5XVyREg6oVNzkTRVa84omsLCYcOsh7lj5G77nnx6D
         MBvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742246980; x=1742851780;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l3jLRI4fPAPnbbd7bi+1L0HtZEbIiZmXbHWcDRW8WyI=;
        b=HrElQq2DaCuZnsrZDNQReS43au+FsZbcob2xukrfkMT9+b7EXHXgqpNTJsI8gPqVUj
         Y2FXPxmSQLmGQya98AuYOWcuRcSfAlrYtNjxB/rFxmRKSTMecKryXUa+SPpQhW1p6cOG
         tOQT2u3t+ipirLmKwxh9d6HKYCOw4CMGctTZ6qQppUwEQArvW/hR36HZigA6LhPnxCKr
         Tu4atBuVdEf21LxvN6nOBANBc7z+oEiyPAy3cWPsCLsI2i0pg8MhtW5pM7kXg3bcL3/5
         TRTGQyg9F6zs2GP6EtsnpwZV1w3PdezDJcGlSOlqi8qWoYTmEEASCX5BFftB7GSZ0Wi8
         OKAg==
X-Forwarded-Encrypted: i=1; AJvYcCXUS3w6pXt2PtCW3V0KpWSUWyE+w00WfUam9DnTvOyNYRjGcXQg3NxpnB2MAF/kZGx8dbMzzX2PfAOc@vger.kernel.org
X-Gm-Message-State: AOJu0YwL9Ltxmg2XSg/BT9rR5g1Tbr46Km69LPixUj98cNmehPUPC5KR
	c9O40/0xXrNn8s9/fnZKOKqyXV9g6lZmhpRLY8l/alihvuGtgQ7eccBP9stJ/ghVPEbXMM/9NCd
	7OyDQ/J2r+elMjvfY5Vrm8a5ixkc=
X-Gm-Gg: ASbGncsD5PFzuReaHB9GE1nR4qS5KC5JWk5QHELKUcAoM0QKckcuz5y3CVYkQsWcmHu
	tsFa9pzli0yZ7NcRAb0ABgNPKSSYqp8tfS0Swrv7EkrZlEnTmgUWn7o+xbRKvWduT1FluwJ5W/B
	BvFvGXQVvemAAxFIWX9cYJCdixKly0FMBhhwgs5XlwikKoT83WZxPBKivu72M=
X-Google-Smtp-Source: AGHT+IHVr/VKUGULP0uPQu9Dkb82bqdRwsDYDujZH4MlerLbp3DUxEzBpdrXg8TfuP/moKraJoGfejMW4oq297ZyN2Q=
X-Received: by 2002:a05:6512:130c:b0:549:66d8:a1d2 with SMTP id
 2adb3069b0e04-549c3900595mr8802229e87.19.1742246979391; Mon, 17 Mar 2025
 14:29:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250312135131.628756-1-pc@manguebit.com> <CAH2r5mtjtigJf7JKUiL3D5Lp8f4qTe4GUxQPXwz1o=SQMqiqdA@mail.gmail.com>
 <70d0157ac13725595d64978b11c4d3a91f417803.camel@redhat.com>
 <4cbaab94c2ba97a8d91b9f43ea8a3662@manguebit.com> <CAH2r5mu5=nnBwibmARGoLepbQfU6qkXnez8whaWaSM7G7MEVXw@mail.gmail.com>
 <9ef1d7140c93877011e7ca5fdcd13ec4@manguebit.com> <CAFTVevVmp7f5Mv7CZhKhV9287ev0Wf9=7d3qakS6BNs2b4wayA@mail.gmail.com>
In-Reply-To: <CAFTVevVmp7f5Mv7CZhKhV9287ev0Wf9=7d3qakS6BNs2b4wayA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 17 Mar 2025 16:29:27 -0500
X-Gm-Features: AQ5f1JovGMzSIh3AyT7qan4fwiNigcORQhQ7uFN88GGFRs94cqYed7fViWWdUTI
Message-ID: <CAH2r5ms3s=9wrB-eMcnSupCD4d8S-v6o3tYWkpVyxfJqSVtYnA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix regression with guest option
To: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, Adam Williamson <awilliam@redhat.com>, linux-cifs@vger.kernel.org, 
	Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000005195e70630907cf0"

--0000000000005195e70630907cf0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Made minor updates to the patch (white space cleanup that checkpatch
spotted) and added the RB (see attached)

Merged into github smb3-utils for-next branch and also to cifs-utils
samba.org for-next
https://git.samba.org/?p=3Dcifs-utils.git;a=3Dshortlog;h=3Drefs/heads/for-n=
ext

On Sat, Mar 15, 2025 at 2:09=E2=80=AFAM Meetakshi Setiya
<meetakshisetiyaoss@gmail.com> wrote:
>
> Thanks Paulo, created a PR for cifs-utils based on your suggestion
> https://github.com/smfrench/smb3-utils/pull/14
>
> Thanks
> Meetakshi
>
> On Wed, Mar 12, 2025 at 9:53=E2=80=AFPM Paulo Alcantara <pc@manguebit.com=
> wrote:
> >
> > Steve French <smfrench@gmail.com> writes:
> >
> > > Meetakshi sent a patch idea to try (to also fix this in cifs-utils) -
> > > will take a look
> >
> > Where is the patch?
> >
> > Something like below would work
> >
> > diff --git a/mount.cifs.c b/mount.cifs.c
> > index 7605130..16730c6 100644
> > --- a/mount.cifs.c
> > +++ b/mount.cifs.c
> > @@ -200,6 +200,7 @@ struct parsed_mount_info {
> >         unsigned int got_domain:1;
> >         unsigned int is_krb5:1;
> >         unsigned int is_noauth:1;
> > +       unsigned int is_guest:1;
> >         uid_t sudo_uid;
> >  };
> >
> > @@ -1161,6 +1162,7 @@ parse_options(const char *data, struct parsed_mou=
nt_info *parsed_info)
> >                         parsed_info->got_user =3D 1;
> >                         parsed_info->got_password =3D 1;
> >                         parsed_info->got_password2 =3D 1;
> > +                       parsed_info->is_guest =3D 1;
> >                         goto nocopy;
> >                 case OPT_RO:
> >                         *filesys_flags |=3D MS_RDONLY;
> > @@ -2334,7 +2336,9 @@ mount_retry:
> >                 fprintf(stderr, "%s kernel mount options: %s",
> >                         thisprogram, options);
> >
> > -       if (parsed_info->got_password && !(parsed_info->is_krb5 || pars=
ed_info->is_noauth)) {
> > +       if (parsed_info->got_password &&
> > +           !(parsed_info->is_krb5 || parsed_info->is_noauth ||
> > +             parsed_info->is_guest)) {
> >                 /*
> >                  * Commas have to be doubled, or else they will
> >                  * look like the parameter separator
> > @@ -2345,7 +2349,9 @@ mount_retry:
> >                         fprintf(stderr, ",pass=3D********");
> >         }
> >
> > -       if (parsed_info->got_password2 && !(parsed_info->is_krb5 || par=
sed_info->is_noauth)) {
> > +       if (parsed_info->got_password2 &&
> > +           !(parsed_info->is_krb5 || parsed_info->is_noauth ||
> > +             parsed_info->is_guest)) {
> >                 strlcat(options, ",password2=3D", options_size);
> >                 strlcat(options, parsed_info->password2, options_size);
> >                 if (parsed_info->verboseflag)



--=20
Thanks,

Steve

--0000000000005195e70630907cf0
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-Fix-regression-in-mount.cifs-with-guest-mount-option.patch"
Content-Disposition: attachment; 
	filename="0001-Fix-regression-in-mount.cifs-with-guest-mount-option.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m8dkrdsn0>
X-Attachment-Id: f_m8dkrdsn0

RnJvbSBhYzRkNmU5Y2Y2OWUxNzk0ZGZmMDYxZDYyZjcyNzM4OGEzYjhiMTJiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNZWV0YWtzaGkgU2V0aXlhIDxtc2V0aXlhQG1pY3Jvc29mdC5j
b20+CkRhdGU6IFNhdCwgMTUgTWFyIDIwMjUgMDY6NDk6MTMgKzAwMDAKU3ViamVjdDogW1BBVENI
XSBGaXggcmVncmVzc2lvbiBpbiBtb3VudC5jaWZzIHdpdGggZ3Vlc3QgbW91bnQgb3B0aW9uCgpt
b3VudC5jaWZzIHdhcyBlcnJvbmVvdXNseSBwYXNzaW5nIHRoZSBlbXB0eSBwYXNzd29yZCBhbmQg
cGFzc3dvcmQyCnN0cmluZ3MgdG8gdGhlIGxpbnV4IHNtYiBjbGllbnQgZm9yICJndWVzdCIgbW91
bnRzLiBIYW5kbGluZyBlbXB0eQpwYXNzd29yZDIgaGFzIG5vdCBiZWVuIGltcGxlbWVudGVkIG9u
IHRoZSBjbGllbnQgeWV0LCB3aGljaCBlbmRzIHVwCmZhaWxpbmcgdGhlIG1vdW50IHdpdGggImNp
ZnM6IEJhZCB2YWx1ZSBmb3IgcGFzc3dvcmQyIi4KClRoaXMgcGF0Y2ggY29udGFpbnMgZml4ZXMg
Zm9yIHRoZSBtZW50aW9uZWQgc2NlbmFyaW8uCgpTaWduZWQtb2ZmLWJ5OiBNZWV0YWtzaGkgU2V0
aXlhIDxtc2V0aXlhQG1pY3Jvc29mdC5jb20+ClJldmlld2VkLWJ5OiBQYXVsbyBBbGNhbnRhcmEg
KFJlZCBIYXQpIDxwY0BtYW5ndWViaXQuY29tPgpSZXZpZXdlZC1ieTogQmhhcmF0aCBTTSA8Ymhh
cmF0aHNtQG1pY3Jvc29mdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVu
Y2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBtb3VudC5jaWZzLmMgfCA4ICsrKysrKy0tCiAxIGZpbGUg
Y2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL21v
dW50LmNpZnMuYyBiL21vdW50LmNpZnMuYwppbmRleCA3NjA1MTMwLi42ZWRkOTZlIDEwMDY0NAot
LS0gYS9tb3VudC5jaWZzLmMKKysrIGIvbW91bnQuY2lmcy5jCkBAIC0yMDAsNiArMjAwLDcgQEAg
c3RydWN0IHBhcnNlZF9tb3VudF9pbmZvIHsKIAl1bnNpZ25lZCBpbnQgZ290X2RvbWFpbjoxOwog
CXVuc2lnbmVkIGludCBpc19rcmI1OjE7CiAJdW5zaWduZWQgaW50IGlzX25vYXV0aDoxOworCXVu
c2lnbmVkIGludCBpc19ndWVzdDoxOwogCXVpZF90IHN1ZG9fdWlkOwogfTsKIApAQCAtMTE1OCw2
ICsxMTU5LDcgQEAgcGFyc2Vfb3B0aW9ucyhjb25zdCBjaGFyICpkYXRhLCBzdHJ1Y3QgcGFyc2Vk
X21vdW50X2luZm8gKnBhcnNlZF9pbmZvKQogCQkJKmZpbGVzeXNfZmxhZ3MgJj0gfk1TX05PRVhF
QzsKIAkJCWdvdG8gbm9jb3B5OwogCQljYXNlIE9QVF9HVUVTVDoKKwkJCXBhcnNlZF9pbmZvLT5p
c19ndWVzdCA9IDE7CiAJCQlwYXJzZWRfaW5mby0+Z290X3VzZXIgPSAxOwogCQkJcGFyc2VkX2lu
Zm8tPmdvdF9wYXNzd29yZCA9IDE7CiAJCQlwYXJzZWRfaW5mby0+Z290X3Bhc3N3b3JkMiA9IDE7
CkBAIC0yMzM0LDcgKzIzMzYsOCBAQCBtb3VudF9yZXRyeToKIAkJZnByaW50ZihzdGRlcnIsICIl
cyBrZXJuZWwgbW91bnQgb3B0aW9uczogJXMiLAogCQkJdGhpc3Byb2dyYW0sIG9wdGlvbnMpOwog
Ci0JaWYgKHBhcnNlZF9pbmZvLT5nb3RfcGFzc3dvcmQgJiYgIShwYXJzZWRfaW5mby0+aXNfa3Ji
NSB8fCBwYXJzZWRfaW5mby0+aXNfbm9hdXRoKSkgeworCWlmIChwYXJzZWRfaW5mby0+Z290X3Bh
c3N3b3JkICYmCisJCSEocGFyc2VkX2luZm8tPmlzX2tyYjUgfHwgcGFyc2VkX2luZm8tPmlzX25v
YXV0aCB8fCBwYXJzZWRfaW5mby0+aXNfZ3Vlc3QpKSB7CiAJCS8qCiAJCSAqIENvbW1hcyBoYXZl
IHRvIGJlIGRvdWJsZWQsIG9yIGVsc2UgdGhleSB3aWxsCiAJCSAqIGxvb2sgbGlrZSB0aGUgcGFy
YW1ldGVyIHNlcGFyYXRvcgpAQCAtMjM0NSw3ICsyMzQ4LDggQEAgbW91bnRfcmV0cnk6CiAJCQlm
cHJpbnRmKHN0ZGVyciwgIixwYXNzPSoqKioqKioqIik7CiAJfQogCi0JaWYgKHBhcnNlZF9pbmZv
LT5nb3RfcGFzc3dvcmQyICYmICEocGFyc2VkX2luZm8tPmlzX2tyYjUgfHwgcGFyc2VkX2luZm8t
PmlzX25vYXV0aCkpIHsKKwlpZiAocGFyc2VkX2luZm8tPmdvdF9wYXNzd29yZDIgJiYKKwkJIShw
YXJzZWRfaW5mby0+aXNfa3JiNSB8fCBwYXJzZWRfaW5mby0+aXNfbm9hdXRoIHx8IHBhcnNlZF9p
bmZvLT5pc19ndWVzdCkpIHsKIAkJc3RybGNhdChvcHRpb25zLCAiLHBhc3N3b3JkMj0iLCBvcHRp
b25zX3NpemUpOwogCQlzdHJsY2F0KG9wdGlvbnMsIHBhcnNlZF9pbmZvLT5wYXNzd29yZDIsIG9w
dGlvbnNfc2l6ZSk7CiAJCWlmIChwYXJzZWRfaW5mby0+dmVyYm9zZWZsYWcpCi0tIAoyLjQzLjAK
Cg==
--0000000000005195e70630907cf0--
