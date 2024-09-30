Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DA01F5EA
	for <linux-cifs@vger.kernel.org>; Mon, 30 Sep 2024 03:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727668799; cv=none; b=C6VHla8pOC3jhH8WlZUefABj1Q5MyE6Xman9AKZYae+zWi4T20viD+EtvcpXz4eaNDaHm6R0IC2zv16msf0Eb16ALNzW2TppWY7+dBsX9ybx5a+v12d4mKiuLwGid8e97QSyijAbGpHkAPzSw8EdIO85UcdVzrinECDIrdNlrhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727668799; c=relaxed/simple;
	bh=iVoWxPAgyhMzJlVrgvLz8qA1uTvEYV+nC6NHUb3k15g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ViP8mxjBiuhVoUIPtPD4IlXx9rTD1NUfGEu293B6q6zUkVT4mingTtgej29wILUaTwJ57aa0nPWNs8M3vncK7GX6igNHaeZ2/Mjv+7VOdzZmfWGHTun61TfC0cMbCukdbB1/1kQlVqvPEzy7r/NS8Bqi0J42dCzonY13CyQyoCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XMoqQLYi; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XMoqQLYi"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6cb3bbb9cf5so29339066d6.1
        for <linux-cifs@vger.kernel.org>; Sun, 29 Sep 2024 20:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727668797; x=1728273597; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rPSl/+D4AW6CRz9BgTNpBZmzGi/+7pcJAjQk6puNu3U=;
        b=XMoqQLYinqs5JKEchbMh9AnXLrr62tyLrzsE/7fLfaxxlOUJIYy8M5sd7RnKpJmJZh
         nJtsIz28IzdrDxwjXpX6PX5wzznLO1w4xfnOm66WBthRvgzxO4Xmc9KJiDHHzTnktMrz
         zlQbD84SaaAFQg0N+v+CX/zEff866Tt1VtLg8KOBVyd+khGD8tIweZV7fNd+BV5FxYLi
         Bkuq/vDoZRa+TAHTKILZGQW0enOs7O6QnGePqw6ZZ3ETcyFUfvczxPwpon/j3EC70afy
         ydnrn6389fqEUU9DwFgxEuzTiZIKPG6z10Wz9weH2YXrAi40bWAdVFZaAEpU9iWZsVBz
         C2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727668797; x=1728273597;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rPSl/+D4AW6CRz9BgTNpBZmzGi/+7pcJAjQk6puNu3U=;
        b=AxYEAPRgpRrww+MaYOf5A7u+ciF3XUAguC+4Io1c+S5JIsIaGsB7jKUJ8tE3qvGbd9
         nc24z1jzcJUMM4YipYQaiTikkdvU7X7y/8gdiIcgICpX6MMKrr2T/ui65mGjOmPeLU/4
         m+5GpzPDQ4ZjaX8uL3b+UzTtoIfC7mB2rVZvHAu/RMOWS85rJYlfuGliBHjM2F7xb+Ks
         Tj5ITGj+QzO482lLRcF8NY0eDYrVhJZvZq8yPhX+ceZ+yjE147Ff7pIGnDjUZJYa8Icy
         q6i054LKJU6N71rVjQCRwoktffRJXVUbu4n0tRJvmoGUFXF+fcrnIxnp8kfSyApEB55E
         EHNA==
X-Gm-Message-State: AOJu0Yyz8/jYJCF2Zb+NKtjxbZ/y/35ZQqoIOEDliqmFGXWbUAOlifPW
	zsL+8jVxz254ltbet8LOPKMoSbhYtHo4gY4vRbU8oJKe5W4XcIhWNxz5Vb1VodNIAMm8A8eMGu0
	UM9pZyDy6kYoiyG27E1FwIUBBI5eiPLOYaQs=
X-Google-Smtp-Source: AGHT+IHUwiOqxWwt51uZVVepFe6yAzE0ZUNgbgrDVGe4BInGEUB059x9Ho80uFF9lk0GtH+Ovr7PZPjVZaMarY8eC74=
X-Received: by 2002:a05:6214:4613:b0:6cb:2242:df32 with SMTP id
 6a1803df08f44-6cb3b5ee4a8mr181102976d6.20.1727668796702; Sun, 29 Sep 2024
 20:59:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtp0SNG1yvDq8rDUWOYQrZh9_OtFFKWCEmOXeD=Ou5i4Q@mail.gmail.com>
In-Reply-To: <CAH2r5mtp0SNG1yvDq8rDUWOYQrZh9_OtFFKWCEmOXeD=Ou5i4Q@mail.gmail.com>
From: Anthony Nandaa <profnandaa@gmail.com>
Date: Mon, 30 Sep 2024 06:59:44 +0300
Message-ID: <CAACuyFX7J9Ht2RdbarBFp+VvF9Y8800mezYMFVmQApaAzOKxYQ@mail.gmail.com>
Subject: Re: xfstests generic/089
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Steve --

On Sun, 29 Sept 2024 at 18:32, Steve French <smfrench@gmail.com> wrote:
>
> Has anyone seen xfstest generic/089 going forever (sending compounded
> open/close then open then close forever)?  This was with current
> for-next, running to current Samba master (localhost) with "linux"
> mount option

Getting the same, tests gets into an endless loop even in the
for-next@f9494b6b6dcadd3ee1d70d27d1419d1084e98ff6 (Aug 20).

Could you please remind me how to get more verbose logs, or
an approach I can take to help debug this?

>
> --
> Thanks,
>
> Steve
>


-- 
___
Nandaa Anthony
