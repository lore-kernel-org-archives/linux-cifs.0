Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F8B3A1E60
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 18:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766772498; cv=none; b=Y2FVaKShI9xy/bkCgW7wpUJggoFTLZi5mNgMBARcoOLpUdc8ldaLC0DwoXLeKUtXunCzglQbScEh+3LmeC9CUUtbMG6CKZB8qlMHpr6YkYoahoXs7nstSdzZgVWrDeg+CvR8faR9HySI/LmPV3zqa7VGjCgXgH6BVbneZ6EBPTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766772498; c=relaxed/simple;
	bh=2nSJKYQTYLJaxXxu5krx4gjMWcyoISYvEEo7BpfRgis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edhT1pjMGjT0AmbL0gjv6ae8JMhm2KX5Gua0HshLZlKsMHLfhRQf/XpTEfz6LFPECFkAxG21cdmJ55twVyOUnkCA2PcM15vrKz7qS7KII1RDzBE+DbBh6r77z4qoyf6pZ4kQ+tcBwwt8bBoG6nwngp43dO+qM0nNZeACtT55iVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RmM4Fekk; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RmM4Fekk"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47775fb6c56so55396825e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 10:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766772494; x=1767377294; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7E52nD/cvGGCOX1oU3ZUDMb9+Fd5shA2G+Sfj0LoCK4=;
        b=RmM4FekkcCd6FXsU/24xZZAkM7zN8HJAib/j/jPzhxRiFFLW5tNQuZGtQOkoNJVU7x
         LPvd8IAK+kiwaMuoiwQXEJWL3TcW9ErfeMZWvqbBu7f6Mkd6Gy3TLoRIXa0pVVsar1rp
         s0i8G7OphD4uwa8fTkTI3bFRUa18WMS8KAL2lP0QOdsp/M5VsZrkFxlY36wBo5r4OkLz
         APxgmnhQf71r1wXk5vLJRQROQvA08x9xJ02kUj/wPHB3uAAn+AK9S7OMGORnzyQQpBQF
         1k2l12Suiy1DbOrNhJA1R3PmYQRr/77CQdb4gv4ByX9XolyJrTXvQlJUkPAa5f6xQ7jV
         2SUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766772494; x=1767377294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7E52nD/cvGGCOX1oU3ZUDMb9+Fd5shA2G+Sfj0LoCK4=;
        b=q0kt7TByJZ9oAKdxzqjBMu0Hzkr464F/tZHfPKz4EqXaf+Pi8UaQChf3Yif/d5+Gpp
         1qc7qZ7VzGekiYJsDpdgfO3LmPCa53jOBe8Rh+632nmm3g0EPljEMHAkjKF0osJ+xtNh
         jAlR3HBDxa2neV9vcnhaKOmnVHJNYQIcOSfS6IQowK7ra7V6ZWuYe6vJ3ZFdsEDTJTej
         4yit9T4mw4hqV0jMWg4UbEEH3Ms+Aisn0vKms+exY22t1yXcsuB5gLUQKYlNI4UYDUzd
         PAnqxqxSAZM/o4lqVVyXLyiNnFBucB7L9zQcVFKIheG8IRcOkMxeTIQ74z8jK+3ZhTxy
         K43g==
X-Forwarded-Encrypted: i=1; AJvYcCUeFTOkISHB/EVBuV+YEYCSwQ6AB5YxXSy+TtL/NBHlhAJa7a5Isvgbv8y3WwXGlkp6gjM19B8rZH9K@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi/oURLO92KjW4NXMzFAbma6Saf0SBz9Gauxtg3ep5siiZa3HV
	FTREUzLkA5x85XGEj9XwTJNbgDCKZ4R+IdONa3jloMIh7D5KpYdrINkLLp4JovCeTWM=
