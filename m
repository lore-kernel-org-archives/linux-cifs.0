Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF4F4438F;
	Thu, 18 Apr 2024 04:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713416296; cv=none; b=CDZr5Mm5tC+VMbGQislnjAWMRVFip5f1+Fj+X0fxb40eYuaLNpD6GyPf+v7vBrDilEN3da2BIOpKijUuKIaYkps88Uc3fX4zrskY7h8dh9O3QW610ds0FFwMKRtNXlm48VNoDLGrIdGg/0cU98VCLrnYvQPLbGK/G0EHaCE7cUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713416296; c=relaxed/simple;
	bh=1GIfnLR14SpISzBtJDNhW/puZNUl+1Lzin0dxK/lgws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EYx+62IoSDYIb8Jiuw+zkokWRRnLUWPY5T9CvuRXPQ4ilSH9cATWAGc24xxOQpIU28ZcCRV7Gx3blZnJAUrxSIjHMNQCpjVNqgR8MFAyPoRR9bTuVzqtmxliAxWVpr+rsJ3dCI8lJEQLsvmMuO9NDn4rLG9wqnq5BRlJF5V8XrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XIQ2q0Hl; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XIQ2q0Hl"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-56e6a1edecfso559773a12.1;
        Wed, 17 Apr 2024 21:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713416293; x=1714021093; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SL2uiIXH35aGZc0Hh8VLlfK7Ln3jRKiQNAg1SPvfYcs=;
        b=XIQ2q0HlaGbtjmZ21Re7qDfJ07IUir6HxGMZO8DD/KJMbkvHUUx1FwUEGFLgSTstcW
         3JruC8Vbj2t50xwTPE/rTHLVJFvTrTmW3TI7AC4wMsvFBhD+Ms3qVPBmP6/0fhRDl00j
         rr90Psjyr0w2LECN31IRNuJdWz6E0bnob0JBVl/xMCHiLPyYlGzcZ8aYB9sosxIAVxLP
         PUEidWZfJvLPngn220UT4uqazCOI8bkbOSh0bezS6q8k1enVhMXAJXTfkhTXzLZu/j6v
         9OTkz+rrDjOmab4LPueY9tdKpFL4Me5DtAw+Lr3Nzbzzmtzt7TEp9MuE2Abls9xknyQG
         pRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713416293; x=1714021093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SL2uiIXH35aGZc0Hh8VLlfK7Ln3jRKiQNAg1SPvfYcs=;
        b=IIeFfg6WL7z6PtuzlyqvfP66YLIwh1d9iASwsmDM/CTveAdtENixSxV7VkK5vEUONk
         mhVIQ3DTvhPZy8uwrJ7a4OvH5SGYylI5cC01ld/y01klUer4nZga3cRgP1OvxmzVIYXf
         6GWnbVz9FkbCMwU+x3xaHfMs1ha/rplrRIaYjIwXrsIY1K6Mzyoj4zXhJTUBjXjamEbU
         +T8GRQW8/losJWt2kZrsFH1N3l00BAb0E3nvjDEVO2EiJserLAgnb/aWZMC/gWkwcjUS
         zZSbfsg+AUJV7sh2EkTUIO5jb2mIG4wPYZNI8fJgNmfQbhjW8lAf5spuCh0MqGp7dtkd
         YXNw==
X-Forwarded-Encrypted: i=1; AJvYcCV+8fAerK6ZIWZlc2pNp9c4S73UOSl1gUqHIyyyt0rZlUkqMc9zn7lLJm4ZKyL0i4pWfM6J0uQKvH+FxovnLjcHzmeLKElvN0M4X8mg4PsS4xsRX8g2Hd9B/xoQWjkeQmnqag==
X-Gm-Message-State: AOJu0Yxx5OuAS3s0KfXnM6ugZzhhGZEvSskLz41v9dPXdOtXvPuRLMbg
	UQxv+MCmiG2Hn76/VdY9sbMRWWeEz1PxIFEZVGFanVIVoPKoanbk
X-Google-Smtp-Source: AGHT+IHz0IE74OUzjcYa9ALlwnqFMHsbPsP49is02/FUiFH1TdkJ3Fu4Hl774aOUHaxTCJ5ZuqG6xA==
X-Received: by 2002:a50:d4c2:0:b0:56e:2abd:d00f with SMTP id e2-20020a50d4c2000000b0056e2abdd00fmr1172402edj.18.1713416292503;
        Wed, 17 Apr 2024 21:58:12 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id d15-20020aa7d68f000000b005701df2ea98sm383140edr.32.2024.04.17.21.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 21:58:11 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 1C0A9BE2EE8; Thu, 18 Apr 2024 06:58:10 +0200 (CEST)
Date: Thu, 18 Apr 2024 06:58:10 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: regressions@lists.linux.dev, Steve French <stfrench@microsoft.com>,
	gregkh@linuxfoundation.org, sashal@kernel.org,
	stable@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: [regression 6.1.80+] "CIFS: VFS: directory entry name would
 overflow frame end of buf" and invisible files under certain conditions and
 at least with noserverino mount option
Message-ID: <ZiCoYjr79HXxiTjr@eldamar.lan>
References: <ZiBCsoc0yf_I8In8@eldamar.lan>
 <cc3eea56282f4b43d0fe151a9390c512@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc3eea56282f4b43d0fe151a9390c512@manguebit.com>

Hi Paulo,

Thanks a lot for your time on looking into it.

On Wed, Apr 17, 2024 at 07:58:56PM -0300, Paulo Alcantara wrote:
> Hi Salvatore,
> 
> Salvatore Bonaccorso <carnil@debian.org> writes:
> 
> > In Debian we got two reports of cifs mounts not functioning, hiding
> > certain files. The two reports are:
> >
> > https://bugs.debian.org/1069102
> > https://bugs.debian.org/1069092
> >
> > On those cases kernel logs error
> >
> > [   23.225952] CIFS: VFS: directory entry name would overflow frame end of buf 00000000a44b272c
> 
> I couldn't reproduce it.  Does the following fix your issue:
> 
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 4c1231496a72..3ee35430595e 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -5083,7 +5083,7 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
>  		info_buf_size = sizeof(struct smb2_posix_info);
>  		break;
>  	case SMB_FIND_FILE_FULL_DIRECTORY_INFO:
> -		info_buf_size = sizeof(FILE_FULL_DIRECTORY_INFO);
> +		info_buf_size = sizeof(FILE_FULL_DIRECTORY_INFO) - 1;
>  		break;
>  	default:
>  		cifs_tcon_dbg(VFS, "info level %u isn't supported\n",
> 
> If not, please provide network trace and verbose logs.

Yes that appears to fix the issue.

But as you say you are not able to reproduce the issue, I guess we
need to try to get it clearly reproducible first to see we face no
other fallouts?

Regards,
Salvatore
