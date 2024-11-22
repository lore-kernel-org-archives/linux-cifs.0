Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E054418C932
	for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 23:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732317876; cv=none; b=r36vU7+YGe/Uge3HEzlgL00Lz3aki8ciepEDzIfeVEgFrR0Z43vvss9FNJn5V4NqE1bwXBkhrauqUVxQLIy8/05jtGI8PdyNI+9QN1lrRG9RtOcF/UdEhqaKMAta3g/lz/pN0oz9J/x25qHHMKavAWY55KBVuQNpUmNGgvJkgtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732317876; c=relaxed/simple;
	bh=YO8YUi9DBNUcscBORFvkC18yfne2jjpRxziiSkyro8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m24eqdh0uysHRV0vt2RMqQVAhpl2+Udqk+Afct6DJPro51QLWTMgit2b/sRcQ/VxoFtDg1F6pTWfjazH9MSt+3hoUyEhlaBZKat7qus0ehk+dX//Lrwp/UnyR3+5ac67q5NQd3Giafnuky+hviea0+Go9EIjTupv0Ubkf9Qhp5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TTaLw677; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TTaLw677"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43169902057so23084715e9.0
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 15:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732317872; x=1732922672; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AvDhiyQBrTO9O1rVNduMvcBUGXYvXuGdk926A/Hiy50=;
        b=TTaLw677z76q0enfzMmmcwHAS0Exd5GyzABrwR1ZhYDd8lse/ziz2ssj6WMA3RCwIu
         xh4fNWv+/cslf9RQXf1Ex0ApYoa6Gm7alho7ffTVVIySLDp7zbWQPOX3/l9fUK4Z4Ddz
         Nr8JSCs8g9Z5n13PxosiQo/qQqsWkioL6dsd4H5FAyo0iL05LbVbKANxZIeKHfFYq26I
         Hk3vGPoUVHDsFzTnhwE7jAnGlcBmYkYVjeSBAp2RbWtrb3vQMIe8RYwLuYB4VtOeCHzT
         fGI5CrPOyzyvLd+kMhSOrtJ56i62lZ5L+6i4caIzeqLGgP1VJAsuExuIcayRZ2v8Sop9
         vYDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732317872; x=1732922672;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AvDhiyQBrTO9O1rVNduMvcBUGXYvXuGdk926A/Hiy50=;
        b=azHnxd13QkTWWcEgaJzrFheABbCTiEDeHSxprIHmilwiLZWVqUNB3V0jl+le86l192
         PeE9yoQdVvL8kJbAizrNvPljqOm2toz2ubdhFfnwQSoaHd9jnsolpq0LRVQfUnjnwKZQ
         lL/IWx0l87UjlLPm3ldWwNniK/HSrK/CwJDZWAX3uk0c0/JljL6YB1B/QiAd+34QUpgn
         /xIAGnlCnofpDfoxbZxUB7suhQfSTHouKkALlcf/BnPF6sQJhZrN4x3wB4jzsaI22V1U
         mlBbDn3JRQnkrRvsYR1vNTmnOSUSGGdUqeXLQcLRWHovMctVPBUEHOnBzleKpPOJ5jvG
         32+Q==
X-Forwarded-Encrypted: i=1; AJvYcCV7doR57PMgAjppYvubTqfsXmwn8vBqhn7lq7zYFlfCTAQg3dec41VoifE67SZ4+6E50zPsys9iQEXv@vger.kernel.org
X-Gm-Message-State: AOJu0YwgqtoxS0J8g7uRleCLeqPQn+yz+5AO12ccmqT6GeoxA7xdmNRs
	xUMzeWFnJfb2h8Svd/IlANxTODR8LrOWgLK1XCO/y3vBouXENBBHjEM4hRICCuA=
X-Gm-Gg: ASbGncsNLuAjodF7gEzap3X+9B48pXuXaQNXEJXLu+R0Xb/pvaEgIP0FQbhV5u1//os
	5eldDohQ03TahoY+cxFMC138H7cLjJmJV0Pv4Ld8KBnpHU73RNfCqZGKNR3eApaoYcFCshMDZYr
	p/lPnUoevdo5yQym9r7D5wyLZUfm2m09qiKqT1L4P8OOOM621t+X5PvpuyhXC+iZgmqpzGRAlLs
	faAA/4e3bgreWIPtWS67M1/gwe+SX1P0CI5Txv0TRKiqndlCYmOtQ==
