Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7E6175A74
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 02:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791513317; cv=none; b=uPpJ/iZk8WCxUyLO1329IiqI29uY3eWL7KtDi91Ztuzw1e/z7UNNWzKvzdYg48Y/YYp/EvFpTtGuBsC6/czg39KHzJG4A89oSVjp4D6E10ce/vpdLYoQFfGl4SAJWJb+xL++MPwfy/NXP9OFk77ihVR9HZNgWt8mmMZx+Zp7SGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791513317; c=relaxed/simple;
	bh=VZv4jniYuk4Z2fxTVjf6GnSyXYpzq6KaHj9otbasg+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n+6MijltNaEc7IpTPS/ESpBTnmlYmoIvNC6eAc3VOfSlkqKm4XkX4a6jKU3KMcOeyG/kc4wA/lOFRoCkKcwYOHLaDe0dFukBtbkrH+PCDGjaMJoQszvEB315RwA8eh8JKACZMDhBwv7ymOH8DvP+1qEVEbn0iHsYYb4zFgnY3Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NTmYlZkZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NTmYlZkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8EE1F00898
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 02:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791513316;
	bh=sAkdI7vNxTi6eGXSEUzKU4xq2lGM2UC2n23ZttDyUdg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NTmYlZkZjbGrOit4kVyL7av//w53jOAaJVKrljp3I0UMY/Je8DZxO/digHZLMxZYJ
	 ROvU9DeLI1wzF2MVWEKudmXOhZeBo5AjU6tQbsiJwvnSgFy1Z/zxAoIJKaFZFKRYQ6
	 Or4yqbbZRIPW7F18oCZmAokQyDw5MGvXU6PigHeMfM8tU7G9MVhdw18NEKc53wPuBX
	 rU8P409ZXNpAkNasaxHPlCtDHd5MhKlc+yOJX0t36uSl8QVkXElwRCcb4LIS/LqW6l
	 B94ONsVPU9mScLCrwf7M5Qxh+HztYi7BlXoHDdzS7WPlJ0QCqY+Ts03Wz0sK9I91A0
	 HVuGVn4ZjukFg==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c315729ad50so532562366b.0
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2026 19:35:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwbMh3HyKih3O/Dmbxk7yWHxI7hBO5O/MX9mB7kxisZwzT3gEJV1QPkQds5tJajDMlafr3FekuAcCao@vger.kernel.org
X-Gm-Message-State: AFuF++mZJybgPisS6ZjGe3HlpZuL8jelFroZhQdiC5frN6xN3e2p65iq
	vfWVWHVpxh5WhIn96RiLaspgwUBWz4LOM3Hax1d+/KivrJG1GSWzoV7dFlX2h3MnFw8ONgGvjKd
	I5qynsxsKZZPZztGzCo8iiDnCO8ZmQBY=
X-Received: by 2002:a17:907:e98c:b0:c2e:8eb7:53dd with SMTP id
 a640c23a62f3a-c31aa0c19a7mr42228266b.42.1791513315221; Thu, 08 Oct 2026
 19:35:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008170542.1034301-1-bsdhenrymartin@gmail.com>
In-Reply-To: <20261008170542.1034301-1-bsdhenrymartin@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 9 Oct 2026 11:35:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8tBP6sDEyZG0Uatg-iGu2hehp1kxWDCacOQy3LZZR8KQ@mail.gmail.com>
X-Gm-Features: AclHuK-PXIKpBKTffox6qhGJhJMQtqPmD8OGEyG3yCJov5YLD5JwPxLlBrlle78
Message-ID: <CAKYAXd8tBP6sDEyZG0Uatg-iGu2hehp1kxWDCacOQy3LZZR8KQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix heap out-of-bounds write in SMB2_CREATE
 context stacking
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Gael Blivet <gael.blivet@gmail.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 9, 2026 at 2:05=E2=80=AFAM Henry Martin <bsdhenrymartin@gmail.c=
om> wrote:
>
> smb2_open() appends up to six create contexts (lease, mxac, disk_id,
> durable, posix, aapl) back-to-back without checking the total length
> against work->response_sz.  A non-compound SMB2_CREATE only gets the
> 448-byte small response buffer, which also carries the 4-byte rfc1002
> length word, leaving 292 bytes for contexts.  The AAPL response alone
> occupies 128 fixed bytes, so a client stacking contexts (up to 416)
> overruns the kmalloc-512 object into the adjacent allocation with a
> deterministic zero-fill.
>
> Compute the worst-case context total from the per-dialect
> conn->vals->create_*_size table and grow the response buffer to fit
> before writing any context, so legitimate requests keep working
> unchanged.
>
> This vulnerability was discovered by Tencent CodeBuddy Security.
>
> Fixes: 8f1b796ff1135 ("ksmbd: add AAPL kAAPL_SERVER_QUERY create context =
support")
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Please check the following patch in #ksmbd-for-next branch.

https://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git/commit/?=
id=3D4ceeaa7b1a1a022ee329c4068339b3f44c1514a2

Thanks.
