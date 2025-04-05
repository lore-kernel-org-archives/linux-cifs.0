Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E678F64
	for <linux-cifs@vger.kernel.org>; Sat,  5 Apr 2025 21:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743889380; cv=none; b=IyaH6JQIGr2x/vT/56xcdGhRgZF3MAJ+gyjotsEaX/kyXzSvCchwAvWJeHGVJf2nDdAaRawsTZj0lYFXrnzau7W1jxdpEBW+ep3rsH0sUoMhKj0/zni3YdXVj8pi/b+7MxG1h607VLJsEc4RdDfC9gBZTIwBGEpZ7kMZ4pjtltM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743889380; c=relaxed/simple;
	bh=FgnHFQahc509ueh4A7Bh5NoOwF3Vkgavyzs3MN6+5KI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iO+chTk+9kjSq7Ht/s6hKKCGK+tNZm4pQTvTIYrU9PeMdPFuFnnCblvEszHrM7LOqEodCpr/ASW8MajlkLFPXxQfI7mYWxYCVmtcCcURXFxw/VuLrhv9VuabyYi4ViylU3ewoccRDaZICxF7W+Mia4GcCQ8Q1CheGGD/CL923FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MJusavDs; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MJusavDs"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-30bf1d48843so27509541fa.2
        for <linux-cifs@vger.kernel.org>; Sat, 05 Apr 2025 14:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743889376; x=1744494176; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=So9Is6ILrbdWFQUFqNQkV9su3TrSFA4oPKk1+22kua8=;
        b=MJusavDs1vPlUHp91wEhW3fSVRi2ruAQ387S1j/iWmPyeQG7eHfiF27anQqRbSNQEQ
         ew271EY4iIIama7+LIOQ65Aw7IyjJg17vcXdCUJYy3VL/XGvncS1v7XGic5fczUGDhR3
         Hm3i8BBFtLSeMyOHlL5/o0cZ7NC3/q9XE9eV6Sej9E8iffIQYL1H0d57TyLqBzBELh7F
         xT5n3YI0L4CM+ouz+bUrm0JE2HlzAbbFt2djMz0qEhCDfNvCNfF0mwjcOsDwMQx1XWSX
         nioQxyW+2HZYpUetIgpafEFNF6o3X2oyTR9uHDjFHEQEPt022AJgl9F9tvUO5sl+jQJh
         lc0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743889376; x=1744494176;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=So9Is6ILrbdWFQUFqNQkV9su3TrSFA4oPKk1+22kua8=;
        b=FGS4c42i0aexXm1MJS5ZC7nqSYE4JHh9hHxgfR8iJ/mwwEJ+0wXwWOYAsPJ6zDq5fP
         e5b0uRXyPgIfybfb9XIDLb1YANIl2dSYDeapd8BlBmQHLPGS2tcF4ntjKhvJnT7TANrf
         1xE3v6e0rZmKRgnuOzL/5S0ELtkBOQZYNHNESFaQDtqHW7d9y4g4hkrJHVv5s8eqvvCk
         Il/bL4px5fMtIDXuKouP4O9Ujo0NC5dta3rIpywp5M4iiTsOegz4P/yQHiCAvfNp/S9/
         sZWDg1JgK4mpAvJwq6bS8B0OHz9gdbFzXKGpRjhlwgPKtijW0Z7Kupdb4+JCmSQD3y09
         0e4A==
X-Forwarded-Encrypted: i=1; AJvYcCVvZzDsfFrYNPVaY5XZJzppzercyxeaO3OzkL1FGxhA29+O2l3M9da0pQPVzNNGWyINttsr7l4eGRFT@vger.kernel.org
X-Gm-Message-State: AOJu0YwkmpJ4mjATkSiWTfNs7Vm54SaT2jawYbsBHiPwvd5Przf/lWtA
	IDbCY4zpjla2fPyB16wGe52VzcnDhqGVwogWxmgxd56tGELSMl1Xm4aPhQ/UfrMup1jQfx/eF2Y
	eZAzfYQawgaQGmQf2YHFscAGyvj0=
X-Gm-Gg: ASbGncvUAMGrb1POVaXwZU2NMoqldGHzqgLXkeE3HybT4nsiw39dtOKh+n/FDfgP7VD
	+EcVWc+lurN1FCCQ4sqHJOAcrNScJjpUVy8t/Xjazrb9PjkivQij6xD4M5H31KG5bqsj/x3vLel
	zDMTYGVqTMSnrHM6/0UkX7kYEVO7av3Z96rOB3TnfJGcplowZbiMmVUSDLBddE
