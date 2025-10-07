Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3702E92D9
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 18:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759862482; cv=none; b=WNNUvPkHmNNaHMA9nOK4f2Au7on0MsefYNUkXQQrh21nq5Z2+5edXad0sYoTdHon8rYv/t96QLg9eqIPQBUuuDJjNkPKRib1n7RRpQHLenj2luaq495gZ5mUigV1AizHUxhrlo3RQmeKUVhxEeoSFOy8gJPnp4suogutOPdsinE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759862482; c=relaxed/simple;
	bh=14usrE9rcmwH9BanS4vF2iQdAhBZbHzF121WciBEXL0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PxZdUK0M5V9sc8wbaGxeXkPWKo95WKgZzfCemJ2YGX5Kx//LxqiaMgRACZutSC3vH5mdZcIrHka8V+Y5lowOlddj6Kvf9jdlJFSi6dGC/Q/SE418kErUa7XrgfbvHnVYSqP/TmBLuN5VRuwP46KPFAQziZWth5/rTyB8oW2Hs40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRiiwToP; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRiiwToP"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-78e9f48da30so59500126d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 07 Oct 2025 11:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759862479; x=1760467279; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgixTp66/wF3ZLblegPyEnfFW2saZwup+K1H+9SeEGo=;
        b=BRiiwToPFqpIdT2tutgEU0uZ+uFv+4a2ucVNOOYSkbPmHzo1MtORGFtpi+w55bY8xN
         //7shi1f7fm90ikMuFxVZ3VHCSs7oOSiUlOnQRTEx234CNumUzPPDdKHnoIXU0lfvNIn
         8CthL34yetz5XfjcvN0zuUEYdpryJLXB4lJI0Xgt977QhZ8DoQ7NLoubs+EXlIRz/MQx
         x9WBUFFEs31EmkczI+XTmreqUQDdxPq6W25tIhK2e+k6wjN9ByDNzkZRXUFPaBmQ8fEn
         tvkeV3wP9MAeBQ/VYit7Hjhyt+jMs9JsYR8Rr5ku3MeKh/9MSoYvPvUHvCNkqliWIrzw
         Tsgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759862479; x=1760467279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bgixTp66/wF3ZLblegPyEnfFW2saZwup+K1H+9SeEGo=;
        b=G5E87xx6TNQ9xkMLO/2lh0YTtwiOKTbInZjVGfmcO4trGgevfJA4U9pOhx8nUx4yHS
         34Aj7d6ulY2vvBWCYnJZJRirByzUcUpe8Gf1NK72aEX6fK5jRU+fJiU+a3Gs1aqdDDZs
         xr4roR9C96jtqtWCtYtdZH17HQhgBtTvYW+UoMBWVFW2FWYkK2kSUxPSu5meEgQ4aveu
         FgxmrSqmuEw4YG74Vch87W0+P/nQlA+61HEAGdW31w+eDKybreG1JcTzez9vDy8yi6cF
         Zo3mO0gFYHlQhEUon2HFoVVLQvTA4KNkftVK1guHtYUcXecFNui5REcfzU07i5mbnJnk
         AsLA==
X-Forwarded-Encrypted: i=1; AJvYcCX3bUXcjg82VFN5m64Wo1yCiIT3J6P8YM5SpxoFfRuTtYiKC0KWl0RUM5nFyhWvFIE56paJVtB02Wtq@vger.kernel.org
X-Gm-Message-State: AOJu0Yy67k5qfsq8WalpfnQIolhfxzDhZCMd+DWc4QpSULuYs1tqqykJ
	+or1lBOTxkNMsvY8vOetVCxXG95OeW8qa/Div6hILSq4Po/k1+MQ87VaYJSAxeH1O2nyKGNsVw/
	1/Xz+H/jme62lCSlGhGVchobg9hIbWSc=
