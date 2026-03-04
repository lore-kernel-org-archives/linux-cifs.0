Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952FC1F8691
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 00:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772582793; cv=pass; b=Hpv2lq1cFOuJTLSysDFHDHKkifXyMmwjGd8elMrutQ4IW/FYIAnxeO5Qkc1V1TO1nU/gPU4kijsoWPTBmCpPzIwA1cu/mme2Y+GgzUWpF+AskZ/A/KldKNfS/UvmyOTF7fTJVOk0BqQkXDP1u9tiEg/X5exBI9AhjC2HDa7sOH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772582793; c=relaxed/simple;
	bh=1fLGtIqE1uqQKTXlctAjg7YGuK4PaDPE4qP1xsTIWIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MizZNKe0DthYWURGfbdzsHKYk/RKv6Gw5ectQeUH5KY81u5h6feUba/OL5CCNaGsh4l3NmVgAj1lwV9VIqPilBo44VyHbn0bNiFRc93fwrpR8T+CHLTw+G7JL2+7HfxIfl2gZnbewABy/PuFY3P0/qDLx/m5wwZ1X5yyg2JKiN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dCNpgx+n; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dCNpgx+n"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-507373bffd9so55863021cf.2
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2026 16:06:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772582785; cv=none;
        d=google.com; s=arc-20240605;
        b=SrWAoVLhhqElqbBHuvULkWziURSU43u0OJ01zrZwhDtX9AcADjqYyalUSw/vtp+5Id
         74VT61lVQD32Qg/lg0WpEgP5Dy4qfcRDu8y9uWmyXMzw09j7s2GA2Ghwqov7w6PGc6vu
         TsRULFiVrq83T2S1Vpk73oiunr4PFodoRhN2tKrqtWqzLbtRRglpD8r7PFpvL2k3janC
         bk+f7PwHDlvdkGbripx/oELV0scv6kYUSbJvK16pNnloLfj7kE460/b3eJKcH5ULOo72
         ckDHqVTBs3hIvc21bI3UIUiVPbnAbScswLS7K+V0NxNhxH9X+nYvvoFalr4UgB0TkASn
         I4uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TCTKBLVYHA014AXS55bXy4TLuWhPqffq18oG2+mIBm8=;
        fh=evySMjn3yIEMpjbcqqojrl/AC/NVuGKGE1Ufhk9aCvo=;
        b=fIwrie4h+fU5CdIWGu8wed8cERztwYRLZljxY6axCl/MmySeRV6LJlAimCBcwDG1yM
         2EqvyKjNz43HX5nJtxxcWEBrfK0lBJnYXmPGQokj7oCf7iEL11uTOD2GgPnmcsDQ2/xx
         ZDuFR5DoEx2NYkEty+Jqt4e6U2Wf49yOpnRq1ActlEOZe6Sj3H2EoDOitskHmctEEiZ4
         kpwTXqAqAh0j2R1nzrAig0qG1vZUNd6oY4bkmaH69vvgho/JPO7UKupVFAlMWgaWIi0j
         nTYEA3FhffZ+BfDCL2k3aF+G3MAzJq12wKFgNZ2mdFY6BNAQvWOMkj4hUzpwDQYfwqAm
         ig8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772582785; x=1773187585; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TCTKBLVYHA014AXS55bXy4TLuWhPqffq18oG2+mIBm8=;
        b=dCNpgx+nOjZvvKlksGdGuxlU6x0hlWjlc/V4Ja3d5HnrzW0LijzS38yNk9avVUWd0F
         lI47kCnlrjfyVLw7qLGfi45+h9kEXgAYzsCtwzeR4a8PwVj5tIcytWVYOZ/+crSW7ha7
         9Ku7avwLvNdS/cLEYEHgIl+pF4b7ifGQiHiheN42B0fsbtWJBXQl/AZmTq94uT7L9/v7
         /U57aPcV5qvMDrWOWOQLveVO64rdIXQHiBQ9apVdhv6bJaTM6W13B3P/LNgqhiwqBjTJ
         MfiJs7F8PGMqQI4rZGyPFq1IJx8eA6OgLeVlD5FKnJnIXr6M6EjWgnLdxwdkPQzKZN+p
         JcsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772582785; x=1773187585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TCTKBLVYHA014AXS55bXy4TLuWhPqffq18oG2+mIBm8=;
        b=SuiD60vme8US/7UnkqpZKCE6JNNR49bz8Zk00qJjjIfS3DQ3H/vAEoLmTntGF0S2Mv
         QK7Uz23B/0+C8mAnUdzlEeWLtdAXJUlmsNTECsmN0SJZjvPAyLrMwCiZMLaFv0uwsYEU
         9b8QS9KHSWjaEmTozgCcu1JF7lqOUXyK9bFNv+LHigu2BqvzuuPkPWNXBO5KJFvalj4q
         9mjTYV05T2IaLptKoTQYU/6QgUAQHuz8MYozvt5q9oxaf7cXhITKHk5rqb+oOmT3tB5H
         g7nMRBDRAx2XVsGhi/9KBS8CeSjiotInGcE2Myq5cmCw03JzoRxLp0CIj2M+G8iwg+7w
         qDow==
