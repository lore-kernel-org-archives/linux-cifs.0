Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1878B4418D9
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 14:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768918401; cv=none; b=pj7JeqKMajxysWInS7hke6UqYfdlsE45OLz3F6GBBrtGlQOQyoIsNlaQ40GFaeK8tJ8RdcITtsm9U4WlUqlMS832xgABg0hfQVo//ZAPhOTJEC0cdszlVkXVVlhm0eKVP2jvo1a05UiAWZ6X71foSJtpNgSMXnd4y5yuC6TRidg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768918401; c=relaxed/simple;
	bh=1barDntHWr955DPKo7h1w6dJSd2uglhVezxCYv6rDNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z3q4Ps3HZkWXDgH6HWd9O/XI3EA89SO/TFV9Bf+MhU0pNDOsab/3HWlxS32fnmY4N8qlAM3/fzUdh3DkiJeq70BjPJddc621wOwZ0I/V/bfXEVHA0zHG4i45vFMA/YqjZUXsuxAmLyx52FUtMBrbg+Td3DvaqM9bgKx2HhWplMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fjCSltE7; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fjCSltE7"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47ee301a06aso51046275e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 06:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768918397; x=1769523197; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xvB4FNxXmFE90bXlbaqeLF81xzyHl5CCjmWT93asNzY=;
        b=fjCSltE7dO+jAH9J0DbX1wJAq0QsQkZ5LsFAbHgG2Sjkq79I4KFA+oRiq3XglQs3Ph
         BloT56nTKPnU8aGzXMZZSj+5HnhQux2iaSGaRQa/Q/hBtu+OM0yDufTLQe7KjSJIcEyf
         Pvg/tskOMZQAlASHGDTKy2MX4eSoXL6/2v+YwpPIWnA7Eo7wZDaREcRjvQqLdEYf2eKf
         P3scuXIbureQp49vKBzM5yNYA/do1XGoakL9iIkjN8QLV80cfNERj0ZAgVs8oAer1dP7
         NnaPHSNfmxIZ+LNngNzIqkbVk81FJzhMF8XnzdMahfv0KFfTsI1QKGckEfJi4z9WEZdn
         XYKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768918397; x=1769523197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvB4FNxXmFE90bXlbaqeLF81xzyHl5CCjmWT93asNzY=;
        b=mLAHB5QR/1OfDBhQiPJK9+G+hJjUG37OsatIm2/IMO4G/1+dWmYy8GToek78esFSZE
         D+cNe3/bUu05MMSQeua2AzbClt7lCcUwZKgKgjeKVn7au1xObwF+zjcO0llE9tM76AHc
         G3vc7aXINAs8HUlXZ8Akbs7LH7msJ1SxPckyI7Hk3E5ETJz3OPYXMoncISo0uvriQgsz
         rUwZzdJ4Je05DkJWBLtl1CvgfDpMaHufOPouxQtOn1DLA1Fs+KOB/Br/jMjiskhEuxKJ
         HPps9IsNPbeDRUtRQb6yRElbba4V/L59214bVNiL3jhBTygPLxMTCIjSz7yUbASgDWTV
         /8ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWj17oDslU8PCmVzlRGW/4ONYSjokfsWtAleP3aDVqPN75NDW+BgedbkBeYDiga2bQZA/rbKW+A2YdD@vger.kernel.org
X-Gm-Message-State: AOJu0YybnzV3Pyp53h6lwWocywTcJWpUxAVAGRTW1QQCExpBHuca1p1o
	20EXKhF3sfa3j+L5tfyV+hO3VqhOWLE3WrU4SwSU6YP/L+nTzDY952ED4rzhe1xgY0Y=
X-Gm-Gg: AY/fxX4oV/YRP5Xr3MfP4GIQnGsPkkIrZTYkmkQ3qTuX+tyspXjGLWzrYv8k8HRt57I
	26KlKB4CBHQI7nk+qL7mdlDo1dqEcggo8ZjCu1rNmEEYG/0ygTmLYtAhe3eybDeq/JzSc03trvX
	hogUagjEAecg32wLRRp8ubsr/l0WU2EECMaev4trAfDrRHT3tcP2QCOU0Tzic0n4Qp4s8y++3Pw
	+ooKtEPhM5QVPZozPSO7qCXKZoZNnrQ/cePbjgH9B/DbwDpTPiEnI5JZvfVhXOyxsEy1CobhMiu
	9jWwuCOrNGASQliTPpEctH0NbD2WS/b+UQzgqmTKFhBvSXy6VLlurFmBMZOrIPSO3W8+nTLV+DP
	6mT8Fy4VUU8hKpcviLunTqb3Pgfe9h4mWS9lCKLdMNjs96aJUvU5L1ppo0YmP5pstFw5blHpfrA
	ANcXt/Cv/LwWR6Xh/E
