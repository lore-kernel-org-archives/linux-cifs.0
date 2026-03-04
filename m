Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548AE17DE36
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 00:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772582758; cv=pass; b=NjIIuKMk7thembHWoHkTVuprlrbSMp+Y/uMiKqyAM1gCA+tQACNA8tLCPNSCnD8NgjIOJkHKcZIf3thHktCyrhusr2tUJsyjhJ45beeru8eTfCkR4JDzD5i0SX3a+Ovwdb3T6DpDm+FViMX3lH05Rz2P9imfKXsGtleVCE4MCNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772582758; c=relaxed/simple;
	bh=nXmEO9LmnbKqO+trR5UXQBshWB5/jKXpBWp7TM0Dh94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=haKpOhJ32qoVCN/cU5VhlDBkx60t2IfYtrbO036XBAAwrnMxfwkb/OuqRVkbSo9fK+UvfXiis20IpJLe7qOt/vh5bSBq/rXTeas/kKd/Hri5NY9wdocftqsmqUGIB/bi/dxjyFwuXu3xzUKuBor+yIcgGSUlUi3DDACNoSL+YyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E625iy/D; arc=pass smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E625iy/D"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cb420f7500so597645585a.2
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2026 16:05:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772582747; cv=none;
        d=google.com; s=arc-20240605;
        b=IN0y++3/8rzvsQP4V+PDgcw78Prennm4Cof8SGI14Ur8TgpyK3HAGIQXlLMa82GecE
         vh50WtxU14DgkV9KxevqNBE72WIlrqZYIes+67jWSTXe9lc1oMi8iehFmcGtOfza6X4K
         b9VPJNFdPfK/ts/s8zlUbSgDwcdNizU8wqTSRrU40IeY+/+SSabQxBpZ0FXdztyaD3Sq
         drvq6Zs1lTj4CHvkMFx4XVGln8rOUB/FgpZ0FdkOMAdsgeNAMNKZG+1QKrfJs2V+Nu/p
         7LJchyh6h67qlru2E0Ir5KbPvZaRD5l9luGlYeV7HjBwJua3PQTIKRiUzPDSd3fh4rT1
         DmVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f2wZEqK79wMzpg1Pn5Tti1GvnwoERllu4E+cdGP0eOM=;
        fh=EguGg28gP+sNk86speHtjXt8btN4ov8F/PL5eO0WaYI=;
        b=exT+aQT1B5CjbmIEhCBsOvBJZ++O6KpsPXUM+RBZFPioClR2HhS8OWCLqsibE/t83M
         CeeZLtkFUqgCEbA03fgF4fmEgUioNNG/vy35Gpf3uvCDxJlbqo5QkUmRtUOPOO65bBWN
         kvWGlnMYhRg5up+pIwNrFQ85YUjpzxcqHC4MiP0F1aXsUhmTHKZhwZcm1kyaSpgnaYl+
         r+CY86GDpKoJZSX557zxAjJymXlEMrQ4Zr1obF0REVseKf2kaeSpL57AKNfy6YDTx7Va
         Vg+CVkTT4tLXs4PwPC5kuxOwic3QM8P7aNVknekYds/+sPul9hQwVIH/7xx5bv2siiGr
         2SPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772582747; x=1773187547; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2wZEqK79wMzpg1Pn5Tti1GvnwoERllu4E+cdGP0eOM=;
        b=E625iy/DwKMZwIAfis2xksC336avtqsjkvlu3WHXsEJBLi6wz1CPPSMfYGKgMQwKC6
         idM1ffxZj+ZhZd/e1BhHvZRygYEnvLP7LINWC0O7lkf+XGqVywjYCuk8iSmx02u0YHA3
         btmJuVf5KLOWpB5q7vH0k4TJH1IhYHOxszp+FUVZrVhTPen7qjMKzJPydX+Jw+2xXutQ
         CxsxQtDd+z1yjQk2A2DRz96wDFzF1sTE/mz1FsbvRnFj5YQnr/0Fv3lCpfNw1QB8Ulhn
         t2MCN2ekIpqwSZCm21opg9G6E/UNDJT3YEZXTHgAkCvliVEbVjfKx8HxcrV1WbKylktY
         Tdmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772582747; x=1773187547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f2wZEqK79wMzpg1Pn5Tti1GvnwoERllu4E+cdGP0eOM=;
        b=pVEI0DQqlIjpxRNvP8CxZGa94SV6FAuWNfPzy+fJLfRveVqdI7GoqMiMWgOCzkrFMq
         +rqCXuMelwhv3Ab5/G6nn0EwF175TXrp5QOq/oN++3UZZB+CuS0myUpL65DyHpDnA68c
         7eE3Wl1JrAeE9QjO3SNeYZIeFVR94so51FE3pPD/QUr6K0tiY7aaXO77v4sgrBRNa7Ks
         C1S965bSFQN6h+EzLtspB0AyXAOnb6FIbbXvTTg7JjkhhVEBVLJ+mDdLC69KJDPJ8MCU
         13pJWEMqMhkci41f9dQyIl2bbVee2rgEVc+Vo1OmYEy0a0MRdVSI/SqHSGT9ra33wkty
         M+8w==
