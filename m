Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795475420;
	b=KT/gYHluXJfHeFrl8lZeOc9yzZdatG1DY02yFyzht5618UNqtNOr5f00BInIhAhnzCf8
	 vHpscuaNjBXxJOvayUskX43aknaJIv3dqHm2LRYcswoZ42rk2b+DhdkO1Use6tjbo1xhm
	 /JWb4gupKNu0m2YAS3rS05EWDuPj1audnx+h/U5YDGed+X5oiVxiWj7wS+vm6kv4JCSgV
	 /RpHo6BSH81S5B0iyH37fLTVcc+cLH2wAl3yxKrP9/xXtn6vlnNZtdAu8TIo8B0f7Hodk
	 OTpKYI9mo+IZG62FpKRWWQAlDZ5pAd+6hYDIvz73hPAJejeH+5Rfi1HJWr26UJfZNAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795475420;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=UweiNxwHTgAt8ftm1WMDIgqwHu2JV76yvvj/0FyLrMo=;
	b=I+zsiLvXkG8d1lO6MVJgsKCgmSXUjeIJPxCVRlGpKQQYC6c617JvFm4Cvx2k9QrZLDPN
	 KyqAyawmtuQrOI0SzMq5bgbPQkVH3neADu6WTzYstn3hFG/bjLBTNJgYq5nawD60UYSs7
	 iuJssx/zTbzn8JIrg6ixCBGqbSVtl78iPT48HCdAF362Tc44yJ2E1VnOg+r8NK+F/Y8se
	 d0hjLZfwmqfQJM2e+kj2yvg4XrRfIlWahkVWCN5unOszT83BKwgzFU/1k2O/9BRIDXfBL
	 KOgP9UMB7NOciYvkFF1TqW6YqH4uXjTev8E1iS9lSNv2AQKzD4/Q1PsQueqtiwj96fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F6y8YQb5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A697E606A330
	for <linux-cifs@vger.kernel.org>; Mon, 23 Nov 2026 23:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F6y8YQb5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1581F000CF
	for <linux-cifs@vger.kernel.org>; Mon, 23 Nov 2026 23:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795475420;
	bh=UweiNxwHTgAt8ftm1WMDIgqwHu2JV76yvvj/0FyLrMo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=F6y8YQb5R0H+K2Hc21etiJHUrZmNS+nLZiGoMeKkKHhnodKkyiYrJAoy6X+D6qw4e
	 sl0MmY2vl1ChwZWCR7loPrRpUO/wCtRB+1lEdEsdgUHn8VQvrgr5NQ41lYZ/3tsR1R
	 4D/h0B4vKLBrfxa9yxCi5v88NGqY4V0j9KD3FNGp5e9vL1rsY4g4xR8hcjAFgsxCZr
	 GKiTGc+P212g+2GBWKvSk87IXfqVw+zk7hMAOawxvyP7V0lh/ko7euaCnt366i1wkm
	 IoUt7dh1BrZSd8X09rNS5D1r0FZ7kUyUhjB66e9rnNx+V0Ibp7oRs/rVxSdMM7uWTY
	 H9oR8Da4FB1ww==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6ae305e3bd9so6550969a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 23 Nov 2026 15:10:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEUbAUIyAbxpj1Ko7HAOe9V82IyEWjbqmxQOS83gwDyxib8ur9+mDssPpOn1lQ2PlQ0yFcQ0V6+gSd4@vger.kernel.org
X-Gm-Message-State: APuU4Z+ffKqdS2j7mXfazEI/ck1O0TeCzJ4c1I5aJKZYK1w/hdnk8uI1
	HQnkZ0GfvmgFyebuOoib4N1yfu7VhMw3O3NTCqPL7kjjOR3J/K5vQtvoF03W9t5V/MhVRBIniGf
	ym9Qmt5u/HA/REDVEX+Vpww3Byqdccuc=
X-Received: by 2002:a05:6402:210a:b0:6ba:4bf3:4a7 with SMTP id
 4fb4d7f45d1cf-6ba4bf3066fmr8378296a12.23.1795475418624; Mon, 23 Nov 2026
 15:10:18 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122160149.403491-1-icb@fastmail.org>
In-Reply-To: <20261122160149.403491-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 24 Nov 2026 08:10:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_4V=XDhnkMgZ7AyumGW+x86wxMwP8Pk-04aSYXYeHreg@mail.gmail.com>
X-Gm-Features: Aa3M54pmdqZ2Mt_rbU3GRlwVD6xqCo0bkVzkOT0-8D6p05zezDl8vNMe6n1NLTA
Message-ID: <CAKYAXd_4V=XDhnkMgZ7AyumGW+x86wxMwP8Pk-04aSYXYeHreg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: return only the control flags of the parts in a
 query reply
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 1:02=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> build_sec_desc() copies the stored control flags into the query reply
> and clears only the DACL flags when the DACL is not requested. A
> SET_INFO without DACL_PRESENT stores the control word as the client
> sent it. Its other flags then appear in every reply, such as
> OWNER_DEFAULTED in a reply without the owner, and SACL_PRESENT
> although ksmbd refuses to query the SACL.
>
> Copy a stored control flag into the reply only when the part it goes
> with is in the reply. OWNER_DEFAULTED goes with the owner and
> GROUP_DEFAULTED with the group. DACL_PRESENT, DACL_DEFAULTED,
> DACL_AUTO_INHERITED and DACL_PROTECTED go with the DACL. The SACL
> flags and the other stored bits, such as SERVER_SECURITY and
> RM_CONTROL_VALID, are not copied.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
