Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793781878;
	b=bE5HCTgOCui6RwJr7smoLlqoVSzpK+m1Y1x1N2Of3yntKC7eA/g3rxJQ66uyqsHv538N
	 4OX9G6rzODX59q5s0jgZ3+TPKTBPaVqfpc3nvU22hrNU3M8JfcfJhEFhIfRyJyBmLt61u
	 sTJRFkGLdLEjksnSZneh6sFEzfcOzloZBht9vggbJbdV2sQHpqx8lxTjEJTF0pCQ6aT0X
	 s56lJjjV9Vyb3EE45tvqXGSyLSs4AtfxXVBAPeAMuz0/iyWpW7L+Yc+hfEfukC1wgcwZS
	 7Tu3zju/KsYz2uvxBRxvgsTE/zMEvATTOJSsETcGRuguSmnYbWm3nKnn3LgCM06QRoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793781878;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=cxrCkQFSuOyT2sjaoiQVObpyFNJLzTlcWOT51iAX9JU=;
	b=fel0Q1jay7UEe6uehGnr+RqVyLbzkIpD6TcBLEL++t1zlSLPHAurqKxKRCg03T3QqLgj
	 IhBB8lABTITjUHfsXiKv7o3CMyTsw6iObXbt6lsxkxtKQEYjl8ErbbvNjoP9neeEI0ECs
	 cDftBwsS0KvrgN03kj8ILxIGrtlY9TB0ey9JvE3dbrskE6CHI/dxx05scbZYd55VEom4K
	 WwPJvtPay+LUi9QCH4E+EpTQGYDL9cyHisrJCgzq9EqI0hcV9vAk5O2ib9/Mt4yH74zdV
	 H2yPeU38GEuvsJbGrxpDk1ARibGUvtAsXdtTt54PMR4LEFFGmyusY66nKh6A/tYFNMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CIq6I7t5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67497606A328
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 08:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CIq6I7t5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446891F00919
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 08:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793781878;
	bh=cxrCkQFSuOyT2sjaoiQVObpyFNJLzTlcWOT51iAX9JU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CIq6I7t5S5XMD0bEAsZoX2EkuwVdeAiipKNIka9NuRteho8hN+h66yqGDXiGcFhwk
	 K92Izf/R8/DgqpvSWOVcYfvZduuikvXnxQcEIeP22zyjtMklRUpKtS+bDQyyGGUBdg
	 //UR/7FB+3EpvuNObicgIm9Y+SXnbFCcrC6JN28+66Pd/AZX6JitIBM/F742pRvvSm
	 z2NbKQ01OwNM2zm89LR+OfHmZ06ViQ5o7pqmMuLjNkEilRzhphmWTgoC4yKlsCBTpl
	 0s04PO0REerS0cvlyg9UWuzDtwKAWv0Djp2DYYZVIadfGizyc0+uW5xbZK5sXCgO+s
	 85Zc/re2KA2BA==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4cdc606b47so64004066b.0
        for <linux-cifs@vger.kernel.org>; Wed, 04 Nov 2026 00:44:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwHlpcUj+RvfLqkh35MBDv5dZRn+Dxv1OUiJQpPxXeT1b4ggYjTYhJZBTqs9p4BWWRYiKcB2C449oAy@vger.kernel.org
X-Gm-Message-State: APuU4Z8EigyYcM15G64d4iPnTGmjtxCwT0ukdZrfL2IWeSUd3EHOmMOU
	trVqBMzJBGvNb7G686W3khClM7KzLXbn2lTXzVc3YN5a8kCxKzyGqkULK3p2nEcwEsonV4oleU6
	aoYjZb+pZItQp+Rb21IT4Cp4Tn9/6cQE=
X-Received: by 2002:a17:907:fdcb:b0:c41:f29:72b1 with SMTP id
 a640c23a62f3a-c4ca7aeb21bmr1310103866b.47.1793781876535; Wed, 04 Nov 2026
 00:44:36 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103150458.11591-1-icb@fastmail.org>
In-Reply-To: <20261103150458.11591-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 4 Nov 2026 17:44:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9xNLn1Nk1QzD_Kep1TcgJmGNsT+UTg6Ed0DjjmRRW4+Q@mail.gmail.com>
X-Gm-Features: AclHuK-JcfuZ648DJ94l5sf55_9ZhNmAEUfsKztm_X1MvB-PgWT_Vi8TDrhO1D0
Message-ID: <CAKYAXd9xNLn1Nk1QzD_Kep1TcgJmGNsT+UTg6Ed0DjjmRRW4+Q@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: grant a caller what its groups and OWNER RIGHTS
 ACEs allow
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Aamir Ahmed <elb12345@hotmail.co.uk>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -1531,7 +1557,12 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
>                 goto err_out;
>         }
>
> -       if (*pdaccess & FILE_MAXIMAL_ACCESS_LE) {
> +       /*
> +        * Evaluate the DACL in order (MS-DTYP 2.5.3.2). MAXIMUM_ALLOWED takes
> +        * its result, and so does a caller that only group or OWNER RIGHTS
> +        * ACEs name.
> +        */
> +       {
Please remove the redundant braces and unindent this block, as there
are no local declarations requiring a separate scope.
The rest looks good.
Thanks.

>                 ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
>                 aces_size = pdacl_size - sizeof(struct smb_acl);
>                 for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
