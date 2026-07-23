Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8A0345EDF
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 20:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839607; cv=pass; b=rAkI6mn43rWNWhn2hZDoQ08svWj45nAUMT5kWV+AGjVcudMxlg4yAVZUTJJrfHtB4tO9VviTTiVar+Mit0mLPlKwhGMBG/NcQhPtIurGfyIqZHPyt94AUwxr2v9E+lC9h+PJhCR+I+wzFBPtBm42ivFGRHKIcvaMRrqs9l7r1Oc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839607; c=relaxed/simple;
	bh=KUvOsNmzNI+Z/LrxJo5SAo8Wujzvq7eTFR9R2/hDNzw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mq0Af1Zw5Sgsu2nK9ZtAc93LyfEzW1kxanlNz3SA8OqQM+FGS2ELuZHTx8zUf+0OgUK/87ewj5zwtZHOCMKMx/wVhXKEL5dnGVYngqgv/yShFiEyHgGsF3caiPa3zk+S24Ueaq5BpS+C+iIdwh/YxfzaBk930fO4QE7cMpf3lOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p4zI7vSt; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p4zI7vSt"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8fcc43c48f7so12688766d6.2
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 13:46:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784839602; cv=none;
        d=google.com; s=arc-20260327;
        b=blF/wOt1ZHGNk2tDv8230zzA5nsClG3DJdXbcPsqykg3TtGlC/r06fsM43L+1r15xf
         PfyrdFhsI894Z0cJeuHnKFNoYiWYa+ukjMH7dqMaU9AwlZEem33CvZDY1/V7kYVT9BEm
         jeS90r6BfxjWgm69K7MfnHjefT5gdGmIx7rTqIfYIk43Hl41ODSrb1TZ+0H0OztYSt9c
         /sI9GTV/MLMdS7rnoViR8mYZbOGjsZ7xtJXDj5qfZLjxznSFfyshuq4S10xO46GaM82G
         fDspnvoVhdWJzOSNjyLAU/2Pvb24+xI0LfB5lVuWupIdhG7eXXB/c3mHJpNRZOY5ljYp
         qwKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RO1ALo6rGvkRZzMPDR0dwgnWLVZ7z7ClwqPFL+Bi9NM=;
        fh=YeDnXYw2yJuFkO/zmtuGlENCFPudUGECmIg1gsW/Qds=;
        b=RCAvK5zlkiBvZ3TK4ZJHlBHPS+v3QVRFzWMinPko/H2d1J722XH1bqzKN+K6A0/wvi
         wEDgesubLetOEs2Fmguki81QU2G2hgsAuaBPbCt+AvX8MY/vj5ZtwZsTasHYHcom0H/U
         61Ftf+81rebK+p+A7v4oyHwCu2iL1YAMC1jGkbc/d0+cAdKB9Ts+fbKbsozxuO5V0jD4
         nsOG7mRnxBK4DLQJQl+HHlagsmFyXMCw8nTqzbdgIekii7du8dF4b3ge4EF7ElkeOOgh
         NFu796Ia31QClpvKPg+CNrrPObY+7U/HXRHoeM8jpsSMwCowsEhg9/BLe40TXYN2x7aS
         ef5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784839602; x=1785444402; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RO1ALo6rGvkRZzMPDR0dwgnWLVZ7z7ClwqPFL+Bi9NM=;
        b=p4zI7vStlkZe4g0KCiW+kho9IEYqXsAvecUPtQ+q8bK0nX/oFh2wvQB9kLr61YAPoQ
         q9CptxmZLrxfMs80jd8Nq/18QviEB+XyMs0weWi4oW3g+rkFHar5smId3lzxpWC93egS
         DexnLGznfVnnnz1DOBYBdtmpbLto5NwBZTbl2EoDCU/o6bVjDeqdkwVloJrfXWiqN8Ep
         R3G65lqz83ZGEpweVhzlt0y4sXrdlZ9rZKPE8Q3RZmzWw8xTYGYrE8nih3dBBLjg9rpc
         Bm6LoYffvGv7bJGo+4jkuyCQa2vmeL5/Tx20+VhvBCHqfetSB+2S/slX7gQD4OsTHpdZ
         lD3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839602; x=1785444402;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RO1ALo6rGvkRZzMPDR0dwgnWLVZ7z7ClwqPFL+Bi9NM=;
        b=Wg6OQqDc2cA4VGxMr8ChnHzJBDc6h5ilpHTlny+af+NfQZowyYITGLpikKIl1bwuZW
         DUEOiBW7ywUBufeUcE2mEqTLc3gLwePfbtyoz04b/p/UVySnodsT84yVvziHdurzit1X
         PErh4VUWynR3mqxo/OgC16s9c/gUdFFukh7k7gtSQgZX/6az/Gw9j9L/5e9THTYUmjQ3
         JN2EX6+MdLvl3ug1hZ8S00ho5t3foxkJRPlRIjHSFEBDd0m5iM2FlKF99vOn6lG+JxDt
         xNWdaE8HLECl+8591hVw832HvcmBoPQTqVkxLoTm2q/deibJzUlYheEWEPrUFs7qNVZn
         wJrQ==
