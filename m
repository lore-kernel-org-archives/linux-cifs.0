Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988442D7BF
	for <linux-cifs@vger.kernel.org>; Sat,  2 May 2026 13:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777728424; cv=pass; b=O/xxFnyKeYqYOJ0BQOmlW+2WBFqzQOjpY2CHYF/EBmLVIQnGjjv6s1hiP7Dc9mtKDt8eoiJWRbQ60XySHdQ//8RgwVVjUjHMYZXqaHBysqcH5QHttMqpw0K2xq6x9qjqWi2/QGMVfvDVWUtpj+suADEI2KnozzJtA5+aEcnkxo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777728424; c=relaxed/simple;
	bh=ax+q8rVZxVd5b3oJ7d58OiRhgALzGey32thxe4LddhM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FXjNNHQMVsBc+fX5krAJoL+fIrPt835pAEeb48oMGQQDe/WLhBM0ELTCyppweyYFp7HZNdc4qLLt2yvd1feZG0wq5/YsIvZgMlht59g7CIgv/Dg5lNzWrVqVX6Ex6jVXxRihKtstbqHsa5eFKeSqUGWbXiQxBqgg+r5HTicklqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pK7XQj0o; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pK7XQj0o"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8b45dff1eebso24349976d6.2
        for <linux-cifs@vger.kernel.org>; Sat, 02 May 2026 06:27:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777728420; cv=none;
        d=google.com; s=arc-20240605;
        b=fYzUudzmjo8al8D34zr7LZf7d8HjGreGRXqjCeSwVFZv05r2G46VLzJimI863Vk8DD
         sON30NVD7Wln83ABvG1k4EgPZGZoZyMvfPRNsX1fjGayWkg8R9+Fl5K6QZmBhARBxiXC
         HpNTKgWyvHvJPZFDSts4/uL5mRGbGDtpo1hQnqIB2hIKAUjM/jtdrPnLmb8iHnnFBNTP
         vTGvwFvMnosVyypEYp5s+kGEtPO9TT1kmceOeZWN3cfuVk91w41CdDp2wdTDNRz+BenJ
         h/QFO2Mgi+J08J29kq8gj4m4DKKFrm9VI3mym+XaqprpBWdu4Z4ZFU7d/ofOxkhjiSLM
         CSQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=96mEUW8wN+2bhoRt9GlOUt/xYvY0MYV0pTk+gcc6ObY=;
        fh=perjH9T2uvCI9NAdVjT3N/MWwJxQckoi0KXZ3UBXAsw=;
        b=fXYlDEHxU2FCNgOvIF9ajl1tgE/fdZEcJZ1X8KMlv+2x6nfkkyB9FT6R3udB7dkrK8
         A35kgJin/4z//fePMtkxS57T32fZcWa78r4OZeB2MIWsTnunf4VQATI0YAkKHnX4U3wZ
         VKEiH7eIYZ98vh8Lv60RzDggtZAL6ogLn598/k4exPe76Ou6AV30HK6oJfdCCXrajWQF
         cVF1POuq2NOm5K5TjzOk+4UdeMI7aN/6rUJG8OCCyv5kcgPs+C3lUA3xrnWfdvZKW4eO
         8NaezUmGY6f4p50Q1JEv+90KgPRTPpFHrZN1jUqDghst9hWAzzseewDpxhOTsbW4ekGl
         8jJQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777728420; x=1778333220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=96mEUW8wN+2bhoRt9GlOUt/xYvY0MYV0pTk+gcc6ObY=;
        b=pK7XQj0oK8oC0gvB8T5haAa8GxcnuUKpqrE4STaDtYj8DCB82GToQJsIAUFwbadfXT
         CfuhzaiySG1cgCv/G8Kf6D9+zMuJCauBYbelE2PuovlT1zLLxUJdrdQO+Nc43khIyuTf
         80FJeBMf6x/DTLHhqUeSL76R/hE3nJtw+3gmQbkFvGAvu3KumJx4CdvcSHC4kIx2LgV6
         O4WA3RmrCGa/nQwHY7AbvgXgYW0uTfCMhxwssN5KoG1kvYKu0YaCuhSb0zzIptiBzM/o
         T3MpemCTaDzvm0x2/jffaG98qdBlzOk9XkBhuZXI1AttgHEq00aV2BB4u6d8kFMDBmPj
         YGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777728420; x=1778333220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=96mEUW8wN+2bhoRt9GlOUt/xYvY0MYV0pTk+gcc6ObY=;
        b=OJ9sC9mk9CMn4fhERMEYpbQywcQX34QVxg5yCJZHUy6pK2rRNnGcp5YIzzOAVGu5jJ
         R3sTSgGUSfaKAc1ntDLpBiSCx/hJdc7k05cvcH4IfcTRUv7CoEaikgODKXH3xvunjQe+
         MAjpV2c6EfNJwYoiVyK6+/0KSzntHzDWpZpnAGJbD+qf284AD3kO3yiLLQ1Fs9f4r8zS
         QSTe5PnbE0mU16FnRZCzg392dppl9A+4LFKh4fuwWA6oUmveScTLKcARt1r3C/2cFm11
         EzxCx7XahCa66OeJF6MhwsIuvGT8iz+QK8po+itDWkoRaphsSFFmBJtHoqbBVR0F5OIf
         8O0w==
