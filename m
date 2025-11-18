Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027C235F8A0
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763474417; cv=none; b=uhMrDdkIqkOx/7e28U3u7tLjT4zl5oQXrlgCdWte4Cg1iy3i4hNsSM7bRyryb1k2DdLY7eLJeEmWeXFCIsSqTpFibjQnOe2guoYQ++d9XneReNdvgzOI131W/ymaOpVlS2y8elPo0fClWDTd16EkYjWMVCWwfVBnJKxR14zblYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763474417; c=relaxed/simple;
	bh=w6RMaRifKqqhbxvAWpme/zNrXkZtOAgAESZaw2CWcB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jmXsBvXIqa0ykurgN3oT8TpCu91gSOMk9zFBLfCYnzb0SO/Wz99q9F2rUSaLQXpyjd9R20B61751p4NXcJPCHUTU5caD2osxb+HxfgpPMyO9Md+Kl3qXFK+nFmEkwS+U5dauK7Nyb9sc+/CLSHnxtw71yYxa1RSdpuQ3bizcXNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vT4nH4Aw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AdpLC7b+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=r6SNmXpA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=v7vjtKnT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vT4nH4Aw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AdpLC7b+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="r6SNmXpA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="v7vjtKnT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9E0581FED4;
	Tue, 18 Nov 2025 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763474411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9LNzrVKF5jk5aYcNsFQe1Iz6TiHOuNsHq+z0Dhmpgg=;
	b=vT4nH4AwIO3ydxsSwcbeRHbqZGd6QXog9Kkr72s8y9lRdJ+nW0jepRdy+jpk05qdCxO3xl
	KV1KebwXF5/Z6Lx/8RbrqmKm9zUBOcB6wDalgZTu//T3YDlWvxGfn9dXeQkVvEJndzHbcz
	P5lYUQvdvZjjIKH+HObxm22o3L+KTnM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763474411;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9LNzrVKF5jk5aYcNsFQe1Iz6TiHOuNsHq+z0Dhmpgg=;
	b=AdpLC7b+DDyRBww/PYZRXXX3tod3ly+e9hZjR64xkllvzO7Y4cQ+obvBxGsutO9sth7vQe
	YDQz8lNLCk6+qbCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r6SNmXpA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=v7vjtKnT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763474410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9LNzrVKF5jk5aYcNsFQe1Iz6TiHOuNsHq+z0Dhmpgg=;
	b=r6SNmXpALbCV7oe+A5lwAmnm1ZgDigt5z6r1s+cbkGyUlhZIWMDqxYlhV+QAybSnADev+A
	07ZQ2OCuvclBSM1AsGswW2GlTTP4VQcEKV164iSjw/Ndx9TpJQEaKAOps/w9kAw/XNhqNr
	ISqDge5vOPKEq7PLMnXXCh9+s8bbMx8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763474410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9LNzrVKF5jk5aYcNsFQe1Iz6TiHOuNsHq+z0Dhmpgg=;
	b=v7vjtKnTqcGmsLncWlTV5GGEwGUW7BjghecJcIiiEsqGkt2FTRresUjqL+yjzyQRbnPkow
	0aEQmUPsZuQIfdDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1EBE43EA61;
	Tue, 18 Nov 2025 14:00:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lQyzNel7HGmKZAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 18 Nov 2025 14:00:09 +0000
Date: Tue, 18 Nov 2025 11:00:07 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Rajasi Mandal <rajasimandalos@gmail.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: Re: [PATCH] cifs: client: enforce consistent handling of
 multichannel and max_channels
Message-ID: <7mc3cpg6qojvq7hak6jvkud7xgynmaki554tgn2jic2y52onzm@ugw7wsq43wsp>
References: <20251118022655.126994-1-rajasimandalos@gmail.com>
 <20251118022655.126994-2-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251118022655.126994-2-rajasimandalos@gmail.com>
X-Rspamd-Queue-Id: 9E0581FED4
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[samba.org,vger.kernel.org,manguebit.org,gmail.com,microsoft.com,talpey.com,lists.samba.org];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On 11/18, Rajasi Mandal wrote:
>From: Rajasi Mandal <rajasimandal@microsoft.com>
>
>Previously, the behavior of the multichannel and max_channels mount
>options was inconsistent and order-dependent. For example, specifying
>"multichannel,max_channels=1" would result in 2 channels, while
>"max_channels=1,multichannel" would result in 1 channel. Additionally,
>conflicting combinations such as "nomultichannel,max_channels=3" or
>"multichannel,max_channels=1" did not produce errors and could lead to
>unexpected channel counts.
>
>This commit introduces two new fields in smb3_fs_context to explicitly
>track whether multichannel and max_channels were specified during
>mount. The option parsing and validation logic is updated to ensure:
>- The outcome is no longer dependent on the order of options.
>- Conflicting combinations (e.g., "nomultichannel,max_channels=3" or
>  "multichannel,max_channels=1") are detected and result in an error.
>- The number of channels created is consistent with the specified
>  options.
>
>This improves the reliability and predictability of mount option
>handling for SMB3 multichannel support.
>
>Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
>Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>

It's conflicting because it's already too complex for something that
should've been simple.  This patch introduces a new field + unnecessary
logic on top if it all.

cf. a PoC patch I sent a while ago, we can (ab)use fsparam with same key
name, but different key types, so we could only deal with:

'nomultichannel', 'multichannel={0,1,off,no}' as multichannel disabled
'multichannel' as ctx->max_channels=2 (multichannel enabled, obviously)
'multichannel=X' as ctx->max_channels=X (ditto)

Makes 0 sense to have both multichannel and max_channels mount options.

