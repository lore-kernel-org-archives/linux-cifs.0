Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01D4155C97
	for <linux-cifs@vger.kernel.org>; Tue, 13 Oct 2026 05:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791869149; cv=none; b=O/EhSEi643oHkOnJsVeQ/RvseRTjB4Mw4VhdX/fHtaCgJbtc3gunjV19OHGGrwyks/EAe1Mdgv4Tl2LcdtsC+ywBLhonrbDV1q3iuZog1hHOXoOq4ZCNWQc2ZP90MIx0dU0Zaj9qIOVFr/+Z78riwDUyW0z/WMVxz9V3VS3Ufj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791869149; c=relaxed/simple;
	bh=e7h9DAZ9jHbQxGvAFb/lAiP3ZpPx88/vVWjRYl8WoQo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NLmUmcKrMFKoYRtx4gr7srKoNNA1dVn+cUxopSIWE7uMo5aZmYpEsLWKwZpsAO/finQxqZu2uIgO3PX1BU9UykhXIrJmvOequFfY6WfqW9S+lQg9CbsETk2PI48xgBhc2pMAXMNStrmGwdjU+SlGw0GKZ2D8RigWE0pcLHh+94I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MPjX0j8I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MPjX0j8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9522F1F00893
	for <linux-cifs@vger.kernel.org>; Tue, 13 Oct 2026 05:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791869148;
	bh=e7h9DAZ9jHbQxGvAFb/lAiP3ZpPx88/vVWjRYl8WoQo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MPjX0j8IM8jPjutumYV01obpOfeJ4WB238ApqielTw9dZx77Pe0KUtCHnyd9v26CI
	 02VWvsSt8NF94ML/okBE6iAlvyVKNA7yI+X5yfoZqIeoWTd0JT0SGfkNst4kOygOIt
	 uNDSUVVprqxLKRU3vmGkM1FB/1KdvkWCJtjA4xj/4SiRciB6zUDbnF+9jaX1CCcelx
	 ySii9gnoEbVukZNqzMjy6yNGqXWVqcJqEg6FOOeKO5mLIKRq9OAUqSoqAsmHgJ0WJW
	 dSDAxEbURe0waXS9LjVfbq2L4vTgv3Zga97x/USPQDTmAbj2HmSInLRbc8LUh08muM
	 D6ceZQvpWA/Dw==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a374bea882so3699188a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 12 Oct 2026 22:25:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwNmuUmUMRZRMvU6FPgxmaqitk3oVBJRbiC3PyrIF+NSQVDNLiNpMgOHK310kpZgEsp45Yw1LWwnvHK@vger.kernel.org
X-Gm-Message-State: AFq9FYLyEX0mHFY3LFWc5iW5xnJMbISeVjB4jB43gYs2rcPGliqmdjdf
	y3KF5WMnfAhxXy+gJXIAcXGG0APx921jSQC8jyW1gHItdf1AS730uVSihiUIELpbnvRpK+yK1BT
	rqfAKRwmtHjmsVGhB2XHdDknDkTGucYc=
X-Received: by 2002:a17:907:3fa9:b0:c2a:6c3:9e98 with SMTP id
 a640c23a62f3a-c31aa098468mr1065055666b.40.1791869147293; Mon, 12 Oct 2026
 22:25:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821214722.q7rkflclyyugdxll@pali> <20260825230622.24617-1-pali@kernel.org>
 <20261012141053.4ud5pihrtrxpkxfy@pali>
In-Reply-To: <20261012141053.4ud5pihrtrxpkxfy@pali>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 13 Oct 2026 14:25:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_FP7F1U_ETWx+0QKwpDuEFp=UJzhMjrSmuT9uG3nAxEA@mail.gmail.com>
X-Gm-Features: AclHuK-irOv8qyFoMe7M9j31gFr8maV2gaiTnXJ0icm0SZqBTsQU89DryhSXRFk
Message-ID: <CAKYAXd_FP7F1U_ETWx+0QKwpDuEFp=UJzhMjrSmuT9uG3nAxEA@mail.gmail.com>
Subject: Re: [PATCH 0/9] Various changes
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 11:10=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> =
wrote:
>
Hi Pali,
> Hello, now when is the -rc7 cycle, could you review these patches?
> So if there are any issues, I would have a chance to address them for
> the next merge window.
Could you check sashiko's review comments from these patches ?

https://sashiko.dev/#/patchset/20260825230622.24617-1-pali%40kernel.org

Thanks!