X-Google-Smtp-Source: AGHT+IGbUIhQt+NmU6Ty8AsbZUK4QX8PVpa2MQ6807ZaW4GZZtqaj/V1iOL+AEQgWtkLEp0uvi2abQ==
X-Received: by 2002:a05:6000:2cd:b0:382:3754:38ed with SMTP id ffacd0b85a97d-38260b6ae51mr4512074f8f.21.1732317872104;
        Fri, 22 Nov 2024 15:24:32 -0800 (PST)
Received: from precision ([2800:810:5e9:f3c:e019:b39:5a90:cfe])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fbcc1d22b3sm2244984a12.19.2024.11.22.15.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 15:24:31 -0800 (PST)
Date: Fri, 22 Nov 2024 20:23:53 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Paulo Alcantara <pc@manguebit.com>
Cc: sfrench@samba.org, ematsumiya@suse.de, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/2] smb: client: disable directory caching when
 dir_cache_timeout is zero
Message-ID: <xb4fyaabfrm6p3tuzlwtdbv74pcw63t6rjbqnrgzftm2xaeq4r@wla6hlp6nb7a>
References: <20241122203901.283703-1-henrique.carvalho@suse.com>
 <7e76e6d3a5a194b87ae98e13c354a4f8@manguebit.com>
 <cpbqdqjvgoaamvhg262ruhcnkilrns3gwabcwjgihsvjx7yict@jqzjvkkutjta>
 <f1809e2140cd1d942b0930996ad5740f@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1809e2140cd1d942b0930996ad5740f@manguebit.com>

On Fri, Nov 22, 2024 at 07:55:35PM GMT, Paulo Alcantara wrote:
> Henrique Carvalho <henrique.carvalho@suse.com> writes:
> 
> > On Fri, Nov 22, 2024 at 07:07:06PM GMT, Paulo Alcantara wrote:
> >> Henrique Carvalho <henrique.carvalho@suse.com> writes:
> >> 
> >> > According to the dir_cache_timeout description, setting it to zero
> >> > should disable the caching of directory contents. However, even when
> >> > dir_cache_timeout is zero, some caching related functions are still
> >> > invoked, and the worker thread is initiated, which is unintended
> >> > behavior.
> >> >
> >> > Fix the issue by setting tcon->nohandlecache to true when
> >> > dir_cache_timeout is zero, ensuring that directory handle caching
> >> > is properly disabled.
> >> >
> >> > Clean up the code to reflect this change, to improve consistency,
> >> > and to remove other unnecessary checks.
> >> >
> >> > is_smb1_server() check inside open_cached_dir() can be removed because
> >> > dir caching is only enabled for SMB versions >= 2.0.
> >> >
> >> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> >> > ---
> >> >  fs/smb/client/cached_dir.c | 12 +++++++-----
> >> >  fs/smb/client/cifsproto.h  |  2 +-
> >> >  fs/smb/client/connect.c    | 10 +++++-----
> >> >  fs/smb/client/misc.c       |  4 ++--
> >> >  4 files changed, 15 insertions(+), 13 deletions(-)
> >> 
> >> The fix could be simply this:
> >> 
> >> 	diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> >> 	index b227d61a6f20..62a29183c655 100644
> >> 	--- a/fs/smb/client/connect.c
> >> 	+++ b/fs/smb/client/connect.c
> >> 	@@ -2614,7 +2614,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
> >> 	 
> >> 	 	if (ses->server->dialect >= SMB20_PROT_ID &&
> >> 	 	    (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING))
> >> 	-		nohandlecache = ctx->nohandlecache;
> >> 	+		nohandlecache = ctx->nohandlecache || !dir_cache_timeout;
> >> 	 	else
> >> 	 		nohandlecache = true;
> >> 	 	tcon = tcon_info_alloc(!nohandlecache, netfs_trace_tcon_ref_new);
> >> 
> >> and easily backported to -stable kernels that have
> >> 
> >>         238b351d0935 ("smb3: allow controlling length of time directory entries are cached with dir leases")
> >>
> >
> > Then I could split this into two separate patches, one with the fix for
> > the mentioned commit, and another patch for the changes in cached_dir.c
> > (which I still make sense to have).
> 
> Removing is_smb1_server() check looks good, but the other changes don't
> make much sense as we could potentially return -EOPNOTSUPP in
> cifs_readdir(), for example, and -ENOENT is probably what you want.
> 
> Am I missing something?

I might be missing something, but only place I'm changing the return
value is in open_cached_dir_by_dentry() so it is consistent with
open_cached_dir().

open_cached_dir() already returns -EOPNOTSUPP for these checks:

 if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
     is_smb1_server(tcon->ses->server) || (dir_cache_timeout == 0))
         return -EOPNOTSUPP;


The changes in this function relate to removing unnecessary checks.

--
Henrique
