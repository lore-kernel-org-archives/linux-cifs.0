Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0687B27A477
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 16:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760717594; cv=none; b=qY4iKR3OWv0sPQcYXwhky7e6TQEgHMZhR6vCJo8uXILHehIiJpaGIKWCwDy4FHhMT4O46tHa0qxhoiwpIn74TfGAa0I1+NqlULFKqAGFHNBeaNt8y9SwAfRCUeYEMDPri1Y3OgRMby10BTGer5nTEragBet63WcULJmU+TtzCvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760717594; c=relaxed/simple;
	bh=CnVPB18gPnV0y9ydniAaFgQyj2ZP563th4cx24bDyPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jL3VqeDbETiKHOAQjSiWLr13+JVxBLLk3R9fYy0d5c9xAm0O2Q+2Mt568actedFlB88TNiyCa4ohi6/mtppAXhapa460AIDpbolJ1cN7WzSRx54xoBbEQGC4gm+/YMk5WeeEPE3yGRoEMDtGsuDZWq584BHk+VbhR55FSiDCVF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MzHGJsGj; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MzHGJsGj"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-87bf3d1e7faso43349686d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 09:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760717591; x=1761322391; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OjQetjKtP2N8ZnKgF+/VCDLQar2SjrRhN3JEU0v7jTQ=;
        b=MzHGJsGjNV1JV3wGAKcsS2PxBVcwkQusFZfcAiOHZ5DpzSSzA3nS04Y87o0PPcZTzg
         lDP720A4Yv3n/OChsM09aQ349V2cZ9VHe4qKU+r7Xn3w6MxIMj5bIucjk8SyHeqJ84o2
         WX5YJYBhR7Ku5rwC9WmPTp2JkBc5Hb/DGepUOayk2j93vDewXbF7fRscUkYs890yuBhY
         AI/TBsgp94vqXcAbEELAPxUC/ezH0q1eugyjzjDKJEqnsq3C9q5EZW4x07Oeokq+8Yoa
         DLDrnGVZwntOoTeYGP+nd64VGdV1rx4Os5qy793ZBVqr/QYNJoxgFOeF5+j8ieKKrKAX
         88yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760717591; x=1761322391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OjQetjKtP2N8ZnKgF+/VCDLQar2SjrRhN3JEU0v7jTQ=;
        b=QHrbwuNkxdaO42BE9jlOZKPw5mHEJOMnGrGlqyP1wtAOx+fqCKDomLX3Ao02v5GeOY
         XtmRIZnPm8LYfU3hBmur47grq0Jp6hAyDc3aQKgHmgK4yUXhMQf6er5D382/+EEs97nM
         0Y7ffg79B/aSDTQbj4hK9X/cFFAQXT3RW+tVeOD92spuupOo+g5klPSQkxZs0X1bzwml
         ZcdrDnnrBUmQ9P06ocetK4/praO0Zp0ApXy1cloxAG1U0o7b2X30l5u68uVIoWa2uWYf
         ETuh7ZXOsAaiQa3jh9rPykhANDydXBjKSfSz9Mu03gfu8Na6RIDlfoHqRHIiVDLS55oC
         B5MQ==
X-Gm-Message-State: AOJu0Yw4Y+kXhXD53WVeQUI3xd479PQFSW2jJH9Qb8NszZ65YvOI08RD
	8ql9DoBTLNPZhhybThx1rjyU3BHPChyoUEo8G6fdr1D9gCkeJzJNpF2e/wGiLQcgZABL0wPE3ik
	qOziTfhSFO9XmDny83JXnckzVzCgNqpo=
X-Gm-Gg: ASbGncvsGJVjjf6ugz029Txi/0E46TELV7Uw9GBrnb3/HwQwTQWeerubMl/lb7O76Xc
	IlkCaGu6G+KXlTBamYyerOqnue/RizceLzFAGeWR2DuDsvg6I/3BNj36HnwtT63YdOEwcqyyK5X
	/QHv1qqnwMcF/qFeCLs+RSRZybphiE5pzO68joQgu3LTtVKTMisEOGrAV5j0jBRnTRnTtlydFhA
	f0Cqd3l3a+7eIYZ66s8pJT1V0uofGUoC4fEM3edHqTVxnA+omHXA+FN8liQqaxG0dIC9y9h4Lr3
	c+HQGPC9coWnaPa4rQvOSYoDjRD9HUJJuJr9ixSpmU7lWT7Q48AsFjqDdHWT3MpVZ+J09pV91oq
	DUIgxaBydWZI/y6ExvyRVYtS8QXIbpaw7ud9dQzKDPjJ5EzldvNJ1lwDNiSBI1RYhoqHxAsAePA
	JvB5PTQg+gYQ==
X-Google-Smtp-Source: AGHT+IFPgj/3I5wJOFrTttsDELhaFe1s9tLyKiAelB1Q4yJlww5/YuKcX8nISL32dOO4767+pyotyXgt7BP+A21mluA=
X-Received: by 2002:a05:6214:27e7:b0:87c:1f80:7609 with SMTP id
 6a1803df08f44-87c2063722cmr64935006d6.34.1760717590567; Fri, 17 Oct 2025
 09:13:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251012015738.244315-1-ebiggers@kernel.org> <20251014034230.GC2763@sol>
