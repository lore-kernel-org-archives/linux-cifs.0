Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5C51531C8
	for <linux-cifs@vger.kernel.org>; Sun,  3 May 2026 14:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777819016; cv=pass; b=Z8nHJ3B817qLFbgS9ZFnwvvKOe5lLpoDvgzzbr97jrtgUb7MCdSgaV4CCZ9CbIfdrPLKl67KvM9ZNAD68plstzb07Ir0yOclpjs+wr7emQl1Rm+jwusCZB2n4iYqWnS+DlKg/ypc5IA7yxdMkOwLI1frcqUKzAkHt0Ws8/Ej0SA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777819016; c=relaxed/simple;
	bh=Unyv3EZ/HB4GgUdtsflAJusHcnNNJnKZIPEseowCgbI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UXPmH8IoJYpVHtk8JHZkXimdTxR1/hxGHeEzngfI1es5JQCLfNq931Lhyrz2A/UPPLXUVDnVziQKMNo62YWhJMkGE81xFgV+QYZNgEh+HCj2sqB3dTcB6aV1kRAzmncqFO5CGAx0ujq02p1NKhnBouH/1TgzyksvyoBNwLn5miI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l9iSFd19; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l9iSFd19"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8b3d6b215cfso55574496d6.3
        for <linux-cifs@vger.kernel.org>; Sun, 03 May 2026 07:36:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777819012; cv=none;
        d=google.com; s=arc-20240605;
        b=RxeBq11YF8PyKQ7AQ/DhjXN/bwiy3DuraFwxpAQcn7ChtamAeOAnsctMCoADqHP6UU
         ueQGfh2Nw4lUJYbPDS/Uz6DPpF2o3G0cUn/e84puyHUBJJRlPMMnabwpzolXZc3u1tFz
         gTjdg2Z4+ti4ZZG0epifjeD/FtE2qRh0QXtqCH+pYuwQF03c69oPtMGYn9emb2EOoBPg
         X5RTKKInz8CzDqmp5WDbpWkyndYUyG5i23WFa9VJUSjWu7AxdR01hfMAbv3Los5KA7za
         CHCzDUi8FzKQNc/dj+FkSEuHpTVi9wnT1iTXbsJv6FQByFN7pCfrjv2o1gc5BaXa5+Qc
         WBmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GI3d2iU/mmXcADFfS0JjbTvGYdNnQT9tF4bdBex1PRs=;
        fh=mJFU7+VJBFhdRjDOjXfB5V/e6gTMrBavSWlhoFij58w=;
        b=B/kAjq0krn2e5oh5fybeDNDyTa95isPBtmSjDL+TX2fDwYfGKKi36GkL0Z5nzdELL3
         gMe2K6QwmmjRhWCJhuSgzFhfjoFufdoqDg+4Tb2ohmIbfWCC2ZhZOYmRYLuZwOAiyy4a
         F87EBFd2KZQHUXOFxZ6c1GufP6xQkK14Q5cEUO2Dqncn8mOQ0S6PWp/pXidSvLSufQuw
         Jxj1i4eetcEPvC0UOmX7fgYfZD157/HvX3YnBQYqY3/jawa1f1umWzfL7ePH5DsXRIyg
         3I3n616VCigBDzWaaRkuhmgDfJLORsLmSfOvE1tTWG4Fcl2x0tidasV8yFTTDzXxbDja
         1oaw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777819012; x=1778423812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GI3d2iU/mmXcADFfS0JjbTvGYdNnQT9tF4bdBex1PRs=;
        b=l9iSFd19aW8JuzJlDRoA54ajq+zRBanIt4tZ4C/YeCneDBZrqh1h+dOWze2jyvxey1
         VnWLSqwNb9FzlYc812zbfc+DAqnU2sCWf/bXmRoSvGyDjf7SXJih1zvboI591Kq9vtpW
         +RghzxmEDiisqfAFGu0GzZObAWfTXbvKyVtpCTvRTzYa+sNdxvNvdjtUSRO07Qw/+dfL
         vHOhLY/COI4Un+2jJOjre9/Svv3WeG9FVDXR28KGaHNFjs0CmMqWGeZih/ZCSSViWkBe
         ULkS6nkjjSlO0mEdpR4ziPsB/BIY61btCZXtw4UDPJB3VSAFNv4qr37YHI3uFJyG/HqF
         efKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777819012; x=1778423812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GI3d2iU/mmXcADFfS0JjbTvGYdNnQT9tF4bdBex1PRs=;
        b=m+b5okuKrS1yzOqPmCYVdet7e/1wHj85v/Mmsm4cC1zyGQOXYZf4y+8PxRtl0KM1Cr
         hPnPfFqpiXf0dnZuDf6AWCG3mD+EtGh5CQ6Oj4hDxnP6TOgYOX/jEIEORUIUYvEPoMQ2
         rkJ/Ql7hL+G2JGB/WR9HHzowAbb2TafgaTIMx1H22XLbWfiV2qR2nzN+6sIWYkGWTv40
         gLnGQC8Fc0dhhrzfAB3G7AtwXbIrMkVQDcHBhPimbQbmmhnJP5Hz/NabRP9bwoTcVXLZ
         lOC43PyBsQip7miuQciFgL18woX+rrL8S6E4oczQd52SZ6+MqsnG6FeBIRnd2hIPgUzV
         JPmA==
