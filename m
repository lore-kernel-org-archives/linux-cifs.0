Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B156153E0B
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 15:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766763379; cv=none; b=X5soQ+mAlzmrO5CfawrK5k51tI/yoMFfhwHHuGOBwXQCqOmG/ARORluD0SdzN/8QeAAB/ug6WlahRtzwvab1uoLJbFzVFX5SeEO4EDeyZFrfBlLFIpp6z2iRkyAux+75N2dUeIxBwCIokOR14rM4LWjbDJlsPc6olgoHkgOAY8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766763379; c=relaxed/simple;
	bh=z5X8fssEL3S8mOa0+1zsN7eeU4gVPlqHiruA4um/LHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XP9cns8wFt/OuSSDwWZ/el1KZ4A4jIF5LngsDp42JUnOJv6Bgmrm5n3z8t5CVga7lpqFFxjREsGypJ3kGzsIYgasRHSUy70YEaXiBrrIcTGSdr8HjFQPXwrD2gJ2IkITzOC+JF8au+4ShHmY4RrK++05CTNT8gwjXAw5HY/b1l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M6Y8IyR3; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M6Y8IyR3"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso70937395e9.3
        for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 07:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766763375; x=1767368175; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7mx8YjSLMI2T+8uBUmVX/65U+bMa0Evfy9qm3Pxd/58=;
        b=M6Y8IyR3lUtO2+Fme8/ss5kXOlNv+4jXgG55ijBU3/uVkJtsRGs2+4bO07IXiDSIb2
         +kWPfKXhIK8fsRvroE9r9vqK0f1tX49hoKFd4om9Wd0I+amT/iltCIQb+m4FyeWoI3pP
         PfErJgdo1iBXEeYvVO5LMKvqHZbI6MvNNnhA96p8OylLQptw0By/p0eyatx/sWAvFhoo
         L580cc6BdqymPQRfWGCN74ocneRLjBcmPM/RP7SI4MV1opJUJliug3F1eZZMISLXj3V9
         6M6WIVyrA5X5VWeX37biiaiM6BRzVnXhdkEgajLjQNFfAUkZHZUZALfsGOEQ3+3B0Rm2
         oqHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766763375; x=1767368175;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7mx8YjSLMI2T+8uBUmVX/65U+bMa0Evfy9qm3Pxd/58=;
        b=BwJYTTo0xF7X8el5O7hJz9jUv2Wf5x1x5WzNKReLZQAzlrLgJ9bQxcwSNyYfllrwRi
         UWPrwoM2YwdVT6msO0ecRI6DH4Lu3F8IisyMN11pXCT5bBaAoy6+0nCAJbk1r59zTmTE
         XZkpyyrJKwTb0iBSpJ+MQJ+A6y0E1+t2H51kb6knQ//3Eye8UIMUFwqey3mCNGXle+Yj
         zSI0ED1+8VoP6VKq9loRhJSukVWaNA2sNhVZzr6dmfqqXUJXpuPY2aI5dwU+hRYKian+
         hNrfSA/x8mOA24aNoQaqBDdTA9loKhHmAaB+I9wwUX6Xxe7k7Vvb336lGDP4FNKfFysB
         X1AA==
X-Forwarded-Encrypted: i=1; AJvYcCVMe9+bYu0aBTrhdwFtTiVfygLO5BKrP9Wk12Ep2DfSDYWk/utWMOpDJ1C9h4ygcscYC3AjbeM822jg@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz4STk1tQ/upReFRDJ5BaWUlKjBFDPPZjSXYkb9rF0oTtWhjXN
	+JYc44SC6Anzw4cwgtM4Qg93ppJsc+QQlDUORekiB+xSo57ag6AmjvXHxO4VmX7ujYU=
X-Gm-Gg: AY/fxX6CYQTLVwv1nX4sAeUXVSkTuXEcUQoIomgWY/UdgF+i3thqmU6oU1/8QuhsUu8
	8lWxNjzBhnARkjHEAwUP4lB8iqakZKroWM8vT4XktcqBmOzEniFv4WS08StpFG4rasaVBETgAgx
	viSnTVg1qjKNkj+SWTcYVRGRGY39FLT3rUvHCUTPCJOrJmhw6xVgtB/L0WLK6cfLyJ99EyASlvO
	Ia6osh/vIjbFLYrLcmyPMpygLjUG94uXTXqboDUJyyH88oluLjhShZQvGPWsPakYjACoL3AOjHs
	MzxM9uqlaARQ/BRsWUUYRDPp5IDynUGDnMD7+5qZgVAfhDcZbfSWglQb6wPpe2CARgE/KDdtlIB
	BO2MI3fbds4YK8mgweV7Lk8i4wVsnoEsADfU3hyFvorSnVafT0PSYMRBBwi/rclsabRO/2X47U1
	zgQBM4gJPJpwWTgjE=
X-Google-Smtp-Source: AGHT+IGxL0b8YnuXH+a+Yv77GwhbluubYawrBh+49242t+KAgRfRUNx8Fz0E4JCUyIv2wtc2RMUqdw==
X-Received: by 2002:a05:600c:6388:b0:477:639d:bca2 with SMTP id 5b1f17b1804b1-47d1956ec01mr239183175e9.4.1766763374838;
        Fri, 26 Dec 2025 07:36:14 -0800 (PST)
Received: from precision ([2804:8fc:1d03:c72b:a43b:e62:50f9:41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217243bbe3sm92031856c88.0.2025.12.26.07.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Dec 2025 07:36:14 -0800 (PST)
Date: Fri, 26 Dec 2025 12:33:52 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Steve French <smfrench@gmail.com>, gustavoars@kernel.org
Cc: ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Subject: Re: generic/013 failure to Samba
Message-ID: <kxl4zr5omfke5f5ujdxqb6old2fkrklqujk7y7pirn5qzzdbal@rbve4bzrm2pi>
References: <CAH2r5ms9AWLy8WZ04Cpq5XOeVK64tcrUQ6__iMW+yk1VPzo1BA@mail.gmail.com>
 <5frnv6uc7yvfrb4nar5rpjbjyog5krbpfvus74n2iv4vmri2s7@i5bv6napwn4o>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5frnv6uc7yvfrb4nar5rpjbjyog5krbpfvus74n2iv4vmri2s7@i5bv6napwn4o>

On Wed, Dec 24, 2025 at 12:02:22PM -0300, Henrique Carvalho wrote:
> This UBSAN report is consistent with struct copychunk_ioctl_req::Chunks[]
> being annotated with __counted_by_le(ChunkCount) while ChunkCount is not
> set to the allocated capacity before we start populating the array. This is
> the same class of issue described in [1].
> 
> A fix would be to set ChunkCount to chunk_count (capacity) at the start
> of each iteration before accessing Chunks[]. Proposed patch is attached.
> 
> However, if my interpretation is correct, I would expect the first
> population to trip as well since ChunkCount starts at 0, which does not
> happen.
> 
> @Gustavo do you have any insight into why the first access might not
> trigger?
> 

I need to correct myself: it's not that the first population "does not
trip", but rather that we only see one UBSAN report. Subsequent
array-out-of-bounds events may still hit the handler but are probably
suppressed after the first report.

So this behavior is actually consistent with my interpretation of the
issue.

-- 
Henrique
SUSE Labs
