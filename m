Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795086008;
	b=BtAZNsLgTEJiAVwIvUqcHGyzd8LjER5JnCLX7OKCemMkhUZS/qZYaaKPfyysY1KuYMgx
	 7kg+jcWSdZCzIO/RznDKs/OyUyyPRzFdzePllVZ6cesKPYwjIwRr4oiDbRXC47ERGsrbx
	 b8qjfpkuvoS9Cbg1zPYN91Ad8JvxSxQ3/wrlicgpxUUw09pjCk7SRN+5yWQ0o2k3yYi49
	 aummLyJTSyCLPdMbfR2ZScp7VxVkaukUV80CRi/vbKz+CRWa3kArMQNaXnnnB8BcYkOIL
	 +ufEU/rCMb1H8b7BgPiZ+sFH1ygoE/m3+sfJMh+ditRchUlSu0bANoRGLgsxdtAAPjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795086008;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ehxq3Fo4IWGleEOLFlOfAcwBczNox+3O15mlg4g6/oM=;
	b=aGNzcpI1VQLmjw0DtoF+XalP2g7RHlPIajYnkhUJYcS9mGPpzId/oh+Dds4K+z9ijHK0
	 j13Bd7FT/GBi4ohRg7QfFvCLth5idWuOZhye210EQqD9OfPkAgCRW9HePFxs5SJ11HhXP
	 ljTXckJP9PRDpJIfuchvtz8zrgdh15ZIaM9TPLmCBNVMaTIw0tiBjpGVeK1FBLijNk5E3
	 gZYq1+NBCpSqcmlogN8amq6dYj3tD9xyVsN0SSbfpitaCxnTJg9ZVrOw/pmUdGppzL4pp
	 YqnVQz7h/s7yu2pc/fh+V8HFoSyc15qPAdvsnMkDFxQdpMWvh7MNiBPOMLbDJhfsJUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fHBGuyGE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178CC606A330
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 11:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fHBGuyGE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9551F000CA
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 11:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795086007;
	bh=ehxq3Fo4IWGleEOLFlOfAcwBczNox+3O15mlg4g6/oM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fHBGuyGEKuT9Wss/7/77iBLgCvq7+eb4GdZK+OfK2PqFVC/J7y2RV1grHUNin8Lsc
	 pCkeF05fefLv56FEtN0xVNwQ/lPXTto/H8D7p67PyYIkt7DDa/K4+AChvFEWOtOfo8
	 IiVUylVuQdCyRVzqr74vYYBg863h8GtZOL20blfsUCRJlpjYTSdckMegaC+JxYn8oz
	 rzBzdlPeJiSdLIeWnyGZ38YcalW+pSj0KD4zgaTrgD6h0Af2k5cn2N60Egapo3H1tl
	 2pD5/QFtSDc0+BsBvCXO8q6PMpYPSQx5ucttVXDSbSO8d70tHosc3HAV+cZpMWIJdz
	 yDmgOhsTcP5wQ==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4682977f9aso272888266b.1
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 03:00:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHhutKemiCFEH1ZNzBF26hNREQoAU36f+FbSW3PbCj6ccfsTUJNTmTf4+sgd8PBJtVu3FD7G5XHa36X@vger.kernel.org
X-Gm-Message-State: APuU4Z/eqpg4MKvyEiFDfErokcAgq6DV+3t+6TBcgTZHj2LZRqiTnnCD
	26qjL+rXW3TkjE1p2ZK1Ha8+iVmGvazP8EzNB+Aagc3gyQL74GVECmm5Us7rHndSLDkjzENTeOR
	UjFlvDm3wXa3bUhVYqZEXMKG8I+F3vAQ=
X-Received: by 2002:a17:906:4fc8:b0:c46:ba0d:3728 with SMTP id
 a640c23a62f3a-c510e2d705dmr557796166b.18.1795086006487; Thu, 19 Nov 2026
 03:00:06 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118155818.70792-1-icb@fastmail.org>
In-Reply-To: <20261118155818.70792-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 19 Nov 2026 19:59:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Kv6QUtSPYz4nLM6HsOvp5-LwbmPyBF6v1GJVs6uNLSg@mail.gmail.com>
X-Gm-Features: AclHuK93O6MFCXQuhlW_-4JSIczG1qLVVIMo0kb8FcxG233B2QMwxDvYBSkfS2Y
Message-ID: <CAKYAXd_Kv6QUtSPYz4nLM6HsOvp5-LwbmPyBF6v1GJVs6uNLSg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: rate limit the log for a failed security
 descriptor store
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 12:58=E2=80=AFAM Ian Bridges <icb@fastmail.org> wro=
te:
>
> ksmbd_vfs_set_sd_xattr() logs every failed store with pr_err(), with no
> rate limit and without the file name. A client can make the store fail
> at will. It only has to send a descriptor larger than the xattr space
> the filesystem has for the file. On the ext4 filesystem with 4 KiB
> blocks used in testing, a DACL of 86 ACEs was already too large. Each
> SET_INFO or CREATE that carries such a DACL then writes an error line
> to the kernel log.
>
> When smb2_open() stores the default security descriptor of a new file,
> it logs the same failure a second time.
>
> Log the failure with pr_warn_ratelimited() and include the file name.
> Drop the second message in smb2_open().
>
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
