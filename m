Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742961CEAC2
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 00:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772582780; cv=pass; b=XFkjhJMzTgRIepO3nL6iMhFIwxqrpbB/978rYkQ4MUBABhB3JN5ZTdMYUPZdh4LNXjZhIKyY0dWupYpV0but46zrJWVoTIlqiaHy14kEVG9XTxlQaJzbvYBB3h4DMkELDPJCmM1YjVt7YpWBHNVMqiAyW3TfuMy9zqumYWCkGO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772582780; c=relaxed/simple;
	bh=VpveedkwDUNi3L+b0yfdYrA3OFngmiviKCTXvIuW9vc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mfMPgvjsfmGjmoe1StUH/ZgyBtQILwQ68s3tvX+Ds5LPpVazrdn8C/B3qVK+f/EogkqqDn+h1XNOx8nwIeGl/P7GkkGoPpLc98w7Jrn+JTnT1RrBFOwbW6LrBK6frf9F6prcOuIG8AlbEGv7MvOE9SfMri3q/14Yc9TpvquJWcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mdbQC9w3; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mdbQC9w3"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-89a09ef1e3aso18880836d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2026 16:06:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772582769; cv=none;
        d=google.com; s=arc-20240605;
        b=MFHbFsdOelgK4IRDIrv0edMM+w/diM4pjzy7lSNpv/1vT/iSf6apbb/FDO1GK9h+fg
         Dinhltr/iksmUZlQd16ZQw4Bp6uUk48m+1p5dnE0O9uRsuYScOdKNk3aK6j46reeyoky
         XLjdfhGSXPQZWPk3bVOgVdBH8zAgn+19f8wISEBdqPs08D0ESNO8JM//uMzUJzD5T3I0
         atij4LoVjFIvKk5GgRuM35CuUTceWNRBHS4YcqbZ9EtZnLsQJMXgrqQ2p0hRKn7d3YRX
         KTTXZ+224uEa5YCSjk9g4Dag29uGMMDrBQBxWSQKJ/HTDdntot4C70QFTGa01h3gt0qm
         IKgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zVyAOkEHymuqcpzEPo2fabYmv7xe/kkvvsVcI6ugL7w=;
        fh=1OZsMMQUJQWOMY0ghdh6x+FBB2+26wJa3k6eV36oH7g=;
        b=YhRRyLSxx81pu/3ylzJpQJNQtM4YIh6oxwV1XjY1+On3Fq2rp31Z/mONLezc8dtMpq
         pEaljO8yOpQmwUMTvyzrNbDmieYsKqlSDwYxwNculbYXfPTW034o9udRcggaFDsSg4Og
         b433oWufml3IPyJuqH+T7gnz02gCDIJ895a9Up4eR5+jy77dThXRRM8mEs+5H3TlO14+
         JAcrfny01gsnFisMABPjf7yoXXhGLAxp4m5F7MT0mS8cDk6Qo42yJ4Mt9Eoy03dLOvyP
         pPZr/LqyHudaINHoXrd1jB7x3mZQV1wjUECkYJZ6eGfVdQQ7RKLD2qOS7HFT6s5lolQh
         qfKw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772582769; x=1773187569; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zVyAOkEHymuqcpzEPo2fabYmv7xe/kkvvsVcI6ugL7w=;
        b=mdbQC9w3H5TF4+c+8ALeCkT2EYmmCIAr5Kj1GTbsVNmUl4v+wPDQL+tJTQcDfRlXa2
         SOSDl8PlkKoZ+BNuZ38eHqMgkMDVNIZuTSIlCtLF6rx5PStlDl1tPFw9sewVAQmdfk4T
         zMC+S6Fj41DOXkxMQ9Du1YwaowBV36Xii3TK2Zf9VDBtO1wh0PfCmj6XO7tCW/wXl7CN
         U3da1RPTO6T70Qq+gs2SIOgbatBwKJIvUy8kFv5O71fjBbxANvklyV47dL/6n5/Ze0nX
         fZhV50jENNBhpQTkCr+IJhFnkWDAoTwatZqilkP8ScJnBE/i0HGFAYaMZzUB65lObdnP
         reUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772582769; x=1773187569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zVyAOkEHymuqcpzEPo2fabYmv7xe/kkvvsVcI6ugL7w=;
        b=pr+7LnZMM89UvfxzGKCGyD8K1leKYPExaxtAnT/hsIoWb3+o3xsUL6JgcgpKCEoWTH
         i2zD/kLEh062NvwPhVkofqQtyOULQrcB3CFiic9QU5uL4eV+CUda2AJkVkXV66Keacaa
         TFN/Gl7EpW/4GA2eA2vvUQp25tfSyMEFvzwSKp1hxLyVS6zWzVQPt8aKIyViNTYkRe4R
         fEyqYXTvVc78s7f/j+nhIbA3McuGVmnSMc7rfa/1cDHQUkEor1wqXQanr/iyeV9lkqat
         ftIkt8aboATbQAd73HqjreM/C/eAspFsqxW95Wv7StXEejXtpqtnaV3hQ7fbtoKZ5lh+
         /JrQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5A/jeugJZHCw4vRw4SjlmEGf7ePTGVCIw9kkMIXUBH4Dta+SjLvaHUNA9AcjZuqHHPyfVv3tCRSSb@vger.kernel.org
