Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D9859B7C
	for <linux-cifs@vger.kernel.org>; Wed, 28 Feb 2024 10:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709116037; cv=none; b=JMa0sIxBcLBxB80q7qbMsrYpkz6W0yCvAV6PP7HD+pu1qZLfRP5wIdIlZYhz179ASnGuD6aqZvI+6D9l6X6HaP0Fj1mRTf1MMzDOF+Kp8hdZanCwRmpvRye9WboCYLJyCeygmGL7lSnmkjoztoDkpUGFptBl20qHKH3mgR6O4P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709116037; c=relaxed/simple;
	bh=L6rDZkdvoBV4LFFXGR/am5SOJ5hOD2ZUaeIjazWlgwk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AO0OT05Nj+iurRD2MvAusdCYEzYofZZ5SGPDOsvnjK9Xjpv712D6O5Nbtx0QzjA6YGV+AtUiX+GAC37IXMP2StOnJqx3GfLPwjIxevMccqUk2kSM+vR5IVC6ibOaDwD2fEp9rX9I7hm84cPXNnc8l/VHNZl1xoX/z5acnBN9GFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fGIClpCp; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fGIClpCp"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-607cd210962so49040727b3.2
        for <linux-cifs@vger.kernel.org>; Wed, 28 Feb 2024 02:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709116035; x=1709720835; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CruJ6ipyJmIRMiX0lwiA6OjdjuszOLdcreoy+Ey8pfU=;
        b=fGIClpCpY+jeZp3kr8mgv1MyGvfXC4EH2Dhi8eX0BqQ/64L8150wUP30HE59cDzCxK
         h7bxvEuMGbm8h0OFJZnQRDmaEpCevga55IIvloxnNoeEZpPlFHUu+KaAopcPchnjtgJU
         afAyZuHI0xnKu55DXE8R+DKwhd9k5LYyDkez/vIANB8kxZjG5yDmep/eIJEtCpt+faM6
         XAZHOvP7CnAPy9FsS3WOANMNLXPazP6G/oJtIAGjTTO8C3tdUGbktZaw4gWdG90kBPFX
         mHweE9VxJXH3mIZ4Le39tpNPXThmHjJbHq/4rfWbqkuWjZNcGNi4pfLlY6qHB5ATWK+q
         n4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709116035; x=1709720835;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CruJ6ipyJmIRMiX0lwiA6OjdjuszOLdcreoy+Ey8pfU=;
        b=GrbCQ6VqqzBSeL1y89ufZXL+8EapDCIzqqD7e5Jfuog7oAsNuRAfCoysQGm6fG/9rx
         SVjwvUri7H0CyLPO9YUQndKx5IN+gyFfLUzZ1aNqzDVgtYurluvx8XdfYsLvKmhYiI6r
         4tCV7ntAuYRJZX39b5tSW7xhNxep/m1vJzSEXLcDdSUs1e3tlDAuPZ0J3BEnkQ715S/v
         G8J6B4jDk9gVdtG99NwY29TgVdWAW4+NiUxcycYsMDxPl0/PtfiOobNJbOsBmJ8X//9d
         PW+zcFQAB3CNFC2xXtHvcXhnGOKyeJX3jfmpXkEunKuzQ5HXKeW1K9lKDUVZVzhPHgnq
         iPzA==
X-Forwarded-Encrypted: i=1; AJvYcCXBZFo/Yyvki6RwRg5kaKAQiSIlhOSpYAskZYqap+5fL1iojWUC2KNombnjY/LArLEZIBTDaggntpa/7Mrl5vj3mL+x+wWk0RaveA==
X-Gm-Message-State: AOJu0YyKAB+jxdbiVrOd60fAWlLBmVG1x/LkaB5g3c1m1j4Idj5VYpgv
	wiT09h3j1j86W1aR46c2R0n3rhsysoZdtCV+kwT4sz41t2zg+Pt7b27/vm/P6Su0ji2luvvHXH6
	1A+mnJFsvGQpS6/MVBOLoU7/dGIE=
X-Google-Smtp-Source: AGHT+IGThmYtt5KK6UQJ1m5RuBgo+ePP15dQgQKfvFvhjsDT6t92HSw7uVPl3aa08g7Fq33eFPU0nxpERyEjMYpeMKg=
X-Received: by 2002:a25:d686:0:b0:dc6:e622:f52 with SMTP id
 n128-20020a25d686000000b00dc6e6220f52mr2081588ybg.31.1709116035188; Wed, 28
 Feb 2024 02:27:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240226045010.30908-1-bharathsm@microsoft.com> <CAH2r5msYJncggqkeNQRceNhcnQ1_BdYiQw9mw7fLogHfm8AySw@mail.gmail.com>
