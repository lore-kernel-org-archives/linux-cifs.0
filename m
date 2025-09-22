Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF44279DC9
	for <linux-cifs@vger.kernel.org>; Mon, 22 Sep 2025 21:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758575646; cv=none; b=KnEGXiQLti2tsOsNKiPdiyFF1wnLxlXTdArRQ/efWC9Uitb4Iwx7lG04uLOklSA4/OYd1pspLIQ3/RstpauEWpgXgXH1YSXwtNoItSRTqklER6REF+1iQB3srUG8X9uVFAPfUYzvoxzqxBd/JYNOgSl+6SftF9S7qyuagcMR7hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758575646; c=relaxed/simple;
	bh=NVqNZVGuWMPfCSYxEdjsIejlbkdUqztfaNiXA+Sie0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o6e2l+ulEwX0d4P1DhUd8DZhP5adnEz97ojH4nF5PLsH5TwGRB1avGZydDpw091TLDOVa3+tZ1vMIyKXcABzubS/KKgQfmW7K8TRSVBqRS3m7PL5EAIhFMzB0b6igKTiwHO53xgQVxhVAxATudUwHkdjo/Q7MRo+LdJubVB7FR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=am0Lsjzw; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="am0Lsjzw"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3ece0e4c5faso5614579f8f.1
        for <linux-cifs@vger.kernel.org>; Mon, 22 Sep 2025 14:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758575640; x=1759180440; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AQnUC3UTWERRUD1tnLSmBeOd/aMW4l6+vTyxgJ9B0ZY=;
        b=am0LsjzwKy6vma582juk5KcifsyncQDpHuw/vJgVh7SjqamohCaspyDKtU53e+DEVJ
         0Lm0yMub+Q7mbkJVtQL98+s/KstXLBGJUH2rnZp05EcBkAzRcGaStH5UXft+nGjP/fvV
         YPhqQ36SfWdL7PHu1vYLi18+bDAwIIUElZYCTnD+dSsVSPCkPZXpTzG78tMxjGDmaeWP
         zk56yIM39o4IOHZDTwXo3l7J/BkIh3PSWTxzCSd7aQehC7feLJShTRx9+fVggR2vCdUA
         CSZqoiiTMbxyKVnFaNl7jRwXxbNei1DqqEdpacxUUEQD8xd34lgIp7H7RAZUMbKQqtiN
         bLVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758575640; x=1759180440;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AQnUC3UTWERRUD1tnLSmBeOd/aMW4l6+vTyxgJ9B0ZY=;
        b=NzYtRY1E76S+9Szm/WTSaeAbINRNem4wk3fwnNVahuaXl7nVMNj+5urZoRjqSNd9Vg
         FKMgqf2VI5IBOdriHcSfTchxTWcmZRqlwPs7Kz3BFXDU84SqZ5GNiECfe+SNjpUQEaM7
         ekzZHD7d8iyYyf4cyy9zA2FKAT0WIQaMbaCJNy6bAonZyzCw5hcjCKGA+M37LolOyvad
         saKkiD+SI4kay9lTIfv+ZcQ+oVktnirIuoyq8uQfFCf7/GYf3ei8dqzWSAILidtUyR4c
         /vlScN9g5plsRolzOessayk6SaeCpsRVae5jAg2Sp7+0ckRQvjwDt2mWC7HKOT91735r
         dkeg==
X-Forwarded-Encrypted: i=1; AJvYcCW8HhJqP1ifyunRrXAyPYqVVJlJ3evPt6d03dhYVko6bGVFkf21ah8h4R9MV69WYAFeE4oZdYZAAglx@vger.kernel.org
X-Gm-Message-State: AOJu0YzZeKNYxSyLxlWqMrPZadu3P/MgIxSeW8jEolZDmA5fhRFITPqK
	fZkOWYKV0kBa+PTZfy0ulQUYpLr9LdsdYQkTDUCOogAlYsDARlstppCPia5TDRyvh+gis0mTor2
	moeGJ
X-Gm-Gg: ASbGncsGCAHbSGsz16x+5C1LXTBx54i3yjvOfPcK2nwnOrKPejDLjVZFOwagf1LkE8e
	mmmw1Pv1mY7tWbS8t/foeHQO4/hbwY8TC1Ko5cPPhvaWq+G6EOjZ6FzrAaLiK+B4ruYfTEyCOoQ
	60U6Pw9e8ezSGhwEv3QVIoITGAk/Wlc/99+BnegQYhEE+Tw+upIySbBO7DNqc/EcwUpqmU/eLEi
	zshlfhm6TAocaMFV2VombSRGudbnF9qApdk3Yrxh0/eqbkS9XvNa2t7ANhXoinb9QZlx88QCvQA
	kWPmoTjhIxJsIecyTC7PWEkkncvBxTP5YA9L06nOHXWd8deG3BWoJPWaQo0pK6S+hRQjUPoF5r3
	R0eKmkbgFJiNwJeX2HWHYEE1xGp51vZeA+JMBel5J1XlnrObc48054kTNifnbvjPy5kVnZ0tvvj
	WkwNwy5g==
