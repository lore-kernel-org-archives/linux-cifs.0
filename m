Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6787404E
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 05:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784525712; cv=none; b=f/BidHusX7H/34bJukkJCMF5tfiXwwBz4uDftcrEoVpeLT0AxY2Y582n0Zg2eGEJUIFeKDb2XwlaTj9RYzfdALupjusXPXio3vSqoNxvFU2x6uU9Y6fHVjJ9uyNktdpOUK0EamUePgiFR/oHbBq9VzWrq9u6L8qk6eMxC213bU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784525712; c=relaxed/simple;
	bh=X1yNjo21hd40UWKIaso4SuX/hfpyY6ewSxwTaibJ6MY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ozvuo/RMsKgAhNY9AJ5RbyMqJm53jGAuT5fXlEjjBXwAm0iYnOPeuS332aBu7zk7EkSz753Cd9C8ktXp6ul7EzpLL7ml7rA7e73hg1s2MYs2Wy2XljnqIpD905FOHFNTWcbdLwz+WBPFq5HE8oFzI4aRIky0CZE8UOh5MAXpJcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ESOuLo1g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ESOuLo1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B878A1F00A3F
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 05:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784525710;
	bh=X1yNjo21hd40UWKIaso4SuX/hfpyY6ewSxwTaibJ6MY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ESOuLo1gtRSTdxkNeRw3ySfXowQdDtgYiWdWyWm2TFAgoyMMjMwdpCMcfHc3shmue
	 9cuSZeId+tPuTaMF3IWRdwL5Y/eTUdvKnaptKcypfhxCY4WHoRIRjRyF1GKpcA4BZK
	 vpwK+ugL6smlaVyEnUQi1h71vZ5xMEZ0XGZpmfGJfXE5TczURu+diemDG9sJFdJMIH
	 Z3bMHLY6aN6yOxI33jCXT6H1pdQ3wsRhrqYcIGYpmh7FLBAPBRPwqE+hK5ei3UAMyN
	 rq+FFReDHxp7r0baskPmlGOH+Y/+ynhq9LnUchNaCrA8aQqifu92eSnPQFO+LjmV2m
	 SCVdsvHWBgfwQ==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c1601d552a8so1020008866b.2
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jul 2026 22:35:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RokN5PUn5WOgmzq6/CRuji4Z78XKYGUO2PzEkf5Whcap6/glQk65EqcskvGA6DQWYCw9D9FniF0Ug1J@vger.kernel.org
X-Gm-Message-State: AOJu0YxTvJraw9CLEEICfyXeKJaf2hyVBw4wr6kmGU0UHXO+9U5Pjvq7
	9YGsoVQIGeogc4/mLQTCcau9X/R+s7yfrfqtexTnLWw/EJ2DBoM1dY6Gfp1JO3tHYM1dyXZIiQ5
	1yRJUXEzhoEcRMFPuIJz/r0bLLcLntuk=
X-Received: by 2002:a17:907:3c85:b0:c15:fc59:cdf3 with SMTP id
 a640c23a62f3a-c16b46abda6mr520098466b.12.1784525709334; Sun, 19 Jul 2026
 22:35:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1784258165.git.tanze@kylinos.cn> <37f280818ac592b7e641d08325b4c10ae6bb7c99.1784258165.git.tanze@kylinos.cn>
In-Reply-To: <37f280818ac592b7e641d08325b4c10ae6bb7c99.1784258165.git.tanze@kylinos.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 20 Jul 2026 14:34:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8A+A2OqOqgVVOdaTqC+hvu6kjQzgOtD40s55F9cwGJbQ@mail.gmail.com>
X-Gm-Features: AUfX_myEI9N3urJEfnD6kLHlMx2RYm0ZxjA3RiGBFPSXbQh-4wtuf9NcUnOvrLw
Message-ID: <CAKYAXd8A+A2OqOqgVVOdaTqC+hvu6kjQzgOtD40s55F9cwGJbQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 9/9] ksmbd: avoid self oplock breaks for EA opens
To: Ze Tan <tanze@kylinos.cn>
Cc: sfrench@samba.org, pc@manguebit.org, sprasad@microsoft.com, 
	tom@talpey.comm, senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 12:40=E2=80=AFPM Ze Tan <tanze@kylinos.cn> wrote:
>
> generic/093 writes to a file after setcap sets security.capability. The
> CIFS client can reopen the file to query or update EAs while the same
> session holds an oplock. ksmbd breaks this oplock and waits for the same
> client, so the write can block.
>
> Skip the oplock break for same-session EA or metadata opens. Keep the
> normal break when another session holds an oplock.
A session can own multiple independent opens. Why is session identity
sufficient to conclude that an EA/metadata-only open may bypass the
existing exclusive or batch oplock break? Oplock state and break
notifications are associated with an individual open, rather
than the session as a whole. Could you point to the SMB specification text =
?
