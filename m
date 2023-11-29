Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FB83D8F
	for <linux-cifs@vger.kernel.org>; Wed, 29 Nov 2023 05:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kudsE8/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDD8C433C8
	for <linux-cifs@vger.kernel.org>; Wed, 29 Nov 2023 05:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701234756;
	bh=ysu+2eSq6wVSjP4uxzWx/54QyFxDVB0qbzkNHJQVLpg=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=kudsE8/A+p78QyffsT31FR8aPhNAXLyJtjcPp8JA8GifrqvwjT/I3NbWSZNqVZyTa
	 +mk93+VRmxN9BYs425QDNFUT7goWz0k8J87faIalyA1DK0W/DdjKXe1IDB4/9EkrKw
	 jfStp3x70a2MZFD/B4TVvNSpDz30kGrgtHebYNRrc/rdcNX2aA49aBVB9+h6/EfQKo
	 xCRuWLExHaNd51Q08KtJxtfeSqN5nTtPBQjHyno+Hiri2iJqd6sWquXSxMcRfFSB3b
	 5Q3jGnjqrLq3kQuqX9Md4LWFU6pV60tVcQaqacXhTEdsg6X8/DO08z5y/Oo49z2HPg
	 n1r/rhehpmdlg==
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-1f0f160e293so3655562fac.0
        for <linux-cifs@vger.kernel.org>; Tue, 28 Nov 2023 21:12:36 -0800 (PST)
X-Gm-Message-State: AOJu0YwIT2cGlZQPI+ik7PX7yVmvCMCrOB23vOfcgXM8CDwRpqAH57Hd
	ecJw5TkTOMGOb50xGvxZCsr8sFKlBLMVx4QwZrU=
X-Google-Smtp-Source: AGHT+IGM8sF8epMfgyWTU/yhA0Osu/2rKMGWcMR+sXop7rImKevoT5MxnOw2Dma1JU5efsPk24pjS10yT7rb2NAcHc0=
X-Received: by 2002:a05:6870:b418:b0:1ea:2e2c:e9e7 with SMTP id
 x24-20020a056870b41800b001ea2e2ce9e7mr19393614oap.59.1701234755331; Tue, 28
 Nov 2023 21:12:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:5bce:0:b0:507:5de0:116e with HTTP; Tue, 28 Nov 2023
 21:12:34 -0800 (PST)
In-Reply-To: <20231128105351.47201-1-dmantipov@yandex.ru>
References: <20231128105351.47201-1-dmantipov@yandex.ru>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 29 Nov 2023 14:12:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-QzUq4Ejv6Q8BFPHes-vSwqJW-kPt6tfhTu=h-OKAHsQ@mail.gmail.com>
Message-ID: <CAKYAXd-QzUq4Ejv6Q8BFPHes-vSwqJW-kPt6tfhTu=h-OKAHsQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client, common: fix fortify warnings
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

2023-11-28 19:53 GMT+09:00, Dmitry Antipov <dmantipov@yandex.ru>:
> When compiling with gcc version 14.0.0 20231126 (experimental)
> and CONFIG_FORTIFY_SOURCE=y, I've noticed the following:
>
> In file included from ./include/linux/string.h:295,
>                  from ./include/linux/bitmap.h:12,
>                  from ./include/linux/cpumask.h:12,
>                  from ./arch/x86/include/asm/paravirt.h:17,
>                  from ./arch/x86/include/asm/cpuid.h:62,
>                  from ./arch/x86/include/asm/processor.h:19,
>                  from ./arch/x86/include/asm/cpufeature.h:5,
>                  from ./arch/x86/include/asm/thread_info.h:53,
>                  from ./include/linux/thread_info.h:60,
>                  from ./arch/x86/include/asm/preempt.h:9,
>                  from ./include/linux/preempt.h:79,
>                  from ./include/linux/spinlock.h:56,
>                  from ./include/linux/wait.h:9,
>                  from ./include/linux/wait_bit.h:8,
>                  from ./include/linux/fs.h:6,
>                  from fs/smb/client/smb2pdu.c:18:
> In function 'fortify_memcpy_chk',
>     inlined from '__SMB2_close' at fs/smb/client/smb2pdu.c:3480:4:
> ./include/linux/fortify-string.h:588:25: warning: call to
> '__read_overflow2_field'
> declared with attribute warning: detected read beyond size of field (2nd
> parameter);
> maybe use struct_group()? [-Wattribute-warning]
>   588 |                         __read_overflow2_field(q_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> and:
>
> In file included from ./include/linux/string.h:295,
>                  from ./include/linux/bitmap.h:12,
>                  from ./include/linux/cpumask.h:12,
>                  from ./arch/x86/include/asm/paravirt.h:17,
>                  from ./arch/x86/include/asm/cpuid.h:62,
>                  from ./arch/x86/include/asm/processor.h:19,
>                  from ./arch/x86/include/asm/cpufeature.h:5,
>                  from ./arch/x86/include/asm/thread_info.h:53,
>                  from ./include/linux/thread_info.h:60,
>                  from ./arch/x86/include/asm/preempt.h:9,
>                  from ./include/linux/preempt.h:79,
>                  from ./include/linux/spinlock.h:56,
>                  from ./include/linux/wait.h:9,
>                  from ./include/linux/wait_bit.h:8,
>                  from ./include/linux/fs.h:6,
>                  from fs/smb/client/cifssmb.c:17:
> In function 'fortify_memcpy_chk',
>     inlined from 'CIFS_open' at fs/smb/client/cifssmb.c:1248:3:
> ./include/linux/fortify-string.h:588:25: warning: call to
> '__read_overflow2_field'
> declared with attribute warning: detected read beyond size of field (2nd
> parameter);
> maybe use struct_group()? [-Wattribute-warning]
>   588 |                         __read_overflow2_field(q_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> In both cases, the fortification logic inteprets calls to 'memcpy()' as an
> attempts to copy an amount of data which exceeds the size of the specified
> field (i.e. more than 8 bytes from __le64 value) and thus issues an
> overread
> warning. Both of these warnings may be silenced by using the convenient
> 'struct_group()' quirk.
I'm confused by your use of the word "may" above. Did you checked if
the warnings are silenced with this patch ?

Otherwise Looks good to me.
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
