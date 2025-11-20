Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4F7302CD0
	for <linux-cifs@vger.kernel.org>; Thu, 20 Nov 2025 08:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763627753; cv=none; b=quEg07OEZrU4WCif5HzXvWr3eWtxHAerOW0WB3sn94ZgNYY5FqBO6BCyk3tlWM6DwLgEGZd2YnyNwA2jWz9wC1Ed63aArZul1lWPvuI6xpsgJ2tWFNnDy/wQz1dPx3FG18ZlCnD//rdMu91T7paZKgdc7tA2z/I4nz6zClMOX8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763627753; c=relaxed/simple;
	bh=MFJ63z6TXyLu24OjCKYs0Kt11E/41frSyaDFgCFlNWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ogTQekcb+Uhs/nuNyRgB4q0B38cgB+WnGxElO3G4UD5em+1Kg/4SNq/QIl5kph9WoIkL3IqoEDkmTkS0ZOjWUAmeQyD6ftf4NRl5jlLehS3y3xuAd2PASTfHGpDgKLD16ytLa3OOkJqmovHygGPA2TzVaaJa2lFs1GbRflmtuyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cDX3B7Om; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cDX3B7Om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A74C19424
	for <linux-cifs@vger.kernel.org>; Thu, 20 Nov 2025 08:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763627752;
	bh=MFJ63z6TXyLu24OjCKYs0Kt11E/41frSyaDFgCFlNWk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cDX3B7Om+hIFtgCWfJa7lU1AFYMoOdzGS90RgHBMs9DpfYgutSEjB2qAwpWLYzbC5
	 lSYSDV3OHB2VvVsQu31p8EGsNN95qFeCO7aU7dpVnQtzJw0ITLc8fKo3QXV8L3pTlt
	 pNixPG6u1RHyumz7MVULBZr1WMVFcNa8mb68EGsfnlTHtuhHF47asJ5Zvn2ldaNL8s
	 jUYtQViqWhTxK/NqhKB+K9ytI1ZUpAZMByVc3dnP7yzcJOuhQeHekDoxtZxH+0/BTT
	 Kh2/GKG6Vn6f5puIMfltWGsu+5xI56NzU63K92Twu+fQ7uvTAAZ5Q/bTBq+CARwzzH
	 zEAM2vDf11tcA==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b7380f66a8bso91978366b.2
        for <linux-cifs@vger.kernel.org>; Thu, 20 Nov 2025 00:35:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWkQ/YRH/YkahGEWjaelVbkB9Df+Tg8BVjO8TDwujf0JI5mp/tD18Un8fg3G/O9SgHTj93x7ZJbv2z3@vger.kernel.org
X-Gm-Message-State: AOJu0YxzFjuKgUEmsrzU3Y6I1akx0aeTRuBS9AW03Ue1MpzctZRQo92H
	DLixHG8J75gs2cPX/uElKi5wPuX56DtlGK2HC0Ch+mFCHh+0GKGQpSYRkkyO689fZcfkM48W4dl
	AtTE6GLP17QW0hhx7I8V0cqkhukrfaPM=
X-Google-Smtp-Source: AGHT+IF9dSjGhMZRqv8eD5K7CupB8PVGXybo9OnhQGdHoNEPB6hUwf12h5Ea5oMnuYVTDBop2cBhvd8RSTBj8+xdvCg=
X-Received: by 2002:a17:907:86ac:b0:b73:301c:b158 with SMTP id
 a640c23a62f3a-b7654cf9b84mr206977166b.6.1763627751480; Thu, 20 Nov 2025
 00:35:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251119130231.171352-1-thorsten.blum@linux.dev>
In-Reply-To: <20251119130231.171352-1-thorsten.blum@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 20 Nov 2025 17:35:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd80SpFBmp1JTHz5VfG14jy8+_RoHU_BL6-bFr_wcOduUQ@mail.gmail.com>
X-Gm-Features: AWmQ_bkIcH6AZgv3D-xVCg4qxDXrsLHSg4ZCxzfGI_e_6F7zOhOcY-xQ2asbGBQ
Message-ID: <CAKYAXd80SpFBmp1JTHz5VfG14jy8+_RoHU_BL6-bFr_wcOduUQ@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: Replace strcpy + strcat to improve convert_to_nt_pathname
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: David Laight <david.laight.linux@gmail.com>, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025 at 10:03=E2=80=AFPM Thorsten Blum <thorsten.blum@linux=
.dev> wrote:
>
> strcpy() is deprecated [1] and using strcat() is discouraged. Replace
> them by assigning the prefix directly and by using memcpy() to copy the
> pathname. Using memcpy() is safe because we already know the length of
> the source string and that it is guaranteed to be NUL-terminated.
>
> Allocate only as many bytes as needed and replace kzalloc() with
> kmalloc() since memcpy() overwrites the entire buffer anyway.
>
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strc=
py [1]
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Applied it to #ksmbd-for-next-next.
Thanks!
