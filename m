Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBA123C4F5
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 05:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750309423; cv=none; b=HMWdINOUTAWO/LRJxdc4S66byLHSkZ6pyhpi9GHce6dszSm0duNn5AfKlmOZcYY+19wkplsRobloA9ZNvI50PbFzcpmipFmpPiCHGDWByUQ7UucJvazR1bw32BpU3u+TQh0iIyV8INxzkPptvQditMsogZuBAlhBltIKva7qoq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750309423; c=relaxed/simple;
	bh=lru0IbGZxb3U5mZGpSxa7YlYMFAof9n0AqZn50Mafv8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qkGKQVIIRrMvSqwA5wQTEuaVMF29U+6I9EB0mmGCqN/rI1Dl2VXvWBUt70QbTBPSKmHd91RyyzXWu55nw+Ey9/48x/doVRVpDxaWQMqJ8O0u1GaUSnxQjZQnE2zVzBvlY+916E5qL43A/NtyNax/Tu7OECH5jcxx8CSRWpGLgOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WwiUUj8X; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WwiUUj8X"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-6ff4faf858cso2924897b3.2
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jun 2025 22:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750309421; x=1750914221; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cq47FPO29057fAy/gbCwE7jHTZ3mLnZJzvRXeD6jC1c=;
        b=WwiUUj8XgrWgRe7hNd/B6ihTNpAm2tZYmxa/88CzKsOF4PcEyum0C5paxHK+LviiUz
         w2WzYDjDB9XEwLnQlcZGn5LPDYv5dBH6eClCkyFbks1WfNaM0Z9yJIy4b8100lBrX4Mi
         Stv0dW+6iSnJYhPy9VUoKDE8DmwYeYicFsNh/mReEFRX+0pI0COekdo++rLUi0Sc+I22
         jgOO2Sq30xw3YpuSDdZ+DcxCIc8O7nUjirJoW1MrhtJzmBwcVVQPSgNHRUpg/aneiVlU
         wG7plQreDJm8IAoXDQ9KlA85IFU1JM9suUjpP5r38x2NmtkRm4p9L5zbhWtIHqlptjX9
         im/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750309421; x=1750914221;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cq47FPO29057fAy/gbCwE7jHTZ3mLnZJzvRXeD6jC1c=;
        b=MDZr/OG1gEluB82vBrHnxm6CQcLRSiAAUH7wFBxbwZcfc5maJxvB+CQ4jXy8WuAYKx
         nuBvZA1vu9Yk6rec1gSqJ0vv+ZhQUrSzL6dL9jYUF4ZFRMYPVZb1NdJIQK6MD470bnFz
         uAharh75QVpuRDVG3861IuC3B7Cd+VkvpI2OGW00WtO2oIjRLSKNTE0bd3YcLbfrwnll
         aSY4bbAvlBRfjRpfzb2uIiQVoSfxQeqSn1qZ4qA/JorJabqAc73bpjRPgzaf88uEdCWA
         udbO+X4C22tWvJX5hoRSaRHT6qehEXtSmbzJIhm9i4RcbhdYMABq0Bl3089j8DZCVs/x
         HeDw==
X-Gm-Message-State: AOJu0YzmN0q7bC2fJhJmtiwCjrf0t4QVhE1QyKm54B+wvgrAmQgpOvM7
	B3A2skcSmf3IHTnEPVR70PE4pbNtS3imMZV4uhPvRhfIrRD+mIP5VEJfdYu6tKj2zdeS+yilbbX
	Ur7xYmh4z56avvIGFJpYWXhumXiMy24k=
X-Gm-Gg: ASbGncvRodYVsh9esmCt2E0IPADaq6aB5EUKEmufFlSbVK99X/T9dZ5jhXtAlRBi7gz
	0P1UvLwQwl6lAVf2WUxsLxWHSY2ttbgefEpPcxflzo4PxAXK5FwylFkIrJ1cwHHH92cvbIQOgKZ
	hfoPEN7q84yLoIGyoVs0wzeLjeRsoycsu1R9pH/6hcDqI=
X-Google-Smtp-Source: AGHT+IHwnTAquqKniLPNVOBWKMKHKjR0VfdkKWyAWmBtlAhpJPc4wHoNNVc3IZQZp7UVx2nwoxFQr4OjofPXfA9eK9U=
X-Received: by 2002:a05:690c:680d:b0:70e:143:b82f with SMTP id
 00721157ae682-71175459cebmr297612927b3.32.1750309421144; Wed, 18 Jun 2025
 22:03:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtipm8KB+FwzYKAvNqH4ECAv+1+SUqyZ0ur6k6Sy8KoAA@mail.gmail.com>
In-Reply-To: <CAH2r5mtipm8KB+FwzYKAvNqH4ECAv+1+SUqyZ0ur6k6Sy8KoAA@mail.gmail.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Wed, 18 Jun 2025 22:03:30 -0700
X-Gm-Features: Ac12FXyhZvXVM32u-9lMJwmWUjCqLNnIRVfJPHkad0PXQxNxP45DSiIz7YKPOV0
Message-ID: <CAGypqWy_kDNvDmHzphFUQCbahiKjt2qJNmur3Ehibm+a1-wZJA@mail.gmail.com>
Subject: Re: smb 3.1.1 client dir lease performance
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good points.
I am currently working on performance measurements related to
directory leases to enhance their benefits. Based on my findings, I
will be submitting improvements patches on cache policy adjustments
and performance tuning.

Thanks,
Bharath

On Wed, Jun 18, 2025 at 3:24=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Bharath,
> I noticed that with your patch we are caching directories (when server
> supports directory leases) well for successive readdirs which is a
> great perf improvement but I also noticed that they time out at 30
> seconds from when the first readdir was issued (when the dir lease was
> first acquired) and not delayed if the directory is requeried every
> few seconds.
>
> Thoughts about bumping the timeout on a directory lease
> experimentation to when it was last accessed instead of when it was
> acquired?
>
> I also noticed that when we hit the limit on max_cached_dirs (16 by
> default) instead of evicting the oldest entries in the cache to use
> the newest dir leases we give up adding cached_dir for that
> when we hit the limit, even though some of the older dir leases in the
> cache may be about to expire?  Maybe we should replace the oldest
> entry in dir cache with one from newest dir lease
>
> Thoughts?
> --
> Thanks,
>
> Steve
>