X-Google-Smtp-Source: AGHT+IEJ0VJ3Y7UBL0sdL3wuH24mVdOCQo0qTUSuFgCFX6YAWwh27CJ/+AtxuQ0/LB6+m51ybMbBHrPFSzQOIT/nHms=
X-Received: by 2002:a05:651c:30cb:b0:30b:cd41:89c7 with SMTP id
 38308e7fff4ca-30f0bf4fcbbmr22065401fa.22.1743889375701; Sat, 05 Apr 2025
 14:42:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJXSQBms+s2Whk7SfugzQ1kby-xyJ62aVLVvM05rPtFAo7247Q@mail.gmail.com>
 <CAH2r5ms2=o4baY-6_aLmHpJhBYwvaWXUKwZufKs-iT3vsEg_hA@mail.gmail.com>
 <20250405172030.4ptuwa73nnqhkzdy@pali> <CAH2r5mtFPSe7ccQjVdaoL+OCBP8Dya9s8wjSyd1aQtstQnX7dA@mail.gmail.com>
 <20250405195923.aieo7ad2g3kynudr@pali>
In-Reply-To: <20250405195923.aieo7ad2g3kynudr@pali>
From: Steve French <smfrench@gmail.com>
Date: Sat, 5 Apr 2025 16:42:43 -0500
X-Gm-Features: ATxdqUH-WzUmL4KhLwgloDfAkjcEhPpwO7vBPj6_fMKn3tW1UiABJ_pwh9DO18U
Message-ID: <CAH2r5msWXanWt7VvpiagZ-ekOdX=xRo=3O0kkOnunXN4rGzyJA@mail.gmail.com>
Subject: Re: Issue with kernel 6.8.0-40-generic?
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Junwen Sun <sunjw8888@gmail.com>, 1marc1@gmail.com, linux-cifs@vger.kernel.org, 
	pc@manguebit.com, profnandaa@gmail.com, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000c453df06320ee2fe"

--000000000000c453df06320ee2fe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Lightly updated version of Pali's patch description, merged into
cifs-2.6.git pending more review and testing.

Junwen,
Let me know if you see any problems.  I have tested it but the more
testing the better


