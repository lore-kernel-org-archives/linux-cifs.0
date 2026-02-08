Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7DB36BCFD
	for <linux-cifs@vger.kernel.org>; Sun,  8 Feb 2026 23:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770593895; cv=pass; b=T597xtuhQPXdr1jszbzgLID2FkGr98v+396wUVG69xQ9Y3lKTrqhGQ3JIsVSqhfZfMm4yTQxStnCLc03piWSzSY6yVM3/YGzuzzB3rRRINmhHK7CF+8HkjkHyGqEgBE+BTCvIwLkTz3sX85AP9/nQSdLOPHgsIgJhdutFoGYrsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770593895; c=relaxed/simple;
	bh=Hfz+b3wRpx3bZquuyFLtN8zxb8VC1keMLRGVSVKzyDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lF1uVvLZuMikZhrOA/uh6JePo2nE861/EQVPylA3bXGqetG1CKCqr4PF3FCFrg8Y/kQLFHxVI+a6/3gqlfcuLQ3SiVcHNIY8gTzbIl3grUS7/wZCAZ26w+wZIHZSTbFPSdo3h508A1qR4mVQlIOKhElWOP2G6yOCHOyddw1NTcM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AHnz8Z57; arc=pass smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AHnz8Z57"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8c70ce93afaso412104085a.0
        for <linux-cifs@vger.kernel.org>; Sun, 08 Feb 2026 15:38:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770593894; cv=none;
        d=google.com; s=arc-20240605;
        b=f90xIMcZXENn99odoFuL94JBM+LFBFzAAduAdVBTJB5CW5cvGhWhZPpLSQTu7IRUFo
         Kgog9LVmV/nvSMmjOgpIER1BdK65yjt2dSDmNVBPZPZJxHOZ0jkv2JHYjaGl0++E9gI7
         HRD725Mho/NISuBqOx2DCp/qGy5HBblLrGig+2dBhyAL4dI2V8vk83bKK4+K6c1bxQqB
         xiW6tub20KNj39Xn++UCd6N1bI0BhaHPeBXTluSVobKJBwZcXmIBo0dGycJrxFat0FLi
         1+E5O6R5R9wR229gca3+svoWEJIPReJ2CbjzHTc4/kAE2YUWrxwwt2Zf+WFv5VYXvBHn
         FRgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bE8R4/V/Znw5MaV3mAB/vgVN4PgDt45fCQFS1bhncVg=;
        fh=3VSssDge7uCsWoEgjOOwvV2z/Wmq8g8WsGPNGwmtRlM=;
        b=R+P+5jchd3+rWFqH7ihNTNUviPsT5CrPDZZ1wSJYYKzEGyzvJ7JqNmQ1dqwnbqfLCB
         NVaF94/o6Im9tUbyPcLGPc1LqZBIKd3uZ3RFLhWLp9KMGUeTPwDuThlAepndxLzsTsdN
         Gv39NFS2mj13dyHAoCFXDvOgrFd3/8etLGCESvGtfu+5AP1wem0Oe/5w11f6zFQ82AkJ
         lujgnPR142PdzCM96/rWaGZptmnVBs+hMq6m6xdfx5VbDIrKYafNUDuiYRkjkKaJfOrN
         /j86CZmVvlSPnTUNjm+S/Z7BhluHpwTN7GVKdoRovzOubjUuN6ciWK+VK22BVm8DJD+C
         z7Zw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770593894; x=1771198694; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bE8R4/V/Znw5MaV3mAB/vgVN4PgDt45fCQFS1bhncVg=;
        b=AHnz8Z57JescNvquuwgRD+uJtJ53IK29UMbkW+ytQuE/AmFSJwsboXurMd3BmcLIsD
         9e2smHs+5oqZr8MaXBZs4+HwS/fbtXbY/vZ9TV9rLh6lfXOrsXI+cCvxUbYE8i5lV3DV
         VrOw2v0jxvtfqTYFNlGmYBGW20TiJ2RdC/08KAjCxeNVc9yOqCk14bciOowRlMGGDZnh
         zmmTeyBbJyFM1ILTdtezaxV6yA7wvNs6mMGrudLGcKIuPgG2vM9BbaL0b7A9aTWjfOZD
         GdPj8W4UO+ynrR42XFgR/HL9mEMqpQS9AMpLxsZwJ/z8c81eK7UfWR3Q4ZScyZ1rVFSf
         WBhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770593894; x=1771198694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bE8R4/V/Znw5MaV3mAB/vgVN4PgDt45fCQFS1bhncVg=;
        b=cucuY8ecfGIcXG9fRrzWsY0Pl3ZfqLA/vbTxb9H+SUVkVFZO6arBZHYhM4YeIQ4PWt
         YtYtbTZB2vaAFy0Utja6zmnThmIAeEadUhxpBZROVPDzeuTVq3+iXEDrjFq/vh8B9BDZ
         Rg18W1EyTrddNfSWU4vJP9T88VxQmWtIyjqP4iTzz4ujdRJb5iVwEW+7PdrB1Qb5At7S
         ZD2py7dbt2w7aA0xidRz+d9u5RbHlNptD5dZQAccpSb3TQ6qslcrRc31Aqifljki7YqZ
         IiBQF1L42XG2kaPnMpw5MdBa6jiopgO7A1N/QpMhdbyOAocLr6VVV3fbK8EpZz24cPyG
         3rgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsdoX0epGleL1d+2h0JlMY9HsA8t3GCzaBhrFyBs0l38xt6RpRw0UHZZfjZoad00aif+X80GPR/Jmp@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5jWsspEJWVBFe9z3Abtgz43PwoN0Js8caElMSs80MfltYsK5D
	0abTK7vTy1oRjo8cdeGhSVZZu7RtqdvRPgysNBIX8Mx3i57AEPLoUVCOKobpyJtF3jH+m8jQWnw
	i/flcxwkpCPLUFZ8Q7l4xpub2I3o/wwXz1A==
