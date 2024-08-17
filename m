Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3678239B;
	Sat, 17 Aug 2024 00:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723854616; cv=none; b=Prx+7c5DfelmYfrBlIRCcp74GPBlR7ipQays/KBqZtWMh3czJFHQjcZCrzJGygwJWaB/I9tlFtt0R67u/624AasCzoypJG+fM+7NKOnce8RZY9qpz3FPteLlYjFLoUrBpCpUPCiV0lRZJQcaqQjfo5jB208xblszLp7lDy5SkD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723854616; c=relaxed/simple;
	bh=FAkGEsJhjqOADz7JKeqOOU7K26VAPa64aF968gkWGa4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O/cLzLsecwSFj6rxKY5Pn/DuX0CqMIekXzLR6PQwxty9nyoZYvumbwNZ7ONBTUMX6R+1vDQkYxIahT6xlCHskgmdkBKd+AWoGujv6s/YTgjlIMWJ/Ccf3xOUrGT78CfpMzHmRMjIU74Xcp9MSj+q9k1Rs9xts7NpMKjFZjxTmWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SPVzQS+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SPVzQS+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F72C32782;
	Sat, 17 Aug 2024 00:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723854615;
	bh=FAkGEsJhjqOADz7JKeqOOU7K26VAPa64aF968gkWGa4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SPVzQS+y1kSJsIPI3vUI3O7XvU5cPk7uz/BVTQqoE4dugGxkOVIsn4iRa3CrfktyV
	 8R+ga2PJpme8wX3S6vAdI7PZNHcA6Cmpvn0p1tuDEElOxOKJLtU9R0hLGw2NhfIwGw
	 N+Mf2awB8YXWzVHRpySIuoxUPrXU1sMLsWyT+wdC21nUK4Fjk1higkJ0C037ytX8d2
	 DJ9Ueal+RrTlU7vAQbmuWTuipbOFlK97j1D+bONaJ0spw1mELulaj5GbErWdVQ0oEm
	 k80myezV9wFLZSgSQn3RKl3bSOgIIR+fxdCG7GIQuj0rnxmUd2BYqL1Ug3Ep05EArZ
	 8/4VAwvg5yZwQ==
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-27028b2cf22so411698fac.1;
        Fri, 16 Aug 2024 17:30:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV0ppODrIteauOHCqYK14eOPQSCFaOphKtUSNwzimhuPivwipR3EJhZxnIOdzf8QhfKKNAj9F+CKkmgR1S4peSNTevpOXQoRsvQZS+bn6L1c1diiOEmVAVep8uu4V9Yqs1GpaopMSzHtN2lHbgXGZUlFR85dLEnvmNOucsAo3kE/cgOEmqyp1qVYQ==
X-Gm-Message-State: AOJu0Yzvu3yNrBhLODXw+uS7P9JiZqeM3elVpOl6DStV+wG6DW2rpHLc
	3w27UVUkxk78qk7eD5p9OnzY5PmCIPA8J7mk3alME7R0rgP722jWdxhJCkXPbiPQHsNGpy72bI2
	IUvzoNZ6rubY8tqvtKKEIc8iyezQ=
X-Google-Smtp-Source: AGHT+IFW8SxLRtKfmlbUwBcoVB7CWjepKgCN2AfTWoesH/2xXv2YIHz9d30DrKAiCVNdHcnjHPv0TWuin9OTIwMjjWM=
X-Received: by 2002:a05:6870:1589:b0:260:23bb:1082 with SMTP id
 586e51a60fabf-2701db7c3dbmr2084536fac.10.1723854614980; Fri, 16 Aug 2024
 17:30:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816173338.151113-2-thorsten.blum@toblux.com>
In-Reply-To: <20240816173338.151113-2-thorsten.blum@toblux.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 17 Aug 2024 09:30:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_35FA+n145tZfvndmd85MakHd7w-AbV+cumUmTFxW=RQ@mail.gmail.com>
Message-ID: <CAKYAXd_35FA+n145tZfvndmd85MakHd7w-AbV+cumUmTFxW=RQ@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: Replace one-element arrays with flexible-array members
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: gustavo@embeddedor.com, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> Replace the deprecated one-element arrays with flexible-array members
> in the structs filesystem_attribute_info and filesystem_device_info.
>
> There are no binary differences after this conversion.
>
> Link: https://github.com/KSPP/linux/issues/79
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Applied it to #ksmbd-for-next-next.
Thanks!
