Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F57390613;
	Sat, 10 Oct 2026 16:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791648086; cv=none; b=s8np+GpwaYCXm5tyQPcuGzO+ICIKSpYnQ/w/rAK0WRAye5c5F5QVhH3eQRwIYMNXdGrMUrpXns5/82Zqo0depNZk5FqLtssacGOCFCcHvWoOtimQTuSMmLaRq2Pcxtfc6Z8tt5V2+I0TSVWwXay8vp12mgaLajbWTMCEhlr2Lt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791648086; c=relaxed/simple;
	bh=Bp9DoxMkVf1YFsG60kUVXkST5fsCYCud3Gu4henN2s4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=CBW+03PgqsugDzwsrfVWjVUgO6wAXTKFxHnE1g1DiZpZuuzTjx8kIMdFfUDMEjLwZcmXntkiZGnr8s4lBRNLVteOPiS7D2WunUCsqtoxPBcE5jjKdTAH5Zv7+hT2xH6aELI0CKTFyBnlqYbZJhKsB0xsgEt5IKyRSzJL3Y5AV9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=XY9qjM1G; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="XY9qjM1G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QRlDOfRLib+QmlK02jGROBPleAYn65x7ICBGruxIcO4=; b=XY9qjM1GZMwrYTp8YjI2hwv6+j
	CQGbawQtCQ1bx7cmRX2BSHLYv/gUg6CNnVy/J+dYPmSxkzFSTrMOudLSu3xpbsOHC+KjH/eBqNvU2
	RgFqc/Z3YwWuJd/CWqJkRyhnTSu3V9M5cTqvCxs2YyqjCKM2TAtJozXYYNOzj/e2DFf9UvCtvzwLN
	elg1XPnfjQZoL68d5Ahysols5zNZKqpszoBnwUtdzQiIwMfJqg1R5nO+sEh5R9oKiMvaEISsLZAku
	7iOCYKT0h2heklqUCO5NRobQrbRpvGwKk99+5qFj1LncqeLCXZO7xGsB9N5N9ozIV8H6X+xfIrcOr
	L1PPWNAA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xFZVa-00000003L5T-37Uo;
	Sat, 10 Oct 2026 13:01:14 -0300
Message-ID: <b4e10a4c9d666c99cd7ef704ad0fce0b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Henry Martin <bsdhenrymartin@gmail.com>, Namjae Jeon
 <linkinjeon@kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam
 Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, Steve French <stfrench@microsoft.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, Henry Martin
 <bsdhenrymartin@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] cifs: fix use-after-free of server info on
 cifs_ses_add_channel error
In-Reply-To: <20261010032856.1880706-1-bsdhenrymartin@gmail.com>
References: <CAKYAXd8MyiCVhdN_PaQ=aSEO3yYYQ-Qb-2TnC68o0_pbchM0mw@mail.gmail.com>
 <20261010032856.1880706-1-bsdhenrymartin@gmail.com>
Date: Sat, 10 Oct 2026 13:01:14 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Henry Martin <bsdhenrymartin@gmail.com> writes:

> The error path of cifs_ses_add_channel() calls cifs_put_tcp_session()
> before cifs_chan_clear_need_reconnect().  The latter reaches
> cifs_ses_get_chan_index(), which dereferences server->terminate; if
> the put was the final reference, TCP_Server_Info is already freed and
> this is a use-after-free.  Same put-then-use pattern as the recently
> fixed sibling in commit 717e0a25036b ("cifs: Fix server use-after-free
> in cifs_chan_skip_or_disable()").
>
> Move the put last, but do not read chan->server after dropping
> chan_lock: chan points into ses->chans[], and once chan_count is
> decremented a concurrent add_channel can reuse the slot and overwrite
> the pointer, so the put would act on the new channel's server.  Cache
> the pointer under chan_lock, clear the reconnect bit and decrement
> chan_count while still holding the reference, and release it after
> the unlock.
> ...

Applied.
