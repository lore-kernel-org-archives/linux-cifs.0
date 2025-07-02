Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D952DE717
	for <linux-cifs@vger.kernel.org>; Wed,  2 Jul 2025 20:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751488315; cv=none; b=evrbPszTil6cKUZH2etBzDwt0TL9Yq2st6cL5Y+hS2HMkmcwa9wHIBbmA8PUERoaxtcEmoZdiP7iB+/06NBUfAMrlK+1dFyhezglIGG1rMnRAIATKi5Eg8zs55QOUcUaOu6bpsAcjZhN0qLT2IEKvQfzgncpmq8giLMGAgOEhcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751488315; c=relaxed/simple;
	bh=237TL+ryPGJl23OB4Is73Sai5h42wfZp9Qq3/mTb6dM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iaKntg6JNmeDijFXdTZCEWX+Nrqef0YLd+EPKP8IJqqXw4ilUarsShrxnckjHoMEjv5Rn+v/gHlJ/TjqmyGiBwi+37e1Xtf2XITvZvcIv1B0oNGjfdBawp8WDqHlwTFsVDTIbffIhuxpU5zi/n3U5IjuH/7H3jyJDIuDOqz4NVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=H+99Q/+j; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hZdaoXNn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=H+99Q/+j; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hZdaoXNn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="H+99Q/+j";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hZdaoXNn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="H+99Q/+j";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hZdaoXNn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 21AED1F795;
	Wed,  2 Jul 2025 20:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751488311; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xiHevdhchj/AULvFHyjRkq2CO/s4smgEW5cFdS/4b9Y=;
	b=H+99Q/+jgaQbtbBlR+ref9SXL4cgHutBMyxGRc/4mTlUdbeA51wzrRVQKYLwvU1IAhI5Vw
	T1KNpbeGMZxCFk+zqvz0VGQR3bRP9bAijzkrPBe+tajCs/A/6NmyYCxV8kckD62tZAVCkH
	64YLZ7JUg+giEvdJsy02JFBBhfsje5s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751488311;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xiHevdhchj/AULvFHyjRkq2CO/s4smgEW5cFdS/4b9Y=;
	b=hZdaoXNn9bUlti+kAPRpANhhF41xq5T7cb9S7H03AYtzk2dP5mHETV9VHwrUXPXUhNPcHJ
	457PdOn86VPx8VDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="H+99Q/+j";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hZdaoXNn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751488311; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xiHevdhchj/AULvFHyjRkq2CO/s4smgEW5cFdS/4b9Y=;
	b=H+99Q/+jgaQbtbBlR+ref9SXL4cgHutBMyxGRc/4mTlUdbeA51wzrRVQKYLwvU1IAhI5Vw
	T1KNpbeGMZxCFk+zqvz0VGQR3bRP9bAijzkrPBe+tajCs/A/6NmyYCxV8kckD62tZAVCkH
	64YLZ7JUg+giEvdJsy02JFBBhfsje5s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751488311;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xiHevdhchj/AULvFHyjRkq2CO/s4smgEW5cFdS/4b9Y=;
	b=hZdaoXNn9bUlti+kAPRpANhhF41xq5T7cb9S7H03AYtzk2dP5mHETV9VHwrUXPXUhNPcHJ
	457PdOn86VPx8VDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A12EC13A24;
	Wed,  2 Jul 2025 20:31:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9ZwGGjaXZWhfMAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 02 Jul 2025 20:31:50 +0000
Date: Wed, 2 Jul 2025 17:31:44 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org, 
	smfrench@gmail.com, pc@manguebit.com, sprasad@microsoft.com, paul@darkrain42.org, 
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 2/2] smb: invalidate and close cached directory when
 creating child entries
Message-ID: <6cgznwvt25gpa2h4oxiefz2t6hrzdvhxi2ywqd6deje7bfjnws@tuzdojjvyflf>
References: <20250630185303.12087-1-bharathsm@microsoft.com>
 <aGVkk8LT_RSwElO1@precision>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aGVkk8LT_RSwElO1@precision>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,manguebit.com,microsoft.com,darkrain42.org];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.com:email]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 21AED1F795
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -2.51

On 07/02, Henrique Carvalho wrote:
>Hi Bharath,
>
>On Tue, Jul 01, 2025 at 12:23:03AM +0530, Bharath SM wrote:
>> @@ -190,6 +190,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
>>  	int disposition;
>>  	struct TCP_Server_Info *server = tcon->ses->server;
>>  	struct cifs_open_parms oparms;
>> +	struct cached_fid *parent_cfid = NULL;
>>  	int rdwr_for_fscache = 0;
>>  	__le32 lease_flags = 0;
>>
>> @@ -313,10 +314,10 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
>>  	if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
>>  		create_options |= CREATE_OPTION_READONLY;
>>
>> +
>>  retry_open:
>>  	if (tcon->cfids && direntry->d_parent && server->dialect >= SMB30_PROT_ID) {
>> -		struct cached_fid *parent_cfid;
>> -
>> +		parent_cfid = NULL;
>
>I believe setting to NULL here is unnecessary, no?

It's for the cases it loops back to retry_open.

>>  		spin_lock(&tcon->cfids->cfid_list_lock);
>>  		list_for_each_entry(parent_cfid, &tcon->cfids->entries, entry) {
>>  			if (parent_cfid->dentry == direntry->d_parent) {
>> @@ -327,6 +328,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
>>  					memcpy(fid->parent_lease_key,
>>  					       parent_cfid->fid.lease_key,
>>  					       SMB2_LEASE_KEY_SIZE);
>> +					parent_cfid->dirents.is_valid = false;
>
>Shouldn't we set dirents.is_valid to false only after the open is
>successful?

Agreed.  Even though the most common failure cases will trigger a
reconnect anyway (i.e. cache invalidation), it makes sense to keep the
cache for the other cases.

Also, open_cached_dir_by_dentry() gets a cfid ref, why not use it and
have ->has_lease and ->time checked on success?  It would also look
cleaner.

Also 2: ->dirents should be accessed locked with its mutex, otherwise
there's a risk of race with cifs_readdir() and potentially UAF on the
close_cached_dir() below.

>>  				}
>>  				break;
>>  			}
>> @@ -355,6 +357,10 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
>>  		}
>>  		goto out;
>>  	}
>> +
>> +	if (parent_cfid && !parent_cfid->dirents.is_valid)
>> +		close_cached_dir(parent_cfid);
>> +
>>  	if (rdwr_for_fscache == 2)
>>  		cifs_invalidate_cache(inode, FSCACHE_INVAL_DIO_WRITE);
>>
>
>Apart from the above,
>
>Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>


Cheers,

Enzo
