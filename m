Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAD332B13F
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jun 2026 23:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780876039; cv=pass; b=UlwvISneHJGBpAJR6P3D0rfSgdoivUPlRddJNWZcJEFpCaW7KQCt7e4o8tqXyATtyZbUMcwxqets50w6yLV/2tdmoMOQ9yLRjfR2ay+faMYBbXCcIAHC3La3waO1E6jYVTr4JeAourRVk9Z3+IxbMxyI+1BpJfwcmjXoQ5XFVmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780876039; c=relaxed/simple;
	bh=1T2y3x8BkEBOp/fGRiq3NRWHtVfGZWyXuURxoru/qp0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bR+O+z770P3VPNZZqzoKUWWyi4MBoxF+4UDfrOK4wVTq4WgrMuPyttbQ0BZa85p6Gm8freF6y6iVr8KtlbgQ/3dJ5l9lvvH2tSDKUHoFqKjimMe4IuF5wewe0x9MIOV4U7WyMaPcNjI/bBND+jYVJJZWSGMZkhmY4MxE+bvuBgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qmDWOCX6; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qmDWOCX6"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8ce9df49c5fso57723126d6.1
        for <linux-cifs@vger.kernel.org>; Sun, 07 Jun 2026 16:47:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780876037; cv=none;
        d=google.com; s=arc-20240605;
        b=Goi36MFL86Q5pMrC12anCKaPc3lvY2LiSHUj/4av1ORs3wtHeR0k86KwZ9SVCbfsmV
         w9NziVCTG+o8z8AjqSdr51YD8T+XaGrI7fiybtsVrw2ZzuudYA20MwzowlkaTmEGEn72
         vBrAor4xoz3s0RiWpkaT2t7Wo3QOZ1Zv1cC6pGQLHDPWzRrW3W9eQcCyYnKTSfOv1UqL
         088buoqHdcGlkmW1bj7rgdOAkDbJ5rC8GpFJ3sSbbQEW+q5BJ5AqH/Xe2XN9j/JMMocF
         Ogv14siqGB8w94bW6uZbiKWDY0dMu/ePRHVwpOLXs/Hu27WFi5x3s9XPI1qf21VSsIZP
         9jNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xUQu2Crdlwrj3ZUAxAmtQsPwPoQNT+uW0q72P2etE60=;
        fh=AtG09SRQ2B5P5nMU4ea/f2bEjgVYt2P1gDWeGG8BgyM=;
        b=BsqDE9ycNk/dQqTAS/Ya528HqhIuivvBwWxsAMG7qa2WBGGQ720E0R1oALTPDpkNbN
         Qtx3r3Om1F3Q0WFuBuWygz4ipsjFOSaYd8/3DnUA+tGWtF8fbcVPyT+cd1ekuvBS1z/i
         ExAnuCXLkY5SVSPYvGbONqAxfw0bnjrmASbasTk0Dgc2GqGlMLGvG50Bzvv6NQraxuO4
         LArmQhLMnNXbKeZiRnHGZOo9JZHx+HPqkKv1+nsI5kIzTDGQRFd0NCyUZvVIloosYwg0
         yVfFTztkYDEPd6sptS893lXpgqGagUThlTgm7cGPv8+y8BL3InUIeLoGD1Qv/cvypcXZ
         rf5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780876037; x=1781480837; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xUQu2Crdlwrj3ZUAxAmtQsPwPoQNT+uW0q72P2etE60=;
        b=qmDWOCX6MhfUOG0elk5u/Joo3wNs3vPrqrDQ3B0jfehZAmUWLbwoS5f4bVbzTzYGC/
         DbsbVO62jK9JfkfEqyEbn4B8WHs7rWE/jN+oNFHr8ejm6CUmguW+2+6IV698cO2BijzL
         h9cOEnjBC2ybcCMryyZg9P7qM+1qSr7mgxkXvJU+0gGPF+uW48n28VsPNNAXDZFLVfD0
         V5zoQFAHKTRbQqW80M9oIFqXxzF82zoeDoOUMDdGa1JYyvZ6HgGjXH9fj3dqzmp30SgH
         Z+OUU5bbwsO5JqW+BsaymT5Za5AkMjnD0QXHi0zOfmezUFLPRGoLCfKAB0TzZ2ihXGZ0
         sKpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780876037; x=1781480837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xUQu2Crdlwrj3ZUAxAmtQsPwPoQNT+uW0q72P2etE60=;
        b=i+qA0TUI0jMrapcw1UGe125yk7eknuTcSPEN+oO83/fr6Z1L9qRhVp6dSke4bqEP2t
         bUTOSdoaBMg6q9czxyq7BO27gZ3lbHFWmEv2o7OrFpFl6gn1ukDmUxVW+mSGjvK/RJIa
         hRZeIk6scwc3bUVCjoevAXt79DuSVCgGhle8AeN9q49i66l7J7aiWhHb082KkuO/YiW4
         5ZWYcG8TfGhvg+0mg/mlZjIIcSh+MzsYM5AzAM0WEAd2jjHcdvArYITmwSbbTjOvjEvc
         i0OH85wzNc+J4b/FXc7viUusjP4cP1iy1KBrpDJAHXu0peBSQN5HnFj2fs0lzj4oMjrv
         m0sw==
X-Forwarded-Encrypted: i=1; AFNElJ+toJ9Rw2gVcaBU9UGw3P+ko84iKCG3HcGauf4jGHn8VWS1AbsXcHgTHTL4uq0p4zo1PG8EzvvYJk5C@vger.kernel.org
X-Gm-Message-State: AOJu0YxnK49vOC9ixASXp+T3Ans4OMciblxsEx9fuHs/6tswoWSOXgUD
	3O/zPt5lPsPnnAL7SzH0wx2LyK0oAPS32hqizLnxTjrhWJktCUF3vuhJaAuMYQBm1tFaN31F8O+
	Rc9G3xlEeIDV3e51qz1o/rEztIoOMesQ=
