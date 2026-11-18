Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794987856;
	b=IKBnpsnS+gGeCLQFmejcDNXaJACiHd83j10mGmTxtWRI2zMyZ1Q/hkaYHOqF2W/ZxSoG
	 xWG3x89lgToJVkLwQ8EDUX849tqoPipHYSvYYFZR/1SC+4ja8r4BvWePz8S7C8Kjnwj8v
	 GSKdjxZIejasIQ+EKOjbznp24sLhqNuoKTBHVpDsjm0HZhsgpHJTnZk28B98QpTalLkvB
	 DiBuK0jq1MeSIm+Mdp2TdsyOn5RduMayLK9dKaqwt4zHTuTV2siKfd4sJZ9uS3e0HKbxw
	 gyArrOiPEZBgjnETIPV0FY9ACDJBKgURfpWxgpVrvSLywtWUlVtDdc/FcKXNwcig0PA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794987856;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=n4AlrOV2bTkxElEMddERWhd2tmhmmQ/VeiiLUiTK5Jw=;
	b=GWy4+Wu8q/IEgOFRtn87qls1E70+WO66HL9CCQkK47RhrGlW7VU4hIyv1e+eCaonq7S2
	 WoqxLqaaj9bbrUwlDHneBegvHKQI23X9tDSagtGV0Fq5I7HpwOn5lkyPiSORwEOyoE9Ad
	 jIhRCQ9jlKvwfIfhRg2GaInxKq5v0yYyussJ6eEyQiSMm/1rgGpZMw1bnbbxJJ+PIryex
	 m171RzvnpiQefpAfwJ7eLNqP2YvdzKB9r2TVev4ACVyFiGX31rPdOmswgHW0ISIy12GU7
	 12yMg25Q2Suxz2bW5Wet0ufxjX6lapGRF6bfiQ0zW7NYlthxVpgKVkJlOavm05jATHw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a90oyekV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B47606A337
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 07:44:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6B47606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a90oyekV
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c506a231b88so78059166b.3
        for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 23:44:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794987854; cv=none;
        d=google.com; s=arc-20260327;
        b=Sv0ckmXoxQx3lP9q9olZ3BT9H6pvMfISqcJD/uCYlu7FWNrBuhnLCJihrmHgfgQh/k
         jg91jwH/xlQtLKvFn9FzrjmuBIBZTpNqzr0j3h9403bgOQvG/Ba7Ol2DratD7RD3ZKYu
         LC5EZ5S5YVVmZtYW072YYYoyvBE0b9YmDkKUi0Vv8q5BDZogBtRwplIzVe+TmktKIufJ
         29GtsdkMmJ/8tojms+ltM6HJrNZTV2IYz5yEhh3trHOwuGaqTD+UOdFsq98K6Xmlb/M1
         0UYVdDMJrDz98inDWa03H5DnwaUcwN4kbfOhtoN87f0Hh1At1A3mgzW5MOFElPNa6/Kl
         2Rzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n4AlrOV2bTkxElEMddERWhd2tmhmmQ/VeiiLUiTK5Jw=;
        fh=dtMS6+sGHg1W7MiYF7IXuOwlTs15gP3WJCajQyypZzs=;
        b=VBLbsvs0KYurDNmBc9wbgoirCV5E1vmnqJzvNcynMrhc9EHf+JUbM7628VSjHbx2D4
         cda0g+ts9PwUROkgkP5Jx1rUHM2NqF6WhEVgUM2sQCeE7dwO62SwEL7ZTSyoRJQzCLQy
         VQoyR6VbvtNuEK7MAnGAvt8bu4usGapDJgyEAD9KxGOefvzPoD41VWiEYgCVBufmpiQz
         3dkjGDLzuoulxz8IVNIvuF3+MAsfVFxJ3Gh5vSqP88+slCRktK9UAykwCkwpfYgWKl0E
         yRvrzyrKzx2M3xHnSWMrcfZE0ORBT8GBaA6QhM8k4i18a98Vnb3E7rRcxiCsMOiUeHN4
         XUSA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794987854; x=1795592654; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n4AlrOV2bTkxElEMddERWhd2tmhmmQ/VeiiLUiTK5Jw=;
        b=a90oyekVEtWSbiQRFscTKUuOugQqsd/uPA+FKR2IB/q1W1t8taa8KZshmfMtrhj1sD
         LqlTnKmsQhen50SBtfcKu6ft+wmIP8g2pM86rjRDF5dOKhx6HkBJjAXW7T1Tl+HJbYGM
         9Z/N8X+v0TSuGqaim2wrUn/cNQfHBvaUNsmrozwAN8tX044VAK/I37vtJhmtoyIAOWLA
         XYHsu5zGuiaBInhEXWSkPT9Ljesxk0waBX2hq58DlHTNOBoHWFxCJ3W007gohZobfiCi
         lUKynaBj5mnjW9OxWobgOEENOt4UOL2ebqhsSIkfnMawpK0ePLqbjCd09xHI9SQgG63a
         TzFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794987854; x=1795592654;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4AlrOV2bTkxElEMddERWhd2tmhmmQ/VeiiLUiTK5Jw=;
        b=YkNN0k0rhr9k77aTd38oMaxjUYFsj5tUeV7b+sCPlQokWtgPNvED3LcbQjcx5jIKRg
         k34SroYwvzJR8UQY1oRVrofoEtn8vkXHafed/9w8SA6CKfbXimk5rGrfqQVmyaiyVpAw
         o1Emp/9L04hGl+o1m+8JrdZlntmS4M42Lviwj9308y3Tv+lopBsozD4w+ZzjR0I8z3u3
         ahWdo+XBbw8l5V68l8XPXTUTnpYNm+ChPcZWxnSyLqftT0AfZ3KJBjDWzpY450GBXzhW
         Xi9iQaUR4eS7fSTwOPunzRVz1AIN9CcLIshPAmZyH17i8YhVbB+1e6scLvqOHCkhUoqw
         IOfQ==