X-Forwarded-Encrypted: i=1; AHgh+RrGhRuNzK3G7QRX9UqvXpGCYhVgnQpy9zxlfvyIG4OUmmQO/h9bGeFannaMiSXjsFUqyg3jmVA61PuG@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0ADWhJMTGBu8LbFrSSvcweh++ZuG6cgcGcNaf6skYj5c5Us8j
	/yesCk/0eMhUm88p7gzRjvtrmZGD0YXct7dQu48/eEoe6S5WmcizCYK940Q58yKcd3RQyhQU5Qf
	Gf4iVInf1d0cZEQdMeqoiA4fnqZf580g=
X-Gm-Gg: AR+sD13bvRt6HwjNAawrBmlpioYt8N8tAz6SCBIstryGusc0nWiWw7zocVZbxk4V+rj
	cuGQdvPuHigW75kVQc5sjW3MS8xNJHzGsxKRPjyBHn4hDB9eMKaZcVowg/Xe1KIDzpV2paOmvfR
	8gAI60IbN7wwRuUzD9qQmLWRtFuEnwcm6buIu9TsaeyCyB3SIA2+kwsMcmh+8C1+X7VvCRVUQiV
	YeOZn0pg5BhDQ1oB9+C1IWiSndnb/kGxf5ZUAWH9HcRxxdi+zgVkuCG/5pe2vO2PypFowZXxf81
	sy2K7uk++5stHmUYLcQuMefKvcSrvnxPYF4taR5wKfR/WPw9Q2oJfoLNPsI+VOCgflgOz92Thn7
	JfLnlEJXvDYQa43v+FjLDZPfKa6jirUzSsLeuq7Js+YOTYGzEEhWR1Kh4fRWHRoyB9aqOsfzICB
	Y=
X-Received: by 2002:a05:6214:4382:b0:8e0:16f0:28ab with SMTP id
 6a1803df08f44-907ca24fe91mr57082006d6.11.1784839602163; Thu, 23 Jul 2026
 13:46:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722211844.123697-1-FredTheDude@proton.me>
In-Reply-To: <20260722211844.123697-1-FredTheDude@proton.me>
From: Steve French <smfrench@gmail.com>
Date: Thu, 23 Jul 2026 15:46:30 -0500
X-Gm-Features: AUfX_mxl2KecmmKACnrpTXiw6GL0t8wes6MChB0-ufnUqzm6_qBP2n26Pxb1ulk
Message-ID: <CAH2r5mujqOXko8yWpBM=DTr=arSBGEUd0HqGETRd+kiX8DVMgQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: use GFP_KERNEL for registry allocation
To: Fredric Cover <fredric.cover.lkernel@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Wed, Jul 22, 2026 at 4:24=E2=80=AFPM Fredric Cover
<fredric.cover.lkernel@gmail.com> wrote:
>
> From: Fredric Cover <fredric.cover.lkernel@gmail.com>
>
> Currently, cifs_get_swn_reg() allocates new registry entries using
> GFP_ATOMIC. Since we lock a mutex here, this is clearly not an atomic
> context. Use GFP_KERNEL instead.
>
> Also, fix a minor grammatical error in the comment above the function.
>
> Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
> ---
>  fs/smb/client/cifs_swn.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
> index 9951817d0d7f..fe10719e627e 100644
> --- a/fs/smb/client/cifs_swn.c
> +++ b/fs/smb/client/cifs_swn.c
> @@ -425,7 +425,7 @@ static struct cifs_swn_reg *cifs_find_swn_reg(struct =
cifs_tcon *tcon)
>
>  /*
>   * Get a registration for the tcon's server and share name, allocating a=
 new one if it does not
> - * exists
> + * exist.
>   */
>  static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
>  {
> @@ -443,7 +443,7 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct c=
ifs_tcon *tcon)
>                 goto unlock;
>         }
>
> -       reg =3D kmalloc_obj(struct cifs_swn_reg, GFP_ATOMIC);
> +       reg =3D kmalloc_obj(struct cifs_swn_reg, GFP_KERNEL);
>         if (reg =3D=3D NULL) {
>                 ret =3D -ENOMEM;
>                 goto fail_unlock;
> @@ -451,7 +451,7 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct c=
ifs_tcon *tcon)
>
>         kref_init(&reg->ref_count);
>
> -       reg->id =3D idr_alloc(&cifs_swnreg_idr, reg, 1, 0, GFP_ATOMIC);
> +       reg->id =3D idr_alloc(&cifs_swnreg_idr, reg, 1, 0, GFP_KERNEL);
>         if (reg->id < 0) {
>                 cifs_dbg(FYI, "%s: failed to allocate registration id\n",=
 __func__);
>                 ret =3D reg->id;
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
