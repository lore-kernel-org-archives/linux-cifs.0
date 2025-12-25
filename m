Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DBD22127E
	for <linux-cifs@vger.kernel.org>; Thu, 25 Dec 2025 02:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766628008; cv=none; b=LRN2Xl5zHZRYkANeVk47G7Mbnd/zDvBIuAUA8VbnDsBImY1P3QViZryBO0MK03i0u4oNttRz7ruYbL3GjeVfCC3g+9guh6cXeuOt6mgic7fyY8jwY/X1HPO3E16LDYee39fdrqUaFD9eitbiyT2WyBq21hADhKyZZIYlVhYA8ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766628008; c=relaxed/simple;
	bh=PJAjFawFtuvQmiZBKO/ONWIJjsXMMw3AJGnr4f+obVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cZ/499f9OFaClTGd1FKeimT5RuKlQop/9+X4r9fgw+8B1H+Rp7mkajMBtSfHO1AlbyFUYB7QZKj9XXAnedVlyq/XRKPpa0JeXWceJWFb4qBpjm1ECd1hVSaa8ejD+gBJJOMUqDmrYjM740FiR00zNhRhLrRDQGab2z0fsLO9E+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X9aacYVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X9aacYVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41899C4AF09
	for <linux-cifs@vger.kernel.org>; Thu, 25 Dec 2025 02:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766628008;
	bh=PJAjFawFtuvQmiZBKO/ONWIJjsXMMw3AJGnr4f+obVA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=X9aacYVHa04DKdhfT11thyJ/OlV/c0WsmGwVsDTgNpEw8jfsr1NebtMxsJUEdfz9D
	 38xSupDlI4PlHSldgGCkk9iaN/Ve2v4PO293uFnuE7U0qoYSjRvuUsHFxgI3m66BFT
	 bJMF9hO8qhZsyGHxLhCDCqUzP963rN8k2vKZHCN4HkwW7FEzYnigwrroWansVEmHmJ
	 mFBVKNvcd92EXToWDPDqoy9Az64ONGZMr7LaOHnfXoHUsJyk4uhbKP9wblcrWLgw//
	 gtrv7aN0uJUNqmaCmtWx7Vqqeu2gkR7/aPqY4wbbTYzBYFbsmuT2zxcPpZOIRUx3/+
	 cP42FMgHhZ2Tw==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64b8123c333so9190603a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 24 Dec 2025 18:00:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUIStrL88SAGjnckBpOy1DTMo+0ZG48pZp7AQHDjWrplNWboT3mgFQvQbkKHhOEKwxZY4TcJ65rH0Zf@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj8oEdpb6PDHQL0XM1LpWHkE103ZL43EW3UBJnSUsUGUqbiz7c
	eiWnxmQzgVMFzQO27s1s5r9GYpNsF/nWIOO9xAsV0rCgAn/fOXsBKS17jEtb+vttvYZwZa971yX
	PP9idEud36byE9gSdY+Qz2+xpqaV8Yjo=
X-Google-Smtp-Source: AGHT+IHXjjJATKD8fNfFAHEWcURkHM9hBd7O9PZ6hQ+41yaBJ43zr/9QZKIsfHu+D68BAUSzXdJekAHhC08l7sooJn8=
X-Received: by 2002:a17:906:c148:b0:b72:eaba:aac2 with SMTP id
 a640c23a62f3a-b8036f5c415mr1997991966b.26.1766628006850; Wed, 24 Dec 2025
 18:00:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251224142016.250752-1-zilin@seu.edu.cn>
In-Reply-To: <20251224142016.250752-1-zilin@seu.edu.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 25 Dec 2025 10:59:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-9uNzcRW2qRrw1jLEbmUAPGMfOet453WMU2d7K_D-pzA@mail.gmail.com>
X-Gm-Features: AQt7F2pO7XgxnG2D3b8cWbvBQIl2O-nSw_Kjcv1WWpZ_oXGKZDIshYVVq87M3v4
Message-ID: <CAKYAXd-9uNzcRW2qRrw1jLEbmUAPGMfOet453WMU2d7K_D-pzA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Fix memory leak in get_file_all_info()
To: Zilin Guan <zilin@seu.edu.cn>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jianhao.xu@seu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 24, 2025 at 11:20=E2=80=AFPM Zilin Guan <zilin@seu.edu.cn> wrot=
e:
>
> In get_file_all_info(), if vfs_getattr() fails, the function returns
> immediately without freeing the allocated filename, leading to a memory
> leak.
>
> Fix this by freeing the filename before returning in this error case.
>
> Fixes: 5614c8c487f6a ("ksmbd: replace generic_fillattr with vfs_getattr")
> Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Applied it to #ksmbd-for-next-next.
Thanks!
