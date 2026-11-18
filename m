Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038816;
	b=3FCPexNFSsgcJtDlFVENscd/whRMLS/Q+KmcdLwY/O9DhPYXo/dfOLtcxfIK1czUykNQ
	 oRyNuQlZs7PAsJWVVdKYw3d4AKDe4DAYFEdS7sksldIhgjrAWMiWeSQresgk6bJej/n8B
	 6Hk8sHwotfekSKBrAEvWEuE2Hok8xMt5ieT+46SPazqwv6sCN6amrkKggEeQyetR+71B7
	 YAKg0OwAqQv1M2TgDKW+Mcj2pLN+9pYyXtSTe4TgBlQv+mmKNUWAVFpve/RTPR9intMyA
	 Ld/ermI+TWO4WCxozRb44wDYVjVWjGZiyEmaW8SkLMRi0T/PiatfhjdFzbFAzCvcpTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038816;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=MdGg7b7rxhlsTJTeV38C/+cZfx3rlg88OB46RTb00Rs=;
	b=SdcHa2LeKBwC40NrKSB5mdw+6xlnx8ql3A9NZ3IdM1OGb23DHw7lg5krQ1vYrvcdmfJk
	 c18ShoRV/NBnpLyqwdkk0iimg8G6BCeYVWFd3qDP9OBo0pR5qOkG11cwUQDM3d+0b0AKM
	 i8sgKp+bBN492V5Dmyr21EvEnAY0p1+ihzcIdGq8UNIpyNeQyRvgFHW2Bllx//G2PPBd+
	 6yWc9085kq/1zY1Ox5F9eLifyb/hUhjP5VmMblmfWFDFThvWOITB5cxYKi1PTrPCuoM2E
	 i6LKL7IebLwDuCC10BiyV9WXRKs5Ycps/IGYh6AYW9leUaQ1BfqJzvTulzeSKiOpGEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WVJOd6pD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE209606A320
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 21:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WVJOd6pD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D211F000C7
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 21:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795038816;
	bh=MdGg7b7rxhlsTJTeV38C/+cZfx3rlg88OB46RTb00Rs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WVJOd6pDrmsWrQOJCOEgCWSLmfIoPidxmraVEPFoHOHx2WOzTL3G4tIGJ6fK5D8Yb
	 bjykPCw70Qrf6yC6P9ENM0BY1UUUrjMLWvYQsAB1nL/eKg3gnV3OyBhLsWZOMdla5d
	 qJ/TK8/s0Ce1EXaWQWjL2LWJfcjiNTdUSdlsxX6Njh/7zqy7p4cMqCdRJHTRyb5L15
	 RHPnhWQu6ATQpqmfmYNrkjxkcIqGa5sIGg46mnLESklxIOc1yRmkqSfuufE+Jal451
	 sBXa9uTbCsST7rcCvexctmO8Qt+gVZ9svPkPw5vF3ENpqtTu54bqSNHIyZYTEPohNb
	 nvSxZz8AqB9xw==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c50e26763a4so237467566b.1
        for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 13:53:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEkdM+uYWrazb1v1xFQeiu/3VThGm2s8IRdzeyiYNicfWJPjup9BxC7iOBEaoOQLYvqX1QDspvIMnW+@vger.kernel.org
X-Gm-Message-State: APuU4Z9k1zi3/7hCbk4JGaWz5ZvGsemYIf6FGVnxtMDJ2ML/yqU+WqHw
	oxmfHU/mnx/JaohQVQ2akDb33CKber5R5XKPcy2vC1o2W+xtXcrS/M81ootiGOD57Vgg92jNOPl
	h+58IH+KvXi7ZT3N/iMRy+/EIfGtFuSo=
X-Received: by 2002:a17:907:3d10:b0:c31:5bb8:4b3b with SMTP id
 a640c23a62f3a-c510dfd72b8mr372753766b.2.1795038815384; Wed, 18 Nov 2026
 13:53:35 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117145005.2638107-1-icb@fastmail.org>
In-Reply-To: <20261117145005.2638107-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 19 Nov 2026 06:53:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_4G3K1dbOrX56FFhGRcmk5vb=BNdqMpjTVbjY2NWOemQ@mail.gmail.com>
X-Gm-Features: AclHuK_FhTDeCkHXhLhFaARSCJM09EedOfHEgPt56CjNCi-eFOuqKduFq79lGjE
Message-ID: <CAKYAXd_4G3K1dbOrX56FFhGRcmk5vb=BNdqMpjTVbjY2NWOemQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: do not log a stale security descriptor as an error
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 11:50=E2=80=AFPM Ian Bridges <icb@fastmail.org> wro=
te:
>
> ksmbd stores a hash of the file's owner, group, mode and POSIX ACLs with
> each security descriptor. ksmbd_vfs_get_sd_xattr() recomputes the hash
> when it loads the descriptor. If the two differ, the descriptor is stale
> and ksmbd treats it as absent. That is expected after a chmod, chown or
> setfacl on the server, but the function logs "hash value diff" with
> pr_err() every time.
>
> Opens, security queries, hide-unreadable listings and inheritance
> can all load stored descriptors. Repeated opens of a file with a
> stale descriptor can therefore fill the kernel log.
>
> Report a stale descriptor with ksmbd_debug() instead, and include the
> file name in the message.
>
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
