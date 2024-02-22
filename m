Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FA7182D2
	for <linux-cifs@vger.kernel.org>; Thu, 22 Feb 2024 10:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708599588; cv=none; b=pN/6LZ6bxzUIJybM31JAH3q2CT8YiKU6m5QkN7re1Uo8lxcN1d6GbTls6L/uTBOEnOOwAe0f+fvD6T1vvt+juP3d9ef8t3vqSU/tsukCJ/dDsoNgopLr5cGAVgg6whqTyxNvGxPapYsJfHFyRrAOmJPigPWB+DnA+KDtJ+VJJgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708599588; c=relaxed/simple;
	bh=cztcTemOY5qrfcyaTt7BhxLARF9Co5w5kdiVX/DSwEU=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W16w5lGFWHIN2QpdSyEXQvkhak2jdJT95VXKOs7DrM9L5pxS3gzBBZKlL62jJxoRftoayguYjSqmMzuFML5kL3ppWUM3E6fStNoszts+2tEBwuEaHSQwyA7xBNvkl9+Ti04OohKKAiFtniNKBh6nG4JzjpP3FZAK5JjCH3bD5yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qF0s2JLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qF0s2JLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFBBC43390
	for <linux-cifs@vger.kernel.org>; Thu, 22 Feb 2024 10:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708599588;
	bh=cztcTemOY5qrfcyaTt7BhxLARF9Co5w5kdiVX/DSwEU=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=qF0s2JLsiwp2FgyUjjz1TcuvPnkSonO/b+vhwcGXVKXpu8c8NN9YnpiySVuyt+yjP
	 Q0ktif5BQ+JAal23TscRjnyRBmFjpMNDet55C4LFLGnwv9O++V64JalLpu6YO1LBpz
	 eeKztun2+ddwPFZB2xnazykJsKR8wXsbw+NgyvNNxUDvvbgorWzp+YIxt8/Kf7CVaY
	 eqRieNJyfwOeroYHZuxEumiYVgx8l6DAQK8UUWWe3QpH8e6NPyuxW/OUcKQL6bQ5WD
	 vg5cfHXwHLszTQvnbtLgMr2mIXIN7mmU8pxm8ghV3IuL6baU5e3Z87vKAk1QV/nPVC
	 7rTmqpqK3xadQ==
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5a02eb63ebcso198052eaf.0
        for <linux-cifs@vger.kernel.org>; Thu, 22 Feb 2024 02:59:48 -0800 (PST)
X-Gm-Message-State: AOJu0YyAn/MVvs6jN2AF5BJKjDcjuOqNFDm3+ricTDVmlLJmKEFhWoIk
	BKJ3/x5Lo49GqBGEGNDazec0dnb4GV4Az6Zek/gvkY0K2IuV80RhfAA0kYDbWDICclz/L0CfgZv
	BpO9JDrUHPJYEp2iRXw5SljSAoS4=
X-Google-Smtp-Source: AGHT+IF16NFOO/ZMJtzsKKbxRS+B+nyie7adPuv4hVqFqQiW/TFEzn8o/oBml3VL5hyGTDGe/9X2yZiE94d8/G3DRf4=
X-Received: by 2002:a4a:dcd4:0:b0:5a0:3917:5d4c with SMTP id
 h20-20020a4adcd4000000b005a039175d4cmr130244oou.7.1708599587432; Thu, 22 Feb
 2024 02:59:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:a8a:c12:0:b0:51b:642f:123c with HTTP; Thu, 22 Feb 2024
 02:59:46 -0800 (PST)
In-Reply-To: <20240222095819.2188726-2-mmakassikis@freebox.fr>
References: <20240222095819.2188726-1-mmakassikis@freebox.fr> <20240222095819.2188726-2-mmakassikis@freebox.fr>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Feb 2024 19:59:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8HS5vziqN0Q8vFAuA1J_q214PcUPcR+wmomqFjb2eG2Q@mail.gmail.com>
Message-ID: <CAKYAXd8HS5vziqN0Q8vFAuA1J_q214PcUPcR+wmomqFjb2eG2Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ksmbd: retrieve number of blocks using vfs_getattr
 in set_file_allocation_info
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

2024-02-22 18:58 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> Use vfs_getattr() to retrieve stat information, rather than make
> assumptions about how a filesystem fills inode structs.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Applied it to #ksmbd-for-next-next.
Thanks for your patch.
