Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23452F6911
	for <linux-cifs@vger.kernel.org>; Wed,  1 Apr 2026 15:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775057086; cv=none; b=cABDRnoFUgb2kLsRS+5Vx5ysHPXmz0aDKJcBK6SbgRAQZsPh5kQb0iPwzNKPR4Fjs7DWWQwOl57BoaC0a2Pu/mlQDnNvyNy9rZrKd80kqiAl3I3XPeyvw0qKLMf1P/WBt4mscWwGN2GS39e3sWfpOWPWzxf9osTb/hiO5rnmRIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775057086; c=relaxed/simple;
	bh=5/uYBq7xLc3LY7OvqhoexNFSmBkhfXmGFL2GEt5JcKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OTYYmJORPB6GnsroBmK+ADIKB9Aen3C8XCmMjOvmXqA0g/YknuxhT/Htk/Lm2mNSFvhoJWLcfJ2EyUAR2ZyM0Nk7xntFOxzmhX6Ik4H2eLshbocDtUDUqUPX+/2H9I9npEN4QLAWLBH4CBx7T/Gk4LjjhN6sTHR3LA2brBRyyZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PJIYimS/; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PJIYimS/"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48704db565eso86288925e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 01 Apr 2026 08:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775057083; x=1775661883; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IpvnMbvLfYFfpW7xZ0MAjebpKPC87LdmT0mjlJaiLrY=;
        b=PJIYimS/6KBwDoQbY/zLKhrm3fQQM9J+Vx17KJksGkPio9tFpMlYVX6PX1KGLZ4CLp
         353yVTnDPv0u1FdhtU7yi1fJrZ3HP1nnekflW3rwDKndfNR2ETive502x3Mn2p4lX0j2
         SMVoulTycS+6x9nuX1LG3aAgejy6JvtVyWdrKtps5zV0ntPwmXGmMqKvr2s18SejcmPS
         aeL18d9ocpB9etPdWitnO2jNIUuATnh06+Vuv0crcumflMvjoULfls2DhsXy+Eya7Psm
         OiF3DqcsqLc4HWQ2cZlmVTWOg1IaruDTTmS0kKab5vkWigJIbrBC7P8ka02FiV1GJGos
         QYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775057083; x=1775661883;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IpvnMbvLfYFfpW7xZ0MAjebpKPC87LdmT0mjlJaiLrY=;
        b=QfHaL06m6Xp9GXbD4+pRLi0oewK97WNadvnmv+Kekus0JySEM1M8XK0csBme6wZ+On
         7XscwFgQKOcVobZKcXw6MLo1iwHT1mugB1Q/z0v8/hiVN77nJabJdimTu1HSGQWxgd1h
         /Na7pO+2Wd9Zgfmt+QJmi4/gDSjL7zlYje9pQ1f6I81tJCwqZdj3qDHbHUdEvhbJij0+
         y4z183YJTCkS6qI4R8EXv5FZH5XwnHkSrLGCR1j389YUKSJUZ3I3+sqqkSEnN0FpQl0l
         B7X+KnGTRTJH0yzf971xIzmcp1OMk0XkWGeiOPaPTbhXqZI+UNbeNWAZx+t+cbIvhCwM
         oV9w==
X-Forwarded-Encrypted: i=1; AJvYcCV62Gr73uKVA+hYY+nKxOsK2y+UaLHSqLLW/Evppf6LFRKqUyzcC3ZnPaIDHn4KXI+LmXgbepVOMoyK@vger.kernel.org
X-Gm-Message-State: AOJu0YwwvZ7GhVaS0L/m7lql0HxUNYedAhBhfVnHt6aSxmyYHilNRuHh
	We+9Z0kgKy7hLUJsVag3jWZf2I5jGKs78Y6EYGd76XVuaa9hd2CHCfZHTrV6f34ET0Q=
