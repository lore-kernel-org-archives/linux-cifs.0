Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DBF33A6FE
	for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 12:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772109101; cv=none; b=MgIk0gCA6ukAHNUzujTXOrFHPviLbfZCRTzXa0Wen+hmVrD22aFzWHTlDZRh18NK9MuTdB4R8GXzwi1f3+U/0oPY6bgzdSeIotMKLPtnBXCARPTE8vnMwe4VritLM+ThaKE/2XaxjOlRocy1ipFw8evP2PcZ5q1quGNskN6KiDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772109101; c=relaxed/simple;
	bh=us/q1RDViyzj/F4CyBPVPq1Fwz0rlHfX/F699/ScVQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S4pD925UOEuJWnO3Q+1rtFr4G0+DyZ9Xhz2m0Xpn39ecHh8541tbghsp1KmYoJ/b1O6oFCcbH86D/D/uNK06tDLgaYw1OLtML5gNCjGtObuuIuQjzJ9pgsq0XMvSZ309KYxYuEOb2EFT3FL7n5TOVIMY2dM2qYnQDC/1BVH4mJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x1i6vEoB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=truZqS6N; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LoGPjSK6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1DJWkqOo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x1i6vEoB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="truZqS6N";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LoGPjSK6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1DJWkqOo"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 042651FAA3;
	Thu, 26 Feb 2026 12:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772109098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NBwbGG5AyB2z5PcXm+vXp1ffGB46knF446xqVrER7t0=;
	b=x1i6vEoB/b4ydlC1MBY7ZODAF8gnP5ltSms5+kNKbUca5o8qkEskktWFiG0Sl1wxxZY8i+
	5arhNhHh+bkGhqoSm/L76OUrZC4joNm+BzsRIdcTkEyyvO+yUc3pn6dIw0y+7nCqPWhV16
	VaFCdWajp8V7Pu3TWIEkvHGaGa/GFxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772109098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NBwbGG5AyB2z5PcXm+vXp1ffGB46knF446xqVrER7t0=;
	b=truZqS6NmYfeTYTL3wtj1su5re3+qtwl+HFMII2X2CDQWoFO5+ZMjqK+n3tb2scTeCxRb6
	RpoEyAfqkEZL8XAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LoGPjSK6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1DJWkqOo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772109097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NBwbGG5AyB2z5PcXm+vXp1ffGB46knF446xqVrER7t0=;
	b=LoGPjSK6yHLPl2pjcdVp4411NbZQYAx8ZoR4a23QRKHXeGrvIIt3+zTrdbNYkqZKmilScE
	m+zfpg2m2+gUdWroqvfSUfANBhCPhob66erNaV918CtNPgtYggofZE2h5qZD+r9RuW0Fmo
	EW2WyQcb2OCTy/2cMPwnTLNt8rekldI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772109097;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NBwbGG5AyB2z5PcXm+vXp1ffGB46knF446xqVrER7t0=;
	b=1DJWkqOo2BcpOm08NiTG0gHEWYdHWYmYiSLrStTBHrZiRVSdeBvpqdDQ54TvVX9RPZ+8E5
	tljIUQVOckClEnCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D81E3EA62;
	Thu, 26 Feb 2026 12:31:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CcSjECg9oGnmHAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 26 Feb 2026 12:31:36 +0000
Date: Thu, 26 Feb 2026 09:31:26 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Paulo Alcantara <pc@manguebit.org>
Cc: smfrench@gmail.com, Xiaoli Feng <xifeng@redhat.com>, 
	David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix broken multichannel with krb5+signing
Message-ID: <57bbf5n3fk5ua6taezigjtzxgdprxxowzf4ahhsz6x6vfb5s4p@mrf7wayhf4ss>
References: <20260226003455.1699030-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260226003455.1699030-1-pc@manguebit.org>
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
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[manguebit.org:email,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 042651FAA3
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On 02/25, Paulo Alcantara wrote:
>When mounting a share with 'multichannel,max_channels=n,sec=krb5i',
>the client was duplicating signing key for all secondary channels,
>thus making the server fail all commands sent from secondary channels
>due to bad signatures.
>
>Every channel has its own signing key, so when establishing a new
>channel with krb5 auth, make sure to use the new session key as the
>derived key to generate channel's signing key in SMB2_auth_kerberos().
>
>Repro:
>
>$ mount.cifs //srv/share /mnt -o multichannel,max_channels=4,sec=krb5i
>$ sleep 5
>$ umount /mnt
>$ dmesg
>  ...
>  CIFS: VFS: sign fail cmd 0x5 message id 0x2
>  CIFS: VFS: \\srv SMB signature verification returned error = -13
>  CIFS: VFS: sign fail cmd 0x5 message id 0x2
>  CIFS: VFS: \\srv SMB signature verification returned error = -13
>  CIFS: VFS: sign fail cmd 0x4 message id 0x2
>  CIFS: VFS: \\srv SMB signature verification returned error = -13
>
>Reported-by: Xiaoli Feng <xifeng@redhat.com>
>Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>Cc: David Howells <dhowells@redhat.com>
>Cc: linux-cifs@vger.kernel.org
>---
> fs/smb/client/smb2pdu.c | 22 ++++++++++------------
> 1 file changed, 10 insertions(+), 12 deletions(-)
>
>diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
>index a2a96d817717..04e361ed2356 100644
>--- a/fs/smb/client/smb2pdu.c
>+++ b/fs/smb/client/smb2pdu.c
>@@ -1714,19 +1714,17 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
> 	is_binding = (ses->ses_status == SES_GOOD);
> 	spin_unlock(&ses->ses_lock);
>
>-	/* keep session key if binding */
>-	if (!is_binding) {
>-		kfree_sensitive(ses->auth_key.response);
>-		ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
>-						 GFP_KERNEL);
>-		if (!ses->auth_key.response) {
>-			cifs_dbg(VFS, "Kerberos can't allocate (%u bytes) memory\n",
>-				 msg->sesskey_len);
>-			rc = -ENOMEM;
>-			goto out_put_spnego_key;
>-		}
>-		ses->auth_key.len = msg->sesskey_len;
>+	kfree_sensitive(ses->auth_key.response);
>+	ses->auth_key.response = kmemdup(msg->data,
>+					 msg->sesskey_len,
>+					 GFP_KERNEL);
>+	if (!ses->auth_key.response) {
>+		cifs_dbg(VFS, "%s: can't allocate (%u bytes) memory\n",
>+			 __func__, msg->sesskey_len);
>+		rc = -ENOMEM;
>+		goto out_put_spnego_key;
> 	}
>+	ses->auth_key.len = msg->sesskey_len;
>
> 	sess_data->iov[1].iov_base = msg->data + msg->sesskey_len;
> 	sess_data->iov[1].iov_len = msg->secblob_len;

You can drop the same check for SessionId/Flags right below, as
the server is expected to return the same values for those for
multichannel.

(which then means 'is_binding' can be dropped altogether).

Either way,

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
