Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356B443169
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 15:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746198869; cv=none; b=MG3mHFzz49TtKN8Kfsz4/n6Ml6ZXySS5JxjAQO3laJ/9v0WGR2NEyDRc7481/PH/usqtyMfUGRhYbB75EvLoZNCZhZR2Ky6LUpGd1cvDfKCY07GPMXoQB198Iff7PGXmSydnTLFeGND7FA9AtxOw3ft75riXj9bjo0+XFxRV/6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746198869; c=relaxed/simple;
	bh=2MZhHw06gm21gX1GvtfkiLrkxBaAtgFe7lhWiUbpkLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WkQQ7mrPK8T5dUGQIsiK/HGoPIsniaDxblnF9rzMGpLJAd8jW5zFltf0/4xamgN2PdfD8H+w0q9CtTNsoK2UTY320W9Eld9cYRU/kAregNSd5N2kcpf1uXfByqbPdkI49Gt73g3nZiebOsNKtG7tP7BKdCxsY+Mq0/D0oj4XSfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F3t5AVRt; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F3t5AVRt"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac6e8cf9132so399604766b.2
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 08:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746198865; x=1746803665; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7gq8hseqwi/gHQx1r6qoqGp2kSpWCXdI95m+XKWMWr0=;
        b=F3t5AVRteRqApBsiC8ALVyLPF0uxx3zv5Eb/zVT5v2WoW7xDKRzo12HoEEjmDA81XY
         FUMEpfmVqctaVlwrvQNQLqbmItViGNuduPo9mHN/TCQ+m/LIm/I/crMyO6jpfFSpHCMB
         eD1BljkFiqY5kyg0c7oxmh843axrYijnHiVHSCBXXeQzuuUhbVArCCLam2dfezsN1/x2
         s7JSgLn7Q/0el2bzhcBaHqr1x5ZrkFKkEpJyqaNcKZmRP6AX6ky2c8tD2WMEdt+xlLRn
         fCG4jT++2a80eOcBxH2SDJ9EU4NlX8c3A7tdh2ieS0jn6vaBBe66DGaqfIQd01dktgBo
         zb5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746198865; x=1746803665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7gq8hseqwi/gHQx1r6qoqGp2kSpWCXdI95m+XKWMWr0=;
        b=X33UdnbBnBK/Sg0VNog5N+45CVxo9+sCtnMeOYGBrgpjgGBEv5icSal6V+OGEdSEg3
         PQTeT7bXP/3hBNQKR4ELVjgoyDp/Efe80rDrJD49QP5A7wLIVbNyGVJAZfMsfHkJXP4I
         DMXfCj4tOAVU1KgUaBtwM+MyqZfOngKBNZLyhHWz1QBTD4Ln53I1Z4y95u1944jpevRQ
         x/ryCGWzh99Ng59ddKUaL+4nuxIDRSs71QAZT/O2fLU2FQWiY4NhjPF/t2Jh/GPlyRkf
         +UKowhQEsh3uWiZ8qkgCtPvIdFd+xPnN/JbaD7AjKLLuveJG/ZBsMkhojd7Hz+q5om88
         89uw==
X-Forwarded-Encrypted: i=1; AJvYcCWSmxCZkaroJQ0aLcFeHedDAqSrw5pKLhIGUb7/pT8QNYBCOZCZSGQvoeQIn/wv2XNWgMCabRY+uaZF@vger.kernel.org
X-Gm-Message-State: AOJu0Yxpf1Htii2zWb0Ojpww06AnxUXJyocG9MHcOojeH29cz6yxOppZ
	DXbiyrqp2XpRl83eDTN8YoSnfinjP5LN4KCLcrO2of1vlBQDTXqQN2+U0Ef0NvI=
X-Gm-Gg: ASbGncta3a5Cj12iSB/r1rWHGpfPuM4ybi4NzJ3oPJscA5ErFbLdS0Otgyzs0tcRuCY
	7j1/0EawJT93XpugYHS+ekgI33G2/zGFUOJ6qITjchtK2b1kf1wODz9NwqJG5gdLXGicpfTYka8
	gkK1w9ZILqQlcYGlJNDH/sAkRjXWCZ5bYfVyZTKiVDkpyCDlxZp0JZmf0+6OxSmtUpdGvhTar+K
	EVtkW3ZyOkYDE93mVAZXqr9vPJjOGMusY8DFjbRZw5zksd+uWLMvvsAo8pfb07QygqquviBuz3S
	mEteokjU/Hir9il/Zchw9bgbbBrVvCwqf4hDoVyC+BrX/Yq5
X-Google-Smtp-Source: AGHT+IHPBL5YU4UBo8WIJMp5ICD5akUjvbaf8bLoOGaSknWPpGmhxDjNJTFbSLzF2QHGZFncXgRuQQ==
X-Received: by 2002:a17:907:9620:b0:ace:9d90:cdd3 with SMTP id a640c23a62f3a-ad17b8630e7mr288683866b.49.1746198865421;
        Fri, 02 May 2025 08:14:25 -0700 (PDT)
Received: from precision ([138.121.131.123])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a3480ea02sm5883938a91.33.2025.05.02.08.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 08:14:24 -0700 (PDT)
Date: Fri, 2 May 2025 12:12:44 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: nspmangalore@gmail.com
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, ematsumiya@suse.de,
	pc@manguebit.com, paul@darkrain42.org, ronniesahlberg@gmail.com,
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 3/5] cifs: serialize initialization and cleanup of cfid
Message-ID: <aBTg7K778dLsIFXS@precision>
References: <20250502051517.10449-1-sprasad@microsoft.com>
 <20250502051517.10449-3-sprasad@microsoft.com>
 <aBTgTCnAn4S-UT9V@precision>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBTgTCnAn4S-UT9V@precision>

On Fri, May 02, 2025 at 12:10:04PM -0300, Henrique Carvalho wrote:
> 
> Second, I am not fully convinced that we need a mutex there. :/ I have
> thought about it many times and I could not get a proof that there is a
> race happening there.
> 
> Third, (referencing PATCH 2) even if we have a mutex there, shouldn't we
> just let the thread that just acquired the mutex retry to acquire the
> lease (which I believe is the current behavior).

Here "there" means open_cached_dir.

> 
> Thanks,
> Henrique
