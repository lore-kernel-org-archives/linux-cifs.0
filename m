Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6CA2C3264
	for <linux-cifs@vger.kernel.org>; Fri, 15 Aug 2025 12:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755261741; cv=none; b=bPLAtq1ZKEbnzSRnM+D2znk7gXMqlS8x3g1nYBp/P6pR2ng9UFf9lo5Xw/235hlQj8A47Gv6l+hdYxTvZT+bAsQPhNPpibxx2YDmgoLSRgqGbKvoj5ywoU7VZUD8dDZbQLw1XQMjZmcoDscpBTy3l2FuwwuBJPgnic1jz5gq8Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755261741; c=relaxed/simple;
	bh=p0awzx4AijzArh9JoVwmWj36SOsFG/OWj8fzXV535aQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tw3GUEJTXV3fMnMCJYHovr5jez7A52JTxH1XMhoTGFIWUD51QPUb17pYh+guLVLkJSOslOn2K500K00g/W5XPpMlIw0cg5xearMUCX+R8tncfOTI7XZcMF1JrlNkG3GC38z2PPkjsvF8f9Y8kGAih6PEqzqkf9eTPwT6ss5ZTg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jHrajgTr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0SEzJ/43; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U8S6xj0O; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lgY7iy8G; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jHrajgTr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0SEzJ/43";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U8S6xj0O";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lgY7iy8G"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4FB5E1F83E;
	Fri, 15 Aug 2025 12:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755261737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+aN0nyWY9xyAWt8szmbtZDz6QLFo+Mt7EQPzixcj0WU=;
	b=jHrajgTrIC5sYzZrpTj06wqKyH6F6zJ8TONxtxwHkH8KLtUNx4jQu5F6Oxx1U/L1jKTEeE
	takFnxkE1WJG0GLihGKAOY31JxglhwzlbFnfSgsHCSHfsAA4zaq0AVKbtEF6wydH2ieeF9
	5Torb4cM13CaSoyLedRkRvpFIavBu44=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755261737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+aN0nyWY9xyAWt8szmbtZDz6QLFo+Mt7EQPzixcj0WU=;
	b=0SEzJ/43gt9EL5TqpZgULlCTVpPxWqok6JgCQ4Ro7FzA4C7IZUzwUw5HsFqPQQ7F5TJWlE
	4XxXeRM4osktnqCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755261736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+aN0nyWY9xyAWt8szmbtZDz6QLFo+Mt7EQPzixcj0WU=;
	b=U8S6xj0OgnHBadWUMyCh7STRnLXMybdROorbTlmtl8IRSC6yKI+nrcVrdJcIL33DxIpyjB
	ExG4f8XLDt7zFJrMeTNcVypEwG0b4Pm1GWZFgyrz1KUDAbd4M02yuOqWXg66V/jFm5c0er
	GoKGngPIXU4d9JU3L7RJwjUgwHSd8Dk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755261736;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+aN0nyWY9xyAWt8szmbtZDz6QLFo+Mt7EQPzixcj0WU=;
	b=lgY7iy8GiI1doUwgX8s2Lwi8fhbtT9Mvn9JUD74R6MoRlJ1xTibyrakvu6C3kFJ8ZM/GqD
	gJudQpvY34FpKxCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D42E013876;
	Fri, 15 Aug 2025 12:42:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2uuwMCcrn2jDZQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 15 Aug 2025 12:42:15 +0000
Date: Fri, 15 Aug 2025 13:42:17 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH] smb: server: split ksmbd_rdma_stop_listening() out of
 ksmbd_rdma_destroy()
Message-ID: <cwxjlestdk3u5u6cqrr7cpblkfrwwx3obibhuk2wnu4ttneofm@y3fg6wpvooev>
References: <20250812164546.29238-1-metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812164546.29238-1-metze@samba.org>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.samba.org,kernel.org,gmail.com,talpey.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[samba.org:email,talpey.com:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80

On Tue, Aug 12, 2025 at 06:45:46PM +0200, Stefan Metzmacher wrote:
> We can't call destroy_workqueue(smb_direct_wq); before stop_sessions()!
> 
> Otherwise already existing connections try to use smb_direct_wq as
> a NULL pointer.
> 
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>  fs/smb/server/connection.c     | 3 ++-
>  fs/smb/server/transport_rdma.c | 5 ++++-
>  fs/smb/server/transport_rdma.h | 4 +++-
>  3 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
> index d1f36f899699..525409706805 100644
> --- a/fs/smb/server/connection.c
> +++ b/fs/smb/server/connection.c
> @@ -517,7 +517,8 @@ void ksmbd_conn_transport_destroy(void)
>  {
>  	mutex_lock(&init_lock);
>  	ksmbd_tcp_destroy();
> -	ksmbd_rdma_destroy();
> +	ksmbd_rdma_stop_listening();
>  	stop_sessions();
> +	ksmbd_rdma_destroy();
>  	mutex_unlock(&init_lock);
>  }
> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
> index 99964a75d13e..16bf68dbf4ae 100644
> --- a/fs/smb/server/transport_rdma.c
> +++ b/fs/smb/server/transport_rdma.c
> @@ -2200,7 +2200,7 @@ int ksmbd_rdma_init(void)
>  	return 0;
>  }
>  
> -void ksmbd_rdma_destroy(void)
> +void ksmbd_rdma_stop_listening(void)
>  {
>  	if (!smb_direct_listener.cm_id)
>  		return;
> @@ -2209,7 +2209,10 @@ void ksmbd_rdma_destroy(void)
>  	rdma_destroy_id(smb_direct_listener.cm_id);
>  
>  	smb_direct_listener.cm_id = NULL;
> +}
>  
> +void ksmbd_rdma_destroy(void)
> +{
>  	if (smb_direct_wq) {
>  		destroy_workqueue(smb_direct_wq);
>  		smb_direct_wq = NULL;
> diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_rdma.h
> index 0fb692c40e21..659ed668de2d 100644
> --- a/fs/smb/server/transport_rdma.h
> +++ b/fs/smb/server/transport_rdma.h
> @@ -13,13 +13,15 @@
>  
>  #ifdef CONFIG_SMB_SERVER_SMBDIRECT
>  int ksmbd_rdma_init(void);
> +void ksmbd_rdma_stop_listening(void);
>  void ksmbd_rdma_destroy(void);
>  bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
>  void init_smbd_max_io_size(unsigned int sz);
>  unsigned int get_smbd_max_read_write_size(void);
>  #else
>  static inline int ksmbd_rdma_init(void) { return 0; }
> -static inline int ksmbd_rdma_destroy(void) { return 0; }
> +static inline void ksmbd_rdma_stop_listening(void) { return };
                                                     ^^ return; (nothing at all would be even better)
This seems to have broken our internal linux-next builds.

Thanks, 
Pedro
