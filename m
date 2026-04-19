Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D7222541C
	for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 01:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776562615; cv=pass; b=G8lEBTLf1V4+NtXQzb64i6f96rVOC3nrpAOI4x8jwmqfd1hFKC52tum/Kj8GNTGdH8T2YdtDKMWKVdGuHyY9X3q/4v8IpmxCJDjyRip/z6QZNIATMnF9LtjZbz9ZAfWl996OZKHu0pQrCpkfAExnRi9K+JvVuPqowYAQ2TK7fTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776562615; c=relaxed/simple;
	bh=SIuzGJEOyfdQbVHrkN9auEfohxql8b/XIH1Ni0aYNGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fb6weles58MHt0R5h1hAaQmraHz/K0t8e4l50S4dECfKPcvArw4QGs8vOVHPdw08CPxLVg2S0UV/2TyOkJfYEXxK48WBE1iLsl478nyLW8ulSG4RknGQW9CtABwgm9cs5pKnVa0mUjESt22fqxZhXn6R4EU6qgJP9Dr3S7lolx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=etdYbYDR; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="etdYbYDR"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-506a7bbe9d0so16374711cf.0
        for <linux-cifs@vger.kernel.org>; Sat, 18 Apr 2026 18:36:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776562612; cv=none;
        d=google.com; s=arc-20240605;
        b=WvEuz6t67RFJKih1Yy7CkRbnNvFV4ZtgbPetzfaDaxISlJe9aD6VaBg2hFL0JGY3pK
         BKoQoUpG0yIT+41nJj/xhMXpb+vUXAaRnt8aSE3w04kIxn0WfO11TFzyJu0NuA9NpQ5a
         UJfH7FSgRwCJ1dghA1yvJFhzXBxOB8fQnK2B/kkLoDcDfTjj/Ik9tl03WHXaxYY1TjPW
         /ajY6L7LVQzO7z/X1iXCsNdAU8txLzHmJ8ffpbmJBvQo9/yhPAZC2kJ5X3+Oz69REFc+
         mfjQbR90+TgxBL6F9/6tOlkOuRqE2Sa0szNg70XHPdIo4oRqD0BhTQQTygjheMaNeAv9
         6BFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8azCiZa6V4YdsfYQY+Iy8S7RLv+cv/K0CnDSyjduQcs=;
        fh=l4ThzsJjA/Nwhh97MRajyPCgWfVr8GIfKizMmBsb890=;
        b=X7+ED+Bhu37TMJSjr95jcn37jDbjqj7wcmKDE2bkaOvzjS3/M9qLWtxMf+qhJ4bDHx
         +KP1kCOXF2eT97IRlItmrH3KlcGXmiXT/5YFzwmqbFPHmZBMATqhaS6qgVa+4mCyCYHM
         J9pmfWaaNZtK6ypwSojxAmwZmc3hKfclU44LvASl487IOp+gEPIY9sEJb5tElzx72Gn4
         5ChQg1CBH0Ree/geHkHT9Aq1tRHXmS3T5EzRAYeoED4ka/ciIWDznfm1rNAlqZ3s8T3/
         hTuhnrXIKpF+wNQuLEJ4kJHacJxS+2k4hrrTM/lalTJ/EA2DnfMAeO4KfuKzejPWTDip
         Rc7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776562612; x=1777167412; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8azCiZa6V4YdsfYQY+Iy8S7RLv+cv/K0CnDSyjduQcs=;
        b=etdYbYDRX1im72blh0xBhg8GPKvbYNqT+oGPIbsTa13vy3aB7hiWcEWCgmHQn1u4WB
         k31CXU6X3S2pbga6g89zBNZiCXxM7KPUC41lpasQIcVfOVYL8Pb5R70NMAjZh7+QV31t
         Mu/xhq1ewkerh3KzI3TP7z4er/++73tKqady7Kch+jcA1N2tV79aqmwQ+2nFBmg1I7Fe
         Cj9EFf0XVrAutsmbKzUDU2/0BF866alu5BM1Lb4mJ42PzMYbeRG774jbXuGFPNosZVnF
         AbzJZg6wZnpx49PFkV2mZPoMX+8M5fKT0RVRIyYI6Oy6qxfQMG0Nx22UkdflgLiJHCMH
         7VyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776562612; x=1777167412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8azCiZa6V4YdsfYQY+Iy8S7RLv+cv/K0CnDSyjduQcs=;
        b=fqs5wyKvMl4at+SixZVNdowBQvyi6BKBsrGCrKqhW9//EZl+oAclkMmiSAJzfk3/a6
         4qyDhSicmbnBTtWMJ7c/3W/sqb5E5mNYHOGBYZN2obqe21F8aTY+svQxcvmM36NUgBJE
         67G6VpV5BnwKUG+gvLTXgkiqSEO6/fQDOkXnIB2fpPwJL6LfWrojDrrDOl8mgAz2baqU
         OyrX/H8FY0FNjo+0n9K7VQZyili+A3pznDe67GbpJOCAHBOMhJMHp7bI+1m8HuBmAoy6
         AxQkV5T47MmmKqBLPNkHPDLndxqEwbtcV343Pe8PS+WFbCoRiEs0wJLd5Kv8sU5LNtWb
         2mGA==