On Sat, Apr 5, 2025 at 2:59=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> Steve, thank you for testing. I will do some other my own tests too.
>
> For explanation, the function parse_reparse_point() is called by
> reparse_info_to_fattr() and then return value from
> reparse_info_to_fattr() is checked against -EOPNOTSUPP for handling name
> surrogate reparse points. This logic was added in the commit
> b587fd128660 ("cifs: Treat unhandled directory name surrogate reparse
> points as mount directory nodes").
>
> So this code in reparse_info_to_fattr() requires to know if the reparse
> point was handled by the parse_reparse_point() function or not. Hence
> reverting commit cad3fc0a4c8c ("cifs: Throw -EOPNOTSUPP error on
> unsupported reparse point type from parse_reparse_point()") would cause
> that the above logic stop working.
>
> To fix both problems, the one reported by Junwen about unsupported
> OneDrive reparse point, and the name surrogate reparse points, I'm
> proposing in my change to "mask" the -EOPNOTSUPP not in the called
> parse_reparse_point() function but instead in the caller
> reparse_info_to_fattr().
>
> During writing b587fd128660 and cad3fc0a4c8c I somehow forgot about the
> case which cause this issue.
>
> Linux SMB client should not filter out unknown/unhandled reparse points.
> Reparse points are processed by the SMB server (with few exceptions for
> UNIX special files).
>
> In the attachment I'm sending the patch, now with the commit message and
> Fixes lines.
>
> On Saturday 05 April 2025 14:30:22 Steve French wrote:
> > This was easy to reproduce on mainline for me as well (and presumably
> > the same on 6.12 and 6.13 since it has been picked up by stable, and
> > even looks it has been picked up in 6.6. stable) by simply mounting a
> > Windows share that was exporting a onedrive directory.
> >
> > Pali,
> > I did verify that your suggested fix worked for my experiment
> > (exporting onedrive dir as share).   Could you give more specific
> > examples of
> >
> >       'Reverting "cifs: Throw -EOPNOTSUPP error on unsupported reparse
> > point type from parse_reparse_point()" would
> >       break processing of the name-surrogate reparse points.
> >
> > ie some repro examples that Junwen etc. could try
> >
> > Welcome any other Tested-by/Reviewed-by/Acked-by for the two
> > alternatives - reverting the patch, vs. Pali's workaround
> >
> >
> > On Sat, Apr 5, 2025 at 12:20=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.or=
g> wrote:
> > >
> > > Hello Junwen,
> > >
> > > Could you please provide me more details about your issue? What exact
> > > kernel version is affected and what error message you see? Because in
> > > email subject is version 6.8 and in description is 6.12, so I quite
> > > confused.
> > >
> > > I will look at this issue, just I need all detailed information.
> > > It looks like that the error handling is missing some case there.
> > >
> > > Thanks
> > >
> > > Pali
> > >
> > > On Saturday 05 April 2025 12:16:27 Steve French wrote:
> > > > Good catch - it does look like a regression introduced by:
> > > >
> > > >         cad3fc0a4c8c ("cifs: Throw -EOPNOTSUPP error on unsupported
> > > > reparse point type from parse_reparse_point()")
> > > >
> > > > The "unhandled reparse tag: 0x9000701a" looks like (based on MS-FSC=
C
> > > > document) refers to
> > > >
> > > >     "IO_REPARSE_TAG_CLOUD_7   0x9000701A  Used by the Cloud Files
> > > > filter, for files managed by a sync engine such as OneDrive"
> > > >
> > > > Will need to revert that as it looks like there are multiple repars=
e
> > > > tags that it will break not just the onedrive one above
> > > >
> > > >
> > > > On Fri, Apr 4, 2025 at 10:24=E2=80=AFPM Junwen Sun <sunjw8888@gmail=
.com> wrote:
> > > > >
> > > > > Dear all,
> > > > >
> > > > > This is my first time submit an issue about kernel, if I am doing=
 this
> > > > > wrong, please correct me.
> > > > >
> > > > > I'm using Debian testing amd64 as a home server. Recently, it upd=
ated
> > > > > to linux-image-6.12.20-amd64 and I found that it couldn't mount
> > > > > OneDrive shared folder using cifs. If I boot the system with 6.12=
.19,
> > > > > then there is no such problem.
> > > > >
> > > > > It just likes the issue Marc encountered in this thread. And the =
issue
> > > > > was fixed by commit 'ec686804117a0421cf31d54427768aaf93aa0069'. S=
o,
> > > > > I've done some research and found that in 6.12.20, there is a new
> > > > > commit 'fef9d44b24be9b6e3350b1ac47ff266bd9808246' in cifs which a=
lmost
> > > > > revert the commit 'ec686804117a0421cf31d54427768aaf93aa0069'. I g=
uess
> > > > > it brings the same issue back to 6.12.20.
> > > > >
> > > > > Thanks very much in advance if someone can have a look into this =
issue again.
> > > > >
> > > > > =E5=AD=99=E5=B3=BB=E6=96=87
> > > > > Sun Junwen
> > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve

--000000000000c453df06320ee2fe
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0001-cifs-Ensure-that-all-non-client-specific-reparse-poi.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Ensure-that-all-non-client-specific-reparse-poi.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m94qp6g90>
X-Attachment-Id: f_m94qp6g90

RnJvbSA0OTY2ZjY3NWM4NjAxN2U1YzAzYzdkZjBkODBmYWQzNWFjMzM1YjUxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UGFsaT0yMFJvaD1DMz1BMXI/PSA8cGFsaUBr
ZXJuZWwub3JnPgpEYXRlOiBTYXQsIDUgQXByIDIwMjUgMTk6NTE6MDcgKzAyMDAKU3ViamVjdDog
W1BBVENIXSBjaWZzOiBFbnN1cmUgdGhhdCBhbGwgbm9uLWNsaWVudC1zcGVjaWZpYyByZXBhcnNl
IHBvaW50cyBhcmUKIHByb2Nlc3NlZCBieSB0aGUgc2VydmVyCk1JTUUtVmVyc2lvbjogMS4wCkNv
bnRlbnQtVHlwZTogdGV4dC9wbGFpbjsgY2hhcnNldD1VVEYtOApDb250ZW50LVRyYW5zZmVyLUVu
Y29kaW5nOiA4Yml0CgpGaXggcmVncmVzc2lvbiBpbiBtb3VudHMgdG8gZS5nLiBvbmVkcml2ZSBz
aGFyZXMuCgpHZW5lcmFsbHksIHJlcGFyc2UgcG9pbnRzIGFyZSBwcm9jZXNzZWQgYnkgdGhlIFNN
QiBzZXJ2ZXIgZHVyaW5nIHRoZQpTTUIgT1BFTiByZXF1ZXN0LCBidXQgdGhlcmUgYXJlIGZldyBy
ZXBhcnNlIHBvaW50cyB3aGljaCBkbyBub3QgaGF2ZQpPUEVOLWxpa2UgbWVhbmluZyBmb3IgdGhl
IFNNQiBzZXJ2ZXIgYW5kIGhhcyB0byBiZSBwcm9jZXNzZWQgYnkgdGhlIFNNQgpjbGllbnQuIFRo
b3NlIGFyZSBzeW1saW5rcyBhbmQgc3BlY2lhbCBmaWxlcyAoZmlmbywgc29ja2V0LCBibG9jaywg
Y2hhcikuCgpGb3IgTGludXggU01CIGNsaWVudCwgaXQgaXMgcmVxdWlyZWQgdG8gcHJvY2VzcyBh
bHNvIG5hbWUgc3Vycm9nYXRlIHJlcGFyc2UKcG9pbnRzIGFzIHRoZXkgcmVwcmVzZW50IGFub3Ro
ZXIgZW50aXR5IG9uIHRoZSBTTUIgc2VydmVyIHN5c3RlbS4gTGludXgKY2xpZW50IHdpbGwgbWFy
ayB0aGVtIGFzIHNlcGFyYXRlIG1vdW50IHBvaW50cy4gRXhhbXBsZXMgb2YgbmFtZSBzdXJyb2dh
dGUKcmVwYXJzZSBwb2ludHMgYXJlIE5URlMganVuY3Rpb24gcG9pbnRzIChlLmcuIGNyZWF0ZWQg
YnkgdGhlICJta2xpbmsiIHRvb2wKb24gV2luZG93cyBzZXJ2ZXJzKS4KClNvIGFmdGVyIHByb2Nl
c3NpbmcgdGhlIG5hbWUgc3Vycm9nYXRlIHJlcGFyc2UgcG9pbnRzLCBjbGVhciB0aGUKLUVPUE5P
VFNVUFAgZXJyb3IgY29kZSByZXR1cm5lZCBmcm9tIHRoZSBwYXJzZV9yZXBhcnNlX3BvaW50KCkg
dG8gbGV0IFNNQgpzZXJ2ZXIgdG8gcHJvY2VzcyByZXBhcnNlIHBvaW50cy4KCkFuZCByZW1vdmUg
cHJpbnRpbmcgbWlzbGVhZGluZyBlcnJvciBtZXNzYWdlICJ1bmhhbmRsZWQgcmVwYXJzZSB0YWc6
IiBhcwpyZXBhcnNlIHBvaW50cyBhcmUgaGFuZGxlZCBieSBTTUIgc2VydmVyIGFuZCBoZW5jZSB1
bmhhbmRsZWQgZmFjdCBpcyBub3JtYWwKb3BlcmF0aW9uLgoKRml4ZXM6IGNhZDNmYzBhNGM4YyAo
ImNpZnM6IFRocm93IC1FT1BOT1RTVVBQIGVycm9yIG9uIHVuc3VwcG9ydGVkIHJlcGFyc2UgcG9p
bnQgdHlwZSBmcm9tIHBhcnNlX3JlcGFyc2VfcG9pbnQoKSIpCkZpeGVzOiBiNTg3ZmQxMjg2NjAg
KCJjaWZzOiBUcmVhdCB1bmhhbmRsZWQgZGlyZWN0b3J5IG5hbWUgc3Vycm9nYXRlIHJlcGFyc2Ug
cG9pbnRzIGFzIG1vdW50IGRpcmVjdG9yeSBub2RlcyIpCkNjOiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnClJlcG9ydGVkLWJ5OiBKdW53ZW4gU3VuIDxzdW5qdzg4ODhAZ21haWwuY29tPgpTaWduZWQt
b2ZmLWJ5OiBQYWxpIFJvaMOhciA8cGFsaUBrZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2
ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9pbm9k
ZS5jICAgfCAxMCArKysrKysrKysrCiBmcy9zbWIvY2xpZW50L3JlcGFyc2UuYyB8ICA0IC0tLS0K
IDIgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9mcy9zbWIvY2xpZW50L2lub2RlLmMgYi9mcy9zbWIvY2xpZW50L2lub2RlLmMKaW5k
ZXggYTAwYTlkOTFkMGRhLi45YjU2MTk4ZjcyMzAgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQv
aW5vZGUuYworKysgYi9mcy9zbWIvY2xpZW50L2lub2RlLmMKQEAgLTEyMjgsNiArMTIyOCwxNiBA
QCBzdGF0aWMgaW50IHJlcGFyc2VfaW5mb190b19mYXR0cihzdHJ1Y3QgY2lmc19vcGVuX2luZm9f
ZGF0YSAqZGF0YSwKIAkJCQljaWZzX2NyZWF0ZV9qdW5jdGlvbl9mYXR0cihmYXR0ciwgc2IpOwog
CQkJCWdvdG8gb3V0OwogCQkJfQorCQkJLyoKKwkJCSAqIElmIHRoZSByZXBhcnNlIHBvaW50IGlz
IHVuc3VwcG9ydGVkIGJ5IHRoZSBMaW51eCBTTUIKKwkJCSAqIGNsaWVudCB0aGVuIGxldCBpdCBw
cm9jZXNzIGJ5IHRoZSBTTUIgc2VydmVyLiBTbyBtYXNrCisJCQkgKiB0aGUgLUVPUE5PVFNVUFAg
ZXJyb3IgY29kZS4gVGhpcyB3aWxsIGFsbG93IExpbnV4IFNNQgorCQkJICogY2xpZW50IHRvIHNl
bmQgU01CIE9QRU4gcmVxdWVzdCB0byBzZXJ2ZXIuIElmIHNlcnZlcgorCQkJICogZG9lcyBub3Qg
c3VwcG9ydCB0aGlzIHJlcGFyc2UgcG9pbnQgdG9vIHRoZW4gc2VydmVyCisJCQkgKiB3aWxsIHJl
dHVybiBlcnJvciBkdXJpbmcgb3BlbiB0aGUgcGF0aC4KKwkJCSAqLworCQkJaWYgKHJjID09IC1F
T1BOT1RTVVBQKQorCQkJCXJjID0gMDsKIAkJfQogCiAJCWlmIChkYXRhLT5yZXBhcnNlLnRhZyA9
PSBJT19SRVBBUlNFX1RBR19TWU1MSU5LICYmICFyYykgewpkaWZmIC0tZ2l0IGEvZnMvc21iL2Ns
aWVudC9yZXBhcnNlLmMgYi9mcy9zbWIvY2xpZW50L3JlcGFyc2UuYwppbmRleCAyYjllOTg4NWRj
NDIuLmY4NWRkNDBmMzRhZiAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9yZXBhcnNlLmMKKysr
IGIvZnMvc21iL2NsaWVudC9yZXBhcnNlLmMKQEAgLTEwNjIsOCArMTA2Miw2IEBAIGludCBwYXJz
ZV9yZXBhcnNlX3BvaW50KHN0cnVjdCByZXBhcnNlX2RhdGFfYnVmZmVyICpidWYsCiAJCQljb25z
dCBjaGFyICpmdWxsX3BhdGgsCiAJCQlzdHJ1Y3QgY2lmc19vcGVuX2luZm9fZGF0YSAqZGF0YSkK
IHsKLQlzdHJ1Y3QgY2lmc190Y29uICp0Y29uID0gY2lmc19zYl9tYXN0ZXJfdGNvbihjaWZzX3Ni
KTsKLQogCWRhdGEtPnJlcGFyc2UuYnVmID0gYnVmOwogCiAJLyogU2VlIE1TLUZTQ0MgMi4xLjIg
Ki8KQEAgLTEwOTAsOCArMTA4OCw2IEBAIGludCBwYXJzZV9yZXBhcnNlX3BvaW50KHN0cnVjdCBy
ZXBhcnNlX2RhdGFfYnVmZmVyICpidWYsCiAJCX0KIAkJcmV0dXJuIDA7CiAJZGVmYXVsdDoKLQkJ
Y2lmc190Y29uX2RiZyhWRlMgfCBPTkNFLCAidW5oYW5kbGVkIHJlcGFyc2UgdGFnOiAweCUwOHhc
biIsCi0JCQkgICAgICBsZTMyX3RvX2NwdShidWYtPlJlcGFyc2VUYWcpKTsKIAkJcmV0dXJuIC1F
T1BOT1RTVVBQOwogCX0KIH0KLS0gCjIuNDMuMAoK
--000000000000c453df06320ee2fe--
