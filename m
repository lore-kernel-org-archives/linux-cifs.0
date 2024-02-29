Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BCF70AEF
	for <linux-cifs@vger.kernel.org>; Thu, 29 Feb 2024 17:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709229200; cv=none; b=u1lWQ4264eSErvPHkq8y2007p2kacRtE6bUZC75lk+8/2dq9bahQCXo2xsgfc2VgM6HPzWrI4e8i/cPvQCqoGJId8jiCegNpW3J6ZBdsZbH5yOprjarmhYOHK8FieH8vgzJYw1OfxCdoHLG72NT2i24ljDH4Htc5b0hbE72cQZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709229200; c=relaxed/simple;
	bh=/BPHxtYZaaqJ8XRKPANd0D/zNBP2cCdoKzrM9R5YhXg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F9qe+Fw1eujQbD17lrV8nQk8mfB2nIvIC28lVcVLsGQzFpaWmRNhjZbBFs1yxccCefuDMUG1qWAQb+z6/AEubk3V4hhmlK+usXQJIq9BXLbIxF33RzwfUZXxtziJN6fH5MV9Xspw8jzZi+H2wrcS3iEJEoAuNCpHw6ruJ6awzO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z8pOHzE6; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z8pOHzE6"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-dcbcea9c261so1361727276.3
        for <linux-cifs@vger.kernel.org>; Thu, 29 Feb 2024 09:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709229197; x=1709833997; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=244W1mFPSKLTBPVofb1cR4wetMUANeuXs55GGhaIjLs=;
        b=Z8pOHzE6fJreuW1780UuxEp/VPV7vxjg5qNTzr3ScE6W+ig9LEsHwa/xF9ST0pl6P9
         9RHBuaj+QVPz95sjdOr7Y0TsY6U9AND1ckrKYbLm/m1fVDHQbAqi1Arq3WkniW/BbGal
         J4L+XDGxIDSYuVkPKr89JMoJPL4S2BXKSn6b5dg9Agzt2JkDjihK/ZNP3NvpMzp0jrWM
         AvA96LHHifbXT50z4nv8nKh8CkFB6a3Moqrw2G4cOSHmcIG2GUUZvEyXXbV0rvcLrakA
         OzcD+uOyoMwC9/Umlo1Pv5brEGVJzIXOnnRfRA61AkDhZwZk2UlKbzHH46YwMQvG3OpA
         v/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709229197; x=1709833997;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=244W1mFPSKLTBPVofb1cR4wetMUANeuXs55GGhaIjLs=;
        b=frnIfw9WGozQI4ATzJ81UFLypRDyAPNj/+32zUN7FjghFid4Xiuygfl2W+iz2AMuJF
         qCVndKyaALx2auMXorBk62M5pxR3Q8VuXwyni/c+ST+0n+j7bSU0JSiuI31UX/qV0LLo
         WJusn4jRJcPT/q5bj16Mr/LiSbNkR7/wuBpB/L4A5FtUIisw2/pbKZGttFGO7fGnix3G
         rhv3qWNbJkEsBvNML3o9YlpG9otCMSJa0nQCt2ZQ7Pzov508lxphBIjtPWPv6ihvFXU/
         wk3hUBAErnOZ2zTu+qz8UlzneOPS7nmXUkHV2qj9w9sL1xG5tlra9JxLsHTVM13EoSIb
         mdXg==
X-Forwarded-Encrypted: i=1; AJvYcCU4IfP0r+2FM4v4ZdOObD2u+nF513BoYDNSzbPlAXzAstk2r+5/Fak8n4cG1e2IEtTYMqV40rDScOiCFeW0PuptWe0ImuCDnnLi/g==
X-Gm-Message-State: AOJu0YxwcOcyoy9sy2C88zyXICjkABNjMHZoMYF9qhtBqvdEFVny8vHP
	tJC4pz3XYKTjdXwf6TCkWPoSEPVMDTntdXORLhchkaS4hIenExaXFJ2OaPIktO0KI6rZRaxYBeY
	VS0378mOM0QO7kLsKXlOimAyImfsz6V/d