X-Gm-Message-State: AOJu0YzzV9ZD6VeQK65jMxDuY5bVCtpVi2R6dYdH96A04F3C2c2Sb3wG
	EDZvGJD+Nw8B5Kid6T9sUCaqRwbrsAAH3qUHi8t9g9YYI4Nvfr/ypLiIvzs/w7F2AzE0+3RjPKr
	UlMT+np37q5qWdjOIsSYJ/OCFu3qFhxE=
X-Gm-Gg: AeBDiesF3+HxOqtxjeiyK3a+gtz/3nC8a9MZJMOt/5pGWzBS2jccmj5R9ENt7rlB8fa
	kqv5+VLmS9ulhd60cGF+4aiD/hw6gUJJfRNFOx7NGqrHT3WPoTSNAojt/aLMPMqD6PxfAOzpniR
	lrxaf6CqO/9w9+X1JXP2/rR1Najre6/HBSza3+cue0w+22NS0M/PYlzbr9xJ2RTQ8IvhLwBQO4O
	Oy95AQ2lG1NejHQBWGNMT0yHY8MgaZLAbWAeAorFlQ24opPsdsn1xuhrIB0HhO8/GbVmLD4ibIA
	Q7yEoTx5s69G8RyTrihQoBH9riOknNMi1inx6LQmnH9UKk8sAj4Pws7ML8Wf84hkvdqaN5w/CCs
	Q6Q6hfZcVr6a+mzkPR/C5cg8MOFZW/4waigPorfsMRtb4H+1+smoWVzeWJzT67xepqdsHApOT1P
	57DH+00iKz0MXFIk/+tYVurUn0po9zBK2g
X-Received: by 2002:ac8:5807:0:b0:50d:7504:b719 with SMTP id
 d75a77b69052e-50e36ee7aefmr137108941cf.52.1776562611630; Sat, 18 Apr 2026
 18:36:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260418221311.67583-1-ebiggers@kernel.org>
In-Reply-To: <20260418221311.67583-1-ebiggers@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 18 Apr 2026 20:36:39 -0500
X-Gm-Features: AQROBzCK7srreg0o2SXwUbTa33baOj43xTQYmO1CQ0YZRMqB_en4VoZsbvby9rI
Message-ID: <CAH2r5mu-zJa_N_NJERuOrAbS4RnKsaMTroZs6Nxdtd9CNGo-_w@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] smb: client: Use AES-CMAC library
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, 
	linux-crypto@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional testing and review

On Sat, Apr 18, 2026 at 5:13=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> This series updates the SMB client to use the AES-CMAC library functions
> that were recently added, instead of a "cmac(aes)" crypto_shash.  As
> usual, this simplifies the code considerably and is much more efficient.
>
> These patches were originally sent as patches 8-11 of the series
> https://lore.kernel.org/r/20260218213501.136844-1-ebiggers@kernel.org/
> The only change from that version was adding tags and rebasing.
> I also added some microbenchmark results below.
>
> This is intended to be taken through the smb tree, either 7.1 or 7.2
> depending on maintainer preference.
>
> A few microbenchmarks that demonstrate improved performance:
>
>  - Total cycles spent in generate_key() during SMB3 mount
>    decreased from 20640 to 10780 (3 calls total).
>
>  - Total cycles spent in smb3_calc_signature() during SMB3 mount
>    decreased from 177620 to 73180 (32 calls & 4255 bytes total).
>
>  - Total cycles spent in smb3_calc_signature() while writing 10MB file
>    decreased from 27551180 to 26628360 (10 calls & 10001392 bytes total)
>
>  - Total cycles spent in smb3_calc_signature() while reading 10MB file
>    decreased from 28390900 to 27879340 (14 calls & 10001781 bytes total)
>
> Note that my "before" numbers were taken from current mainline which has
> my changes that made the "cmac(aes)" crypto_shash a bit faster as well.
> So the speedup vs v7.0 is actually even greater.
>
> Eric Biggers (4):
>   smb: client: Use AES-CMAC library for SMB3 signature calculation
>   smb: client: Remove obsolete cmac(aes) allocation
>   smb: client: Make generate_key() return void
>   smb: client: Drop 'allocate_crypto' arg from smb*_calc_signature()
>
>  fs/smb/client/Kconfig         |   2 +-
>  fs/smb/client/cifs_unicode.c  |   1 +
>  fs/smb/client/cifsencrypt.c   |  62 ++++++-------------
>  fs/smb/client/cifsfs.c        |   1 -
>  fs/smb/client/cifsglob.h      |   7 +--
>  fs/smb/client/cifsproto.h     |   3 -
>  fs/smb/client/misc.c          |  57 -----------------
>  fs/smb/client/sess.c          |  11 ----
>  fs/smb/client/smb2proto.h     |   1 -
>  fs/smb/client/smb2transport.c | 113 +++++++++-------------------------
>  10 files changed, 53 insertions(+), 205 deletions(-)
>
>
> base-commit: 8541d8f725c673db3bd741947f27974358b2e163
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
