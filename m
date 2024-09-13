Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C8A1DA610
	for <linux-cifs@vger.kernel.org>; Fri, 13 Sep 2024 13:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726233674; cv=none; b=g7UGUtBcjh/836A465hE1DRbuor9A7VaSSXhbXhP364qh6/UA6cWthHTq1prRCLH//904OKtb28eiQV2xaPXTSo/Fo2TxF/vgF/YbTlQ7DS9i3gu4ybN01d1DLmlrHXF61bES1qlw+cTkxt2WPoBYpmQJ0wywmSWGVayBCH45Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726233674; c=relaxed/simple;
	bh=D0f1PuT9jXBwBOm3nTsBr0JjPgQVpuzPalotUDBLBts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eEqqDqrPIskMJP3Y6zl91Nxs/+5OjckGlUCYLm4XM4TtiAfOk7lO3C/qvxZqL5+mijHldahL3pYQs+fWqboHZBhIouD2ARrDgIX9xkjwi3SORloIf5gh1mmSwDeSHQUOyPAb9EMXG7Uk4vEM6tD0HGYwKg6SHMtbe1LguARTzao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MI1bXRtG; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MI1bXRtG"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a8d3e662791so46930366b.1
        for <linux-cifs@vger.kernel.org>; Fri, 13 Sep 2024 06:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726233670; x=1726838470; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XhdGDbYhYo4L16IpPIGGru0i2V684mpbk3Fjn0fs3A4=;
        b=MI1bXRtGN+e041M+4T5p37hH3SfQSgFeuyOFtKgjjbvFEucv1HTiFjZgdP83w1lzDF
         ZYJ3cmqCVvFwcJQGpPwCP+BvRxG5/2uxQk02i+itqm88LjduYKDQ/B3kfxC803fA6Zxg
         C4XyNng9syJcSkAnydG+p/eko7Yl1Lk/9WeAjTbccoNqMsBVxqFoe9P3rC56jtG1sT8t
         AvBYWEhYR55X0intkYJHjzk3xg6PYWlpiuAJM/ZK6q21PHnx0gFFM34naXTmmtrNliG2
         +9MW11u28bXVENFQ+ROfDighjJLu/xZyHShSL/4ebYmQpwMW099yXvu/c2+Z64FP993L
         DNxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726233670; x=1726838470;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XhdGDbYhYo4L16IpPIGGru0i2V684mpbk3Fjn0fs3A4=;
        b=bOW2C2jaN9nfjTNKPYDKjEaFOTgUd1mA/EeZtf22KDbZyl3c/JsQXCOwddl7SlzSCA
         XSdRzUnTPEjBoE/hbkUxZHeuXSDCdRuftEzx+n/RLRFGHvbPJA4HqT09g3F9A5pjdiGm
         jztqQj4MxopR7mYlbxDq6krGowj93e1iqQrp9CwlWDHJcQ/gcVFvOQXUtP8HY/9aGLqM
         3IexaC2j6KI8ssX7uHH1Kvum9XUkmO/blKYNQbbPRJIEA37p5EE6P9xiLyss8rl1Jkrz
         U5/X20o72V05amUhLQM+Tml9cXnXVTL34VFhLDGwxDYQXM/+oeElUFRo2er7foeDVBQ8
         ns4w==
X-Forwarded-Encrypted: i=1; AJvYcCUaAdHjbz+b+3TJ4J50UWEsZvQu3zB4YE4DjzJQVLyi+lT62xJVwdHnNac+sNgfbV0ROtJXigZ/W06P@vger.kernel.org
X-Gm-Message-State: AOJu0YwDqVtycZ/ND0rGYUtDWoq03Ijt5+bUTjad0IQG0U9CCoa/bTo9
	7VwZJA/XX21MSxpR/s31yEIXvv8RdsplyRDMIBrrUFQdszeQ9FMsAHxAc/3rGvygLQtnL9RXCc9
	S
X-Google-Smtp-Source: AGHT+IHcJ56NtIk9V3Z+A3QtoEu3bfPgHzOA+efDcloNtpUGHKdEpTOJ3QrRsGllAAeULwcGZII6kA==
X-Received: by 2002:a05:6402:2687:b0:5c4:2448:87e9 with SMTP id 4fb4d7f45d1cf-5c424488a68mr872652a12.0.1726233669912;
        Fri, 13 Sep 2024 06:21:09 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3ebd76efbsm7653417a12.67.2024.09.13.06.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2024 06:21:09 -0700 (PDT)
Date: Fri, 13 Sep 2024 16:21:05 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Qianqiang Liu <qianqiang.liu@163.com>
Cc: ematsumiya@suse.de, sfrench@samba.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: compress: fix an "illegal accesses" issue
Message-ID: <63aacc6d-8e3c-476d-938f-cce25d74a6b5@stanley.mountain>
References: <20240913032750.175840-1-qianqiang.liu@163.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240913032750.175840-1-qianqiang.liu@163.com>

On Fri, Sep 13, 2024 at 11:27:51AM +0800, Qianqiang Liu wrote:
> Using uninitialized value "bkt" when calling "kfree"
> 
> Fixes: 13b68d44990d9 ("smb: client: compress: LZ77 code improvements cleanup")
> Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>

Thanks.

Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>

I was reviewing this static checker warning.  I also have an unpublished warning
which complains about collect_sample().

fs/smb/client/compress.c:207 collect_sample() warn: should we be adding 'len' of the min_t value?

It's a bit weird to sample data from each page.  Could we add some comments at
the top of the function explaining what the function does.

/*
 * This reads a 2k sample from the start of each page to see the data is already
 * compressed or whether we can compress it further.
 */

regards,
dan carpenter

