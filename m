Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED589BE69
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jan 2024 02:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706063252; cv=none; b=AIfAcrr/fQyUbc0o8sl8GISH8hcMFPuR918l8dbSCMlWz5t0GA8+JVWJ4JI8Dyfk+2KJe0gSQlQls+6+Y7GmTzAparCdLgp9GrH/Rx78sDXTTLoGgjSLKafLVdDlrzDoO0MW/047hJGSkKXbDVscvGdvTos/mESu6KipXHAO/aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706063252; c=relaxed/simple;
	bh=ufKYgzFUsqqEnS/0fNg5DSjd/lqWhf26VUkYLyysnXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IQsD0sckoyu8uen2POHwbMfn6KuIqfAzg8ezGOb1Nj08H6atp3ltnx6mNSyXCQhPhQACYPNkv07IXATWFF4ltSOLbzuMdwPObw+GOg+LT8by4qi0rzRc0fNYr8Q1Y6s9fMNlQachz+QBOrcAflkJn26OYPEM9Qbi1Wp5Ai4v0Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ntHyo93K; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ntHyo93K"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2cf1b770833so8533091fa.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jan 2024 18:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706063249; x=1706668049; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WfaLtMqv6apcd9FKilYM6ZmedFcjx3slahCY0RKctiI=;
        b=ntHyo93KvOzraGGdgzJnmIBdB10cTT+MrM6IpBZTy8QlO/LlAxfddcupMaHP06iNnu
         1AKi3aCJRSAgDx9kstdYo3O4PyBYYg2h8/BIvhfgh+RYCCtRvkiERZWSCWmgvtn4VHmq
         o+pXuddlBFbcn2B8nUcYzfzVGV9Xx6xrphU4yNaPMPyelkff2TCRiPse+ydkmAHnFFfW
         G/k9gr4T5jfuGZhEvi1ysgij1FVmIgTstbkUYYXY/HqaYJP7AgbXFhp6h6KxaZyp9H0G
         4dfYBvTk3Wc2BBYCRn/SbQg1SfZaYo/18nJ7YBD1QMhomxZ6TtdMixv0Fs0IIeufz64W
         +V8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706063249; x=1706668049;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WfaLtMqv6apcd9FKilYM6ZmedFcjx3slahCY0RKctiI=;
        b=CTex+7GqooxjsksuPyrC/uze7jby9u6baQyGYjQFC2/ICR6bjHVNoGkVYiTJKF2RJv
         8qtZ+0zvxUTvk3OtWBqs/+atBdjmkzj0hQjhI4Il7JrxgNdYpfTOBZQ9hi+UrMNhriUR
         xJMWyfmaYXUF4KBCDHzC1b8lmCeEjR1mtcT5c080UZxNF+38InOJaSPtWeQJsXp+j6tF
         gqRa5tPmQdfoKdyytX2KK7KZCli1wBdU1huFdCGfffSruxwrqkXwUnNnpn7Yc12pDbPO
         IGd8T/g70zJkSlFw3vpHz96em0U+RtUMotba6xi+7NRK13epA81jXY6p9F8c9yYLP3E0
         2USg==
X-Gm-Message-State: AOJu0YxV0WMe+T3t4QgzAUVIoJi0I5LNZ7yUpzZs7KThY8VmoXoVpd/9
	wTiyTL0TXEyg61liNl3gtCJcBWUwG+eQVSuLScoendl1ydayE750ReSQBM3nCfUcE/UvV5q95L7
	DiP5PVQZ+vAY6Q/5b/7CNhQ48Cbo=
X-Google-Smtp-Source: AGHT+IGq5zZCZpBCTvqH7bNSvGEXrqvVepGaoLED0MWELJRuhcJ6mz6dgTHaaEjKQ7/kDn0q3JuZfm7VqveQj8XHM/A=
X-Received: by 2002:a05:651c:7a1:b0:2ce:c3f:3aee with SMTP id
 g33-20020a05651c07a100b002ce0c3f3aeemr270991lje.91.1706063248584; Tue, 23 Jan
 2024 18:27:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121033248.125282-1-sprasad@microsoft.com>
 <20240121033248.125282-3-sprasad@microsoft.com> <CANT5p=rn2dd=Wf85Wr9_mikJ5xSrR0O-RwicZbkP5wqwxrrcAQ@mail.gmail.com>
 <CANT5p=ohQiLW0N6Jjzb1aodD9U7w+PaedoZQUpxnHdhyg0+mwQ@mail.gmail.com>