X-Forwarded-Encrypted: i=1; AL+hErH8ijT6OaDaqRvMQacpXYcMl1/M3FvUAQJfKOFtaLr/EHKaHWOAFQ5ErtJYKKXNT9MmG3lgtV07vt+n@vger.kernel.org
X-Gm-Message-State: APuU4Z99FmH6H59I5KwWuoNT+aRN541zTgwGAeBjIIDknLcCxmBgFAt5
	q+VSjPwWaElE8JG32pUBBrr1mEyLwQSvrmw5L3oU2BUeS5vEjBZDHL855O0w4sW7LyAYzydExRB
	hYHK7vXGcEX4aiyJ7HNkTxilOpWS2HsE=
X-Gm-Gg: AYBFou0QX8vti0+v358+oVEXBPrQjZeTUpSPKiNfSYEsIQ+x5hwfVNuNSPO6aNJKzW1
	WbLxSxbU1PwsyFGqw8zeiJZHk55o0vXd1otOPMNAWlKjx8bvH27illSXmL60cMTCHaYgQuV0PeX
	Ek3FThIktm9VDvD631vdyqkbvjObY+EctvTDrzbVFVy/AigS24067ZLWtssznI4jGJSCTajM0M5
	457guECcHyigb1Af7FIyQrP+SOongQ5A4KMPvRmte+qH4HYMxcUAcdOfAGtjLNJuTti5QA0Ek8o
	VRyFxL+6R457zT4iZgClirLegR67+xfmPkzlaXKCFtjmKbd/6849MiloTGsyjxjH00F8hf9LVjV
	7r/NQtzd3+UunRLUD1eCjA+bPbWky0Fm7cyOpknO1wBct2yLe66cpEQl6dVjyWzPxZ9NbFQ==
X-Received: by 2002:a17:906:99c5:b0:c2a:ad55:b3fa with SMTP id
 a640c23a62f3a-c510debbf56mr128472166b.7.1794987854109; Tue, 17 Nov 2026
 23:44:14 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-8-koray.fra@gmail.com>
 <f297d9ea-ebd7-47f4-ab7b-de5c45980000@app.fastmail.com>
In-Reply-To: <f297d9ea-ebd7-47f4-ab7b-de5c45980000@app.fastmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 08:44:02 +0100
X-Gm-Features: AclHuK95FDUZyIgGYH5oXAgwPF3l-5HxSmk1nBdJ9DPBoS5wbYWUIu9nYKyQ4rA
Message-ID: <CAOQ4uxhpMARO_ZMJDeoa044BwufLVnS0o4Fv0abBF=tjaZmtWQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 07/10] nfsd: add provenance time (ptime) via FATTR4_TIME_CREATE
To: Chuck Lever <cel@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 11:02=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote=
:
>
>
>
> On Sun, Nov 15, 2026, at 1:03 PM, koraynilay wrote:
> > Implement provenance time (ptime) in NFSD, as introduced in a
> > previous commit ("vfs: add provenance time (ptime)").
> >
> > Map ptime to FATTR4_TIME_CREATE, allowing clients to set it across
> > CREATE, OPEN and SETATTR compounds.
> >
> > If the underlying filesystem supports it, use __vfs_fileattr_set_locked=
()
> > to set it, returning -EOPNOTSUPP in case it's not supported (i.e. when
> > __vfs_fileattr_set_locked() returns -ENOIOCTLCMD).
> >
> > When querying FATTR4_TIME_CREATE, request both STATX_PTIME and
> > STATX_BTIME, preferring ptime over btime if available, and advertise
> > FATTR4_TIME_CREATE support if either ptime or btime is available.
> >
> > Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
> > Signed-off-by: koraynilay <koray.fra@gmail.com>
>
> > @@ -3646,7 +3649,14 @@ static __be32
> > nfsd4_encode_fattr4_time_access(struct xdr_stream *xdr,
> >  static __be32 nfsd4_encode_fattr4_time_create(struct xdr_stream *xdr,
> >                                             const struct nfsd4_fattr_ar=
gs *args)
> >  {
> > -     return nfsd4_encode_nfstime4(xdr, &args->stat.btime);
> > +     const struct timespec64 *ts;
> > +
> > +     if (args->stat.result_mask & STATX_PTIME)
> > +             ts =3D &args->stat.ptime;
> > +     else
> > +             ts =3D &args->stat.btime;
> > +
> > +     return nfsd4_encode_nfstime4(xdr, ts);
> >  }
>
> I have trouble with this approach.
>
> We've already established that, for the Linux in-kernel NFS server
> implementation, FATTR4_TIME_CREATE reports a file's birth time and
> does not permit NFS clients to modify that.
>
> After this patch is applied, the server reports the ptime instead
> of the btime on some filesystems but not others.

In other words, for some server filesystems FATTR4_TIME_CREATE is
settable and for others it is not.

Isn't the NFSv4 protocol equipt to deal with this complexity?

>
> Essentially this changes the semantics of existing files that have
> a btime set -- technically that's a regression.

I fail to see in what situation this is a regression. Please explain.

The only oddity I can see is that a kernel downgrade could result
in an NFS client's view of FATTR4_TIME_CREATE going backward
in time to birth time, but I don't think this qualifies as a regression.

Thanks,
Amir.