X-Forwarded-Encrypted: i=1; AFNElJ+gdvNSCP+PEtCP18y1dVjQ83FdHmnij1Gge1ktVuO3nvQ69okOmhncvek3+a3hLy/muMjnr1mvFMeU@vger.kernel.org
X-Gm-Message-State: AOJu0YxwX3wyIi6tXrw9xcHowqMpXhe2561ezNCRB01qDVI2YcRAAz4w
	ZQqA23eLIdjBPy5R2m5blEK85ylimsYuPHipKHtI+P7nE1w0v0Wbhq3p4zfS12IXXAKLAGEZWg/
	9V5evmYvGqQS9qFejzVXQlxP2XbUctJyraJnQ
X-Gm-Gg: AeBDies/B9YipHcoG3T/vGY71liCMFoBMSgqcX2JZzeF6oNGCSa1U4gQLFs14JSNplm
	MTfsvcONSytJzu3MnMTZWDXakAYpBYZ/ZytnhyQ8tmgADVrnKs5A5ogyb544DM1US2EsVR86Z+n
	HV7iYhbpcgqbDnWPN8mm8i4JFqpJwm6nPgNUdUKrsPIvugYAhD9FyX3ovFLYWTo4bC+j/nKLPmF
	NZi2eNCq/qFzleOLZHmbD76ohzpwRtq4GHw/2hDFusWWY9wPEg2pWCR1iwIj8uQK1A7rMUMLOvT
	2V6L058sDQthLa0HXNwrg2aDytw/c8awNtiAVGalQRPM5wDw8quiOczSdyWz44Gk50yCmWzrTpG
	F74WlU9MZ7M8Q5m88zbtDwv1WtwimVZSxN3lpnjL31NcsuiAY4uBhyZ7EP93AezEWO1Q5pffdhg
	AEOtViN6t/t8uf/RgczRK4YYEo+QIXpg6LeeGhRrCZAg==
X-Received: by 2002:ad4:5d4d:0:b0:8ac:a097:2810 with SMTP id
 6a1803df08f44-8b66805d8femr117628316d6.27.1777819012467; Sun, 03 May 2026
 07:36:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260503134333.3260640-1-zisenye@stu.xidian.edu.cn> <20260503141713.3266571-1-zisenye@stu.xidian.edu.cn>
In-Reply-To: <20260503141713.3266571-1-zisenye@stu.xidian.edu.cn>
From: Steve French <smfrench@gmail.com>
Date: Sun, 3 May 2026 09:36:40 -0500
X-Gm-Features: AVHnY4IhwzVw1QzIcj7bVxZg5476jeMOsNbmOAxBdYrlyKp-zDzPHlUSlIZ2OnQ
Message-ID: <CAH2r5mu=Bv153P3KTws98MG=tC7NLvyb3sds8989pYihLq2tAw@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] smb/client: fix out-of-bounds read in smb2_compound_op()
To: zisenye@stu.xidian.edu.cn
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, gregkh@linuxfoundation.org, 
	chenxiaosong@chenxiaosong.com, stable@vger.kernel.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending review and testing

On Sun, May 3, 2026 at 9:17=E2=80=AFAM <zisenye@stu.xidian.edu.cn> wrote:
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
> Cc: stable@vger.kernel.org
> Signed-off-by: Zisen Ye <zisenye@stu.xidian.edu.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2inode.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 286912616c73..28e01d02be03 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -121,6 +121,9 @@ static int check_wsl_eas(struct kvec *rsp_iov)
>         ea =3D (void *)((u8 *)rsp_iov->iov_base +
>                       le16_to_cpu(rsp->OutputBufferOffset));
>         end =3D (u8 *)rsp_iov->iov_base + rsp_iov->iov_len;
> +       if ((u8 *)ea + outlen > end)
> +               return -EINVAL;
> +
>         for (;;) {
>                 if ((u8 *)ea > end - sizeof(*ea))
>                         return -EINVAL;
> --
> 2.53.0
>


--=20
Thanks,

Steve