X-Google-Smtp-Source: AGHT+IEx15QVBVxvTAM0FZsC5CNe1S0I6wlrxJKzWygPiCQ3qj8lhe+IqEzD9Xhgm9A1hjvD5VDRUw==
X-Received: by 2002:a5d:5d03:0:b0:3ee:23a7:5df0 with SMTP id ffacd0b85a97d-405ccdc1a03mr96756f8f.54.1758575640475;
        Mon, 22 Sep 2025 14:14:00 -0700 (PDT)
Received: from ?IPV6:2804:18:898:c51e:84f3:b734:4d02:e7d? ([2804:18:898:c51e:84f3:b734:4d02:e7d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-332a96fc922sm98666a91.4.2025.09.22.14.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 14:13:59 -0700 (PDT)
Message-ID: <d09c8506-6326-45e6-8687-8e0b002eff62@suse.com>
Date: Mon, 22 Sep 2025 18:11:49 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] cifs: client: allow changing multichannel mount
 options on remount
To: rajasimandalos@gmail.com, Rajasi Mandal <rajasimandal@microsoft.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
References: <20250922082417.816331-1-rajasimandalos@gmail.com>
 <20250922082417.816331-2-rajasimandalos@gmail.com>
Content-Language: en-US
From: Henrique Carvalho <henrique.carvalho@suse.com>
In-Reply-To: <20250922082417.816331-2-rajasimandalos@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Rajasi,

On 9/22/25 5:24 AM, rajasimandalos@gmail.com wrote:
> From: Rajasi Mandal <rajasimandal@microsoft.com>
> 
> Previously, the client did not properly update the session's channel
> state when multichannel or max_channels mount options were changed
> during remount. This led to inconsistent behavior and prevented
> enabling or disabling multichannel support without a full
> unmount/remount.
> 
> Enable dynamic reconfiguration of multichannel and max_channels
> options during remount by introducing smb3_sync_ses_chan_max() to
> safely update the session's chan_max field, and smb3_sync_ses_channels()
> to synchronize the session's channels with the new configuration.
> Replace cifs_disable_secondary_channels() with
> cifs_decrease_secondary_channels(), which now takes a from_reconfigure
> argument for more flexible channel cleanup. Update the remount logic
> to detect changes in multichannel or max_channels and trigger the
> appropriate session/channel updates.
> 
> With this change, users can safely change multichannel and
> max_channels options on remount, and the client will correctly adjust
> the session's channel state to match the new configuration.
> 
> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> ---
>  fs/smb/client/cifsproto.h  |  2 +-
>  fs/smb/client/fs_context.c | 29 ++++++++++++++++++
>  fs/smb/client/fs_context.h |  2 +-
>  fs/smb/client/sess.c       | 35 +++++++++++++++-------
>  fs/smb/client/smb2pdu.c    | 60 ++++++++++++++++++++++++++++++--------
>  fs/smb/client/smb2pdu.h    |  2 ++
>  6 files changed, 105 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index e8fba98690ce..ec3118457b26 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -667,7 +667,7 @@ bool
>  cifs_chan_is_iface_active(struct cifs_ses *ses,
>  			  struct TCP_Server_Info *server);
>  void
> -cifs_disable_secondary_channels(struct cifs_ses *ses);
> +cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_reconfigure);
>  void
>  cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server);
>  int
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 43552b44f613..96e80c70f25d 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1015,6 +1015,22 @@ int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_se
>  	return 0;
>  }
>  
> +/**
> + * smb3_sync_ses_chan_max - Synchronize the session's maximum channel count
> + * @ses: pointer to the old CIFS session structure
> + * @max_channels: new maximum number of channels to allow
> + *
> + * Updates the session's chan_max field to the new value, protecting the update
> + * with the session's channel lock. This should be called whenever the maximum
> + * allowed channels for a session changes (e.g., after a remount or reconfigure).
> + */
> +void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels)
> +{
> +	spin_lock(&ses->chan_lock);
> +	ses->chan_max = max_channels;
> +	spin_unlock(&ses->chan_lock);
> +}
> +

The other writer of chan_max is when creating a session. Is this lock
really avoiding a race here?

