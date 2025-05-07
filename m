Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com [209.85.218.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD64F28E58E
	for <linux-cifs@vger.kernel.org>; Wed,  7 May 2025 19:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746646812; cv=none; b=OwUn+1joneDvBT9F3FHUjN3u6h8n4uqm3syqMFnNWeGaXEqlmE2OGlZrplGzaW9ed4CnJTMHv2Pt/DMuzIs0JSCvcgHobdrex6LxvM6+WLOrCcK3TD2HQ0QXZ+fMgL/dTJJWR2xYHflR4C3BQkExmxd+L6qWsZeyovoMofBRdf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746646812; c=relaxed/simple;
	bh=YZtJI4X1uS2H25igEE7zUk/CzwbhXeeaNVgKMO3AMGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fjwCT1mJ4MFpkiJ9B34C2EF/jVXfYnLvGlTKD52BFR/3ONUAHcsMBFZqmFX23u17RWpCzVXJDbQtid2hnySpJDHelJlMh2fCrJ6nFVaqMpbuivnzDSfpooE5WVMywZyHRP0aPDnbvvU7QgU6UGoqRLN3G0+nDbdIf1nrj6U3MS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bpaxxiYl; arc=none smtp.client-ip=209.85.218.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bpaxxiYl"
Received: by mail-ej1-f68.google.com with SMTP id a640c23a62f3a-acbb85ce788so37519566b.3
        for <linux-cifs@vger.kernel.org>; Wed, 07 May 2025 12:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746646808; x=1747251608; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5D3Y/5vFRXliYed731CLuJ7vlBKv7My5KxWNqr3jjys=;
        b=bpaxxiYlgwbXixuR8pF8EMh6wiNcaFC/aAjF5VcWVZR5o+Wug1bwYItJaDnxJbYr/5
         m5PyUKQQDopbBDS6a+e5bUD6YVVx9WI9VvnJtmbdoJVcOW82uEngW+NSHqhDsYasWiHG
         qM339ZiVf8XINNt9knOExbjUDbygpGwDN4chsd8sYzcDt1Is7bKoi++Z7NKZHtO7URUp
         908+vKE+ybYsvYIkcYf+cqf1G1c3jY3CXlMuYy1i3u5hXrKm7vr6aHT3qEG0Pp+8CYgJ
         +b4cGPooDiYstyCb9sFEkR3Pa3OaSEP6ctBsjtCMXHJaeMWencZj36Hr/u7OaaHA24xs
         vRKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746646808; x=1747251608;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5D3Y/5vFRXliYed731CLuJ7vlBKv7My5KxWNqr3jjys=;
        b=eUaYuISl7VfpEJJDdOZXT/PRwDFZ082OnncVSnNfv61uOnCnC6Y5AYJfQuPZ7AAzAH
         BjpIC0ySxznW6NLbRUynvDZUNmqVOK2dWvXRiN8KlzKvlHW+iUahTmCkYAtw0+k98veQ
         AOiUoeGXLhgMbpKthD/F7KrMOKCLQQBixsf+3NStSsBCe/PKoxuhYAroaLqiyDnRPH+4
         0mYoZ4dleMsA49Mgh7qc5hNHKrl/1l8kwkkcCScBpjsLaB7i1c3ue1uXd21AIkZuikah
         5cZwAK+JBXhGmY/NUykux7OuEeOdg2CRSUGQoIwPKWPsJ+5csEbtFASmIokHYQ6DLXAk
         mcZg==
X-Forwarded-Encrypted: i=1; AJvYcCXejdeZGUjL0PI3WbPk3QqIsLWMOp2kPmDu1/W1189foGemo0IuUGX7ToXo9Q3xFlw/pz82wtyXEYBo@vger.kernel.org
X-Gm-Message-State: AOJu0YyX5P/OT4vnFG9hjAnpFnzAu4ImZ5CmqpXoU959b3iHocQ3Ccnh
	PF/ExfPnB3dfKU2Ndr6At0tiFQCK5kPYXpEcV19i26PN3/nhDuYzNkCKZ7MDgoMSltR9Zriib8X
	dUTkYcQ==
X-Gm-Gg: ASbGncsvbgawgsW5VpwDxN5ji1yDXCsK3fQI8e52ritelwxduQ/6BEYiy4ie0aNBWU1
	JtUOigeKt2kbZYY2GeVqSwjPgPPt6JBqzB3CC6DF4KUR8xrrlRpkEZcPPruy08pcBmQ8YBdpzWk
	GSLoFquQ61EGdiKj7A0XSJ5lvViZPruLwV0mIQCug8c3EdYQDN6QLwRe0fRJkUxs1WzW3QjTpxp
	dAa/1AyBowOhJZBTQXuQlWEh9aAnalESa5lFQWpGaOIME9e9fcS77Aczh4Cww9qX+GozCQP0anK
	GEN0qEE/6FVQmHUkVRHERy468fPHp9CTAgwEztTSU1DYKksz6BsSWQZzgZBe
X-Google-Smtp-Source: AGHT+IFv2+tLUCcCzwMNkjfQVO2DxvTFAJnzrU2Fp12rkk/IG+YlHiZTYLlVA6NkATMLp9uv7UtSdQ==
X-Received: by 2002:a17:907:da4:b0:ace:cdfc:40aa with SMTP id a640c23a62f3a-ad1e8befd82mr480649566b.19.1746646807847;
        Wed, 07 May 2025 12:40:07 -0700 (PDT)
Received: from precision ([2804:7f0:bc00:f1b9:7b60:60cb:ca83:87b8])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4036f3406fbsm702470b6e.22.2025.05.07.12.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 12:40:07 -0700 (PDT)
Date: Wed, 7 May 2025 16:38:27 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Steve French <smfrench@gmail.com>
Cc: Enzo Matsumiya <ematsumiya@suse.de>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath S M <bharathsm@microsoft.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] smb: client: avoid dentry leak by not overwriting
 cfid->dentry
Message-ID: <aBu2swvrsvhnle2n@precision>
References: <20250506223156.121141-1-henrique.carvalho@suse.com>
 <aBr6zohhW9Akuu3a@redcloak.home.arpa>
 <CAH2r5muyz7zY=+Fgrtc_zOA6GR1ZSGpR-Z4pFzgqmfszhnywWQ@mail.gmail.com>
 <CAH2r5msisxGqZCFpJUu1Bqv5Kgo+-HD2DEO+wzQeSqG6TS2J6Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5msisxGqZCFpJUu1Bqv5Kgo+-HD2DEO+wzQeSqG6TS2J6Q@mail.gmail.com>

On Wed, May 07, 2025 at 02:01:08PM -0500, Steve French wrote:
> 
>    With both patches I still see the hang in generic/013 to azure
>    multichannel but it does still fix the directory lease crash
> 
>    [1]http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/buil
>    ders/5/builds/444

I cannot see the mount options for this test, does it mount with
nohandlecache?

> 
>    Thanks,
> 
>    Steve
> 
>    On Wed, May 7, 2025, 11:31 AM Steve French <[2]smfrench@gmail.com>
>    wrote:
> 
>    I can try some test runs with Paul's patch.   I wasn't clear on whether
>    it obsoletes Henrique's patch or if both would still be needed though.
>    Is it ok to run with both patches

I believe Paul's patch makes mine obsolete, unless I'm missing something
-- or unless we want to be extra cautious by keeping the dentry check as
an additional safeguard.

