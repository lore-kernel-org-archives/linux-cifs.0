Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D062E149C4A
	for <linux-cifs@vger.kernel.org>; Fri, 11 Jul 2025 16:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752249713; cv=none; b=Oq+04rOtKuqElStZuWBanbZ3GdlvlPtbaV6K6OHquzFQCP7vZBcxerrEcmQ0SkNxll3M19w6XCP4OnEB849AmaPKY1iDe+QW+6H27xQbeV1pbL5hZCZNcvZJ+K98GZNcAu+E/Wymv+0dMosJ7/u7Muw6m3918plMknLVZu3SEtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752249713; c=relaxed/simple;
	bh=+Ou+0IpA5NqFLd6uuzPDHUs6zJKRI695n/2myCKDpMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVT64Upzij8RJ+e55tT1qJVEFwh9FKVe+KQ7tKz3jcMnm2MbjODyMpMZrywGaGwpAKcLAY24AUl6cT0/hbkcotbd5pnzhUBHjyCpQ3jieLFROW4IVcLZR5f02D2Bhee1wYFkChjw21Dy5RKvNFXSGis7BAkT9gYHPqeBOudkQLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LFlDkTo1; arc=none smtp.client-ip=209.85.221.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LFlDkTo1"
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-3a6d1369d4eso1369084f8f.2
        for <linux-cifs@vger.kernel.org>; Fri, 11 Jul 2025 09:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1752249710; x=1752854510; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SfzvTx6PbZXDwLOdzidNW/W7RYVUXx9hspSggUOo04Q=;
        b=LFlDkTo1HX56SN7meX2Y9ubyM0whFQWNuD8arX2Hg8y2mwfGEXxs4p/EZ2i8DI0dtn
         RyNabw5NPiM5eeus/zfh56WxJEOv3csUfzuDj/RpZ/cn19wb/9kAYr23ZmsrFR/Uc3fK
         tTJ9ogWC/zZjCwEG2ooTcp9JUN2yKvfjlBEziLV0s2C2iTp8f4XydwW2qJwxqNUiF6V0
         KM8I23jf5tQbdh/vm3V3nEtS7snbnDuEPDBEQKqFDk+41mWJy5vzlczB/3fjWLM0+t5W
         KKbPwOIuiDN2BXW5ZHWY01BSt5k6q22++IHmOZYpX0HNzq35K9iwkbv21oqiiSPMjVCP
         B8Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752249710; x=1752854510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SfzvTx6PbZXDwLOdzidNW/W7RYVUXx9hspSggUOo04Q=;
        b=UqQdc+3EoSwJtLO+u4vJp0uWEo4ilCRjjG9YJl1pvB0XiTwi8UE67yIQzNt0D8vGUl
         QJUvBF78B+QFFwr0N2SxOxqoHI+pzwwpUbtNmewserqk7faYs7Qx1us5yH8DBmOanR39
         jcOxBvKS/QTLxZQ8NB68kwibyB1fKcIiZA74eO2oAzmsB28fX6l9ss5gG1ih8BSt7zSl
         fPPg6uHSMUKAEudVMvo1U5TriBftezfr0qZqxD4QWeWx8bEAm7t5h6MTy2C3Dxg9Myts
         ZhNBP6rmTLIIH+7iEjGIUNMKnpaWT0wQRqgqoIKHAz6hSMYu9401b08u3dyBZWeBwf3a
         95WA==
X-Forwarded-Encrypted: i=1; AJvYcCXJ5+uw+oND0RyDmCxkI8NaFmcGO01VbSJT+jyF86qJqfLJp+hUVJdhJ2sItO0RGwF5BCGsEI4H9JVx@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6F6ZxO5S1JVCld53iSeO0Nos1ddo486OdeY9tPAINi2Ici+nE
	b+BLrHoCBvm2YQ/V4m7LEFZClWF7oUsQ9XsJg+4v6pSNmRTD8Cf2T4cE1iWfWYwiNDleJ/wCLVv
	rCC5aXvarVA==
