Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCA835F5E7
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 02:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824885; cv=pass; b=QPAVQ3O+SHNSr21SbVoCbFKm6N0RztdAzB9SQM6H0tw5to2ZzBaz8UmcuZa7fC2dqoyzibJTlu7v5dJcC27jbLdl0Int26ef47T6F2qTdOERa99ojRjjbt3+WasXxkBNaIuu/NNH9zmKKegjtPZDeElffHQOlgCfdIzV4FASxSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824885; c=relaxed/simple;
	bh=IkcywboLEQ6ZH4kYu8JPpkMp9w0TSHmZItRMZtWRuAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cJfrSH+xN6pQyLvEREhMn/lHxPQCyfyLy2lR23nS6j5ghgXuFF+riDtrb1MvW44DSYp8O6U1yKhDk0Fvsmii+8T3q7AD0iHZsyESZGbIGJEBxZAManUCujuLs1cDtNh4qsFS0VM0RqR8lt8MBEK7pk2PJBD9WI4c/zH8YpYi7Y4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b5HPvavI; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b5HPvavI"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8a154cc6a48so57107726d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 19:27:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776824874; cv=none;
        d=google.com; s=arc-20240605;
        b=eF7W5356bfaWqy892lo05N6idoscM+rgfXDdtNF4sbVGX6Mzd0DdcVpxdSmiqvaeBb
         olU2n2bwoogjTRDi3Qg28ABBTZn1nJgUo1O4hxQZ9XGJ8h2yfBNPHgCCb/2LZmJPI9kD
         D8PMXlxerDRKT4UoAfELRXATgEYpN9ARhByvXODGUzZR5KbcFkV3DHaSE+vSQI76Ci5a
         BZTiq5sCLAyv3WERw0b3dmIg+oCxirF5T2cuv6Fc1QSft4/e15zoVqhscZG2L9slhP43
         kCpHfy06mCUF05PbNbqz/qx8vSlBccW3pG5FxtiuWnQUXQ9bNTj9aHfxAYZUI9AHeg6H
         fTzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W2ALRJpj9H2zlqlYputDOhmwNHTAhuill0cT5yrnU+8=;
        fh=y+JHyQL1d5Z239s/yN1PTwATWpqwxY3S+Q0cxZn10ng=;
        b=Ca9QSxvRAAf3o9GsJaPNPa3cJYAU8e+LhjgZtwvaJqKpGXgtvZO7SZ42RqbVi24JUX
         72ScA56AGz7bmgXvw8aAVNPgwxQWSF+N7dNSc6k8V9xlWV5Rl9sPVqKtnADtHskmxc3e
         bvA2jGXpEqA4zjridk9RHeCcWTN0f0ZnqLcmJbZTQ/mX/+FfNns9Pj9yeg7tm/9CZVHs
         hQ95P8EabDUI3cMV4gMh37wkgURfsRT8Q1RlRuCH3FCFwGiY5iWHF9kcaCCmvdrhrqTq
         M26jAmb0inNIGs/D9axMdfro+QFJ2COSlkeHWCR29DLOBxP3dWGdMEJ5V2+eZZQmPV0B
         97fA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776824874; x=1777429674; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W2ALRJpj9H2zlqlYputDOhmwNHTAhuill0cT5yrnU+8=;
        b=b5HPvavIHoR4zIpfE8N6OWN34corpSmJvlARMQyINbP9hy+D5Yo4XDS2NKujaL6AqU
         AXPuLtkujHv+w5zIjKCUUfriIx0MPyDXP9VzbaLqy10olbOUHNMPFX/4VnQKrwY19yGA
         ewrNCLy+oCpymM2UB/uyqDErJI9GRr86ksI4BfDnlZp6nvDGRsAABqVUrlGC4NJX/QT8
         tpJly7rP84tlOA9GYxEntuCAbAgVWJBF3X1Yg5Vyk1Fgay4E95cwID5jX7dC6MjAPl4A
         4AETFT7gD/cdwCy6xqBebrYe1KXjmdFrA8owYoLQbJrnHk887CIU0ybRKcBlggl4BpOS
         e3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776824874; x=1777429674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W2ALRJpj9H2zlqlYputDOhmwNHTAhuill0cT5yrnU+8=;
        b=NYkQMKkryJLz8JwKs6YmzJZ95Ctoy9c1t0lm2id0CBqJ03tYr3CLcusB0I8uzVmcdw
         RWHvLLSGt1/MWg/Om90DrZw12a0sNiLB+kWh+pTTIfmZxoyW/2/GhbBUv6/8jBGbpR7K
         CG9zUplQ3BRcyivevS1bUg9FWKmj1Pu5HNCALaYoAjMIsc7/+uaYv1Dd+ABqbgVg/HeT
         RHYlMol5hes6L1omJuxOPviqydy6E/NMWkQs0qH4c2fj2FTeSwAax1kwSTxqInnRq3Gf
         ksikIK9s3SSi693aVmE3433+UnEeKqPFMYNL01O66qx4NWCXfuNpb36UyaAPJQD/95jz
         /Qrw==
