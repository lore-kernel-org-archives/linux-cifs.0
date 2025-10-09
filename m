Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D288D2459F3
	for <linux-cifs@vger.kernel.org>; Thu,  9 Oct 2025 14:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760019026; cv=none; b=kE3EYAgphpak9WjVAtB6h6DXepfsjmC9+z18iidVlEPnCRovfj1qwrTrIEJy5SECKDVLrIR/ve7celB2Xh1D1ROsRjBt5WOsg9sse+A23fwFUVPC82szfZRKyDRFlNT2qfB7Vvi4fab0aFuHxpZ2n3bFncDBvrZlp9Scs+XF7F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760019026; c=relaxed/simple;
	bh=P85/MLXEUe7QF+fN8WJZvrqUyH/HIWgCvcG6iXlJUpI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s6rjU3avjVx4VuGTKQUVK/PWJDijt2ZWeUovt/mBcH203XRi1WRy+uRDjGAHxX14HppmDebrM1H1ZJmQC76krwgTgzlHBqBqx7Fo29ncKTOgil8BGcuDP8Igs2EQ8LsaviPXjiKFMO+ZIXNabUGkDIPCwuojuaXOsrUn9rndp5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k27jODSf; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k27jODSf"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4d9bcc2368eso9985431cf.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 Oct 2025 07:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760019024; x=1760623824; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P85/MLXEUe7QF+fN8WJZvrqUyH/HIWgCvcG6iXlJUpI=;
        b=k27jODSfR9j+LsK7N2YaUTKlTotHaXWuVLwJQaj3yHl52kEGC/FnkWlwEayXeXPYSU
         73CqZMmAnU7cEp9T5MCUCx9v2jC6yzCOhQ0E3VWVXiZHi6NV+B5rimtj9ZPtovsrr2Uu
         R//xfqLzuZIFTC/ZQVWD37bn7znte0YK4hMYwqF9RvuoZr6YPPNnFw2S7rmfr14RlC6i
         sR//tCs8SeJLAiAEZjN89A1sBqsZR4TIbhL2SfEp99nLsz1/C1Bla0tttc+azAcC59TT
         Jra63A238f5I4QhHSKnaZVoiMWSSWsO2hIEL+FHirqt0C9fuA1+MuyfJwl2MsqaeltG6
         64kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760019024; x=1760623824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P85/MLXEUe7QF+fN8WJZvrqUyH/HIWgCvcG6iXlJUpI=;
        b=C8Irc4UvsXivzmfuZtd3zvtkLjKnQoi4SyCaPCKAQgYoeC6Fy92aF14107r3t20FR/
         gr4/HOnEWPPRA9MfCzscCGJdBuTm3fZfovKp1jXLPjKLyBlBxy+4rHJwYatnei1TckPX
         7dA9xjnZ4WL5DuwBNHf0qdIk6BWTq1xf0YWmtVf6lfzkme2UCfSQQqcftD8edV6x09T+
         IZZmG8s11l+B5ZdspFH5DAp4Sb9hR/NQUuVkWRbAPEl1ZwNJjRpNtOwtS5RXQ6YVq2Bg
         khP/nu8ZOU610FypAr3fRo6rUrY3vtKV4ED/eCTLvrFy6ayMV5zT8aoNBvDn6jLmyNFT
         /n/w==
X-Gm-Message-State: AOJu0YzwyYeBr6K14vx6XuNaqyWKXiJBGLSdaJjo8YPyP15KTRaBqtr9
	Q2qm1q6Imufc6pTtrvtBwhFX65i+aOZ5WXayM1tPD2N5OvfgQ/4LIksQOMuixsBB2bciFYD0kSu
	1JjhPVz/8gi8PNj0czmwBpkyKTR/j8iQ=
X-Gm-Gg: ASbGncttP/LAGVunA5+VwhuTO6NS4C6Qq7KozEzCiL6cU1+/EbLvqwvMgS5IDZLRKvE
	6zJxFKSl6Llm2v5vvQrfZQ97L4tlQzzMJYAeC7Ski/r+KHqR07tytdWdMktABkJvPl3wbUx6JAH
	uYED2pqBoY9U5WPcoKYtnqpHQd/JmcbwIeCI4GSKQeeyJDQvOWCye+OYdLLLW2mj7nd83HFWUbF
	f+RNRUCNVYlpduKl+z82NwXyzOCfokAmT89gELHJfNvz6OwyN+z2HPF6pJ3DjuZboG+YnuN8bni
	/3KA5U8ngG29kaGcE0Uta9jB/FhbhjDkkcb5LfitBf40EcJHbha3kmwoAA0HU3gRcxXZV9JC8dw
	0vTUKFEOPzKxRLDMCzUCnI5uQsqQqhKyXn4j05ugIS7NIsDw0SkFlRS0bVoO/Lr1UfBI=
X-Google-Smtp-Source: AGHT+IEq6CVbLtM0eoAJtvMfbqXt4HJ2BgMlkQY9gDys0e20heLVjsMO54GaAaTrR6eS4pO1ntG7gQ4e0F3PtUvAMWo=
X-Received: by 2002:a05:622a:1815:b0:4e0:3cdb:d1dc with SMTP id
 d75a77b69052e-4e6ead4416dmr104621181cf.43.1760019023589; Thu, 09 Oct 2025
 07:10:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5b95806a-e72e-4d05-9db8-104be645e6e5@web.de> <CAH2r5mtpoLscs9sodXcRMO3-dqMDBSTR+ncExdqy4dQR=4uE8A@mail.gmail.com>
 <bc8f02de-0cd5-475d-bb19-e44e202f7a58@web.de> <CAH2r5mtY8--9ccnm5aYfOYJ=kEBr7=y-Z_eROKDp7A6DGnxwcA@mail.gmail.com>
 <5c09026e-3176-4dd3-abd8-e5ef3b2bf5c4@web.de>
In-Reply-To: <5c09026e-3176-4dd3-abd8-e5ef3b2bf5c4@web.de>
From: Steve French <smfrench@gmail.com>
Date: Thu, 9 Oct 2025 09:10:11 -0500
X-Gm-Features: AS18NWDXka1aXJboBSZTAkvYpbLFoOs9n359mdD7fdpj0FKFp6jbH8uCrZTjXDA
Message-ID: <CAH2r5muYzimR+i2EBFwvJQ4MWWpzVdbaocg+8FdSniSZF7rXQw@mail.gmail.com>
Subject: Re: smb: client: Simplify a return statement in get_smb2_acl_by_path()
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-cifs@vger.kernel.org, Bharath SM <bharathsm@microsoft.com>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 9, 2025 at 9:00=E2=80=AFAM Markus Elfring <Markus.Elfring@web.d=
e> wrote:
>
> > Three of the four you just sent today, grow the code slightly,
>
> How much will this observation matter?

Remember the goals here, the priorities:
1) Fixes for bugs
2) Performance improvements
3) Features that add support for missing Linux requirements (e.g.
adding O_TMPFILE or "rename_exchange support)
and then lower priority but still somewhat useful:
4) cleanup patches that remove unneeded code (although has to be
balanced against how it can hurt backports of important fixes),
ie cleanup that makes code *smaller* and therefore slightly easier to
read and maintain
5) cleanup code that adds or updates comments clarifying confusing code

Obviously "cleanup" patches that don't shrink code are often useless
(as they potentially break backports of patches for no value).




--=20
Thanks,

Steve
