Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E6D27726
	for <linux-cifs@vger.kernel.org>; Mon,  8 Sep 2025 09:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757322202; cv=none; b=Jgd+T+Joxh6u3gM5nALyyuIejb72zoWTkPngnRPWsCQNtFWQ1XelMQHgI3kTF2QgvsaVFAr9TGUqRh15QHqiZrnDWo3PAMjYN9oC43BCSIIO0eP+cfFmToxWfvfBQYJABYlc3ICkK55O8/voo9hEqvYBQM3bavGzaVWJYGLhv+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757322202; c=relaxed/simple;
	bh=FK4ntL5VpyqFh0hlrM5zVFpgF6WInc7l12aZDiRVJi8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RLJQtnSIBo63p3h/kzfyC+ZN8/XXBwHNif38EV/AScd22LjwNr1ZAoz+aqZWoDw9mc7stgfEA/TOzA/4ayAQLeqWx3qyrdS5N8QOBNSx1qdCS5ulSL6GtsTB5PECtO7s2ZDjofMoGPsA0Hp4xMclTWJDE7/N69rfACdlkhlSAy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nXuj6sTF; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nXuj6sTF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=/BAWmz2J4iABur/eFvgSCenb5vjuXTUx5jrQy03ODzo=; b=nXuj6sTFUpUPvj90AoztOmxwEq
	6BCMOVMp7t9LGQG+YXS5u5QYLN9EPLfNkJaz+W8V3V0HbC9dnbRTghgqXBHMjB4rbrrQmlCnaAgkg
	n42ZVgHycBr/tT+ntP4Fg/BBnHYkqU+STwNzI5nA3KIZU2Hcqhwd1JSs3wy4y5ZISNA+P5Cgmyv7G
	Fwqc7Hn2630Ui8fCAGj1Op9GVKsv2VaIKXMbagUdAACdB8jW2e3rOW0KNOYvxj7dQ2xLVmZRa6pLB
	+GvufIp+4n0SFWK2Vg+9/6hZuwOjpUOKKA/tU6y3GVfvgLjQkOzeciMKC1F9Nd/JPqidYr+b6mUij
	g7JB8xwIOPE+jZZ2Rolrzq2lV5dDX0fIt4+9VW7NEQLtPWV6ws+BPrtBvF/31MUJ7HyRFI+G+jnbd
	SSUwKxYUV8Yj7OCXkvgFEupMfyEDNUg7EgClZj5kFgjZot1QiM2r+bSmR3qMlr3C64+xWzcPglZUU
	w8DzLbzGIWWccEfYI5XymBrw;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uvXmO-0030PT-29;
	Mon, 08 Sep 2025 09:03:16 +0000
Message-ID: <fcd54ce4-a9f1-45ac-bc18-e0bb6eacba89@samba.org>
Date: Mon, 8 Sep 2025 11:03:16 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 048/142] smb: client: don't check
 sc->send_io.pending.count is below sp->send_credit_target
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>
References: <cover.1756139607.git.metze@samba.org>
 <02ad437bfe57819274af80b0cd3cd4dff96fbbba.1756139607.git.metze@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <02ad437bfe57819274af80b0cd3cd4dff96fbbba.1756139607.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 25.08.25 um 22:40 schrieb Stefan Metzmacher:
> If we were able to get a credit we don't need to prove and wait
> that sc->send_io.pending.count is below sp->send_credit_target.
> 
> This just adds useless complixity. The same code on the server
> also doesn't do this, so we should remove it from the client.
> 
> This will make it easier to momve to common code later.
> 
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   fs/smb/client/smbdirect.c | 28 ++++------------------------
>   fs/smb/client/smbdirect.h |  3 ---
>   2 files changed, 4 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 2eaddf190354..220ebd00a9d7 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -414,8 +414,6 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
>   	if (atomic_dec_and_test(&sc->send_io.pending.count))
>   		wake_up(&sc->send_io.pending.wait_queue);
>   
> -	wake_up(&info->wait_post_send);
> -
>   	mempool_free(request, sc->send_io.mem.pool);
>   }
>   
> @@ -1035,23 +1033,6 @@ static int smbd_post_send_iter(struct smbd_connection *info,
>   		goto wait_credit;
>   	}
>   
> -wait_send_queue:
> -	wait_event(info->wait_post_send,
> -		atomic_read(&sc->send_io.pending.count) < sp->send_credit_target ||
> -		sc->status != SMBDIRECT_SOCKET_CONNECTED);
> -
> -	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
> -		log_outgoing(ERR, "disconnected not sending on wait_send_queue\n");
> -		rc = -EAGAIN;
> -		goto err_wait_send_queue;
> -	}
> -
> -	if (unlikely(atomic_inc_return(&sc->send_io.pending.count) >
> -				sp->send_credit_target)) {
> -		atomic_dec(&sc->send_io.pending.count);
> -		goto wait_send_queue;
> -	}
> -

I'll drop this change for now, as I found commit 3ffbe78aff93
("cifs: smbd: Check send queue size before posting a send")

Instead I'll change info->wait_post_send into sc->pending.dec_wait_queue.

I'll look at it again when moving to common functions, but for now
I better try to avoid changing the logic here and we may need to
add something like this to the server too.

While debugging the problem that lead to these fixes:
smb: server: let smb_direct_writev() respect SMB_DIRECT_MAX_SEND_SGES
https://lore.kernel.org/linux-cifs/20250904181059.1594876-1-metze@samba.org/
and RDMA/siw: avoid hiding errors in siw_post_send()
https://lore.kernel.org/linux-rdma/20250904173608.1590444-1-metze@samba.org/
I first thought that exactly the above logic was missing in the server...

metze