X-Forwarded-Encrypted: i=1; AFNElJ8LCcOK1Zm07oSakZ8x2VVPFfgE/go+PxDuhEF7h4df2DM/PotafD3GhkGslHOvSUcoH7VswAQAH/M5@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy3X+K65qSG28411J5XF0bwWD9n1nW59iiiW+fdn+JaTFgwAxn
	Hp9QiIRgaAZJAuZHf+L6jjdxLDWu7fqht1nx2cvHtUM+J7kAAInKp/s6ayY+eaLU4I25j/pKXrK
	SjoyfO/21nGkjRYLNiy09zMZ8xKTYPMo=
X-Gm-Gg: AeBDieuQxZ2/6XcMlVuI36ZM8iPFhLbIgBSvzu1urd0QvlsMQRKoD0M9J6Dzf6HG8iy
	2CLLX/BYdMCJv4D2YqtX5mTRL5zwlv2bgSP4n6ZsR4392EPJ/Qgb9mY+88p8qnJCrqdV3962nLz
	M55JqtBw9qf2luDKG4atdK/IVT360FN1RqvdOnn9tTMQ6l4ZjR0NlDPmrw3Y/PJX18ovXXdJi1t
	v55vfwWLl+v1xt2lLHe5LJMrbzTzFVW6mKocRtEUT1rjNINJ570reul6Jc+qR0UVffcb2b6httW
	D50FPmIy4EclwhCZ8ddfKg7OGjg03+VuiE37Lf2lYgGEYDwh8IkGQnC8Svs1kSwTLzIQIsX3Ahu
	G66Tr3ur7Gv9RuX8blRStmPc8pH43iNm/q0i2HlfLBRNewPPLoFMAc5QipfznF0IBfvwhDB6/6A
	==
X-Received: by 2002:a05:6214:5294:b0:8b0:2b9e:9636 with SMTP id
 6a1803df08f44-8b02b9e9cd4mr307045956d6.18.1776824873706; Tue, 21 Apr 2026
 19:27:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421190619.1396589-1-mmakassikis@freebox.fr>
 <CAH2r5mu+kn7qDq4_y6PFYsgAPwUE9WuAjNU_-4Z8Ot6s9WkCQQ@mail.gmail.com> <CAKYAXd8E7gMoKraLs-qzsEZezs6MNDxv2Sj_7mmmMVkFdy56Xg@mail.gmail.com>
In-Reply-To: <CAKYAXd8E7gMoKraLs-qzsEZezs6MNDxv2Sj_7mmmMVkFdy56Xg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 21 Apr 2026 21:27:41 -0500
X-Gm-Features: AQROBzA8Oncc42SB20VJX05sBfR5Sli6m46Ja2re1iHu5q95O8vdqQBcfxws0X0
Message-ID: <CAH2r5mvhW0pTVtmgJRb4n8-cSUa+du1A9OxTa7oR_MiBKif9HA@mail.gmail.com>
Subject: Re: [PATCH] fs: smb: server: stop sending fake security descriptors
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Marios Makassikis <mmakassikis@freebox.fr>, linux-cifs@vger.kernel.org, tom@talpey.com, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged updated patch to ksmbd-for-next