X-Received: by 2002:a05:600c:3f06:b0:475:dde5:d91b with SMTP id 5b1f17b1804b1-4801eb0359amr195117725e9.17.1768918397245;
        Tue, 20 Jan 2026 06:13:17 -0800 (PST)
Received: from precision ([177.115.49.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6fb72e477sm2659777eec.29.2026.01.20.06.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 06:13:16 -0800 (PST)
Date: Tue, 20 Jan 2026 11:13:11 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, ematsumiya@suse.de, 
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] smb: client: introduce multichannel async work
 during mount
Message-ID: <eqzvsoomaa7wtsv5zwnelaziv3dlb7oxggc4cw2gn4nj4mwosv@h27txgrld4et>
References: <20260116220641.322213-1-henrique.carvalho@suse.com>
 <CANT5p=r5+Fw6g-gyA25pw1pX_FCXtnxw2qUG8bt4iTNQnyrxUw@mail.gmail.com>
 <CANT5p=oLDiauPjeOV-4FNxB-oiu+_p5r=AbrK7V--kOZBcAncA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANT5p=oLDiauPjeOV-4FNxB-oiu+_p5r=AbrK7V--kOZBcAncA@mail.gmail.com>

Hi Shyam,

On Tue, Jan 20, 2026 at 09:01:00AM +0530, Shyam Prasad N wrote:
> 
> Hi Henrique,
> 
> I reviewed this once more. Now that the adding channel logic is async
> I'm concerned that there maybe a possible race with adding a channel
> to ses->chans array before it is fully ready.
> Earlier this would not be a problem since channel additions were
> synchronous. Now that it is async, we want to make sure that the
> channel is fully set up before it is added to this array.
> We do not want cifs_pick_channel to pick a channel that is still not
> fully initialized. Can you please look into this aspect?
>

I think we are safe here.

In cifs_pick_channel, we iterate over the channel indexes, from 0 to
ses->chan_count - 1 and we pick only the good channels, meaning channels
not set to terminate or !CIFS_CHAN_NEEDS_RECONNECT -- all this guarded
by chan_lock:

	spin_lock(&ses->chan_lock);
	start = atomic_inc_return(&ses->chan_seq);
	for (i = 0; i < ses->chan_count; i++) {
		cur = (start + i) % ses->chan_count;
		server = ses->chans[cur].server;
		if (!server || server->terminate)
			continue;

		if (CIFS_CHAN_NEEDS_RECONNECT(ses, cur))
			continue;

So in order to reach a channel we have to increment ses->chan_count and
set the chan as not needing reconnect.

Channel addition is done by cifs_ses_add_channel inside
cifs_try_adding_channels. Inside cifs_ses_add_channel, ses->chan_count
is incremented in the following code

	spin_lock(&ses->chan_lock);
	chan = &ses->chans[ses->chan_count];
	chan->server = chan_server;
	if (IS_ERR(chan->server)) {
		rc = PTR_ERR(chan->server);
		chan->server = NULL;
		spin_unlock(&ses->chan_lock);
		goto out;
	}
	chan->iface = iface;
	ses->chan_count++;
	atomic_set(&ses->chan_seq, 0);

	/* Mark this channel as needing connect/setup */
	cifs_chan_set_need_reconnect(ses, chan->server);

	spin_unlock(&ses->chan_lock);

Notice the channel is marked as needing connect/setup and that is only
unset inside cifs_setup_session when the setup is successful.

	} else {
		spin_lock(&ses->ses_lock);
		if (ses->ses_status == SES_IN_SETUP)
			ses->ses_status = SES_GOOD;
		spin_lock(&ses->chan_lock);
		cifs_chan_clear_in_reconnect(ses, server);
		cifs_chan_clear_need_reconnect(ses, server);
		spin_unlock(&ses->chan_lock);
		spin_unlock(&ses->ses_lock);
	}

Now, I've noticed more than one issue in cifs_pick_channel...

First, we seem to allow channels in reconnect to be picked, which is
wrong. Second, we don't check if start is actually a good channel when
we round robin. Do you agree?

But these *are not* related to this patch and should be addressed in a
different patch. If you agree I will create a fix for it.
