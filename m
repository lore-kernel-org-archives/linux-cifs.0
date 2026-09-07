Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A3943F4A2
	for <linux-cifs@vger.kernel.org>; Mon,  7 Sep 2026 22:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788821938; cv=none; b=T+0Nz/w1QVwgIFtzqBU+JiIb3TndzZ7ZtjZo4YiS6uYbEf/2tl2KcUS1OyeTEDgXKKxC9f8JDKPjIv2E03siQmMF00tWhq1hR99m3EbVVBrbIA/DqDW46JVvUKKb+vDP6KZwgLmYoXLqIn8QWB+vcIpl4W9UxWT7PpN+SKdy0tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788821938; c=relaxed/simple;
	bh=4vWkjTIQ7I9XCt7KChPWVShGxvPChCaC4r4BMctckEI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gD1lsFSfhKARnCJUOJJPt+JftM7oDADSWEps0+0SKdHcE+tOgZFWUXb7FACvMmsEqQ0zxCq19EflwBHMvEsG9/wEPnw8C3/LqxdqiZn77+sgEpIUvZ16QV93gKStan6PrZeBDpCBUt8S5ZRq04E8lVRzNtefkdP1GBJduQwFr3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZKqJprhz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZKqJprhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04161F00ADE
	for <linux-cifs@vger.kernel.org>; Mon,  7 Sep 2026 22:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788821936;
	bh=4vWkjTIQ7I9XCt7KChPWVShGxvPChCaC4r4BMctckEI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZKqJprhzsz7bFZcFWfLN8jLMokWHNCZ7pqLnl9ij2cu5RRmiISyQ3AW1l9C/e+EUr
	 zqPvjir4NTj4US6saXLxlVSKJuE0LUspX6xp0yMme1YcFaqNt+D2ONmNlYTcDFgYZK
	 dlRjKdqrYgaJ639qBi0Elx4nqFHci1LAnziYyyhv1jqRsaBUiEqtQ7njAzDNFTaSVD
	 o2JxqUcGHx9NKfKUdsD6obAtFUF3T9DJ0SHWUvlFotv+I/qIgLaAu3/mMedgIfxVb0
	 rqW9U4BSgAIwpWCNDnj4P3/hW+uwMzLeiXbXAsdpqrXD78hZs4w0DrIIRZWn2r65c9
	 Z+vAqahirRfgQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1600d040e4so641834766b.1
        for <linux-cifs@vger.kernel.org>; Mon, 07 Sep 2026 15:58:56 -0700 (PDT)
X-Gm-Message-State: AFuF++nE4ny3s6A75H2vywDMlHgId4+z+jG0tKCnN5iqYmOEstSGm7GX
	FOqGTfL8xfvkQ2G5Ub3AECv7Uw4AUaKB/bOQBC+B4HBc3lQ+lW9a7GBahTcZttir8CzIkieS+U+
	YpgXGApnmzES4ZJ63rYyTHMYAfo1GzxA=
X-Received: by 2002:a17:907:c011:b0:c25:f7dc:2d9 with SMTP id
 a640c23a62f3a-c25f7dc099cmr1108469666b.26.1788821935289; Mon, 07 Sep 2026
 15:58:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260906200517.725015-1-pc@manguebit.org>
In-Reply-To: <20260906200517.725015-1-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 8 Sep 2026 07:58:43 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-i1ntpqR-dbJToxBr+qYswi6uaw4XtgBTY+it1Mcn2Hw@mail.gmail.com>
X-Gm-Features: AcwNN1XjYPZbO8QH97KWpFMJ6ZafEcWT8sogTZ1VE_ciivS7wZBsUfUlnOvwJJ4
Message-ID: <CAKYAXd-i1ntpqR-dbJToxBr+qYswi6uaw4XtgBTY+it1Mcn2Hw@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] smb: client: fix uid/gid override in getattr with
 posix extensions
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, Arthur Lesuisse <arthur.lesuisse@ulb.be>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 5:05=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> When mounting with 'multiuser,posix' options, cifs_getattr() overrides
> the server-provided uid/gid with the current process's fsuid/fsgid.
> This is because the condition only checks for unix extensions
> (tcon->unix_ext) but not posix extensions (tcon->posix_extensions).
>
> With SMB3 POSIX extensions, the server provides real uid/gid values
> just like with unix extensions, so they should be preserved rather
> than replaced with the caller's credentials.
>
> Add a tcon->posix_extensions check to the condition so that uid/gid
> from the server are properly reported in stat results.
>
> Reported-by: Arthur Lesuisse <arthur.lesuisse@ulb.be>
> Closes: https://lore.kernel.org/r/DB9P190MB2012266F6B8DECBE5D26A1798DB52@=
DB9P190MB2012.EURP190.PROD.OUTLOOK.COM
> Suggested-by: Arthur Lesuisse <arthur.lesuisse@ulb.be>
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
