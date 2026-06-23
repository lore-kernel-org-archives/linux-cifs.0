Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406AA63B9
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 03:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782186659; cv=pass; b=JmlAPSTKEzj6NzPuDpphNtY6+di+S2h54NO2jVCCdvQFE9Qd88kAjn/QjAXjWsTkmFv4Ek/1QpTOIoSURg6OSMiOmFesU3Y3fyG7gh3edkMQxiwjpAUV8TTzsZSOeEC678u23UPkKVtrBgBMz672NJWqU5U+WJf3Y/To6XHFRqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782186659; c=relaxed/simple;
	bh=mbeMOWzkjaXmk6J9yWJvS/JtMWwn/l8TStNyQ5Q/lJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CvGHrDMyrXJSKOFtZVXvV1rTcXaGRxSYwyCzRZotGuDepf2/m40FwoM1cfVaYmQv9T54ZkcPWc8QLEyiTuRzao/CDs588vS0We9hUgtGFmdBGkcRz+QAcZqxLIVP3s5pbENSw643DaNf650x1yGJ1i9wOvpPRCgU/xrVfGAlsIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mWig4tHK; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mWig4tHK"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8de2adc59d8so5895426d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 22 Jun 2026 20:50:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782186657; cv=none;
        d=google.com; s=arc-20240605;
        b=EF7/334Sq6yK2nmbMCE7KiYlPLUyaGgbvaa6HddKWPvFKYXEi5+KhSs+4JGliFDWHF
         d6fy1gXGwzskclOtzn0APIHsKB1I3mBYpu5sncSrc/7oQ+iboPYQRe/sM9TpuDLo9DHw
         ZF2HqGPN+OdhEVwQzFzAanDGSNluHbuA/sq35Cg6INFlzWjAJ8DYt+Eezvv6qgme8v6O
         MTY7st0EIjahTGPs0utm2V6h5q1EY/JVEZZCh4ksd+z+nc38MbX4apW/ajI3RZwdI0G5
         Qml3Cl3lhVUsaj2IywHS35HJKORQso4g5atzlAE4wiKELZrorg1D+U5r/BWX9LAWhyjL
         QzEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nQX4xExW9VkCr1JzSfmC6N2aDcsXMdQNKX3WLBpbtuE=;
        fh=PhLh4ffIICdUdA0768SpuPdcAB6rk7Cv3hW8X/UluEI=;
        b=NWZwE6Y14byyiQVhlRx7uw36FrycrEGYkkrbhwDHD5inZvse+UQZd+dAoo+PH4l63U
         0gfDoo/X8XR47Zt+bmv6vW85nYmQ/DyeibUouHRt6J5UtazqlP4jN6IKD4LECasiZ+cT
         nO/B9E63LpqDdhlt0wRaSKcjU5EA1gujG+SHqVRHEKD78riYzXdIgNWRR26HpibCj6+7
         xB5mx8RtKKu1msrHHx5BE/AWebjUcrMFetnV8zq77gLKt8Q4d+C8ar+BvXJOMOp+M+Lv
         De8ml7hbblfuRZoKU3bkpoRWlkZeNvn8JBXpI7tRjB22CM+YUiKj5Ru0YVPWZAzL66QT
         eYlg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782186657; x=1782791457; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nQX4xExW9VkCr1JzSfmC6N2aDcsXMdQNKX3WLBpbtuE=;
        b=mWig4tHKqm5qKAwcbx+fdleeachXqmP6u5F8aEuzX5DwG7N0QOtMIhhFnJK9CCVyrz
         X6Mi1lbxddLws1xRTL780e8rUT8R8Q8+SDIGoNTb3lDDcoVAtuvD/yo/vnmLmZ/eUPCD
         ppIPz9xlT40MsCBpXwgpgz3HBjlfQsu+VsXQKAjHls2S1Zd8n5nvptirmFCqwYFHDzRI
         8OJMImbAJ/G/h878aGx8zOdCoep+uYvRJQHpTd+KksnIuMSdvXDgFBOXw69uN3Vav7ul
         DO3RRCEjgSqY7TFIrrrJ3g8+5Q+v4Ond6+67BoeUPQmdCPikNJrl9wLcbPOyzyb3KnCJ
         HkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782186657; x=1782791457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nQX4xExW9VkCr1JzSfmC6N2aDcsXMdQNKX3WLBpbtuE=;
        b=G6SWFOTGLS1sVr/A7adl7ZXQoQa9HcZLhqONpTKSbrOPCM5/Tz3Xg19fqBv3H37Gbn
         LY2MLh9CqZZgQziyUUJtsJqUld04WGpqHJ9OzQqaiKRIAtnAMovkCoYsSKDA8ecFE9JT
         JyUHNvp7HBWB+r8gP9pGvSeTwmVAo1+aVlDzhAv+PlS9B4+tSTYnJtcS6Tx8AxNvrMeB
         PW5LDQQJTa9mvot7eMYhJz/rbZ3CgmfdXx1HSkez70LiuhmjKJxZ+FT4pJIR4yuOB0Lm
         0fx5edBZzkC9ec8HXRz8UqiLY+Wp06gxPK97GJw+6EFJzX8QYx0Na6eJcZFkc56l1GAL
         Q0fA==
