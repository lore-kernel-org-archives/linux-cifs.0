Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D532F8BDA
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 13:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760967155; cv=none; b=QzCopkwI8XdXreUlsnN0QowC0o2rzjrOkSx2xsksgLqABicuQY9Pq+UPO0cZskIanSTwu17yiSeojCIxDvJG89A7qph+tHa8iL0YAPLRyB4/yO3jUOnN/gXzivuTG4xNkkbPk3yI63Yn1afOJLXywmnK1XUtKU9oTMj02eXtOf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760967155; c=relaxed/simple;
	bh=y6boeZjebtX/+nJjvLu6q9uSq3vP76etrkB2o1FPnII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k4uwu7/fpF+4wGjn+AUoL9GKeR3a8H8fcu6uwsKAaxRA9csydTnJ4Gy5azxmx5svHDSOzpFLoMGTVG0ku2e1hJk56rnco9eAqaeCfTxkjTvQSoYLyZOQ056/K6L7FzE1YHP94qHAfUKNDkkx2xEZ8WxxZc+XtJ/FgK1sT+08N5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KOuftcyx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6DIuojql; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=d3RpGJk7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uC9HQ2XD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KOuftcyx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6DIuojql";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="d3RpGJk7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uC9HQ2XD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9EB5E211A7;
	Mon, 20 Oct 2025 13:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760967146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lct50XtsIE03/eWleldlT3vV36AXyNXI/51Yr1oyyk8=;
	b=KOuftcyx/dAPxXn4uNPKRpIU6FtFZa8lcBIV/vxUgDPBOnpsLa6mlqriHEMvGqsqHs9f8p
	x4+T7LY/ulIqdL+56f3Kfq+5UwaPXcSvbCtzV4DLmpMOlx80t7w4PZDp5RxNeJdglZMJ9a
	akSAKhzU8PlNOIB1r3SAOtRBkE8M8kA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760967146;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lct50XtsIE03/eWleldlT3vV36AXyNXI/51Yr1oyyk8=;
	b=6DIuojqlKuhmW/sk0awS7Hf0YsFldno5Qb9bCgnwkoC9CTQ4nHtkjd2ZOLd80Kx3L7iNkN
	b20Sx5z0bGDTZhDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760967142; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lct50XtsIE03/eWleldlT3vV36AXyNXI/51Yr1oyyk8=;
	b=d3RpGJk72FmabxAtJ3XIJrmkhempoJRfceFtU5kOW6UJQX2nCc6nKXb4ELx/Yg9a5Cn8RQ
	DgmuWYJCKy1OQ0AzRWkYLt5FXiJ/GXrDAKZs+Q1KPfoX0QOzg5UwJvtIGGARATIjRnFqJI
	i46o6Q/RhzGyrkWxsShFWzkKPE0tHwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760967142;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lct50XtsIE03/eWleldlT3vV36AXyNXI/51Yr1oyyk8=;
	b=uC9HQ2XDhnckSNGLttD3TNK0amkXTULIFbrMPxAgLoXD3GPxfSFsHIdZCyW+i6Oh5QL7wS
	mXKy1eaMozlHl4AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B59713AAC;
	Mon, 20 Oct 2025 13:32:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MErhOOU59mgCbAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 20 Oct 2025 13:32:21 +0000
Date: Mon, 20 Oct 2025 10:32:19 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix TCP_Server_Info::credits to be signed
Message-ID: <vmbhu5djhw2fovzwpa6dptuthwocmjc5oh6vsi4aolodstmqix@4jv64tzfe3qp>
References: <1006942.1760950016@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1006942.1760950016@warthog.procyon.org.uk>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,samba.org:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80

Hi David,

On 10/20, David Howells wrote:
>Fix TCP_Server_Info::credits to be signed, just as echo_credits and
>oplock_credits are.  This also fixes what ought to get at least a
>compilation warning if not an outright error in *get_credits_field() as a
>pointer to the unsigned server->credits field is passed back as a pointer
>to a signed int.

Both semantically and technically, credits shouldn't go negative.
Shouldn't those other fields/functions become unsigned instead?


Cheers,

Enzo

>Signed-off-by: David Howells <dhowells@redhat.com>
>cc: Steve French <sfrench@samba.org>
>cc: Paulo Alcantara <pc@manguebit.org>
>cc: linux-cifs@vger.kernel.org
>---
> fs/smb/client/cifsglob.h |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
>index 8f6f567d7474..b91397dbb6aa 100644
>--- a/fs/smb/client/cifsglob.h
>+++ b/fs/smb/client/cifsglob.h
>@@ -740,7 +740,7 @@ struct TCP_Server_Info {
> 	bool nosharesock;
> 	bool tcp_nodelay;
> 	bool terminate;
>-	unsigned int credits;  /* send no more requests at once */
>+	int credits;  /* send no more requests at once */
> 	unsigned int max_credits; /* can override large 32000 default at mnt */
> 	unsigned int in_flight;  /* number of requests on the wire to server */
> 	unsigned int max_in_flight; /* max number of requests that were on wire */
>
>
