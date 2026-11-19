Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048686;
	b=Paa9LG0i6y3GyHWyk1frcphtjtj24n9NkC9EwU/qB+xk0Hyo7qINPGlbzFld03P0l06g
	 hkn0WUXaRZX7SdHOC7Jj/J9mHSizbtaVM3+SAif8JqdLQRBthLKOEly68y6o+BNlJwAan
	 DJfRmM8NWsWJ9D8ee2F/d8quq/qZ11eLAjI5thii4OaQM87ftfaylVZZ6t/kEKzdeH6dM
	 x1Fnavu76ff1P9pfpJHvmiAzgtoy5Kfno7igA/fVyGtsbx63bipmiaC1PRRT0WOEL8STs
	 2RCRosj2psBBA6HQOAJpnazWLHG4nqi8UOnnAFou3SKZ0VqVPHpInHn9o8L2psdJBYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048686;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=PtNQN5iYY+jY31+2PAsZJiMk/VcCexNZzkbg/hmJWTs=;
	b=Zjl+SxCmyngEe9kFTLB5C3SB403GzCxVlCVOBCnlIn5uEZWbgsOKhACZrAP+YcQp7wEu
	 QD0iVB/9CLWWVOM484ynv8OGlKLQ2iXZ69QDTOOL6n+3aSY4anwJEOl+5BkzZE+owvvzJ
	 DxpP+mHhUUFhTXwYcX+eHostJzKoHOb7aHUcV+ixfZQWLtJSE0vZ9wJc9Mm5jN+kgWiG6
	 1TUSRFpSnLA2TPiIHK9ZKeV/1ECV1TOeO/cFCdM3UNqVm931OFMpIcSI/zoOS25cc2gqZ
	 HYuWb+dScpHTGMMDlRSP406ttuFHKXuHiO4lYkcRbqkq0lnrXm6ZqINE/78Rjix1ylQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JJWSzLfr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA22606A32C
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 00:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JJWSzLfr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D571F000C5
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 00:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795048686;
	bh=PtNQN5iYY+jY31+2PAsZJiMk/VcCexNZzkbg/hmJWTs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JJWSzLfrLWZLBh+bEY0S4ycyK9l/DjHDUguV84PKMcPNyaeevfvpGwjeP5NMi9c71
	 iO1zRMc4UNpYSZkasBAbCngTGqNTi6rJFXgWvtRq2s8zFweQezKoGi+adSu3FXCJ6O
	 Jz2zEwZ5MpvW8GBWHGmgpbcp4rFbHt5FGxPTYixIUfmHWnFt1Au65Knobt94LrSEPq
	 OBpFWYzlhRjvHuF0u8FwPAw53oZZ7YBYF9tAksGmXgb9jk+TO5LUqz1kmmCgQoezRx
	 OtPAjoCfGE1+4hu1Qk1FjFpPlcPfQFYdasd9AECJnfzFloDA6WQMdZa2IRDCpktwWn
	 yQv6f181rk53Q==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4cac7a7d3cso222353966b.3
        for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 16:38:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHGHhszqaA5ezvogkqPHF8sJVC5lPr4GF6aQ7kbOPSDRE8frQfL6NNHPDPt0DBrt7edI5qXeY7/Gxit@vger.kernel.org
X-Gm-Message-State: APuU4Z/VuJ/ED20AYvjB++n8ZQ1onjaAi2ot++nSYqCogjJ/FRH3yvda
	vjRmmUqg49mI4mxmoKshtWz9qzn/yHYnrM6IKQwibFAuIssAJAImAo0/jyZR8v5j0X2VOBgt9Tx
	1rO+ISMIFLMsAEI/nYURSLbAl+zSCUtg=
X-Received: by 2002:a17:907:2d0a:b0:c42:4750:8d49 with SMTP id
 a640c23a62f3a-c510e19f1d9mr421000666b.25.1795048684847; Wed, 18 Nov 2026
 16:38:04 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118173454.76416-1-icb@fastmail.org>
In-Reply-To: <20261118173454.76416-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 19 Nov 2026 09:37:52 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-KFizCjxU=qm65Aw+3NYoMWGHZhuaJ_7G5w_+4jFp5MA@mail.gmail.com>
X-Gm-Features: AclHuK8obTmEl6pbQBPLiW6u_HRdn8tgal2Bb23iPchjtvXRpFt8tnpt1hRJ6bo
Message-ID: <CAKYAXd-KFizCjxU=qm65Aw+3NYoMWGHZhuaJ_7G5w_+4jFp5MA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: allocate the security descriptor reply at its
 padded size
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	manizada@pm.me, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 2:35=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> smb2_get_info_sec() allocates the security descriptor reply with the
> size that smb_acl_sec_desc_scratch_len() estimates. A compound response
> pads the reply to 8 bytes inside that buffer, so after build_sec_desc()
> the query fails with -EFBIG when the padded length does not fit. The
> estimate is not padded, so a descriptor that fits the estimate can
> still fail. A query with AdditionalInformation 0 always fails with
> -EFBIG. Its reply is the 20-byte header, the estimate is 20 bytes, and
> the padded length is 24. The client gets an error instead of the
> header.
>
> Round the allocation up to 8 bytes, as READ does for its data buffer.
>
> Fixes: fda9522ed6af ("ksmbd: fix OOB write in QUERY_INFO for compound req=
uests")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
