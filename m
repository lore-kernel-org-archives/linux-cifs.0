Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFEB390999
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 17:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782237321; cv=pass; b=nyx+LiL2qogQjOzknEMAne0hIfjTCWQ1IQJZ9fyGSO8AWJZldHcsh11232DXou/hrt98eZyaW13wtKlo+0VvwEB5M+fNRl0ohVUWAR4sAnZ0SpIYN1b+hZF/UhJ0+LYfs56aniG01cQfJpxaalJuAHnLr/Qz6PbKUi5dkfaLYZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782237321; c=relaxed/simple;
	bh=EeXi+hGCAdDhkUHDhHTHamjLLYH+F9berW68uRQrO0k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bkeAiFQ2/6ejfqGIqnQsYG5a/4xYRlm2xmRvMtHeq37cFR3iTY8eCiPCMAwo6IJYUNwwdYEEuqa1oYyQAzFpHsRtdCDq2kmZnD9S8xpOl1RU5p9jKfP0ePwy+gaz+78wRGQ3Jzp4TvNVmvJyiWdGc7nhn/cjQOZggD70YWMmXAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tBYAhfpA; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tBYAhfpA"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8dd586317ccso1635336d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 10:55:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782237319; cv=none;
        d=google.com; s=arc-20240605;
        b=QqUdFISQyIFLiQUEXgBixMb0IDMYz16x8aC63Ty8UAFl4yekIjBz9c65NpLwUSgf46
         /XXMTXqGp+AuTKiSmmdU3vXMVIUR/hN+4Cp7yLjiTbtPc7a6MLUsTAZUu5zDsdxKU/tI
         wBt90sm6ov3kk75skyTxNswpT+qcEcPwpfZopnylrH9gLnHZS37KLTImHPSAaUtIHbOI
         Tf4MrRiNZYS7R/GwkCxkxkbdDjmbNN8mH0sOkdSQmxxxvZX7RfWvxRQx5Or8PPUxwjDm
         b60piX91lqgtUBi15UydEmcYXJLJ/oyKrLHTY49uWCfUXN9c40QOEblkAYX4HU4sX/HX
         fwhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eVwHoQAGVfOimcPWgMqQ8TRVG1yeevHhR1Dh7M0wd54=;
        fh=hEuD4dgbOIecppjqeLc1ut/hrkKp+gN+LyX7aMhXvAw=;
        b=FBgWj+MB2aBL6gW8n2B2PVKr36XeVHjPo7OO8Gq0d8LUJNtaduyhP6fFgOCVj+bhko
         6UYuym3TjufzDS+mOlJvMpNTn6VDbGHEDIX18pm6a8k5RMau1tnKPzbXGavHcawnjg6p
         H3pdqtmlRIYYGhbeXTfBKmpU0V2i2h/u8PuWwOeR2fslIxJdV3ie+UXB69ZsNzi4ebIe
         OwQs3Thfdq7u6bcdiNBzohC+73RBjTV4nDD71eUZqsaZYcJt7hO0J+l0DPbAUigGoQfo
         xiKkv5lb0PQZnPLzOYWuQuJ7NH0E3Dz2y1N52jhLGB0aDoCciQ6HKxDakozK3GhxEvER
         fHNA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782237319; x=1782842119; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eVwHoQAGVfOimcPWgMqQ8TRVG1yeevHhR1Dh7M0wd54=;
        b=tBYAhfpAhMnjKyZeTS9CLWhuT2PfhABxSH4EWD404z714m46f1MYLCIdBy6/nnfVLX
         5QaY7EiN/nF0ElIcHTeZq3P0HjrU1kC0hs5h/h438kdHmZtYC+ZGe5Y35UQbh4lfA3fb
         7VHX0KO4joSNLU41lk8iTqoGO1WatUFkUR+NWRhLXFZDF2ZSO8EGm3KQ+vJ9IpXinMRq
         B5001lNh8HdBHMkyO+DFic6zjVmkpL4gvqdJ/PEVhiBMMLl8YvA5vhHpIz5qiqm0R6CZ
         eWK4fp62y2nYf0sBA/i2t2HVS+tF/NOfBne7yJLr0/rOsNvmVUk7TTLmT61hsG03V3R4
         b5/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782237319; x=1782842119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eVwHoQAGVfOimcPWgMqQ8TRVG1yeevHhR1Dh7M0wd54=;
        b=ruLwnd5LWnbRfiqEwViij7psvi73I9LA5TuECAfvcJgFK2Yh21o8+raBn/X+vuhwTx
         eUhfRlNl9wOGvprHobi+NU5M7k9sMEz3zDov/hvf+6gGhPNa9xZ9K3YkPdzeIugNu8Q0
         Nil3LC+n/UUZN5Vpaiy9MzAf73BUqylbqxaxJnNmAE2TSNL7nCy5x78z00DSea2qCtZC
         oTgyaE8MXKyB5UdrMiykN+DbnKbeBTtEmIvcJqHiMwbMtJRvHTR04GLB9o9DdTtfiG49
         aqXGO4GBdiiy+4wpf22fO7ZUrsyKfhq/tTbb37xbVdSg294cIaJLASvzhfZIo6pSeUVL
         VaVA==