X-Gm-Gg: ASbGncvH2Ty1DVPgdWXt9lVpgH/GSuy4M76DY3KGeil5QvHUhAx32NKLkR/v0kMs6nm
	/YzFz+Ofp/gp5HlM0EJyATgdO8STkL84Z3ewpnpLXSF0LY634LK4z7LkL0lusczkM/swvKB1Hid
	lR4XukhBmF5I9KCzwrq9hjRLYpCS304bI8jv6JBIQPTJbv7tXYW+/UDMaczlqXCZd9475jYTxZa
	GuhWrRt9PaSW+rdZL4BXV6nrcewTY4xSpxCk8lTTU37+XTsm/Y2Q0uUzmpDFYOwV289hjRVO9yr
	tLfDbAibjqcXd3oWzv0J9EkiCiW3A1bVTWGvc7VeInJJGVhnAHltkUXzwxtzXrtnn5zDYUysX35
	+d3WxUj5Fu6QbeajgoY8dZWA8AuASHC0=
X-Google-Smtp-Source: AGHT+IGVE/TqkveogVzDWlQtprwEsaxc2e/30UrrYvMU03kHlt0fJ8uctIWNIzx+f4bYJUmlkYcLOg==
X-Received: by 2002:a05:6000:18ac:b0:3aa:34f4:d437 with SMTP id ffacd0b85a97d-3b5f35783abmr2762577f8f.37.1752249708422;
        Fri, 11 Jul 2025 09:01:48 -0700 (PDT)
Received: from precision ([2804:7f0:bc00:fc9b:1aa7:f529:d2f7:747d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c301cb550sm8511080a91.41.2025.07.11.09.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 09:01:47 -0700 (PDT)
Date: Fri, 11 Jul 2025 12:59:55 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org, smfrench@gmail.com, linux-cifs@vger.kernel.org,
	Laura Kerner <laura.kerner@ichaus.de>
Subject: Re: [PATCH 6.6.y] smb: client: support kvec iterators in async read
 path
Message-ID: <aHE0--yUyFJqK6lb@precision>
References: <20250710165040.3525304-1-henrique.carvalho@suse.com>
 <2944136.1752224518@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2944136.1752224518@warthog.procyon.org.uk>

On Fri, Jul 11, 2025 at 10:01:58AM +0100, David Howells wrote:
> Henrique Carvalho <henrique.carvalho@suse.com> wrote:
> 
> > Add cifs_limit_kvec_subset() and select the appropriate limiter in
> > cifs_send_async_read() to handle kvec iterators in async read path,
> > fixing the EIO bug when running executables in cifs shares mounted
> > with nolease.
> > 
> > This patch -- or equivalent patch, does not exist upstream, as the
> > upstream code has suffered considerable API changes. The affected path
> > is currently handled by netfs lib and located under netfs/direct_read.c.
> 
> Are you saying that you do see this upstream too?
> 

No, the patch only targets the 6.6.y stable tree. Since version 6.8,
this path has moved into the netfs layer, so the original bug no longer
exists.

The bug was fixed at least since the commit referred in the commit
message -- 3ee1a1fc3981. In this commit, the call to cifs_user_readv()
is replaced by a call to netfs_unbuffered_read_iter(), inside the
function cifs_strict_readv().

netfs_unbuffered_read_iter() itself was introduced in commit
016dc8516aec8, along with other netfs api changes, present in kernel
versions 6.8+.

Backporting netfs directly would be non-trivial. Instead, I:

- add cifs_limit_kvec_subset(), modeled on the existing
  cifs_limit_bvec_subset()
- choose between the kvec or bvec limiter function early in
  cifs_write_from_iter().

The Fixes tag references d08089f649a0c, which implements
cifs_limit_bvec_subset() and uses it inside cifs_write_from_iter().

> > Reproducer:
> > 
> > $ mount.cifs //server/share /mnt -o nolease
> > $ cat - > /mnt/test.sh <<EOL
> > echo hallo
> > EOL
> > $ chmod +x /mnt/test.sh
> > $ /mnt/test.sh
> > bash: /mnt/test.sh: /bin/bash: Defekter Interpreter: Eingabe-/Ausgabefehler
> > $ rm -f /mnt/test.sh
> 
> Is this what you are expecting to see when it works or when it fails?
> 

This is the reproducer for the observed bug. In english it reads "Bad
interpreter: Input/Output error".

FYI: I tried to follow Option 3 of the stable-kernel rules for submission:
<https://www.kernel.org/doc/html/v6.15/process/stable-kernel-rules.html>
Please let me know if you'd prefer a different approach or any further
changes.


Henrique
