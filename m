Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE876197A93
	for <linux-cifs@vger.kernel.org>; Fri,  9 Aug 2024 15:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723216279; cv=none; b=Kudx9p7QH2yMGSV6KTFcUqW8gpjSX7hK3WVa2PLrAJhN2R3yiIw0A1YXbDLm2fIzaXweyQykPnLHiABLLzd3iJ3OZGEcuheT2QlejLk6pZaCAQz3RH5290ahXfkrwttY5kuN8wur6PZy3gdqS+J6evnsYB3immWj9QJtxXElB0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723216279; c=relaxed/simple;
	bh=7qv5/5ztgjnBd8ABlrZklhWeB1+KbwrFTx+b/38oBVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uqdCmFqp1n2bbdOgGbJl/UmoSD2OC5vIQfP6MRO/8MC7USm7TuB9bOP+8BuUSUSk7qg2hjbOxe02dTmiqqMCGL09E+4b+t5gvEZdse7yMNb1sWj5PwH0xCD1hvWO8UxLkHFRR+dIXWirdZlTGq7omlaN5hJQU3f/tTzoxuHdIlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dumN3CSD; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dumN3CSD"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5af6a1afa63so2416138a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 09 Aug 2024 08:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723216276; x=1723821076; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HCnFjP8yeSTbgg04jO70aNmUrU3V0BlhkT72Qsh0eiU=;
        b=dumN3CSDg61IqILdGhI6uKDjeqWFaLYRztBAdAEylQiCpRw1EcT6viaBp6jKfpdM02
         NgHICBOHKDfikhPodtVd1qTDR7LCTUqBF3ah/YsBqRxLKXW7aUQbPxcs709ZYexdu0ae
         kzmxm6qNecQMCZZHq9J6vbJFSvxF1IwYPEKQ+i8QXVc8U9sxqh0ueyfnTFhRbn2byohl
         5xhIYLB7xsjdsgIn6I6DmvDHVLT5f6YG62m8imQYyZnXu8piG3tvRZWbod6cLdN8B9+y
         ba4SkJkxztKZZlqEdtd7UOiXuN5z0e38XK8XD7+TjpGKQjOKgW5pA+zDp8mibVTwQif7
         oftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723216276; x=1723821076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HCnFjP8yeSTbgg04jO70aNmUrU3V0BlhkT72Qsh0eiU=;
        b=wPE9yRClrbPAQc3LEGat3kIIyftT0nC7sLwJTvi0hmWrbTdEBPNPmR1xMeGpD21Wht
         GyU15Izeslh91QsW+15ZBnYFo2JqjQQor/RM2bhffEIRfIxUIq0o4yoBsdDzr2ZPlkms
         X/vo8JuCk1m1MEZKb5lP/8GcEE1uUL6dVbQIAzpJqrBhhv0Pir1bkRyCtKjXTjyHbi1w
         3KUMWJVqKMAeCmg2wpwcTDsch6BSnY6NTHU+Io8R+BNSLY/aTXibT5uVnmDa4ASCgIbb
         muBBRPgvAceN4OvuXaEeiGFb8bpZT8TKGBm/Ew+cWfQJtyQI+l0GnC923QGzqsrtrABN
         wcEg==
X-Forwarded-Encrypted: i=1; AJvYcCVK02DthWwJV+ZNGoHbcgfdlSxh6h7ixttFRQhRzfQCBIR0yFMN3hv4htx5UWd+B33iV/RuYUDDjcIHAdZfpYfxHnpvrZ774q0VeA==
X-Gm-Message-State: AOJu0YyBDBoCZxtevYbFKoskSrAfQs3Q4AbAzmWJXckuZb5H8aY/NEfV
	CzF8e6HkPjki8BoAfTXqLvw3kCxDZLXg/6/Y91JO6H/I7231SM8MQLerXKi2SQ8XF7r7XNttGOY
	F
X-Google-Smtp-Source: AGHT+IHM6/NyJG0fypeFEFHE1MSoC6qNiWwYqrml/FzF4jdvuVfqudW3tenaS4EdJbwoBirlwLdtnA==
X-Received: by 2002:a05:6402:348b:b0:5a2:4d19:4c08 with SMTP id 4fb4d7f45d1cf-5bd0a58a137mr1382401a12.11.1723216275896;
        Fri, 09 Aug 2024 08:11:15 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bbb2c1dbe4sm1590031a12.27.2024.08.09.08.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 08:11:15 -0700 (PDT)
Date: Fri, 9 Aug 2024 18:11:11 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Su Hui <suhui@nfschina.com>, David Howells <dhowells@redhat.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com,
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
	nathan@kernel.org, ndesaulniers@google.com, morbo@google.com,
	justinstitt@google.com, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] smb/client: avoid possible NULL dereference in
 cifs_free_subrequest()
Message-ID: <a08c6b03-6d23-4711-a891-14b0250b90be@stanley.mountain>
References: <20240808122331.342473-1-suhui@nfschina.com>
 <893f2ebb-2979-4e34-bdab-a7cbb0c7e7b8@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <893f2ebb-2979-4e34-bdab-a7cbb0c7e7b8@stanley.mountain>

On Fri, Aug 09, 2024 at 06:00:26PM +0300, Dan Carpenter wrote:
> On Thu, Aug 08, 2024 at 08:23:32PM +0800, Su Hui wrote:
> > Clang static checker (scan-build) warning:
> > 	cifsglob.h:line 890, column 3
> > 	Access to field 'ops' results in a dereference of a null pointer.
> > 
> > Commit 519be989717c ("cifs: Add a tracepoint to track credits involved in
> > R/W requests") adds a check for 'rdata->server', and let clang throw this
> > warning about NULL dereference.
> > 
> > When 'rdata->credits.value != 0 && rdata->server == NULL' happens,
> > add_credits_and_wake_if() will call rdata->server->ops->add_credits().
> > This will cause NULL dereference problem. Add a check for 'rdata->server'
> > to avoid NULL dereference.
> > 
> > Signed-off-by: Su Hui <suhui@nfschina.com>
> 
> Needs a Fixes tag.
> 
> Also when you add a Fixes tag, then get_maintainer will add the David Howells
> automatically.  I've added him manually.
> 

Actually, David should have been CC'd but the fixes tag wouldn't have pointed
to his patch.

This is an inconsistent NULL checking warning.  It's not clear to me if the NULL
checks should be removed or more added.  If David were trying to fix a NULL
pointer dereference and accidentally left one unchecked dereference out then the
Fixes tag would point to his patch.  Since David was doing something unrelated
then we don't point to his patch.  Instead it would point to the first patch to
introduce the dereference.

regards,
dan carpenter

