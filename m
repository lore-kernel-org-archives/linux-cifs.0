Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793242193;
	b=RQTrepd9yrse70AubfIhUn6dEC2B7BryQldMCr9EWtaToxImexJc8mSTTAFgGyuyrJi9
	 Gy2V6/YjTWK1DMpQrhqpMNXMsYLfw07A6HJ2ZWNE0kx/NLYJl091uhrtcGQVFei2UJnpR
	 TUho+6MDJfkT4HaWkWF2lVeDAJfT56nEPW+QQe+3PyuFw5SlBUUIw1UokCa5Tk3SDtpCQ
	 MKrFus174UidechjLELkj4VPVXc3/t8AgKvUctQhNnEGmcLv49awyRvbDcyqdNmR7lKmH
	 ljHmIwWcyQT0lPnX6rveysAyteU792u8FAdzp/I9jUhPt0rzmNpHvQDuQh42akrVzEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793242193;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=JId6uBk9aYq0Mf2gdl20bnvfJVHQCFd7na+LV0uLZ5Q=;
	b=YUlJ10q8i9L0g50eyIwhQ61duHGNi22VyTukEUPed3VbFabZW6/sZ3crSmkPh6J7RAj4
	 zsDCWq2ZrAz/5EKD6zaJdcItYT78S4GPfGn8c+f+yeQrYRONHzxqoWDxEwft0na4OFPct
	 Ux9V6DUzLe2JVPparreWqC95ATxtal+V+thmPpHPs6zRZ8vSumJCyV6ghMzcQpIhTYqPc
	 PRDMg8Pt0LBsu3JBhVUVFphaOtb8ljSWgXsvos8VTGhLs6lszarH4kEhC+bRO6Npd2gcU
	 A5bZQ+/JJf5i6BVmvgGM4MPq2nvlmQXPfemEGadfdbqgqTfRmINYa/09Pp2/wmQlA9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iqrcViW6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE070606A31A
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 02:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iqrcViW6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E151F031E4
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 02:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793242192;
	bh=JId6uBk9aYq0Mf2gdl20bnvfJVHQCFd7na+LV0uLZ5Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iqrcViW6QMFkXV++QBl6D0RJ1Own2kpWc8pYU+XpZ1iriTfqwbTSBiiXaXjMjGyrc
	 JPuBiXLOWHQMkup0wt4XXcQ8e8vF/0/HuU5GRcgzI9NQvWJkZfoPR9tlLPrwkBhTSz
	 ok0LaUqj4UmGoEIQEWddgYa+z7Y8psRq0jBTfnO/kyjVgZ2GFwgkI1uzqfjeFAx8f4
	 9Q0Gz1Gm+DNJZuxEq59zLiBjiNbchwa0vQuPD2FnyB3mU7x/IHsuvODE0Nb4fRuuDb
	 Tcz7+DRA7hmsxPutP8wcTVNlY/BM3SYJMDAwjuuOQAF9LbI9M0PLvu580OA/GyNF2l
	 NC+u43CoxE9IA==
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-67990a45e02so1965993d50.3
        for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 19:49:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBydGh0ziBg/8Gp/GySuqUJQNPVgXcDxTXaG6Ww6iHIdW198n8bDdeXz+Tj0cfWBcgxg4ynT87NdH2Tm@vger.kernel.org
X-Gm-Message-State: AFq9FYLFo2IKsHKiTJ9Q1u+LceWNvIaQS7p7N868dnMlgTHrcG9BuN0W
	XzlOfBeTLaGn4w7g0HQaJSbN69q1f3VC6u/6luyv5x0wB70N6noLYtw90x96X2Cl4hoNeN3iCMc
	roAbPsQ/zEAvnlhAH3w4jo3GdyqRZb8M=
X-Received: by 2002:a53:c712:0:b0:679:a959:2507 with SMTP id
 956f58d0204a3-67a7bd3b4b9mr3064245d50.45.1793242191766; Wed, 28 Oct 2026
 19:49:51 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028153441.184701-1-icb@fastmail.org> <CAKYAXd8PwT4aaFgUg82NYZUB=pFNasL2QN7TGGpJVaZjFXCuSg@mail.gmail.com>
 <20261029022039.224864-1-icb@fastmail.org>
In-Reply-To: <20261029022039.224864-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 29 Oct 2026 11:49:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-pRY-2aWy7vJwGSwVXL0=qadU_MA=K+GjtRkLcNBnOgQ@mail.gmail.com>
X-Gm-Features: AclHuK_d8MuzdKlzIG4ps_XWszTxNssGg7CnIdjq_8sWubyo__a0XLuRAHGpTaA
Message-ID: <CAKYAXd-pRY-2aWy7vJwGSwVXL0=qadU_MA=K+GjtRkLcNBnOgQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: enforce the DACL permission check on
 delete-on-close opens
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 11:20=E2=80=AFAM Ian Bridges <icb@fastmail.org> wro=
te:
>
> On Thu, Oct 29, 2026 at 10:38 AM Namjae Jeon <linkinjeon@kernel.org> wrot=
e:
> > This patch causes smb2.acls.INHERITANCE failure in smbtorture test.
> > Can you check it ?
> >
> > failure: INHERITANCE [
> > (../../source4/torture/smb2/acls.c:1054) Incorrect status
> > NT_STATUS_OBJECT_NAME_COLLISION - should be NT_STATUS_OK
> > ]
>
> Thanks for running this. I can reproduce it with smbtorture 4.22, and it
> passes without this patch.
>
> The inheritance checks themselves aren't what fails. It's the rmdir at
> the end of the i =3D=3D 1 iteration, which the test doesn't check, so it
> shows up as a collision when the next iteration creates the same
> directory.
>
> In that iteration the parent directory's DACL is
>
>   ALLOW CREATOR OWNER  WRITE_DATA   (object inherit)
>   ALLOW Everyone       full access  (no inheritance)
>
> so the new subdirectory ends up with no ACE that grants DELETE. Windows
> and Samba still let you delete it, because the parent grants
> FILE_DELETE_CHILD. ksmbd doesn't have that rule, so even a plain DELETE
> open of that subdirectory fails today. Before this patch, the
> delete-on-close open that smb2_util_rmdir() uses skipped the DACL check
> and got through anyway. This patch sends that open through the DACL
> check, and the check denies it.
>
> So the test is right. What's missing is the FILE_DELETE_CHILD rule.
> Reverting this patch would just hide that again, and reopen the
> delete-on-close bypass.
>
> I have a fix that treats FILE_DELETE_CHILD on the parent as a second way
> to get DELETE, like Samba's parent_override_delete(). It only uses a
> parent's stored DACL, and never looks above the share root. With it,
> INHERITANCE passes, the rest of smb2.acls and smb2.delete-on-close-perms
> are unchanged, and the cases this patch blocks stay blocked.
>
> Would you like the fix as a separate patch on top of this one? Or, if
> you'd rather not keep this one in ksmbd-for-next for now, I can resend
> both as a two-patch series, fix first, so they reach stable together.
I will revert it in ksmbd-for-next. You can send v2 patch to the list and m=
e.
Thanks!
>
> Thanks,
> Ian
