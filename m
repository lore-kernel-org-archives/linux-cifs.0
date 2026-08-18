Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CBA385D86
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787039305; cv=none; b=pXf8zYAFuPuiPQXq0NuI6V06uQj0dQ6Iuu3zWBAZFW7XxtoBOiek+WFn8OH9XuPGX4dqqWfZRtQpl0nYCwkekBbkf7KxGdosKAX61CplN/PmO3TlwIaNAu+TNkAXqoptHRsefC4DoreWRaMRhBopgDE55+X1TKeEXlXlfvzYFis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787039305; c=relaxed/simple;
	bh=y8Z+VNWx7adawMpjR+uHXaVd3uW12KF3Yv3eqI+HRnU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=We8kLGrLMwwZqGCsdeqbNltbLPlEgOmSMAEFJPM+tka5HOic6wSgGXfV831Y/kVwTjf4OBTDXERx48zjMH/mGBFUGevcWXAPo26d+yg+AOiiubMBp48FYUFLWqX2aGEMx9x1+VnRhVDXCw6/1G8XmOd0DxWoVbqEbzNkmprvW6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j06RfwU2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j06RfwU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1211F00A3E
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787039303;
	bh=BNv4fsjJl8E9LblXmHd2Gz8L1WWR9+noq+nOBM+836E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=j06RfwU28rB9L0NOuM9mw4UcvcAof8UKaWliX/IQ4rsShX24etg2BKkfEXpqia/Gq
	 EBsaErjITKxDidBGHBvwhVQam672ivvsT/DNCByw8We4TRBr2pIpNCJOtzyq7VrxJ+
	 QSgvgIsLttMrmdX89hJ43pyggN7n1T+Gg0Vumj9T5whhQaCEdfSzs91SFOtG2Zh6oe
	 XnBoh08qv+oBiery9XFQZclj1w7qLnk0NGj2ASE2jiUIM2sRJgzFacZd83smuEAcJh
	 8nIv233ETFKAxoCqA0X7zoeAFvqAHFLpi8H6CxX/5aHqS1SPG7kp4GpCpNVIiGW9i/
	 9i7kAHVrZdLwg==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a3819e8be8so1450363a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 00:48:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpk1asK6gWkijYa4yfieiJeKOuKWjsYDlugA3JXDXfRGsxLg99Y31gCj9vZHBxFZZ9xResnNIW4Kk04@vger.kernel.org
X-Gm-Message-State: AOJu0YyTRNu17PTDjWRCJSQeMV+O3k+VwZw1rd8QXzdBn4gl0798/Wlk
	IhvR/SZs4fVqZeDhnm4O7KHFTO21zOZwXC/6TkUnqmdSR7LwEqyDVBN11ewmrJCep50jTormkVj
	L7j0HKyZxoC/lrJidTB9RLsnTxvrD3SU=
X-Received: by 2002:a05:6402:4548:b0:6a3:5685:703 with SMTP id
 4fb4d7f45d1cf-6a3e827e600mr1673593a12.3.1787039302385; Tue, 18 Aug 2026
 00:48:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812130152.2861834-1-thuth@redhat.com> <20260812130152.2861834-2-thuth@redhat.com>
 <CAKYAXd-0RLf6uYZO+yFnF8+gvDX_2AyMMPF75B8XcKL_qSaKzg@mail.gmail.com> <621b2dd4-fd61-4af8-b855-be6c82065acd@redhat.com>
In-Reply-To: <621b2dd4-fd61-4af8-b855-be6c82065acd@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 16:48:09 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9UzvYgjrOWe1QFe5HBXta3aeGwpksaDFZCwKHhkNtLeg@mail.gmail.com>
X-Gm-Features: AcwNN1VKFtgHsOOZl1fGZzAfN5GyhDc__dtN5ISUV4tTmQiO6vHOwWQCCyV47yY
Message-ID: <CAKYAXd9UzvYgjrOWe1QFe5HBXta3aeGwpksaDFZCwKHhkNtLeg@mail.gmail.com>
Subject: Re: [PATCH 1/5] smb: client: Clear sensitive stack data in smb2transport.c
To: Thomas Huth <thuth@redhat.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 3:27=E2=80=AFPM Thomas Huth <thuth@redhat.com> wrot=
e:
>
> On 18/08/2026 07.47, Namjae Jeon wrote:
> >>   struct derivation {
> >> @@ -482,6 +485,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct =
TCP_Server_Info *server)
> >>          memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
> >>
> >>          rc =3D aes_cmac_preparekey(&cmac_key, key, SMB2_CMACAES_SIZE)=
;
> >> +       memzero_explicit(key, sizeof(key));
> > cmac_key is not zeroized, and cmac_ctx  is not zeroized on error paths
> > in smb3_calc_signature(). Please zeroize both on all exit paths,
> > taking care not to clear an uninitialized context.
>   Hi!
>
> The cmac_key and cmac_ctx have just been handled via the new __cleanup()
> functions, that's why I did not add these to this patch here. The patch h=
as
> just been merged:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D2b240733f27c8dd7e192f36540a10dcb88339222
Okay. I will apply this patch-set to #for-next.
Thanks!
