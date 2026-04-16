Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F3D19539F
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 00:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776299146; cv=none; b=SSHLR/iNEV+i4E7dSdf/DuQxS5cYaIYxfZlaD7hqXdLmaPIriVvg4SyKc8dSRCxfYx5Swiw5fS8OXJAV2cexGt3DYulOoaBjQseMD72e8O+aO0cwRMnOyjDNHbjz5wcAXi91uAB6htjtBktE5A/ciL8Fp8lfhJSyDSm+XD8D9eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776299146; c=relaxed/simple;
	bh=AXyNXjDfVtCE0ZrJX0GJ8x2yqOZGd7+QRmcScIvKqZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UrxKejv19RyzXoeXr2zR1jEnbvHvofyzZRwIuSc4hQA2R47B0b8Z217oASSG7jiiNkNJmHilTGOfRTiCsHmZFAWxM35NKIViJ0U9dYrWGEybV7xTtrP04fmZSL6wh3T46hGbNmghMhOpXtt5lYLBIz5bfgM0Gdm9YzBil2dnDMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f+UuA9+c; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f+UuA9+c"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4887ca8e529so718985e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 17:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776299144; x=1776903944; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AXyNXjDfVtCE0ZrJX0GJ8x2yqOZGd7+QRmcScIvKqZI=;
        b=f+UuA9+c0xT+BHjeYoCfkIMu3defE5bzqQgNgayWkEJZ034Y7uKMKXw/wYmB0tQj5f
         Q/p0pBK63nCtlV1o0MrVzUZ9gis7HEcopv+TiKA7lDMwbcRSuYJLCIxGmT+o9qaz4mtm
         z4YnN+DG34KKEasOnX/Iv8COGepeP1DyILPNM/EDgbM9l/uqqsWQYehnCuDLsBuAKrhE
         ZafwX3FWgMTrOjtU1p1Mslhv42vebdtaKm0OWSS+rnMwqwAT+az4EF6ghljSOhX6nDSL
         akJVnmz697ub7ZkRfDqwSWnXOXM22BPc3zhFV3CnmUvvQk837dWLCnfdUQnWisD+RSNW
         TGaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776299144; x=1776903944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AXyNXjDfVtCE0ZrJX0GJ8x2yqOZGd7+QRmcScIvKqZI=;
        b=Tp0ntUQ562zWVyrLNJGDfIKtRtYZ5aQ2vXS3mqzIhc2ZfaLiwGWxFhtNBSXtr4uKEG
         tpZhK7ssaoe358kDhxxuT6a/mgNQIH9CgseWlasib/M+zspz7UapTpN055JSmup1m+9H
         YQuV1rHxRhxP8tjW01WE6etrJxSOfCZ69EF2esFJ4KhmMHXNOAoXJQ48vtCXoSEj/pxE
         DsDSNk9VJK66EdwJrsRq9bpkLkgFwx+yMLyDG6B7DUmKrki5J/CFyTz8r7W+ZbyoB23K
         vgHgpic1NdjkEGKPMhrMEP8sIFUXXXPGPhH/X50FmxDviKAQgYR/dCl2htDuzy63ichY
         VfUQ==
X-Gm-Message-State: AOJu0YzrHbylXXgyyMxtAu/Ax32YFV8AMMs8qqYPCCfLigZkreUdiyr3
	SIuU6Bmw2Yot9Zxo/jz9M+Be7Lu1fe2PXq7pliNWjF2Zh8dlRhelpK/nQIlj4seL9YI=
X-Gm-Gg: AeBDietCEw9QQskg/2ybaWR48vg31caG7DqNxZVptbKW+qa3JZhgfkVlhiPGTJjydng
	G4Hoed05rPbsqThEj2i3sYhr2TC9Q088BGLjc5zvRwi0sPARUQ3Q0y4v7VbGDGbFFs0gRe8AtnN
	HPTeyc8z2WXREPJ9b6y+GGkyyLAj8BNmI6WJLstxFTY9N9cBXAiwir8rC03SIAOev3izsQmDOMs
	fZEwy4l0Z6dxDJ8aRnnkvAUxoYBii3U2PJi7R5KksHUJiIeEg7KjnnAVGbhzwG1AcHiO/xA8ZLt
	KvGwrxjMOXRXoYCvea73cEuxnZRuimhiasQ91FyH8afxvN8fVrGWjP16lIYN3DkR8Rt6i0L5uyy
	GY2KEknopoU+IgiO3CDMu/yhH0CmdPDp2liG1YVnTdG0EUJ2kuftGsiT0sZeMJqrFji+vYCODYx
	8k+sW5i3HRMSFTGYpamKd5COJl4q5vz0yvwU88ggs1ww==
X-Received: by 2002:a05:600c:a101:b0:488:9ec1:4976 with SMTP id 5b1f17b1804b1-488f45c6406mr15939765e9.8.1776299143583;
        Wed, 15 Apr 2026 17:25:43 -0700 (PDT)
Received: from precision ([2804:7f0:6401:5290:433e:afae:f475:c9f7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c5e62b9d1sm4019937c88.5.2026.04.15.17.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 17:25:42 -0700 (PDT)
Date: Wed, 15 Apr 2026 21:25:36 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Werner Kasselman <werner@verivus.ai>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	"sfrench@samba.org" <sfrench@samba.org>, "pc@manguebit.org" <pc@manguebit.org>, 
	"ronniesahlberg@gmail.com" <ronniesahlberg@gmail.com>, "sprasad@microsoft.com" <sprasad@microsoft.com>, 
	"tom@talpey.com" <tom@talpey.com>, "bharathsm@microsoft.com" <bharathsm@microsoft.com>, 
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] smb: client: fix OOB read in symlink error response
 parsing
Message-ID: <adk3zcdqpl34l4ggvady2dbkb74gzxmhilolvchvhbmeubekix@q2u4fk73bzpv>
References: <20260414115040.552945-1-werner@verivus.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414115040.552945-1-werner@verivus.com>

Isn't all this fixed by this patch?

https://lore.kernel.org/linux-cifs/2026040636-icy-constable-9e17@gregkh/