X-Google-Smtp-Source: AGHT+IHtz1bYBvzyXz++W+6R8T/h9wHgKpzo8M5vjezx7ZQp3PcwWfiWr8oaTuw3Oty0K4xoiOH4CN8/lWnqnuQ6tXg=
X-Received: by 2002:a25:ed0f:0:b0:dc7:48f8:ce2e with SMTP id
 k15-20020a25ed0f000000b00dc748f8ce2emr2738512ybh.37.1709229197643; Thu, 29
 Feb 2024 09:53:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240226045010.30908-1-bharathsm@microsoft.com>
 <CAH2r5msYJncggqkeNQRceNhcnQ1_BdYiQw9mw7fLogHfm8AySw@mail.gmail.com>
 <CAGypqWzZoQZW4=EK_bCAORMXmw1+bdA7icptFEQCge05rrB14g@mail.gmail.com> <CAGypqWx9JwO5nz-S+Yr8kw3UBsZPk5n0hiwzGa632pm_f1zpWA@mail.gmail.com>
In-Reply-To: <CAGypqWx9JwO5nz-S+Yr8kw3UBsZPk5n0hiwzGa632pm_f1zpWA@mail.gmail.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Thu, 29 Feb 2024 23:23:06 +0530
Message-ID: <CAGypqWx8x=q_srJLp7w1ygn0kgfTD8s_VP3wPyqp6mh3APoO6g@mail.gmail.com>
Subject: Re: [PATCH] cifs: prevent updating file size from server if we have a
 read/write lease
To: Steve French <smfrench@gmail.com>
Cc: pc@cjr.nz, sfrench@samba.org, nspmangalore@gmail.com, tom@talpey.com, 
	linux-cifs@vger.kernel.org, bharathsm@microsoft.com, 
	ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000002a66a1061288ef6c"

--0000000000002a66a1061288ef6c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Attached updated patch.

