Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792544872;
	b=kYSva5pnQVsSkQ8Z8gOVk1w+LZsih9lz9hjKr3WE+/9cgNBc8XHnUWxa+9IS1IyIS0Y8
	 KXgu8XPkEfugT77XV5UJ98eFPUgHUgPi+Zb8Pt3+qNHWr9HVC3wapu51fF1ebQ2bSNMQO
	 LsyA2b8o/3feA20Nsf13Q5stSedZxrTR7DN5mFQpzH2wd8DtbV1oAZ5f12CqC6yQ8yt1e
	 TqHZ/elw24NTN3SxXF+jaU+QVcr49OMgdAxwXZdkGP8UyrbM+Bh6izVfvr668Di1j7ic4
	 HMQzDVJLVNQqdvO1DypyQgo/ehe+ocHbku4ZCHNihwXcAJS8D8OA1Cm2HRui9qxyUbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792544872;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=XMC/JKLmO6GsbdiZMLRSa5NCpQOlGMpsGRIQ+M5+oIo=;
	b=lDGqDH0wF+8NjZP7c9mmgSIpCw56ATm7U88h7HCVC9g5Y8M4vYx1NX/ldIt4QnQMF9pQ
	 qfvhNhrmWJ+ijRXxMaRu9LtY9PSvKR3W6z8n/ZB2jCG7qEXikx06Yk4OZgFTRpdNFa7oT
	 ZMffJC6gLpXX/HAc/jYRk5TW4BkxEpY/otAEXXr+daGVFjqrCt6qcKW3VkHyRqyf0RwXP
	 IAiUYdGH24dJjbMlaKGSWpuc72reD6YUyWcaVW/MUX0V6phb4xt6TTIsiVHYACSyGByey
	 ATh04Q6MfaFZEUO0/IhVfXu4+SCQ43ULAuaoiDUP9sR2loAHubLjJvqOlwLZkNwqMow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B52606A31A
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 01:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BF61F000CB
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 01:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792544861;
	bh=XMC/JKLmO6GsbdiZMLRSa5NCpQOlGMpsGRIQ+M5+oIo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A6g4egyVkvIfeRMzGFj/0XleoEIllH8u0WDTi34CWFe5bPLS71whXNLWRKfdy1gZF
	 Lmp01+B6m805ExLRitei99IbcjU/Qg+Qurb6jB3pz0oNxr8ZITmoaN87jmUnkU5rQq
	 cyCHpbjef3kllYiZ7Nnjtz+x1CQ+ukv19rxgAY+ME3fSLKow7RlTO7miJ0m8XJVTBs
	 34VFYfX26GLSXPc3uyoP/sWR/WWdvALpWU8bxDFYbPY6FuDBkmKNVmLCLbmt580px2
	 xZZREyd4eWCJluqObxiK3UbdBZH5EV4D/BxOipUBBASnp5o+WZWUiKUMH+mCaPyG22
	 +NZHz8MGc+qfA==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c263415982eso14702966b.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 18:07:41 -0700 (PDT)
X-Gm-Message-State: AFq9FYIzkqFp1p/a+W4sKRq6+o0HWMqrb20lo8lcSJ1dOP5vlpQQSwWj
	HGgLlZFGGCqB8ps/exwYge8DOe2Tm7f8qN/6TibUoMWRaA3dWqMW2L1pPbfr0yW7asUpu/S2QPA
	TZjaCLPSMVU7SqhNMR+8579EUTX8eFvo=
X-Received: by 2002:a17:907:9693:b0:c42:9ded:6a8a with SMTP id
 a640c23a62f3a-c46795f0e10mr48388366b.16.1792544859963; Tue, 20 Oct 2026
 18:07:39 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAD37_9gRtYiiKOV-efL7HAaP+_F7CUhv6k-iJhfwnEwuYt3GWg@mail.gmail.com>
In-Reply-To: <CAD37_9gRtYiiKOV-efL7HAaP+_F7CUhv6k-iJhfwnEwuYt3GWg@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 21 Oct 2026 10:07:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9CNgQb0XxZ6Emue_cXWw8YAbmGuO+nk=DVMCKKR15p9A@mail.gmail.com>
X-Gm-Features: AclHuK-2-U9dNuIKJYVW1bdcw0b-kMfroshV1U87z8YoDffsr0q7mmj1JJ86qrU
Message-ID: <CAKYAXd9CNgQb0XxZ6Emue_cXWw8YAbmGuO+nk=DVMCKKR15p9A@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: reject foreign RPC pipe handles on IPC$ read and write
To: Mohammed <mohammed.saad.alquraini@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 3:19=E2=80=AFAM Mohammed
<mohammed.saad.alquraini@gmail.com> wrote:
>
> Hi Namjae,
>
> Patch attached for the IPC$ pipe-handle issue I reported. Tested
> locally. Thanks!
Appied it to #ksmbd-for-next.
Thanks!
