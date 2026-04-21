Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A75018FC80
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 01:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776735610; cv=none; b=BLxV9UCL9KuXKC9YiszhPDK2sQhWHmG3cBtCZKNJF4HmtIY8bbaGov0hb1/UjR5AUc0p7JFbHMM68iy778VHz7IUByp7n2nA8W2l9yP1WYIzdJFaW60beXg5LNELDAE+NvG3GXJDg8juflkH/++BXP0jOhJ2rjePIM/tM16vusc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776735610; c=relaxed/simple;
	bh=VY/sZE8bhqM0/mK0lAft5EfTXoxNB/ZE7p9Jx7PupQw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KUXwriTDuK7GtbDmTO/0Qx4Q153YE3ukJd9m6TFzYqkVVGfiAIitIHHhH6UeIJM+C8VvFLY7Eg4uhThwQKlvB6zUFebHwnlgtjPw7+Ar6YT7EVfP75i/lhcENrPGGpy169pvwPY/JhJzE1XrvHsen1M2l7F5vJ/4cldhFI9pqnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kvtK1qwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kvtK1qwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C024FC2BCB4
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 01:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776735609;
	bh=VY/sZE8bhqM0/mK0lAft5EfTXoxNB/ZE7p9Jx7PupQw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kvtK1qwzqX8Q9m6/yH5rbu08NDxCA0K4EesbssNK40mAkQFIDXbdodlYl/S7GUUO8
	 A8hfyScGROh57mmiZLHclX/Tqmn79+Cv04GK5WduA0Ij6pFpFyRGPQWraQFOx5m4P1
	 G4o9JrZgQLVCqmeWs89gsoNx+krKL8+Avdfb2BvYlDxEiAMvzbfHoW5pyPq1PfOtHn
	 paBoIdhcuPLSsfvz0D5CwBa6w4DZ/QVyvXk0ez041VVHQXP1kEfONFgCC/5QFMh6TI
	 sZ6xu24y2Qq4DTDsmdGP4WyyFxZf1rnJ1CP1O5NPAW4c30YTOLFwa2xhxFsg1oVRw0
	 WGVos2yw7zMlg==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b9358bc9c50so486724666b.1
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 18:40:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/01GovMQ5pR5E3kGye8PqvHYWjrjN6NziyWgFQGcZOy8vLzDASx1Z9N/UA+Ish+2wzpgdQs7ADEM22@vger.kernel.org
X-Gm-Message-State: AOJu0YzOj5P5Af0nqX++cuiDaGzw0dh23KacDSX5QK7ABHAuXvlYxoy5
	4UUx87EOHR3O9AWAqDPbFNAya/FP62B1jOV2FEqbi7YpeTEDQhA9uuWVAgbST8/5tvW9pVe5tSu
	Rp60Wx/gs3IAUC3aqxf95GEVWL4MiLPI=
X-Received: by 2002:a17:906:bf45:b0:b9b:1cad:fe93 with SMTP id
 a640c23a62f3a-ba41adf96d8mr797789666b.24.1776735608276; Mon, 20 Apr 2026
 18:40:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260420175125.3341090-1-charsyam@gmail.com>
In-Reply-To: <20260420175125.3341090-1-charsyam@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 21 Apr 2026 10:39:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9c-CSqtXzgTn6davHNbLo4Y4ipma=5EHsZ5Wb72uEMEw@mail.gmail.com>
X-Gm-Features: AQROBzAUCaYD2fipzmFFnXI4X8t4RhxnDlOpMjGu2F0y7p6I7ahJmYW1zt0h-U4
Message-ID: <CAKYAXd9c-CSqtXzgTn6davHNbLo4Y4ipma=5EHsZ5Wb72uEMEw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: fix CreateOptions sanitization clobbering the
 whole field
To: DaeMyung Kang <charsyam@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2026 at 2:51=E2=80=AFAM DaeMyung Kang <charsyam@gmail.com> =
wrote:
>
> smb2_open() attempts to clear conflicting CreateOptions bits
> (FILE_SEQUENTIAL_ONLY_LE together with FILE_RANDOM_ACCESS_LE, and
> FILE_NO_COMPRESSION_LE on a directory open), but uses a plain
> assignment of the bitwise negation of the target flag:
>
>         req->CreateOptions =3D ~(FILE_SEQUENTIAL_ONLY_LE);
>         req->CreateOptions =3D ~(FILE_NO_COMPRESSION_LE);
>
> This replaces the entire field with 0xFFFFFFFB / 0xFFFFFFEF rather
> than clearing a single bit. With the SEQUENTIAL/RANDOM case, the
> next check for FILE_OPEN_BY_FILE_ID_LE | CREATE_TREE_CONNECTION |
> FILE_RESERVE_OPFILTER_LE then trivially matches and a legitimate
> request is rejected with -EOPNOTSUPP. With the NO_COMPRESSION case,
> every downstream test (FILE_DELETE_ON_CLOSE, etc.) operates on a
> corrupted CreateOptions value.
>
> Use &=3D ~FLAG to clear only the intended bit in both places.
Applied it to #ksmbd-for-next-next.
Note that I have added the missing signed-off-by tag and let me know
if there is 1/2 patch.
Thanks!