X-Gm-Gg: AZuq6aLJGi7lHD1B0vfd4VoAOigNG7h2+Saw/L9r3PHDb1dd/IkbO25Gd1ohv3NWu42
	TZlCpmubS5gD1EpbJ4NZpm9p7SuOpMN2Ze2Gvnqi2TfCu0KMHI05vmSz/MfowI0a2lkYHyCbXvn
	SmDLrc1GTbr3lZ3RqUAlWZDBQ4P7PBQm8djqufc0I8M54myLbbZKC/BnLsohMl/uwPdAkBrPfLl
	uNpLhAqd8lCRQ/lWve8N2pT19LSRdd2Gsd3BvDN773s7+s8l/1Vt+ZYAc9SpcQxUslctrqwHyvs
	xS5uOfvz32ekHvFXrUSl5pmXvIASgser0fJh8xhE+B3IpUpO3qfxrixxK6SXuNayjgeY2g1mFYg
	Mxqqs+xS1InrJ1bl4RQAFgc0PRWt8f5OguIE4NdYsP8J3TWvqVKAFMGigrsxUKtu05nLgj8kICR
	eVQUle57WFmw==
X-Received: by 2002:a05:620a:1789:b0:8b2:eefb:c898 with SMTP id
 af79cd13be357-8caf2389cc5mr1207596185a.69.1770593893567; Sun, 08 Feb 2026
 15:38:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e2726e90-3645-44ef-9af8-2d390c4d5bc6@samba.org>
 <20260203152012.914137-1-metze@samba.org> <68046261-f2d9-49a2-92ea-9c7abb97cd5e@samba.org>
 <46c9afa7-7834-4ac4-8509-b7087f358c96@samba.org> <2901815.1770327095@warthog.procyon.org.uk>
 <11ef6c9e-01f3-4c09-b16d-5e652624c257@samba.org> <CAH2r5mv6xVwX0Ar4ObzQ+2zcou2-KhYcWhjT_aGfeZnOD8FLCg@mail.gmail.com>
 <72494b19-1ca7-41f6-a80a-26a819ebb89d@samba.org>
In-Reply-To: <72494b19-1ca7-41f6-a80a-26a819ebb89d@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 8 Feb 2026 17:38:02 -0600
X-Gm-Features: AZwV_QhR82BY9Gg-bqfgmtv0q7mIO5RbUS_V4Cua6E5WlkdJ3pwGkw_d8hGAf7o
Message-ID: <CAH2r5ms6fOuqRFkER2yvYJdQ0MauepTG6tPPqWSBZ5Ojw-io9g@mail.gmail.com>
Subject: Re: [PATCH] smb: common: add header guards to fs/smb/common/smb2status.h
To: Stefan Metzmacher <metze@samba.org>
Cc: David Howells <dhowells@redhat.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looks like your suggested change works.  My change had a typo which you spo=
tted.

On Sun, Feb 8, 2026 at 2:39=E2=80=AFPM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Am 07.02.26 um 04:41 schrieb Steve French:
> > updated the patch with your suggestion in cifs-2.6.git for-next (see
> > attached).  Let me know if any objections or if you spot any problems.
> >
> >
> > On Fri, Feb 6, 2026 at 3:42=E2=80=AFAM Stefan Metzmacher <metze@samba.o=
rg> wrote:
> >>
> >> Am 05.02.26 um 22:31 schrieb David Howells:
> >>> Stefan Metzmacher <metze@samba.org> wrote:
> >>>
> >>>> diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
> >>>> index 802dec276e15..3abd357d6df6 100644
> >>>> --- a/fs/smb/client/Makefile
> >>>> +++ b/fs/smb/client/Makefile
> >>>> @@ -47,7 +47,7 @@ cifs-$(CONFIG_CIFS_COMPRESSION) +=3D compress.o co=
mpress/lz77.o
> >>>>    #
> >>>>    # Build the SMB2 error mapping table from smb2status.h
> >>>>    #
> >>>> -$(obj)/smb2_mapping_table.c: $(srctree)/fs/smb/common/smb2status.h =
\
> >>>> +$(obj)/smb2_mapping_table.c: $(src)/../common/smb2status.h \
> >>>>                               $(src)/gen_smb2_mapping
> >>>>           $(call cmd,gen_smb2_mapping)
> >>>
> >>> That looks reasonable.  Do you have a patch for it, if so, you can ad=
d:
> >>>
> >>>        Reviewed-by: David Howells <dhowells@redhat.com>
> >>
> >> I'd propose that Steve just squashes this into your commit
> >> cifs: Autogenerate SMB2 error mapping table
>
> The attached patch has this
>
> +$(obj)/smb2_mapping_table.c: $(src)/fs/smb/common/smb2status.h \
> +                           $(src)/gen_smb2_mapping
> +       $(call cmd,gen_smb2_mapping)
>
> Which is even worse, it has to be
>
> $(src)/../common/smb2status.h
>
> metze



--=20
Thanks,

Steve
