Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC172DB785
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 16:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773246237; cv=none; b=gJqUCACv3XoKWS8NqKGkfvFe9SnJnqNSf0QNXJm4uLqLj9KpIHEq8Yva6gr61g/EbOMI/LIp7g6o1vOUsxtO+kZMx164//P4f6fNS5livtyNfzk4dZ+TTLv4unzChjzYnmlqzfUq+SBNCrjVW3EmYfndapnghI9KRWiWK3w/e0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773246237; c=relaxed/simple;
	bh=2H/yVnJJmAxhJ83CwNFTepUshz1imEhuQ2X8EbbDV0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SWz6idtX/oZd+UTxQdapro3+A8fm1eZJLSlgvePdA1cqBpY/HlmQIzejdEK9kGxyXgAUhy265f8sFFS3TbMnFYF5LozMqyECpi4ZvlrahRnrXkA1NMwjmNuK5+ZvIMRRkp2dpOInVb9AMJI1wMQdSdm4D4XO8itsGLaiRVZuzxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dyjC/4C3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=haUAA8fR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dyjC/4C3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=haUAA8fR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dyjC/4C3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="haUAA8fR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dyjC/4C3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="haUAA8fR"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4ED0E4D375;
	Wed, 11 Mar 2026 16:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773246233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jpFWJn2jtjJa9SzAY4Nhl8AZlJoMwz2ud25Vt0MFAAk=;
	b=dyjC/4C3CoyixGNi0SBbKhzg1hWHcM0i5KWQp6FuwaB6U811r8+orTiyfVu2wOsGAz/cLd
	J9jYn1vYIdroILuCzawRcrgdCV/Z2Rh8h77eMiL75Fc3YinicbL2lpryQvp4mFuKnGmTpM
	EWm/pOYa36cPHu9THJJAkZaGM5JzxjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773246233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jpFWJn2jtjJa9SzAY4Nhl8AZlJoMwz2ud25Vt0MFAAk=;
	b=haUAA8fRiLaGcewVVS4/3y8JccZgu7l0RG7y5AyrKiwfaGGzGtWZSSARGsOem4PgFxj9rl
	fcWGodUrtUZDgABg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773246233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jpFWJn2jtjJa9SzAY4Nhl8AZlJoMwz2ud25Vt0MFAAk=;
	b=dyjC/4C3CoyixGNi0SBbKhzg1hWHcM0i5KWQp6FuwaB6U811r8+orTiyfVu2wOsGAz/cLd
	J9jYn1vYIdroILuCzawRcrgdCV/Z2Rh8h77eMiL75Fc3YinicbL2lpryQvp4mFuKnGmTpM
	EWm/pOYa36cPHu9THJJAkZaGM5JzxjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773246233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jpFWJn2jtjJa9SzAY4Nhl8AZlJoMwz2ud25Vt0MFAAk=;
	b=haUAA8fRiLaGcewVVS4/3y8JccZgu7l0RG7y5AyrKiwfaGGzGtWZSSARGsOem4PgFxj9rl
	fcWGodUrtUZDgABg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C846B3FAE8;
	Wed, 11 Mar 2026 16:23:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WJs2IxiXsWlTFQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 11 Mar 2026 16:23:52 +0000
Date: Wed, 11 Mar 2026 13:23:50 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: preserve destination port when parsing
 server interfaces
Message-ID: <oahcuvsmgnhuzmsgssbpmu3glg2fdzm3efk2xi3xitdaifksg2@pjd6c5tiolkl>
References: <20260311160856.635916-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260311160856.635916-1-henrique.carvalho@suse.com>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[samba.org,manguebit.org,gmail.com,microsoft.com,talpey.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Flag: NO

On 03/11, Henrique Carvalho wrote:
>parse_server_interfaces() initializes interface socket addresses with
>CIFS_PORT. When the mount uses a non-default port this overwrites the
>configured destination port.
>
>Later, cifs_chan_update_iface() copies this sockaddr into server->dstaddr,
>causing reconnect attempts to use the wrong port after server interface
>updates.
>
>Use the existing port from server->dstaddr instead.
>
>Cc: stable@vger.kernel.org
>Fixes: c1846893991f ("cifs: update dstaddr whenever channel iface is updated")
>Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>---
> fs/smb/client/smb2ops.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
>
>diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>index 7f2d3459cbf9..d3cbfb3fdfc9 100644
>--- a/fs/smb/client/smb2ops.c
>+++ b/fs/smb/client/smb2ops.c
>@@ -628,6 +628,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
> 	struct smb_sockaddr_in6 *p6;
> 	struct cifs_server_iface *info = NULL, *iface = NULL, *niface = NULL;
> 	struct cifs_server_iface tmp_iface;
>+	__be16 port;
> 	ssize_t bytes_left;
> 	size_t next = 0;
> 	int nb_iface = 0;
>@@ -676,18 +677,20 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
> 		 * conversion explicit in case either one changes.
> 		 */
> 		case INTERNETWORK:
>+			port = ((struct sockaddr_in *)&ses->server->dstaddr)->sin_port;
> 			addr4 = (struct sockaddr_in *)&tmp_iface.sockaddr;
> 			p4 = (struct smb_sockaddr_in *)p->Buffer;
> 			addr4->sin_family = AF_INET;
> 			memcpy(&addr4->sin_addr, &p4->IPv4Address, 4);
>
> 			/* [MS-SMB2] 2.2.32.5.1.1 Clients MUST ignore these */
>-			addr4->sin_port = cpu_to_be16(CIFS_PORT);
>+			addr4->sin_port = port;
>
> 			cifs_dbg(FYI, "%s: ipv4 %pI4\n", __func__,
> 				 &addr4->sin_addr);
> 			break;
> 		case INTERNETWORKV6:
>+			port = ((struct sockaddr_in6 *)&ses->server->dstaddr)->sin6_port;
> 			addr6 =	(struct sockaddr_in6 *)&tmp_iface.sockaddr;
> 			p6 = (struct smb_sockaddr_in6 *)p->Buffer;
> 			addr6->sin6_family = AF_INET6;
>@@ -696,7 +699,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
> 			/* [MS-SMB2] 2.2.32.5.1.2 Clients MUST ignore these */
> 			addr6->sin6_flowinfo = 0;
> 			addr6->sin6_scope_id = 0;
>-			addr6->sin6_port = cpu_to_be16(CIFS_PORT);
>+			addr6->sin6_port = port;
>
> 			cifs_dbg(FYI, "%s: ipv6 %pI6\n", __func__,
> 				 &addr6->sin6_addr);

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
