Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3F82AD10
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 23:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772582332; cv=pass; b=epQZjJft2DfHTCwkSRlfaDS2ghE0j+FngSgoNDeMqSDchTzf9bneru992eVDO6cgWjq30V02AcRrL7+br0MdC76oCcZl3LT/WUMfFa+tTUmswUCGbW8nLgdbT1RoHebJAMHUiZyzQIMDPYNcv2eWsK0xRfOcr1v6WzrDEkXKDcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772582332; c=relaxed/simple;
	bh=kVpkg6v37u9kY5MUoy6DzCYUMm2N+Z6Ka7XSSPZlw2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qrjKnwehBMI46MvyY3X9DrHdhS3q8owDvmawdYsiVGgb4vrtrQYC6FNSxxN6oT5z5RYavhZ+o+jm68RwDhDgPlTdMaqd8kLX8XTyWXvDoO1HQ6i+Uq1SbuuW3hMMTc4/lfniLYjttD2EXBDtkwKOo8pVBeqZuSnXQqoY5D7ab/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VPYgzUOy; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VPYgzUOy"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-899a5db525cso57300216d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2026 15:58:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772582330; cv=none;
        d=google.com; s=arc-20240605;
        b=KZMHYiP8k3SWB2eZBj0lvQho3RQ6mqifZiMxN9vagzk1Ro0ZChFsEEBt0gslW5hcIx
         4Y+HdskZ3X90xQHFNq32l4XYVCLOGMto0XO8Xh98Qtz2wdjACp+7KBls6RYHcOo/yM+u
         1/NqfLJFmipJfhPodQx9AgNSdRBNetVoyovq5912rBrOD/UxFGeIL85THP5XRUSAeItc
         iIDLfL0vajKOocf9tipvsrXXJLQSST3gYUDtD7eeIuc4EtrwanShihbqCkcGPYxdsM45
         sG8khs81H/+Po08Xxg9aorjL9UUQ68AqRkt8c+1yAsfw+i7xzNHdGcgS+pkpIzieMWYb
         WcZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HLI0m0UT98/OOAJ8nkR/CWr1uZ0+Ku8t1rgsjfX3GXg=;
        fh=nWGANkmQgSHdz312apVID0lb5xKseBXgwQ+7OTlLvNs=;
        b=gVRJU+cscxtZan0rmlC/5SgYmJFeOnUfrOLxMowqHVe8GvwShcgjmel6yZ1ICyLL78
         3ps6f01sI07U2TFdkhtCyPBAFmXdjuqUlLJHtPFQdEey18Dw2juaKSnfAg4XkSb1wLeR
         bgsdlhlAbE/QKsf5xlTrSA0VQOQoyNDvjIIZ0Uberd1/872rBpAeyoNXBwZolsQynyoV
         bMo9itbKCgPOYgfBaJWMSf1wU8EDM8zF7vtank8TIjeGcgUkBUXln91GSj6qZbM6tIqg
         YoyAP2UgA4zLMNxzzcm6CVfeSCY1J+qD0w5qyWO2cVpxwXvS9vKYL4NgdmjoWirQEaLx
         cqBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772582330; x=1773187130; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HLI0m0UT98/OOAJ8nkR/CWr1uZ0+Ku8t1rgsjfX3GXg=;
        b=VPYgzUOyUwSfmTfzAUsg6SBuBQpYOBGRU4IG/gH4wGC9dw5xyPCUMzTy2/VOS0JxZR
         /6DS9NZfHowKKBefi5g8vIW42MsLy+pV465eQxqb14N14Oo/m6bGzvxuTDERuQrlXjro
         uEp4ZpgOrBIvItZpvgWONTCodhotirKwtuAHtXBcgfyyhTz/KkkTwjkz6xKD2XZdOt3C
         xIYdA8+aq/+R+k3fcYVe64D30h621p+ctDz/An7nIkpyobTZVAtigsErscvVFxp5xl/z
         BwtUpEGLKzeboQ62RE2lcOC+Iu7QCwbpFJCD5wQTTX294bI1uRazsm9WO6kSNT3w97IJ
         MlBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772582330; x=1773187130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HLI0m0UT98/OOAJ8nkR/CWr1uZ0+Ku8t1rgsjfX3GXg=;
        b=od8K+zSe8yBBmelqEW9vhqU6QEscGfh9SsQFGfNVE4KbWNkex42wsWyMQizsZ7saan
         AUejbIHPMLPOI8bTCOIrQoNtgFt5YcyXKAGqY9r4R6396n7KT9egxPq+NFkZvu57V56F
         koXsnCZC+IqwQ+yYMwyJHHwTA3z8FLlmgevJX3ZmaWobv/ReRwybpc8kxVn9HcmI7UfM
         QUhmmB5UF6ovtqxlnwkZCed9Cxv2LIL5a+QzXlgpap9OosbVoUIHy0k4VeDpyywxDEy3
         +HPqluJvIjG+oKnvbXAuRUfPcMvgtcK5kBgp/IxuJBxf/vqUxaZBeBiA0rgzzwJLaYMH
         O6aQ==
