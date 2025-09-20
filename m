Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7CB2FDC57
	for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 17:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758389659; cv=none; b=fs26bYzDH5YBCWoD6lyTP4fjwqNALmqeNrF2rkHTWc5P3HP4nN32uK96Ee9PLgVqPa4j8cdkwnhxbB0LeVQdeLXU+pUeHuLTTuCTHVhL3QVTooDTutKehUzZ5JaLvW+FI/elSxYD3rnw3MuGIYbfXCwULiTeErYxMBnDd9npbmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758389659; c=relaxed/simple;
	bh=fjR9JFlWRTflHruCmH7sfe41GNKR1SlUHyHHAaj6RKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iyzuWtjIMzoNCqMPU70txrm0IYfeKvtvh3PxurxZFUmXOWpGmsVTotaexHjvgzSTZf62k66zA66twFLtoZuQkr1Bs5uUNGOx1k673w8m/tV+62WiOcTU+55qA6VcMLDy+fHEGl9Dcz1KeoN6eAq+ysm20C5QUKviIMABlr4kUQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=neI/lwQ9; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="neI/lwQ9"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-80e2c52703bso315329085a.1
        for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 10:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758389656; x=1758994456; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0VO0A7zIqU8xKhWSL8LGrAnldKkVRxERQhWv6Dw/8kg=;
        b=neI/lwQ9nBBHA5efIEry+PbTsRcID/BJSOtUnmg8Q4KTxFhm3/Kyp2RZIGfB9UYzJh
         8bAgP/bOBtMPk6Y1eyLciSsJgFKxbtSkajeNLInd1L3TdW6LAw5MaP/jklvMilGIDLbl
         SPywHLc7hKG3BUMZChbcoy4+D/6vrmEZFkC09afqxPSKF3BLkgzkLg6GoZQYUdkTTixg
         9tK5xopcel11ctUT3XNgoPaL0N4mCvsx9XpVRUliyNCBKJhg1cw9zZQMkxs0F4s+Exin
         doKXyj7roDS2zXz8OITy9ZM5ih96rZdMQbV+bIAuq60Y3f0yh56dscaA0jSSM3Rg3K0m
         FZLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758389656; x=1758994456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0VO0A7zIqU8xKhWSL8LGrAnldKkVRxERQhWv6Dw/8kg=;
        b=wiqCZeosA+kwdnjYe0DXZI3xaykCOndd8y//UjGMP07T2yOIrRtD4LMN8PbPR780rL
         pkeH/YaVJmlKhQzX+RkMNtSKjDboz9jc4K1POQW4QsAV0rBg4jVRc1XBHB+hRxLHH6Y8
         r/dFuw5LRwpuepzlY+ZMTCDdC79MJ8I2RtofvjK4IMFLNIStS5RhogySyEGOxTWd89Wa
         hB8qlX/yPxNg2U7znGs5b8ztR1xMF1RriCGc8ndx2qQpBeNANmWD2KB5LxyNvicRfM4M
         yrx+6uM9uTUzDrah8vHNdX5gFPl7Tfk45X3UoLfHM5OD67wkl3HrhcY9yawl0K/ZSG4a
         fwww==
X-Forwarded-Encrypted: i=1; AJvYcCUfu51Aq7ts60TaBQp8vu4fKMxxTWVe2eo6TaW7ypKZKDbGsphxxPRoDpql3dv7P0giJNA5M3/jo4qq@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb3zL9+ZsFCe6VQeR+BLoEItYDOCYlbuAvo3XhFeJVWv483p9E
	Q8tRxALP5FwBQ+eGycTLroRQG7m2HwUMFVsx3c71byuEhidYHxPVN/+FgQtrVERXPOHRrldrYYY
	KQQ5cDEZlzNF1egZ++trDdILuFEjPtfRLZQ==
X-Gm-Gg: ASbGncuQsU6U07c4s+CYD7XeKiNOoN597w5oWLdTK5idNpt1un1GLNKcuon0/Td03uC
	pucWxaIcqjSRrbgb+ZGA/zj9dseHBUQVEAttvHvbDadv2AvcjqO/z9cRP6U3zxzKj/KcUtGA43W
	UoNHais8b0DE8llSVfTg3BWDKMjYCE9qhDXC8ggW2AeR29ofvplq2PRvRcI7jqJlwLvv0w4X+SP
	NIGcHhylVEzUz9zNCIhEQuGFQgzGmY2LOXtwCxZP36q8HnBerCD88RhqEe+mVCCH3fRTCQ0/mr+
	KGmCe45vESbojY3D1w0kCeRK5e2mQ3vvZcEvBcmJk+7F+VeHANSUkQJ8nDDwFSdbwlGqOtm/FAi
	fNwEe9+ljn6TVc/JC8AiF
X-Google-Smtp-Source: AGHT+IFj+RVGEr/ivtHi7RmHcKrvMcPpE2DZlXW8IOF7Bb+jli7NjwDWdk/qhy2QEe0DOPw3933HcP3Y/3Ps75OVxsM=
X-Received: by 2002:a05:620a:4006:b0:812:ac32:affb with SMTP id
 af79cd13be357-83ba29b5ce8mr999618885a.17.1758389656258; Sat, 20 Sep 2025
 10:34:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250831123602.14037-1-pali@kernel.org> <20250831123602.14037-29-pali@kernel.org>
In-Reply-To: <20250831123602.14037-29-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 20 Sep 2025 12:34:04 -0500
X-Gm-Features: AS18NWASxqdbcjNWSLHLtnvE0gYbw0rjcsQIKcNVkTaxSXs7rmoN24rESOP-ymw
Message-ID: <CAH2r5muoF-OKg9e=T8moEifwJ+RwmGX28nXqgECM891TufqY_Q@mail.gmail.com>
Subject: Re: [PATCH 28/35] cifs: Fix smb2_unlink() to fail on directory
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	ronnie sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This did not merge to current mainline

On Sun, Aug 31, 2025 at 7:37=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> unlink() should fail on the directory with ENOTDIR error code.
> Flag CREATE_NOT_DIR handles that.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/smb2inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index c8b0e9b2438f..c69293fcf26c 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -1348,7 +1348,7 @@ smb2_unlink(const unsigned int xid, struct cifs_tco=
n *tcon, const char *name,
>
>         oparms =3D CIFS_OPARMS(cifs_sb, tcon, name,
>                              DELETE, FILE_OPEN,
> -                            CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
> +                            CREATE_DELETE_ON_CLOSE | CREATE_NOT_DIR | OP=
EN_REPARSE_POINT,
>                              ACL_NO_MODE);
>         int rc =3D smb2_compound_op(xid, tcon, cifs_sb, name, &oparms,
>                                   NULL, &(int){SMB2_OP_DELETE}, 1,
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
