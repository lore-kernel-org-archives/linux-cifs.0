Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A86729E11A
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787037195; cv=none; b=ESdEzJcw3nFk6x5SiMB47m6G0ieqOn3z6M1H+eQjs+r47V8/CY2gK9t3RwkmIWvcK9kYeug02hOn0Ct9JtVBz5zzZhpKs4sB10K7HfB6+PdhPTsaf80qaXfa4P+Ss7pzIVsGmYH91opw5Yxly/BkMRwgA9JawPZw3h3NQ/bSEI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787037195; c=relaxed/simple;
	bh=JunbrMh1yI0mkLFpGxtU0Z5pI0zE+QPz5j4D4HgGYWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=INMRpu2Y2Inxe0xFL4XEhETBOUsYhfpRxzkncWDbhfVQ+p6F4P15nr0bqCSBVS+8aX9fw+IFzeiMC3qAZ15EGGbmTq+iM3YRknz4R/D7PUBlsiVaXhTGOPBDGE9E0muJ+JakgdpWvKtpB+hvmV3H/yCYH3QAPaiuqvi4pZCe+mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cB0DY737; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cB0DY737"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56A11F00A3A
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787037193;
	bh=A85nw1UST3SqzMgqsoL2q4u0M4lJIKKLMkysCrurgwo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cB0DY737B0fMYYPRHRv/ME58NSxcYq4ExTY4VOFDm8VIuporTlyklFSFl8NNCU6cn
	 zqxZst/WhAxOmp05ygRylmv3uxJfKfIlHuliaDsR3R2esvI3BY1DWW1prF2BZC0jDK
	 GMKAm0J7g1N0wiSo7DpEWyShYy7aVtxVOSG01J5Nl8290BwT99O/Er/kLocX+BKPyG
	 5nCIO9dnjUGyP8weroqy2a2aZ9n08RbtmLQL/GkVa1n2c1AkOxXhS2r2I4KfQFVbuo
	 zitQ/HLyxZ/n7bQAaJ4gOH9xbunlXy2/x0e9gXNOMM3GPMepvN4PKH2N7nKGAvUz9p
	 jsPbCwukVAw/A==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a3819e8be8so1394875a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 00:13:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro4t2yaN4E6/U6ZdClQhzmK3/q2SLgxy6FS7Gm5xNKvGHzJoo8RJZoJvG0D3FDdum7ycE7+5Sg1gJp9@vger.kernel.org
X-Gm-Message-State: AOJu0Yza7tecEdDi3LYTLdyazREUcN2drmR3Pu3dJ0XqfKtBLEOLzcI+
	qCvgjLJh0FK5vnWOO38wM94RjtJ4qNc0pg65kVtZSuA9qS22aqOilz82AGHjZo40zxgmol42Gl4
	grqUxHKfzKTeLEI7fYRQsgcbSz6wpo3I=
X-Received: by 2002:a05:6402:24cd:b0:6a0:9ce5:3f5c with SMTP id
 4fb4d7f45d1cf-6a3e3c986f2mr2122879a12.7.1787037192330; Tue, 18 Aug 2026
 00:13:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260813132136.366532-1-huiwen.he@linux.dev> <20260813132136.366532-3-huiwen.he@linux.dev>
In-Reply-To: <20260813132136.366532-3-huiwen.he@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 16:12:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9=LsiPNG3=+-x44fvowpT0oXWtHwL0eYy8zEtLGR4POQ@mail.gmail.com>
X-Gm-Features: AcwNN1VKDwbxBmgKxuvvbMmkeXqoEIhqs_CeD8qa7IxmiHBEqdVpWzOSht39tTI
Message-ID: <CAKYAXd9=LsiPNG3=+-x44fvowpT0oXWtHwL0eYy8zEtLGR4POQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb/client: mark file sparse before emulating insert range
To: Huiwen He <huiwen.he@linux.dev>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@kylinos.cn, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index bc7dda6d825a..430b6a1a2d92 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4006,6 +4006,12 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
>
>         count = old_eof - off;
>
> +       /*
> +        * SET_ZERO_DATA creates a hole only in a sparse file. Try to mark the file
> +        * sparse, but continue the emulation regardless of the result.
> +        */
> +       smb2_set_sparse(xid, tcon, cfile, inode, true);
Shouldn't this error be propagated? Unlike ordinary file extension,
FALLOC_FL_INSERT_RANGE is required to create an unallocated hole. If
SET_SPARSE fails, SET_ZERO_DATA only writes allocated zeroes, but the
operation still returns success...
