Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43B32116E0
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 00:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765240211; cv=none; b=nfJb+6kCTCpg11ZIpPmeW0eetwBMHoD1nYP22MBEmON2De3kdvomXtRQI99Y6snO4Ah0UdYcZUEO7cjXTIn3A7HEJyUs63qd1oJ6+uJmM6NzZgUV9sxiWNTa+ET/EcKmFCSaonBF1kZyud7GSN+Ew6VV+LprUEzKmBcXwPot7fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765240211; c=relaxed/simple;
	bh=WCfzFjc1ZaGyXY9goF3sIImU6PucKnQNZ0DqI9GE3M0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Px9mMwQjU0fJZsiB3cSd/sVQL76NeeCleHZ0wOp3c4SOMbCwWiy4rvyarG4OixicIo+QI7LABflrU7esipvi9MV6HdFEqZloWtlWU6g64R3iBUqbAHgA7b2i8KALOFEVJ6+cq2M5Iy5G5Rk4eJS4wv4cxeW/Gdb1aOjP64fxBWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CbouPBEa; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CbouPBEa"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88057f5d041so53738936d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 08 Dec 2025 16:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765240207; x=1765845007; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahGjGqE32yAN5yv7daZxily+bJADeZEXmufHgMX1Mc8=;
        b=CbouPBEaOzRuVSgNazWpZb1ZjDaF9u0EQWmBBQayfOwQLg5iiIS4iNhgVla76ezoPO
         7MOqKr7hDeVntse+XkgswThhWS3a2y9sWE2xtTqmf3LWaBJagHbWQ+4OpCz99EShrCuN
         kTiWBuxThmGGPBC257TRL6oR1SeY8VN2r8Fj1F9yAAOV5e5TXalh02ZNzkqF6nmBkFuw
         KIxATSkYIFfLooSbfyJiz2+cXkkTJ5g0PqnyFiMeisnEzARZ9vHEVP6CQA21FdMYYRJa
         8T8WNVcJJTFyr5MosapsVFf4CjXQci0XaJOHKl4X7kIJHpyGEseab+v1jR+ON6biMMyw
         wOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765240207; x=1765845007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ahGjGqE32yAN5yv7daZxily+bJADeZEXmufHgMX1Mc8=;
        b=pK7RdDt28TfeAidBttUs0H/NTw/STGP4oLTaYjl2jOxo+WQKziSX41TUn5rmNgtjXZ
         xf55g81mmdA1wi+AYCWGXv3tL1AbAJkjDKAQWDgbCZughK6NYrG23RPelJ1HX+GLYSoE
         BZRH9XobVYBXmfEfaN0sHcYMsELhnw9FjLPudDcYgf4kTgdrgi6wa7rCwbVvbqbN1KGG
         okAiu2bbWCEoEeE9/lyVGb9mS4E8obaoiGy/dQJkzACmAd2nWN5cbaOWOr3tD4w2R8TB
         abAoUdFSnm/WqLus+NJ9m1DGEjAuM9/ykrCvHumtJfZsM2iEVgCk/lVfUMrZHSItVVCh
         YR0g==
X-Forwarded-Encrypted: i=1; AJvYcCVyTeVAXgLeJdznwcKfF9yR11F+uiF7yfcR0rot2l08XI+kWGFlddtXdOINS3PLJYdannblpuVesJVg@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0FNl5LAOcfuds77mbcDnAJ9eE2agL/RHCCmq5Y8U1J4VfSPI4
	WiYzqBomKhOB5716Sb5FpRQOcqYIbs+qtIPQ0tl4HudB4Xy20EoPJzf1UIe8ApiGTUwd+sgFrVZ
	DjBCYg3VCC1jKD2yyCobTgHI86XNv37Y=
