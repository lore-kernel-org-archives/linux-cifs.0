Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542C83D66;
	Fri, 13 Sep 2024 01:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726190058; cv=none; b=DrpoaML073rnARTJmSgnOhuY+fmVcvuciA9LeeXv7maEYX3LR1+fwr5noqhOwp8xGBuzeMNLnaHZ+Bj4yJyX12o4/Ko1JXbE54TJNXmb4MC/OYbIkwh9VqfllE7kkoaRjkaCuaX1hFlu2Pm2tBluukfaiNHAvZFUMZeBx9q6vs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726190058; c=relaxed/simple;
	bh=c0yaicf4NJPfYOK4lcoT2jZH6xYResdEE1c5u5X8Y18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lrIzw7797vqKtgkZFo8avsL0e5QdF30tl+cKoCQ/3GupJIiIc6excH4DWcNhnvoNtCCmR73PyweOkxT8YwQabukh1EIncZW/5JbgY+CzoZypt1iccKCVbl4lD40IJMPYsjz+iar2OW9gRL86oRG9S64sTCFq/70qka59jekrwZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CuS6415l; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CuS6415l"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-53654e2ed93so1884390e87.0;
        Thu, 12 Sep 2024 18:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726190054; x=1726794854; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gAgjzjVLvrd0brRCe5Bge88sB90MQTZTYNADq3HWyr4=;
        b=CuS6415lZWkDohbUnKiD8FkuEIImDaUHDoSeaD3+VriWLgPKT8+SeN0fPz8odMHRU7
         G+sKBJTwBHJPzmbdDAhLNPDFP5mP9TUg1OWvwZPMq2zi/2caMrVCdJ5wSNv/Ss12QTXt
         6A490zEwqiCZt5dql+NkXp9/+mAwsbIEgF05+ScC/ODsUEmhfrrWHptvkuT+CnZmvme3
         3ktfVXEQnhothx5fZauh20FQuRF6XwXsHCw+g9+X/KQVeC1TIV2mFkrKQTOqbB3u2Xqi
         Nrtl2+4E2/+V75Ms2Oj8V71/peQwVe0FWq+D7VnLdvVoDy+GiaZ61aJcoK0LukQ6+6DA
         YQbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726190054; x=1726794854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gAgjzjVLvrd0brRCe5Bge88sB90MQTZTYNADq3HWyr4=;
        b=Zl9NkKkuFF+QtRDih7WJHyV+4n6PDaTMf06FBaaqlG7GFKvRvWDPlIDTUhaa2o9GIS
         lpRFm3fQcOy7DJcS6xhra7z9RIK5NXYVqiLxUCuI3729xeQCExZB/fxbP1WUqWh0d7u9
         obeMdU64ZV21voBmIQbHJskvGytF/W2L896yjzQpG/8tgmYyaypH6pVHkjKYNaQ/QuKl
         8zS4Wqdy0OV6d2ehPpW9mktn3uXAAbH1X2jFDaUvds2F5Aw5ywIPa2tCzUd/sazggEps
         rQVhuDteppwk195LFKqmHIvos/Mkn1yVZ3DGhmFAhBk0FaRTr+N8WZ4ZQ13Krn+WQstl
         Hk3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVadYT3czHxrt/iuTNVaOaMurHDXcwaiHf6SmahotiBFc53QHFTvJmoJYT4Ih++q9Ajkc84Hm/zIFB5@vger.kernel.org, AJvYcCWSODorusE0GecvyYGtn19uxSPMc5a0ZpeO9OkD1tlG7TJYBLEvofr4ERi+hliU3u2oX2AQoSBQWXQRRq1v@vger.kernel.org
X-Gm-Message-State: AOJu0YwF4FAu7oS4d3GAay/K5FIRyVSt/SHWkZ3AkbUXylyUz4hNP5Ah
	tr7KJ77plQOMfaZqmvzT3IiEz5mdkN4qJoEKlAyLNf9vulq4szgWtPpvhpk81ywz1mntBTvM3yM
	Z/S+hGAPhMjWoZ74DK4XoTtp7MdE=
X-Google-Smtp-Source: AGHT+IGlElygHVCvY0Le33o89IgiMFttT6HzN3W3uVWF3oe3t7E2JSa0on0oe9QBj841OoS5+B8fw2UwWTAdQvK5aa0=
X-Received: by 2002:a05:6512:12c4:b0:52c:db0a:a550 with SMTP id
 2adb3069b0e04-53678feb66dmr2789764e87.42.1726190054084; Thu, 12 Sep 2024
 18:14:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240913000053.123052-1-qianqiang.liu@163.com>
In-Reply-To: <20240913000053.123052-1-qianqiang.liu@163.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Sep 2024 20:14:02 -0500
Message-ID: <CAH2r5mvsuTE=DoP-TwzSsREbGTgnsdNMMnPzK2ypLts6YuX_dg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: compress: fix a potential issue of freeing
 an invalid pointer
To: Qianqiang Liu <qianqiang.liu@163.com>
Cc: ematsumiya@suse.de, sfrench@samba.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch.

Added to cifs-2.6.git for-next

On Thu, Sep 12, 2024 at 7:02=E2=80=AFPM Qianqiang Liu <qianqiang.liu@163.co=
m> wrote:
>
> The dst pointer may not be initialized when calling kvfree(dst)
>
> Fixes: 13b68d44990d9 ("smb: client: compress: LZ77 code improvements clea=
nup")
> Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
> ---
>  fs/smb/client/compress.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
> index 65d3d219e8bc..daf84e39861c 100644
> --- a/fs/smb/client/compress.c
> +++ b/fs/smb/client/compress.c
> @@ -318,7 +318,7 @@ int smb_compress(struct TCP_Server_Info *server, stru=
ct smb_rqst *rq, compress_s
>  {
>         struct iov_iter iter;
>         u32 slen, dlen;
> -       void *src, *dst;
> +       void *src, *dst =3D NULL;
>         int ret;
>
>         if (!server || !rq || !rq->rq_iov || !rq->rq_iov->iov_base)
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
