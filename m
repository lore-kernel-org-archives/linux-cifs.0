Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34AC1DB356
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 00:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789431212; cv=none; b=arO38P19tKtyVhN6HfSfdt+0ny05TF8dIXToTT+98tEaM7jbQX19kE0ETqR7FUSqOzY688ZOJzcHs3yk4HV6MOwMeAZs1rVkbSzEDvo1kxFKOLEQPBPwttmNZAyRfg96DNe9VKCl873M4hQAlIee23rU6zCfBn6VZrUTQkPPGb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789431212; c=relaxed/simple;
	bh=tffxmS+pQvVXbjcu/RUtQEoYjvL47ymfo3Dfr7HH8NU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KoHhjxHIgJj7vVrKtuBmvgRFf++zB3XiGWuwMi98CdJQvu/2DLDFk8pXncDQSbDmtUsSDYRKdTBIwfULINTLqiUAY81pD5YV/DQEpqYsETAJQt2XKuOPnu3V9Ry1ZpJHgMNCbReILm3eRRHLy+ZpjlzZb4Ug1byiVVHyDexWfUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b4som2LC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b4som2LC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A9E1F00899
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 00:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789431211;
	bh=f9lytcE2XegMAYQ5SLE8HvilyIu+GNdT3bUJNdbNgeo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=b4som2LCxOlJnKyr6uV8vDbTQBCz2fAD2TyPei2hxoS9th9d+HJY4pJKBMN/2srdr
	 RNN1v4LmdHWQV8SgORm+CsTbDVJiCVcTNvbGRqRqCbhyS9it9svo3udtwvkqJG1/2/
	 VymrwGkUdEPy+hGPRmkGVUsyFsIe90gH5d4gLVrccZ4KjX1udtLJTaDzfOohdRdXQS
	 rJYhSI0KIPW2ympYcDsvpjoQKmT8kz0863torKF63r1z0+xxIwuoX9Hyt5/lkRVRpJ
	 4EK6UN8TSJUCae6TiKNks9X8XdakXuVutJbgr1lx59WE1LURk85rTX195YuVeztoQ9
	 rpufgJETBNsng==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a9cb66f7b4so4223414a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 17:13:31 -0700 (PDT)
X-Gm-Message-State: AFuF++kDbYNo9HzWUjh7hUEFIwMGlcqVyTWjNEmzQWs1ZiRF6RrZT5aD
	glZ7+r1LlkTpphes9oSw2rQWjKB5bpV2wrd6Af9v0CR2yGN3bfaEmO2NsHb4D+/sPG7P2sepFgE
	FzHFhMWFTcw+AF/MTayD2ATPlUhD55jA=
X-Received: by 2002:a05:6402:46cc:b0:6a7:ee54:f89b with SMTP id
 4fb4d7f45d1cf-6a9f63d6a09mr2684095a12.31.1789431210242; Mon, 14 Sep 2026
 17:13:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914011052.809774-1-pc@manguebit.org> <20260914011052.809774-2-pc@manguebit.org>
In-Reply-To: <20260914011052.809774-2-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 15 Sep 2026 09:13:17 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Kz49C7ey4m=3BQmpFu8NMWibaf5YNcbgFtt2O+nJnEw@mail.gmail.com>
X-Gm-Features: AcwNN1WVavc6_pbK86jW4lMYnXaAKQH9A8iUc0Oa5nEv6VwB9RkCuKSEXrBXoyw
Message-ID: <CAKYAXd9Kz49C7ey4m=3BQmpFu8NMWibaf5YNcbgFtt2O+nJnEw@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: client: fix fattr leaking on wsl_to_fattr() failure
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Tom Talpey <tom@talpey.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Bharath SM <bharathsm@microsoft.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 10:10=E2=80=AFAM Paulo Alcantara <pc@manguebit.org>=
 wrote:
>
> wsl_to_fattr() mutates fattr fields as it parses each WSL EA.  If
> validation later fails, the function returns false with partially
> mutated fattr fields that callers do not reset.
>
> Fix this by parsing into local variables and only committing them to
> fattr on success.
>
> Closes: https://sashiko.dev/#/patchset/20260906200517.725015-1-pc%40mangu=
ebit.org
> Fixes: 78e26bec4d6d ("smb: client: parse uid, gid, mode and dev from WSL =
reparse points")
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
