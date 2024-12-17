Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDA81F709D
	for <linux-cifs@vger.kernel.org>; Tue, 17 Dec 2024 19:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734464541; cv=none; b=rFciJS/TB0hRjRx/RSGRnXdgNzY11Q99vK+/9XHL+3pxm8X7w/rkwcw+FhUlcbQNvgue5T/dHEH1jdLU6j0UNcTOwYwKP9ByGICXXb2Y1KbCc0JzRT3u3x57UQkdZ53eSRLIJyVw7IgCHI7H+A4lB3DNJcFOd+Scx8tyLkMR8Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734464541; c=relaxed/simple;
	bh=achiuxBzbM3VEP5eZ162jNXTWMy+0cD2XHlKR/0lQsw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=d4DD0eVDejXp5wYkEsczF/kTRdCz0JoGkp8RLi/ym/gRBCH6QferIA3C+R0jLK4V22lyLbvLr6+nD586k7xyXrPN88TlKuB6nAszi+kPg4pCFQG0yoVx3MH2zUi897CwX/0xeVh1yam+COVvA3pUA4q2izQsJ9D+QbrENJ0/ltM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EuCITKvR; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EuCITKvR"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53e399e3310so6619985e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 17 Dec 2024 11:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734464537; x=1735069337; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f22HL5gpkon9dTeKpgexWS/AAUlUTb2ka1v0JukniNo=;
        b=EuCITKvRHu6enlJAUMo4n7mDYtv1+d5wd8WkVPQZrWke9/mF2HAreXgDDWPjZdOA2J
         dihPZ8bgwwvK5neTq4HwesRC2wc+Z1VqcCthRaSuaVcimPbKM1l8WMnx85SZz8AvsUWJ
         KTMsB3fxVh4fCW77Vp4wsUXXe8C1M2OjQeB4vPlAaPzt/sXfxZBnuC39dMc8opv7VATx
         ZJcIYXg34TAfS67jnmpP1aJ+hc5HyBvRaCjpQoYXB/kdbj30dzi2pihbXSGsGJPNsTv9
         UjDzJ3p08pnOv/vuSWMFNT6R5pYF7VKxs6Qixzl4IsSkI1/ik3jiDvhENhc+nr2ybPn0
         dL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734464537; x=1735069337;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f22HL5gpkon9dTeKpgexWS/AAUlUTb2ka1v0JukniNo=;
        b=C/p9hLlx6p4DiqDYi+aY99P9pnOcJGkjUIC7KMuLCmWg+u/sXtWw4MyQsUXYV90jv7
         TwlZzFxWnLmXdG47hrTpEkOUzpyWCZ3QUo45mmXyPFsHYWer+8g/vIypvhM+qGElpsCJ
         Ngoiiji1Kt7QFTuD1q8nwTJqLh0hK3yxOk3XQhW+1X0DORrg773tUHZrVrT++wojdA00
         bJSuZRQ2wVDaSJX6KiI+XvndTkZvWqfkyZcgzjV+wLpz4Z9+4ffNZS3sY6YjX9EM5bFx
         XdGX4pbJtzNCO28Czy9ETmPvKGjyEXPm33bHnYj9DonXu+gU8b1zKnTMEXWWUK1iBXW2
         Zdyw==
X-Gm-Message-State: AOJu0Ywd2yk3ZiMD1NUpiE8PxG6bb3UrHQKoQ8NbFp8Gov2N7ryOM9iL
	vrP/FhL+fPh/OF9fJuAfLH3EzIyZ/oPj+qxggUrLw/O8dpSj0LU+qCDMjEq0HD9fv1Pd96nYiCC
	VqycodzrwRYfb3YmmlETUmL2tlmrDGA==
X-Gm-Gg: ASbGncsX921LsMFaidykam5ERdbeGNy8xUPKxKURhYIUWiF78+VWu94LBnERyqWbZbp
	wr4TfEdoArIIa7D/S//zqJ4100KVaBwucBqsli8meTyN8DyNywI2QxXkRO1b6LDhm8c+tlKCD
X-Google-Smtp-Source: AGHT+IE72eXnX/sUeBtrIbIymV/8G9Gv4N6qVCVZ+gNmaAuTR+yZzG7En4CVK4/E1VwhTU2POOQAAGN5VLIP9jz8mlY=
X-Received: by 2002:a05:6512:3e16:b0:53e:94f9:8c86 with SMTP id
 2adb3069b0e04-541ed900027mr117313e87.35.1734464537318; Tue, 17 Dec 2024
 11:42:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <011da8e5ae7537ad188cc49cee6f96e09eb1b8db.1734427173.git.dsimic@manjaro.org>
 <CAH2r5mt61UvqdE-15ndegOHROObk0CfcZxMnTZeSn9oJymY=YA@mail.gmail.com>
In-Reply-To: <CAH2r5mt61UvqdE-15ndegOHROObk0CfcZxMnTZeSn9oJymY=YA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 17 Dec 2024 13:42:06 -0600
Message-ID: <CAH2r5mtd9uS_gJYS01mdBxHP=2Rn4vh8etLQkZnUjyNeTGWd6g@mail.gmail.com>
Subject: Fwd: [PATCH] smb: client: Deduplicate "select NETFS_SUPPORT" in Kconfig
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Tue, Dec 17, 2024 at 3:26=E2=80=AFAM Dragan Simic <dsimic@manjaro.org> w=
rote:
>
> Repeating automatically selected options in Kconfig files is redundant, s=
o
> let's delete repeated "select NETFS_SUPPORT" that was added accidentally.
>
> Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
> Signed-off-by: Dragan Simic <dsimic@manjaro.org>
> ---
>  fs/smb/client/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
> index 2aff6d1395ce..9f05f94e265a 100644
> --- a/fs/smb/client/Kconfig
> +++ b/fs/smb/client/Kconfig
> @@ -2,7 +2,6 @@
>  config CIFS
>         tristate "SMB3 and CIFS support (advanced network filesystem)"
>         depends on INET
> -       select NETFS_SUPPORT
>         select NLS
>         select NLS_UCS2_UTILS
>         select CRYPTO
>


--=20
Thanks,

Steve


--=20
Thanks,

Steve
