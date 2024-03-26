Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A42D1CAB5
	for <linux-cifs@vger.kernel.org>; Tue, 26 Mar 2024 01:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711416418; cv=none; b=QdpsYOgI+nWlj/SMBwDMrcuKFfpx7jW4thZ+/kC3CxCOXr5KdS89RRyQb82XZ+EwyIQ1uhNo20jllNji/Itu25KdzLf5Bq4qpU6RMwicwqSCD/0CErDXR49Jn7kc9GPXrrGnLd6hMHD663tI6tKsHeSQtBUCMw3r8g/mA8xiFl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711416418; c=relaxed/simple;
	bh=lCH886INZXeO6dZhtoT5wP0+e1hXNKhcqzhydCUvLhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J/MfBCKhdGSSsKFbjZcvEPPihHdyLNCtdlJ1AY91K0BUM9NB63bF9RJ6KKATYB9pxxexUrMClBfHImFENUQwZ6iJG0m4qFRujuNL/sS+X67RTiVeQ01j/X9Wv497vZ7EfJax2O7V0aRUlK/VIssVn/LEgsnwPMslvphGY5jqzu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a2f22bfb4e6so649577566b.0
        for <linux-cifs@vger.kernel.org>; Mon, 25 Mar 2024 18:26:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711416414; x=1712021214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iQcQ1A+iKbmSgwzRlJixyw3CK9rLbpP+XkxQCC5qKos=;
        b=u7PREBpp4hMnhw6xZO63mbpm/uDfcE6dB0H4CLm/698e8utoA533uO5WDrUgHgTIph
         TCst0noe+7z+TMjfZG3kbrIUC4U0mLDy2H+oEe79NK/IrqjhhKjFCqGbNy6+QMgH5mlB
         cB3bRCsZpb9BymfwMKtkQAmDTV4QLi6+RqaUphh70SRMA+T5mKu5WoDs/TyXQJqjA0RC
         MFcy7ph8eCHUOQmYjueJjjqFOnc7NJH8TnlzEeIyhtJEl0oOpxRUlQXji1pT52d3vCC9
         PsMQfX+nGNqwv90EISDU6OCShPhNGkLTdlN3/nfd00oOcN3exQHIOFTCK8gA6aMcfHIy
         7zyA==
X-Gm-Message-State: AOJu0Yw29ffQGLX+HO6bm5RT2aFf4tkoY1mXhRTbAZ+ppZKhLoNHZ78O
	zOe4R9HNQFWnRZazaOnUIyyO/P8goCEPV4M2vI5n+35Zm8Av2D+ZWLaDS+kLdN0d2X2zI61eB8I
	WABFx4Bhaszx3LdNWKITUiM9qhbjwjDi+7A==
X-Google-Smtp-Source: AGHT+IGx0GbO++xneozxzeKJG9RvfJ+/LCKJhZAXnkykGzXJqlMt1tLbleijd4VBg9hO+Ha+DcQrhqMXPlT0VBfS4Sg=
X-Received: by 2002:a17:906:260a:b0:a46:de64:c479 with SMTP id
 h10-20020a170906260a00b00a46de64c479mr5487153ejc.69.1711416414453; Mon, 25
 Mar 2024 18:26:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20220816004335.2634169-1-sam@gentoo.org>
In-Reply-To: <20220816004335.2634169-1-sam@gentoo.org>
From: Pavel Shilovsky <pshilovsky@samba.org>
Date: Mon, 25 Mar 2024 18:26:42 -0700
Message-ID: <CAKywueTjdJRwRwwFYjiy9xppZ_xggUWjBDBirrQhw_gM-0qoXA@mail.gmail.com>
Subject: Re: [PATCH 1/2] getcifsacl, setcifsacl: add missing <linux/limits.h>
 include for XATTR_SIZE_MAX
To: Sam James <sam@gentoo.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged #1 and #2 into next. Thanks. Sorry, I missed these patches previousl=
y.

Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 15 =D0=B0=D0=B2=D0=B3. 2022=E2=80=AF=D0=B3. =D0=B2 17:43, Sam=
 James <sam@gentoo.org>:
>
> Needed to build on musl. It only works on glibc because of transitive inc=
ludes
> (which could break in future).
>
> Example failure:
> ```
> getcifsacl.c: In function 'getcifsacl':
> getcifsacl.c:429:24: error: 'XATTR_SIZE_MAX' undeclared (first use in thi=
s function)
>   429 |         if (bufsize >=3D XATTR_SIZE_MAX) {
>       |                        ^~~~~~~~~~~~~~
> ```
>
> Bug: https://bugs.gentoo.org/842195
> Signed-off-by: Sam James <sam@gentoo.org>
> ---
>  getcifsacl.c | 1 +
>  setcifsacl.c | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/getcifsacl.c b/getcifsacl.c
> index 1c01062..d69d40a 100644
> --- a/getcifsacl.c
> +++ b/getcifsacl.c
> @@ -34,6 +34,7 @@
>  #include <errno.h>
>  #include <limits.h>
>  #include <ctype.h>
> +#include <linux/limits.h>
>  #include <sys/xattr.h>
>  #include "cifsacl.h"
>  #include "idmap_plugin.h"
> diff --git a/setcifsacl.c b/setcifsacl.c
> index d832cec..b7079ab 100644
> --- a/setcifsacl.c
> +++ b/setcifsacl.c
> @@ -48,6 +48,7 @@
>  #include <errno.h>
>  #include <limits.h>
>  #include <ctype.h>
> +#include <linux/limits.h>
>  #include <sys/xattr.h>
>
>  #include "cifsacl.h"
> --
> 2.37.2
>
