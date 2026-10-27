Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793093295;
	b=uPBDK3iziUHqKd7sJKkmXliMQvqpSw8ZlNHf98ww8f4AHr18JrBvP77D/kLcNshZuNqF
	 V3Inni/WyKz7gW+szGasFmZ/G1hdPiMiaTwU6HpRiJY9eHa/Gqmu1nQcIPOMnbHAXVEjm
	 m60ztJ8cCB1f8XsuRwnDLPxaSmV5MisP2FtcSsVIGPMlPjNnZVfi2CcXfc7e33rbvV47C
	 YiG3xoV1m4dtCEQRSSoxlCyro9YbO2TFDsFmqQcD/1U77culq2i0+nmfA3r59BAHxPd71
	 9ptHWtiScbzCry4RVE3JIJWjeGUc1cj8ZuOQVfeSekgnkj8u+9uPE6JfrCV2GKBjQag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793093295;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=HdpV8/8ebIhU1zoXk4jFUfi23O/1u5Y3/kMloldzY3o=;
	b=v+V8jFn7tCDSJkrmtHdpADBqqkdnn2zzMbMYUs/EBh8ecQddHIO7mRlIDWqMrXqye59Q
	 Ejwh6ot1PelQefU26vkB6eEHIIqNDk8TYJzwCNsJBQLg2ARtO0HrcVLvvgup5HTVyqiLv
	 6Q1/rrhXJhQsfytMCCim120pikdzcLspJTLa8TYLCIFZ8/xXOJQ7P4YkE0cMOOBRalkJA
	 rA1cqKZYMJtikEPfuhNZ4E8FJPAO8VHdBd1WrQZKglx0SjB2DajCsefNO5nu8QITB9jLm
	 hQyH76KE+MEh79a9QaFUSKPR4Zn4WvU13lFOv7QRox3hgG0yEAq+0qM3s+aTr0JB6ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QUBb3Qhh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761FF606A31B
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 09:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QUBb3Qhh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A011F031E1
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 09:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793093295;
	bh=HdpV8/8ebIhU1zoXk4jFUfi23O/1u5Y3/kMloldzY3o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QUBb3QhhXF/1sAdgLNkyeIBkfegZ2auDCxH+GLk8G/jkRgMkdJk+HdNEifadd/lM4
	 /u05qFnd7H5zy54uBgARdMPEVVnBwYD3AgZnwGM2PNGlOpIGdcG/bUv0XvRqDbNs2f
	 umdA6Hu09Po2N/Y/rDfSTipeeX0I5PUysZx0TGpd2yWJljSsWHt7SFP3xppQHd+9av
	 KjIGKvaulGuzHFWB5UBuprDsFOvsgz9q3fr9OJzgWNs7sAvUmJ0PvvHCBMLuYQXzVY
	 gQBpDWZoIBF73dIdRGvzKdCcOL8TTsXsp27CkeS0GVB34xwMMhbY3KPnwpo9yemJv4
	 wPGNYce2LWXYA==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c45551fa84eso570561066b.3
        for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 02:28:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw/X/lSsM+dPMp+PAHH70uQM35nm0mv5GwGw9vo6g1HjnLqbnA2slO+2YghIgDQj2Wkok8uAP6A6MM3@vger.kernel.org
X-Gm-Message-State: AFq9FYI0lGB78nA6QIe5hV4LZRoLtNm7lAEy42qFw5hhLrVevW9o08Ce
	516CdIN03ln5o5Vip5IDAEtgj5gba9pxIMqay26iVCTAnE16iar48M38hbrjdbTglm3GtWvO0lF
	LPjJp5t6vqyjGVacwzMC3IOv7dI0nu84=
X-Received: by 2002:a17:907:9711:b0:c2e:8eb7:53dd with SMTP id
 a640c23a62f3a-c46bde23c36mr970710666b.42.1793093293725; Tue, 27 Oct 2026
 02:28:13 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026125541.87507-1-dar1knessx@gmail.com>
In-Reply-To: <20261026125541.87507-1-dar1knessx@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 27 Oct 2026 18:28:00 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-NkB-fDPN-tCLbcFOfbGLQoVE7RSPwYvpZ-BX5mEBxYA@mail.gmail.com>
X-Gm-Features: AclHuK-9hOq04acXPgcCfbFyvdOXqJ2p-mYNoPkIXSRdIeTvt563ht1dQ3pl9tU
Message-ID: <CAKYAXd-NkB-fDPN-tCLbcFOfbGLQoVE7RSPwYvpZ-BX5mEBxYA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: use the resolved share path for the share root
To: Denis Kulikov <dar1knessx@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Steve French <stfrench@microsoft.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 9:56=E2=80=AFPM Denis Kulikov <dar1knessx@gmail.com=
> wrote:
>
> If the share path is a mount point and crossmnt is not set (crossmnt =3D =
no,
> or ksmbd-tools that predate the option), the share root looks empty to
> clients: QUERY_DIRECTORY on it returns only "." and "..". Files created
> in the root go to the mounted filesystem, but a directory query cannot
> find them afterwards, so e.g. "rm" of a file that was just uploaded
> fails with STATUS_NO_SUCH_FILE.
>
> An empty name refers to the share root. For it, ksmbd_vfs_path_lookup()
> looks up share_conf->path again starting from its parent, and the mount
> on the last component is not followed, which gives the directory covered
> by the mount. All other names are looked up relative to
> share_conf->vfs_path, which was resolved through the mount when the
> share was set up.
>
> share_conf->vfs_path already refers to the share root, so return a
> reference to it instead of looking the path up again.
>
> Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d=
_name")
> Signed-off-by: Denis Kulikov <dar1knessx@gmail.com>
Applied it to #ksmbd-for-next.
Thanks!
