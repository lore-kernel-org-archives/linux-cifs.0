Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FD53603C6
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773245554; cv=none; b=EZK73AAmpPjELiLK8xlqzv6PrnOHtqZaSBODz0sSIbusUHvdNjAW0O8Zp2bkB+LSSKEqCcptxN9EGVbsnq+gZZwkubqtZnYAsv5RJhsmrgOMSfG+BaeC3rrMzeO9CqKxv90mZqP4JtUDM/+b1T/amPrhaanQh2MlTGcdvH8PkF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773245554; c=relaxed/simple;
	bh=zXYXilJ1hbpmx1D0Zw4urqw9JRsY74/33FC8/lHVvyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeT48SZ2YE5ZNnVHcAyTTTSKDOBx4F/NJcV8GbOrIElYz+DJ4gPO2tQ4yPapDFMxCzl5ZY0e08+lrGJC8KV3fJd535iboH8IvIDif4iHWF4Wj2g7PWOT96tEEQygXPNLTJJB+YPNuP8ee2GuXY+TpSif9fIQhwdN/JVbNUE8L8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NpS4JDaO; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NpS4JDaO"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4852a8482fcso54055e9.3
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 09:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773245550; x=1773850350; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wdb8PCOlgls8g32Eovg/NZwMsiR9gdwY/Koklz9SGq4=;
        b=NpS4JDaOYTxNLZiFp74OfaZ70nTgcl2rQPeeXzdKH/EQZ1Ou0e5p2SLWqzge07fF8t
         ZzEUT8kEo976YKW+VESyBZrPBvEZEavX90VUz0adtGKp85PgWH7LAReZw8w1avvt3yWy
         HldWjcu53yGHR5CpruJkl5T0MwYFI1WYmUJ+7Lj8g8ln4JPSWca08Y4ZOC9MM+QB5+Hz
         8SR5MJwFAwrXCVjcvr6jvLcy2wDns6MD2Gi04DmlqeDw0005Y7o3t521LmFEgwNF65rO
         4LNwJs9KqoPsFwO4sWcMg4hhQaWlPWhhPk0RRp9OezITPWIvPwru8Ns3LD7w42M+knvM
         K+1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773245550; x=1773850350;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wdb8PCOlgls8g32Eovg/NZwMsiR9gdwY/Koklz9SGq4=;
        b=cWjVfE5k3/vQ2sQAiLYztWlYUh7GoroHCxKKKittTGxL44ZtQgV7J9DKDTMND6yfaq
         qFYo0P5XcB/mTVR1+gGQ1IU9IGM5UcQu1x3F5/ZANblqGd/5cLfC0dP2QoMnTysgyhZc
         3CMKGE1G6QF80c3uzpxX9bqR2LO0ue4XIAZFno2cP7/ozIHmdMA5pgMP12XoiX4ec83T
         Y27/eb2O4GzkbcWmwMfjJcZOZyKvIQBlEiS0LR3sR7pqr11HkCthBykEBqtcDnZxHukA
         0wD5UZRL4OC7xLmxe/mxg8oGYBDBtfDtcXkmfoCSw3fDLiTTGcDu9rSlRYTQQw3QXXhI
         PFJw==
X-Forwarded-Encrypted: i=1; AJvYcCUw/WDOCgS1ilx+uK3sMDepz4RFxZv2pX03GojoRAE8HkoZ5KxvwP6HCsf5IyeU9a1yGYLaUuaEnkrA@vger.kernel.org
X-Gm-Message-State: AOJu0YzDuNaS8PxW1rn+ulXK/hHrD0P41G4toYIFcluo6OjSvMEA4qEh
	uxKdWvzq+BPCofLkOqPPNrMfrdlXF99uqiJ84XKhFVLtkoSaxvge+lXGv9fKdX02POI=
X-Gm-Gg: ATEYQzy2evX41ecRaHbOsGb3Wf9wAGATIL6YEp3u1izHLKGG3rq8fGt7CS0Y+IHS7bD
	7QFDzUROPhl6rE/6iryT6b+9uxe/HJD1If0iaZYv7HcQSQL4ZiLovkhY0oLHvbAoGqPriwgt8zX
	YUZTpqbckVnleAwOO0a1bkXoRT87ri9kmosHCrkjV8acjgjh5lWSghOgmH/eGvchR3XGSwWFgvj
	nSOH9yW6iYEIaPAeJJPBndjRERCBDcfk73rp6h94f7ZvSurWznT0SiMq+NiRZGePg2pkEWMg/kH
	6K4FTEbug96zk47zKd0IGhlUxaNdGFANa0WLLq44k4Iam/JnUSbTM8RH0rDGbhgY0b/EXyh/R43
	WscInbKgTLFVmKEOMYtaZqKbBStkauQlTy24aHyibfVbL/nfhX/2SvOydsU7zFHWxuIwfvE52HS
	JI6GJwH2sZvgXZWOzSM8vSTcmAXqTTNYdGUfskRsA9xLf5K2Fe+e3xTN8=
X-Received: by 2002:a05:600c:8715:b0:485:3f1c:d8a1 with SMTP id 5b1f17b1804b1-4854b0b327fmr55640975e9.9.1773245550008;
        Wed, 11 Mar 2026 09:12:30 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6402:b103:6a0a:3e1c:778a:5cc7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128e7c1780bsm3380311c88.7.2026.03.11.09.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 09:12:29 -0700 (PDT)
Date: Wed, 11 Mar 2026 13:12:25 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	regressions@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [REGRESSION] failure to reconnect on SMB server restart with
 custom TCP port (not 445): Host is down (at least since 6.6.95)
Message-ID: <lbexcljami5n73cz7oevuarmcvwbchtolcvlx27w376lparasj@kcfy45dkgt7g>
References: <20260310235642.6d9798f4@plasteblaster>
 <c66p7dr6vlujvnwczbnrmqx7monkdgdnm4rwewm76aibn7jza3@d3uik74dei72>
 <20260311091653.358b213a@plasteblaster>
 <20260311094836.5ba141a3@plasteblaster>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311094836.5ba141a3@plasteblaster>

On Wed, Mar 11, 2026 at 09:48:36AM +0100, Dr. Thomas Orgis wrote:
> Am Wed, 11 Mar 2026 09:16:53 +0100
> schrieb "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>:
> 
> > Do you need a confirmation with 7.0.0-rc3? I guess the picture is clear
> > enough as-is. I've started a build and can give a short follow-up later.
> 
> I can confirm that the unmodified patch works with 7.0.0-rc3 in my
> setup.
>

Thank you, Dr. Thomas, for testing this and confirming the fix works.

Can we add your "Tested-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>" ?

-- 
Henrique
SUSE Labs