>  static int smb3_reconfigure(struct fs_context *fc)
>  {
>  	struct smb3_fs_context *ctx = smb3_fc2context(fc);
> @@ -1097,6 +1113,18 @@ static int smb3_reconfigure(struct fs_context *fc)
>  		ses->password2 = new_password2;
>  	}
>  
> +	/*
> +	 * If multichannel or max_channels has changed, update the session's channels accordingly.
> +	 * This may add or remove channels to match the new configuration.
> +	 */
> +	if ((ctx->multichannel != cifs_sb->ctx->multichannel) ||
> +		(ctx->max_channels != cifs_sb->ctx->max_channels)) {
> +		//Synchronize ses->chan_max with the new mount context
> +		smb3_sync_ses_chan_max(ses, ctx->max_channels);
> +		//Now update the session's channels to match the new configuration
> +		rc = smb3_sync_ses_channels(cifs_sb);
> +	}
> +
>  	mutex_unlock(&ses->session_mutex);
>  
>  	STEAL_STRING(cifs_sb, ctx, domainname);
> @@ -1110,6 +1138,7 @@ static int smb3_reconfigure(struct fs_context *fc)
>  	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
>  	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
>  	smb3_update_mnt_flags(cifs_sb);
> +
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  	if (!rc)
>  		rc = dfs_cache_remount_fs(cifs_sb);
> diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> index b0fec6b9a23b..a75185858285 100644
> --- a/fs/smb/client/fs_context.h
> +++ b/fs/smb/client/fs_context.h
> @@ -371,7 +371,7 @@ static inline struct smb3_fs_context *smb3_fc2context(const struct fs_context *f
>  extern int smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx);
>  extern int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses);
>  extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
> -
> +extern void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels);
>  /*
>   * max deferred close timeout (jiffies) - 2^30
>   */
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index 0a8c2fcc9ded..42b5481c884a 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -264,13 +264,16 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
>  	return new_chan_count - old_chan_count;
>  }
>  
> -/*
> - * called when multichannel is disabled by the server.
> - * this always gets called from smb2_reconnect
> - * and cannot get called in parallel threads.
> +/**
> + * cifs_decrease_secondary_channels - Reduce the number of active secondary channels
> + * @ses: pointer to the CIFS session structure
> + * @from_reconfigure: if true, only reduce to chan_max; if false, reduce to a single channel
> + *
> + * This function disables and cleans up extra secondary channels for a CIFS session.
> + * If called during reconfiguration, it reduces the channel count to the new maximum (chan_max).
> + * Otherwise, it disables all but the primary channel.
>   */
> -void
> -cifs_disable_secondary_channels(struct cifs_ses *ses)
> +void cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_reconfigure)
>  {

Maybe you could get rid of from_reconfigure parameter if you just set
chan_max to 1 before calling cifs_decrease_secondary_channels when this
function is not called from smb3_reconfigure. What do you think?

>  	int i, chan_count;
>  	struct TCP_Server_Info *server;
> @@ -281,12 +284,13 @@ cifs_disable_secondary_channels(struct cifs_ses *ses)
>  	if (chan_count == 1)
>  		goto done;
>  
> -	ses->chan_count = 1;
> -
> -	/* for all secondary channels reset the need reconnect bit */
> -	ses->chans_need_reconnect &= 1;
> +	// Update the chan_count to the new maximum
> +	if (from_reconfigure)
> +		ses->chan_count = ses->chan_max;
> +	else
> +		ses->chan_count = 1;
>  
> -	for (i = 1; i < chan_count; i++) {
> +	for (i = ses->chan_max ; i < chan_count; i++) {
>  		iface = ses->chans[i].iface;
>  		server = ses->chans[i].server;
>  
> @@ -318,6 +322,15 @@ cifs_disable_secondary_channels(struct cifs_ses *ses)
>  		spin_lock(&ses->chan_lock);
>  	}
>  
> +	/* For extra secondary channels, reset the need reconnect bit */
> +	if (ses->chan_count == 1) {
> +		cifs_server_dbg(VFS, "server does not support multichannel anymore. Disable all other channels\n");
> +		ses->chans_need_reconnect &= 1;
> +	} else {
> +		cifs_server_dbg(VFS, "Disable extra secondary channels\n");
> +		ses->chans_need_reconnect &= ((1UL << ses->chan_max) - 1);
> +	}
> +
>  done:
>  	spin_unlock(&ses->chan_lock);
>  }
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index c3b9d3f6210f..bf9a8dc0e8fc 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -168,7 +168,7 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
>  static int
>  cifs_chan_skip_or_disable(struct cifs_ses *ses,
>  			  struct TCP_Server_Info *server,
> -			  bool from_reconnect)
> +			  bool from_reconnect, bool from_reconfigure)
>  {
>  	struct TCP_Server_Info *pserver;
>  	unsigned int chan_index;
> @@ -206,10 +206,49 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
>  		return -EHOSTDOWN;
>  	}
>  
> -	cifs_server_dbg(VFS,
> -		"server does not support multichannel anymore. Disable all other channels\n");
> -	cifs_disable_secondary_channels(ses);
> +	cifs_decrease_secondary_channels(ses, from_reconfigure);
>  
> +	return 0;
> +}
> +
> +/**
> + * smb3_sync_ses_channels - Synchronize session channels
> + * with new configuration (cifs_sb_info version)
> + * @cifs_sb: pointer to the CIFS superblock info structure
> + * Returns 0 on success or -EINVAL if scaling is already in progress.
> + */
> +int smb3_sync_ses_channels(struct cifs_sb_info *cifs_sb)
> +{
> +	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
> +	struct smb3_fs_context *ctx = cifs_sb->ctx;
> +	bool from_reconnect = false;
> +
> +	/* Prevent concurrent scaling operations */
> +	spin_lock(&ses->ses_lock);
> +	if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
> +		spin_unlock(&ses->ses_lock);
> +		return -EINVAL;
> +	}
> +	ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
> +	spin_unlock(&ses->ses_lock);
> +
> +	/*
> +	 * If the old max_channels is less than the new chan_max,
> +	 * try to add channels to reach the new maximum.
> +	 * Otherwise, disable or skip extra channels to match the new configuration.
> +	 */
> +	if (ctx->max_channels < ses->chan_max) {
> +		mutex_unlock(&ses->session_mutex);
> +		cifs_try_adding_channels(ses);
> +		mutex_lock(&ses->session_mutex);
> +	} else {

Maybe you can avoid entering any cifs_chan_skip_or_disable if
ctx->max_channels == ses->chan_max. There is a cost of holding locks
inside of it.

> +		cifs_chan_skip_or_disable(ses, ses->server, from_reconnect, true);
> +	}
> +
> +	/* Clear scaling flag after operation */
> +	spin_lock(&ses->ses_lock);
> +	ses->flags &= ~CIFS_SES_FLAG_SCALE_CHANNELS;
> +	spin_unlock(&ses->ses_lock);
>  
>  	return 0;
>  }
> @@ -356,7 +395,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
>  	if (ses->chan_count > 1 &&
>  	    !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
>  		rc = cifs_chan_skip_or_disable(ses, server,
> -					       from_reconnect);
> +					       from_reconnect, false);
>  		if (rc) {
>  			mutex_unlock(&ses->session_mutex);
>  			goto out;
> @@ -439,7 +478,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
>  			 */
>  
>  			rc = cifs_chan_skip_or_disable(ses, server,
> -						       from_reconnect);
> +						       from_reconnect, false);
>  			goto skip_add_channels;
>  		} else if (rc)
>  			cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
> @@ -1105,8 +1144,7 @@ SMB2_negotiate(const unsigned int xid,
>  		req->SecurityMode = 0;
>  
>  	req->Capabilities = cpu_to_le32(server->vals->req_capabilities);
> -	if (ses->chan_max > 1)
> -		req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
> +	req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
>  
>  	/* ClientGUID must be zero for SMB2.02 dialect */
>  	if (server->vals->protocol_id == SMB20_PROT_ID)
> @@ -1310,10 +1348,8 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>  	if (!pneg_inbuf)
>  		return -ENOMEM;
>  
> -	pneg_inbuf->Capabilities =
> -			cpu_to_le32(server->vals->req_capabilities);
> -	if (tcon->ses->chan_max > 1)
> -		pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
> +	pneg_inbuf->Capabilities = cpu_to_le32(server->vals->req_capabilities);
> +	pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
>  
>  	memcpy(pneg_inbuf->Guid, server->client_guid,
>  					SMB2_CLIENT_GUID_SIZE);
> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> index 3c09a58dfd07..d3f63a4ef426 100644
> --- a/fs/smb/client/smb2pdu.h
> +++ b/fs/smb/client/smb2pdu.h
> @@ -420,6 +420,8 @@ struct smb2_create_ea_ctx {
>  	struct smb2_file_full_ea_info ea;
>  } __packed;
>  
> +int smb3_sync_ses_channels(struct cifs_sb_info *cifs_sb);
> +
>  #define SMB2_WSL_XATTR_UID		"$LXUID"
>  #define SMB2_WSL_XATTR_GID		"$LXGID"
>  #define SMB2_WSL_XATTR_MODE		"$LXMOD"

I also agree with Enzo that we could have an update_channels that
centralizes the logic of rescaling channels, but that could also come in
another patch as Steve suggested.

-- 
Henrique
SUSE Labs