X-Forwarded-Encrypted: i=1; AJvYcCWm77zCf9oLy9gaBMOHBxlFLwUvAc002wND6tWfXSKooI/gsb90qs352vqrPEWkAIdWAXUNYzSvQP5M@vger.kernel.org
X-Gm-Message-State: AOJu0YxsQFJCMZ8KWSDXy76YQsjL7mcfJmfmrQnelrEylsOYXZ69+IcI
	ggglMzdnB3Jq3HUI9hPwMyYlITVROKSShe/ssFG6+/Oqsf6AdtikC/0mcCbzBcEzJlwHEyOYY7c
	P4+aFd0zaLjVdSTRsFtepgqWTRz/6lZc=
X-Gm-Gg: ATEYQzwtdXfmrBpOPnezLCpY6STN1hi0xwy91BQfomaU2QL16pXDbi8xN0KGlzhol3j
	k/eTNevBkFtMGdTBvTY//YNvbiFcRUB1qzokfUk6HgEd50UUUVXBYcHC3+tQk9qrITBQhCNnkLR
	clBJN/8TxJ6IoCfC7K0VqQPJHv0dAFUEXUZe5qYXaYPQma0GgNMwf/u2MKUaQURPRqAolb1Fxb8
	jnjK+bLU/LNJQxnpCg1NdPOby55EPU1m2qe0tOBNIIuBWXh9TdIPZEsVe+A34s7yZTjPINxVyfT
	V4Ka5prqZIDtXxU3e2wEdm3qaD6ZKK2skRcrUi49JlbKJv1qvMU6bY4mTYWikLd3V34L3vAvoG9
	XuAejxoZSiCdJw9Ov1iWtzvjByuWU5GfSRfpsfT025oUAjYlB0DHVf57Tgg/IFt0UcT/2+DRnx6
	6I0F3tH8jg0u9inuD62Wnayw==
X-Received: by 2002:a05:620a:280c:b0:89a:2f9b:10d3 with SMTP id
 af79cd13be357-8cd5af0386amr34106185a.30.1772582746868; Tue, 03 Mar 2026
 16:05:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303151317.136332-1-zhang.guodong@linux.dev> <20260303151317.136332-4-zhang.guodong@linux.dev>
In-Reply-To: <20260303151317.136332-4-zhang.guodong@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Tue, 3 Mar 2026 18:05:34 -0600
X-Gm-Features: AaiRm51AXEip8OYo37caTHE91cf5Jkot0RaLNlNRwo1mSLvjYhi_qZYKSXYKtso
Message-ID: <CAH2r5mvoXiK=q7UPoqfjshRXab9ud_d-v-v6RJYiGM8AHQtHCw@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] smb/client: remove unused SMB311_posix_query_info()
To: zhang.guodong@linux.dev
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@kylinos.cn, 
	chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending more testing

On Tue, Mar 3, 2026 at 9:14=E2=80=AFAM <zhang.guodong@linux.dev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> It is currently unused, as now we are doing compounding instead
> (see smb2_query_path_info()).
>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2pdu.c   | 18 ------------------
>  fs/smb/client/smb2proto.h |  3 ---
>  2 files changed, 21 deletions(-)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 8a1fcc097606..c43ca74e8704 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -3989,24 +3989,6 @@ int SMB2_query_info(const unsigned int xid, struct=
 cifs_tcon *tcon,
>                           NULL);
>  }
>
> -#if 0
> -/* currently unused, as now we are doing compounding instead (see smb311=
_posix_query_path_info) */
> -int
> -SMB311_posix_query_info(const unsigned int xid, struct cifs_tcon *tcon,
> -                       u64 persistent_fid, u64 volatile_fid,
> -                       struct smb311_posix_qinfo *data, u32 *plen)
> -{
> -       size_t output_len =3D sizeof(struct smb311_posix_qinfo) +
> -                       (sizeof(struct smb_sid) * 2) + (PATH_MAX * 2);
> -       *plen =3D 0;
> -
> -       return query_info(xid, tcon, persistent_fid, volatile_fid,
> -                         SMB_FIND_FILE_POSIX_INFO, SMB2_O_INFO_FILE, 0,
> -                         output_len, sizeof(struct smb311_posix_qinfo), =
(void **)&data, plen);
> -       /* Note caller must free "data" (passed in above). It may be allo=
cated in query_info call */
> -}
> -#endif
> -
>  int
>  SMB2_query_acl(const unsigned int xid, struct cifs_tcon *tcon,
>                u64 persistent_fid, u64 volatile_fid,
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index 881e42cf66ce..230bb1e9f4e1 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -167,9 +167,6 @@ int SMB2_flush_init(const unsigned int xid, struct sm=
b_rqst *rqst,
>                     struct cifs_tcon *tcon, struct TCP_Server_Info *serve=
r,
>                     u64 persistent_fid, u64 volatile_fid);
>  void SMB2_flush_free(struct smb_rqst *rqst);
> -int SMB311_posix_query_info(const unsigned int xid, struct cifs_tcon *tc=
on,
> -                           u64 persistent_fid, u64 volatile_fid,
> -                           struct smb311_posix_qinfo *data, u32 *plen);
>  int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
>                     u64 persistent_fid, u64 volatile_fid,
>                     struct smb2_file_all_info *data);
> --
> 2.52.0
>


--=20
Thanks,

Steve
