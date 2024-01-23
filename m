Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C647F2AE91
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jan 2024 07:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705996086; cv=none; b=gAhfKRsjoRFsWa4C02hjcrWhe+4TaBaWYm/Ti9+M2q/huzk/l6vdrO+ao1DOK7AaV/iy1/UWjxmTJGZkZ15eR7Swg92jO9B6+Au0cutI8J3GG2F5hY0NBSCbS9PgXZjwvYqLMRZaRR8mxsnhiJzUV7pT4KGw6wZGq4k81Oi0n2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705996086; c=relaxed/simple;
	bh=zppj8RGPNvGgyc7pvbEtrPhp11cY4sQVCKnNilE7H3I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qtxlQJL7KwuiUXnDoo/RVct5KUEGRP4qNZ0/V6zakMD+38ZSywP2r28Ca3IJIEaES458H8tsZz9SmgpFIxy1ORcr7T8WtDoHdrMKZGTIYjR0sUez/k0+v0wkjjKTZcPkjiUlyT3DEfxKJsTawq8A7CueXbgx7iaX8JWml/ihT2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gQf7HTIL; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gQf7HTIL"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-50eaabc36bcso4261626e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 22 Jan 2024 23:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705996082; x=1706600882; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H14MvAfpM7OpQWzIWMYjzcmE9rQrvP2c28AHPgXtrtU=;
        b=gQf7HTILSOhf5wWzvnYdruuB48ir4K+TU+rt9kr6yEHTD3J9a3MO5EuiAGrsCO5PhU
         rJ32kskZ67id23hawSebslQXJCeFcY3FY3svKtnJbEXa7iUhc73RQ+C/LJ0UnxWNf2V1
         54PodN/U/G4yTxmLP4eHRUoiX/MRYjpYaJhddDKq6sjL27zC1gdZ0nwWNPiyU5SphSd8
         CVL3AQ2C4k4vcps4CdHQmLXx0a/rnVhlqcSSy2jt5r8BReh9X5fEvh8QxQit9RcVrYCa
         abjUQS8IHtw+Ix2lqqugdvfd0Sx94gBvPZqpVfoW+LtHaoJF5M56F4NaKIDTywCxQhfl
         xDLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705996082; x=1706600882;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H14MvAfpM7OpQWzIWMYjzcmE9rQrvP2c28AHPgXtrtU=;
        b=GhFoDldWnewWtFrpDrkSLXfDE73DqUHAvAS1c+QykHifEno4Ca6bcBiMtVjHCykvbA
         qUf5IweMUclzYXvrSdI+dYrATTs9momm3Yni8wGLZxn1TFtGluzWkPMwPS4cnd5wwWVk
         qy/kaYsFP/4An6ntpiQ4DmDi6Zf9XRVVXezYrKwESquU2py4zaz9h/SkZeFuHVXwVyGV
         aBWWHJPCyOHjONP4WGjziGM8oKgXbt0+HnEVwl/ZoiqsLQWZkQmoe44HuU1s2fn3zfqx
         b9cWlsTox+tjx87ZPaCYW6/buCO+6EocFtOY5QInujir904KmmsqdTdfs0Rj9+RZFsSG
         PO9g==
X-Gm-Message-State: AOJu0YyWWZD3bqq7cd9CwR8cCuOq/Uws479x1eIx2KryOJ6Iy9pshBFt
	/GwjQSb3P8AKiJDRcy3bVuR8YrD/xBEgNvxo9ZD0r2py3USvzpsvWProqaeAOYiSzKNy8+eo5/v
	gewNhXokl9kOzXQaog6D4YrsNkf6WgH1K
X-Google-Smtp-Source: AGHT+IGtqhmJby+VquSd/gXr2dweaXX4LbuDfKpNHq112GTWiOJpvjfyH/qsdS5mgTh+zzPZT1sOE3/RulUSyZ95r+M=
X-Received: by 2002:ac2:58cb:0:b0:50e:cccb:f5f2 with SMTP id
 u11-20020ac258cb000000b0050ecccbf5f2mr1721354lfo.56.1705996082271; Mon, 22
 Jan 2024 23:48:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121033248.125282-1-sprasad@microsoft.com>
 <20240121033248.125282-3-sprasad@microsoft.com> <CANT5p=rn2dd=Wf85Wr9_mikJ5xSrR0O-RwicZbkP5wqwxrrcAQ@mail.gmail.com>
