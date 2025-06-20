Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22C2286890
	for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 09:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750412706; cv=none; b=N/viiGy04L7PPJE1CWMc+FLZOsYUEo8tUejc5iVpvE/glN7jqP0PhAm/3DqBUI9Z/WSPoseubmMWgfL6ZZMsxl67kKwuBNw1hFQRJVZ2PhxTJuLwJWpUKUKZz+IhiJNn4j+HIEA/EN/TX1fMzc2npanPQ0mU8jIYGaFETmc5S4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750412706; c=relaxed/simple;
	bh=dBOoTv4i6yEtqfqEVzdE+rCIFSgM1j03mwdUuhkcxQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IPnB2Y6ry27DRS9Bz+7LrTfNiRYNJbvpATeOYaaVOoLsmnNCTJJQcjR+vYdyAppjlWheMD669RktWfNnARd5UuhFi2e4U68EjY6Lep7CVRqJecIrMo54/MEiTFXKXxDImxptzfvB6uJSVuArtb25nPaQ95w5EgG8Ml/qgWiyWlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iUet02xA; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iUet02xA"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-60727e46168so2990340a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 02:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750412703; x=1751017503; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xf/Ui3B8EysKOwydlmY9cZtRWBamuznt+8fmcEjas9c=;
        b=iUet02xAHS35gBBZWwFCgJ6kOp4OkiZsuk1nqMzCUI2+cQFSTcdCr3cGBnU2Xmc2gb
         oVbW25yarXJxasp0TexojcI8ZkwSbtHN/fZVPWX64Q+lrnzDNeUF8K9X308uWwTpTPrh
         6wmaSVWFmUr2ddMyQ6gym//PBNa7wukwlMB+aLraTNk4vN+X2aAMyMJ5JQFYlqDZJRei
         Um0a51fCshCfCLHOYDfmsbavTq0DO05e+mvbaOayUfaAjjMg/4q1QkAUPvcrmXMpnQfE
         7iqwwnPFLZP/vvctpdEEy1ylYoHc9670NzeE8eZ80CpkfTtiLzBAJjKzNmWUAA+M9DCe
         Xy3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750412703; x=1751017503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xf/Ui3B8EysKOwydlmY9cZtRWBamuznt+8fmcEjas9c=;
        b=idF7Eg4cr9wGA28MAE3zJRuumZpSlBgXkwcuuLX/NL2shBiaDQt1DnDQMhbLakg2An
         d8CbTtAjoOgAy0CV5ZCgYDloi1gRXXUNYu9/on6ULzsTA+bk/ScB6cfJBWGWTKVteFxc
         /UdpuxRNvncE6xhiDmdFXtGc57SST1+ntQ+ZcHXmFZHF8atfeCy619KqUPgtpssequSi
         vGSiKCDk7lU1WCiR2bnUWmJ2Kp7ye1qSmDpyyBatLcnH2a0AQAgGW8AuNKVY9obJow9f
         Cr9gxE6cJ7kHbddC+C4vlPgrhMlPgXtjggnDQdIWYS7uKU18csvYzbbs5Wy7AehIo6wp
         t9kg==
X-Gm-Message-State: AOJu0Yx2e6Yc40gHpc/4C9AhodAwfRuWP4HUFg6dUJ2zqq4twhgpbchC
	hVVYiJTY1K42kfyM6p04Q195nFnZdsF24r4gUWjjC96MoKYxuzdj996oL85wLaiNeFC9wEq6Hw4
	5ed4zm2EXMBuvrK0WfmG8Z5xinpoO3V5YByUi
X-Gm-Gg: ASbGncu7NfmduZyAeqdnDhWcuUejjinM7mdT8BBFuUN6tzUsnAePPpPFfJOaSKgF8tm
	pSnvQ7MAZXcbjzAUvHqqsRvfwYouLpixLH70LKvoDPJsi+tOZNvCCR4nUvqiJR9xZtBNo3eriyb
	raAbOTpmGVryNzBPzUQceM38cJXbBuhzzvlxK/xlr+5kx0cQI7kQ2C
X-Google-Smtp-Source: AGHT+IGnOnH5JMudmXvRKfDbZFYBrbihbn6Q9fZ+x+oRaFknvnXPdTg55KVqbMkUQVnG/wHhvmnml8O7oZ7bmjUqcrU=
X-Received: by 2002:a05:6402:909:b0:607:35d:9faa with SMTP id
 4fb4d7f45d1cf-60a1cccd2ecmr1845152a12.15.1750412703235; Fri, 20 Jun 2025
 02:45:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619153538.1600500-1-bharathsm@microsoft.com> <20250619153538.1600500-4-bharathsm@microsoft.com>
In-Reply-To: <20250619153538.1600500-4-bharathsm@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 20 Jun 2025 15:14:52 +0530
X-Gm-Features: Ac12FXwiyNEFf62Da40EDzjstFQEahApJwH6FRJAkdaSxaeXhk6JKnatYeCtjTA
Message-ID: <CANT5p=qtxFMFCJMq25KMRwLd-LgmjY8G80mdM68qcVEbxEhrJQ@mail.gmail.com>
Subject: Re: [PATCH 4/7] smb: add NULL check after kzalloc in cifsConvertToUTF16
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2025 at 9:06=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> Added a check to return -ENOMEM if kzalloc for wchar_to fails
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cifs_unicode.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
> index 4cc6e0896fad..7bc2268d6881 100644
> --- a/fs/smb/client/cifs_unicode.c
> +++ b/fs/smb/client/cifs_unicode.c
> @@ -466,6 +466,8 @@ cifsConvertToUTF16(__le16 *target, const char *source=
, int srclen,
>                 return cifs_strtoUTF16(target, source, PATH_MAX, cp);
>
>         wchar_to =3D kzalloc(6, GFP_KERNEL);
> +       if (wchar_to =3D=3D NULL)
> +               return -ENOMEM;
>
>         for (i =3D 0; i < srclen; j++) {
>                 src_char =3D source[i];
> --
> 2.43.0
>
>
Looks good to me.

--=20
Regards,
Shyam
