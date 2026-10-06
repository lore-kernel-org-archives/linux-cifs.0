Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4162B270575
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 19:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791316092; cv=none; b=p5jnlsoUBsamhhX28RfONfKZspht1ncDUrAx27poOy74tNK1BRsSclLgWu+BwPh1jKEkMjcfJMTrbhOsucRA8WsrHVmnMhehXUu1dW4DkOtQDr0mLLrhZyW+jFEKUJXADmtFhk+mHOMJnIhxEivFhhUmdkHiq1YWY6tqdh4EZPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791316092; c=relaxed/simple;
	bh=7CVunao+vPo7VqyOtxjbOwHobx8DBBTlB/4dGLv8UZ4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=BP9av+jgVG6EsyKO2/p9I7/0un76zsYXwsBzRF+s21xSDREEVU0h+rpiVgytdNZPEhGKpc8dQG/kmdfU4xjPgBEgfZLUu/jNMYkWzGekhikEYXkWu/K6aAtxkURkC68PqjkqIhvkmDYomVrcr393RSpw9nnUD3TGHxEpMOxI4uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=C8nJuqLc; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="C8nJuqLc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WBwJusaljE38i7DDJqb89j1tWtTgg6RZAPeTB4bED+U=; b=C8nJuqLcCNmIGi/uByupnwsZS1
	0cV5ilKOnGdoC1r+Floe9oBfyKAUd7ff6E496uSwUJUNjiYCAzc9UtQEanydXNmiKwItlT99ZhIC7
	1isa9bFWvknGn0tEzR9XkwCZtQofNZmy4W/TIw3olF8hJ/a3jXuEFb2linvScFnSjobW8bEHt9ch5
	LapDWyMb3H8+7cQhc2AEiIIkkRtwfiybj4LW4VyPR/0Pasx9QdfO+Gn+TaF2vUHD0Fu4knimrRkaa
	r15EEk2F+hZqd/Z3B9dbgogQKwIO8gCJXxzr5A5miCuJRyBPPa34bRUYNZq+cyqOTv20M3UaFTu69
	X9xXu3vw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xEB8x-000000033Pf-2fHH;
	Tue, 06 Oct 2026 16:48:07 -0300
Message-ID: <b0f37e56c4559eb51624f76f92c23ee8@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, henrique.carvalho@suse.com, Enzo
 Matsumiya <ematsumiya@suse.de>
Subject: Re: [PATCH v3 2/2] smb: client: prevent premature discard of
 requests if reconnecting
In-Reply-To: <20260929170358.270612-2-ematsumiya@suse.de>
References: <20260929170358.270612-1-ematsumiya@suse.de>
 <20260929170358.270612-2-ematsumiya@suse.de>
Date: Tue, 06 Oct 2026 16:48:07 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Enzo Matsumiya <ematsumiya@suse.de> writes:

> Add TCP_Server_Info::reconnecting to track cifs_reconnect() lifetime.
> Wait for it to be true in cifs_wait_for_server_reconnect(), and only
> then wait for tcpStatus change.
>
> Also, return -ECONNRESET (instead of -EHOSTDOWN) if reconnect is still
> ongoing at the end, so requests are not discarded unnecessarily;
> -ECONNRESET is not immediately retried by intermediate layers, e.g. VFS
> or netfs, but still serves as an indication to userspace that retrying
> the operation might be successful.
>
> Changes (refactor cifs_wait_for_server_reconnect()):
> - remove unnecessary do/while loop; use wait_event_interruptible()
>   for hard mounts
> - increase timeout, and base it on echo_interval to match user
>   preferences
> - remove useless debug log for interrupt errors
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
> v2 -> v3:
> - handle CifsExiting status on hard mounts (from sashiko report)
>
> v1 -> v2 (fix issues detected by sashiko):
> - handle condition changes post-wait_event timeouts
> - return -ECONNRESET instead of -EAGAIN when leaving still reconnecting
>
> (not from sashiko):
> - add missing wake_up() after setting server->reconnecting to true in
>   cifs_tcp_ses_needs_reconnect()
> - handle tcpStatus == CifsExiting in cifs_wait_for_server_reconnect()
>  fs/smb/client/cifsglob.h |  1 +
>  fs/smb/client/connect.c  |  4 ++
>  fs/smb/client/misc.c     | 94 ++++++++++++++++++++++++++++------------
>  3 files changed, 72 insertions(+), 27 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index e49140d5c4a4..61191a167b89 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -803,6 +803,7 @@ struct TCP_Server_Info {
>  	struct delayed_work reconnect; /* reconnect workqueue job */
>  	struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
>  	bool need_sock_shutdown; /* true when CifsNeedReconnect was first set by non-cifsd task */
> +	bool reconnecting; /* if cifs_reconnect() is indeed running */
>  	unsigned long echo_interval;
>  
>  	/*
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 733d50b042fd..8ea60965ae06 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -374,6 +374,8 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
>  	shutdown = (server->tcpStatus != CifsNeedReconnect || server->need_sock_shutdown);
>  	server->need_sock_shutdown = false;
>  	server->tcpStatus = CifsNeedReconnect;
> +	server->reconnecting = true;
> +	wake_up(&server->response_q);
>  	spin_unlock(&server->srv_lock);
>  
>  	if (shutdown) {
> @@ -457,6 +459,7 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
>  	spin_lock(&server->srv_lock);
>  	if (server->tcpStatus == CifsNeedNegotiate)
>  		mod_delayed_work(cifsiod_wq, &server->echo, 0);
> +	server->reconnecting = false;
>  	spin_unlock(&server->srv_lock);
>  
>  	wake_up(&server->response_q);
> @@ -599,6 +602,7 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
>  	spin_lock(&server->srv_lock);
>  	if (server->tcpStatus == CifsNeedNegotiate)
>  		mod_delayed_work(cifsiod_wq, &server->echo, 0);
> +	server->reconnecting = false;
>  	spin_unlock(&server->srv_lock);
>  
>  	wake_up(&server->response_q);
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index 05168284f205..3fa4e36aac32 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -1077,44 +1077,84 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
>  
>  int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
>  {
> -	int timeout = 10;
> -	int rc;
> +	int timeout, rc = 0;
>  
>  	spin_lock(&server->srv_lock);
>  	if (server->tcpStatus != CifsNeedReconnect) {
> +		if (unlikely(server->tcpStatus == CifsExiting))
> +			rc = -ESHUTDOWN;
>  		spin_unlock(&server->srv_lock);
> -		return 0;
> +
> +		return rc;
> +	}
> +
> +	/* Hard mounts keep waiting until process is killed or server comes back on-line. */
> +	if (retry) {
> +		spin_unlock(&server->srv_lock);
> +
> +		return wait_event_interruptible(server->response_q,
> +						(server->tcpStatus != CifsNeedReconnect));

Hrm - given the above comment, makes me think that we should be calling
wait_event_killable() instead on hard mounts.  But that would change
current behavior, so it's probably better to handle it separately.

What do you think?

>  	}
> -	timeout *= server->nr_targets;
> +
> +	/*
> +	 * Soft mounts, wait with timeout.
> +	 * Compute timeout based on echo_interval, to match user expectations wrt. time to recover
> +	 * from network interruptions.
> +	 *
> +	 * Minimum is 17 seconds (per reconnect target):
> +	 *   7s for cifs socket timeout
> +	 *   3s sleep after a failed attempt
> +	 *   7s spare, to cover at least a full attempt
> +	 *
> +	 * Maximum is 60s; might not be enough in some rare cases, but >60s is too much.
> +	 */
> +	timeout = max(server->echo_interval / HZ, 17) * server->nr_targets;
> +	timeout = min(timeout, 60);

I know you've intentionally increased the timeout, but my worry is that
I/O will now fail with -ECONNRESET/-EHOSTDOWN after 180-240s instead of
10s on soft mounts with a single target server?

Are you sure that the best option is to rely on the echo_interval value?

The rest looks good, thanks for fixing this issue.
