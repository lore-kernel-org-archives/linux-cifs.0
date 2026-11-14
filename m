Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794617053;
	b=sWwsowKzznelf1darpi/D1iWuTzavKXPYz+IRnBdZEPLPMoTk/izNRvc09BUW0/WhttK
	 foamblAOLvOUBi8zW8XYLUSFzKQrTecg3O6yOjgUR+XmLy8LgGxHapa3sm55yat/Oun9J
	 1a9T2Dm55mkuKkBB/Bi3h/lkCDHaCoa0GJnNxwr0YildnsZio/prDzzP/hHtwatu3ecpb
	 B6CezudMr6nTm1zd5Fg+TOXkK80/em2bU/IuqlSoEKr4Rk8ZxRShBZWe1idwteusm4Xqu
	 F4vvjQpGoCLpVXezJJPqkeAhqrz9d5qtaTCGtfl9HK1IB0zP4mXYLXoMvMDAJ11Za2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794617053;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=YmxDCB0txYq55lNE4Q9A1BVGErbr4G/vZzPr5xJTeuc=;
	b=2qevkzyuT6VqimZdaZwptw/CUYiVw5uDac7ZD1Oth3En8PYuzYGRWQCFMq9te+yb8sSZ
	 GzGW88DuMzu3Prv8I7E/NaaW8ER9cmYSfZTgaTFJDYkrP0TWUl+EBY+tOhEjzrQtc0gTo
	 s5jdLpNIBFMoogXvB3AIu97Nvfn4tNuJeZW9OTpJbWiQHRwM1dvuG9+xE86fHYsL0TGst
	 aUoCDQjcUiDJiB3xOjr02BzvWpOyr2OZrsMAXWtOJtHR6Y73QNhp4bbtm+ZAwuRIrIkJS
	 cUBhedyjAObAiQxiW+N/iL2O7tyW5hFr1CmLlFDJQTQPUXc1jgTd425vwGaRGUPbPag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=efWCLS6W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D60606A338
	for <linux-cifs@vger.kernel.org>; Sat, 14 Nov 2026 00:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=efWCLS6W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E601F000D1
	for <linux-cifs@vger.kernel.org>; Sat, 14 Nov 2026 00:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794617052;
	bh=YmxDCB0txYq55lNE4Q9A1BVGErbr4G/vZzPr5xJTeuc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=efWCLS6WUirN00J0a8tqEhSeUf1kmYaBlu5CKQLabsoZGEbXzuqAJKB8TMX9JPNAa
	 Nborg/c2LsRv41LwPsso8Ia3L2VTEPWMxvSK0uIwh669eksi10toY4MA75uau2UFWX
	 SnAxqmzYIO4b/mgXHMC8yzoiH2JiLPj+55wglkGhegvKv4u5XNBmLssyOVv8ssAMkC
	 //JUVNHRa18buo66G5jzjwG8nxgmWx7GlEoquRGmIwyEfnCmMYYAi6XVDeDq7yuZqu
	 Zr061TZStsia3PumpHtt3v45aDbv5QJ3G9CDcOQ/ewrLw33oprzmhYWqdb+l0w8EXh
	 4D3TTrX9COKyg==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4395d31228so319228766b.1
        for <linux-cifs@vger.kernel.org>; Fri, 13 Nov 2026 16:44:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHErCHms9LgPRbUhqP4IiKYJ4RZSHrK7peV6ecjf85JSIhath2mQI0dQ3SoaT1dFRyxwunDV/U2CT4N@vger.kernel.org
X-Gm-Message-State: APuU4Z+9fgDS7vXl5PLKIJj7hXbMrrtVb9d0VVe7+WirNUIG6/zsjK4/
	xrLpPGpxX48GRuayMxAXa/tsngK+b/LQwYA8HoiyEECXgnuMn3YOBXekzMg4Y3owKBUAgnLxUU+
	tUNZ4m2/EqA2wEl+qXDSfwRM0jkEb8lI=
X-Received: by 2002:a17:907:3e07:b0:c4d:4d5b:849b with SMTP id
 a640c23a62f3a-c50963408demr378661066b.19.1794617050597; Fri, 13 Nov 2026
 16:44:10 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261113-smb2-sign-v1-1-937ee7c20f08@gmail.com>
In-Reply-To: <20261113-smb2-sign-v1-1-937ee7c20f08@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 14 Nov 2026 09:43:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9un6yV7fq0oPL3KAxdZqKDq21pT040aZGaGpsxKfvd+Q@mail.gmail.com>
X-Gm-Features: AclHuK-d6sLchv89JefHGOSkJ35jFjOK9BF0xm0q8BhaARXpTJWG57E-KBI5Fw8
Message-ID: <CAKYAXd9un6yV7fq0oPL3KAxdZqKDq21pT040aZGaGpsxKfvd+Q@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fail SMB2 responses with a bad signature
To: shyckless@gmail.com
Cc: pc@manguebit.org, linux-cifs@vger.kernel.org, sprasad@microsoft.com, 
	ematsumiya@suse.de, smfrench@gmail.com, ronniesahlberg@gmail.com, 
	bharathsm@microsoft.com, linux-kernel@vger.kernel.org, 
	daniel.birtwhistle@gehealthcare.com, samba-technical@lists.samba.org, 
	tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 13, 2026 at 9:00=E2=80=AFPM Suyuan Wang via B4 Relay
<devnull+shyckless.gmail.com@kernel.org> wrote:
>
> From: Suyuan Wang <stevewong@hust.edu.cn>
>
> smb2_check_receive() checks the response signature when signing is on,
> but a failed check is only logged:
>
>     rc =3D smb2_verify_signature(&rqst, server);
>     if (rc)
>             cifs_server_dbg(VFS, "SMB signature verification returned ...=
",
>                             rc);
>     ...
>     return map_smb2_to_linux_error(mid->resp_buf, log_error);
>
> The status from the response is returned as usual, and the caller goes
> on to use a response whose signature is wrong. This is the path for
> synchronous requests and for smb2_writev_callback(). On a signed but
> unencrypted connection, anyone who can modify the traffic can change
> e.g. a directory listing, and the client accepts it.
>
> Return the verification error instead.
>
> Unlike the SMB1 fix in commit dc96f01d54cc ("smb: client: terminate
> session upon failed client required signing"), don't reconnect: this
> runs in the thread that sent the request, and only cifsd should call
> cifs_reconnect(). And fail the request whichever side required signing,
> since a response with a bad signature can't be trusted either way.
>
> Found with a static analysis tool and checked by hand.
>
> Reported-by: Daniel Birtwhistle <daniel.birtwhistle@gehealthcare.com>
> Closes: https://lore.kernel.org/linux-cifs/SN4PR22MB28883DAF57E0B4D4BFB1C=
22AEEC42@SN4PR22MB2888.namprd22.prod.outlook.com/
> Fixes: 3c1bf7e48e9e ("CIFS: Enable signing in SMB2")
> Cc: stable@vger.kernel.org
> Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
> Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
> Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>
Please check Sashiko's review comments.

https://sashiko.dev/#/patchset/20261113-smb2-sign-v1-1-937ee7c20f08%40gmail=
.com

Thanks.
