Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049568;
	b=aZ/iEWkIlaFm1vQiFoZzh/YMmfdNbNkugk0m3H3jCig+5cNX8X34b0nWax4EFJC9TZqm
	 zeO/wPET6ovLPX/8uEM1xy63kob3GSG0AK6bC0+0LcEMXj03ZiyOJx5gD/WwPNm9JihMb
	 3bmvGiGsb3EdIKN+n0Q9IbZij2B1G7jiZS0OLKJKXtnuCn54eGUp6tytavJ0Af8/s3PKi
	 RifsuMiqtTimDBctzWUDytmAUKt83gp3apf+0B5UzPNDRjUhTs+srNbzs3mTP6p4UD4kq
	 MkLcc19EXr5pf/4vrTnDqtIiFCXnf83H5AxBuRdg+U7ssG1bRgQnwdfG1SNGkvY9yPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049568;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=3fqxcRA59nGG2GFaHTxSrJALKfPpvhTXvqIt6jzDVGQ=;
	b=17XjAAmH0ULhtBzaZwiz3gUrtDG0s2TmkeBVGHzla05i4613xjIi4+OxuUX9d1tPVsFH
	 iojZisBOCeJXBUD1l4xuangMZRXzMQi5mu+4EmCnUeo8KtMirkk5iXlXlBc9LJtMjAMVN
	 TnG9kNFPYaC/lBx5q12/OXujAckwH40280g9vOFVnG2XtGqhAYeF2KSftjOJnKacKEPNF
	 4Q+nW/w/9gGTyqrmQoTHwSV/CerNvSC3IbSRDi2e2HocFWIswh9pW2OkeqmeYm/+wqD9+
	 FIjB4UJ34GPxhahTlMyXEexjaXQYW9+riLTo9+JIJxx+Fs7Ko3bqufzfF8vfnFIosLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DEA606A33F
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 00:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5EB1F000C4
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 00:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795049568;
	bh=3fqxcRA59nGG2GFaHTxSrJALKfPpvhTXvqIt6jzDVGQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AbxgtOSe8H5zVOQqseLvd6hauju7xcjsA9MMWd1u1ANcmQoP9da5w7EeEBSjNDxfy
	 X+mOhSJUDZtbGbRgHG+dDvdVlubim5OC5GPCWX0n+yLdoeFZB75/NaHp7zS5uZ5UF7
	 sPPn0DLO9zBorpMAF9Tsn6+iyETmZ3ZS03AxEBKiCJx0trJVxavfjAwh411/MuaW1I
	 Yy5xvqODqAXf9NiPci/wn3qS1bvDAVMpoPH7eASO73+zYWPG3JOKMsxkZQjRXNFcIP
	 96HVRyUfJL3239fBf7qj9YrSH3FST1vsf4K/Y6tex0/9gjhxoU07iwqwCvlThs64QN
	 J0+1Q1DbCGCOQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c4d5b2db4bbso103282466b.0
        for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 16:52:47 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHdH/RdyNNxjMqqj/l58Mgoc8hpZ8JWY77V0ehTPQKEIphNRIZ61477s42sn5Qp1hKx5gDqREB9MQmJ@vger.kernel.org
X-Gm-Message-State: APuU4Z+Ni1FeP40H0wfHSn/LtKMIEEFvEVNOKfkgEqRcSlh7iU8npS4W
	kviAap3MYeKhFoXkPMv67a8JK47X3DNZP16U1uUMIZKHGFhsUlMDKmcxAKMhtbVYPeVLGMLloAn
	IxTgSwvZZkPVQaBCMsdqmVHGW9qUc3lE=
X-Received: by 2002:a17:906:7306:b0:c29:4b57:503e with SMTP id
 a640c23a62f3a-c512b4373d1mr21641066b.1.1795049566753; Wed, 18 Nov 2026
 16:52:46 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118155521.70611-1-icb@fastmail.org>
In-Reply-To: <20261118155521.70611-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 19 Nov 2026 09:52:33 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9=4OfQ6HESrMFhuffHANTWDjYyrt9VDQpBFdV8i4Mi4w@mail.gmail.com>
X-Gm-Features: AclHuK9fpIXSg-K6iwftVqFnqQORnobjsfqgoT_nBWRu89S49TH0_lVl20XZ0Hw
Message-ID: <CAKYAXd9=4OfQ6HESrMFhuffHANTWDjYyrt9VDQpBFdV8i4Mi4w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fail SET_INFO when the security descriptor cannot
 be stored
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
> index a87c22fa9a6e..3770dda2b3ed 100644
> --- a/fs/smb/server/smbacl.c
> +++ b/fs/smb/server/smbacl.c
> @@ -1984,7 +1984,14 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
>         if (test_share_config_flag(tcon->share_conf, KSMBD_SHARE_FLAG_ACL_XATTR)) {
>                 /* Update WinACL in xattr */
>                 ksmbd_vfs_remove_sd_xattrs(idmap, path);
> -               ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, ntsd_len);
> +               rc = ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, ntsd_len);
> +               /*
> +                * The CREATE context (type_check) stays best effort because
> +                * the file exists already. A filesystem without the xattr is
> +                * not an error either.
> +                */
> +               if (type_check || rc == -EOPNOTSUPP)
> +                       rc = 0;
-ENOMEM and -E2BIG fall through to STATUS_INVALID_INFO_CLASS. Please
map -ENOMEM to STATUS_INSUFFICIENT_RESOURCES and assign an appropriate
status to -E2BIG.

Thanks.