X-Gm-Gg: Acq92OGTMsZXLS2qW/pw6Lmspkg62U+hFNuQ8KjmuScA0s5TD0wpSsx/AUqcRIlRWxt
	EsslzMYCdKrWLBt/DKLpVoc2COjwpAIloOPcOFY8gfUS2dH9GmwY6wtbhHHGCibnWhEZSyFy4jR
	1BzEarncgDVzE3zAeb+AFewaGaVidQawUAkZaAu2g2dzq3HCvSjs/JJvoSZkxFTPO9yj7VAXMb3
	gsubtulSuNNO0Nmk1EO+Mjnpz7lwMGrswK/Q5VOPUgDaYJgTXZM4BlZLD5CYtI2ryO8ZVwc1vGo
	Xs89iHeKTKUJJ0la5gBIlguwCOsgqVs4NkimDfmN8gVUEv3C+INb+4B4fhD1Vjrd2f3C0wvQUe0
	frpUf5VNma2AO9ZR/cSYUXRJNrXMFylGxa9Fj8TLAxvyG1BKApM8elFwkIyRVCrEhS720pnTSQw
	ePyHZbeCba8NdoTSfLUxZoUKiwbz/9iNGsDbNoVaCWNA==
X-Received: by 2002:a05:620a:6cc7:b0:915:769d:554 with SMTP id
 af79cd13be357-915a9dbdaa9mr2258652685a.46.1780876036878; Sun, 07 Jun 2026
 16:47:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
 <1aa393be-4f17-4dc4-989d-77b0dc6de09d@samba.org> <01a5f813-1847-4ede-83a5-62bef4dd26ed@samba.org>
 <CAH2r5mubw0zVBO83XzOmhWSOzq6PM5OkP-18Eg+LK3tvoULzkQ@mail.gmail.com> <40942fc2-330b-420b-b188-dafb065d1edb@samba.org>
In-Reply-To: <40942fc2-330b-420b-b188-dafb065d1edb@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 7 Jun 2026 18:47:05 -0500
X-Gm-Features: AVVi8CfsgR71M8_OyFJaDfsWUseuAzQucMqCmi_aTy0ankYijuxqrfUFJG9OVw8
Message-ID: <CAH2r5mvK79MPsNL3PjB_pYeZfOhqmgOd5cRo=Vk+vsa8__jjEg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix chmod and chgrp with SMB3.1.1 POSIX Extensions
To: Ralph Boehme <slow@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Jeremy Allison <jrasamba@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 7, 2026 at 12:35=E2=80=AFPM Ralph Boehme <slow@samba.org> wrote=
:
>
> On 6/7/26 6:38 PM, Steve French wrote:
> >> For chmod() SMB3-POSIX *does* tell you to use S-1-5-88-3-<mode>, so
> > *if* we want some SID encoding of uids/gids, we should use S-1-5-88
> >
> > We definitely have use cases where the client (similar to what you see
> > with people using nfs on Linux) wants to be able to save and view
> > uids/gids that the client understands without worrying about whether
> > server has RFC2307 setup to map uids.
>
> Can you elaborate on these use cases? I guess this involves Linux VMs in
> Azure talking to =E2=80=93 what? ksmbd? Windows SMB?
>
> Fwiw, proper idmapping is NOT restricted to RFC2307. It is just
> requiring proper join of both server and client to the authentication
> domain with winbind or sssd. The idmapping can be based on RFC2307, but
> both sssd and winbindd support other schemes, in the Samba case there
> are "rid" and "autorid" which are very common in deployments.
>
> If server and client are working in this mapped mode, we'll have to map
> all SIDs, not just owner and group, but also the identifiers in ACEs, in
> both directions. I doubt anyone is currently doing this properly across
> uids, gids and ACLs.
>
> I agree that this might be useful, but lets please get a complete
> picture first, think it through and fully understand the protocol
> implications. Starting with a new create context...
>
> > The server may not have those
> > same users defined locally but the server still saves the uids and
> > gids (similar to nfs).
>
> What about other clients? How is it ensured all clients have the same
> set of users, groups and ids, avoiding alice having uid 1000 on one
> client and bob uid 1000 on another one?
>
> > One advantage of having two uid mapping choices (S-1-5-88-x vs
> > S-1-22-x) is that it would allow you to have two different server
> > behaviors (one where the client changing the uid also changes the
> > server uid for the file, and the other where changing the client uid
> > is stored by the server but doesn't update the uid on the local file).
>
> One mapping, ok, but two? No, just no! Let's get one thing right,
> allowing for future additions, but we must not overload the
> specification and the implementations. Iirc there have been quite a few
> bugs in cifs.ko caused by this complexity and keeping to throw stuff on
> top of this pile will only make it worse.
>
> > Do you have a change to Samba server fixing the chmod bug with
> > modefromsid?
>
> It's not a bug, modefromsid is not relevant in the POSIX context.

The example I tried was without POSIX (mounting with
modefromsid,idsfromsid not with posix)
Definitely is a bug


> SMB3 POSIX expects a POSIX backend which has to be able to store mode_t,
> no need to map the mode to a non-native representation for SMB3 POSIX on
> the server.
>
> Correspondingly, Samba has this check that guards processing of the
> S-1-5-88-3-<mode> SID in check_smb2_posix_chmod_ace():
>
>          if (!fsp->fsp_flags.posix_open) {
>                  return false;
>          }
>
> On a POSIX mount chmod() works just fine, just tested.
>
> -slow



--=20
Thanks,

Steve
