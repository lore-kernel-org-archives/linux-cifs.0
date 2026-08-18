Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0D0331EB1
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 05:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787032044; cv=none; b=JexXqatWKrZqcRlPqsQN+GB3Yrry0X4KEriJiLLf9sNcPf36/Oq5iJxMHfc61T2yZMKwWqQ2DhG6pqXrTqVlGkPun+D2q7Dar7oyGmy1SmhBNBqrUQViObfqSFD1x/0v8G1GNSJvmMJ/vjD1F9iAI4W168wIUaNyUlOH0zwIGio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787032044; c=relaxed/simple;
	bh=T8cV53EPkMSUWKhLmsy3IommHG5AatzGDsE68psB3Po=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ymic4TbKiB3g08DahcYtBFuWxmdajNGqjEn2krjMc4QihNhuevCMWY5lVsF0CSGPhPwXBZhH3OVofxXZq3+8zfTp9D0+n7qYsInGZHSEuABl/kDeppLbYPXCeEg6xDy4oZpU43ND/B5IHNtgzT7IlAMG/7TDMvn1BddsIdD+jAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IlJHI4sJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlJHI4sJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6911F00AC4
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 05:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787032043;
	bh=qg79qXaLuUb7DgkyXKV7r64neC9E3+KBaRg2Rl2y0wk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IlJHI4sJ2CWqKNylzZ3CXZW+XNXmjo47gM52NhZdvjWde19kPCcYGs1ONOg3udU0i
	 6GTb8prHGPcBhbxwq+L4SJcGogYO/fgkybY564nqkThxcSX0otaONZ5VCbUdlPKtvD
	 iLg9/bMOUH3wH7tL/G8ZIsedXS8jizqzDCEb9/r+JjcENQOM6zJEsOUvl6sbKtSSvJ
	 52QMMsDGo8L9bnQ3Ab7Lt/RS+rPT7cnR2vES4ODaEq/4fqjmqJfS54bmHPMLyztoh7
	 p0oaNdnQmADiNqxqq9X+NIib1n9DOyJuz507nASPiBbqRccYwdwrGKPFN/oKeQ8z4K
	 PdAJziacr+S+g==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-69fc9f25118so4144393a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 22:47:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpwnK5JS4pEwh/gGoUDoCgQ6ucvJ7m2xtZCEP5yR6rcdjbXiMVIgGmAVt4+vls1stFsK+gy135TqWBW@vger.kernel.org
X-Gm-Message-State: AOJu0YyzHwFGGqpQ67ytSi2HcaqCBPUuqmsqay3Lm4pcfvQ/dkuSY84J
	dI+dj+epliK3ocKVsUj3zLlRD/9+2e7VMcpSYTV6NCR1d76XCZRAegA+dgwKqpfqeMZAcbq/G/f
	p0GIXkoDjsohy0M07fGkZuHUSjAJpVGY=
X-Received: by 2002:a17:907:e1c6:10b0:c21:94f7:7ab with SMTP id
 a640c23a62f3a-c2194f72832mr18782466b.12.1787032041850; Mon, 17 Aug 2026
 22:47:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812130152.2861834-1-thuth@redhat.com> <20260812130152.2861834-2-thuth@redhat.com>
In-Reply-To: <20260812130152.2861834-2-thuth@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 14:47:09 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-0RLf6uYZO+yFnF8+gvDX_2AyMMPF75B8XcKL_qSaKzg@mail.gmail.com>
X-Gm-Features: AcwNN1WWGk7Ir-KEWLH6hdoWrOxl-k32iXjQFVBcAn1XokgJkrsden693-WpFIg
Message-ID: <CAKYAXd-0RLf6uYZO+yFnF8+gvDX_2AyMMPF75B8XcKL_qSaKzg@mail.gmail.com>
Subject: Re: [PATCH 1/5] smb: client: Clear sensitive stack data in smb2transport.c
To: Thomas Huth <thuth@redhat.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

>  struct derivation {
> @@ -482,6 +485,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>         memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
>
>         rc = aes_cmac_preparekey(&cmac_key, key, SMB2_CMACAES_SIZE);
> +       memzero_explicit(key, sizeof(key));
cmac_key is not zeroized, and cmac_ctx  is not zeroized on error paths
in smb3_calc_signature(). Please zeroize both on all exit paths,
taking care not to clear an uninitialized context.