X-Gm-Gg: ATEYQzzweRDfMjPitjVLtVbZMArSFQKMp964KeW7/43cZ1GZL0qKKhQ27w/rzPy/xqA
	PMNNM7MQ8c6en16NfYFvRfMaWD3Ifg7W5ym7JLPN3H2PChDl/BBsggKBslBPDMmSQq+HkafNwe4
	Usk0HxD2b3IykFgfz8Rn9fs+RjQDLrb7bkdBUxsj22TzbPKSTyI22WEGa7wZ21fGr7tQ34EohPi
	3BGlmrYEV982CwTvYax/mbvBz+VbhQxAp3Gs4++6tN9145T116YR82DODHh22bz/TjaYIcG2Qpz
	GFzaiTN0wKmKE3PfA6MKoXrT1Vl4FVPu6SaNOzsnAKIKAhAbupDkRj9pahOt8gWHq7TV/zqGlkj
	oY0+yeYo5WJZTStco+Sc47uDM0wm/hiyOgZ538IKgiUrpkePlSFwNkU1i2CmQG/w5Hl/ZFXFwLn
	vpSqTGPRdSAO2dMzSN62qchisM4Gl03PPWcyRELEDia7VV9Olmd1N2
X-Received: by 2002:a05:600c:468b:b0:480:1d0b:2d32 with SMTP id 5b1f17b1804b1-4888356275bmr64782215e9.12.1775057082400;
        Wed, 01 Apr 2026 08:24:42 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6400:851c:3e:b5f8:f525:a475])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-953fb897b8dsm314265241.7.2026.04.01.08.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 08:24:41 -0700 (PDT)
Date: Wed, 1 Apr 2026 12:24:37 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: David Disseldorp <ddiss@suse.de>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Bruno Bierbaumer <bruno@bierbaumer.net>
Subject: Re: [PATCH] mount.cifs: fix buffer overrun in set_password
Message-ID: <cauglxiqmzregxmz7qu3ervva3qiszmgs4xeiczmlpwuzmi4lk@6hgpziq22o6p>
References: <20260331000911.16062-1-ddiss@suse.de>
 <vuah4lb4wtxy3vhw4ywuacfto3dfxke7zldb4oiu3bcpjncrzv@ntdb7jyuzywi>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vuah4lb4wtxy3vhw4ywuacfto3dfxke7zldb4oiu3bcpjncrzv@ntdb7jyuzywi>

On Wed, Apr 01, 2026 at 10:40:41AM -0300, Enzo Matsumiya wrote:
> Hi Dave,
> 
> On 03/31, David Disseldorp wrote:
> > The existing (j > pass_length) check is insufficient to avoid dst buffer
> > overrun into the start of the adjacent struct parsed_mount_info field.
> > Check for overrun before writing to dst, and account for comma-expansion
> > and null-termination.
> > 
> > Bug: https://bugzilla.samba.org/show_bug.cgi?id=16044
> > 
> > Reported-by: Bruno Bierbaumer <bruno@bierbaumer.net>
> > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > ---
> > mount.cifs.c | 8 ++++----
> > 1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mount.cifs.c b/mount.cifs.c
> > index 1923913..d41ca6a 100644
> > --- a/mount.cifs.c
> > +++ b/mount.cifs.c
> > @@ -350,13 +350,13 @@ set_password(struct parsed_mount_info *parsed_info, const char *src,
> > 	unsigned int i = 0, j = 0;
> > 
> > 	while (src[i]) {
> > -		if (src[i] == ',')
> > -			dst[j++] = ',';
> > -		dst[j++] = src[i++];
> > -		if (j > pass_length) {
> > +		if (j + 2 >= pass_length) {
> 
> There is the overrun bug, yes, but unconditionally accounting for comma
> expansion here will crop the password if it has at least 1 comma and
> (unparsed) length == MOUNT_PASSWD_SIZE, e.g.:
> 
> (password here is <511 * 'a'> + ',')
> 
> # echo -e "username=administrator\npassword=$(printf 'a%.0s' {1..511})," > /tmp/creds
> # ./mount.cifs -o credentials=/tmp/creds //w25.vm.test/test /mnt/test
> Converted password too long!
> error 1 (Operation not permitted) opening credential file /tmp/creds
> 
> 
> Maybe password/password2 could be malloc'd with size
> "strlen(src) + <number of commas in src>" and bounds checked against that?
> Just a thought.
> 

Maybe we could have buffers double the size, but that would represent a
behavior change. Passwords containing commas were never guaranteed to
fit in current MOUNT_PASSWD_SIZE sized buffers.

I believe this would be a separate chage.

> 
> Cheers,
> 
> Enzo
> 
