Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8AD1A7AF1
	for <linux-cifs@vger.kernel.org>; Mon, 14 Oct 2024 12:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728910427; cv=none; b=ZPFMueK9LSgmE/E6HWP3IiI9vldtXOhteh6hK9+1vNk6msF8+D7uOXCnniCWXWZ8xTOBd0Tan8SdTcyZNzNiMHR7SLmlCIdB/iBlvUQ+i3JHsToslpmrUyhvZBL0uutwcWUMjuPp96EjIJ3lOKnN5thp8KJsTo9c8LomXAtSfLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728910427; c=relaxed/simple;
	bh=+pcu92eMqg+NHXSehZfy3gPTkISBMTAQR/PVez1N+qk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J4pz4Q3LSgoMaYVbbopaoFr5NqjxEhuadXzS6mX/OSQ3RPiO4vjz7moKuC1oe2LIgO1Ufm16oJMjdcFY5XI6S4g2b8qDg0k3P5FCnXn8lLTSOxm8RePz/MBcSvsLWSAZkJ6LC54PvsMVv42yTkq5E7JBqhgyQzqL6GiNtVp031M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=U7avgCd2; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U7avgCd2"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9952ea05c5so656701766b.2
        for <linux-cifs@vger.kernel.org>; Mon, 14 Oct 2024 05:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728910423; x=1729515223; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SyCHsuV/E8d70gfcK9ip53tgwN234YxCxe5zH8xLMPY=;
        b=U7avgCd2Kq1XxkEYlk4PupuY4CHxpsGoPm4vKOF28tPALoNUKrgikVf5GGJ+wx5Nef
         QtEA7ezPL+11HILyzfSu04/bPDphbjGhGLO6sBINBPdulB5rxnC9/Lt5xX3TDAIr/G3R
         3b0iYAfgibyIYxkfJHDz21fztzlUeniDmMkTY8VOw6LYxRmAw2BcGMTFGtIFaSyW80TX
         dqmg9VM/kliZkHjzW7mVfzpbsr9DVNDS5flwgBNMGrkgxlTCnjZxe7FJ+GmO5W0ynO3n
         Kt1UmcV6GzF/zgslKdCfTpf5+0wzHlLcYlcKTCWZu7XOHIEwqIKnMqQbHyA2qTRb58cO
         RWoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728910423; x=1729515223;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SyCHsuV/E8d70gfcK9ip53tgwN234YxCxe5zH8xLMPY=;
        b=X1adiXl7jeqA4NlX1qGngMLYk8+DK2+g3nRo2uHr/wWPyQcJzrh4ujeknbaC5cSHEZ
         d2ib2nGSEXt0g/eTJGJWfPh6N5y9jFgVRcV+nYDdQ21h9ttuarfUaoFCLyE29FfTTsGf
         r6+2F5/lX7QzW8wPty3bh8chYF6elcZM7bAO3J4fF8Elw66jPYQ91DyUe7On6cXd2fku
         1+AqhQQxNpRxqfi5JEmHxaQsMwSZq5GqwCDvTxDPBDw/T2rkRV05JopSHtAvMaUSTNJx
         BxqIkWMVpxmJRp+Na12+IH4hfqFUsV2NkW+Oadkc+3htaL7bz1mIj+Mkv2jsEk2esSvs
         Ceog==
X-Forwarded-Encrypted: i=1; AJvYcCUbpXiO2gehbfkFpEpSXUtygKdcQZaSrrJAOD3JO0ra++0oWxvR1kfqh08gahWdn4sv3Zs4KCayBsm3@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk/RnCMqBDHxYO3EwnnNOk74eYRyB/2FGgy5uIidxj05BrSKP0
	ki48r6wx4hldVDV1BbrU3shDefOJT4qYe1lvBM+SS9scJZ11SKiuP0S2TV/wW80=
X-Google-Smtp-Source: AGHT+IHqHcsA+FZtp+v7kI5pgeIQE8uQgQTumNO5wX6KZkk6/bkHGwus6vrXYrx9c73EQIuXhgDQGA==
X-Received: by 2002:a17:906:c14c:b0:a99:6163:d4f8 with SMTP id a640c23a62f3a-a99b966b148mr1069583166b.58.1728910422787;
        Mon, 14 Oct 2024 05:53:42 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99f375db53sm303654866b.113.2024.10.14.05.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 05:53:42 -0700 (PDT)
Date: Mon, 14 Oct 2024 15:53:38 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Su Hui <suhui@nfschina.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com,
	sprasad@microsoft.com, stfrench@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, nathan@kernel.org, ndesaulniers@google.com,
	morbo@google.com, justinstitt@google.com,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix possible double free in smb2_set_ea()
Message-ID: <8bd0fae3-82fe-41c4-a4e8-3c28aa2b1826@stanley.mountain>
References: <20241014113416.2280986-1-suhui@nfschina.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241014113416.2280986-1-suhui@nfschina.com>

On Mon, Oct 14, 2024 at 07:34:17PM +0800, Su Hui wrote:
> Clang static checker(scan-build) warning：
> fs/smb/client/smb2ops.c:1304:2: Attempt to free released memory.
>  1304 |         kfree(ea);
>       |         ^~~~~~~~~
> 
> There is a double free in such case:
> 'ea is initialized to NULL' -> 'first successful memory allocation for
> ea' -> 'something failed, goto sea_exit' -> 'first memory release for ea'
> -> 'goto replay_again' -> 'second goto sea_exit before allocate memory
> for ea' -> 'second memory release for ea resulted in double free'.
> 
> Assign NULL value to 'ea' after 'kfree(ea)', it can fix this double free
> problem.
> 
> Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
> Signed-off-by: Su Hui <suhui@nfschina.com>
> ---
>  fs/smb/client/smb2ops.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 6b385fce3f2a..5b42b352b703 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -1302,6 +1302,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
>  
>   sea_exit:
>  	kfree(ea);
> +	ea = NULL;

That's very clever.  But I think that it would be better to do the "ea = NULL"
near to the replay_again label.  There are some lines where we re-initialize
resp_buftype[], utf16_path and vars etc.

	ea = NULL;
	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;

regards,
dan carpenter

