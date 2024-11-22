Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B999A15B13B
	for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 22:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732315093; cv=none; b=k3mSphrD3COlqpASMr4xD+YLSp8SXy1Qrhna0OZmR0fTJBXMtzynQYfjNbX2LFui5ezUaslpAwCbU6+BNSuMXMgRDVGn0phSKpFGQ+QTlMCfR0uVOnvO3H43xwuWT/DIbdY0S5lzW92oRevzaVR21/3Zqd8scVECs4gwNZOp1F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732315093; c=relaxed/simple;
	bh=ZcXmqTM6XssFPQrNMsDQAaGrYYRY/zE5alKaSUE3g7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WuTNsGgmMDrauRO7JM00jZrZ58L2qHBA29zLd4pVCd4mX7uRA/JZKoO7EiLv/ZV4HQEPMDKc0NKbBpuh7S+iUiBzmo7kDLacKuIWno/2S6WThi/WIbr5JQxTIFg9q3FPlEKy3WRLx3skIjNYT9X2cP+X36b7sEOsOge6aroRV10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C2WodXoT; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C2WodXoT"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-38248b810ffso1851869f8f.0
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 14:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732315090; x=1732919890; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9i2jYjItWtjPs0Cmoi4DVMBe5IOhMoye9pY0/DQyGS0=;
        b=C2WodXoTiTMi/g33UN8xgh8uXfwU03s9XQDvYiyYIiB6sQvtzGqPgKqZmFSbDwfAN1
         aX26CyH3LZR2rSeX76+wGmVr/C68ALQt/JOuv6PVQIS5hS6IjclWoAyg56WErTnQJ74E
         U8+FCmGidPzJzKVCAqQsjqS7qdvxZv34Ho502mpYRcPgFaLnreY3ZQb5b57tZLwEzIW8
         uOP+domOopwuzEiKIJNelPcgfifIMubKnEiJUIgrPfkopwTcB5E1u+0SUzpquq5R0SOn
         ya3+ojD+I1+K4rBt3XLmo1JDNFpf19e6Z7Fo8f4zjzoz5YPt+1aWApXVQFwxjF/PJWVE
         NyXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732315090; x=1732919890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9i2jYjItWtjPs0Cmoi4DVMBe5IOhMoye9pY0/DQyGS0=;
        b=wfZ5ImVAS/ruTV5QkOdoOR7q813cjkEZoDzLabb4vxEV1ndBJ+OgIGqPNr7K7jh/25
         qVE4RD2UaS8UY06sEv7zN2lAa3E+3H38QIBRdVHyx6uXbDOPU39yVOWdTgWn3eeT/CzD
         BUi3novd8K/Pq0K1rrQe0MhKcx390CCiLH5yFTDFGh6/Xf9cpNHWrTPNKOdTKB70dEAr
         NV2tsYapZZg4towRyl7EhhHRwjbMWwyv7B6bSCwu/qWS3ctS31t/WKKMqzrG9Sk1ZJ3o
         vM0iZcFG8ibW+VwNAWk42/NPoOqTiudE0SQr5u4T9R6lQlhbXf8TKgHE1jD+p63dGHea
         3xWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsKxEOLhgLwnxhrOmeD2JS/zuM6S7SAqmsNTbt5iDRV3yZBI9+FcnU1gKRdEWQWch2YoZmnAy6WkAg@vger.kernel.org
X-Gm-Message-State: AOJu0YzlR2XIUl8Spc720M2nsALL/Vve6fzLF99MKLvez6mbFwLag0sW
	g96rivIg6zLysRnJHfhLAykIwgpHSgasfRqqFn1EAxDSLhDMS9PGJGpBPYV7g4E=
