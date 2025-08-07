Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F671411DE
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754580976; cv=none; b=ijWQeX6V89ZBPzaHZ86gwb2aiGFyceYKE46NUvbcovC3fw/DIloNgjttSRmSNRTD4l8S16i/VnM76i3Bv7BeRfM5uK3C3dnDU4zNeXUr7YP2pDe+kYjUmltpZJrxTZqhXavZS9WLs4aOUiJWenR3YnpIRjTNR1lUQDzebUPthug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754580976; c=relaxed/simple;
	bh=v4SegK1YkozLM/5t6e/P90upgy6A7svRDz/F1ls8Bns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XBOxpPcMmpJO0yyKkAw0/1ccb0FAI6FSrsQnu21eegTkM5kkBzIT5T7M8Nn/fT8i5D0z7uvY6fyyREyYGqzUdGsUey+t21Dk1NSIOt0qdc0JEsqM3gN19sV5DMJ/1G74M3kadBbV9wt9wuaaV5E4wzLH4NN01re1NtbUy6MjIMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BKRbSUUK; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BKRbSUUK"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-459d44d286eso10439675e9.0
        for <linux-cifs@vger.kernel.org>; Thu, 07 Aug 2025 08:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754580973; x=1755185773; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QMOLSsFLAcYwBYitWCmib8GLJf3qTqTLYwkuuzCFAxY=;
        b=BKRbSUUKvg1w/69d+0wj7oJNmVf3NA/FSjalQFNUHAdNR9F8zJKbfyGWCLmzzxTzzW
         RVViBkPu6LzwmG4NBjTql3SJ4WG4CSLxUHw3tt37sgwKMrNDMRHgddpjYBUjIb2+149X
         WpYPFHel2Z0CnZuZ0wAq6Ee5UK1Z4J6tdgQRYYjxA1TTF3uGqUw8D4j1WewIZv4U8Zc8
         DLz9xh7FPu3Rso74w+ysNqdIUvh5LlhuAkY9D4Hqt6p2K0TvJPcgQsRiEEoLf8kUhIEm
         hhxPrmjDQ9oFa55hgk3iC4Js/JBCEqw7kszu8cD6EDsjT6ipquYKdQTz9OomDhA5h+z6
         aFVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754580973; x=1755185773;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QMOLSsFLAcYwBYitWCmib8GLJf3qTqTLYwkuuzCFAxY=;
        b=YXXaihTIjjVPAGRE8mYRxvubwVuJTQ8+nsNOuoZ/3JMzUYl9PiF+JSi/g6boDYhion
         LgWNRH9M4neOewGp6e4TKmIEyuH2AwQJOobPlbER6XHHkTysBU8Itj63LRwuyO485LdG
         Lj2eCh6xojSGn9sU/y4qxWhY5ffQEfEqMlkEORkUSXB1BS83wNj2PzGArHfrVzHEUb4S
         4pQ2iHo9EpQV6ebImPmgu2pzGXX/IZW90PS2hjeJVX2Gydy4qZV0CkUqEdmQ0GR6GgIJ
         AkQQcutWo0oFzer078dw6HQFbFQviS8MEYrUINk5lLfnG1ResgEJTfONvxZPG+Ma0LuJ
         a/bw==
X-Forwarded-Encrypted: i=1; AJvYcCV0N7tEF6GZcuZyCBRdRzjELidiBk2uGc6lqGP3XTa9DX+X6HEyE+DlrA6UrUC58CBcoBDjUZYt2iAV@vger.kernel.org
X-Gm-Message-State: AOJu0YzHHNhC40+iXSNbAVX8tE7Y4AZu144qCRegClY1ARiJySoBRZDz
	uNj3rhQkouXIbYT7OSxKtBogc5JI/C/+CLTGuUSQe+ZXrPH+puaNc8hqtzCzDcALBao=
X-Gm-Gg: ASbGncukuaMelVzWaFIraEfbgqkm3GiXHCup2AFKDt1A3j5zba/kFYLSe1uXu56rjuI
	Gd7MsK9F0llRx0NU4NQtW7CYG1HxWfQLQGYPAUk5U+GqYZoh4ihcumt0sX9J4T2seOvUZyvc6CS
	/W0O/zvFQmnEAQE796JQAKqf667CXmYaRM3OIm8JAj+aTZGK83/P9N03K/9YRqxf4vJ9ojMlHM5
	4v8/qI0tECQp6XC6+WKu8e4lY3HbjLkGLsNExmzbJNTSXklJkwnBAz9Gx58NJialWoSDRK74X/I
	KQ128G1LxIUwUGAWaoct8KPcFGdIaeZ75E2EoN6VWW5bMO5jingWLDzCPIgSpFtWGfoCE5xSHnw
	LJcZCmQJEPKoZ0Fiq0YCPbkrNKKK1La6BKC7hby50EIo=
X-Google-Smtp-Source: AGHT+IHV8dMO7twajlNvibI4+8XJL+mV64WbbAe+U8htA2aWAwO31dkgRGRgQpqoiYGZNTZXl3VeXg==
X-Received: by 2002:a05:600c:1e05:b0:458:bade:72c5 with SMTP id 5b1f17b1804b1-459ee08a8ecmr43575175e9.8.1754580972966;
        Thu, 07 Aug 2025 08:36:12 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459c58ececdsm113034325e9.1.2025.08.07.08.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 08:36:12 -0700 (PDT)
Date: Thu, 7 Aug 2025 18:36:09 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: Using smatch and sparse together (Re: [PATCH next] smb: client:
 Fix use after free in send_done())
Message-ID: <14c2bce9-ee3d-448c-8a01-542b5b0b9848@suswa.mountain>
References: <aJNASZzOWtg8aljM@stanley.mountain>
 <ad2e9d94-2d95-4351-b800-627f20672209@samba.org>
 <87646c67-78b8-41c5-9b72-361cb3b733d1@suswa.mountain>
 <e291d925-bfd9-4202-b5d4-de5bf30ab870@samba.org>
 <a1a0046c-f47f-4e8a-ae3c-85db58a6cb2f@suswa.mountain>
 <df4905fb-933e-4055-8363-d6427515773b@samba.org>
 <d3b63d25-1b03-4c7c-85cc-efd9d74c3a8a@suswa.mountain>
 <aa65df64-68f1-47bb-ab69-9817387f3ab8@samba.org>
 <ffc54288-5986-4505-b77f-bd800cc45527@suswa.mountain>
 <e685f670-d994-48c2-8913-57358f0f9ad7@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e685f670-d994-48c2-8913-57358f0f9ad7@samba.org>

On Thu, Aug 07, 2025 at 05:17:05PM +0200, Stefan Metzmacher wrote:
> > > I'm typically doing a full kernel build a week after each rc.
> > > My idea was to rebuild the whole db after doing that.
> > 
> > Yeah.  That's a good strategy.  The data from the existing DB feeds
> > into the new one when you rebuild the DB so don't delete the old
> > DB at the start or anything.
> 
> I mean I'm typically do a git clean -xdf . in order
> to wipe everything in order to do a clean:
> make -j33 bindeb-pkg
> 
> So it would build a new DB, as I'm working based on
> the new kernel I guess that's all I need or
> are there other reasons to update the existing DB?

You really want to keep the old smatch_db.sqlite DB file between
rebuilds.  Every time you rebuild the DB it adds more information to
the call tree.

Imagine a() passes a number to b() which passes it to c().  It takes
two rebuilds for that information to be built out.

regards,
dan carpenter