On Tue, Apr 21, 2026 at 8:19=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Wed, Apr 22, 2026 at 9:34=E2=80=AFAM Steve French <smfrench@gmail.com>=
 wrote:
> >
> > The patch generates a build warning
> >
> > smb2pdu.c: In function =E2=80=98smb2_get_info_sec=E2=80=99:
> > smb2pdu.c:5817:1: warning: label =E2=80=98iov_pin=E2=80=99 defined but =
not used [-Wunused-label]
> >  5817 | iov_pin:
> >       | ^~~~~~~
> >
> > The patch removes the use of that label
> > ...
> > -               secdesclen =3D sizeof(struct smb_ntsd);
> > -               goto iov_pin;
> > +               rsp->hdr.Status =3D STATUS_NOT_SUPPORTED;
> > +               return -EINVAL;
> >         }
> Right, I directly fixed it and pushed it again.
> Thanks!
> >
> > On Tue, Apr 21, 2026 at 2:06=E2=80=AFPM Marios Makassikis
> > <mmakassikis@freebox.fr> wrote:
> > >
> > > in smb2_get_info_sec, a dummy security descriptor (SD) is returned if
> > > the requested information is not supported.
> > >
> > > the code is currently wrong, as DACL_PROTECTED is set in the type fie=
ld,
> > > but there is no DACL is present.
> > >
> > > instead of faking a security, report a STATUS_NOT_SUPPORTED error.
> > >
> > > this seems to fix a "Error 0x80090006: Invalid Signature" on file
> > > transfers with Windows 11 clients (25H2, build 26200.8246).
> > >
> > > capturing traffic shows that the client is sending a GET_INFO/SEC_INF=
O
> > > request, with the additional_info field set to 0x20
> > > (ATTRIBUTE_SECURITY_INFORMATION). Returning an empty SD
> > > (with only SELF_RELATIVE set) does not fix the error.
> > >
> > > Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> > > ---
> > >  fs/smb/server/smb2pdu.c | 16 ++--------------
> > >  1 file changed, 2 insertions(+), 14 deletions(-)
> > >
> > > diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> > > index ee32e61b6d3c..6622efdd55e3 100644
> > > --- a/fs/smb/server/smb2pdu.c
> > > +++ b/fs/smb/server/smb2pdu.c
> > > @@ -5745,20 +5745,8 @@ static int smb2_get_info_sec(struct ksmbd_work=
 *work,
> > >                 ksmbd_debug(SMB, "Unsupported addition info: 0x%x)\n"=
,
> > >                        addition_info);
> > >
> > > -               pntsd =3D kzalloc(ALIGN(sizeof(struct smb_ntsd), 8),
> > > -                               KSMBD_DEFAULT_GFP);
> > > -               if (!pntsd)
> > > -                       return -ENOMEM;
> > > -
> > > -               pntsd->revision =3D cpu_to_le16(1);
> > > -               pntsd->type =3D cpu_to_le16(SELF_RELATIVE | DACL_PROT=
ECTED);
> > > -               pntsd->osidoffset =3D 0;
> > > -               pntsd->gsidoffset =3D 0;
> > > -               pntsd->sacloffset =3D 0;
> > > -               pntsd->dacloffset =3D 0;
> > > -
> > > -               secdesclen =3D sizeof(struct smb_ntsd);
> > > -               goto iov_pin;
> > > +               rsp->hdr.Status =3D STATUS_NOT_SUPPORTED;
> > > +               return -EINVAL;
> > >         }
> > >
> > >         if (work->next_smb2_rcv_hdr_off) {
> > > --
> > > 2.51.1
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
