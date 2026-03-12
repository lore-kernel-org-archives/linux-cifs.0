Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958CC3AD50A
	for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 19:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345538; cv=none; b=CEq69F8VMImy2+JSKJaqiqrPytzyjGoG4P5HxDTZC7cRE1yitdNlLfeNxPOFLr05yDqj244VerPyb4c+O+gpRmxZ6LNyW5JpbSVI6Nxm+hajqrPx0Hj4SBtwbrYxj6A2t/Q6/h7H0NDx9Gwbbd4m5KP9ByAwDoiF1o+s2kgKg7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345538; c=relaxed/simple;
	bh=RY963B+uqTjMp7UVFZuiwEqIxn4cJaaQeDCKxuMpfzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYNc07YZHOpXv+ofc/BHtMeMbYRX4Rw7DagWNwxuQwRfpMCLU0pEbuoPiaiMNkkhs2xiauyLMsZTVMxnZ/EQUC9yKy9ce+68r25cbRv2CJ9ErrPYVEU6TpVZJlAzBhG1ZPSvXbDIlJ7uy5dol6I6t3DJp/nOIbsPLNxytbitiek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fGx99qZe; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fGx99qZe"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4853aec185aso12659765e9.1
        for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 12:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773345535; x=1773950335; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MIAskK+ZNtzz1SwxyEcF/wj8vxB/luVLoRjKKyPZhTk=;
        b=fGx99qZewKXukzKKfUidwe0vteY3e84Pf3rZQYtlGSMbg5QKXqr5U9rzXM3Lk61D7V
         oh6y6i2n3FKatw1OtJ5HgZy9gsDyOiQXcJoRe0wy1dFc10GlwzJ9t41SF671R0TfOZLi
         XWLdndrot2+bhXIOnSdxLww3ouJCNGEZ724IkwxP2LzKH7T97gNbIseYw0Jhxk6rllw/
         XeM2ZEVFWvmC39qJK2d5wDALaATFLMujvgkxZd6OIfb9t9UWpd+Gq4qtNRi15rPp5204
         cCyw3fWxQ+k9Wl5CAmrC+vxXWKaTm9Gm2MryJHddIzlBHKIQVg/WTZIn9wdd923apvMJ
         s3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773345535; x=1773950335;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MIAskK+ZNtzz1SwxyEcF/wj8vxB/luVLoRjKKyPZhTk=;
        b=JYz75frtRwsm2zqSondvSZybgI3xyQbEWyfT3LsStZUJgE4XA9fnFdzAY4l3FbM4Uk
         53KpNhtRnpEzVgK4y1f7qmapPVSVSj4qcN0B9od1VZzgsk8XZkYWnKAlFVTwzqCRlXaT
         hMAZGDLahcY+WN/RiXPRw6zaxtygHbLyHKIQ3feG6yncXDbyOTl/BwXPp4PqdIJypRJr
         kKEXpP98JzVMwOmrPIodniRLKB71kLlRt6T/0VwERYFIYDjbFt7DPJMxfeFR+MgumgyN
         UJ/5Zig05xMWS6apg04udDvyGeXKMZk7FYgX3LHOZvEvNNuYi/uK1LzLp+Pbf1tXcP9O
         pbpg==
X-Gm-Message-State: AOJu0YziAn/IWKXmJbwTWkpuWODN6I+NrCjUKtDs/docVGevUMoFsbgC
	s8nfGWjyg8AOlS1FqUKAwqSil/BRDTaQiTXrC8ee9rfa2GBOpdqRFVGOEo/nLyX7PZc=
X-Gm-Gg: ATEYQzy7hshMYe+UAF6t3r9YHLQoRCM52eK7XiNyl8/J5SrzyuQ7Hy95sfbeMKcvBty
	JRQWMoNH+IHUDyrfLLneYNbAFpVkwNtg/txUCh0sJZQOpK40UuwjImaHiIBJxvw7jYC0rnABzQL
	EfUHmicv+hiT78f0Eh/acOmMQzQwGm0gMbVEn+jIx4ijpEPPiYMmo+QKcSiS2uo617/O/5b4IeB
	w/p3rURvFq1jpQ1VTeL0lwvve+AO+GO8A7BQcsp7c3YOPZDLb0lTlS6xn1smf6Mnrvmx/WtGBb2
	/Q1Ha72RbY+/NA+hjiEx1ts12zd+/pdMorGjrP/htWs63uo6foW8EpJZsMn7Ro6/uahZz7O9xjA
	pgMQ4Gy2iBxZfgNV03hOwrSnGt/5MWXe/cyp5JAuoFpmFDWAXYZ2i55SuQzddCP1czKEU9MT6f3
	JwS53xOIUr5ifeIn5VWXQOlBKH0eSHwiQ2AFqsiIH6ErjpnfEx3HZtUaA=
X-Received: by 2002:a05:600c:c8d:b0:47e:e2ec:9947 with SMTP id 5b1f17b1804b1-4855671052dmr9527745e9.33.1773345534851;
        Thu, 12 Mar 2026 12:58:54 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6402:b103:6a0a:3e1c:778a:5cc7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be8aa96fdcsm7899078eec.30.2026.03.12.12.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 12:58:53 -0700 (PDT)
Date: Thu, 12 Mar 2026 16:58:49 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	bharathsm@microsoft.com, dhowells@redhat.com, Shyam Prasad N <sprasad@microsoft.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] cifs: open files should not hold ref on superblock
Message-ID: <u4s57pxvrttksfxe5evylucarfoyiv3ut32d45nvfafsgmxtog@72x2iew66wrt>
References: <20260304124629.1616108-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304124629.1616108-1-sprasad@microsoft.com>

On Wed, Mar 04, 2026 at 06:15:53PM +0530, nspmangalore@gmail.com wrote:
> From: Shyam Prasad N <sprasad@microsoft.com>
> 
> Today whenever we deal with a file, in addition to holding
> a reference on the dentry, we also get a reference on the
> superblock. This happens in two cases:
> 1. when a new cinode is allocated
> 2. when an oplock break is being processed
> 
> The reasoning for holding the superblock ref was to make sure
> that when umount happens, if there are users of inodes and
> dentries, it does not try to clean them up and wait for the
> last ref to superblock to be dropped by last of such users.
> 
> But the side effect of doing that is that umount silently drops
> a ref on the superblock and we could have deferred closes and
> lease breaks still holding these refs.
> 
> Ideally, we should ensure that all of these users of inodes and
> dentries are cleaned up at the time of umount, which is what this
> code is doing.
> 
> This code change allows these code paths to use a ref on the
> dentry (and hence the inode). That way, umount is
> ensured to clean up SMB client resources when it's the last
> ref on the superblock (For ex: when same objects are shared).
> 
> The code change also moves the call to close all the files in
> deferred close list to the umount code path. It also waits for
> oplock_break workers to be flushed before calling
> kill_anon_super (which eventually frees up those objects).
> 
> Fixes: 24261fc23db9 ("cifs: delay super block destruction until all cifsFileInfo objects are gone")
> Fixes: 705c79101ccf ("smb: client: fix use-after-free in cifs_oplock_break")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---

Hi Shyam,

So the side effect of the previous code is that the umount hangs until
all the files are closed?

Thanks,

-- 
Henrique
SUSE Labs
