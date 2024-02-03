Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA8E13AC2
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 22:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707000465; cv=none; b=CKYYx7giN+GlM3hOjs5LcdxXIH4tKCMHBPgNRcIFxuPEuYdpQl2aj9tyrQvzOI/yWOYEOpEHnzUUz2NMWcMsyWhALfDlAkJw2xPTBBxv8ARwV7dmFG2ZrHaLnZsxhD0Boo/BerTAC58FfKJsagLhjcqmD3ldQnGbDr244rG5LUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707000465; c=relaxed/simple;
	bh=0A73D9Vtm4xwYxTH+DvfpwjdaJKnTEEeRgHMkRFCZd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E9uqAmpv0ofqM57EJ9gKiLlzyZb5UwvkVodSt5L7d52QmJtD0QDZmdepAA4O/BhIgXoWewOlNIcu4xk9D1mugDU4VvuAPndv5P8dDIn45qam3gA81iSJva4IYqm4zqVb3xKynhysDIvYXhkLsHd35ow+x+Wz/XBN8SkzJObDCPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 49A4C22032;
	Sat,  3 Feb 2024 22:47:42 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BEB0E1338E;
	Sat,  3 Feb 2024 22:47:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oCSCII3CvmWPEQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Sat, 03 Feb 2024 22:47:41 +0000
Date: Sat, 3 Feb 2024 19:47:39 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: workqueue warning
Message-ID: <20240203224739.r3y6ga6pp7ifz4k3@suse.de>
References: <CAH2r5mueWCC5aa+7t=qOhDLDYTfYDa+8ku+0GOqFfaTHWPNQUA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mueWCC5aa+7t=qOhDLDYTfYDa+8ku+0GOqFfaTHWPNQUA@mail.gmail.com>
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	none
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	 REPLY(-4.00)[]
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 49A4C22032
X-Spam-Flag: NO

On 02/03, Steve French wrote:
>I saw the following warning about workqueues when running xfstests
>with multichannel to Windows server target (at test generic/048, which
>failed due to umount busy).  Any thoughts about whether WQ_UNBOUND
>would help?

Probably.  Unless the worker relies/desires(*) the advantages of CPU
locality, there's no reason to not use WQ_UNBOUND.

(*) I'm not aware of the details of deferred close, but a quick look
indicates it doesn't take any advantages nor depend on local CPU data.
Manually rotating CPUs with queue_work_on() would also prevent a single
CPU from starvation, but if doing it randomly, or without any specifc
goal, would have the same effect as using WQ_UNBOUND in the first place,
if not worse (probably).

On a related note, I've been playing with the idea of spreading
multichannel workloads across CPUs by "allocating" a CPU to each
channel (assuming the client has N CPUs and defines N max_channels
for best performance).

The results are promising, but are far from justifiable yet (from the
amount of modifications needed).

For a quick, unchecked fix, setting cifsiod_wq to WQ_UNBOUND too
seems beneficial, where on a multichannel setup, all cifsiod_wq work
will be ran on a single CPU, that can starve much faster than deferred
closes/lease breaks.


Cheers,

Enzo
