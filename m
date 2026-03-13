Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6968D329C7B
	for <linux-cifs@vger.kernel.org>; Fri, 13 Mar 2026 01:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773366597; cv=none; b=TVdqEuhFXRJSrHZbtnAAT2GSqt7+YbSblOc4np9G+ekyAx2bCsL8lpXwQRIBvJD09gyHkn5J8OFTsktVwMapJLfT+KDql+6PaHS+yl+VCo6Hta3gtfQAb0eCsxLAkDc8D7XoBmy7ofB8S7CypK7I3glU2yrog/xcdwDULKpOwIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773366597; c=relaxed/simple;
	bh=+PYPTaFu6q1gnew20OgpX9/Wgs422ul2Sws/v7jQIFY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f5VCqmsP8xZW3ADfoUe4BEDvngUGKQsGqdR1vQTuuoPWT6+oeAnfg81Lfua9zfEL3yyWE9EKDLcZj1cZlUBa/kL3WowYabFLiXn8D89uG45fffxU2EuGOY4Db+UjjiN9Obaw5AucVS0NsndtEWutDcxJLnibT/1B9xzeqTIKd10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M8ifcOaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M8ifcOaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30E6C2BCC9
	for <linux-cifs@vger.kernel.org>; Fri, 13 Mar 2026 01:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773366597;
	bh=+PYPTaFu6q1gnew20OgpX9/Wgs422ul2Sws/v7jQIFY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=M8ifcOaHQy57hlQs0dBf4/m7CvXQfdvSH3qm7pvHUzxhBujOoM/G1y9Lh1RTqAZzU
	 koUiSrAx7tLqGwHpEmnFHjL1h7UcwKtjuyh/xeGnt/R2Z3mMSigCPjLB0CBCddpsma
	 MRdZ/02uNgQqD73OZLyU59dXpgTvTa61kQzceg1yIJnlyT5CPPPewmyAKckiHYJQ+n
	 ihSMO4o555BlaFaPX1e7S8VAOqazxI2UpXibiqooBFExecW4mDnBGK1kKD+JmPZkpI
	 RRRPVsuKwI/70PjsuagBTjjWz7bxIJYPVY2YgDzRBcJruL5tDvO6G71mFKhtvYqRCK
	 kED88uCL/TQBg==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b9434f706a2so214359666b.1
        for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 18:49:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWSCaW6vXN1dNZIxZFjq9mQkqZB58d4Iwvf08DT3zdKku4FNQPssfUImQs/wAuQ6ZWh1VB9YcxPuJmz@vger.kernel.org
X-Gm-Message-State: AOJu0YyDM8kaa2JfEkRpu5OPkBEF76nM4zG5Uh9apVDKZj2fXk25JL8a
	r2j1B5RB013VMD/SXfmw48gmSaztGM2OoDRmrLi/hkTXRghZyKAvxeohfo33Af+6DUafN5078Qe
	cQKBLLNRcVNAkpDh19agrg3lc0ODMz74=
X-Received: by 2002:a17:906:d7df:b0:b96:d6cd:29e6 with SMTP id
 a640c23a62f3a-b97650145aemr72715466b.2.1773366595503; Thu, 12 Mar 2026
 18:49:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <abJ2fk0KaQNeHgmp@v4bel>
In-Reply-To: <abJ2fk0KaQNeHgmp@v4bel>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 13 Mar 2026 10:49:43 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8JQo6wgt=c_65VmD3NwveXSCGRCUi+vkXG6YSjfHU6nw@mail.gmail.com>
X-Gm-Features: AaiRm50-txnmwPNsTqAcTS7A2ch_MAxA6r-RKGh9spvGYAOC06jCoVu3lh7M0Qs
Message-ID: <CAKYAXd8JQo6wgt=c_65VmD3NwveXSCGRCUi+vkXG6YSjfHU6nw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix use-after-free of share_conf in compound request
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Add the same t_state validation to the compound reuse path, consistent
> with ksmbd_tree_conn_lookup().
>
> Fixes: 5005bcb42191 ("ksmbd: validate session id and tree id in the compound request")
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
