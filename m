Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3D71F5858
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 20:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746217334; cv=none; b=i4XsAimNiS6uNwhUh7h/tPzREIlUSRviUJlbPN2k+vhKoiXCOlpdiywHf96OERznpmQsB26TRC7yQlH/RizVxORdDJ0CxUNpAe/znEGaArLEXFzAWXM6TlSsDSKT23ufiJkbonioegPFGtK4Jue/JGgpHc5iLk1DC6bx8B16AEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746217334; c=relaxed/simple;
	bh=TB3U09ptL25dNqSq5fJAdpQFS0Z/432PxIZVLB3JtUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QlkSX6N9mSp+dNdmacLmVIvr/eJqK6tGXl8BYwOQxZQXRQly8dktBZxrCMMNOZYOdpUNu88BkDWMiUcSiq+JKzXPwiIMinJxFy7hdwXs2j5gtn0xOYP68IPHabf0fANYOvm45fKP8hfGgHBD/o7WKcEcBV2DGTv+pEpuIwiKlCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dAiY6+dU; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dAiY6+dU"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-acb39c45b4eso374468566b.1
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 13:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746217330; x=1746822130; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PCcy97+iT9vE9daQ1axKMhkv8iMGC4N4gyyNBZ2YR2I=;
        b=dAiY6+dUcpgwgAEIJDmsZbGOPWT4/e0tSeA6IGrPJd1psYvlzCZukKHnwpryLwuLig
         wXkR3FFagUGb9on5y9C0JF1dNi747wERHKoOJtEw6cBV7dpjQ9sgXLqRuLxmmH665AwU
         PiC5iE2C0ZmW0l/ux3Wei/Y5wtRiEw7VHGfTnl6q0WqXyGaEbBnWm3IlxCq99CMiq8MG
         YyWUr1Z1aQb9qYFZ49KLl1yltD9I5gaoXG+JVjVc5bJjwe03tK2BHRgyQ/o+KhsV5x9Y
         2DIQn8XXaYVb2b9QaILEIO5ZVRoGm9i4MLic7PxEfYgt4I+VB+BcAlHZDT0ZYpsokNCh
         VtoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746217330; x=1746822130;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCcy97+iT9vE9daQ1axKMhkv8iMGC4N4gyyNBZ2YR2I=;
        b=WDf2OFXhyGhyyxXb5AytwcriOLzgP2JDbhpdxA69tKXsI026WjJVsXHlsDi/RAo2F1
         iQ0Abk7XDFLH6ppWWF7z1OD5r2ZhEq1AriPRsNrWm4Gcs8nmFN9LbY2O945O7IOCATs1
         t6Zg5BtjD7EwT5XLXaiQx9MS/SbI4Pir1EFIuYWVp2WTmX296+Zh7jgGQ/3qK2G7/UQa
         mDHS9H8YJOwmXs3+X7xbRgR3V+gAaxbHmjwQHy264BTSPM+7ZHxvBPbC2hYje61P1xAi
         OkH4xI8M/knVlUuR5j3EzHNFeWMrnnfcWMiR//4ez+oOJzVU71FgdwCN58u2TEkbcWri
         s1KA==
X-Forwarded-Encrypted: i=1; AJvYcCXZpmDwE4UpFfk4rwGCfERNHMUr/RmnhYyy98JQ4YuQ8Qkck3KRzeqFvdzFbofk6eRuVTfSBJiv4RDb@vger.kernel.org
X-Gm-Message-State: AOJu0YyuMk7ODPjpqx6z6ewpw2KJSNVMRtV8hmGjFkFxY8FOJ7LGS8jH
	h3T2nzDYXkdbakzTdzZss10QtniGU0ZhKuqB7sKCUAIzqZvDhdc4N5X2Sz0+R2o=
X-Gm-Gg: ASbGnctJr5Aicc562oKg0wtDuaEIIc1B7Fn3J3dNIIR7oSdgMY/UuEe4iiA4NnLztZ4
	4P069AmS+BriKfYiJgE0V+/T87JRpXWMVPfSKWZMseHWx/wWT30oX95MeY2f/6z+Vj6Tsisz9gX
	IBelFNlRXkRx37gyTfn4B3v6bS/lRfpzgFfIypq5oXrlGC1Ncxh6dJ5fZgb3gMX38nmnZ5hYciO
	roATXetYDJ2THqd4vUPGLhdgYhrN8hQBbjrJ29i/4HMfy/3xcxjoCTXqi8n7TrGj9OfkfcOPhOt
	Ybph1cXf+L8VlFREDTC7vxqrWQVbAdXKWcmYDuwM2wHRiqnS
X-Google-Smtp-Source: AGHT+IGfHFZTdgsktsZ+M8CJOk3r/g/SI00M4oViGWcofvHqRLZHNya8MbgBLax+iUMk7zd0kj+6Tw==
X-Received: by 2002:a17:907:c04:b0:acb:5ae1:f6c5 with SMTP id a640c23a62f3a-ad17b470922mr442431366b.3.1746217330585;
        Fri, 02 May 2025 13:22:10 -0700 (PDT)
Received: from precision ([138.121.131.123])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a3471ef7asm6230125a91.9.2025.05.02.13.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 13:22:10 -0700 (PDT)
Date: Fri, 2 May 2025 17:20:31 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Steve French <smfrench@gmail.com>, pc@manguebit.com,
	ronniesahlberg@gmail.com, sprasad@microsoft.com,
	paul@darkrain42.org, bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: Re: [PATCH] smb: cached_dir.c: fix race in cfid release
Message-ID: <aBUpD0LzzzPUbRjz@precision>
References: <20250502180136.192407-1-henrique.carvalho@suse.com>
 <CAH2r5msw0gCUH29up7D5p2eH5LLGtmwu9E5PJagUi3S2trPHrA@mail.gmail.com>
 <fh2ose2otti5opro6jmpoo6dr4uhc2nfdrlgo3e2ikim4y4gqq@7zxtxyyhphah>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fh2ose2otti5opro6jmpoo6dr4uhc2nfdrlgo3e2ikim4y4gqq@7zxtxyyhphah>

On Fri, May 02, 2025 at 04:58:00PM -0300, Enzo Matsumiya wrote:
> On 05/02, Steve French wrote:
> > I fixed a minor checkpatch warning but also noticed this compile
> > warning - is there a missing lock call?
> > 
> > cached_dir.c:429:20: warning: context imbalance in 'cfid_release' -
> > unexpected unlock
> 
> The lock is taken (inside kref_put_lock) if count == 0 (i.e. when the
> release function is called) and must be released from within the
> release function (which is done here).
> 
> However, sparse can't recognize this and also there doesn't seem to
> exist an annotation to indicate so.
> 
> @Henrique do you think you could rework the patch to something like:
> 
> cfid_release() {
> 	list_del();
> 	on_list = false;
> 	num_entries--;
> }
> 
> cfid_put() {
> 	lock();
> 	if (kref_put(..., cfid_release)) {
> 		unlock();
> 		dput();
> 		SMB2_close();
> 		free_cached_dir();
> 		return;
> 	}
> 	unlock();
> }
>

@Enzo, good idea. I will rework the patch.

Henrique
