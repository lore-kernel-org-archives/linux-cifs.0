Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18D93112DC
	for <linux-cifs@vger.kernel.org>; Mon, 22 Sep 2025 18:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758567159; cv=none; b=SdmuBNAOQrYTvqYI0PdI6F8pBsmmF6H2CQJBx/f17yh+tNxHQdIQoFQZGJOHRQn5x0kKFAWQcd1WTkhflosNWiGOigwmb4G0cEOURE1JhWPFCXKfIR2pOOqbGd1QIbVgdUvCZ9FjuXOzC8I5aeMyDIegskGfqs2p6qA9OVIxCAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758567159; c=relaxed/simple;
	bh=Zdpldsom9bOtqZerA5Njc/yNlXifusbBIKIr3wV4eoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YryA9W+lYXXyEUWD561VZuqDe7KtfAbZ6PoMvfhjIfPqSh1JbLT6IJi987Bh1pGCO2k03mXK50uzqoBKEKo+di32QGF370kx3mH/huGUOFzVREcSoEhr1h7CCOAQVyjLbmJRp+5uymoiCykR+0DeGKbMt0rxUvRWlHEK+DD4CzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=t/qEswtN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=i9ROUaIx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=t/qEswtN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=i9ROUaIx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="t/qEswtN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="i9ROUaIx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="t/qEswtN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="i9ROUaIx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C7D9F33682;
	Mon, 22 Sep 2025 18:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758567154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uOEd+KM3IMYvWo1eE95rp6+9G3pn0buEqnuk3zzFeaU=;
	b=t/qEswtNPno+qZdXKePeL7juke2Sz+zo5qi1HMyoWs8Kl7Ql81qRs/L/ermbMU/bJ7EPQ9
	xvdtFGtS1XcZCapGD4Szvr5t2GORYmcC0gd/j5uFeYz2cddO24+AXKa8dd8luNwSVULxe6
	LWshpRD5HAihKBSa5rLfNIhTmzdFwPg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758567154;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uOEd+KM3IMYvWo1eE95rp6+9G3pn0buEqnuk3zzFeaU=;
	b=i9ROUaIxP7C25w/wLu9U9VVKZfbToGDE1JgqdVw9vH+s9fYcr0guVbhayg9fHCwVzkTn5p
	y92y43hhbx2bIkBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758567154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uOEd+KM3IMYvWo1eE95rp6+9G3pn0buEqnuk3zzFeaU=;
	b=t/qEswtNPno+qZdXKePeL7juke2Sz+zo5qi1HMyoWs8Kl7Ql81qRs/L/ermbMU/bJ7EPQ9
	xvdtFGtS1XcZCapGD4Szvr5t2GORYmcC0gd/j5uFeYz2cddO24+AXKa8dd8luNwSVULxe6
	LWshpRD5HAihKBSa5rLfNIhTmzdFwPg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758567154;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uOEd+KM3IMYvWo1eE95rp6+9G3pn0buEqnuk3zzFeaU=;
	b=i9ROUaIxP7C25w/wLu9U9VVKZfbToGDE1JgqdVw9vH+s9fYcr0guVbhayg9fHCwVzkTn5p
	y92y43hhbx2bIkBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C9551388C;
	Mon, 22 Sep 2025 18:52:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E1AwAvKa0WjjYAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 22 Sep 2025 18:52:34 +0000
Date: Mon, 22 Sep 2025 15:52:23 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Steve French <smfrench@gmail.com>, rajasimandalos@gmail.com, 
	linux-cifs@vger.kernel.org, sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
Subject: Re: [PATCH 1/2] cifs: client: force multichannel=off when
 max_channels=1
Message-ID: <byjdlepkzmhm6j4ap5eyzdcusl7dgq3iuhkduf3s5h4mrayj32@lzwe2rksc4ei>
References: <20250922082417.816331-1-rajasimandalos@gmail.com>
 <da3e2b5a-a5da-4526-9884-8789990ebf95@suse.com>
 <qmf3xwqq4hqj4issgci2g76eghytaqxihnrp236ithh2istkkf@n4s54vp3hblr>
 <CAH2r5mu9xUQz5e1Mf-dBCNh2_y2jnxPYMhmuHr1bVqKC6atd8w@mail.gmail.com>
 <75a60a40-a6fe-40f5-9d6a-aa9ff8cbfa3c@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <75a60a40-a6fe-40f5-9d6a-aa9ff8cbfa3c@suse.com>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,samba.org,manguebit.org,microsoft.com,talpey.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -3.80

On 09/22, Henrique Carvalho wrote:
>
>
>On 9/22/25 1:14 PM, Steve French wrote:
>> . >Do we even need ->multichannel flag at all?
>>
>> Yes - especially in the future.   The goal is for the user to have
>> three options:
>> 1) (preferred) "multichannel" (max channels will be dynamically
>> selected and can change) the client gets to choose how many channels
>> to connect to based on what it sees in the output of the most recent
>> query interfaces call (it can change on the fly as server dynamically
>> adds and removes channels or networks become temporarily unreachable)
>
>I'm guessing this would be required while we are transitioning from
>setting channels dynamically to having multichannel on by default, as
>you commented below. Because once we have it on by default, I don't
>think there is a point in having the flag.