X-Forwarded-Encrypted: i=1; AJvYcCWETvyPgzbrV+oxmP5S04bevOPWY5k+01xfNVefzt+PkHe15/C6aBYr9cX3bMeI4sERUte/KZvRmNP2@vger.kernel.org
X-Gm-Message-State: AOJu0YxEAZnl3JJE/x2BZuLn0V04FNqHG7AE2WGDUi9y0Zg2wrMJG3zZ
	iOjTj/uJwHbL+T0kGTU1rNp5MZP40qRJFCUuIwrNtUp8gKzIhuxwCc2bDs1l0AvrDjK/FYsry/s
	c7arjLQMzbTjUv6dEUQSLvoyz8lc9CCU=
X-Gm-Gg: ATEYQzxsaFVVsE28MrvpN7p8uPkrNdqPfy6Ajoz8dHcU35PardlhSM0yd69Ji1SCK0z
	QPnYK5NgrNJ02Q6Cbj302Wsl+24xTxQu8VsYg3zJnOBsKYsYfTcPww0TgE96awrSY5T1AkRMm2I
	G7Ms6VNH8Wq1Xp+iSg26CVBb81MSI7lUvZR6OamssyUIopqEDRlnFkP/44aQyIkMpZKQxCCx2pg
	9H53YJob2CG1cmd7rMiCT6feeX9la+ntho14NWk4xgDQfP86YkFeGlX1o54Klnh/OpFjW94qgQy
	tXvlq6VBPnm60oA1db3blokQyrHIOB9H+dZivubYEXHYDuc8eIdtoWhPlw4Nhct1sT2sXvG1ix+
	wmonoYCCVzC5ivElSagiZ2tqsDKRkRisNKbY1ntF6C1pGrX9TPn6LLtm4l2KDNi+lo8bJAp32r8
	cy1a4rqdeuivbeMBe5EMT+giIzz0Gsb5Os
X-Received: by 2002:a05:6214:2423:b0:899:f179:d187 with SMTP id
 6a1803df08f44-89a199961aemr696436d6.6.1772582330334; Tue, 03 Mar 2026
 15:58:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303151317.136332-1-zhang.guodong@linux.dev> <20260303151317.136332-2-zhang.guodong@linux.dev>
In-Reply-To: <20260303151317.136332-2-zhang.guodong@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Tue, 3 Mar 2026 17:58:39 -0600
X-Gm-Features: AaiRm51Hb3SECM9eIJFDgBjZ7i9PQTW2kGgrTWHQJeMm8xCctK5jv5DHAgY49s0
Message-ID: <CAH2r5msFB7KBUMmfwq7HwpF7+WLOySGhhfQm93OwZLWTmp1a9Q@mail.gmail.com>
Subject: Re: [PATCH v5 1/7] smb/client: fix buffer size for smb311_posix_qinfo
 in smb2_compound_op()
To: zhang.guodong@linux.dev
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@kylinos.cn, 
	chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch - were you able to repro a crash or other bug when running
without the patch?

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