X-Gm-Gg: AY/fxX4UW0zd8BTyMuFhIZmzeLO1JdW1tj6IgAGNfOOaELL1d/PkbUIqBT2V6BzR+YI
	UoyOykmJJzJ5kJXKSESof4QgKsi2jeXuWgdVYw1s/vUXcBEC4KdVqq7IpXobqyigfkds05sbiCD
	KKqsaTge+FxlqN3yoL0krjXbCeMIsPLGze3sbDjb5uSi9QLtlhJDnBf6MToEHAyx1P5zTUQIxTo
	Fd4TLvL9rQ+3trPf0/ucxqvCXF2Q4OapiyfsETkYVlTOYpxozUtqWeA6PZs4y2gvyzMTgjruk+v
	ZXo8r2DwXr+4qiKgcPU+BA0nFiDotOumX7Bxa2T19hBdSof0e4AUsFgtdP9mLSOBcCUOcLZ+Ah2
	isSEJdvpGJgBrE4Enlfjd0m0dJkT6aymPhKE0YZ3LtbkTu7xZ0wnu3PCpLTcf3oyf2ZyuPVx7W/
	hmGcDBsmvJi3PkhbiRvvTUMfMb9A==
X-Google-Smtp-Source: AGHT+IHENJga4mOEIm//yBngu3px5wczyl2/m4xn/7CjHAF6A4pU4T1oIwK7gM4sjAT9X2fi9twZEA==
X-Received: by 2002:a05:600c:1d0a:b0:477:79c7:8994 with SMTP id 5b1f17b1804b1-47d1959f72amr270194275e9.30.1766772494212;
        Fri, 26 Dec 2025 10:08:14 -0800 (PST)
Received: from precision ([2804:8fc:1d03:c72b:a43b:e62:50f9:41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724de25dsm65949982c88.7.2025.12.26.10.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Dec 2025 10:08:13 -0800 (PST)
Date: Fri, 26 Dec 2025 15:05:55 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: Steve French <smfrench@gmail.com>, 
	Youling Tang <tangyouling@kylinos.cn>, Namjae Jeon <linkinjeon@kernel.org>, 
	David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, gustavoars@kernel.org
Subject: Re: generic/013 failure to Samba
Message-ID: <7duojyv45sv3x65fmaggbhl2rydgisaqesedqqbrk2pg6jyo5m@2cwq23g2sw2v>
References: <CAH2r5ms9AWLy8WZ04Cpq5XOeVK64tcrUQ6__iMW+yk1VPzo1BA@mail.gmail.com>
 <5frnv6uc7yvfrb4nar5rpjbjyog5krbpfvus74n2iv4vmri2s7@i5bv6napwn4o>
 <141824e7-50ab-4072-b611-5db5fa01bb86@linux.dev>
 <e56024d8-6fd3-4040-b31c-44d3dea3df3c@linux.dev>
 <xrumab2vstnivbhiafrjhzflztii6bxfwrlfs3lfjc7lwsbty7@3jozs5y6lxg7>
 <b75f093a-6546-4b90-b4d0-879aa81cd327@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b75f093a-6546-4b90-b4d0-879aa81cd327@linux.dev>

On Sat, Dec 27, 2025 at 12:01:18AM +0800, ChenXiaoSong wrote:
> Yes, you are correct. I didn't consider `cpu_to_le32()`.
> 
> How about changing it to the following?
> ```
> smb2_copychunk_range()
> {
> 	...
> 	chunks = 0;
> 	while (copy_bytes_left > 0 && chunks < chunk_count) {
> 		cc_req->ChunkCount = cpu_to_le32(++chunks);
> 		chunk = &cc_req->Chunks[chunks - 1];
> 		...
> 	}
> 	...
> }
> ```
>

Your change does make the code semantically tighter, since ChunkCount would
track initialized elements as we populate the array.

That said, I still slightly prefer setting ChunkCount to the allocated
capacity before we first index Chunks[], and then setting it to the final
chunks value before the IOCTL.

This both satisfies __counted_by_le() during population, it isn't wrong
given the allocation is chunk_count, and avoids an extra ChunkCount
update on every chunk entry (in my build this is not optimized away).
It's cheap either way, but if we can avoid per-iteration overhead, I'd
rather do so.

What do you think? Do you see any correctness or tooling downside with
this approach?

Thanks,

-- 
Henrique
SUSE Labs
