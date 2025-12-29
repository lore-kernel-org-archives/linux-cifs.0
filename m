Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BDF347C6
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 04:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766981211; cv=none; b=X5q0c3s2PptmDycPJObrt0AMDegPIWjwhbwwlhKcDdniMYpIVLmcH0heirUKXOYeD//u6ixiYOCOY5l7zWCwNGHCjEq9hb5XD1bhnFDJ5AE0+oqp1C1jFlRISyNY3KoD05jvb8muy5GjrcEmqxwrswGGk2GE8FXQyoFhJRjs3as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766981211; c=relaxed/simple;
	bh=i0LqLGGyy9JvevQfTpUbnWRPvXtXCirQyd76bHKY6g0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pz7mZ+oMIZhs6tdUnw1+BRF9ZDOihvc9o6YVHOkA9JHNc8WPovwx5X99DOakOipJiL9OPgJexSEMRCsOZvIvZc/nANPawRH4LuiTdYt98Uw1h9OSRJM4hg8o0IjHCa9eZbZFq6N8EYIiQiKLjP8G0tbxgH6Qa9yv5n6i9edSb+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aVjSXE6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aVjSXE6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F512C116C6
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 04:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766981208;
	bh=i0LqLGGyy9JvevQfTpUbnWRPvXtXCirQyd76bHKY6g0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aVjSXE6yacIkhfdB1VtAY209753ixkhpnQ7oaUhJDQebO7CyXVOBC9YwV7JWx4DMp
	 HUKGt45wZPqzB+Xu7+Aq97ACInW0gY9N4pz/egrCtb+qjZ3tlUEOl5Ra0zbKxT2606
	 tzs7hHt4adcB7aem8qjzn5uZrY/KQ0s6n3abEwlH/hxiZkmSze3OP7ekOGbzXFgeQj
	 EanQoDuYjvrljGHqrFA7rBN0N6jC0bfWAF+UoNVzG/L0ASVmOLVe5aDs1YC5E3wNJM
	 4R41T+p47Qg1OMckI5ceD3BGSUsYzUnVaZFPQMxkneFIElsC+Nge69B3e2gSV9CS1q
	 9A6ptiUP3p2ow==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b832522b47cso360974466b.0
        for <linux-cifs@vger.kernel.org>; Sun, 28 Dec 2025 20:06:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUgn4pdCgCgTMGVDr0ojpI3Qw4B85gH/IA9Wdl0pCTT7xPZagC7RsuqERJgXKMoZB0LwS5pQvY195hQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1RIMbauCZoNKFOGCy5G8wM85nNl1JOSyxCT/iTdeqQBe37xE4
	M/wI31VgSUmDpp7qqIiBMcRySJEIXg99jbF2CQj1e7tnYcD9wqqmhzwLPysk3mTGoR/rFkcSpao
	QJ6nxXbPwBi5Qh0xV0FIGdTfDRCq/V0s=
X-Google-Smtp-Source: AGHT+IFQQoZEUm8/RyAFTeq91+1G+Juc2YLZe2ONIJY+Nq4/mN3PSQ/cKu7iP0qQIYpiRlAqWJyN6a7DheOQFxHr6y0=
X-Received: by 2002:a17:907:2da8:b0:b76:f090:7779 with SMTP id
 a640c23a62f3a-b8037155210mr3004436966b.33.1766981207241; Sun, 28 Dec 2025
 20:06:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251229031518.1027240-1-chenxiaosong.chenxiaosong@linux.dev> <20251229031518.1027240-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251229031518.1027240-2-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 29 Dec 2025 13:06:35 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_T7EpefT=d77GJe-TuoECQZhg_5Z9y0s0HaNCv5kbJ5Q@mail.gmail.com>
X-Gm-Features: AQt7F2qihG7MIC_t2c9eTntFkGk8m3L_xzgn8h831PLgOICHoVd63iIUGX8_uPs
Message-ID: <CAKYAXd_T7EpefT=d77GJe-TuoECQZhg_5Z9y0s0HaNCv5kbJ5Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] smb/server: fix refcount leak in smb2_open()
To: chenxiaosong.chenxiaosong@linux.dev
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, linux-cifs@vger.kernel.org, 
	ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2025 at 12:16=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.d=
ev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> When ksmbd_vfs_getattr() fails, the reference count of ksmbd_file
> must be released.
>
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next-next.
Thanks!
