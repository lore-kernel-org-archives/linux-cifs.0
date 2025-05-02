Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ADB20766E
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 22:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746225795; cv=none; b=KF23wMwp0Usqf09vjo6ebcEE9ptdZCy4cMQ4lz8UF9Tg+xspIi176guBLNVrrabYoSygQZBgSBYk+knfdf7gFKeISOqUHb9lWspOMQvu006hA11ogurtQ0q+RVyEyrrksDqqmvQBBxKa2sQGMiJEXZyR5LcsW+xr+zqOAADxTYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746225795; c=relaxed/simple;
	bh=dCjgLPyHHie3XkdttxVT1nAqXGBGc9hKtElM+AGxrjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RlMKoBM6WHs/BnbHL7DQdMpjzSap2nwT7gWDDsOOm+gtJYfVEjvFU+5ZXEYdJPrQd0uTzVWq2Nqf6M4cvrlJI74DeapfPbWXVsTvCCOLwEk9PohpuDB65oiNaWWO7ziKZi7pyTducWptXhUrGW8uvuQXdAsBLtOJ1mTBq03pfhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X7RZE5d+; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X7RZE5d+"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e8be1c6ff8so4170777a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 15:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746225791; x=1746830591; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dCjgLPyHHie3XkdttxVT1nAqXGBGc9hKtElM+AGxrjQ=;
        b=X7RZE5d+GQ1WYCJ40qu/R23stt/B7HhCsC4+UxvcmvIxfudT+9YWyuB84CObfVLcyp
         lRgFw6e2qWrX44ocwPhQBCLLBpgw4YhW3OIai2it/ZjdTkMNQK0vrijTDRONzz9s1wPR
         GLFVNKD/R4y/qLoDcCszsZtJJHXrk8UheTmTksgYOnYFTTrAyJ044EHVp4sMB6+BEUjs
         zIIiMso++pWtbXbGPelRH7UksGi+m8e8fEoIUwZsdc6DiVL0qNtnTYThEa5pldbtkpDO
         byPYfRbvOCXYeCWiyxjTB9fr0A39KRa1gLdWxeDoizy1SGI1tAzhzVYPEj/Ouw3rLptE
         LekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746225791; x=1746830591;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCjgLPyHHie3XkdttxVT1nAqXGBGc9hKtElM+AGxrjQ=;
        b=M8qYGGLwoyI9dqb/ii8KFo+1POdun7/6WeK2fdRgXUfdT9V4nIr1vRarHb59qRiI0M
         slrwjw7FqY1AUSQiQ24bx8e4/dJMEskmj+RSUQ8WnUJjOQJ9SfewPvuob9fds+fkn/PG
         NkmapQHzwTpP1XkoxoxbFyy1mkJkt2dji1tcdWF2UjgkVeAzpbMiG0Qf+taf2XWnswuu
         ZxRXBg89/Yzq3j/oxwcnR0c4KL1k/rpFGtC6xktvfAbe/OBHsU9v9dnNqS/rCFoIo61S
         wmkh/M2swXXq+Bq7zqNbR5U5K1OOuCRD7Xd6BbKOZsYrFauSpWTyzelA9BjfO79nGXmo
         EmjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvq3jCcZk4IwBu8MMHTB7enbpzu54OH9rFWChQTYa6bV0B/Bc/aWpEERP6rJ+pz3jUOlBVg5xW3IFP@vger.kernel.org
X-Gm-Message-State: AOJu0YyDOy157Aonw2+oBRcvUtspC/dx95eDTVI/GLJPOwaDJ4hwtP5x
	S3GYjwtFEao0LI72S3jjRR4Zqh6iyo3jCWbllGo0DMerNDFf6uz8xa/YsKmGvis=
X-Gm-Gg: ASbGnct3ObFBftUph9QkyduySHZDgzf08jjRWahvdx4u01DvHBMlfHnfp35N/oSJ6rW
	uzuKh3N2rUBdjZhsjgsQQv7dAQ2vylRNvb2pXvDJNm8Hm21mGfi5u7bHuXLkRBU0Brk+MI0kDGq
	kLaDKC9dtEhxCyLSROl5YlE8nQMbOZQv2nKJCgxk7YKD5YTX1noXhI6S6GA1z/7g7NsKeHAsLTO
	1+UexcoR+fnAWvacUGwabVUAxpT/EZ5U6k8k8caE3yIp+eKlyl621YhbgY/cHo32mvthrjG/P5b
	gMWEMtovwOYX3L3UXfETEH2ZSPJVLmPoLO6kgD0JRhBNs3yp
X-Google-Smtp-Source: AGHT+IHaRNE+3M89TCMKgCzhACGmMmdp96qp93rXdBUbU5L0k2Jwp+4vDIQJ73dZ43vu9E0NLBhl7Q==
X-Received: by 2002:a05:6402:2548:b0:5f6:ef1c:c50b with SMTP id 4fb4d7f45d1cf-5fa78042ec5mr3750788a12.14.1746225791030;
        Fri, 02 May 2025 15:43:11 -0700 (PDT)
Received: from precision ([138.121.131.123])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a5ad86c01sm401151a91.46.2025.05.02.15.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 15:43:10 -0700 (PDT)
Date: Fri, 2 May 2025 19:41:31 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Enzo Matsumiya <ematsumiya@suse.de>, smfrench@gmail.com
Cc: Steve French <smfrench@gmail.com>, pc@manguebit.com,
	ronniesahlberg@gmail.com, sprasad@microsoft.com,
	paul@darkrain42.org, bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: Re: [PATCH] smb: cached_dir.c: fix race in cfid release
Message-ID: <aBVKGylNVgyqgp2J@precision>
References: <20250502180136.192407-1-henrique.carvalho@suse.com>
 <CAH2r5msw0gCUH29up7D5p2eH5LLGtmwu9E5PJagUi3S2trPHrA@mail.gmail.com>
 <fh2ose2otti5opro6jmpoo6dr4uhc2nfdrlgo3e2ikim4y4gqq@7zxtxyyhphah>
 <aBUpD0LzzzPUbRjz@precision>
 <aBUyL2ypuI2PTvoy@precision>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBUyL2ypuI2PTvoy@precision>

Using __releases() annotation seemed to work, I am sending a second
version of the patch.


Henrique
