Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF7BA50
	for <linux-cifs@vger.kernel.org>; Sat, 23 Nov 2024 01:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732324610; cv=none; b=R1LcwOFQNzfQBn3H+VkbUiS/z1z/WBLKJ71CXKGcVVb2Up0MgGINHFGoULSBPcIrJjdi29r7RA3anFiVMc9teSMO0A4KVOlKDu8Xtr4w14uasLmFOEJcwXU4VB8Ydv3w0WuZ/aOyCnGeJuPELLLm1ceZ2yV+OGZz4LrAD0wgc/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732324610; c=relaxed/simple;
	bh=WhI+n8U+RiMdSUmmp9qm+xLDpZoqvZtEcNniglEBRDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knFpAL77wPX+du2zSl0X/pt6d8xNCV4cL+pnB/klTm8MpnisMZxyT+aORXhEXtGxD53tqZdg1hXp8t0xCk4y0t0N/eDFbDzDHlUq0n33yLnE20/mPEhjP0ldehfaAt6fcZt36z0gg9O68LYJFLqsmIoqXuIvvnI23bBdaWnMfR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bJwt8Qvx; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bJwt8Qvx"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-38246333e12so2512328f8f.1
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 17:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732324606; x=1732929406; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yAH7+GiJb6pq/+rCN49I9xZYW6tEJ74Izs2OgSqOh0g=;
        b=bJwt8Qvx7GbF8pghma8Rt8zsKUIoJXXlsYHFVZ8lRu4+blx7MFWyd7D460tF5rzAjz
         ofXPVUJXf+ux/dB2z5+slLG2lyDx2ved1048JVcvv2cM3nEcRRqiHwrDi0f9kz7AkFPW
         ZhEiMoj7SOR0b1rVsiKPSOaW2dJ9XYwiMTwOxwTWSsIgSijBNESQetTxOpuORWWXIsdS
         BirtPJsp2SpwvJMaDv2+Wa7dJzsR/z6C/pgBMdoWv82GJfhq46fhEgeY2V3qe7wU/Gfg
         482/x2auO2dLXBtKDjsy7QPEBG+ke+IG7iB51FV9mJSjZeT5xlN+WLOiQv+39UvUofYw
         rZsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732324606; x=1732929406;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yAH7+GiJb6pq/+rCN49I9xZYW6tEJ74Izs2OgSqOh0g=;
        b=DpY27S6yEFcKef3JYPwGpzlAhisvIGWfp7WyCvyRw6rPg6pyOQPuRWSj28fh9k6M3Z
         yfKxs6qzJjOLQ6+/mwnkZWZgR5s4KGhu3R3lIaNGzSjG/1l6QbAIf9aJQ+kR1nrAjKvO
         DnxX1a2OukVytFL6uVVWoAXV5zEKdD0spU5GrSzkgfsD8NIzeo39r9XdPFgDMqQ/Qufo
         NxgTUj+lHP3FYBIDHyW95UNHHYOe1/FCl+4rc88E35CK1TVcsM6i1D9xdQcP40/LzB8E
         ZsGh+8iiZg/GrDe1ByQwkM4RWoxHSSkZ9cH7SkyptxvrFmh6DGntVujbt+sr5TdKSlmT
         yR9g==
X-Forwarded-Encrypted: i=1; AJvYcCUi0aeOiR3Wwo3jugxpDP+V7A1tT4LHzDNzKQPAv3J5Bd3VxdKRR4Oat7B6TWBN1hcQUzr5BnGj1sbF@vger.kernel.org
X-Gm-Message-State: AOJu0YyggXkbwW3sKiJkdrKn4w1lG9za/79xmiNpqeJGWNzBkaLszo6k
	qN2cFNXJsu+8CfLoXHhMriBLLtm4ehdjO48hot8Gch6DN4ROWCNBJe9OGEb2jVo=
X-Gm-Gg: ASbGncsB0Vj5FX/rqNipait1FaH5a6QIPHUnPQwT5VrOxy+NSSA8Dg8Ti7DgyrhSAEm
	BYQ/q+OuBvXGamDucE4tpiWE3NltojE/d13c1JxiTYhy4QOH/3STWzNw/494ePX+t7vjSVX7+mv
	Rp4X8i0nLJoyxB9trRmcFBXTKfrGxxuudBrkityzaeAvqkZEJhxYrN/ge+sYTHB6h979li8dYrF
	HWlBG3RmVpBF8zKwJlexYBNGiuL0CJE7B88qH9Hf1lj6TnL2cIivw==
X-Google-Smtp-Source: AGHT+IEBOmDRy9l7WpxTA9ndsxdmpTrG95Cp5Czs1W8RYqwpcOH/Ivc3tpbNRDW8cGJvchknp+G5WQ==
X-Received: by 2002:a5d:5f85:0:b0:382:46ea:113f with SMTP id ffacd0b85a97d-38260b3cc97mr4849706f8f.10.1732324606592;
        Fri, 22 Nov 2024 17:16:46 -0800 (PST)
