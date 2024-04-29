Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE4C1119B
	for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 20:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714421777; cv=none; b=XQNPyDv4oMv+YsppLnGQfTUJXOVUnlbpYpg4DiqfYPhBNarJNl0y7q6jLhkaPxmSDjlYqMQbDnNqJQyIAI36XuJrzt4PHMu+3BtP+uRkr4DafoazCKSauw23aQNfnkWFU4R0f1LC4H6pvJbXrAC2O6FWPSdYqh2+H7Z0xDSAihE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714421777; c=relaxed/simple;
	bh=h6vOmGXp0bW2Rs5TlI84aeVIutzI85dxGVuQRe7OFnc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FDACSWzDzPUGf/sbh4WEB/QVUpXgRtMnUCa50RSfLAprNPxX1fvN0oXyliXksVwE6Q5ktNhuKii0hTpzYvA3TQN5jHGL7c+4MrDLQqScwX9F8h1HUWrmWw7x47e9Ac4UZx1KgaMBhVxLM2DwgV/NF9BFq7pSQr8z7COf9C1igZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JnI2rPEi; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JnI2rPEi"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d8a2cbe1baso65792971fa.0
        for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 13:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714421774; x=1715026574; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6vOmGXp0bW2Rs5TlI84aeVIutzI85dxGVuQRe7OFnc=;
        b=JnI2rPEiAJxHTUeissCV7kCzdGmDScNX6h5VVsztSrPJQMZlU2ABzbLoUAMhZSmHtu
         s+IT7bVU7EEeNNDcOOGUGts/5kHjHVbaMn6dzvb5a0aHZVfjg4HbHPrIQDUiIP5zHjQ4
         fi5ujRZFnG/YZNyH0aLS+AJhRxGKLA0Y4Ai+o+i+XPL/ALlrtwqz0Z/tB1hCcS2Nqj3Z
         p1iM73+3MSTSPy/cGaEL25bEO8gbZ0tTaOoRwVzeyBawF14HAml4OntEKrvFJaE0JNAp
         ofv/Tc4guIvDX/YYmlqL48bJoglK77gnVYnLQisJmeHim7xDsp3wk/KryNOua0a5Cm1r
         saww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714421774; x=1715026574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6vOmGXp0bW2Rs5TlI84aeVIutzI85dxGVuQRe7OFnc=;
        b=sObecalBVBoqREirFZKG1BbeAntVckx+hz7QTdDeoCSrPB5VPoldD45H7YC6I6u5y6
         rB7RzwwZYd6vKHLw0D0ipq6EB/2repWBvZ3/K+0AUBTUYHiVRnryGozF6qgvdmx4WAEm
         f/2A9yiTik9mO9Zs7Yv0IiASRX748zsjUyKmgzRA7QHC09hlJ7tpkuF2YZr70emc9bkw
         YeL9evuqAAHQZh9gMOWehkfCLJ9186wBrsfPAoxC5XyTe7JXyLn1iHcmkCIe93O0OfDB
         7fcly0jTsee0Ed4rmDCEMzIjQsvHq5fybl9Sl0KSFTeHbommhpBay1lql9aV1HHxazUb
         nZEA==
X-Forwarded-Encrypted: i=1; AJvYcCUh0Dk0jhvR3AR3pflvvF7cf3pKZfFDdle1n0k73/4VGUq/cJc2pTMc+BEx9yc7lxcFgs9bv4wdHzTa9Lj9CHQyCIe5SxlENvnXUA==
X-Gm-Message-State: AOJu0YyQ42edlCF1dIDuhkpDcKrbvmMmCbq1QrlhfKduNg0gq4a+7BOw
	AzqOVODM2dkM2RHGVA/y9ZIQ4eW4NWwFXfzo7CPbeG0TUyQw8FHI6VY4WTB39jth8xiEBFXWe73
	cBm5Ggtvxojqz1TwmMY9jnXquJNs=
X-Google-Smtp-Source: AGHT+IHi2rKIsmr/2uzfklN8ur/dhS20ps7ru0MTBPfpyf3k0b74pYZVhPiureoEYY5J603Qib2V33B77zv1e4+ukrE=
X-Received: by 2002:a05:651c:a0d:b0:2dd:d3a0:e096 with SMTP id
 k13-20020a05651c0a0d00b002ddd3a0e096mr11212815ljq.31.1714421774094; Mon, 29
 Apr 2024 13:16:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muXqpZN1mu=WAhaxXe0yRB7Rib_CaoGo3h15wwcSPZFuw@mail.gmail.com>
 <b40a9f3b-6d2d-4ddc-9ca3-9d8bb21ee0b9@samba.org> <Zi/WD7EsxMBilrT0@jeremy-HP-Z840-Workstation>
 <d9f60326-9ddf-485f-81c8-2012b7598484@samba.org> <Zi/8DEo+ZiF24LLw@jeremy-HP-Z840-Workstation>
In-Reply-To: <Zi/8DEo+ZiF24LLw@jeremy-HP-Z840-Workstation>
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Apr 2024 15:16:02 -0500
Message-ID: <CAH2r5mu2Qr5W1eUOz-JFyf4X6Wk9X2Jr4XFza4tJmH+mVVZqLw@mail.gmail.com>
Subject: Re: Samba ctime still reported incorrectly
To: Jeremy Allison <jra@samba.org>
Cc: Ralph Boehme <slow@samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 29, 2024 at 2:59=E2=80=AFPM Jeremy Allison <jra@samba.org> wrot=
e:
>
> On Mon, Apr 29, 2024 at 09:27:15PM +0200, Ralph Boehme wrote:
> >On 4/29/24 7:17 PM, Jeremy Allison wrote:
> >>
> >>If you look closely at that commit, you'll see
> >>that it's actually not changing the logic that
> >>previously existed :-).
> >
> >yeah, sure, but it was a decent refactoring so I was wondering whether
> >you'd considered the actual logic you were touching was correct. :)
>
> That wasn't the point of the change I'd guess (although
> it's from 2009, so who can remember :-).
>
> >Hm, so what do we do? MS-FSA seems to indicate NTFS ctime has pretty
> >much the same semantics as POSIX ctime:
> >
> >2.1.1.3 Per File
> >
> >LastChangeTime: The time that identifies when the file metadata or
> >contents were last changed in the FILETIME format specified in
> >[MS-FSCC] section 2.1.1.
> >
> >Let's see how many tests complain:
> >
> ><https://gitlab.com/samba-team/devel/samba/-/pipelines/1272333543>
>
> Yep. This is the right thing to do going forward. Let's
> see what breaks. Remember, 2009 was way before we had
> any good time tests.

Another test to try is xfstest generic/728 (which checks that ctime is
updated on setxattr)
and xfstest generic/236 (checking that ctime is updated when hardlink updat=
ed,
where I originally found this bug)

--=20
Thanks,

Steve
