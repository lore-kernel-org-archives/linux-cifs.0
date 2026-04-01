Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0623DD52B
	for <linux-cifs@vger.kernel.org>; Wed,  1 Apr 2026 13:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775050851; cv=none; b=ORqX1r1/X2IBS4JFDg78ukz8AfEi+FrmNLDG6lHPj1FdpQ3Ej97Z2h9q7jvVTZRs/nspcboNWs5sA5vrBZ/qKa9L2lgtaADYJ6NNSONwlAbgZHmgkQrNpPwTZKKPpAU6YYt95MGxTKF4Nt+dDbw6fpNXWv6ppgNfpNku9Prz5gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775050851; c=relaxed/simple;
	bh=ZV8U6ewtYHZMDAu4GLPtvTKE4+4rNSl2WfGpeC62M1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTegJcZTe2ihLyM9WqpiEUd3mWg8Om6fG5lHJRRoeZOHs44Q6nSEy3rhpptqqrGMkJQ9UoGD5yyvph04XkY2bxE71ku787IDsF1wVTrkrCjju8/becTnsEuvsOzz+qYPq8Od/7SGUDoX5wrH/5OYp9DVRkZPp419ZE64Jwpoh9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Dp64pFI2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tdrq8gyL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=G7HeTuFW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dxZl2zY9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Dp64pFI2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tdrq8gyL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="G7HeTuFW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dxZl2zY9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E23B04D7A3;
	Wed,  1 Apr 2026 13:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775050848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n+O3wpUubWWhIF69HYFHrTRMQCFJu+C3XY04pFLmghQ=;
	b=Dp64pFI26/r5lPyfpsKh3QzGChIpCl2jNTJsdPgrnWKe9EaRfQyKORE4aD7bbFy2WDCwJY
	Yvuh5ii2eNeewmS7/Bhbi2gBBGwLkX8SCpnbSZ1LQ1yzUazHXclV0zPnlMyzdqhLG/bIJd
	+/ABAnG2ekVLV1pHSTvhmLEdDxzkoqA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775050848;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n+O3wpUubWWhIF69HYFHrTRMQCFJu+C3XY04pFLmghQ=;
	b=tdrq8gyLGsMJFB6x2QNpkb4SwLHUP72PsgUANQ2HpGN0i+6xEtgwafxavkk9tQo4lyU5Ph
	YVztnQUHggCoUYAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=G7HeTuFW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dxZl2zY9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775050847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n+O3wpUubWWhIF69HYFHrTRMQCFJu+C3XY04pFLmghQ=;
	b=G7HeTuFW/M39S1x98yFjQbUxgoOerfqmUZABd4Oec+/+2krd0uZzukdPUsn+m8P9EtjFiK
	Yv2eLkQO912Gbh/IRmup6UXM0PA4cCN8hoydlR6+A30X6y5CDk54gss4NKnwQ1DgVpGYOJ
	KNMu32VmLuQZNNxGRzWgZob3cFNYsmc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775050847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n+O3wpUubWWhIF69HYFHrTRMQCFJu+C3XY04pFLmghQ=;
	b=dxZl2zY9sFnWNHaFpexEDAGQkkwYwFCSQx5RRbk9xAu9rYHSCyPQ/x4h5mAOxIrQM26Y10
	5QnMlOmNjocL0sCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6FC024A0B0;
	Wed,  1 Apr 2026 13:40:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YfAHDl8gzWlPUgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 01 Apr 2026 13:40:47 +0000
Date: Wed, 1 Apr 2026 10:40:41 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: David Disseldorp <ddiss@suse.de>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Bruno Bierbaumer <bruno@bierbaumer.net>
Subject: Re: [PATCH] mount.cifs: fix buffer overrun in set_password
Message-ID: <vuah4lb4wtxy3vhw4ywuacfto3dfxke7zldb4oiu3bcpjncrzv@ntdb7jyuzywi>
References: <20260331000911.16062-1-ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260331000911.16062-1-ddiss@suse.de>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,bierbaumer.net];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: E23B04D7A3
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

Hi Dave,

On 03/31, David Disseldorp wrote:
>The existing (j > pass_length) check is insufficient to avoid dst buffer
>overrun into the start of the adjacent struct parsed_mount_info field.
>Check for overrun before writing to dst, and account for comma-expansion
>and null-termination.
>
>Bug: https://bugzilla.samba.org/show_bug.cgi?id=16044
>
>Reported-by: Bruno Bierbaumer <bruno@bierbaumer.net>
>Signed-off-by: David Disseldorp <ddiss@suse.de>
>---
> mount.cifs.c | 8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>
>diff --git a/mount.cifs.c b/mount.cifs.c
>index 1923913..d41ca6a 100644
>--- a/mount.cifs.c
>+++ b/mount.cifs.c
>@@ -350,13 +350,13 @@ set_password(struct parsed_mount_info *parsed_info, const char *src,
> 	unsigned int i = 0, j = 0;
>
> 	while (src[i]) {
>-		if (src[i] == ',')
>-			dst[j++] = ',';
>-		dst[j++] = src[i++];
>-		if (j > pass_length) {
>+		if (j + 2 >= pass_length) {

There is the overrun bug, yes, but unconditionally accounting for comma
expansion here will crop the password if it has at least 1 comma and
(unparsed) length == MOUNT_PASSWD_SIZE, e.g.:

(password here is <511 * 'a'> + ',')

# echo -e "username=administrator\npassword=$(printf 'a%.0s' {1..511})," > /tmp/creds
# ./mount.cifs -o credentials=/tmp/creds //w25.vm.test/test /mnt/test
Converted password too long!
error 1 (Operation not permitted) opening credential file /tmp/creds


Maybe password/password2 could be malloc'd with size
"strlen(src) + <number of commas in src>" and bounds checked against that?
Just a thought.


Cheers,

Enzo