In-Reply-To: <20251014034230.GC2763@sol>
From: Steve French <smfrench@gmail.com>
Date: Fri, 17 Oct 2025 11:12:58 -0500
X-Gm-Features: AS18NWAXgy1nFdCK093JcuNsEH8SVWOSU1ZaVUWkdPUWnKyCsTrh62MZCh2lBYs
Message-ID: <CAH2r5mtPp6yGFHipzQ6A+6Yi0FZjWZa=T=CrtALc4o6TGqF8EA@mail.gmail.com>
Subject: Re: [PATCH 0/8] smb: client: More crypto library conversions
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, 
	samba-technical@lists.samba.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> with SMB 1.0 I get "CIFS: VFS: SMB signature verification
> returned error =3D -13",

If testing SMB1 to Samba the server disabled signing unless I set
  "server signing =3D mandatory"
in smb.conf.  But with that, signing with your patches worked fine even to =
SMB1

Were you testing to Samba with SMB1?

On Mon, Oct 13, 2025 at 10:44=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> On Sat, Oct 11, 2025 at 06:57:30PM -0700, Eric Biggers wrote:
> > This series converts fs/smb/client/ to access SHA-512, HMAC-SHA256, MD5=
,
> > and HMAC-MD5 using the library APIs instead of crypto_shash.
> >
> > This simplifies the code significantly.  It also slightly improves
> > performance, as it eliminates unnecessary overhead.
> >
> > Tested with Samba with all SMB versions, with mfsymlinks in the mount
> > options, 'server min protocol =3D NT1' and 'server signing =3D required=
' in
> > smb.conf, and doing a simple file data and symlink verification test.
> > That seems to cover all the modified code paths.
> >
> > However, with SMB 1.0 I get "CIFS: VFS: SMB signature verification
> > returned error =3D -13", regardless of whether this series is applied o=
r
> > not.  Presumably, testing that case requires some other setting I
> > couldn't find.
> >
> > Regardless, these are straightforward conversions and all the actual
> > crypto is exactly the same as before, as far as I can tell.
> >
> > Eric Biggers (8):
> >   smb: client: Use SHA-512 library for SMB3.1.1 preauth hash
> >   smb: client: Use HMAC-SHA256 library for key generation
> >   smb: client: Use HMAC-SHA256 library for SMB2 signature calculation
> >   smb: client: Use MD5 library for M-F symlink hashing
> >   smb: client: Use MD5 library for SMB1 signature calculation
> >   smb: client: Use HMAC-MD5 library for NTLMv2
> >   smb: client: Remove obsolete crypto_shash allocations
> >   smb: client: Consolidate cmac(aes) shash allocation
>
> As requested off-list, here are some (micro)benchmark results for this
> series.  The CPU was AMD Ryzen 9 9950X.  The server was Samba running on
> localhost.  Message signing was enabled.  A valid username and password
> were given in the mount options.  The "Improvement" column is the
> percent change in throughput (reciprocal cycles):
>
>            Microbenchmark               Before      After   Improvement
>            =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D               =3D=
=3D=3D=3D=3D=3D      =3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>     1. Total cycles spent in             44548      20081      122%
>     smb311_update_preauth_hash()
>     during SMB 3.1.1 mount
>     (4 calls total)
>
>     2. setup_ntlmv2_rsp() cycles         31777      22231       43%
>
>     3. Total cycles spent in             17802      22876      -22%
>     generate_key()
>     during SMB 3.1.1 mount
>     (3 calls total)
>
>     4. Total cycles spent in            205110      87204      135%
>     smb2_calc_signature()
>     during SMB 2.0 mount
>     (26 calls & 3316 bytes total)
>
>     5. Total cycles spent in          22689767   21043125        8%
>     smb2_calc_signature()
>     reading 10MB file using SMB 2.0
>     (316 calls & 10031077 bytes total)
>
>     6. Total cycles spent in             56803      37840       50%
>     cifs_calc_signature()
>     during SMB 1.0 mount
>     (18 calls & 1551 bytes total)
>
>     7. Total cycles spent in          52669066   51974573        1%
>     cifs_calc_signature()
>     reading 10MB file using SMB 1.0
>     (336 calls & 10021426 bytes total)
>
>     8. parse_mf_symlink() cycles          7654       4902       56%
>
> Note: case 3 regressed because the "cmac(aes)" allocation moved from
> smb311_update_preauth_hash (case 1) to generate_key (case 3).  Excluding
> that allocation, generate_key got faster.  Likewise, the sum of cases 1,
> 2, and 3 (which all occurred at mount time) got faster.
>
> There was a greater speedup in signature calculation than I expected.
> It's probably because many SMB messages are short (especially the ones
> exchanged at mount time), and also because the old code allocated new
> crypto_shash objects more frequently than I had thought.  The SMB 2.0
> code allocated a new "hmac(sha256)" crypto_shash for every other message
> signed.  That overhead is all gone after switching to the library.
>
> TLDR: all SMB crypto calculations (SHA-512, HMAC-SHA256, MD5, HMAC-MD5)
> affected by this series are faster now.  The library APIs fix the
> unnecessary overhead that the traditional crypto API has.  Of course,
> it's also a lot easier to use as well.
>
> - Eric
>


--=20
Thanks,

Steve