X-Gm-Gg: ASbGncv6gNM6agSL9Pc/mbK23ohxPazZ0+iIugwxx+lGsqp+5pQQQMO7N6KYgFM2qBB
	8vwh8DOX3oyDWY+5/S1gzfZ+qgrMvF2vPGciezkklZSCJLruBTuMlPxXqeUH5A0BG20NR3dzUru
	ttzG/yTMBVqADTjcpeyFomatL1BmvjBc07BaLMCJN2DQoagHgy97SCL2t8y36DQqtGOABPp7tj3
	YI6L1Uop5isOnh/5lzOJB5bVA2ftOSW/98YnhX0rw8eyr6UIZbt7Q==
X-Google-Smtp-Source: AGHT+IEmnmxgK76KlPaJWkm2h8/ys39WjwTg+oySmO1EkS11d2rzDVCrPV5zeoCPZrBjBgenc+Jg8A==
X-Received: by 2002:a5d:6dab:0:b0:371:8319:4dbd with SMTP id ffacd0b85a97d-38260b58319mr3244537f8f.17.1732315089872;
        Fri, 22 Nov 2024 14:38:09 -0800 (PST)
Received: from precision ([2800:810:5e9:f3c:e019:b39:5a90:cfe])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ead031523fsm5671903a91.19.2024.11.22.14.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 14:38:09 -0800 (PST)
Date: Fri, 22 Nov 2024 19:37:29 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Paulo Alcantara <pc@manguebit.com>
Cc: sfrench@samba.org, ematsumiya@suse.de, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/2] smb: client: disable directory caching when
 dir_cache_timeout is zero
Message-ID: <cpbqdqjvgoaamvhg262ruhcnkilrns3gwabcwjgihsvjx7yict@jqzjvkkutjta>
References: <20241122203901.283703-1-henrique.carvalho@suse.com>
 <7e76e6d3a5a194b87ae98e13c354a4f8@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e76e6d3a5a194b87ae98e13c354a4f8@manguebit.com>

On Fri, Nov 22, 2024 at 07:07:06PM GMT, Paulo Alcantara wrote:
> Henrique Carvalho <henrique.carvalho@suse.com> writes:
> 
> > According to the dir_cache_timeout description, setting it to zero
> > should disable the caching of directory contents. However, even when
> > dir_cache_timeout is zero, some caching related functions are still
> > invoked, and the worker thread is initiated, which is unintended
> > behavior.
> >
> > Fix the issue by setting tcon->nohandlecache to true when
> > dir_cache_timeout is zero, ensuring that directory handle caching
> > is properly disabled.
> >
> > Clean up the code to reflect this change, to improve consistency,
> > and to remove other unnecessary checks.
> >
> > is_smb1_server() check inside open_cached_dir() can be removed because
> > dir caching is only enabled for SMB versions >= 2.0.
> >
> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > ---
> >  fs/smb/client/cached_dir.c | 12 +++++++-----
> >  fs/smb/client/cifsproto.h  |  2 +-
> >  fs/smb/client/connect.c    | 10 +++++-----
> >  fs/smb/client/misc.c       |  4 ++--
> >  4 files changed, 15 insertions(+), 13 deletions(-)
> 
> The fix could be simply this:
> 
> 	diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> 	index b227d61a6f20..62a29183c655 100644
> 	--- a/fs/smb/client/connect.c
> 	+++ b/fs/smb/client/connect.c
> 	@@ -2614,7 +2614,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
> 	 
> 	 	if (ses->server->dialect >= SMB20_PROT_ID &&
> 	 	    (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING))
> 	-		nohandlecache = ctx->nohandlecache;
> 	+		nohandlecache = ctx->nohandlecache || !dir_cache_timeout;
> 	 	else
> 	 		nohandlecache = true;
> 	 	tcon = tcon_info_alloc(!nohandlecache, netfs_trace_tcon_ref_new);
> 
> and easily backported to -stable kernels that have
> 
>         238b351d0935 ("smb3: allow controlling length of time directory entries are cached with dir leases")
>

Then I could split this into two separate patches, one with the fix for
the mentioned commit, and another patch for the changes in cached_dir.c
(which I still make sense to have).

The other changes are mostly cosmetic and could be dropped.

Sounds good?

--
Henrique
