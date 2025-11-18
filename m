Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379532D4B66
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 22:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763505318; cv=none; b=q3BEED2XkirTGRtZGsaX8Fxk50n+sVOyxjNbJPHhYeNCHITQKRbFg5qin00Egmwt84JtLSoVwKqRk4K8G9e95DC97KhzfhiTa9ab0a4vB+gR6l3a9wGC1EiUp8GHYj8+a3AB+I61DyizVZle4HsezRI8nDP+5SsRmQn8bfVIK+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763505318; c=relaxed/simple;
	bh=HGBI59D58dtnJMQWok2BE6+Bp+MNC5IMyCdT+yTqh5I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MMEJefgT/egpddanUa20KVEL3l070ZmnLOnMJc257HaIZMSTi0IinLWi1fCD6NIdOwHuHVkQfzlHg3baW6onoxGvPPRKYxv6pffUI5PjIPlcvIBeWZkoq5JjT0DIA0hl12lLLnLuyY4Mst9Ut3L2K1F/5qVx7rTDPKlEPH55OFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K/2+NFpp; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K/2+NFpp"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42b3377aaf2so3400754f8f.2
        for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 14:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763505315; x=1764110115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hKoEwxJe1/8YaYN7TE5Zcyy9lUtQgGUkJVTLvPZKYQ4=;
        b=K/2+NFppz0pv1aYQ2eYljLHsznl/VJtpSx/4gbpOVgKX5ee567rHlS+jUeXRZPlD5q
         j/GkZGfQjQ+ks2duUxDuO0wfv2DHr5uqxxSSl722Src9WJ82HkCW/+HRs1nkVYkdqNla
         vcVRCVuWqxYDj5fB7jB3mY2hHbUTkmLg1z17BQw5h/BXfL+EjaSHFBOnaCF5ZvlZI0xt
         CsJZW3yV9XEJtKEXgi1QWfnsMz19lljOdL5AoeqGir0zPixD8/gbuJrw+9kWz+UA2iG8
         H7fr2q5l2bImhKDdo/5kuqZ3BQ8VokfKp2o3x7panUqiq/ML8jYtFC67LM2JUMjNsvho
         HPRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763505315; x=1764110115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hKoEwxJe1/8YaYN7TE5Zcyy9lUtQgGUkJVTLvPZKYQ4=;
        b=H5Yt0jj4v3Fyvoq44xciCNjBeNW09zNN5ES/e2bnwC6kz1BEqKDKqUbd69MJJs5ejl
         gNEnf0r3Slefrm9LQ2/VdtzufLB1ZmhInH4AVbFKbUEwfB8Df0QfouIylPvwLcgrBEkC
         JKUYxfkUWZNV0bRHfRg37VY0V3Qh/P95gFXLjy6pwaIeOCm/erPWanOvb9S71BsbPrLj
         1ltkaQas5aiNRM0bdjEc7ENl+RU2zesp1JcV4eXHsu3yCwnXUKymSyHSOUFErgQBNFAP
         n4/GbWT2G/O0Z1c3fBtnrHK2MybwVgvyg2Iho1r6ugJTTpVw527zp51zcvHCfjOrKOZ3
         9obw==
X-Forwarded-Encrypted: i=1; AJvYcCUBTVNu8ELOQRPM3K76qCF/CEst0LPvBW57ZGV4aOgBse3DAX+MC4zgLb2kAdWyrk1AeIfH9BgbitRd@vger.kernel.org
X-Gm-Message-State: AOJu0YyMtFoBaNY6iIZhyw3vhfPqQx17ZpwrjcAuO9PBP6EcpKqA4hZe
	+1/YBELg0t1nKtK3ovGEQscXff6CTrkKFzpieM7GGRZCHhjmih0oZFry
