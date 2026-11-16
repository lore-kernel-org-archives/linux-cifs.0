Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794866954;
	b=VlaykXVE/D2CdAkMG8lVhsfZYvKu/dbJ1yRVrgypIYQkokJ6CozidSHdHf5IDFc+8+d1
	 /zbVIzqfVyH89vkqswh9QIKZzXIUujXoNd+e8WQOO2HiSX+GFdCRqhU8An5HnaoDLYYnY
	 FMZuA5GgqwBKLFREwF1YvrbR3fcefwB2qsHY8D+ttNYDDFmIlXjVtCtkp25BtAUobpOHF
	 wCIthpPPdhcpaKaK7MyNrAWCAVJ+gC3c8CUYxdsjgTU2h+EUQllFKNHvsMS8S0eTHvqai
	 pOf6qslr6jSJJyzaqVN0NHiRB5a1seN/oeFwWTUcZxQjZmUr9udJRFR0cWHNbMFb7Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794866954;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=VI/oteI2MKHGuHMppVNpHncnUh2GTN5LFZkAzdLoASQ=;
	b=m4zf+AaPfIjYkrnW7hbFitYGPjEhsWCBrzddHD6BAbfFlDhaZsF1mTSrfAsb4U6kVTVi
	 t/YgXQxyjYiCx0CshOcC2kjtEBQJ4f3Px0u5Tr8HRO86qkGaOlSeffHkoawhqMgXTVpxJ
	 B7It72QWz8MCTzqcSugAFnpyJgSHl0pkcZ+dWs+QTmAPc8GqGM0/k0l8Vp9AwRJjcybIA
	 1TDqqWTD9rupXdopE+Hsi3K7RWw8ppN7UpsJYdU6cAg/WLYJoDvaAUKmWRBW2pMmlqCz4
	 UPPZydF7KJYKM+6LFDTRJzfLsSWIwLiL9LI2BkixeIKvFlqdP8G9u+UV6Du877HhrWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YtVYn1gO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91328606A32F
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 22:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YtVYn1gO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4ED1F000CA
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 22:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794866954;
	bh=VI/oteI2MKHGuHMppVNpHncnUh2GTN5LFZkAzdLoASQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YtVYn1gOxzTtGZDv2HrZCfeuQ2FcoOVDq82Ivhow8da6dF2Uk9yo0ZmOyG6fiFhJ+
	 qG09QS/9xdA3SMr2eDvsn5mNBNrGPzpWDMBQmPdLmNkngyREX+YmGWSE/SVJevGIPF
	 pSPn8DrPxHPHTXKGPHaYaeRY39Lo5p3qXo/mYIXZspbIgLKWc9gZYgPNNfBJx3bgBp
	 xSeB8VTpsuF8oUtx91Olx/XikOJZp2ZIjAOjFHyOZd0iQAcooM+QW3VQG34F5DgNeJ
	 Ox18zQxy9N1d0LUH9gZmWbYaLiQW9VM71o29Lu38HqZeVO+OD6ABJgpVFWvSsahTYd
	 IiGwID37CC4TQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so678313666b.3
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 14:09:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHtLTZc7ob97IXA+d+Rt6YVauU6K/9VRJzOrIiBOQii/h22HaTgZz2ZFMK7j/TrLjlWr4XT787T6m8M@vger.kernel.org
X-Gm-Message-State: APuU4Z/MJScb3nzkJjhF7t8fSgqWgIQ03+JLix//6fjuvRGJbIonU+8c
	5J+6p5Xu8xz5NxVqpkWc+bZKGI2iw/xVdEIhiuKtS17KiMlbiuGK25X7RglNbcwlLYT1rib3NW3
	x+MYKy3bvYG2Q8u3xWMFznZO6ke6NpoM=
X-Received: by 2002:a17:907:d8c:b0:c40:560a:462 with SMTP id
 a640c23a62f3a-c5096375806mr1084937066b.32.1794866952854; Mon, 16 Nov 2026
 14:09:12 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116212549.2574919-1-icb@fastmail.org>
In-Reply-To: <20261116212549.2574919-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 17 Nov 2026 07:09:00 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9pbPNz_ojKieP7uiFkb-JC8TS-VqJADjfiEm2513USEQ@mail.gmail.com>
X-Gm-Features: AclHuK9M8klvf9XpmwrIQoKGJSMhatCJ_xFEUvl9FVJhSE9baL_VkmgKd_kRVIk
Message-ID: <CAKYAXd9pbPNz_ojKieP7uiFkb-JC8TS-VqJADjfiEm2513USEQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: drop the get_write argument that every caller sets
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 6:26=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> Commit 020ad4a0d0ba ("ksmbd: protect SET_INFO metadata updates against
> filesystem freezing") and commit 3c463ed5bb47 ("ksmbd: protect CREATE
> metadata updates against filesystem freezing") made every server caller
> of set_info_sec() and ksmbd_vfs_set_sd_xattr() pass get_write as true.
> Only the two KUnit tests pass false, and they store on a shmem file,
> where taking write access works as well.
>
> Remove the argument from both functions. set_info_sec() now always takes
> write access around the POSIX ACL and attribute update, and
> ksmbd_vfs_set_sd_xattr() always asks ksmbd_vfs_setxattr() to take it.
> Nothing changes for clients.
>
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
