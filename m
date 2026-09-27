Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD8F2D29C8
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 01:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790472315; cv=none; b=NpMHN7serGlUylrNZmkb4bUKrnbQrk+SVF3pR1UapxiJnY0ny5atYBmcGmIH+fxEju5HliXuFTPP23jsmodDYgessSbuqrYbvmn8L0c9OC9wRqcrJeNvmF7W6lyK55V1rg9Bn2J9rMeTXUBozbenBgvWO9mwgYMLe0qOdFylID8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790472315; c=relaxed/simple;
	bh=sBLlI4P2MoPu+/uxfU9eouJ8ppcz8Npmf6B2lH48vvs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JLhwUcI/jnCQEdjDBF7c08U2QpjomR2+Th8v0MCywclcKoTc26zjdtJQJCzDIz/IjkjuoDirVhOCeUXN5LM3/M014guatee6Ach0XBbtqSZUhLAUjSqB2Etv9g/HDuuGqYnIZULie0eysc5HiVm2/DLuGTHhhDxINSkeOzkuKHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MeUmZHYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MeUmZHYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48AE1F00898
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 01:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790472307;
	bh=sBLlI4P2MoPu+/uxfU9eouJ8ppcz8Npmf6B2lH48vvs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MeUmZHYObczLgIVoUk0u24iFfpiMAi0oNeokac+pj3GFsvsNjs2QFndW0wfy2jhS0
	 biEBxv/18rr0maF3ZfovS96kWxU9tYDmFh6cMD8H35hCeduXjQKxeLbPlFjufIWFSz
	 FfBVxdjn+YT86vOwYrSNiKGXm1Xbuq5HRf6TJaS5NSEgyvPNJfR6SpUIdEKOtGmun0
	 H6Ytmu685940IDIzgK3Gml25lVH91iUGE+swyIqtkeeMsJKyr0R4iQ/7NkZVbyvtXf
	 KihfZkVy+BsyadDvQC5zmsMKFaGqs2K7XJ2d03L34vU4P4gik6y+VVs+IayFWi9AuC
	 phb1nowAsa7PA==
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aae90f528fso2794793a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 18:25:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxTR3XW6zo36tM56doBjEya4kBRZEUkQusJUD9wQl8vZPMX0TEUIMvTxa2XtSrFZRD3Ss4abVNszwdz@vger.kernel.org
X-Gm-Message-State: AFuF++lDBDiJKGJ03CGuJetXbiVVxTeqr4U/mHwUpicECEZG0nj29v5/
	fWTxf+b8QuEgHZ9N8uAiLK5Ns4/tBYgE8SHpwcTHLm/HH8J6m46msvWua0cYEIaDtB5ahIZJDwX
	FeAWvd41VeJfxAjaVx2pThBKJY4TBimY=
X-Received: by 2002:a17:907:ea8:b0:c25:8bf0:36ef with SMTP id
 a640c23a62f3a-c2ac2409273mr826144266b.14.1790472306396; Sat, 26 Sep 2026
 18:25:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260925174623.1640482-1-zhangdairui@gmail.com>
 <CAKYAXd-3Q3WboGm=s=t-BYf_t6HgiGLTm8CboLNUsEU1VvBzMA@mail.gmail.com> <6fa542de-3008-4f11-9923-b6f7fbdd24b6@talpey.com>
In-Reply-To: <6fa542de-3008-4f11-9923-b6f7fbdd24b6@talpey.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 27 Sep 2026 10:24:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8yTKp5nh7Mc9_Cw9RY323cEZF0EAn6uc72AJS4mOaaKQ@mail.gmail.com>
X-Gm-Features: AclHuK-FL4iorIdZKJULFY4HtteJh0IhJLucpxR6q7Latr0ZUY4BHWe7M3RaSj4
Message-ID: <CAKYAXd8yTKp5nh7Mc9_Cw9RY323cEZF0EAn6uc72AJS4mOaaKQ@mail.gmail.com>
Subject: Re: [BUG] ksmbd: no check that transform SessionId matches inner one
 on encrypted requests
To: Tom Talpey <tom@talpey.com>
Cc: Dairui Zhang <zhangdairui@gmail.com>, linux-cifs@vger.kernel.org, 
	Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 27, 2026 at 9:25=E2=80=AFAM Tom Talpey <tom@talpey.com> wrote:
>
> On 9/25/2026 4:45 PM, Namjae Jeon wrote:
> >> Suggested fix: compare the transform SessionId with the inner one
> >> after decryption and drop the connection on mismatch. Happy to send
> >> a patch if that approach sounds right.
> > Thanks for the detailed report. Please send the patch to the mailing
> > list and me.
> I agree that there appears to be an issue, but it may need some more
> analysis of MS-SMB2 section 3.2.5.1.1.1.
>
> This in particular.
> > As I read MS-SMB2, the server is supposed to verify the two
> > SessionIds match and treat a mismatch as a protocol error.
>
> MS-SMB2 does have explicit requirements that the server MUST check
> for equality (and drop the connection if unequal), but there is one
> SHOULD attached to a behavior note stating an exception that doesn't
> seem appropriate. So there may be a document issue which should be
> resolved before deciding.
>
> Some of us are at the SDC IOLab in Santa Clara this week, I'll bring
> it up with the Microsoft folks here and report back.
Thanks for looking into this. I=E2=80=99ll wait for your update!
