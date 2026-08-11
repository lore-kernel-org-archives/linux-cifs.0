Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB95641A77C
	for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 10:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786444327; cv=none; b=D+5TmkDodzK/sGw2PrtOLZPHV6xTdDQd9mpq043wFhoLSeCgGE3DuLk0TJHkKyAKy6OMou3P8sd2fNF0UrpotLzifVRejwOrFsFv6sEgpZ+kgop7KKJgokgX3QSVSDRVYXITMVTfQbFfBD59N3C+351Do/FQlYE7rq226UAe8S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786444327; c=relaxed/simple;
	bh=FdPSroC7ce+kAtD3T7bEB7mVsMeu/ZxDfA2/6aLIlbM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D9TcLedglY9quZ+VkwizKjqG80HgF5M92pjlO528KPSEof0PkyC/xGtjJL4gldAUKUcQ9SOiE8oXWp+NfmOe7LUflYS3c2MWyj7XlumyGX4eEotmed156oJyVvsMdWFiqJWZ0NqyM44qFSZGP2Ntx+n9L7mICuohJjCbED3/Ue0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z51f/OK9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z51f/OK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDE11F00A3D
	for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 10:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786444326;
	bh=tcyjhxwWlllK6qutC+N1y/RvpNtsnXKy2Zqc1iFumV4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Z51f/OK9xgFLpv/lJ0L+bKMm+upU5P96V1h7CeAQDjjpjMaxHd8U103AA+VzPC3eh
	 6P5y+dUKtQRON/QtxH8j3rGTe9KIQx1qpB1r5QFafeJBE9oDs29/Kb0R731f97Qqqp
	 n729WgXRWqMc4orxGztxDYo3hurP6Ysq2daWNf03U9DGLHpk16qEIuj0lKyHKpyeE5
	 e890D24l0Vih+GKYMFtQK/JiiWjCEJFIyFd7j293LyYjb/nB0nRYSARFHlKwkf/se/
	 sWt3x/49ccxxqurVI8cWRCA9stGEStmEaFqtJhjixFZlm3hoyLjyUPd4UwcsEd1fXt
	 HW8sv2YnPSKuQ==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a18180so4402970a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 03:32:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq7ZuVPymsfoa+VLgiJlHGOEK8siqeWTdBQ+BMcU738eE1iyhARSXNSRr1DJl1ekBYTwO/GZ/XNZRnD@vger.kernel.org
X-Gm-Message-State: AOJu0YzVDG8y2cT76h9O8+Td86m1IBpkVn9/oKVpiTNHd23q71HwqypO
	CHWmUcNd4rEYpUgs/OmW//zbP4/ouWV8nQN9cjprFqzdYfozNB6bAyBdDqGXj9QSxzmnF9z0fHz
	ZQlzmUUAzcyeuEh08aV6a+Bu82V/eswo=
X-Received: by 2002:a17:907:d1a:b0:c1f:bda0:a771 with SMTP id
 a640c23a62f3a-c20e60ad48dmr114349766b.13.1786444324874; Tue, 11 Aug 2026
 03:32:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260807125845.1477067-1-thuth@redhat.com> <20260807125845.1477067-3-thuth@redhat.com>
In-Reply-To: <20260807125845.1477067-3-thuth@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 11 Aug 2026 19:31:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_VJH8dFHofy2Jfk2172vDuU+XizXQf06w0oz81F1WDdQ@mail.gmail.com>
X-Gm-Features: AUfX_mx_zSkaoj5nh7WflA2gKP8S9W47Zxrr5Dv4iawiccAXZBlrwDeYNI4JMqo
Message-ID: <CAKYAXd_VJH8dFHofy2Jfk2172vDuU+XizXQf06w0oz81F1WDdQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] smb: clear the aes_cmac_key and aes_cmac_ctx when done
To: Thomas Huth <thuth@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Steve French <sfrench@samba.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index 1143ee52470a7..d23566da2ac81 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -464,8 +464,8 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP=
_Server_Info *server)
>         unsigned char smb3_signature[SMB2_CMACAES_SIZE];
>         struct kvec *iov =3D rqst->rq_iov;
>         struct smb2_hdr *shdr =3D (struct smb2_hdr *)iov[0].iov_base;
> -       struct aes_cmac_key cmac_key;
> -       struct aes_cmac_ctx cmac_ctx;
> +       struct aes_cmac_key cmac_key __cleanup(aes_cmac_zeroize_key);
> +       struct aes_cmac_ctx cmac_ctx __cleanup(aes_cmac_zeroize_ctx);
>         struct smb_rqst drqst;
>         u8 key[SMB3_SIGN_KEY_SIZE];
Shouldn=E2=80=99t we also clear the raw key with memzero_explicit(key,
sizeof(key)) immediately after aes_cmac_preparekey() ?

        rc =3D aes_cmac_preparekey(&cmac_key, key, SMB2_CMACAES_SIZE);
+        memzero_explicit(key, sizeof(key));
        if (rc) {
                cifs_server_dbg(VFS, "%s: Could not set key for cmac
aes\n", __func__);
                return rc;
        }