X-Gm-Gg: ASbGncuJKy22rs16ptF4W31fYF/T13Qafk0s84qOBtQiFg22Smjt1pgRvWdZGvFBhCX
	LoE8VV3G0FvE3qd/+9CbzpYWbrzeijlMvtONe0NSqKA2ZPI3WaTEiXTJBkN+5I7n7TJGDWfW7CD
	K9Sw5OjN3mzZOwV8rOpX7hbCxCVxSp8gMMz/PLvQLJONVtWVMwdy4GuxN6W0u16vGHIQlzJmpai
	OlgJ0+qw2ocIm6uNugi8myBshyHJuMVtRjzEVSu9KhnRE4f5YF8yEXx66PNtq0XwubclfQ0AzaQ
	eW6d59Fuc+JKHh8Ss1YiFyZG7Itsx+4c9tmSO2/7kWcfZTW9Q74adFzu1tDUV4kxIT+oqsk5HJb
	fF/zokWDDC04XlYbZsdwbIcwQDqym2Wo3kKYkvfdhXeKEsg==
X-Google-Smtp-Source: AGHT+IGAMaE//thkRYv+ZrpKF5RBJeySCJyfuh/WlBoUDmdbdLu2J8HHznMto8B8AiACvjHNGwfsCkFdmIperQb8fJ4=
X-Received: by 2002:a05:6214:2aa6:b0:824:30f8:ed70 with SMTP id
 6a1803df08f44-87b2107268fmr6367856d6.9.1759862478535; Tue, 07 Oct 2025
 11:41:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251007082603.16174-1-wangfushuai@baidu.com>
In-Reply-To: <20251007082603.16174-1-wangfushuai@baidu.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 7 Oct 2025 13:41:06 -0500
X-Gm-Features: AS18NWDX3J4Uc_xYcuVgMqAXVA6vY8sa8xSNr6lLcFhs5hl5VboMY8BBFdwzWwM
Message-ID: <CAH2r5mvws19ho44YJDROdNUy3FtWfxyVE8QcbCTbFJ_VWYNQ9Q@mail.gmail.com>
Subject: Re: [PATCH v5] cifs: Fix copy_to_iter return value check
To: Fushuai Wang <wangfushuai@baidu.com>, David Howells <dhowells@redhat.com>
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, Markus.Elfring@web.de, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

David suggested fixing this line:

 +                       return -1;

to

 +                       return -EIO;

which makes sense to me since returning -1 could be confusing.

On Tue, Oct 7, 2025 at 3:27=E2=80=AFAM Fushuai Wang <wangfushuai@baidu.com>=
 wrote:
>
> The return value of copy_to_iter() function will never be negative,
> it is the number of bytes copied, or zero if nothing was copied.
> Update the check to treat 0 as an error, and return -1 in that case.
>
> Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rathe=
r than a page list")
> Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
> ---
> v5: no code changes, only improve commit format
> v4: no code changes, only add version description
> v3: use size_t type for (copied) and check for (copied =3D=3D 0) as error=
.
> v2: use (!length) check for error condition.
> v1: use (length <=3D 0) check for error condition.
>
>  fs/smb/client/smb2ops.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 058050f744c0..ac8a5bd6aec4 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4650,7 +4650,7 @@ handle_read_data(struct TCP_Server_Info *server, st=
ruct mid_q_entry *mid,
>         unsigned int pad_len;
>         struct cifs_io_subrequest *rdata =3D mid->callback_data;
>         struct smb2_hdr *shdr =3D (struct smb2_hdr *)buf;
> -       int length;
> +       size_t copied;
>         bool use_rdma_mr =3D false;
>
>         if (shdr->Command !=3D SMB2_READ) {
> @@ -4763,10 +4763,10 @@ handle_read_data(struct TCP_Server_Info *server, =
struct mid_q_entry *mid,
>         } else if (buf_len >=3D data_offset + data_len) {
>                 /* read response payload is in buf */
>                 WARN_ONCE(buffer, "read data can be either in buf or in b=
uffer");
> -               length =3D copy_to_iter(buf + data_offset, data_len, &rda=
ta->subreq.io_iter);
> -               if (length < 0)
> -                       return length;
> -               rdata->got_bytes =3D data_len;
> +               copied =3D copy_to_iter(buf + data_offset, data_len, &rda=
ta->subreq.io_iter);
> +               if (copied =3D=3D 0)
> +                       return -1;
> +               rdata->got_bytes =3D copied;
>         } else {
>                 /* read response payload cannot be in both buf and pages =
*/
>                 WARN_ONCE(1, "buf can not contain only a part of read dat=
a");

> --
> 2.36.1
>
>


--
Thanks,

Steve
