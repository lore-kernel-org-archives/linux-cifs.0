Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5A31B85DA
	for <linux-cifs@vger.kernel.org>; Fri,  6 Sep 2024 20:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725655002; cv=none; b=oKeGBlhq4jieLn+3F6K6Q+B8IRq6m/RlCe/T5s/qE0dnAmzL4MyLJkzudB5pEo6hgT7ZVFXyd3YE3XMlul61TliZ7WPrCIAv339N7TQ17r4usUdaT0WlQOxdcrTlS06F3ZUOTSfAPU8jPs3MI/HZ1Rftl8XwGRuAUTNVZGGpAOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725655002; c=relaxed/simple;
	bh=8JCz+98fU9x9W7S8EXr4cXnKJGDhTLDoOQjG7JU5OOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I7REGwSjUERQL7VvazS6sspUlymutIZCENomtmJv7fCbGUixrlXhQ6KR35xwwAZ8IldC5mcLWSpxJ4SNbHMAGJxVopIpX4UJJ27mIS2zRRT0Jh9Mp4ReHAbNTt8QQ0Daad6za8IS2B3j0X2UknWNCsaVhJjebMx9NjYl/keNNhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z4fj314F; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7oZ0DDqV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z4fj314F; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7oZ0DDqV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z4fj314F";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7oZ0DDqV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z4fj314F";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7oZ0DDqV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BE9ED2198A;
	Fri,  6 Sep 2024 20:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725654998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/PYMDwcljt9cH+cj0mv1eLSt1/3GfqNsWAIZlzUi3RA=;
	b=Z4fj314F1N0w7EctBlGZCL4PjBza7DqtSbPagX3AGIjmyaPNNuq4tV4V04Lws7oiO955Fr
	9/PzpTdyXcgFUCnf4K4HhstDQQX+6BPlDnvDZAPcCCtd9d83UHv3hHfyOlHKHd/yorPxJS
	AH85gTAEQ05NiU3+QvCOPB5U1PcZTuA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725654998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/PYMDwcljt9cH+cj0mv1eLSt1/3GfqNsWAIZlzUi3RA=;
	b=7oZ0DDqVXeM7gP4l6YSNKpuHz3m8clQerz4Qscki2pPwd7k2W90d0SZFLdqkdczd8TODHR
	/d967VuPVYlJp4DA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725654998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/PYMDwcljt9cH+cj0mv1eLSt1/3GfqNsWAIZlzUi3RA=;
	b=Z4fj314F1N0w7EctBlGZCL4PjBza7DqtSbPagX3AGIjmyaPNNuq4tV4V04Lws7oiO955Fr
	9/PzpTdyXcgFUCnf4K4HhstDQQX+6BPlDnvDZAPcCCtd9d83UHv3hHfyOlHKHd/yorPxJS
	AH85gTAEQ05NiU3+QvCOPB5U1PcZTuA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725654998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/PYMDwcljt9cH+cj0mv1eLSt1/3GfqNsWAIZlzUi3RA=;
	b=7oZ0DDqVXeM7gP4l6YSNKpuHz3m8clQerz4Qscki2pPwd7k2W90d0SZFLdqkdczd8TODHR
	/d967VuPVYlJp4DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 49B64136A8;
	Fri,  6 Sep 2024 20:36:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hwwbBdZn22Z3FQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 06 Sep 2024 20:36:38 +0000
Date: Fri, 6 Sep 2024 17:37:02 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Paulo Alcantara <pc@manguebit.com>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org, 
	Rickard Andersson <rickaran@axis.com>
Subject: Re: [PATCH] smb: client: fix hang in wait_for_response() for negproto
Message-ID: <ksvd6i2ohf72mqo4dcd7vwoxahuud3pes2pqygcvc2sfazzoox@zbjo3y3jnwqe>
References: <20240901014734.141366-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240901014734.141366-1-pc@manguebit.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,axis.com];
	RCPT_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Score: -3.80
X-Spam-Flag: NO

On 08/31, Paulo Alcantara wrote:
>Call cifs_reconnect() to wake up processes waiting on negotiate
>protocol to handle the case where server abruptly shut down and had no
>chance to properly close the socket.
>
>Simple reproducer:
>
>  ssh 192.168.2.100 pkill -STOP smbd
>  mount.cifs //192.168.2.100/test /mnt -o ... [never returns]
>
>Cc: Rickard Andersson <rickaran@axis.com>
>Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
>---
> fs/smb/client/connect.c | 14 +++++++++++++-
> 1 file changed, 13 insertions(+), 1 deletion(-)
>
>diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
>index c1c14274930a..e004b515e321 100644
>--- a/fs/smb/client/connect.c
>+++ b/fs/smb/client/connect.c
>@@ -656,6 +656,19 @@ allocate_buffers(struct TCP_Server_Info *server)
> static bool
> server_unresponsive(struct TCP_Server_Info *server)
> {
>+	/*
>+	 * If we're in the process of mounting a share or reconnecting a session
>+	 * and the server abruptly shut down (e.g. socket wasn't closed properly),
>+	 * wait for at least an echo interval (+7s from rcvtimeo) when attempting
>+	 * to negotiate protocol.
>+	 */
>+	spin_lock(&server->srv_lock);
>+	if (server->tcpStatus == CifsInNegotiate &&
>+	    time_after(jiffies, server->lstrp + server->echo_interval)) {
>+		spin_unlock(&server->srv_lock);
>+		cifs_reconnect(server, false);
>+		return true;
>+	}
> 	/*
> 	 * We need to wait 3 echo intervals to make sure we handle such
> 	 * situations right:
>@@ -667,7 +680,6 @@ server_unresponsive(struct TCP_Server_Info *server)
> 	 * 65s kernel_recvmsg times out, and we see that we haven't gotten
> 	 *     a response in >60s.
> 	 */
>-	spin_lock(&server->srv_lock);
> 	if ((server->tcpStatus == CifsGood ||
> 	    server->tcpStatus == CifsNeedNegotiate) &&
> 	    (!server->ops->can_echo || server->ops->can_echo(server)) &&

Maybe, for extra precaution, also worth adding a check in
smb2_reconnect() that could catch other cases:

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -278,6 +278,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
                         spin_unlock(&server->srv_lock);
                         return -EAGAIN;
                 }
+       } else if (server->tcpStatus == CifsInNegotiate) {
+               spin_unlock(&server->srv_lock);
+               return -EAGAIN;
         }

         /* if server is marked for termination, cifsd will cleanup */


FTR we hit this exact same bug a few months ago and fixed
downstream with the above check, combined with using
wait_event_timeout() in wait_for_response() (using @echo_interval
seconds as well for timeout).

Never sent upstream because it looked too much like a hack and the bug
was only reproducible on our v5.14-based kernel.

Anyway, HTH.


Cheers,

Enzo
