Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B484231F9A6
	for <linux-cifs@vger.kernel.org>; Wed, 25 Mar 2026 20:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774471497; cv=none; b=GywnKcfSPIfd5Qvu2aQDVAJRYMcydccER+SgKU8AGVKD3XUNs/M6MTqpDwb+1AmNq5455iLnU5w7J4KwB04QtzOeiB0Tgw0t+DguPKPTaKV28X50gZj4pRBg2E2+f1QRBGcHQZQCdKhYJU96xJxdysiiEpiT0OgxKz8x2zPwY2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774471497; c=relaxed/simple;
	bh=LpH/J1JfFHLnWjnEDaspQFQJkbGPXFlaD8MN3FsSDZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q8kRc4bUpLylbnf5ezgrgS+qAHfS9P4wXe0AzElxrnXOy+wbXo4odplLTlQp/T9LEukBWRXPDBJtyGZUqJ5vUY8v/zThkk5ncvXlQ652P8Obgs/Vclte0rXUY2gISczZgucskat0b9DD4wxV7tHajBgXV+ksRZjDMGxSL4/Z2pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Dzkbzkwm; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Dzkbzkwm"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso2812425e9.3
        for <linux-cifs@vger.kernel.org>; Wed, 25 Mar 2026 13:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774471494; x=1775076294; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SeJPO+oykn143/zdV+Uq6qD6BcvlKesTxvZjTLlsSJ4=;
        b=DzkbzkwmFcyZRWjnOFCfjc/paLDl0+Dy2NMscaWI8AJqS+DU/TYV53dhbuHsl1DOph
         ejYpiySv/V6IgZmROo9KQ14G+oeYn78hzLs1wYcGlNFqHpnSwXst2k+c7VFHDP+9YH8+
         fydHTsFaCTEQsGaY6161fjgNZ088wP0KHkPVABKmmGMQ31OP+BzmR/ChkuLKdaKOl48R
         l9fYo3t2nwvjFclxJv20IRuU4D7q1nHdcyijSi/19qI/OpybBFqQrcg7uDEuMme+kNhy
         Jr8LmrF4ahE8DYd/9fn0DvSld/KxGbUjk7JEz+Yp7fnWPzvG5YqZUWO2zhammx4qwwkh
         AVPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774471494; x=1775076294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SeJPO+oykn143/zdV+Uq6qD6BcvlKesTxvZjTLlsSJ4=;
        b=bNvJepipn4X9Q/xmpPzPdshClYkbzgusTT33YUaUVW0+GBB/1XR93IXuFNgKGb9Own
         gNeMH8jrMILTHrlwRxHvLUSMUbnul5XtI81s1oUWBtzekHtsNZYUrxPCfNUPSXRrWCWu
         E8KiJIhtrUoAj+7tKhkCX68Gf0RbJwTVSmvbe7j9g5u/MSLCHQtrPnKfKsAqbq1AIQyp
         1PE+JUM7pvx8UgJu+SV7b4e9/TqN+xxoxIexdD3GBSqPqoY94qi0TI2DaJbG4cJ16TLs
         Bz2ANZM8PH/pcq7sCITdmTLtPcxgw/eV/JgT2D+vjPftzu0HlNY1Mm1mzeQoULMXIwkL
         IWkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAPtYnVgbJSmwzak0vqQb2M9Uz6Y821u3grskx8DyreKM3w8ZjzNCR2TawXrkqh0NJpfV+pIvQ3bW5@vger.kernel.org
X-Gm-Message-State: AOJu0YxsGCu6wwO5be48MdZuuPYqG9z9+HEQvaMM8/tvJltvxIG7e/iR
	oD/GQU2wsKk+HGNhlegTXeMGG84qWMA8gjGjncWuANLypYIQK9XFzi9/13cLi6FIJY/Fpuqh06V
	3Vbm3ZD4=
X-Gm-Gg: ATEYQzw6zFMuNyni+fjAEEQNk5+eIVbfJVIaCQL9YCBj+F0mc58YgmRZ0La7QVZT0ER
	mDhtiODRv1/cD+66IQnF2Ud6VUF6GuyDKzRWGZhY1zu+2khN/xBRYLN8hNCncP4lg4xfzT76q/R
	j0tx5igkEi8pvSduleTPqwkVKP+WFNxYSsw6KEi1/2i00E6jumHvVXC7j1ajSdZgLXreeM8PkMR
	sl8mF0HCoRlfiqUFxEVc9LlnWK6fU3tXjiSXwZ4eiy+fsRULLnLL75/tZKIQz/I2fJNK/LtVBzZ
	U3U7l/k6eB8eN4XHAX2tl2TeWFXFlkATzzk2WKbdWPc5ZIKhzFczJLXTN37388VTyBGi/goYIJi
	NPIdyIH8dPrfk9Em3lD6KQmd1LdVHfBrp7mqzBXbOR5H9g7PdFxiPP+hlZQoO+jYt2qFlek4XlV
	lx3m1CYUt9kycHfGJWeMWJVTvR/4l+j0qoIAww7h8qoKwNy24Kuz5/A58=
