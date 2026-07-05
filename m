Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0137F3644A4
	for <linux-cifs@vger.kernel.org>; Sun,  5 Jul 2026 14:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783262245; cv=none; b=W1tzdQbCAhCMQrtGaQtR5CSo/EzwLplSd8852I+ONpDXe3u5U9YQPVItUoQM4Us0EY4QJgtkrYHiakqSTEThKgoc45Iul0/GoPrz12+EkZOSXApJ3QqQ9IgieOZzRT9GNWMkvSNMJ3MmTDQmRqdLvgGY31jQNqaRaTIZmCqmoWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783262245; c=relaxed/simple;
	bh=4u0GlxqATIjkm7N5mOt08U3P5+jXGS39U13Wj0A2jnQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LrNU3/aJ4blZ/LGLgsz1nn5EH+MhMCQmWn0AZ/vWPgtdkA2NUp0qqZPcl70RAVsNYfF86mgH6+QJHlEJdvu0LJZokj0G1A8Kx9DEltHfEMMV3FlZSd+BVsJ3gXcoHnCC8q33wChWjtpcUfsRc065nGqm0qcxht1CkrNKPoXR81c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hFjd6fw8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hFjd6fw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831881F00A3F
	for <linux-cifs@vger.kernel.org>; Sun,  5 Jul 2026 14:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783262243;
	bh=4u0GlxqATIjkm7N5mOt08U3P5+jXGS39U13Wj0A2jnQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hFjd6fw8cEoxppphmAK14KNwgN3a+zDiRdKMidyJkzbZ+tAG6eOtuqAn1I7AJBgtZ
	 ezfdBxXysBquUOW84uUPfBuSonoLoAuJowjtYlkuQF/GvQXkjwDmzHRRdbwXuHxsAf
	 EZfz/9tN22n8I89zkq613XTt42kaD4QAgHx+4Z1BWs9cElaTc/WAZYtUdogtl0mW7b
	 qXqn6pVryKn9LAxXNXTZ6Z4n/jht4QqIg+AEQceft6ZrICTa537MsHcry6NMkTmVc8
	 jYg2Cfk8GIQlQ9eAshFKntlpC8v5Y5bUchW9B/l3enq+fS0xyt/RrgCaeb0kknL6xd
	 M043P5NWbwWHw==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c125bcfd9a1so287380566b.1
        for <linux-cifs@vger.kernel.org>; Sun, 05 Jul 2026 07:37:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpC+l/0GzzDJbdctIqS3TCtNvA0qQWf0SdXsC18Kgs/e13o2etn+KX3bCkiVstMA0AkrkVK2oYhQEsV@vger.kernel.org
X-Gm-Message-State: AOJu0YwxpXW6WiuR9FmF7zEeB8WXn25lyu/8q12altd4S7ydWP9pAA8m
	g6gM5ZCANduZ3vBKIl5YXsA/hXtYyEmXR5OLfHxQO9bQxHMEra7f2zeGzsqH8P4kutF8x6wZGPC
	LvvHsURMJ77mSpebSzed9ndNXGxY1dtM=
X-Received: by 2002:a17:907:1787:b0:c0c:b5ca:931 with SMTP id
 a640c23a62f3a-c12e6b524f1mr235977266b.31.1783262242185; Sun, 05 Jul 2026
 07:37:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260705113435.285715-1-lgs201920130244@gmail.com>
In-Reply-To: <20260705113435.285715-1-lgs201920130244@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 5 Jul 2026 23:37:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_66zHKLSCw-aF5J=kAMKTeDbHTGGGm-YtdY-GLhEukpA@mail.gmail.com>
X-Gm-Features: AVVi8CdppsiL9h0f3hjOaHedUdlgiHAysP7nvvZrMrkYKUbmDbi-CLpvh9Pku_Q
Message-ID: <CAKYAXd_66zHKLSCw-aF5J=kAMKTeDbHTGGGm-YtdY-GLhEukpA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Do not skip lock checks for single-byte ranges
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Qianchang Zhao <pioooooooooip@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 5, 2026 at 8:39=E2=80=AFPM Guangshuo Li <lgs201920130244@gmail.=
com> wrote:
>
> check_lock_range() uses inclusive ranges. Its callers pass the end
> offset as start + length - 1, so start =3D=3D end represents a valid
> single-byte range rather than an empty range.
>
> The start =3D=3D end shortcut therefore skips mandatory byte-range lock
> checks for one-byte reads, writes, copychunk operations and one-byte
> truncate ranges. A conflicting lock covering that byte is not checked
> and the operation is allowed to proceed.
>
> Remove the shortcut. The truncate size =3D=3D inode->i_size case is alrea=
dy
> handled by only calling check_lock_range() when the new size differs
> from the current file size.
>
> Fixes: 5d510ac31626 ("ksmbd: skip lock-range check on equal size to avoid=
 size=3D=3D0 underflow")
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
