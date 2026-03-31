Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4CF4418CB
	for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 18:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774980392; cv=none; b=j329kTCPWGHLpc971cP3VqZmpurQ+UEVZQBM8E6KGEibj65krkV3LJe6c8DBhTtAQwBjsixINdWThUB55/p20ubKG0mPNN8A8fokjvB4wQIY36+11izpN9s3Nhcwecslcd42gOi8582DMx2rS/6oJgwkFx/tmQNZ2j1h1rEdXKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774980392; c=relaxed/simple;
	bh=rMzw+RpXp4B2DS3dLv4zrTvfy9WXunClYqK9jcKgsyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B2ipRa0YNrh/AxDXGXXmeX0Ggzi3rvcUDOr6+URJeud7a77nUHUHjNsQzynQeqL+26ZSvCAeJtwGU1lBEP9TK2U7Iezt850BA5U1rjJySP3D9R4EUXh/jehUVkUXaZaAjpWEdLsKL+u2vS5395JxOCCGYvHc7wsNMwDuAlmAyCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=e3e93FRA; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="e3e93FRA"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-482f454be5bso1571305e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 11:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774980388; x=1775585188; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9mHHngYhGkgU6UBtAkTjUhy7ti6I8OZErZ58HIgxmzw=;
        b=e3e93FRAbtfG8+zsF0TQqfphpd7iL902Zy/XP2pmwhc/BaFWRe3ZrZ9SGgnJybOBQr
         FOxvpZtcD7O9fFXOsNEdHlI0NFHvr3EHDPFRcFVign/rLIyKfgeOBkOAYdcVf5ToO0dA
         C5rJxxQ9eu7P0k/IaZb6Ku6xK7VaPsLsCvlv0Y9Rjz6fg4QnHkeaFNJcwPCArPmF547B
         kdQ6AxMxfm/boCGd44yNOhHhKDmBD1GvUYnNuxLLPy1mHHcb/UB28I4swN8j7OFbCMHg
         g5QUI49JaBmrdLK4hFrVRuZ7Sp4oGP3CfqvcWrTFLWvEv9ZQ35MTgg2DRAJwPhGMqQKU
         GZtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774980388; x=1775585188;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9mHHngYhGkgU6UBtAkTjUhy7ti6I8OZErZ58HIgxmzw=;
        b=OZiSJJnStBIcFfGh8hu9lJ87dAsa9sj11hRzOEJApOUeZv6zJzjIcqzRG52l0Ah/1V
         aMy4vFHEclw7Es21bWAa3HXs2F3cyw4YQCoCsoPNFpepShMaCUM/eGGEdMTMhHgmKX8S
         efr4XcKPL+x/YnoheUXqlT49TwAh+ksl/Abx5w/jzMPjpSgFevxgGCX8kjietv0S8g3H
         3adDos/MzDFCwZEwMaObAggdmtaT9ZDtS4HaCPjIh366hAibxhGgUZRJ4UCTu7GrldMN
         KRwn1OMMWHIS/NVGMeT/gJTCmjfEeT6W8MQWfJjPYNfINTPInclneJbB6/JP2VGvY/Bk
         WVMA==
X-Gm-Message-State: AOJu0Yzkz6LeYnLQMca+iZVQ/oa7a6Z7rBKdwySb86TNsvUiAfmoGYDA
	1/rDDRv8rDurxwrWxrDwKX00pPdyNaIEzZFcsTjPW99c3ob/91svys/Zh9Cgg6geCEE=
X-Gm-Gg: ATEYQzxN3GVyyOrUZ8NmSKeNwpB7c0qJnp11MetxuFzrxLckqjPiVHb7GTKgSepTreP
	o8bAcxX20G5mwZ5+cHDzulqdpOAdTOuD9R7hzjQiGumZNDkQKomMgvrbJo82biXIQUWWFXAYAyY
	O17tZHn3hylKn20gMF9DcLuzl9FyUMDR6Hr8dxnokcLjYU+NxoWbILruEbEUySq5vxP6/JDPA6D
	gIexkE06/2FMVuq/3lGNTuEnklArvpgFou7NEE2+3BR2v6it02WEOqUTBUUPPn8w1nUMC5tohag
	z+GQZGrCLgzbF6+7TGHpC1OTN/IEUAQ3mDLWSFQc+Eam1YL8Ue4o4j3MuM+WV8PaHc17zV1WC5M
	5cnZwol32kyM3bafpXlG7cORP5kaakimFF6YE6jEMMdPZRJvDWych7UfUhBelM7Iin6+//c9ycs
	Lt1nxYVDClsS0XFkZfLeScoQpqlwxYFclGUQ8UxOCszN4RPN2faG3NJOY=
X-Received: by 2002:a05:600c:590b:b0:485:39b9:9680 with SMTP id 5b1f17b1804b1-488783f32ecmr61081885e9.16.1774980387845;
        Tue, 31 Mar 2026 11:06:27 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6400:80bf:5df9:f3dc:e523:9865])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9539e2a0285sm11574614241.6.2026.03.31.11.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 11:06:26 -0700 (PDT)
Date: Tue, 31 Mar 2026 15:06:22 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: David Disseldorp <ddiss@suse.de>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 0/3] mount.cifs: minor buflen tracking cleanups
Message-ID: <rt2s32lnxvi7rfhmoqpvujls3shmbumor4imura7ryvaqizbcf@qc74gdiyr74k>
References: <20260331012508.17410-1-ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331012508.17410-1-ddiss@suse.de>

Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>

On Tue, Mar 31, 2026 at 11:37:50AM +1100, David Disseldorp wrote:
> These changes are minor cleanups to go atop the bugfix
> "mount.cifs: fix buffer overrun in set_password"
> https://lore.kernel.org/linux-cifs/20260331000911.16062-1-ddiss@suse.de/T/#u
> 
> David Disseldorp (3):
>       build_assert: add ccan build_assert.h header
>       mount.cifs: adjust get_password_from_file() buf size
>       mount.cifs: remove runtime pass_length calculation
> 
>  build_assert.h | 40 ++++++++++++++++++++++++++++++++++++++++
>  mount.cifs.c   | 18 ++++++++----------
>  2 files changed, 48 insertions(+), 10 deletions(-)
>  create mode 100644 build_assert.h
> 
> 
