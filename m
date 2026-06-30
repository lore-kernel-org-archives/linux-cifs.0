Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA8236F901
	for <linux-cifs@vger.kernel.org>; Tue, 30 Jun 2026 20:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782850076; cv=none; b=P3RXuaP8V58kgTUDKOBOuZRWJKbtT25/sQQ3ZUf2fK0MvlVXbF/7S5T06YNAeadGLR8AALCdC457qgbvh0Y9q9bkMcoarkSIv8d4Ly9hawvHlL4kCpcg2ge5O/VHNiGGIQwa8F/6NBiJQcakfh7LLXvVLnv6cP1X0CC8X7749xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782850076; c=relaxed/simple;
	bh=Hx9R3z3LE7iR6fdl2nNyJ7C4N0+oUAfJLQatai4KR3w=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=e3fpc0STLmn1lx+YPVtT54jVyi+EQnPFbBSNH9rH1u1N/1OC9X678Y2OVKbji4IQYzAt1e6eXkhAUryqT35OoDHi7DUrpaOnANji8vUxgr+PFr4nDnfux7W2WGSlnt0oGIdqcbHsJq83QB0F/OOo2ydZIHD5fpBgv/vwRE7/2iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Bl3890mp; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Bl3890mp"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so35351045e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 30 Jun 2026 13:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782850074; x=1783454874; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8H1SqQy9QmnaMv4+XSVbtjpvq/hMgtgGTHR9jpS7KaM=;
        b=Bl3890mpTs01vKo9fDKssPcH4xlJV0HPaodbly6D2Y8J4Sy+/Op6KkR8OJntspxlYu
         3SmprQ9gZV7tk1eqfoh+BF6iZmtP4OKFGWQsiZE6f9dbFhsUxgm7CP40b5Ak1/qyXJNJ
         8lP7xMkpBwpz3F3mDGS7dR0mDJqFXrEhO7jpGswVUM0MkDsLK3PoTCWauixkP0OphWqb
         W0gU4AYB+Gd87n24wNVwA65/hnerlYMruueOeJT4RTAg32tloXHDo/jNUVFOJbL2A0Wo
         lkwVLA5kJcVEyj2rgtRFcVx0EkYaUV0jLssRsYWMf6AHuKeYXvQ7t+/H2+/i+pp/WSOg
         DyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782850074; x=1783454874;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8H1SqQy9QmnaMv4+XSVbtjpvq/hMgtgGTHR9jpS7KaM=;
        b=lnhgzSOb/niRD6+J/R8E28ZDOu/xNVK3iAGm4VOGkG2FEr+e+hWuS5ZpYY8d/w1Lbl
         K/8Bo2j+iTzCkFzcBMHn48P8KuX8BVHolEw0Or4ZTOBTdgOC+Zr+2ahNrOVvaIZmS6PS
         NVr1e46/q6MAQbgm6HW3kD3Mhsa/vixc0qAJ5EgQs4tFU3qDAwKsDQDQnsYcrENWhnjc
         pnCXCVUFYzMlRJf7ssXKK7nbSQADaKGtPWyhvS98LT4vXBPzE1q0WD4t6/+5Vk4LBo+u
         GJC7DX27lexnT2KebRCwFDzjAQjDO6lVWwlDFYk7Q8bEgHf33ZL6KOZEmwIvlNamwFNq
         hdhg==
X-Gm-Message-State: AOJu0YwL098nVhjnd/LuEqmM98/DhLw/XA3eleDPbIFvVeU+xw4kbaZF
	6jeaRcV9qXyDIFn8aCwWMhNUb0GS0wxFDGwXtU1hDzTF604pm/4ieYzOU8YMUPiPJ0s=
X-Gm-Gg: AfdE7cm5z+rdee676l3JKPy0ArU6GU2ztRPS7XytKt4Umeudb7MsVZaezHxuw+FdKjy
	RlST5BoJhvGPOLYaQWS8qEV/p8J9X4vwlP+nriIGYvzRDe36yaHRiIesmWh/Eu/wkqYvy0PPbmk
	WM9qT/0sU2Ya/9QLj00o/mpluGM8zfIk7TzD2v7KBJIPsxSeguaNFcJmM57KpD0EOhV5mvKp4Z4
	xtkEauRZXTO3nCevxdg2dBUjBBlyPnXM3zIZ40aGf3dFLOiRNWyZ1BqgsjpiYL4ytFIBAYlLOcU
	NW7apSewx2byCrOz1tRQcHfnNENpznKCAKoY7YQYERnKpm+EtsqkbpX433Wz57qNJv3rMt0vtuS
	hIcHM1MKP8BqbIBugrxxjc8Deff4f4OqzLsABgCD9EI7rytHn/eyKeqkWnp0MGe3MkO5SVTkRfF
	zsU1li4LWrzbf+S2kc1QcT
X-Received: by 2002:a05:600c:154d:b0:493:bcef:5646 with SMTP id 5b1f17b1804b1-493bda38e34mr29944715e9.12.1782850073872;
        Tue, 30 Jun 2026 13:07:53 -0700 (PDT)
Received: from localhost ([2804:7f0:6402:b560:c546:35a3:485c:e505])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee31da63asm11004706eec.21.2026.06.30.13.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2026 13:07:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 17:07:49 -0300
Message-Id: <DJMNLR4D4KSX.2GHLCM6B2NH3K@suse.com>
From: "Henrique Carvalho" <henrique.carvalho@suse.com>
To: "Henrique Carvalho" <henrique.carvalho@suse.com>, <sfrench@samba.org>,
 <pshilovsky@samba.org>
Cc: <linux-cifs@vger.kernel.org>, "Bernhard M. Wiedemann"
 <bwiedemann+git@suse.de>
Subject: Re: [PATCH] cifs.upcall: Avoid int overflow after year 2038
X-Mailer: aerc 0.21.0
References: <20260630195521.1188778-1-henrique.carvalho@suse.com>
In-Reply-To: <20260630195521.1188778-1-henrique.carvalho@suse.com>

Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>

On Tue Jun 30, 2026 at 4:55 PM -03, Henrique Carvalho wrote:
> See https://en.wikipedia.org/wiki/Year_2038_problem
>
> This patch was done while reviewing potential year-2038 issues in openSUS=
E.
>
> https://web.mit.edu/kerberos/krb5-devel/doc/appdev/refs/types/krb5_timest=
amp.html
>
> Signed-off-by: Bernhard M. Wiedemann <bwiedemann+git@suse.de>
> ---
>  cifs.upcall.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 01690df..1cc9767 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -247,7 +247,7 @@ static time_t get_tgt_time(krb5_ccache ccache)
>  		    !strncasecmp(name + KRB5_TGS_NAME_SIZE + 1, realm,
>  				 strlen(realm))
>  		    && creds.times.endtime > time(NULL))
> -			credtime =3D creds.times.endtime;
> +			credtime =3D (unsigned)creds.times.endtime;
>  		krb5_free_cred_contents(context, &creds);
>  		krb5_free_unparsed_name(context, name);
>  	}

