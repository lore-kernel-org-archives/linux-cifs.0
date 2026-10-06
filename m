Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D92375AC4
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 18:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791310449; cv=none; b=V8C4lZznUwLDObh/wwvJOVuShWgQ99cAcFJfkHerINzmz6AwZH6xPC6RDT9Dh/Q8sdr0wFRVBTxJI1Hlzc6X502n2A5GWu9AQwz2tw9ZOoBd8OPTGLIh95oBT+4u1sPc3lZRp9QZcyNf56F9eqtEWye226uDZIMRtW7Fb9h0n1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791310449; c=relaxed/simple;
	bh=cR2yQzgyUDspLPcnQUQ+D0GzG3qMhdbyb8pU+s7ONYk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=N4Xb/opkQtvfCSiXPZEn/R9SpR+7n+hdd6/4wt+cfcyZfJB46JMXYv7lUpCb75oKNEdAjb9dpGDVnGLQY6wI/E13umCSyUKTSe5eJB255zEe3S6iiTbu1ebqboMb7KZKaZYOH26L9grc9FoNEvJZ9FS4LSZKjyzVsdGCCjab/kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=m+hqOxbo; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="m+hqOxbo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BF3yIzVKzMMdJ1uyXVtzuLhohgQ8n/ytT2ra89eOi1E=; b=m+hqOxboOmMy0y5Fq13fYQEQ1l
	zmFfFgPcEO6swOT3FaaZUTp++az7K5w54+WvzX/Hmb78TYfXhEru6TQZNSpJhUmTKMnPi9kLWYdU0
	GhxN830cpk/eTjnZIQ6DQ+22Ow/LvWldgb+5NsAdQASnIv89qg3oCzPTMM/Y7irzPZFAVqUkOJHLh
	PldMzb5iRe7jW+5LpmMrsswq/yOvET9vSA5DTuRH8XTfihLM3glJb26jGDUOgc1Euw1zdTyM5MLD4
	gQbTNs98ubef5eiZaTP850hPlA6mo+coGaqvh55FMF3Mj5eexWXFvqe5yWdE+DhG0Qpw5i4XYO4Qv
	2t67ikMQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xE9ft-0000000337l-15yv;
	Tue, 06 Oct 2026 15:14:01 -0300
Message-ID: <4627cfd704304e43bed6825ae68699ad@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, henrique.carvalho@suse.com, Enzo
 Matsumiya <ematsumiya@suse.de>
Subject: Re: [PATCH v3 1/2] smb: client: fast fail sends if need to reconnect
In-Reply-To: <20260929170358.270612-1-ematsumiya@suse.de>
References: <20260929170358.270612-1-ematsumiya@suse.de>
Date: Tue, 06 Oct 2026 15:14:00 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Enzo Matsumiya <ematsumiya@suse.de> writes:

> smb_send_kvec() keeps retrying when server needs to reconnect, which
> makes no sense as cifs_reconnect() will never run in parallel (because
> both need server mutex).
> IOW, retrying will never succeed, but only delay reconnects further.
>
> Bail out early from smb_send_kvec() when need to reconnect.
>
> Also shutdown socket queues when CifsNeedReconnect is first detected,
> so any sends/receives fails immediately (and don't wait for socket to
> timeout).
>
> Add TCP_Server_Info::need_sock_shutdown to ensure socket is shutdown
> only once.
>
> kernel_sock_shutdown() will be called from whichever task detects it
> first;  cifsd (cifs_tcp_ses_needs_reconnect()), or sending tasks,
> through cifs_call_async() or compound_send_recv().
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
> v2 -> v3 (patch refactor, change strategy but keep concept):
> - remove TCP_Server_Info::mutex_owner (covers sashiko report)
> - shutdown socket directly from sender functions (when need to reconnect)
> - bail out from smb_send_kvec() when need to reconnect only if rc <= 0
>   (from sasiko report)
>
> v1 -> v2 (fix issues detected by sashiko):
> - move kernel_sock_shutdown() call out of cifs_tcp_ses_lock
> - use server mutex to check/shutdown socket
>
>
>  fs/smb/client/cifsglob.h  |  1 +
>  fs/smb/client/connect.c   | 22 +++++++++++++++++++---
>  fs/smb/client/transport.c | 30 ++++++++++++++++++++++++++++++
>  3 files changed, 50 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 79e4e84f8985..e49140d5c4a4 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -802,6 +802,7 @@ struct TCP_Server_Info {
>  	bool	posix_ext_supported;
>  	struct delayed_work reconnect; /* reconnect workqueue job */
>  	struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
> +	bool need_sock_shutdown; /* true when CifsNeedReconnect was first set by non-cifsd task */
>  	unsigned long echo_interval;
>  
>  	/*
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 28e1ddeb6182..733d50b042fd 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -126,12 +126,14 @@ void smb2_query_server_interfaces(struct work_struct *work)
>  	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
>  			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
>  }
> -

Why are you removing the blank line?

>  #define set_need_reco(server) \
>  do { \
>  	spin_lock(&server->srv_lock); \
> -	if (server->tcpStatus != CifsExiting) \
> +	if (server->tcpStatus != CifsExiting) { \
> +		if (server->tcpStatus != CifsNeedReconnect) \
> +			server->need_sock_shutdown = true; \
>  		server->tcpStatus = CifsNeedReconnect; \
> +	} \
>  	spin_unlock(&server->srv_lock); \
>  } while (0)
>  
> @@ -353,6 +355,8 @@ cifs_abort_connection(struct TCP_Server_Info *server)
>  
>  static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num_targets)
>  {
> +	bool shutdown;
> +
>  	spin_lock(&server->srv_lock);
>  	server->nr_targets = num_targets;
>  	if (server->tcpStatus == CifsExiting) {
> @@ -365,9 +369,21 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
>  	cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
>  	trace_smb3_reconnect(server->current_mid, server->conn_id,
>  			     server->hostname);
> -	server->tcpStatus = CifsNeedReconnect;
>  
> +	/* Cover cases where sender tasks didn't manage to shutdown the socket for some reason */
> +	shutdown = (server->tcpStatus != CifsNeedReconnect || server->need_sock_shutdown);
> +	server->need_sock_shutdown = false;
> +	server->tcpStatus = CifsNeedReconnect;
>  	spin_unlock(&server->srv_lock);
> +
> +	if (shutdown) {
> +		cifs_server_lock(server);
> +		if (server->ssocket)
> +			/* Don't release it here/yet! */
> +			kernel_sock_shutdown(server->ssocket, SHUT_RDWR);
> +		cifs_server_unlock(server);
> +	}
> +

The new TCP_Server_Info::need_sock_shutdown field seems unnecessary.

You could simply call kernel_sock_shutdown() if @server->ssocket != NULL
after releasing ->srv_sock, as the socket can be shut down only once.

>  }
>  
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index 6e21b5f8754a..a1ae8548cf16 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -179,7 +179,18 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
>  		 * to avoid unnecessary reconnects.
>  		 */
>  		rc = sock_sendmsg(ssocket, smb_msg);
> +
> +		/*
> +		 * If need to reconnect, blame it for any non-interrupt error and bail out early,
> +		 * even if -EAGAIN;  reconnect will never happen in parallel as cifs_reconnect()
> +		 * needs server mutex (which we're already holding), so it's pointless to retry.
> +		 */

Long lines.  Keep them at 80 columns max.

Consider doing the same for the rest of the series.

> +		if (unlikely(rc <= 0 && server->tcpStatus == CifsNeedReconnect &&
> +			     !is_interrupt_error(rc)))
> +			return -ECONNRESET;

You are reading tcpStatus without holding ->srv_lock.  Is that OK?  If
so, you should use READ_ONCE() here.

> +
>  		if (rc == -EAGAIN || unlikely(rc == -EINTR && task_work_pending(current))) {
> +

Remove this new blank line.

>  			retries++;
>  			if (retries >= 14 ||
>  			    (!server->noblocksnd && (retries > 2))) {
> @@ -654,6 +665,23 @@ int wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *mid)
>  	return 0;
>  }
>  
> +static inline void cond_sock_shutdown(struct TCP_Server_Info *server)

inline is unnecessary.  This isn't even hot path.

> +{
> +	bool shutdown;
> +
> +	lockdep_assert_held(&server->_srv_mutex);
> +
> +	spin_lock(&server->srv_lock);
> +	/* No need to check status, need_sock_shutdown is only set if CifsNeedReconnect */
> +	shutdown = (server->need_sock_shutdown && server->ssocket);

Again, TCP_Server_info::need_sock_shutdown doesn't seem to be required
as you could have done

        shutdown = server->tcpStatus == CifsNeedReconnect && server->ssocket;

Besides, the parentheses are unnecessary, so remove them.

Otherwise, looks good.
