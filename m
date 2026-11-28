Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795847031;
	b=nHmIFcMKZcz+TDCcJASRr6D9j9c6lQCmlH+iPsEhGeR0kQBAhwzjYom1pp+eVoV6AUIn
	 9zPHqh0rrs9PhcQNcjxneEnm/QCWrfyD6eKVzJN9ubwvI6YNFs79Zv0jAvAjXDeLu7PdY
	 MYywKNtVbYy9Tvc0Z1GuN1sfpCGmm/HhSlqk2MZxKl8zV33YEWyiytwkJWrSGYipbQbB0
	 X0geL/l8BiEBuYbk2e+dndu7FMpgSWTBd0M28u1ktI//8alzYOw3UH1XF4cIaoBryNP7z
	 kjkXAGU2wEBGOyjhSfiEwZjvMdJqXgBIf+DRmJKX3HskP0gxDsfK34Bsh2O8QaJCnBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795847031;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=HP9YpPstHQsS2pBvnT8vtHxMveIHDezOw1ggWURVis4=;
	b=kBriCP9Bq+yOLi143WGyDbtbqTAXEd6hrRSYWycbg4ryAwo5/ORhgsDhNNbL4ZauPLc2
	 K+5r167sS5WXsFopRsx5eXK+RJzLGi7R1GuvKUX0ZkgAcsjITiWMd2txnN/zGayyARaWd
	 /7YPBELYWL3bGX0APUyWBipR4uJX+LM1wMZ9E3NXkWlv1atUTw2IVZMWz1LrF5oiZN3dt
	 ClGCplV4wDwtWNCdpgucG6YJTb8Nys7s/nbgjiSStouaddCC7KGNtD+U0f7M/sGfEiocu
	 coHubLdH6TDwThcW5I9IqHOcyu1+iwVGQ+1PCgXPoHl6enhG5bS5Nfs1DCUvOXVKZXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TnSRteEK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217B5606A31E
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 06:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TnSRteEK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1EF1F0089A
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 06:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795847030;
	bh=HP9YpPstHQsS2pBvnT8vtHxMveIHDezOw1ggWURVis4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TnSRteEKBi5+5l6x1GjVNyXrgUxRIZe5QVUou9H9gs709Z1bR/3IEzKDyxpXg9DMj
	 PfkCCFCqK8McaYtdFK+i65QC0kfZkdfp6HCG5ilzK6pvTrbuoJd/8ZAJL7YDz8Cdxm
	 oJjHU2q7tSdhG1li9xErqhUwzupACUWZNWHlKunc+bgWtp5+2CqF0sOZcPeiVpxGNO
	 P/jCu2oWq2c7xDbA017fiIOtPFu/voQWVn7Fh0nhOrRNGGCC/Gfh8mKTACY3OfKWSl
	 sPmy8jNosVcOAfTokmheER7L/K2cYP5BVytpndhpReBtL6ygZS7FvNlPo7QBfNFsbY
	 kZufn1SDI2aPg==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c5198302d38so719554766b.0
        for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 22:23:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHS3aiRX0hJ9G2cgoBxmhzuDPIhUEswqmh2V8+59rCXoSEFEgi9vE32CXqiHC3ua96w8EvBiOPMGFCQ@vger.kernel.org
X-Gm-Message-State: APuU4Z+QRoWiZAFKeGPBRlsfV3oIm8ItmurIZ6UQysyN/Z3Yl7kiBoqj
	lnLIffmSMRNlWnZ8uuAXY7RhbNsDXSRZl6N64fcpsLIE0MxBzFcX6v+HtGDdn/7k4vdioeHhTYt
	ZyWf/jpM7R40uEooltj++/pgm90q3yGM=
X-Received: by 2002:a17:907:6ea9:b0:c46:645f:cee2 with SMTP id
 a640c23a62f3a-c513a3ab024mr2327095666b.4.1795847029415; Fri, 27 Nov 2026
 22:23:49 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261128013952.1691873-1-icb@fastmail.org> <CAKYAXd-qC2UZbsOUEWvt3mhViwOyvHEqHt9hLK5+aiiuMC-4iQ@mail.gmail.com>
 <20261128031631.1713665-1-icb@fastmail.org>
In-Reply-To: <20261128031631.1713665-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 28 Nov 2026 15:23:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_TEwt3fDdXUme28HK=KcBjkyYiU9xWdE6ZjuqNifBBLw@mail.gmail.com>
X-Gm-Features: Aa3M54p5HaVxjWOJRYeYz-YfvbE3jrdjd7jCcoLAMtPaXx4muAmsAfg2_ifRP64
Message-ID: <CAKYAXd_TEwt3fDdXUme28HK=KcBjkyYiU9xWdE6ZjuqNifBBLw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: return the cause of a failed link
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 28, 2026 at 12:16=E2=80=AFPM Ian Bridges <icb@fastmail.org> wro=
te:
>
> Hi Namjae,
Hi Ian,
>
> Thanks for the review. You're right that passing the errors through
> does not handle all the link failures correctly.
>
> I'd like to propose one default mapping for errors from the VFS, shared
> by the handlers, with the link path as its first user. It would cover
> the cases you named, STATUS_NOT_SUPPORTED for a filesystem without hard
> links and STATUS_TOO_MANY_LINKS. Results that a handler carries in an
> errno today, such as -EPERM for a sharing violation in smb2_open(),
> would set the status directly instead. The other handlers would move
> over later, each in its own patch.
>
> Would you like a v2 of this patch along those lines?
Sounds good, thanks!

>
> Thanks,
> Ian