X-Forwarded-Encrypted: i=1; AHgh+RpB73ZeOinL5XXTe6x2H5W/C3J9Gc5/q1eK3sImQoYKCe0lM9DjG3YavG+yEj0h5NMyERfSpI22oChc@vger.kernel.org
X-Gm-Message-State: AOJu0YzgKE/JLh3KJGIxY4wgwXQ9afFND+uCC1cl3A3h4SzXMx1uOyVP
	bcsNRyEdLzdnW6N9PEUnIxrjVhxM8nvW7Rcr1OZth7W9zhTSbSVejn27WzXM5EWQ5zRxw0P1NCY
	BE8dBlPLRUwi0i32GQK7cmrGULZQ7kFY=
X-Gm-Gg: AfdE7cmFcnbg8Q6xgTI7uURVy88hdSz6y0NxSLoHBL6grC+oLRwZiJCpIc8NzLhu8Gl
	1VzGgJnKNDaFl5Xm3wV0c3WL0kNRmNnI23RkmvEZlsS3dXKY8xCcM2UO2eTZwL4xUWsTkiLZ1eD
	0JRLgm71vY11uKvpmbeY3g/Io3+2YG8TOWQfPneo6IRy4BER/3wX5gSFMW2GJ3RtUS2ncIY1mMS
	Is+TmoP0oIvg91QGXdid7G8uF1BPiJo6zxEtf8rTregylI7IDlqkFIU6gLF/JVS0/k8AH1UUBn4
	7FvkFEthiHVlXMfd0bn5L+SiGl2eURmhOTNvE7CjFlOU8B9h2jlFnIin66L/CunaDuPUHZkPEVs
	Gebz81uS7rJfKF6y5wIGodOgPazd3vCowpo+YHdO/e5fOnQXPpLStNxEEgyzu0iInL7Xa/n3OWw
	jr9+zOq19ttQ==
X-Received: by 2002:ad4:5965:0:b0:8e0:dfaf:a218 with SMTP id
 6a1803df08f44-8e3b56bcbb0mr38320716d6.1.1782186657252; Mon, 22 Jun 2026
 20:50:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623024619.1360127-1-huiwen.he@linux.dev> <20260623024619.1360127-2-huiwen.he@linux.dev>
In-Reply-To: <20260623024619.1360127-2-huiwen.he@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Mon, 22 Jun 2026 22:50:45 -0500
X-Gm-Features: AVVi8CdQWNB4P66fK2wjkTLbYGc_efUON6y6FSV2pbJTjznvTVPqlno9NifViLo
Message-ID: <CAH2r5mv7G20cZoE4t4mSiMa0+kGkd6ALJM3BZ3Y_-w+=ELUDOg@mail.gmail.com>
Subject: Re: [PATCH 1/7] smb/client: name the default fallocate mode
To: Huiwen He <huiwen.he@linux.dev>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged patch 1 into cifs-2.6.git for-next

Holding off on the others until you get a chance to review Sashiko AI
review of the other patches

On Mon, Jun 22, 2026 at 9:48=E2=80=AFPM Huiwen He <huiwen.he@linux.dev> wro=
te:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> FALLOC_FL_ALLOCATE_RANGE identifies the default fallocate
> allocation mode and is defined as zero.
>
> Use the symbolic name instead of a literal zero in
> smb3_fallocate() to make the mode dispatch clearer. This
> does not change behavior.
>
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index a8f8feeeccb5..2964f461fc84 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4071,7 +4071,7 @@ static long smb3_fallocate(struct file *file, struc=
t cifs_tcon *tcon, int mode,
>                 return smb3_collapse_range(file, tcon, off, len);
>         else if (mode =3D=3D FALLOC_FL_INSERT_RANGE)
>                 return smb3_insert_range(file, tcon, off, len);
> -       else if (mode =3D=3D 0)
> +       else if (mode =3D=3D FALLOC_FL_ALLOCATE_RANGE)
>                 return smb3_simple_falloc(file, tcon, off, len, false);
>
>         return -EOPNOTSUPP;
> --
> 2.43.0
>


--=20
Thanks,

Steve
