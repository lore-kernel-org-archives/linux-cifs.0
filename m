Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795695414;
	b=ap8yhDn7Qd7r5+GaoRPx+80/OMVDtFk+hauQUaNfnFzuZCIfs8xdwZ0wTbX1XJbbFktq
	 CmtbyK+ylwMxzMFKwDy+J8ZNFizq5kI+FjmtUDldlrvSp1YXqgOG1rvF9s1pVYDQ4ncml
	 gvUAMhHr4xBCZPK3GVGelhHT+P2eFwKuN3aNmjzNuQNLru7FfRvOrbLHi1jD5SEgmAp52
	 O8tITPAcxFtMp0QGHThXx1T8UIbroBLPnG8Iu2pALQo17ctwZux02a1J0FOKkjkAtySAU
	 RcYVkQ9Od+r1zmZe1YwnuMtR938G8N1SOI0Fx5g9V4rUMiA9LABXY9C8N6CmsDOsntw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795695414;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=nY9kYR/xw/7wOiVhGg3uzbGjOgXyshW0del5pACziv4=;
	b=Ll0KOzl+3AxtlgmZVXA3QM143F/E3kfjL5IvtDQKHjTSeBf3R/2M1VdpBwzKo8DgmHY6
	 BwzPizoPsvmwo1rrce9HonFf/Y/DS9uHspznU+HtKnQjPOMbWPkvq26m0+rvNTpzxM0AR
	 JM/ReCojkTpDZCBOvvhKWACAzlgMZA6ZHoqKtxO7i6PK/DtrKpyQo9hz8PvnfZHUFy/l+
	 8sXNNBksu4KGHqTwhNNyjqypWj0u2Gjv2ZwfFn4LLY+RJlDDfGDOsxwO4iqlZFsH5yLN9
	 XwJRgj5xPpMCkVdh5YvXair0etVU4ICky6AD8brz9wSBEDnVm2EWw6Tu29r7hWHTP7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=trs+zPqO;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D364606A31C;
	Thu, 26 Nov 2026 12:16:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D364606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=trs+zPqO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nY9kYR/xw/7wOiVhGg3uzbGjOgXyshW0del5pACziv4=; b=trs+zPqObBmbFuWzSje6cG8p/Z
	XxLyFSTnTu6JZ/rtVxBIPyJ+VMpZ6KuyqMl9bTCV2CBiJKow0zqh+N1sd6nTS8eDbX3T1lr1Sb/40
	0l6QBOGvmLI/5Il/fGqxwVgGTzOC9wtV+igWlmOPkyZXCSP31N7qbwH9WA1S7dsvkeysVhPO/Ih3J
	0qjaqZLM/9tWwPn8EONQkcvLdJUxDYqH663Ru4Jts3hXlggsGtzx4bbAptqvRtaVhDAnhIR3XW/xr
	/ICz5CSijAneM1KCKUpk/LHP3MbOfTo5SfGpLpB+qjI15PU2Cae+zgqxB1aaGcsixtfijAKxB/OMj
	FW9nBgRw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xWYPD-00000000zqR-3EYd;
	Thu, 26 Nov 2026 09:16:51 -0300
Message-ID: <c9542b37c8edfdfa255cdfc2d5e3f9d2@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Elkin Cruz <elkin@google.com>, Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, irogers@google.com, Elkin Cruz <elkin@google.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: unlock reconnect_mutex before putting
 session on terminate
In-Reply-To: <20261125210025.1277771-1-elkin@google.com>
References: <20261125210025.1277771-1-elkin@google.com>
Date: Thu, 26 Nov 2026 09:16:51 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Elkin Cruz <elkin@google.com> writes:

> In smb2_reconnect_server(), when server->terminate is set, the early
> exit path calls cifs_put_tcp_session(server, true) while still holding
> pserver->reconnect_mutex and unlocks pserver->reconnect_mutex
> afterwards. Dropping the last session reference can free server (which
> equals pserver for primary channels), causing mutex_unlock() to touch
> freed memory; the normal done: label at the end of the same function
> explicitly unlocks reconnect_mutex before calling cifs_put_tcp_session().
>
> Unlock pserver->reconnect_mutex before calling cifs_put_tcp_session() in
> the server->terminate branch as well.
> ...

Applied.