>---
> fs/smb/client/cifsfs.c     |  1 -
> fs/smb/client/fs_context.c | 65 ++++++++++++++++++++++++++++----------
> fs/smb/client/fs_context.h |  2 ++
> 3 files changed, 50 insertions(+), 18 deletions(-)
>
>diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
>index 185ac41bd7e9..4d53ec53d8db 100644
>--- a/fs/smb/client/cifsfs.c
>+++ b/fs/smb/client/cifsfs.c
>@@ -1016,7 +1016,6 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
> 	} else {
> 		cifs_info("Attempting to mount %s\n", old_ctx->source);
> 	}
>-
> 	cifs_sb = kzalloc(sizeof(*cifs_sb), GFP_KERNEL);
> 	if (!cifs_sb)
> 		return ERR_PTR(-ENOMEM);
>diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
>index 46d1eaae62da..1794a31541fe 100644
>--- a/fs/smb/client/fs_context.c
>+++ b/fs/smb/client/fs_context.c
>@@ -711,6 +711,47 @@ smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
> 	return 0;
> }
>
>+static int smb3_handle_conflicting_options(struct fs_context *fc)
>+{
>+	struct smb3_fs_context *ctx = smb3_fc2context(fc);
>+
>+	if (ctx->multichannel_specified) {
>+		if (ctx->multichannel) {
>+			if (!ctx->max_channels_specified) {
>+				ctx->max_channels = 2;
>+			} else if (ctx->max_channels == 1) {
>+				cifs_errorf(fc,
>+					    "max_channels must be greater than 1 when multichannel is enabled\n");
>+				return -EINVAL;
>+			}
>+		} else {
>+			if (!ctx->max_channels_specified) {
>+				ctx->max_channels = 1;
>+			} else if (ctx->max_channels > 1) {
>+				cifs_errorf(fc,
>+					    "max_channels must be equal to 1 when multichannel is disabled\n");
>+				return -EINVAL;
>+			}
>+		}
>+	} else {
>+		if (ctx->max_channels_specified) {
>+			if (ctx->max_channels > 1)
>+				ctx->multichannel = true;
>+			else
>+				ctx->multichannel = false;
>+		} else {
>+			ctx->multichannel = false;
>+			ctx->max_channels = 1;
>+		}
>+	}
>+
>+	//resetting default values as remount doesn't initialize fs_context again

Please stick to /* ... */ comments style.

>+	ctx->multichannel_specified = false;
>+	ctx->max_channels_specified = false;
>+
>+	return 0;
>+}
>+
> static void smb3_fs_context_free(struct fs_context *fc);
> static int smb3_fs_context_parse_param(struct fs_context *fc,
> 				       struct fs_parameter *param);
>@@ -785,6 +826,7 @@ static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
> 		if (ret < 0)
> 			break;
> 	}
>+	ret = smb3_handle_conflicting_options(fc);
>
> 	return ret;
> }
>@@ -1296,15 +1338,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
> 		ctx->nodelete = 1;
> 		break;
> 	case Opt_multichannel:
>-		if (result.negated) {
>+		ctx->multichannel_specified = true;
>+		if (result.negated)
> 			ctx->multichannel = false;
>-			ctx->max_channels = 1;
>-		} else {
>+		else
> 			ctx->multichannel = true;
>-			/* if number of channels not specified, default to 2 */
>-			if (ctx->max_channels < 2)
>-				ctx->max_channels = 2;
>-		}
> 		break;
> 	case Opt_uid:
> 		ctx->linux_uid = result.uid;
>@@ -1440,15 +1478,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
> 		ctx->max_credits = result.uint_32;
> 		break;
> 	case Opt_max_channels:
>+		ctx->max_channels_specified = true;
> 		if (result.uint_32 < 1 || result.uint_32 > CIFS_MAX_CHANNELS) {
> 			cifs_errorf(fc, "%s: Invalid max_channels value, needs to be 1-%d\n",
> 				 __func__, CIFS_MAX_CHANNELS);
> 			goto cifs_parse_mount_err;
> 		}
> 		ctx->max_channels = result.uint_32;
>-		/* If more than one channel requested ... they want multichan */
>-		if (result.uint_32 > 1)
>-			ctx->multichannel = true;
> 		break;
> 	case Opt_max_cached_dirs:
> 		if (result.uint_32 < 1) {
>@@ -1866,13 +1902,6 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
> 		goto cifs_parse_mount_err;
> 	}
>
>-	/*
>-	 * Multichannel is not meaningful if max_channels is 1.
>-	 * Force multichannel to false to ensure consistent configuration.
>-	 */
>-	if (ctx->multichannel && ctx->max_channels == 1)
>-		ctx->multichannel = false;
>-
> 	return 0;
>
>  cifs_parse_mount_err:
>@@ -1955,6 +1984,8 @@ int smb3_init_fs_context(struct fs_context *fc)
>
> 	/* default to no multichannel (single server connection) */
> 	ctx->multichannel = false;
>+	ctx->multichannel_specified = false;
>+	ctx->max_channels_specified = false;
> 	ctx->max_channels = 1;
>
> 	ctx->backupuid_specified = false; /* no backup intent for a user */
>diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
>index b0fec6b9a23b..7af7cbbe4208 100644
>--- a/fs/smb/client/fs_context.h
>+++ b/fs/smb/client/fs_context.h
>@@ -294,6 +294,8 @@ struct smb3_fs_context {
> 	bool domainauto:1;
> 	bool rdma:1;
> 	bool multichannel:1;
>+	bool multichannel_specified:1; /* true if user specified multichannel or nomultichannel */
>+	bool max_channels_specified:1; /* true if user specified max_channels */
> 	bool use_client_guid:1;
> 	/* reuse existing guid for multichannel */
> 	u8 client_guid[SMB2_CLIENT_GUID_SIZE];
>-- 
>2.43.0

Cheers,

Enzo