In-Reply-To: <CANT5p=ohQiLW0N6Jjzb1aodD9U7w+PaedoZQUpxnHdhyg0+mwQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 23 Jan 2024 20:27:16 -0600
Message-ID: <CAH2r5mugoi4TRWozAA-AGuPgMP4QGTeiHiMqSQ+F9f0+2MT88Q@mail.gmail.com>
Subject: Re: [PATCH 3/7] cifs: smb2_close_getattr should also update i_size
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	tom@talpey.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000e58898060fa7cd76"

--000000000000e58898060fa7cd76
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This was the patch that was causing test generic/074 to regress so I
took it out of for-next temporarily till we can fix it.  The version
of the patch I was using is attached


On Tue, Jan 23, 2024 at 1:48=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Tue, Jan 23, 2024 at 12:52=E2=80=AFPM Shyam Prasad N <nspmangalore@gma=
il.com> wrote:
> >
> > On Sun, Jan 21, 2024 at 9:03=E2=80=AFAM <nspmangalore@gmail.com> wrote:
> > >
> > > From: Shyam Prasad N <sprasad@microsoft.com>
> > >
> > > SMB2 CLOSE command with SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB
> > > flag set is already used by the code for SMB3+.
> > > smb2_close_getattr is the function that uses this to
> > > update the inode attributes.
> > >
> > > However, we were skipping the EndOfFile info that's returned
> > > by the server. There is a small chance that the file size
> > > may have been changed in the small window between the client
> > > sending the close request (thereby giving up lease if it had)
> > > to the point that the server returns the response.
> > >
> > > This change uses the field to update the inode size.
> > > Also, it is a valid case for a zero AllocationSize to be returned
> > > by the server for the file. We were discarding such values, thereby
> > > resulting in stale i_blocks value. Fixed that here too.
> > >
> > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > ---
> > >  fs/smb/client/smb2ops.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > > index d9553c2556a2..e23577584ed6 100644
> > > --- a/fs/smb/client/smb2ops.c
> > > +++ b/fs/smb/client/smb2ops.c
> > > @@ -1433,9 +1433,9 @@ smb2_close_getattr(const unsigned int xid, stru=
ct cifs_tcon *tcon,
> > >          * but instead 512 byte (2**9) size is required for
> > >          * calculating num blocks.
> > >          */
> > > -       if (le64_to_cpu(file_inf.AllocationSize) > 4096)
> > > -               inode->i_blocks =3D
> > > -                       (512 - 1 + le64_to_cpu(file_inf.AllocationSiz=
e)) >> 9;
> > > +       inode->i_blocks =3D (512 - 1 + le64_to_cpu(file_inf.Allocatio=
nSize)) >> 9;
> > > +
> > > +       inode->i_size =3D le64_to_cpu(file_inf.EndOfFile);
> > >
> > >         /* End of file and Attributes should not have to be updated o=
n close */
> > >         spin_unlock(&inode->i_lock);
> > > --
> > > 2.34.1
> > >
> > Noticed a couple of things in other places in the code:
> > 1. i_size_write() should be called instead of updating i_size directly.
> > 2. There's a server_eof field that is generally maintained in sync
> > with i_size. Need to check how that needs to be done here.
> >
> > I'll submit a v2 of this patch soon.
> >
> > --
> > Regards,
> > Shyam
>
> Attached updated patch.
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve

--000000000000e58898060fa7cd76
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-smb2_close_getattr-should-also-update-i_size.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-smb2_close_getattr-should-also-update-i_size.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lrr6012t0>
X-Attachment-Id: f_lrr6012t0

RnJvbSAzNjY1ZjI5NTYyYTZmZWZlZmQzNmE2MDFkNDc4ODU0YTZiNjcyMjU1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBTdW4sIDIxIEphbiAyMDI0IDAzOjMyOjQ0ICswMDAwClN1YmplY3Q6IFtQQVRDSCAx
LzZdIGNpZnM6IHNtYjJfY2xvc2VfZ2V0YXR0ciBzaG91bGQgYWxzbyB1cGRhdGUgaV9zaXplCgpT
TUIyIENMT1NFIGNvbW1hbmQgd2l0aCBTTUIyX0NMT1NFX0ZMQUdfUE9TVFFVRVJZX0FUVFJJQgpm
bGFnIHNldCBpcyBhbHJlYWR5IHVzZWQgYnkgdGhlIGNvZGUgZm9yIFNNQjMrLgpzbWIyX2Nsb3Nl
X2dldGF0dHIgaXMgdGhlIGZ1bmN0aW9uIHRoYXQgdXNlcyB0aGlzIHRvCnVwZGF0ZSB0aGUgaW5v
ZGUgYXR0cmlidXRlcy4KCkhvd2V2ZXIsIHdlIHdlcmUgc2tpcHBpbmcgdGhlIEVuZE9mRmlsZSBp
bmZvIHRoYXQncyByZXR1cm5lZApieSB0aGUgc2VydmVyLiBUaGVyZSBpcyBhIHNtYWxsIGNoYW5j
ZSB0aGF0IHRoZSBmaWxlIHNpemUKbWF5IGhhdmUgYmVlbiBjaGFuZ2VkIGluIHRoZSBzbWFsbCB3
aW5kb3cgYmV0d2VlbiB0aGUgY2xpZW50CnNlbmRpbmcgdGhlIGNsb3NlIHJlcXVlc3QgKHRoZXJl
YnkgZ2l2aW5nIHVwIGxlYXNlIGlmIGl0IGhhZCkKdG8gdGhlIHBvaW50IHRoYXQgdGhlIHNlcnZl
ciByZXR1cm5zIHRoZSByZXNwb25zZS4KClRoaXMgY2hhbmdlIHVzZXMgdGhlIGZpZWxkIHRvIHVw
ZGF0ZSB0aGUgaW5vZGUgc2l6ZS4KQWxzbywgaXQgaXMgYSB2YWxpZCBjYXNlIGZvciBhIHplcm8g
QWxsb2NhdGlvblNpemUgdG8gYmUgcmV0dXJuZWQKYnkgdGhlIHNlcnZlciBmb3IgdGhlIGZpbGUu
IFdlIHdlcmUgZGlzY2FyZGluZyBzdWNoIHZhbHVlcywgdGhlcmVieQpyZXN1bHRpbmcgaW4gc3Rh
bGUgaV9ibG9ja3MgdmFsdWUuIEZpeGVkIHRoYXQgaGVyZSB0b28uCgpTaWduZWQtb2ZmLWJ5OiBT
aHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgpDYzogc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvc21iL2NsaWVudC9zbWIyb3BzLmMgfCA3ICsrKystLS0KIDEgZmlsZSBjaGFu
Z2VkLCA0IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21i
L2NsaWVudC9zbWIyb3BzLmMgYi9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYwppbmRleCAyN2Y4Y2Fj
Y2ZmN2YuLmVlYmQyYjcyMDk0NSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zbWIyb3BzLmMK
KysrIGIvZnMvc21iL2NsaWVudC9zbWIyb3BzLmMKQEAgLTE0MzMsOSArMTQzMywxMCBAQCBzbWIy
X2Nsb3NlX2dldGF0dHIoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAq
dGNvbiwKIAkgKiBidXQgaW5zdGVhZCA1MTIgYnl0ZSAoMioqOSkgc2l6ZSBpcyByZXF1aXJlZCBm
b3IKIAkgKiBjYWxjdWxhdGluZyBudW0gYmxvY2tzLgogCSAqLwotCWlmIChsZTY0X3RvX2NwdShm
aWxlX2luZi5BbGxvY2F0aW9uU2l6ZSkgPiA0MDk2KQotCQlpbm9kZS0+aV9ibG9ja3MgPQotCQkJ
KDUxMiAtIDEgKyBsZTY0X3RvX2NwdShmaWxlX2luZi5BbGxvY2F0aW9uU2l6ZSkpID4+IDk7CisJ
aW5vZGUtPmlfYmxvY2tzID0gKDUxMiAtIDEgKyBsZTY0X3RvX2NwdShmaWxlX2luZi5BbGxvY2F0
aW9uU2l6ZSkpID4+IDk7CisKKwlDSUZTX0koaW5vZGUpLT5uZXRmcy5yZW1vdGVfaV9zaXplID0g
bGU2NF90b19jcHUoZmlsZV9pbmYuRW5kT2ZGaWxlKTsKKwlpX3NpemVfd3JpdGUoaW5vZGUsIENJ
RlNfSShpbm9kZSktPm5ldGZzLnJlbW90ZV9pX3NpemUpOwogCiAJLyogRW5kIG9mIGZpbGUgYW5k
IEF0dHJpYnV0ZXMgc2hvdWxkIG5vdCBoYXZlIHRvIGJlIHVwZGF0ZWQgb24gY2xvc2UgKi8KIAlz
cGluX3VubG9jaygmaW5vZGUtPmlfbG9jayk7Ci0tIAoyLjQwLjEKCg==
--000000000000e58898060fa7cd76--
