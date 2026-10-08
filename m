Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EFE3A9612
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 18:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484252; cv=none; b=Yyr+jk4ZUdyhcrNaysHOzf9e2hKg/vKvwcLIw/n8J5d6+jd5KB3zZH6i4CmgZjuPITE4wJC+T2UA6k/Hr+/baD9lYm3GKG15TpX5paeqw3GIWx4pqi3JUlo/kN1gy7eoH84jCxcmbqj+9uyT5Yf7+Bso5tEYUXCqk7PTz5Yo/H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484252; c=relaxed/simple;
	bh=A6zjFdRKJeiNQA+zVfR4ae8Kef53a4LdlwQHfvKXRE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VLnBWk54wwN+EKmeJlO9NE2LLZKY91vCOdJ2087YoPBK8pPArMnMvxZBgAokuBolSTkYcU01rLBHoKE8qekGeejoVyb7OGeyY3Q26wC8hKLF/P6Z0IkEPfsSpsz3JYC5Uvrm0Ok9YdpGZlEHhTd3GYRworXu8YpsbiGG5qthBzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E68171F790;
	Thu,  8 Oct 2026 18:30:49 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52BC613354;
	Thu,  8 Oct 2026 18:30:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id i5ICNljhx2q2UAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 08 Oct 2026 18:30:49 +0000
Date: Thu, 8 Oct 2026 15:30:43 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, linkinjeon@kernel.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH v3 1/2] smb: client: fast fail sends if need to reconnect
Message-ID: <asfgaKGQrdX2fKTw@suse.de>
References: <20260929170358.270612-1-ematsumiya@suse.de>
 <4627cfd704304e43bed6825ae68699ad@manguebit.org>
 <asU7Jr6Q_PJuubBJ@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <asU7Jr6Q_PJuubBJ@suse.de>
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spamd-Result: default: False [0.00 / 50.00]
X-Spam-Score: 0.00

On 10/06, Enzo Matsumiya wrote:
>>Why are you removing the blank line?
>
>Probably just because I saw it.
>Not sure why it should stay there, but I'll drop it.

Sorry about this comment -- I thought this was about double blank lines
(which I unconsciously delete every time I see one).

I just sent v4 of this patch handling your concerns.

As we discussed, let's put patch 2 on hold for now, until we can get
a more concrete strategy to handle data corruption on reconnects
mid-writes.


Thanks!

Enzo
