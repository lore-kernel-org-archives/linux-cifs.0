Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253B615AAC1
	for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 20:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731531149; cv=none; b=OuNOBhQSx52IM/XicJ6U9o2NsmjBmnbMuWpaxR10/AM737Y8bBEXiO4OmF6DUi8BFP8zajlaoH41apsgxThMqWTT2BGDnHBUmUo11YdaH9HYiCkuJUHHJ6hD4AVv0sz4HwzHC+n6Y0bkvT8lL9yZMqMmAljnGIQV/FSgwVviArg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731531149; c=relaxed/simple;
	bh=Z1q4sSc9txO9PHvRHMRoED/JdQn979+VCwCPJ6fzi8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s4tqDCKLp/AVBDOUhSVN9metkAETMaxyKCNy7akFwpghLDXKZkbHmD+1eKOCRNFYJzHl7NRZTvTTBG3f3t0/8UN03nxxdZBnHW7hGEgNSCqMFJsmxP03F9GI3TKQd9GYj5gHdiW5jZreiBN7aHou5IkXl4sbvHcGLHNiYiT7RfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GGxNz0oi; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GGxNz0oi"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2e3fca72a41so5900807a91.1
        for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 12:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731531146; x=1732135946; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Z1q4sSc9txO9PHvRHMRoED/JdQn979+VCwCPJ6fzi8w=;
        b=GGxNz0oiuhXpdaCCPWVEYAgCCL3a+H+/GgMLLhQG6UrKScWH8F/ifO/7tXREKyr+hV
         TRv8gy9pGvfNOKPR62rpIkPPuzj99MThQ7hNlBbm5VymDjns1wWRucqSAjr9sL9RtEqL
         BAIBDSwWB26lsoAlDz9uwwWJb2kI9LP9edJZ5afScNKosU/r2Bwe0zJ5Vl+bYdVWGDA2
         0j9HDY7Ey7rDxCK6cBsLCUxFQbVAoCzTlWGQbDM9D9SydX6zeYnOlrcRob+ezYz0SmQh
         RpcuGLhkNGt7IzmxRIWMNlej+eSwT96Iqni2jzj8Ipwf5h7jEaXaMMcjqarHT45wGSmi
         Kxyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731531146; x=1732135946;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z1q4sSc9txO9PHvRHMRoED/JdQn979+VCwCPJ6fzi8w=;
        b=qZ4Ni77EJgtcKjt9dojZ0oS3GQWSMBIcALGZF6W7Eix2DXyjrx01zt2E15hExVQIuJ
         hrqsAnxox65AYU78uWmqhrBDkgcIaWtMh07zv8D8CN/oFe2BXtbQrDIX2cPMlvIsF4zY
         BUtkztX/Lim+0v345ho7TuXuSvEgPbAg/Jpp4ZKRr1pMl9N7+RuYzS4w9OwZGYj0pD0V
         K/LwCei1KD9tekRWsdJzGB5OaH1SfqZl67sVQ0jfvcPWSo5E/pH2PFDnnyNPC5nL4PoH
         rk+jrH9yeSau/uVt4vwOWFI+Vn08hsEqqviGmaoIpIbCnvw04jYw4o0EBOf+igh9x5Oy
         HtOA==
X-Forwarded-Encrypted: i=1; AJvYcCX2MJr/+7pgIVdFF4MGhcpW1oxNwqGrkcjrX6/jObTSq2bFJCJiy4aAxTDolN+fNmmVHzIfZ+Zw3cY6@vger.kernel.org
X-Gm-Message-State: AOJu0YwiZ+5NJB0rVZqAaORAbjsubJybPqhY56P8cQicVfZkd+686UVr
	lryDpfKHTGlk25l9OfPF+7DjpCIhmDSjxVi2JJu4EMWkrw8PEq9lJ91NyViBdAgcL/XmGtCzQtQ
	wIpWhB7caBk9O2E81evBIawNd7wPJBia+
X-Google-Smtp-Source: AGHT+IHD5fPE4ssrv1m2sQfxj4ffKpTIL2G8lurMRzGksQLb5f6C0CYVOkRpxmMOPS5jO6qLcM9TJRU1TpezR0zgloQ=
X-Received: by 2002:a17:90b:268b:b0:2d3:c638:ec67 with SMTP id
 98e67ed59e1d1-2e9f2b3e437mr5740932a91.0.1731531146294; Wed, 13 Nov 2024
 12:52:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <8b57433e-a203-465c-b791-07471439ce86@samba.org>
 <ba86c7247ca08bc1553f6bece0987ca0@manguebit.com> <1f6416d3-5579-4a6e-aa75-351158a35e86@samba.org>
 <0447a472-9b60-478a-98e4-9f07a058380b@samba.org>
In-Reply-To: <0447a472-9b60-478a-98e4-9f07a058380b@samba.org>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Thu, 14 Nov 2024 06:52:14 +1000
Message-ID: <CAN05THQ=fx5hfp=FFRw4D5hCHvcoU8bs6cbeZT2X4o5i=QZkGg@mail.gmail.com>
Subject: Re: chmod
To: Ralph Boehme <slow@samba.org>
Cc: Paulo Alcantara <pc@manguebit.com>, Steven French <Steven.French@microsoft.com>, 
	Jeremy Allison <jra@samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Samuel Cabrero <scabrero@suse.de>
Content-Type: text/plain; charset="UTF-8"

On Thu, 14 Nov 2024 at 05:07, Ralph Boehme <slow@samba.org> wrote:
>
> On 11/13/24 4:39 PM, Ralph Boehme wrote:
> > Am I missing anything? Thoughts?
>
> did some more research on what the option modefromsid actually does and
> I guess the problem is that the behaviour is likely correct for
> modefromsid, it just doesn't work for smb3 posix, so populate_new_aces()
> needs to be tweaked to not include sid_authusers.

Remember, it also need to work for use-cases with normal Windows and
Azure servers where you do NOT
have a multiuser mount (i.e. all client access is using the
credentials from the mount)
and you basically have an inherited ACE to "allow all access to the
mount user" for the whole share.

>
> -slow
