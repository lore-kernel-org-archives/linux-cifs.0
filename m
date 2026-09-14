Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D9233998
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 01:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789348744; cv=none; b=EDTngrBTCjDfk3IpFRZkbbWZEkFjMXZUFsIeUOZJ9AB8qGGnHKyKfd8wa2ElWAID1wBTuUZ+jzYltZydLR4t8yzSt1sQi7PPTdMqVhT4+4FYbacnt/3mQHHOXiG4G1nAonVz8gZH4nEt88GVkvc3d4VdI5BMUecDiFjtHwJs7Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789348744; c=relaxed/simple;
	bh=yPepE2Q31331yRC0cCmiNiQjcGrp/Im4CZj3P88JTwg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KwO9YsWlKhQTPXbtw014+jyEzqmFeGcm7YrlAvpA8smpEgUhev3jx+68j/8YPvGLzqWChfM+2601P6HB6M+EwjT5NqRQGnefLObtCuVSmqJp22EJ1FK3XT8SH5aS5oyY05N0ruVL/UZUDxImMFfRUX6wvji9STGYoDSKhtY8V3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ad9cgTJa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ad9cgTJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863901F0089C
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 01:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789348742;
	bh=yPepE2Q31331yRC0cCmiNiQjcGrp/Im4CZj3P88JTwg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ad9cgTJaZpmWOjofZsgJ9KQ4ALvktKlzuRLCVUik/doTrKn//IUhoWXNjKysD460D
	 UqepE9CG0L13hWcdL7HoawBvGobBgvFexMvDzxyD61cxNNs4k7Z2rcq6LNCaY+lv/Z
	 BgZoRAsRjHyaEgMS+l0KSktaipbt/Ls34is6HKe84WJI6RAeBDoADDdvF5hKY6ijH4
	 nfG/w/zLlHB9xEBb2xbnmaoZofUcd+YqfOa1IDpUWmh4FznSOQFGC9QQ8cbPydoSZz
	 JMLJgvpwT/5cIUGEhP2FTjBctYGV1ZdHHXReyTbAVJfkMgrorMiFlYOMbCsXUQgLA4
	 1n4rGw6CF3zVw==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f8694aeso109249066b.0
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 18:19:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByIhuOIo9l2jTs/08/xOo6x434HUAeTFU4tQd5YbdD7IbFLIEDh831PW/YRbeWdnBP3fXW/dCdV2JIY@vger.kernel.org
X-Gm-Message-State: AFuF++k88xgfcpiIkqajazmBYw+xxwjHCq1eeB5EbGHXh6o1VxKUfMx4
	IeOpagj5xf/ymOZ3gsuBlYuzaxX/E8xFV60YRrI7TrDRL3NO4dQtGOY6fg6Dvd0kgRYViuk9bfp
	9gDIAFvLO/8pxHTCnu65KgI1KFEA+1Gc=
X-Received: by 2002:a17:907:3cc4:b0:c16:6dac:a008 with SMTP id
 a640c23a62f3a-c29b91b5c6cmr13985866b.8.1789348741029; Sun, 13 Sep 2026
 18:19:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913113552.11486-1-linkinjeon@kernel.org> <07866f8b-5170-4fc4-aa78-503038f2ef5c@chenxiaosong.com>
In-Reply-To: <07866f8b-5170-4fc4-aa78-503038f2ef5c@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 14 Sep 2026 10:18:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8A+jQEweN5pqoQDL7gSxCjCW_0cNQk2KixEp447WYjuQ@mail.gmail.com>
X-Gm-Features: AcwNN1WPn2RdlED0_G-dtn_UqMipd26vQsTc1a-3OaRti_5uqZZPfTmnEYHhFe8
Message-ID: <CAKYAXd8A+jQEweN5pqoQDL7gSxCjCW_0cNQk2KixEp447WYjuQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ksmbd: fix partial normalized name responses
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com, 
	chenxiaosong@kylinos.cn, Mobin Aydinfar <mobin@mobintestserver.ir>, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 12:45=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Should we define a new macro FILE_NORMALIZED_NAME_INFORMATION_SIZE?
Okay, I will add it in v2 patch.
Thanks for the review.