Exactly.

>> 2) "max_channels="   This is for the case where user wants to choose
>> the number of channels rather than have the client automatically
>> (hopefully soon in the future) choose it for you
>> 3) if server has mchan bugs, allow client to mount with no
>> multichannel (or equivalent max_channels=1)
>>
>> But ... "remount" also has to work for the three above (and currently
>> doesn't) and this is what I am hoping the recent patches can fix (?)
>> but haven't tested them enough yet

I was talking more in the context of code, that it could use some
refactoring/improvements -- I also think such functionality (hence the
patches) are necessary.

There's no sense for me, as a user, to specify e.g.:
   # mount.cifs -o ...,multichannel,max_channels=2 ...

Was there only a single option for this, it would be less confusing and
wouldn't require this patch here.


The below patch (PoC) is an idea I had that would make things much
clearer for users -- have 'multipath' mount option be either a flag or a
value option, e.g.:

   # mount.cifs -o ...,multichannel //srv/share /mnt/test
   # findmnt -t cifs -u | grep -Eo 'max_channels=[0-9]+'
   max_channels=2
   # umount /mnt/test
   # mount.cifs -o ...,multichannel=4 //srv/share /mnt/test
   # findmnt -t cifs -u | grep -Eo 'max_channels=[0-9]+'
   max_channels=4


Cheers,

Enzo

---------------------

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dd12f3eb61dc..ad9a588c7103 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2487,7 +2487,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
  	spin_lock(&ses->chan_lock);
  	ses->chans[0].server = server;
  	ses->chan_count = 1;
-	ses->chan_max = ctx->multichannel ? ctx->max_channels:1;
+	ses->chan_max = ctx->max_channels;
  	ses->chans_need_reconnect = 1;
  	spin_unlock(&ses->chan_lock);
  
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 072383899e81..ceb19a58b743 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -165,7 +165,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
  	fsparam_u32("max_cached_dirs", Opt_max_cached_dirs),
  	fsparam_u32("handletimeout", Opt_handletimeout),
  	fsparam_u64("snapshot", Opt_snapshot),
-	fsparam_u32("max_channels", Opt_max_channels),
+	fsparam_u32("multichannel", Opt_multichannel),
  
  	/* Mount options which take string value */
  	fsparam_string("source", Opt_source),
@@ -1252,14 +1252,16 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
  		ctx->nodelete = 1;
  		break;
  	case Opt_multichannel:
-		if (result.negated) {
-			ctx->multichannel = false;
-			ctx->max_channels = 1;
-		} else {
-			ctx->multichannel = true;
-			/* if number of channels not specified, default to 2 */
-			if (ctx->max_channels < 2)
+		if (param->type == fs_value_is_flag) {
+			if (!result.negated && ctx->max_channels < 2)
  				ctx->max_channels = 2;
+		} else {
+			if (result.uint_32 < 1 || result.uint_32 > CIFS_MAX_CHANNELS) {
+				cifs_errorf(fc, "%s: Invalid max_channels value, needs to be 1-%d\n",
+					 __func__, CIFS_MAX_CHANNELS);
+				goto cifs_parse_mount_err;
+			}
+			ctx->max_channels = result.uint_32;
  		}
  		break;
  	case Opt_uid:
@@ -1395,17 +1397,6 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
  		}
  		ctx->max_credits = result.uint_32;
  		break;
-	case Opt_max_channels:
-		if (result.uint_32 < 1 || result.uint_32 > CIFS_MAX_CHANNELS) {
-			cifs_errorf(fc, "%s: Invalid max_channels value, needs to be 1-%d\n",
-				 __func__, CIFS_MAX_CHANNELS);
-			goto cifs_parse_mount_err;
-		}
-		ctx->max_channels = result.uint_32;
-		/* If more than one channel requested ... they want multichan */
-		if (result.uint_32 > 1)
-			ctx->multichannel = true;
-		break;
  	case Opt_max_cached_dirs:
  		if (result.uint_32 < 1) {
  			cifs_errorf(fc, "%s: Invalid max_cached_dirs, needs to be 1 or more\n",
@@ -1901,7 +1892,6 @@ int smb3_init_fs_context(struct fs_context *fc)
  	ctx->echo_interval = SMB_ECHO_INTERVAL_DEFAULT;
  
  	/* default to no multichannel (single server connection) */
-	ctx->multichannel = false;
  	ctx->max_channels = 1;
  
  	ctx->backupuid_specified = false; /* no backup intent for a user */
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index b0fec6b9a23b..ff75a7cc11dd 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -175,7 +175,6 @@ enum cifs_param {
  	Opt_max_credits,
  	Opt_max_cached_dirs,
  	Opt_snapshot,
-	Opt_max_channels,
  	Opt_handletimeout,
  
  	/* Mount options which take string value */
@@ -293,7 +292,6 @@ struct smb3_fs_context {
  	bool resilient:1; /* noresilient not required since not fored for CA */
  	bool domainauto:1;
  	bool rdma:1;
-	bool multichannel:1;
  	bool use_client_guid:1;
  	/* reuse existing guid for multichannel */
  	u8 client_guid[SMB2_CLIENT_GUID_SIZE];