X-Forwarded-Encrypted: i=1; AHgh+RqM1CmtDW3blDlzMdUbE0Kr1wUmlBeCC+WIw+Hc30sdSLZSwefIgRJRnKVBTRncLf0b4TDrM5l/bNc3@vger.kernel.org
X-Gm-Message-State: AOJu0YzmmqKBpYKRp7DjpGiucqw5Ny+4w13rSB5Z2slCimR0hnYO9Mvy
	lrVi3I9tqLcUJQ9wfLkFQfD9uNyYwpK31xUqYMhQ5O45k5TUZOL/LJh3IzBJKewaSZEuatY64O9
	crfqfK6e40otIUnmOKRPCS9krG05YUpk=
X-Gm-Gg: AfdE7cmPdrX3jWHUMb301Fwz0XLrXwfAjAuHEdobUUBCzz/p2qjQWThwyIHN2ICWukx
	Gfe4dCT0ksM+a23F44E0tLwLC9MegcPEK3GPD13A1RY07GoWHwuZudj0XE4M1Vn60Qv6WGDgZHC
	wYgPXtu6TM18OLBUYdM1JTJ5Jtb7Sw+6wqMzHyU2/t2NG89ppmMqhw4Gg3nAe+AH2s6X5AOatb6
	vBLLkL5U9D3OBT4GxIJXwRSuHgHt7RYnxj6jvon0OPKxNrZchDdz9RzBgP7ag0/7ocGIQDITTeM
	mWUe4zYmUZ2m0vUcJeJXYx9w7eI91LHpdIHYr5ykGNNOHSNk689KbHsYa7W1DUocPVtcLGuZm+F
	1UQw+2b+2H01L0ugF/c6Bw7LIIXAGtlXEnh7ndYl7EyNpLUZ+7+GiwSMSUnTJjLPhGjbgm6YGaj
	UU5TZTLU7AC1s=
X-Received: by 2002:ad4:5969:0:b0:8ce:af02:fc7b with SMTP id
 6a1803df08f44-8e52d4ee780mr2876636d6.7.1782237319194; Tue, 23 Jun 2026
 10:55:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623164915.42518-1-FredTheDude@proton.me>
In-Reply-To: <20260623164915.42518-1-FredTheDude@proton.me>
From: Steve French <smfrench@gmail.com>
Date: Tue, 23 Jun 2026 12:55:07 -0500
X-Gm-Features: AVVi8CdpNQJ-oZrJxG4A49SEB0gVbxTt1M0ZQR7sf2AUIKsRp0Xmdwb7brnvLYY
Message-ID: <CAH2r5mvdJD5P5mJBS5d3KGSo3A_vApsNesoRhEPYcw=EMz-QyQ@mail.gmail.com>
Subject: Re: [PATCH] smb/client: use %pe to print error pointer
To: Fredric Cover <fredric.cover.lkernel@gmail.com>
Cc: sfrench@samba.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending any additional reviews

On Tue, Jun 23, 2026 at 11:51=E2=80=AFAM Fredric Cover
<fredric.cover.lkernel@gmail.com> wrote:
>
> From: Fredric Cover <fredric.cover.lkernel@gmail.com>
>
> Currently, __reconnect_target_locked() prints the error pointer
> 'hostname' using PTR_ERR() and %ld, printing only the error code.
>
> Fix this by using by using %pe to print the error symbolic code instead,
> and remove PTR_ERR().
>
> Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
>
> ---
> Found via coccicheck. Tested to compile with CONFIG_CIFS_DFS_UPCALL
> to ensure that __reconnect_target_locked is actually compiled.
> ---
>  fs/smb/client/connect.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 74197766471c..85aec302c89e 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -457,8 +457,8 @@ static int __reconnect_target_locked(struct TCP_Serve=
r_Info *server,
>                                 server->hostname =3D hostname;
>                                 spin_unlock(&server->srv_lock);
>                         } else {
> -                               cifs_dbg(FYI, "%s: couldn't extract hostn=
ame or address from dfs target: %ld\n",
> -                                        __func__, PTR_ERR(hostname));
> +                               cifs_dbg(FYI, "%s: couldn't extract hostn=
ame or address from dfs target: %pe\n",
> +                                        __func__, hostname);
>                                 cifs_dbg(FYI, "%s: default to last target=
 server: %s\n", __func__,
>                                          server->hostname);
>                         }
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