X-Gm-Message-State: AOJu0YxvMqny19KnAh+nIZtAidk+KnJ1XuHUKsBZ0Fe1duewe/VvzmUw
	ZnpBJcaxJFE386Na4LQqk1T0DLjZIU8lSxpEFsX/g47eApfnoYAVm28WtIOo6tQx11DFKdAU+1N
	nokHPGqqm055l9DJ6x8kKOYLx7cUusPg=
X-Gm-Gg: ATEYQzziUeTinfHBQW2DAlMrlswC+jz4/aNHgMyt6zB24Nw01d6/1USq/sxWQvsjMMD
	2K7PZW3hmBcNmPNenRJiGx12/NqgYC3AC6g8LzNV5+R1E2dOAwb84WFN+46/VwNTLyBdYcuVszp
	8fcGp1nIX4tL7PSaXzXsGbWudjyXIn+Ibluhcqk9N+plJDNk/2CdXFIVwVmJXP6EoSKQ0PpwlPK
	dB9b9doY/N9D33eQYjCaWAlZtcg8UIiRbWF8/Tm0cMddyr2nHYw+BrKUXOWX/kHXretqfCW0oga
	f0eD9VfVbryNZ0DJrntEvJepvV7jFeslz8f/MdTdz4HvJ/vjBXmOktNVj9NBO6g75us3GTlAy7l
	+TFDdXmdLfqavROzUk6NHKIw7oArFZbqdtYfz3xEDa/l5uKZUhx81QiT/bwsmTUYRI3VzG4A7VV
	9YyhkMpvOw1GVsEVgdphKPeQ==
X-Received: by 2002:a05:6214:246b:b0:89a:1088:2039 with SMTP id
 6a1803df08f44-89a1998000dmr1076406d6.3.1772582769042; Tue, 03 Mar 2026
 16:06:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303151317.136332-1-zhang.guodong@linux.dev> <20260303151317.136332-3-zhang.guodong@linux.dev>
In-Reply-To: <20260303151317.136332-3-zhang.guodong@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Tue, 3 Mar 2026 18:05:57 -0600
X-Gm-Features: AaiRm51DrfuCF514nuCrjPY8r0vnG4UUbv9OV5TLzy0ZH9QpGlRk0U8NTLvqT6E
Message-ID: <CAH2r5msW6nhsjCHwff3J5yD6GN1h=MM7XtSsXSYfZTnbP0+M2A@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] smb/client: fix buffer size for smb311_posix_qinfo
 in SMB311_posix_query_info()
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
> SMB311_posix_query_info() is currently unused, but it may still be used i=
n
> some stable versions, so these changes are submitted as a separate patch.
>
> Use `sizeof(struct smb311_posix_qinfo)` instead of sizeof its pointer,
> so the allocated buffer matches the actual struct size.
>
> Fixes: b1bc1874b885 ("smb311: Add support for SMB311 query info (non-comp=
ounded)")
> Reported-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 04e361ed2356..8a1fcc097606 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -3996,7 +3996,7 @@ SMB311_posix_query_info(const unsigned int xid, str=
uct cifs_tcon *tcon,
>                         u64 persistent_fid, u64 volatile_fid,
>                         struct smb311_posix_qinfo *data, u32 *plen)
>  {
> -       size_t output_len =3D sizeof(struct smb311_posix_qinfo *) +
> +       size_t output_len =3D sizeof(struct smb311_posix_qinfo) +
>                         (sizeof(struct smb_sid) * 2) + (PATH_MAX * 2);
>         *plen =3D 0;
>
> --
> 2.52.0
>


--=20
Thanks,

Steve
