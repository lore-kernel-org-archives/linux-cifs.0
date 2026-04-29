Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B35B401490
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 13:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777470203; cv=none; b=uAznETX3b7XD2LwrW0ahfSNiLqd9UBDiLD2JXXhDLxzpk1Me5tHcOv3qpdLBup2jDaNQjwSCcUnIVMbe9gA9PGzqlu0n3z8CvIv5Przh+Spejrjo7B6XU1RzYAt1g3VCi9qzsyNsSTtoO/uL/HgkfWko17yp7JxDuz+TSLLpWzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777470203; c=relaxed/simple;
	bh=ru+/VQqNw+RePt0bZj4FS8VFpVXHxbInhjX4BRQnFzs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kNn4l/koteD8S1ZDDtnDvRBXiRjzElQewMwodQj4+FTP0yo99Ux8Z88BBMNTIJu9dMX4ih/UhxQe6MTHG8Ycfg/+hayRwOVt8fLsAhvPZkmaXi0DgxgyZGzrjvrsu2AoTH2cYLJRVdeicm9WtD7bzTL6ZXL+3YYb/a1xH3GjfxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jADbK+Q1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jADbK+Q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E4DC4AF0B
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 13:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777470200;
	bh=ru+/VQqNw+RePt0bZj4FS8VFpVXHxbInhjX4BRQnFzs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jADbK+Q1Y7uMZJuKi/bJbO2Qp1IRw/zZOMn6AYejgPLXBJtkjRwvUOkWZN9O4S4ZF
	 Nl8Ei5RH3OzWra93AJquNca+ziTn+pVF8VxPKlyR/+3UvA8hKjiPy2dux4ri6es+0H
	 D+qJC9x5aaJgwKG0TdiU1c/L3KH8m0KZl/eUYXLAQx5vmQljNoEY7Xr4zGo6IUYsdZ
	 K4+Xdrz+UarVAcTAybPUcBc1zB31j8YsbsPQ6LSxKvLUnerJE2b2cASBlC/HV7wTZl
	 hi8zrIC/Y7kHB4bNFByM9YRh7VIb5xOCQ2wY6f9em4gTN8DgVmnqIln54bMilTqbgA
	 1V3cvo0CMuA+Q==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ba5b107eaa2so1420206166b.3
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 06:43:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+ftBDpxs1ptiG7vmahHlsCHpBwQZGtT6ehlA3Uo9Ugc3QFeceioUqgvtd2NOM+c+s1d5O7/slg7mBn@vger.kernel.org
X-Gm-Message-State: AOJu0YwyVOp+a4zG69U3l75JF/PHh3zifpuHUqyOeirwA49PfWTFMwlt
	P/SRTz2WIPBMSaUNoFew79P9vGZ+mAn+PwJCxBmPv7t4spbuXC+E2e2pTRX1kb3fUIJiW5e98OF
	wy75E/F5aMobw81rEym7IovDq43JJT2Y=
X-Received: by 2002:a17:906:6206:b0:b9d:17f1:fff1 with SMTP id
 a640c23a62f3a-bb804053542mr488977266b.42.1777470199462; Wed, 29 Apr 2026
 06:43:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260429085956.GA3326432@chcpu16>
In-Reply-To: <20260429085956.GA3326432@chcpu16>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 29 Apr 2026 22:43:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9yNbrDYe9sovtQtAvEm3Jq+BkKwxP9gXmd6qWK0UXs3Q@mail.gmail.com>
X-Gm-Features: AVHnY4IvIilQ79NWPpqPmUxa-KD0x0b3VSQqhrexJP6SFGHD6JI1KCxlCJ9en3U
Message-ID: <CAKYAXd9yNbrDYe9sovtQtAvEm3Jq+BkKwxP9gXmd6qWK0UXs3Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fail share config requests when path allocation fails
To: Shuhao Fu <sfual@cse.ust.hk>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2026 at 6:00=E2=80=AFPM Shuhao Fu <sfual@cse.ust.hk> wrote:
>
> Non-pipe shares must have a duplicated backing path before they can be
> published. share_config_request() currently calls kstrndup() for that
> path, but if the allocation fails it leaves ret unchanged. If veto list
> parsing succeeds and share->name exists, the partially built share is
> still inserted into the global share table with share->path left NULL.
>
> A later share-root SMB2 create uses tree_conn->share_conf->path as the
> lookup root. If the share was published with path =3D=3D NULL, that reque=
st
> passes a NULL pathname into do_getname_kernel()/strlen() and can crash
> the ksmbd worker.
>
> Set ret =3D -ENOMEM when path duplication fails so the incomplete share i=
s
> destroyed before publication.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Applied it to #ksmbd-for-next-next.
Thanks!
