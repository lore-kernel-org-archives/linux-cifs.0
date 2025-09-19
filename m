Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9467222A4EB
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 18:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758308151; cv=none; b=lH0dKfhYM3eCMHvL6ZEMDIYjh9/T30aSgXJW5FNCqZFpV1vt1802H43J9qIRJQ/aJpBiHIiV3AvnOqwG4zp+hAYGyDKyN4ZZx/OdytIfViJg8ok4HdIdtHHtjQqMTlx5bd/I8POGEnpXgy1eeDZFPzv4MF+PPRIs+MoWQflM73Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758308151; c=relaxed/simple;
	bh=Tji27guUkHZgflwpd0BKsBQqHVEeNuopg8rpqb8nTNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dDoY2vnj4yaX1GzAwq+z7wTS4CP638KG03IcoywB+Efn10e95FzXIkHA1bnFF5keusd18UtmzjXISRlpehzw7ascGH4Ix0dFT8TcTCi/FFTWEhuT6hvs9/se2RI4mslhhCTvjFQOYyMqdtNnSlrfH2Z9DKb/dJHI2z6SFkj61rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=C/9ledO4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VRtFoe8X; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=C/9ledO4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VRtFoe8X; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="C/9ledO4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VRtFoe8X";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="C/9ledO4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VRtFoe8X"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 873BF1F7CB;
	Fri, 19 Sep 2025 18:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758308146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1X/AxW3l67plcU/QzNiUMnueEgHk4dKLtY6qTQymuJU=;
	b=C/9ledO4ZrPqW9Gnspzar7wzxHVfxP3qW48881bnMsxRpucA2DKMX77ICQ6HDg/texJmxw
	IN3OvgWj8uSC99uOu3fOEhoSes3w+vO9WBZpiNYJybojK1Ul7fW9IH0uZpLthXIYDuclzB
	3qfRCQiKJdWe31xOFP897TYj3aPkSZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758308146;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1X/AxW3l67plcU/QzNiUMnueEgHk4dKLtY6qTQymuJU=;
	b=VRtFoe8XjDOIy/gu/vgPS+695u1nzvQJkEhRFeGYWUNyV0+PrKiaYLYKnru0vufalZ1nWC
	ji28TOlsE9Lx+/DA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758308146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1X/AxW3l67plcU/QzNiUMnueEgHk4dKLtY6qTQymuJU=;
	b=C/9ledO4ZrPqW9Gnspzar7wzxHVfxP3qW48881bnMsxRpucA2DKMX77ICQ6HDg/texJmxw
	IN3OvgWj8uSC99uOu3fOEhoSes3w+vO9WBZpiNYJybojK1Ul7fW9IH0uZpLthXIYDuclzB
	3qfRCQiKJdWe31xOFP897TYj3aPkSZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758308146;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1X/AxW3l67plcU/QzNiUMnueEgHk4dKLtY6qTQymuJU=;
	b=VRtFoe8XjDOIy/gu/vgPS+695u1nzvQJkEhRFeGYWUNyV0+PrKiaYLYKnru0vufalZ1nWC
	ji28TOlsE9Lx+/DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 14FC513A78;
	Fri, 19 Sep 2025 18:55:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id phadMzGnzWg+fAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 19 Sep 2025 18:55:45 +0000
Date: Fri, 19 Sep 2025 15:55:35 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH 5/6] smb: client: remove pointless cfid->has_lease check
Message-ID: <woexc5yya6d6idhmkasx2hwppdcydldhsdb4rhr4a7rj24tk66@exwhhyxh5ojj>
References: <20250919152441.228774-1-henrique.carvalho@suse.com>
 <20250919152441.228774-5-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250919152441.228774-5-henrique.carvalho@suse.com>
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
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80

On 09/19, Henrique Carvalho wrote:
>open_cached_dir() will only return a valid cfid, which has both
>has_lease = true and time != 0.
>
>Remove the pointless check of cfid->has_lease right after
>open_cached_dir() returns no error.
>
>Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>---
> fs/smb/client/smb2ops.c | 5 +----
> 1 file changed, 1 insertion(+), 4 deletions(-)
>
>diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>index 94b1d7a395d5..e6077e76047a 100644
>--- a/fs/smb/client/smb2ops.c
>+++ b/fs/smb/client/smb2ops.c
>@@ -954,11 +954,8 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
>
> 	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cfid);
> 	if (!rc) {
>-		if (cfid->has_lease) {
>-			close_cached_dir(cfid);
>-			return 0;
>-		}
> 		close_cached_dir(cfid);
>+		return 0;
> 	}
>
> 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
>-- 
>2.50.1

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