X-Forwarded-Encrypted: i=1; AFNElJ9Q4M8X+vGF8KiiIfeqhnvC3bJRmSi1jVMDabyiwsFCtBd0BSTiXb4lqPdpaFkpW+DBEkwgr3cgnSvA@vger.kernel.org
X-Gm-Message-State: AOJu0YyiJT2EXCF5rx2nkm/ds41CVwAeoamdN1dvuPYX1ZIQ28mkpES2
	4TyEmfCB3eMY8iwuwFMZUBAA4/Zc1Dd3U08GadS1hEdtQsGk+jk4MXM78OXyQZ/wiL79pN4m4Q0
	/3AFrqLT1Y193iAs4jvkEa5nL/lq14gM=
X-Gm-Gg: AeBDietAmfDFTkN/zUKcs0yLU/iFOiCZRTvNscY000v99SLglkrRXm197tnR4PK6tgP
	vC4MqNe8sLmRjCwM3I6qmFBwLNrH9wUVH6h4yZ9BDuczK1yQmb2nyB8dDR7CxYiNimyXOJrChjK
	yoviPfBfFDRePxn3WDjj+hgbS/e/jSSpwNn0caxPXxkhEMWHZ1RirYPlWSxxm4D1DdcV51MkTxO
	aX+EIFyVnd4wbS5i88j5nU0+3l0pgnJbFJLqNGQ1EANrm6vrIi61P66uaG0XA8DSXBJRpMzh/Hq
	buLwO6seulrIaRw9QNmkV6i5ft7A/F9Mi8OCG8/8GHBPAT+7FJPxTihJNk1ina209FPac1Ex3Oq
	HzljwAdg52iFaFLp+chb1/G/Ef3rb9gzlRoFQZPkcTy7VsmaflZMsuXaoiJw6VOYe8XQw76Q=
X-Received: by 2002:a05:6214:e45:b0:89c:5f6e:451a with SMTP id
 6a1803df08f44-8b6667ee116mr55192506d6.21.1777728420510; Sat, 02 May 2026
 06:27:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260502095435.2969835-1-zisenye@stu.xidian.edu.cn> <20260502104436.2978678-1-jasonye247@163.com>
In-Reply-To: <20260502104436.2978678-1-jasonye247@163.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 2 May 2026 08:26:49 -0500
X-Gm-Features: AVHnY4JCm6Q3MxWZymRf8uWukt1vQnZmtxcBPNotbvr1eoqDne7c192vEX0LPHY
Message-ID: <CAH2r5mvEG=zFV5r6bFLDiCj4NqaDgP0j8Aonx4EqSpG8Tp6kKQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] smb/client: fix out-of-bounds read in smb2_compound_op()
To: jasonye247@163.com
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@chenxiaosong.com, 
	gregkh@linuxfoundation.org, linux-cifs@vger.kernel.org, 
	Zisen Ye <zisenye@stu.xidian.edu.cn>, Stable@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patch generates a build warning, can you send a v3

  CC [M]  smb2inode.o
smb2inode.c: In function =E2=80=98check_wsl_eas=E2=80=99:
smb2inode.c:124:25: warning: comparison of distinct pointer types
lacks a cast [-Wcompare-distinct-pointer-types]
  124 |         if (ea + outlen > end)
      |                         ^
  CHECK   smb2inode.c
smb2inode.c:124:25: error: incompatible types in comparison expression
(different base types):
smb2inode.c:124:25:    struct smb2_file_full_ea_info *
smb2inode.c:124:25:    unsigned char [usertype] *

On Sat, May 2, 2026 at 5:47=E2=80=AFAM <jasonye247@163.com> wrote:
>
> From: Zisen Ye <zisenye@stu.xidian.edu.cn>
>
> If a server sends a truncated response but a large OutputBufferLength, an=
d
> terminates the EA list early, check_wsl_eas() returns success without
> validating that the entire OutputBufferLength fits within iov_len.
>
> Then smb2_compound_op() does:
>     memcpy(idata->wsl.eas, data[0], size[0]);
>
> Where size[0] is OutputBufferLength. If iov_len is smaller than size[0],
> memcpy can read beyond the end of the rsp_iov allocation and leak adjacen=
t
> kernel heap memory.
>
> Link: https://lore.kernel.org/linux-cifs/d998240c-aca9-420d-9dbd-f5ba24af=
19e0@chenxiaosong.com/
> Fixes: ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
> Cc: Stable@vger.kernel.org
> Signed-off-by: Zisen Ye <zisenye@stu.xidian.edu.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2inode.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 286912616c73..a192d70cd29e 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -121,6 +121,9 @@ static int check_wsl_eas(struct kvec *rsp_iov)
>         ea =3D (void *)((u8 *)rsp_iov->iov_base +
>                       le16_to_cpu(rsp->OutputBufferOffset));
>         end =3D (u8 *)rsp_iov->iov_base + rsp_iov->iov_len;
> +       if (ea + outlen > end)
> +               return -EINVAL;
> +
>         for (;;) {
>                 if ((u8 *)ea > end - sizeof(*ea))
>                         return -EINVAL;
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
