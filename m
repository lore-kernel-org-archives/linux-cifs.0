Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1084130F812
	for <linux-cifs@vger.kernel.org>; Tue, 19 Aug 2025 05:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755581243; cv=none; b=ipfNarsaHYB9hKV1TDIdp5Vyzp/jQBi/UbUVf/F5tjLcHKIBAWa1hgTfDOwmvo7Lwk3p2RD/5RxA1tO2B2Un+My4jZucwj/1LMYkQj0XPOOVX6dMkP5mgU0Hu70GVjbH86dN8dddhcis+Y6CHY0U9N4iDezcrz1eC4Hy7neOAAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755581243; c=relaxed/simple;
	bh=m58pm/y93ex8Ncv061DlagzVcecj++xj/Do3CRly1jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tjqdGmNmeMUXyO7zjmbFfT1ad9+EALXVVldSPry/MwNHvb6sKjoS1gqLblpbKomvFD3gDczy0S960U958Uf+yEE4t+E3iN+8SFlbN1luKATzc2jGvbdomQptIiAVb/5UbMNcx/Qb+8PGcyuQEpsQwC5RlvosQKTGDRqbWp61JIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zPLpZ0HC; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zPLpZ0HC"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45a1b00797dso32107295e9.0
        for <linux-cifs@vger.kernel.org>; Mon, 18 Aug 2025 22:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755581240; x=1756186040; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=POjRSSun8byVdEQqP9DQ7UyrlJnob6YXd9k0xYVJVr4=;
        b=zPLpZ0HCZkNozIEAPnEkxbwb6aFyUO7jvyzQiDo1EpGW48gD8lw/iejvSJXlX1yh0T
         c5UYxE0/Z31W10ilKCSRs5MeDdkcD+OxGkPHHvZcHnPyqtQRnY7vRAosKkIc06mHumbF
         Myi11mLHljGKPLmEaHRsAt7hpptzXH6RswpmiSiubnaUxfOiHtI0pm5EiADf1pnr8O1/
         C12Nov6eLKolum/j6sq4Kqsl+PbqeJIGiL6/VjCCHM69aikjtruWFwubwyUU0ElfVOkY
         F3XkPgpcYrS5zznIjVuofxJTbHfUskIkxZY2Io5Uc6ylEg5WoxdMN0Jk2dZOndapUFna
         YFaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755581240; x=1756186040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=POjRSSun8byVdEQqP9DQ7UyrlJnob6YXd9k0xYVJVr4=;
        b=ldaUI828849MwU2gC/UxzVxbk4P7M6E8GtRtt9xus3C+gWAWStpt9oBma6M4QfODHE
         NOSULz4V8EiwApVIYzNP91YWiyqLIbI5TNyuicAE1QIB9dIB7WQn2fbdnil67AE3TBjL
         br3MaJj4RS39uGPhXAi1JXVU7C52jPz/bhEg92fgBuQECKLEGsKpN20Q09XAPRjnmRFv
         STe+iSdXge9Iy1iq02R7OIos9lxhKWajlVLj+yHPi1+OOtxJRV22yV4OqRsRvGPXHBK5
         5auyH9fnDubQ4yHj34Ct40hZyPXHk11EQK8s5dctG1KWHk/jyoth2pdud+PQas/cfZ5Q
         lSGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtIxpgoUnO1AZou+7uizexM4hl02WxuH6+2bWtdHQT0Gm/VIHbQvnCfNytAm672CmfgKXMbsa3bbFA@vger.kernel.org
X-Gm-Message-State: AOJu0YwACOADTtjKCDTBGWp4UMn4a48YOZoCSxlUy/rrecHdpCozjyr8
	dWhpsSIwH/13O71QFJXmoMPJg87m3+5Wm8XYfqVyTj7BOqrdqkqMjzd91Zx0+ytn1Y0UNS/7S0L
	8mayA
X-Gm-Gg: ASbGncuegKMpZaCUewyjAHuALQ944JOYwDvL9zq/nr8k9Y/C/L7u5dv1PsKD2G4mEKY
	LyFtoY31tnWlLYfAThGx1T6lXbDVAFpbHe0jPPhYInuY6HzU8VripM8+OtG0JY8ETTDTdTRq6na
	ExdkUMk0Y/4zM4EGi3Aq81pI7P3Mszp985oYcWq3qWvkVuusobSedXuB9f2OAEvRJmkhZOOGmUV
	VaBhI9LqGAO8/hzqEDS03fI/8NwTRqEevcNiLIMStsqNdpibvcBMzU9CoqmU/NvKkhCC/R4V2Ze
	d68ZMeTa114itRj/LTCwzZXmrGZbgxj4IZJLpJDQ9DMoL3ymwZLliQBiVxkCZw1sbHwVlb/uHPI
	XJT6tZnvLrVm6SZQK/AYayh/TMSg=
X-Google-Smtp-Source: AGHT+IGKYSqUDzbc4GjhgW3BDdJh5Ev2IvdZsejLJPAp4FscOBlrz16sEekNNDLRTobugxi8K9O8Kg==
X-Received: by 2002:a05:6000:2f84:b0:3b9:1c60:d795 with SMTP id ffacd0b85a97d-3c0e3337785mr885643f8f.22.1755581240310;
        Mon, 18 Aug 2025 22:27:20 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c074879864sm2110199f8f.13.2025.08.18.22.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 22:27:19 -0700 (PDT)
Date: Tue, 19 Aug 2025 08:27:16 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Steve French <smfrench@gmail.com>
Cc: Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH next] smb: client: Fix NULL vs ERR_PTR() returns in
 cifs_get_tcon_super()
Message-ID: <aKQLNODuSBvUP4_F@stanley.mountain>
References: <aKL5dUyf7UWcQNvW@stanley.mountain>
 <89a2023c-e383-4780-83e3-ba8f9e44c015@huaweicloud.com>
 <CAH2r5muVjS+Y_NFSWwYoisPGfynyTkmynjpQHi2_Kk6Z8AiG0w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muVjS+Y_NFSWwYoisPGfynyTkmynjpQHi2_Kk6Z8AiG0w@mail.gmail.com>

On Mon, Aug 18, 2025 at 04:41:52PM -0500, Steve French wrote:
> Since Paulo pointed out a problem with v4 of this patch, an obvious
> question is Dan's patch "independent enough" to take or would it make
> the v5 of your patch harder.  Let me know when there is a v5 of the
> patch so we can do more testing and review
> 

Probably it's best to just fix this in version 5 instead of sending a
separate fix patch.

regards,
dan carpenter