X-Forwarded-Encrypted: i=1; AJvYcCUp/jICuX0k7fCF+ezrkcKi6GxLStZsxNHhcGbEwDaSaAyHKRiEY3cN7PHTJyauMhsI6UrRAfIyY1HH@vger.kernel.org
X-Gm-Message-State: AOJu0YwfQlqrfaHqEfrbddA3XYtVN4/dZzXXlS5+P8z4iFFwUHwQWEBi
	Tojh7WmsSNj3ddGf/xhp4MoW39gvcDu9VxIxHSY3A28+ga66UCz3sF4uJHrh1ZTwg2X96qNqZkA
	SM/KaBcUTfMai7jZwSKox8NUFLfJrU24=
X-Gm-Gg: ATEYQzzN+Am1EGuOTd2wKjwJgolj1KDL6zrDAFrhHEX+PMjHmxaqfdeR5uLC/iwcR59
	se5MAe5vT79Hs4LwnMQCGO9OI2CcQOcxd8laIQw4Fqkvh3PK7JMrco9m++TfKToKkbORczMfS/H
	TaiQSuJ+4j1tqTdfEsOmfNQgCCzClhdPmpuQkUSCeF9NA98SBT6BqmZuwk/7k9Pme5AD88ARLY2
	n2Mt5eJ63CgjA1fzpyRDoocb+CN75GxG4IuqkVFkHfykbBITvPMgeeuVaPdsWiKXF/2fZvrmr6O
	HPe/1MQa7xBoUTVBs7SLwlB9DIvk+D8VjxFknjekPyt9+t9ZYh9uyECE/mNxBGRALff4gujKQjT
	Wi1hkSBWpjxVRPuFioc+8HuB5T6I4OljdIkDW/tPBJDnBZQeMJ1JS2p0rqGZGijOhNT8qLUGzfz
	qNpXzXBv8W8khIai+m1qX9Yw==
X-Received: by 2002:ac8:7d56:0:b0:4ee:5fc:43d9 with SMTP id
 d75a77b69052e-508db28bd78mr3776781cf.16.1772582785044; Tue, 03 Mar 2026
 16:06:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303151317.136332-1-zhang.guodong@linux.dev> <20260303151317.136332-2-zhang.guodong@linux.dev>
In-Reply-To: <20260303151317.136332-2-zhang.guodong@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Tue, 3 Mar 2026 18:06:13 -0600
X-Gm-Features: AaiRm53WKgyj2hRWchdydp9cFjeddIUijy4Cqj0qdX5EQOn3N66XLjfo4Q93-Ac
Message-ID: <CAH2r5msdwtxTbWUbdDn89+Lsgy6hD+V_xJzsznkBghMuYHjCUw@mail.gmail.com>
Subject: Re: [PATCH v5 1/7] smb/client: fix buffer size for smb311_posix_qinfo
 in smb2_compound_op()
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
> Use `sizeof(struct smb311_posix_qinfo)` instead of sizeof its pointer,
> so the allocated buffer matches the actual struct size.
>
> Fixes: 6a5f6592a0b6 ("SMB311: Add support for query info using posix exte=
nsions (level 100)")
> Reported-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 195a38fd61e8..1c4663ed7e69 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -325,7 +325,7 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
>                                                           cfile->fid.vola=
tile_fid,
>                                                           SMB_FIND_FILE_P=
OSIX_INFO,
>                                                           SMB2_O_INFO_FIL=
E, 0,
> -                                                         sizeof(struct s=
mb311_posix_qinfo *) +
> +                                                         sizeof(struct s=
mb311_posix_qinfo) +
>                                                           (PATH_MAX * 2) =
+
>                                                           (sizeof(struct =
smb_sid) * 2), 0, NULL);
>                         } else {
> @@ -335,7 +335,7 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
>                                                           COMPOUND_FID,
>                                                           SMB_FIND_FILE_P=
OSIX_INFO,
>                                                           SMB2_O_INFO_FIL=
E, 0,
> -                                                         sizeof(struct s=
mb311_posix_qinfo *) +
> +                                                         sizeof(struct s=
mb311_posix_qinfo) +
>                                                           (PATH_MAX * 2) =
+
>                                                           (sizeof(struct =
smb_sid) * 2), 0, NULL);
>                         }
> --
> 2.52.0
>


--=20
Thanks,

Steve