X-Gm-Gg: ASbGncvjYQ9HBFxkEclTorOnEPU/pO0ndFmyCdqHRxKOw8gBBcDpV97zkeH53SvZjcU
	nvvz5I8+Kjt32XZqTMxT0cziaj2E3k4wOCUJYDBfFK4V9B6a6KdA0FadLiRUh2vA1nDm9m+aABX
	8v4TTuBXGFrmJkZdoQeokc/g+mBzhFf23e+FCC21sfRQQ02QeKua6mAu+U0AqUGuD6fgUDq2NwU
	Pr0+Vt/QQditMh0nFxINLgUJzwyRSS+f+OgsiFT1ftaO++CRwC5r6jQ196+ZH1ckqXeTVAi5g6v
	vgNb5luDUdFsmbUIhvruQj4PGLQ4Ad3DcjHoiEGSh4G0WPfKVZHL9wiF2bBAJWVNmM8XvCDh96k
	7nTo2FUhXB9sK0Z4QsCI81L7TZyQM4zTNEgpeXRjTYk7CbYY3BWj2GS4ee3vKgeO9LZDkaMqU/Z
	Q5Lt4NLj1f
X-Google-Smtp-Source: AGHT+IEjRnrAGZH+CgQCXmGxYT7b/11FCJZPDRgt2hobKbkqqjSbQYzQZUUJ5m952nQesYkd2yGGmX9AAximkLcrVxk=
X-Received: by 2002:ad4:4eef:0:b0:880:57cc:7a96 with SMTP id
 6a1803df08f44-8883dc54115mr158960066d6.48.1765240207533; Mon, 08 Dec 2025
 16:30:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251208062100.3268777-2-chenxiaosong.chenxiaosong@linux.dev> <93da5441-e942-427c-aa7f-138d7e750ca5@kylinos.cn>
In-Reply-To: <93da5441-e942-427c-aa7f-138d7e750ca5@kylinos.cn>
From: Steve French <smfrench@gmail.com>
Date: Mon, 8 Dec 2025 18:29:54 -0600
X-Gm-Features: AQt7F2qLUuSq5HMu_6N3VhwZjHz2kDszkGPU74R6o0qvySOAAAcLxps87R29_Ik
Message-ID: <CAH2r5mtQPx3K20bsOrZFHHwQsy4yMGMTYJx1X0vJqXG=dYDwWA@mail.gmail.com>
Subject: Re: [PATCH 01/30] smb/client: fix NT_STATUS_NO_DATA_DETECTED value
To: ChenXiaoSong <chenxiaosong@kylinos.cn>
Cc: chenxiaosong.chenxiaosong@linux.dev, linkinjeon@kernel.org, 
	linkinjeon@samba.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

These (return code, NT STATIUS code names) are unlikely to change much
so probably would not need to regenerate, although wouldn't hurt to
check every year or so.

On Mon, Dec 8, 2025 at 6:17=E2=80=AFPM ChenXiaoSong <chenxiaosong@kylinos.c=
n> wrote:
>
> Hi Steve and Namjae,
>
> Some of these macro values seem to differ from the documentation
> (possibly due to typos or updates in the docs). Should we, like Samba,
> use a script to automatically regenerate these macro definitions on a
> regular basis?
>
> Thanks,
> ChenXiaoSong.
>
> On 12/8/25 2:20 PM, chenxiaosong.chenxiaosong@linux.dev wrote:
> > From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >
> > This was reported by the KUnit tests in the later patches.
> >
> > See MS-ERREF 2.3.1 STATUS_NO_DATA_DETECTED. Keep it consistent with the
> > value in the documentation.
> >
> > Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> > ---
> >   fs/smb/client/nterr.h | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
> > index 180602c22355..4fd79a82c817 100644
> > --- a/fs/smb/client/nterr.h
> > +++ b/fs/smb/client/nterr.h
> > @@ -41,7 +41,7 @@ extern const struct nt_err_code_struct nt_errs[];
> >   #define NT_STATUS_MEDIA_CHANGED    0x8000001c
> >   #define NT_STATUS_END_OF_MEDIA     0x8000001e
> >   #define NT_STATUS_MEDIA_CHECK      0x80000020
> > -#define NT_STATUS_NO_DATA_DETECTED 0x8000001c
> > +#define NT_STATUS_NO_DATA_DETECTED 0x80000022
> >   #define NT_STATUS_STOPPED_ON_SYMLINK 0x8000002d
> >   #define NT_STATUS_DEVICE_REQUIRES_CLEANING 0x80000288
> >   #define NT_STATUS_DEVICE_DOOR_OPEN 0x80000288
>


--=20
Thanks,

Steve