X-Received: by 2002:a05:600c:3b16:b0:485:45fb:3472 with SMTP id 5b1f17b1804b1-48715fc3a88mr74017555e9.7.1774471493916;
        Wed, 25 Mar 2026 13:44:53 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6403:713c:9121:1883:a667:fd76])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-604d50677f0sm1028751137.1.2026.03.25.13.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 13:44:53 -0700 (PDT)
Date: Wed, 25 Mar 2026 17:44:47 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	linux-cifs@vger.kernel.org
Subject: Re: cifs_ses_add_channel() can race with itself
Message-ID: <rw7ptbx22cntes5eag5r3kvg5mzfvvzdhj4v2kw6mnunmsewev@f2iyrmmitkl3>
References: <122437.1774444814@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <122437.1774444814@warthog.procyon.org.uk>

Hi David,

On Wed, Mar 25, 2026 at 01:20:14PM +0000, David Howells wrote:
> Hi Steve,
> 
> Whilst running xfstests against cifs, I managed to encounter what I think must
> be due to a race between cifs_ses_add_channel() and itself - presumably by
> concurrent mount type things that share a session.
> 
> SO what I saw was this:
> 
>     BUG: kernel NULL pointer dereference, address: 0000000000000358
>     ...
>     RIP: 0010:cifs_alloc_hash+0x5/0xd0
>     ...
>     RSP: 0018:ffff88814eb4bdb0 EFLAGS: 00010246
>     RAX: 0000000000000000 RBX: ffff888148804800 RCX: 0000000000000000
>     RDX: 0000000000000000 RSI: 0000000000000358 RDI: ffffffff82c66915
>     RBP: ffff88810ad52000 R08: 0000000000000000 R09: ffff88840fa1bea0
>     R10: 0000000000000006 R11: 00000000000002eb R12: ffff8881488048a0
>     R13: 000000000015681b R14: ffff888148786c00 R15: ffff888148804860
>     FS:  0000000000000000(0000) GS:ffff88848be03000(0000) knlGS:0000000000000000
>     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     CR2: 0000000000000358 CR3: 0000000002e3a002 CR4: 00000000001706f0
>     Call Trace:
>      <TASK>
>      cifs_ses_add_channel+0x39b/0x530
>      cifs_try_adding_channels+0x201/0x2e0
>      mchan_mount_work_fn+0x1d/0x30
>      process_one_work+0x189/0x2b0
>      process_scheduled_works+0x3a/0x50
>      worker_thread+0x13b/0x1d0
> 
> Now, the RIP location corresponds to the deref of *sdesc in cifs_alloc_hash(),
> so sdesc (which is 0x358 in RSI) must be based on a NULL pointer.  Looking at
> cifs_ses_add_channel(), this corresponds to an inlined call to
> smb3_crypto_shash_allocate().  0x358 matches server->secmech.aes_cmac if
> server is NULL:
> 
> 	(gdb) p &((struct TCP_Server_Info *)0)->secmech.aes_cmac
> 	$2 = (struct shash_desc **) 0x358
> 
> Looking further at cifs_ses_add_channel(), that means chan->server must be
> NULL - but that would seem unlikely, given:
> 
> 	chan_server = cifs_get_tcp_session(ctx, ses->server);
> 
> a few lines above:
> 
> 	rc = smb3_crypto_shash_allocate(chan->server);
> 
> chan_server got checked for error, but not NULLness, though it doesn't look
> like it could be NULL.
> 
> However, I note that there's no locking that spans the two lines.  The first
> happens under ses->chan_lock and the second under ses->session_mutex, but
> there's nothing to stop another cifs_ses_add_channel() jumping in in the
> meantime and zapping chan->server as there's a gap, be it ever so small, where
> no lock is held.
> 

Do you happen to be doing remount?

A possibility here is chan->server gets NULL'd after leaving the
spin_lock and before it reaches smb3_crypto_shash_allocate().

This could happen (a) in the put session path, which I'm assuming cannot
happen because we hold a ref to the session, or (b) in the channel
*removal* path rather than inside another cifs_ses_add_channel().

In particular, inside cifs_chan_skip_or_disable(), which gets called if
ses->chan_count > ses->chan_max.

This condition can happen if ses->chan_max gets overwritten by a lower
max. One place that does lower ses->chan_max is smb3_reconfigure(),
which updates ses->chan_max and then calls channel scaling/shrinking.

-- 
Henrique
SUSE Labs