In-Reply-To: <CAH2r5msYJncggqkeNQRceNhcnQ1_BdYiQw9mw7fLogHfm8AySw@mail.gmail.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Wed, 28 Feb 2024 15:57:03 +0530
Message-ID: <CAGypqWzZoQZW4=EK_bCAORMXmw1+bdA7icptFEQCge05rrB14g@mail.gmail.com>
Subject: Re: [PATCH] cifs: prevent updating file size from server if we have a
 read/write lease
To: Steve French <smfrench@gmail.com>
Cc: pc@cjr.nz, sfrench@samba.org, nspmangalore@gmail.com, tom@talpey.com, 
	linux-cifs@vger.kernel.org, bharathsm@microsoft.com, 
	ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000002886eb06126e9638"

--0000000000002886eb06126e9638
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Attached updated patch to have this fix only for calls from readdir
i.e cifs_prime_dcache.

On Mon, Feb 26, 2024 at 10:44=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> My only worry is that perhaps we should make it more narrow (ie only
> when called from readdir ie cifs_prime_dcache()  rather than also
> never updating it on query_info calls)
>
> On Sun, Feb 25, 2024 at 10:50=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.=
com> wrote:
> >
> > In cases of large directories, the readdir operation may span multiple
> > round trips to retrieve contents. This introduces a potential race
> > condition in case of concurrent write and readdir operations. If the
> > readdir operation initiates before a write has been processed by the
> > server, it may update the file size attribute to an older value.
> > Address this issue by avoiding file size updates from server when a
> > read/write lease.
> >
> > Scenario:
> > 1) process1: open dir xyz
> > 2) process1: readdir instance 1 on xyz
> > 3) process2: create file.txt for write
> > 4) process2: write x bytes to file.txt
> > 5) process2: close file.txt
> > 6) process2: open file.txt for read
> > 7) process1: readdir 2 - overwrites file.txt inode size to 0
> > 8) process2: read contents of file.txt - bug, short read with 0 bytes
> >
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > ---
> >  fs/smb/client/file.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> > index f2db4a1f81ad..e742d0d0e579 100644
> > --- a/fs/smb/client/file.c
> > +++ b/fs/smb/client/file.c
> > @@ -2952,7 +2952,8 @@ bool is_size_safe_to_change(struct cifsInodeInfo =
*cifsInode, __u64 end_of_file)
> >         if (!cifsInode)
> >                 return true;
> >
> > -       if (is_inode_writable(cifsInode)) {
> > +       if (is_inode_writable(cifsInode) ||
> > +                       ((cifsInode->oplock & CIFS_CACHE_RW_FLG) !=3D 0=
)) {
> >                 /* This inode is open for write at least once */
> >                 struct cifs_sb_info *cifs_sb;
> >
> > --
> > 2.34.1
> >
>
>
> --
> Thanks,
>
> Steve

--0000000000002886eb06126e9638
Content-Type: application/octet-stream; 
	name="0001-cifs-prevent-updating-file-size-from-server-if-we-ha.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-prevent-updating-file-size-from-server-if-we-ha.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lt5njsil0>
X-Attachment-Id: f_lt5njsil0

RnJvbSAxYTIzODg1Y2JlYjQ5NjU5ZjBjYmNiZmEyZmE2NDE3NGZmNzlmMThiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4K
RGF0ZTogU3VuLCAyNSBGZWIgMjAyNCAyMTo0ODowNyArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IHByZXZlbnQgdXBkYXRpbmcgZmlsZSBzaXplIGZyb20gc2VydmVyIGlmIHdlIGhhdmUgYQog
cmVhZC93cml0ZSBsZWFzZQoKSW4gY2FzZXMgb2YgbGFyZ2UgZGlyZWN0b3JpZXMsIHRoZSByZWFk
ZGlyIG9wZXJhdGlvbiBtYXkgc3BhbiBtdWx0aXBsZQpyb3VuZCB0cmlwcyB0byByZXRyaWV2ZSBj
b250ZW50cy4gVGhpcyBpbnRyb2R1Y2VzIGEgcG90ZW50aWFsIHJhY2UKY29uZGl0aW9uIGluIGNh
c2Ugb2YgY29uY3VycmVudCB3cml0ZSBhbmQgcmVhZGRpciBvcGVyYXRpb25zLiBJZiB0aGUKcmVh
ZGRpciBvcGVyYXRpb24gaW5pdGlhdGVzIGJlZm9yZSBhIHdyaXRlIGhhcyBiZWVuIHByb2Nlc3Nl
ZCBieSB0aGUKc2VydmVyLCBpdCBtYXkgdXBkYXRlIHRoZSBmaWxlIHNpemUgYXR0cmlidXRlIHRv
IGFuIG9sZGVyIHZhbHVlLgpBZGRyZXNzIHRoaXMgaXNzdWUgYnkgYXZvaWRpbmcgZmlsZSBzaXpl
IHVwZGF0ZXMgZnJvbSByZWFkZGlyIHdoZW4gd2UKaGF2ZSByZWFkL3dyaXRlIGxlYXNlLgoKU2Nl
bmFyaW86CjEpIHByb2Nlc3MxOiBvcGVuIGRpciB4eXoKMikgcHJvY2VzczE6IHJlYWRkaXIgaW5z
dGFuY2UgMSBvbiB4eXoKMykgcHJvY2VzczI6IGNyZWF0ZSBmaWxlLnR4dCBmb3Igd3JpdGUKNCkg
cHJvY2VzczI6IHdyaXRlIHggYnl0ZXMgdG8gZmlsZS50eHQKNSkgcHJvY2VzczI6IGNsb3NlIGZp
bGUudHh0CjYpIHByb2Nlc3MyOiBvcGVuIGZpbGUudHh0IGZvciByZWFkCjcpIHByb2Nlc3MxOiBy
ZWFkZGlyIDIgLSBvdmVyd3JpdGVzIGZpbGUudHh0IGlub2RlIHNpemUgdG8gMAo4KSBwcm9jZXNz
MjogcmVhZCBjb250ZW50cyBvZiBmaWxlLnR4dCAtIGJ1Zywgc2hvcnQgcmVhZCB3aXRoIDAgYnl0
ZXMKClNpZ25lZC1vZmYtYnk6IEJoYXJhdGggU00gPGJoYXJhdGhzbUBtaWNyb3NvZnQuY29tPgot
LS0KIGZzL3NtYi9jbGllbnQvY2lmc3Byb3RvLmggfCAgNiArKysrLS0KIGZzL3NtYi9jbGllbnQv
ZmlsZS5jICAgICAgfCAgOCArKysrKy0tLQogZnMvc21iL2NsaWVudC9pbm9kZS5jICAgICB8IDEz
ICsrKysrKystLS0tLS0KIGZzL3NtYi9jbGllbnQvcmVhZGRpci5jICAgfCAgMiArLQogNCBmaWxl
cyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9mcy9zbWIvY2xpZW50L2NpZnNwcm90by5oIGIvZnMvc21iL2NsaWVudC9jaWZzcHJvdG8uaApp
bmRleCAxNDY4ZGYxZmY0N2QuLjk2MDJjZjZjNzJhNCAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVu
dC9jaWZzcHJvdG8uaAorKysgYi9mcy9zbWIvY2xpZW50L2NpZnNwcm90by5oCkBAIC0xNDQsNyAr
MTQ0LDggQEAgZXh0ZXJuIGludCBjaWZzX3JlY29ubmVjdChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZv
ICpzZXJ2ZXIsCiBleHRlcm4gaW50IGNoZWNrU01CKGNoYXIgKmJ1ZiwgdW5zaWduZWQgaW50IGxl
biwgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc3J2cik7CiBleHRlcm4gYm9vbCBpc192YWxpZF9v
cGxvY2tfYnJlYWsoY2hhciAqLCBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICopOwogZXh0ZXJuIGJv
b2wgYmFja3VwX2NyZWQoc3RydWN0IGNpZnNfc2JfaW5mbyAqKTsKLWV4dGVybiBib29sIGlzX3Np
emVfc2FmZV90b19jaGFuZ2Uoc3RydWN0IGNpZnNJbm9kZUluZm8gKiwgX191NjQgZW9mKTsKK2V4
dGVybiBib29sIGlzX3NpemVfc2FmZV90b19jaGFuZ2Uoc3RydWN0IGNpZnNJbm9kZUluZm8gKmNp
ZnNJbm9kZSwgX191NjQgZW9mLAorCQkJCSAgIGJvb2wgZnJvbV9yZWFkZGlyKTsKIHZvaWQgY2lm
c193cml0ZV9zdWJyZXF1ZXN0X3Rlcm1pbmF0ZWQoc3RydWN0IGNpZnNfaW9fc3VicmVxdWVzdCAq
d2RhdGEsIHNzaXplX3QgcmVzdWx0LAogCQkJCSAgICAgIGJvb2wgd2FzX2FzeW5jKTsKIGV4dGVy
biBzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpmaW5kX3dyaXRhYmxlX2ZpbGUoc3RydWN0IGNpZnNJbm9k
ZUluZm8gKiwgaW50KTsKQEAgLTIwMSw3ICsyMDIsOCBAQCBleHRlcm4gdm9pZCBjaWZzX3VuaXhf
YmFzaWNfdG9fZmF0dHIoc3RydWN0IGNpZnNfZmF0dHIgKmZhdHRyLAogCQkJCSAgICAgc3RydWN0
IGNpZnNfc2JfaW5mbyAqY2lmc19zYik7CiBleHRlcm4gdm9pZCBjaWZzX2Rpcl9pbmZvX3RvX2Zh
dHRyKHN0cnVjdCBjaWZzX2ZhdHRyICosIEZJTEVfRElSRUNUT1JZX0lORk8gKiwKIAkJCQkJc3Ry
dWN0IGNpZnNfc2JfaW5mbyAqKTsKLWV4dGVybiBpbnQgY2lmc19mYXR0cl90b19pbm9kZShzdHJ1
Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgY2lmc19mYXR0ciAqZmF0dHIpOworZXh0ZXJuIGludCBj
aWZzX2ZhdHRyX3RvX2lub2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBjaWZzX2ZhdHRy
ICpmYXR0ciwKKwkJCSAgICAgICBib29sIGZyb21fcmVhZGRpcik7CiBleHRlcm4gc3RydWN0IGlu
b2RlICpjaWZzX2lnZXQoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwKIAkJCSAgICAgICBzdHJ1Y3Qg
Y2lmc19mYXR0ciAqZmF0dHIpOwogCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2ZpbGUuYyBi
L2ZzL3NtYi9jbGllbnQvZmlsZS5jCmluZGV4IGYyZGI0YTFmODFhZC4uYmMzMjBjNTY3ZDYxIDEw
MDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2ZpbGUuYworKysgYi9mcy9zbWIvY2xpZW50L2ZpbGUu
YwpAQCAtNTYyLDcgKzU2Miw3IEBAIGludCBjaWZzX3Bvc2l4X29wZW4oY29uc3QgY2hhciAqZnVs
bF9wYXRoLCBzdHJ1Y3QgaW5vZGUgKipwaW5vZGUsCiAJCX0KIAl9IGVsc2UgewogCQljaWZzX3Jl
dmFsaWRhdGVfbWFwcGluZygqcGlub2RlKTsKLQkJcmMgPSBjaWZzX2ZhdHRyX3RvX2lub2RlKCpw
aW5vZGUsICZmYXR0cik7CisJCXJjID0gY2lmc19mYXR0cl90b19pbm9kZSgqcGlub2RlLCAmZmF0
dHIsIGZhbHNlKTsKIAl9CiAKIHBvc2l4X29wZW5fcmV0OgpAQCAtMjk0NywxMiArMjk0NywxNCBA
QCBzdGF0aWMgaW50IGlzX2lub2RlX3dyaXRhYmxlKHN0cnVjdCBjaWZzSW5vZGVJbmZvICpjaWZz
X2lub2RlKQogICAgcmVmcmVzaGluZyB0aGUgaW5vZGUgb25seSBvbiBpbmNyZWFzZXMgaW4gdGhl
IGZpbGUgc2l6ZQogICAgYnV0IHRoaXMgaXMgdHJpY2t5IHRvIGRvIHdpdGhvdXQgcmFjaW5nIHdp
dGggd3JpdGViZWhpbmQKICAgIHBhZ2UgY2FjaGluZyBpbiB0aGUgY3VycmVudCBMaW51eCBrZXJu
ZWwgZGVzaWduICovCi1ib29sIGlzX3NpemVfc2FmZV90b19jaGFuZ2Uoc3RydWN0IGNpZnNJbm9k
ZUluZm8gKmNpZnNJbm9kZSwgX191NjQgZW5kX29mX2ZpbGUpCitib29sIGlzX3NpemVfc2FmZV90
b19jaGFuZ2Uoc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpZnNJbm9kZSwgX191NjQgZW5kX29mX2Zp
bGUsCisJCQkgICAgYm9vbCBmcm9tX3JlYWRkaXIpCiB7CiAJaWYgKCFjaWZzSW5vZGUpCiAJCXJl
dHVybiB0cnVlOwogCi0JaWYgKGlzX2lub2RlX3dyaXRhYmxlKGNpZnNJbm9kZSkpIHsKKwlpZiAo
aXNfaW5vZGVfd3JpdGFibGUoY2lmc0lub2RlKSB8fAorCQkoKGNpZnNJbm9kZS0+b3Bsb2NrICYg
Q0lGU19DQUNIRV9SV19GTEcpICE9IDAgJiYgZnJvbV9yZWFkZGlyKSkgewogCQkvKiBUaGlzIGlu
b2RlIGlzIG9wZW4gZm9yIHdyaXRlIGF0IGxlYXN0IG9uY2UgKi8KIAkJc3RydWN0IGNpZnNfc2Jf
aW5mbyAqY2lmc19zYjsKIApkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9pbm9kZS5jIGIvZnMv
c21iL2NsaWVudC9pbm9kZS5jCmluZGV4IDdhY2FmNzVmZWFiYy4uZDFkZWE1MzMzOTgxIDEwMDY0
NAotLS0gYS9mcy9zbWIvY2xpZW50L2lub2RlLmMKKysrIGIvZnMvc21iL2NsaWVudC9pbm9kZS5j
CkBAIC0xNjMsNyArMTYzLDggQEAgY2lmc19ubGlua19mYXR0cl90b19pbm9kZShzdHJ1Y3QgaW5v
ZGUgKmlub2RlLCBzdHJ1Y3QgY2lmc19mYXR0ciAqZmF0dHIpCiAKIC8qIHBvcHVsYXRlIGFuIGlu
b2RlIHdpdGggaW5mbyBmcm9tIGEgY2lmc19mYXR0ciBzdHJ1Y3QgKi8KIGludAotY2lmc19mYXR0
cl90b19pbm9kZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgY2lmc19mYXR0ciAqZmF0dHIp
CitjaWZzX2ZhdHRyX3RvX2lub2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBjaWZzX2Zh
dHRyICpmYXR0ciwKKwkJICAgIGJvb2wgZnJvbV9yZWFkZGlyKQogewogCXN0cnVjdCBjaWZzSW5v
ZGVJbmZvICpjaWZzX2kgPSBDSUZTX0koaW5vZGUpOwogCXN0cnVjdCBjaWZzX3NiX2luZm8gKmNp
ZnNfc2IgPSBDSUZTX1NCKGlub2RlLT5pX3NiKTsKQEAgLTIxNSw3ICsyMTYsNyBAQCBjaWZzX2Zh
dHRyX3RvX2lub2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBjaWZzX2ZhdHRyICpmYXR0
cikKIAkgKiBDYW4ndCBzYWZlbHkgY2hhbmdlIHRoZSBmaWxlIHNpemUgaGVyZSBpZiB0aGUgY2xp
ZW50IGlzIHdyaXRpbmcgdG8KIAkgKiBpdCBkdWUgdG8gcG90ZW50aWFsIHJhY2VzLgogCSAqLwot
CWlmIChpc19zaXplX3NhZmVfdG9fY2hhbmdlKGNpZnNfaSwgZmF0dHItPmNmX2VvZikpIHsKKwlp
ZiAoaXNfc2l6ZV9zYWZlX3RvX2NoYW5nZShjaWZzX2ksIGZhdHRyLT5jZl9lb2YsIGZyb21fcmVh
ZGRpcikpIHsKIAkJaV9zaXplX3dyaXRlKGlub2RlLCBmYXR0ci0+Y2ZfZW9mKTsKIAogCQkvKgpA
QCAtMzg2LDcgKzM4Nyw3IEBAIHN0YXRpYyBpbnQgdXBkYXRlX2lub2RlX2luZm8oc3RydWN0IHN1
cGVyX2Jsb2NrICpzYiwKIAkJQ0lGU19JKCppbm9kZSktPnRpbWUgPSAwOyAvKiBmb3JjZSByZXZh
bCAqLwogCQlyZXR1cm4gLUVTVEFMRTsKIAl9Ci0JcmV0dXJuIGNpZnNfZmF0dHJfdG9faW5vZGUo
Kmlub2RlLCBmYXR0cik7CisJcmV0dXJuIGNpZnNfZmF0dHJfdG9faW5vZGUoKmlub2RlLCBmYXR0
ciwgZmFsc2UpOwogfQogCiAjaWZkZWYgQ09ORklHX0NJRlNfQUxMT1dfSU5TRUNVUkVfTEVHQUNZ
CkBAIC00MjEsNyArNDIyLDcgQEAgY2lmc19nZXRfZmlsZV9pbmZvX3VuaXgoc3RydWN0IGZpbGUg
KmZpbHApCiAJfSBlbHNlCiAJCWdvdG8gY2lmc19nZml1bml4X291dDsKIAotCXJjID0gY2lmc19m
YXR0cl90b19pbm9kZShpbm9kZSwgJmZhdHRyKTsKKwlyYyA9IGNpZnNfZmF0dHJfdG9faW5vZGUo
aW5vZGUsICZmYXR0ciwgZmFsc2UpOwogCiBjaWZzX2dmaXVuaXhfb3V0OgogCWZyZWVfeGlkKHhp
ZCk7CkBAIC04NzMsNyArODc0LDcgQEAgY2lmc19nZXRfZmlsZV9pbmZvKHN0cnVjdCBmaWxlICpm
aWxwKQogCWZhdHRyLmNmX3VuaXF1ZWlkID0gQ0lGU19JKGlub2RlKS0+dW5pcXVlaWQ7CiAJZmF0
dHIuY2ZfZmxhZ3MgfD0gQ0lGU19GQVRUUl9ORUVEX1JFVkFMOwogCS8qIGlmIGZpbGV0eXBlIGlz
IGRpZmZlcmVudCwgcmV0dXJuIGVycm9yICovCi0JcmMgPSBjaWZzX2ZhdHRyX3RvX2lub2RlKGlu
b2RlLCAmZmF0dHIpOworCXJjID0gY2lmc19mYXR0cl90b19pbm9kZShpbm9kZSwgJmZhdHRyLCBm
YWxzZSk7CiBjZ2ZpX2V4aXQ6CiAJY2lmc19mcmVlX29wZW5faW5mbygmZGF0YSk7CiAJZnJlZV94
aWQoeGlkKTsKQEAgLTE0MzAsNyArMTQzMSw3IEBAIGNpZnNfaWdldChzdHJ1Y3Qgc3VwZXJfYmxv
Y2sgKnNiLCBzdHJ1Y3QgY2lmc19mYXR0ciAqZmF0dHIpCiAJCX0KIAogCQkvKiBjYW4ndCBmYWls
IC0gc2VlIGNpZnNfZmluZF9pbm9kZSgpICovCi0JCWNpZnNfZmF0dHJfdG9faW5vZGUoaW5vZGUs
IGZhdHRyKTsKKwkJY2lmc19mYXR0cl90b19pbm9kZShpbm9kZSwgZmF0dHIsIGZhbHNlKTsKIAkJ
aWYgKHNiLT5zX2ZsYWdzICYgU0JfTk9BVElNRSkKIAkJCWlub2RlLT5pX2ZsYWdzIHw9IFNfTk9B
VElNRSB8IFNfTk9DTVRJTUU7CiAJCWlmIChpbm9kZS0+aV9zdGF0ZSAmIElfTkVXKSB7CmRpZmYg
LS1naXQgYS9mcy9zbWIvY2xpZW50L3JlYWRkaXIuYyBiL2ZzL3NtYi9jbGllbnQvcmVhZGRpci5j
CmluZGV4IGE4YWVlOTE0OGU4OS4uZWJlMWNiMzBlMThlIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xp
ZW50L3JlYWRkaXIuYworKysgYi9mcy9zbWIvY2xpZW50L3JlYWRkaXIuYwpAQCAtMTM0LDcgKzEz
NCw3IEBAIGNpZnNfcHJpbWVfZGNhY2hlKHN0cnVjdCBkZW50cnkgKnBhcmVudCwgc3RydWN0IHFz
dHIgKm5hbWUsCiAJCQkJCQlyYyA9IC1FU1RBTEU7CiAJCQkJCX0KIAkJCQl9Ci0JCQkJaWYgKCFy
YyAmJiAhY2lmc19mYXR0cl90b19pbm9kZShpbm9kZSwgZmF0dHIpKSB7CisJCQkJaWYgKCFyYyAm
JiAhY2lmc19mYXR0cl90b19pbm9kZShpbm9kZSwgZmF0dHIsIHRydWUpKSB7CiAJCQkJCWRwdXQo
ZGVudHJ5KTsKIAkJCQkJcmV0dXJuOwogCQkJCX0KLS0gCjIuMzQuMQoK
--0000000000002886eb06126e9638--