X-Gm-Gg: ASbGncvOZsd+oYjACywMB5+p+tQvQLscGpX55STVWUbEhPZ8GOKJs/MhO4uUWReeW0K
	xKme5iFuRMdtOHWTwdZEr5G9T9OuCtePWDWu+MZcYqfpLpXpGQ+ON0+cCgHGT5t8OlaM+KLdN78
	AGFPpg8vIbC1/gl1vY+qdu0LxeiVxRyfSwN6fezez1X+0U+9WxXtG9A4ju6KItk4JSTYXiS3cFF
	F3Algko+lTwCJoIfePh7DREYBpdRU4AN5H2nQATufOMNLmniyEQsYR7a1EXXz8qNxBtRA+QgDgv
	k8ZLf/5UmWi6+Rliw60Nv1AoiPe/4kCrqoaP8UPJ2gUwl8H0dBYb9q5+vmWphbaBLxTJIvIui2h
	9rzk8Yf/H+EHCStOYThSWld15+NZZtdp/x9nICmLjYHLvlskAUSn2BUQ25IQQqezZ+6hs6xORZR
	7sQTFjxCz0ylbG0TA/ACgtIHw93/0lAeYheRDnuWqXFidgAoGS01gg
X-Google-Smtp-Source: AGHT+IECevNnqyxy2p4jQ72SNj7b8N5J3Um0O9yhSOD0lRRAmm5uHUCyTmn3w+0WoRXbh+e4mh7XkA==
X-Received: by 2002:a05:6000:40c9:b0:429:d391:642d with SMTP id ffacd0b85a97d-42b5935e340mr16975383f8f.5.1763505315207;
        Tue, 18 Nov 2025 14:35:15 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f0b60csm33431239f8f.22.2025.11.18.14.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 14:35:14 -0800 (PST)
Date: Tue, 18 Nov 2025 22:35:13 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ksmbd: Replace strcpy + strcat with scnprintf in
 convert_to_nt_pathname
Message-ID: <20251118223513.241aed65@pumpkin>
In-Reply-To: <20251118122555.75624-2-thorsten.blum@linux.dev>
References: <20251118122555.75624-2-thorsten.blum@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Nov 2025 13:25:56 +0100
Thorsten Blum <thorsten.blum@linux.dev> wrote:

> strcpy() is deprecated and using strcat() is discouraged; use the safer
> scnprintf() instead.  No functional changes.
> 
> Link: https://github.com/KSPP/linux/issues/88
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  fs/smb/server/misc.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/smb/server/misc.c b/fs/smb/server/misc.c
> index cb2a11ffb23f..86411f947989 100644
> --- a/fs/smb/server/misc.c
> +++ b/fs/smb/server/misc.c
> @@ -164,6 +164,7 @@ char *convert_to_nt_pathname(struct ksmbd_share_config *share,
>  {
>  	char *pathname, *ab_pathname, *nt_pathname;
>  	int share_path_len = share->path_sz;
> +	size_t nt_pathname_len;
>  
>  	pathname = kmalloc(PATH_MAX, KSMBD_DEFAULT_GFP);
>  	if (!pathname)
> @@ -180,15 +181,15 @@ char *convert_to_nt_pathname(struct ksmbd_share_config *share,
>  		goto free_pathname;
>  	}
>  
> -	nt_pathname = kzalloc(strlen(&ab_pathname[share_path_len]) + 2,
> -			      KSMBD_DEFAULT_GFP);
> +	nt_pathname_len = strlen(&ab_pathname[share_path_len]) + 2;
> +	nt_pathname = kzalloc(nt_pathname_len, KSMBD_DEFAULT_GFP);
>  	if (!nt_pathname) {
>  		nt_pathname = ERR_PTR(-ENOMEM);
>  		goto free_pathname;
>  	}
> -	if (ab_pathname[share_path_len] == '\0')
> -		strcpy(nt_pathname, "/");
> -	strcat(nt_pathname, &ab_pathname[share_path_len]);
> +	scnprintf(nt_pathname, nt_pathname_len,
> +		  ab_pathname[share_path_len] == '\0' ? "/%s" : "%s",
> +		  &ab_pathname[share_path_len]);

Ugg...
If nothing else non-constant formats are definitely frowned upon.
Never mind the non-trivial cpu cost of printf.

OTOH once you've got the string length, just use memcpy().
That way you know you won't overflow the malloc buffer even
if someone changes the string on you.

	David



>  
>  	ksmbd_conv_path_to_windows(nt_pathname);
>  