On Thu, Feb 29, 2024 at 11:22=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.co=
m> wrote:
>
> minor update to resolve conflicts.
> And Cc: stable@vger.kernel.org
>
> On Wed, Feb 28, 2024 at 3:57=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.c=
om> wrote:
> >
> > Attached updated patch to have this fix only for calls from readdir
> > i.e cifs_prime_dcache.
> >
> > On Mon, Feb 26, 2024 at 10:44=E2=80=AFAM Steve French <smfrench@gmail.c=
om> wrote:
> > >
> > > My only worry is that perhaps we should make it more narrow (ie only
> > > when called from readdir ie cifs_prime_dcache()  rather than also
> > > never updating it on query_info calls)
> > >
> > > On Sun, Feb 25, 2024 at 10:50=E2=80=AFPM Bharath SM <bharathsm.hsk@gm=
ail.com> wrote:
> > > >
> > > > In cases of large directories, the readdir operation may span multi=
ple
> > > > round trips to retrieve contents. This introduces a potential race
> > > > condition in case of concurrent write and readdir operations. If th=
e
> > > > readdir operation initiates before a write has been processed by th=
e
> > > > server, it may update the file size attribute to an older value.
> > > > Address this issue by avoiding file size updates from server when a
> > > > read/write lease.
> > > >
> > > > Scenario:
> > > > 1) process1: open dir xyz
> > > > 2) process1: readdir instance 1 on xyz
> > > > 3) process2: create file.txt for write
> > > > 4) process2: write x bytes to file.txt
> > > > 5) process2: close file.txt
> > > > 6) process2: open file.txt for read
> > > > 7) process1: readdir 2 - overwrites file.txt inode size to 0
> > > > 8) process2: read contents of file.txt - bug, short read with 0 byt=
es
> > > >
> > > > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > > > ---
> > > >  fs/smb/client/file.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> > > > index f2db4a1f81ad..e742d0d0e579 100644
> > > > --- a/fs/smb/client/file.c
> > > > +++ b/fs/smb/client/file.c
> > > > @@ -2952,7 +2952,8 @@ bool is_size_safe_to_change(struct cifsInodeI=
nfo *cifsInode, __u64 end_of_file)
> > > >         if (!cifsInode)
> > > >                 return true;
> > > >
> > > > -       if (is_inode_writable(cifsInode)) {
> > > > +       if (is_inode_writable(cifsInode) ||
> > > > +                       ((cifsInode->oplock & CIFS_CACHE_RW_FLG) !=
=3D 0)) {
> > > >                 /* This inode is open for write at least once */
> > > >                 struct cifs_sb_info *cifs_sb;
> > > >
> > > > --
> > > > 2.34.1
> > > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve

--0000000000002a66a1061288ef6c
Content-Type: application/octet-stream; 
	name="0001-cifs-prevent-updating-file-size-from-server-if-we-ha.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-prevent-updating-file-size-from-server-if-we-ha.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lt7iwkdv0>
X-Attachment-Id: f_lt7iwkdv0

RnJvbSA1NDc0ZGM1NjZlYjBhOTBmMWVlYWZmODAxZWZlNmRjNTcxNmIwNDE3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4K
RGF0ZTogVGh1LCAyOSBGZWIgMjAyNCAyMzowOTo1MiArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNp
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
ZXMKCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IEJoYXJhdGggU00g
PGJoYXJhdGhzbUBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvY2lmc3Byb3RvLmgg
fCAgNiArKysrLS0KIGZzL3NtYi9jbGllbnQvZmlsZS5jICAgICAgfCAgOCArKysrKy0tLQogZnMv
c21iL2NsaWVudC9pbm9kZS5jICAgICB8IDEzICsrKysrKystLS0tLS0KIGZzL3NtYi9jbGllbnQv
cmVhZGRpci5jICAgfCAgMiArLQogNCBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAx
MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2NpZnNwcm90by5oIGIv
ZnMvc21iL2NsaWVudC9jaWZzcHJvdG8uaAppbmRleCBhODQxYmY0OTY3ZmEuLjU4Y2ZiZDQ1MGE1
NSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jaWZzcHJvdG8uaAorKysgYi9mcy9zbWIvY2xp
ZW50L2NpZnNwcm90by5oCkBAIC0xNDQsNyArMTQ0LDggQEAgZXh0ZXJuIGludCBjaWZzX3JlY29u
bmVjdChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCiBleHRlcm4gaW50IGNoZWNrU01C
KGNoYXIgKmJ1ZiwgdW5zaWduZWQgaW50IGxlbiwgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc3J2
cik7CiBleHRlcm4gYm9vbCBpc192YWxpZF9vcGxvY2tfYnJlYWsoY2hhciAqLCBzdHJ1Y3QgVENQ
X1NlcnZlcl9JbmZvICopOwogZXh0ZXJuIGJvb2wgYmFja3VwX2NyZWQoc3RydWN0IGNpZnNfc2Jf
aW5mbyAqKTsKLWV4dGVybiBib29sIGlzX3NpemVfc2FmZV90b19jaGFuZ2Uoc3RydWN0IGNpZnNJ
bm9kZUluZm8gKiwgX191NjQgZW9mKTsKK2V4dGVybiBib29sIGlzX3NpemVfc2FmZV90b19jaGFu
Z2Uoc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpZnNJbm9kZSwgX191NjQgZW9mLAorCQkJCSAgIGJv
b2wgZnJvbV9yZWFkZGlyKTsKIGV4dGVybiB2b2lkIGNpZnNfdXBkYXRlX2VvZihzdHJ1Y3QgY2lm
c0lub2RlSW5mbyAqY2lmc2ksIGxvZmZfdCBvZmZzZXQsCiAJCQkgICAgdW5zaWduZWQgaW50IGJ5
dGVzX3dyaXR0ZW4pOwogZXh0ZXJuIHN0cnVjdCBjaWZzRmlsZUluZm8gKmZpbmRfd3JpdGFibGVf
ZmlsZShzdHJ1Y3QgY2lmc0lub2RlSW5mbyAqLCBpbnQpOwpAQCAtMjAxLDcgKzIwMiw4IEBAIGV4
dGVybiB2b2lkIGNpZnNfdW5peF9iYXNpY190b19mYXR0cihzdHJ1Y3QgY2lmc19mYXR0ciAqZmF0
dHIsCiAJCQkJICAgICBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiKTsKIGV4dGVybiB2b2lk
IGNpZnNfZGlyX2luZm9fdG9fZmF0dHIoc3RydWN0IGNpZnNfZmF0dHIgKiwgRklMRV9ESVJFQ1RP
UllfSU5GTyAqLAogCQkJCQlzdHJ1Y3QgY2lmc19zYl9pbmZvICopOwotZXh0ZXJuIGludCBjaWZz
X2ZhdHRyX3RvX2lub2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBjaWZzX2ZhdHRyICpm
YXR0cik7CitleHRlcm4gaW50IGNpZnNfZmF0dHJfdG9faW5vZGUoc3RydWN0IGlub2RlICppbm9k
ZSwgc3RydWN0IGNpZnNfZmF0dHIgKmZhdHRyLAorCQkJICAgICAgIGJvb2wgZnJvbV9yZWFkZGly
KTsKIGV4dGVybiBzdHJ1Y3QgaW5vZGUgKmNpZnNfaWdldChzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNi
LAogCQkJICAgICAgIHN0cnVjdCBjaWZzX2ZhdHRyICpmYXR0cik7CiAKZGlmZiAtLWdpdCBhL2Zz
L3NtYi9jbGllbnQvZmlsZS5jIGIvZnMvc21iL2NsaWVudC9maWxlLmMKaW5kZXggZjM5MWM5Yjgw
M2Q4Li45Y2ZmNWY3ZGMwNjIgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvZmlsZS5jCisrKyBi
L2ZzL3NtYi9jbGllbnQvZmlsZS5jCkBAIC0zMjksNyArMzI5LDcgQEAgaW50IGNpZnNfcG9zaXhf
b3Blbihjb25zdCBjaGFyICpmdWxsX3BhdGgsIHN0cnVjdCBpbm9kZSAqKnBpbm9kZSwKIAkJfQog
CX0gZWxzZSB7CiAJCWNpZnNfcmV2YWxpZGF0ZV9tYXBwaW5nKCpwaW5vZGUpOwotCQlyYyA9IGNp
ZnNfZmF0dHJfdG9faW5vZGUoKnBpbm9kZSwgJmZhdHRyKTsKKwkJcmMgPSBjaWZzX2ZhdHRyX3Rv
X2lub2RlKCpwaW5vZGUsICZmYXR0ciwgZmFsc2UpOwogCX0KIAogcG9zaXhfb3Blbl9yZXQ6CkBA
IC00NzM4LDEyICs0NzM4LDE0IEBAIHN0YXRpYyBpbnQgaXNfaW5vZGVfd3JpdGFibGUoc3RydWN0
IGNpZnNJbm9kZUluZm8gKmNpZnNfaW5vZGUpCiAgICByZWZyZXNoaW5nIHRoZSBpbm9kZSBvbmx5
IG9uIGluY3JlYXNlcyBpbiB0aGUgZmlsZSBzaXplCiAgICBidXQgdGhpcyBpcyB0cmlja3kgdG8g
ZG8gd2l0aG91dCByYWNpbmcgd2l0aCB3cml0ZWJlaGluZAogICAgcGFnZSBjYWNoaW5nIGluIHRo
ZSBjdXJyZW50IExpbnV4IGtlcm5lbCBkZXNpZ24gKi8KLWJvb2wgaXNfc2l6ZV9zYWZlX3RvX2No
YW5nZShzdHJ1Y3QgY2lmc0lub2RlSW5mbyAqY2lmc0lub2RlLCBfX3U2NCBlbmRfb2ZfZmlsZSkK
K2Jvb2wgaXNfc2l6ZV9zYWZlX3RvX2NoYW5nZShzdHJ1Y3QgY2lmc0lub2RlSW5mbyAqY2lmc0lu
b2RlLCBfX3U2NCBlbmRfb2ZfZmlsZSwKKwkJCSAgICBib29sIGZyb21fcmVhZGRpcikKIHsKIAlp
ZiAoIWNpZnNJbm9kZSkKIAkJcmV0dXJuIHRydWU7CiAKLQlpZiAoaXNfaW5vZGVfd3JpdGFibGUo
Y2lmc0lub2RlKSkgeworCWlmIChpc19pbm9kZV93cml0YWJsZShjaWZzSW5vZGUpIHx8CisJCSgo
Y2lmc0lub2RlLT5vcGxvY2sgJiBDSUZTX0NBQ0hFX1JXX0ZMRykgIT0gMCAmJiBmcm9tX3JlYWRk
aXIpKSB7CiAJCS8qIFRoaXMgaW5vZGUgaXMgb3BlbiBmb3Igd3JpdGUgYXQgbGVhc3Qgb25jZSAq
LwogCQlzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiOwogCmRpZmYgLS1naXQgYS9mcy9zbWIv
Y2xpZW50L2lub2RlLmMgYi9mcy9zbWIvY2xpZW50L2lub2RlLmMKaW5kZXggZDAyZjhiYTI5Y2I1
Li43ZjI4ZWRmNGIyMGYgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvaW5vZGUuYworKysgYi9m
cy9zbWIvY2xpZW50L2lub2RlLmMKQEAgLTE0Nyw3ICsxNDcsOCBAQCBjaWZzX25saW5rX2ZhdHRy
X3RvX2lub2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBjaWZzX2ZhdHRyICpmYXR0cikK
IAogLyogcG9wdWxhdGUgYW4gaW5vZGUgd2l0aCBpbmZvIGZyb20gYSBjaWZzX2ZhdHRyIHN0cnVj
dCAqLwogaW50Ci1jaWZzX2ZhdHRyX3RvX2lub2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVj
dCBjaWZzX2ZhdHRyICpmYXR0cikKK2NpZnNfZmF0dHJfdG9faW5vZGUoc3RydWN0IGlub2RlICpp
bm9kZSwgc3RydWN0IGNpZnNfZmF0dHIgKmZhdHRyLAorCQkgICAgYm9vbCBmcm9tX3JlYWRkaXIp
CiB7CiAJc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpZnNfaSA9IENJRlNfSShpbm9kZSk7CiAJc3Ry
dWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiA9IENJRlNfU0IoaW5vZGUtPmlfc2IpOwpAQCAtMTk5
LDcgKzIwMCw3IEBAIGNpZnNfZmF0dHJfdG9faW5vZGUoc3RydWN0IGlub2RlICppbm9kZSwgc3Ry
dWN0IGNpZnNfZmF0dHIgKmZhdHRyKQogCSAqIENhbid0IHNhZmVseSBjaGFuZ2UgdGhlIGZpbGUg
c2l6ZSBoZXJlIGlmIHRoZSBjbGllbnQgaXMgd3JpdGluZyB0bwogCSAqIGl0IGR1ZSB0byBwb3Rl
bnRpYWwgcmFjZXMuCiAJICovCi0JaWYgKGlzX3NpemVfc2FmZV90b19jaGFuZ2UoY2lmc19pLCBm
YXR0ci0+Y2ZfZW9mKSkgeworCWlmIChpc19zaXplX3NhZmVfdG9fY2hhbmdlKGNpZnNfaSwgZmF0
dHItPmNmX2VvZiwgZnJvbV9yZWFkZGlyKSkgewogCQlpX3NpemVfd3JpdGUoaW5vZGUsIGZhdHRy
LT5jZl9lb2YpOwogCiAJCS8qCkBAIC0zNjgsNyArMzY5LDcgQEAgc3RhdGljIGludCB1cGRhdGVf
aW5vZGVfaW5mbyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLAogCQlDSUZTX0koKmlub2RlKS0+dGlt
ZSA9IDA7IC8qIGZvcmNlIHJldmFsICovCiAJCXJldHVybiAtRVNUQUxFOwogCX0KLQlyZXR1cm4g
Y2lmc19mYXR0cl90b19pbm9kZSgqaW5vZGUsIGZhdHRyKTsKKwlyZXR1cm4gY2lmc19mYXR0cl90
b19pbm9kZSgqaW5vZGUsIGZhdHRyLCBmYWxzZSk7CiB9CiAKICNpZmRlZiBDT05GSUdfQ0lGU19B
TExPV19JTlNFQ1VSRV9MRUdBQ1kKQEAgLTQwMyw3ICs0MDQsNyBAQCBjaWZzX2dldF9maWxlX2lu
Zm9fdW5peChzdHJ1Y3QgZmlsZSAqZmlscCkKIAl9IGVsc2UKIAkJZ290byBjaWZzX2dmaXVuaXhf
b3V0OwogCi0JcmMgPSBjaWZzX2ZhdHRyX3RvX2lub2RlKGlub2RlLCAmZmF0dHIpOworCXJjID0g
Y2lmc19mYXR0cl90b19pbm9kZShpbm9kZSwgJmZhdHRyLCBmYWxzZSk7CiAKIGNpZnNfZ2ZpdW5p
eF9vdXQ6CiAJZnJlZV94aWQoeGlkKTsKQEAgLTkzNCw3ICs5MzUsNyBAQCBjaWZzX2dldF9maWxl
X2luZm8oc3RydWN0IGZpbGUgKmZpbHApCiAJZmF0dHIuY2ZfdW5pcXVlaWQgPSBDSUZTX0koaW5v
ZGUpLT51bmlxdWVpZDsKIAlmYXR0ci5jZl9mbGFncyB8PSBDSUZTX0ZBVFRSX05FRURfUkVWQUw7
CiAJLyogaWYgZmlsZXR5cGUgaXMgZGlmZmVyZW50LCByZXR1cm4gZXJyb3IgKi8KLQlyYyA9IGNp
ZnNfZmF0dHJfdG9faW5vZGUoaW5vZGUsICZmYXR0cik7CisJcmMgPSBjaWZzX2ZhdHRyX3RvX2lu
b2RlKGlub2RlLCAmZmF0dHIsIGZhbHNlKTsKIGNnZmlfZXhpdDoKIAljaWZzX2ZyZWVfb3Blbl9p
bmZvKCZkYXRhKTsKIAlmcmVlX3hpZCh4aWQpOwpAQCAtMTQ5MSw3ICsxNDkyLDcgQEAgY2lmc19p
Z2V0KHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBjaWZzX2ZhdHRyICpmYXR0cikKIAkJ
fQogCiAJCS8qIGNhbid0IGZhaWwgLSBzZWUgY2lmc19maW5kX2lub2RlKCkgKi8KLQkJY2lmc19m
YXR0cl90b19pbm9kZShpbm9kZSwgZmF0dHIpOworCQljaWZzX2ZhdHRyX3RvX2lub2RlKGlub2Rl
LCBmYXR0ciwgZmFsc2UpOwogCQlpZiAoc2ItPnNfZmxhZ3MgJiBTQl9OT0FUSU1FKQogCQkJaW5v
ZGUtPmlfZmxhZ3MgfD0gU19OT0FUSU1FIHwgU19OT0NNVElNRTsKIAkJaWYgKGlub2RlLT5pX3N0
YXRlICYgSV9ORVcpIHsKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvcmVhZGRpci5jIGIvZnMv
c21iL2NsaWVudC9yZWFkZGlyLmMKaW5kZXggYjUyMGVlYTdiZmNlLi4xMzJhZTdkODg0YTkgMTAw
NjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvcmVhZGRpci5jCisrKyBiL2ZzL3NtYi9jbGllbnQvcmVh
ZGRpci5jCkBAIC0xNDgsNyArMTQ4LDcgQEAgY2lmc19wcmltZV9kY2FjaGUoc3RydWN0IGRlbnRy
eSAqcGFyZW50LCBzdHJ1Y3QgcXN0ciAqbmFtZSwKIAkJCQkJCXJjID0gLUVTVEFMRTsKIAkJCQkJ
fQogCQkJCX0KLQkJCQlpZiAoIXJjICYmICFjaWZzX2ZhdHRyX3RvX2lub2RlKGlub2RlLCBmYXR0
cikpIHsKKwkJCQlpZiAoIXJjICYmICFjaWZzX2ZhdHRyX3RvX2lub2RlKGlub2RlLCBmYXR0ciwg
dHJ1ZSkpIHsKIAkJCQkJZHB1dChkZW50cnkpOwogCQkJCQlyZXR1cm47CiAJCQkJfQotLSAKMi4z
NC4xCgo=
--0000000000002a66a1061288ef6c--