Received: from precision ([2800:810:5e9:f3c:e019:b39:5a90:cfe])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2eb0d048e94sm2258142a91.40.2024.11.22.17.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 17:16:46 -0800 (PST)
Date: Fri, 22 Nov 2024 22:16:06 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Paulo Alcantara <pc@manguebit.com>
Cc: sfrench@samba.org, ematsumiya@suse.de, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/2] smb: client: disable directory caching when
 dir_cache_timeout is zero
Message-ID: <ngk6hpc5is7lzd7r3cs7d4zvovyswxwkiziibdvro5xda7wcaa@6bpvmnld2255>
References: <20241122203901.283703-1-henrique.carvalho@suse.com>
 <7e76e6d3a5a194b87ae98e13c354a4f8@manguebit.com>
 <cpbqdqjvgoaamvhg262ruhcnkilrns3gwabcwjgihsvjx7yict@jqzjvkkutjta>
 <f1809e2140cd1d942b0930996ad5740f@manguebit.com>
 <xb4fyaabfrm6p3tuzlwtdbv74pcw63t6rjbqnrgzftm2xaeq4r@wla6hlp6nb7a>
 <f783a9a53769e3e4f9df14621691fa9e@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f783a9a53769e3e4f9df14621691fa9e@manguebit.com>

On Fri, Nov 22, 2024 at 08:59:53PM GMT, Paulo Alcantara wrote:
> Henrique Carvalho <henrique.carvalho@suse.com> writes:
> 
> > On Fri, Nov 22, 2024 at 07:55:35PM GMT, Paulo Alcantara wrote:
> >> Henrique Carvalho <henrique.carvalho@suse.com> writes:
> >> 
> >> > On Fri, Nov 22, 2024 at 07:07:06PM GMT, Paulo Alcantara wrote:
> >> >> Henrique Carvalho <henrique.carvalho@suse.com> writes:
> >> >> 
> >> >> > According to the dir_cache_timeout description, setting it to zero
> >> >> > should disable the caching of directory contents. However, even when
> >> >> > dir_cache_timeout is zero, some caching related functions are still
> >> >> > invoked, and the worker thread is initiated, which is unintended
> >> >> > behavior.
> >> >> >
> >> >> > Fix the issue by setting tcon->nohandlecache to true when
> >> >> > dir_cache_timeout is zero, ensuring that directory handle caching
> >> >> > is properly disabled.
> >> >> >
> >> >> > Clean up the code to reflect this change, to improve consistency,
> >> >> > and to remove other unnecessary checks.
> >> >> >
> >> >> > is_smb1_server() check inside open_cached_dir() can be removed because
> >> >> > dir caching is only enabled for SMB versions >= 2.0.
> >> >> >
> >> >> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> >> >> > ---
> >> >> >  fs/smb/client/cached_dir.c | 12 +++++++-----
> >> >> >  fs/smb/client/cifsproto.h  |  2 +-
> >> >> >  fs/smb/client/connect.c    | 10 +++++-----
> >> >> >  fs/smb/client/misc.c       |  4 ++--
> >> >> >  4 files changed, 15 insertions(+), 13 deletions(-)
> >> >> 
> >> >> The fix could be simply this:
> >> >> 
> >> >> 	diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> >> >> 	index b227d61a6f20..62a29183c655 100644
> >> >> 	--- a/fs/smb/client/connect.c
> >> >> 	+++ b/fs/smb/client/connect.c
> >> >> 	@@ -2614,7 +2614,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
> >> >> 	 
> >> >> 	 	if (ses->server->dialect >= SMB20_PROT_ID &&
> >> >> 	 	    (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING))
> >> >> 	-		nohandlecache = ctx->nohandlecache;
> >> >> 	+		nohandlecache = ctx->nohandlecache || !dir_cache_timeout;
> >> >> 	 	else
> >> >> 	 		nohandlecache = true;
> >> >> 	 	tcon = tcon_info_alloc(!nohandlecache, netfs_trace_tcon_ref_new);
> >> >> 
> >> >> and easily backported to -stable kernels that have
> >> >> 
> >> >>         238b351d0935 ("smb3: allow controlling length of time directory entries are cached with dir leases")
> >> >>
> >> >
> >> > Then I could split this into two separate patches, one with the fix for
> >> > the mentioned commit, and another patch for the changes in cached_dir.c
> >> > (which I still make sense to have).
> >> 
> >> Removing is_smb1_server() check looks good, but the other changes don't
> >> make much sense as we could potentially return -EOPNOTSUPP in
> >> cifs_readdir(), for example, and -ENOENT is probably what you want.
> >> 
> >> Am I missing something?
> >
> > I might be missing something, but only place I'm changing the return
> > value is in open_cached_dir_by_dentry() so it is consistent with
> > open_cached_dir().
> >
> > open_cached_dir() already returns -EOPNOTSUPP for these checks:
> >
> >  if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
> >      is_smb1_server(tcon->ses->server) || (dir_cache_timeout == 0))
> >          return -EOPNOTSUPP;
> >
> >
> > The changes in this function relate to removing unnecessary checks.
> 
> Sounds good.

Resent. Thanks a lot Paulo!
