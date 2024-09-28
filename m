Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449BD101E2;
	Sat, 28 Sep 2024 00:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727484822; cv=none; b=P78q7rjHmDuX4bsnusJvjD6wN82mWGXYpee1wUtPHfXRsCktjJY2OA4xT2Z551bCFw2dWgrkmA1084lf8gu7UPYFiuiM7spO9SgNf3RbjuqdmcGPulRKn+lri43FPxNVXjMRVtIL60aySdom0vLbBEz7qaoCEnCn9B+WYy3AzF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727484822; c=relaxed/simple;
	bh=M6RSOZbadviKrK3aTrBAXSlrSJMsJ1jTZQG5Twep6hs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eS4On3WVUQxcu+CaPo3UfdQYteezwyYVuKcgllvFVCTy0J1RcFlGhlS15X+13iWfm2VoItOel0JIy/GhKBi+fIeN+iawWU+rRndov0Q5OAAeOg2qJY1c1zvcXxlok4Ob7dbexMVNew/xHP4ayAxt0ckHnIApuJGpVrJqdExJJYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YY+O9bdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YY+O9bdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBC1C4AF0B;
	Sat, 28 Sep 2024 00:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727484821;
	bh=M6RSOZbadviKrK3aTrBAXSlrSJMsJ1jTZQG5Twep6hs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YY+O9bdxJzxiyNtC7Q/7DtqEB0QYU0dCLkZIATKq/Txg6MQcHUv2IDsJv0D4eW5TI
	 h4ewlbtT14VUY5UMuG2UreWJPke6cO5LAsgfgTjs3O6Nte9UoKjqh603OY240HJTBE
	 GCqwU0nrOC9mDbZxAXm2zoGX/6fR8q9WkT4vIb91tQtn/Q2ZTPIaSqcQqBa9BJ2eIM
	 7k80bFhHBJvj0PcpM51zV/92zc2DXPtQZ8bPH6Tg6Lr4TJT+uf71ymakR1nyw7vZl1
	 o2Iak3LDfRrxrV3zrbu+VG0YaNzbN2CwClbK8BsATTuO+3CQVJFmMopzGj3rPQ1pb4
	 nWQ4R9cqbKtIA==
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5e1b6e8720dso1430530eaf.0;
        Fri, 27 Sep 2024 17:53:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVKMr0O+tmS/fQInbpxA819T2SvzTy5feopZ7B0bwtJBFcdXTa4DjZ6KSZJTQPVv3tk9rg/7RdgkRUwpnZHTQsp@vger.kernel.org, AJvYcCVQ5IjhGxwmyYCHH5Au9QB3zlQK4wSfmUFxul0tXCc0QZKriRTPLEWmS+QUe5Vjw6raRCZWEne5hxqk@vger.kernel.org, AJvYcCVwRL64757q/DBKRKuuY5dCc6ZYl40g5N8VJr0TtRdXAhHauJ5dL1942cL2hHN2oiJBRXXp9yUsr3frmlEV@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4+wLM6X+DAgp4ck6I8BFKYgMxFdWduYA+8d32eu8CrLbtMdMw
	S9i0ixMhdgQ7EbmclDYLuvu5THSOtYErvkH7/vBLlvnOt+gZOYQpseS0s/OOYJ062h3B91+Xi2h
	ZpvgzFafflGBlTJo/VpV+Xx2357Y=
X-Google-Smtp-Source: AGHT+IFl8cYWBZ2K1SWBPY0SW+FCHnU5DEv8uBX96Z6/GBq0PQ68fjdRpWs6j5nn797NTMoWB+1+8NY3dBWTtPZBX/E=
X-Received: by 2002:a05:6820:2208:b0:5e5:7086:ebe8 with SMTP id
 006d021491bc7-5e77244736emr3030436eaf.0.1727484821128; Fri, 27 Sep 2024
 17:53:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240925090313.22310-2-thorsten.blum@linux.dev>
In-Reply-To: <20240925090313.22310-2-thorsten.blum@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 28 Sep 2024 09:53:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9ihJRoY0yzS9mANHBQGM7zPRsSMzo4784bKLqj0MzGMQ@mail.gmail.com>
Message-ID: <CAKYAXd9ihJRoY0yzS9mANHBQGM7zPRsSMzo4784bKLqj0MzGMQ@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: Annotate struct copychunk_ioctl_req with __counted_by_le()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2024 at 6:10=E2=80=AFPM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Add the __counted_by_le compiler attribute to the flexible array member
> Chunks to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE.
>
> Change the data type of the flexible array member Chunks from __u8[] to
> struct srv_copychunk[] for ChunkCount to match the number of elements in
> the Chunks array. (With __u8[], each srv_copychunk would occupy 24 array
> entries and the __counted_by compiler attribute wouldn't be applicable.)
>
> Use struct_size() to calculate the size of the copychunk_ioctl_req.
>
> Read Chunks[0] after checking that ChunkCount is not 0.
>
> Compile-tested only.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Applied it to #ksmbd-for-next-next.
Thanks!