In-Reply-To: <CANT5p=rn2dd=Wf85Wr9_mikJ5xSrR0O-RwicZbkP5wqwxrrcAQ@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 23 Jan 2024 13:17:50 +0530
Message-ID: <CANT5p=ohQiLW0N6Jjzb1aodD9U7w+PaedoZQUpxnHdhyg0+mwQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] cifs: smb2_close_getattr should also update i_size
To: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	bharathsm@microsoft.com, tom@talpey.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="00000000000078ecbe060f982ab4"

--00000000000078ecbe060f982ab4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 12:52=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail=
.com> wrote:
>
> On Sun, Jan 21, 2024 at 9:03=E2=80=AFAM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > SMB2 CLOSE command with SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB
> > flag set is already used by the code for SMB3+.
> > smb2_close_getattr is the function that uses this to
> > update the inode attributes.
> >
> > However, we were skipping the EndOfFile info that's returned
> > by the server. There is a small chance that the file size
> > may have been changed in the small window between the client
> > sending the close request (thereby giving up lease if it had)
> > to the point that the server returns the response.
> >
> > This change uses the field to update the inode size.
> > Also, it is a valid case for a zero AllocationSize to be returned
> > by the server for the file. We were discarding such values, thereby
> > resulting in stale i_blocks value. Fixed that here too.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/smb2ops.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index d9553c2556a2..e23577584ed6 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -1433,9 +1433,9 @@ smb2_close_getattr(const unsigned int xid, struct=
 cifs_tcon *tcon,
> >          * but instead 512 byte (2**9) size is required for
> >          * calculating num blocks.
> >          */
> > -       if (le64_to_cpu(file_inf.AllocationSize) > 4096)
> > -               inode->i_blocks =3D
> > -                       (512 - 1 + le64_to_cpu(file_inf.AllocationSize)=
) >> 9;
> > +       inode->i_blocks =3D (512 - 1 + le64_to_cpu(file_inf.AllocationS=
ize)) >> 9;
> > +
> > +       inode->i_size =3D le64_to_cpu(file_inf.EndOfFile);
> >
> >         /* End of file and Attributes should not have to be updated on =
close */
> >         spin_unlock(&inode->i_lock);
> > --
> > 2.34.1
> >
> Noticed a couple of things in other places in the code:
> 1. i_size_write() should be called instead of updating i_size directly.
> 2. There's a server_eof field that is generally maintained in sync
> with i_size. Need to check how that needs to be done here.
>
> I'll submit a v2 of this patch soon.
>
> --
> Regards,
> Shyam

Attached updated patch.

--=20
Regards,
Shyam

--00000000000078ecbe060f982ab4
Content-Type: application/octet-stream; 
	name="0001-cifs-smb2_close_getattr-should-also-update-i_size.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-smb2_close_getattr-should-also-update-i_size.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lrq1yplv0>
X-Attachment-Id: f_lrq1yplv0

RnJvbSBlNDcwZGYzOWU1ZWNhNGYyOTQxM2I2MDQyMWMyMDdkNjI1ZmU1YmY3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBTdW4sIDIxIEphbiAyMDI0IDAzOjMyOjQ0ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogc21iMl9jbG9zZV9nZXRhdHRyIHNob3VsZCBhbHNvIHVwZGF0ZSBpX3NpemUKClNNQjIg
Q0xPU0UgY29tbWFuZCB3aXRoIFNNQjJfQ0xPU0VfRkxBR19QT1NUUVVFUllfQVRUUklCCmZsYWcg
c2V0IGlzIGFscmVhZHkgdXNlZCBieSB0aGUgY29kZSBmb3IgU01CMysuCnNtYjJfY2xvc2VfZ2V0
YXR0ciBpcyB0aGUgZnVuY3Rpb24gdGhhdCB1c2VzIHRoaXMgdG8KdXBkYXRlIHRoZSBpbm9kZSBh
dHRyaWJ1dGVzLgoKSG93ZXZlciwgd2Ugd2VyZSBza2lwcGluZyB0aGUgRW5kT2ZGaWxlIGluZm8g
dGhhdCdzIHJldHVybmVkCmJ5IHRoZSBzZXJ2ZXIuIFRoZXJlIGlzIGEgc21hbGwgY2hhbmNlIHRo
YXQgdGhlIGZpbGUgc2l6ZQptYXkgaGF2ZSBiZWVuIGNoYW5nZWQgaW4gdGhlIHNtYWxsIHdpbmRv
dyBiZXR3ZWVuIHRoZSBjbGllbnQKc2VuZGluZyB0aGUgY2xvc2UgcmVxdWVzdCAodGhlcmVieSBn
aXZpbmcgdXAgbGVhc2UgaWYgaXQgaGFkKQp0byB0aGUgcG9pbnQgdGhhdCB0aGUgc2VydmVyIHJl
dHVybnMgdGhlIHJlc3BvbnNlLgoKVGhpcyBjaGFuZ2UgdXNlcyB0aGUgZmllbGQgdG8gdXBkYXRl
IHRoZSBpbm9kZSBzaXplLgpBbHNvLCBpdCBpcyBhIHZhbGlkIGNhc2UgZm9yIGEgemVybyBBbGxv
Y2F0aW9uU2l6ZSB0byBiZSByZXR1cm5lZApieSB0aGUgc2VydmVyIGZvciB0aGUgZmlsZS4gV2Ug
d2VyZSBkaXNjYXJkaW5nIHN1Y2ggdmFsdWVzLCB0aGVyZWJ5CnJlc3VsdGluZyBpbiBzdGFsZSBp
X2Jsb2NrcyB2YWx1ZS4gRml4ZWQgdGhhdCBoZXJlIHRvby4KClNpZ25lZC1vZmYtYnk6IFNoeWFt
IFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jvc29mdC5jb20+CkNjOiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4K
LS0tCiBmcy9zbWIvY2xpZW50L3NtYjJvcHMuYyB8IDcgKysrKy0tLQogMSBmaWxlIGNoYW5nZWQs
IDQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xp
ZW50L3NtYjJvcHMuYyBiL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jCmluZGV4IGQ5NTUzYzI1NTZh
Mi4uY2NiMzQ4ZTk2NmY2IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYworKysg
Yi9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYwpAQCAtMTQzMyw5ICsxNDMzLDEwIEBAIHNtYjJfY2xv
c2VfZ2V0YXR0cihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29u
LAogCSAqIGJ1dCBpbnN0ZWFkIDUxMiBieXRlICgyKio5KSBzaXplIGlzIHJlcXVpcmVkIGZvcgog
CSAqIGNhbGN1bGF0aW5nIG51bSBibG9ja3MuCiAJICovCi0JaWYgKGxlNjRfdG9fY3B1KGZpbGVf
aW5mLkFsbG9jYXRpb25TaXplKSA+IDQwOTYpCi0JCWlub2RlLT5pX2Jsb2NrcyA9Ci0JCQkoNTEy
IC0gMSArIGxlNjRfdG9fY3B1KGZpbGVfaW5mLkFsbG9jYXRpb25TaXplKSkgPj4gOTsKKwlpbm9k
ZS0+aV9ibG9ja3MgPSAoNTEyIC0gMSArIGxlNjRfdG9fY3B1KGZpbGVfaW5mLkFsbG9jYXRpb25T
aXplKSkgPj4gOTsKKworCUNJRlNfSShpbm9kZSktPnNlcnZlcl9lb2YgPSBsZTY0X3RvX2NwdShm
aWxlX2luZi5FbmRPZkZpbGUpOworCWlfc2l6ZV93cml0ZShpbm9kZSwgQ0lGU19JKGlub2RlKS0+
c2VydmVyX2VvZik7CiAKIAkvKiBFbmQgb2YgZmlsZSBhbmQgQXR0cmlidXRlcyBzaG91bGQgbm90
IGhhdmUgdG8gYmUgdXBkYXRlZCBvbiBjbG9zZSAqLwogCXNwaW5fdW5sb2NrKCZpbm9kZS0+aV9s
b2NrKTsKLS0gCjIuMzQuMQoK
--00000000000078ecbe060f982ab4--
