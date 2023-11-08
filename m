Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E9E12E47
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 10:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jy0w5/LE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6C5C433CC;
	Wed,  8 Nov 2023 10:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699439790;
	bh=4DE/UXmXwifyDoiyNn3xcd+HmupemW0VVegJNlaiVqA=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=Jy0w5/LEk1q4a1LSiFS+Xr4Qei82UDVKPO2S1hwdc/3+AM94nqR2du/Pz6wXyQT43
	 9uCOMMUcpVn1wDyJuexTtuXnTnlGJjDPg32kEB75LnEuYvD6R1QoGxtIbdOmOwRp/G
	 RbXrtWVRIc1+cZv7PUoBr1k0h/jtL6PH8cU5nJrHICkZvfGLHkLT1IG8aSSj8sZ6IM
	 9RoVgIPHMBOaNcemnMEG/fTXBXrzW5hmxRiuIzkDt7F/1jY4JF/5SFnfUqo0IIsp+c
	 5i4YlFM4gDz1j2kLgcXp30CE8kROHeTdlePZp3Cu1Rb+RW/biX22vUxsJFl+RZpxUh
	 Wa6efsjJacFOQ==
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-586beb5e6a7so3706557eaf.1;
        Wed, 08 Nov 2023 02:36:30 -0800 (PST)
X-Gm-Message-State: AOJu0YzlAEyUlF/MfqHedz4rcn8p5LG3mvKD6xWso89dCGPqsLp2KciL
	+1UkYiiXPos+EtlC8LIqmo9LUQkwhR1+Enpd+2U=
X-Google-Smtp-Source: AGHT+IGLwZorB1H+KI27PyiNbnajcz/J20sDEAiVpP3YenI7b28dUxmcuzRh94trA14zuUxpmszLEN3ZnscwTMIhwF0=
X-Received: by 2002:a4a:e2d4:0:b0:582:99ae:ca47 with SMTP id
 l20-20020a4ae2d4000000b0058299aeca47mr1293303oot.3.1699439789311; Wed, 08 Nov
 2023 02:36:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:67d1:0:b0:506:a3fc:1021 with HTTP; Wed, 8 Nov 2023
 02:36:28 -0800 (PST)
In-Reply-To: <20231108081502.3113828-1-min_halo@163.com>
References: <20231108081502.3113828-1-min_halo@163.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 8 Nov 2023 19:36:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8qZTiSBR3aSUk4YRSo+LG-Z20FRJfGgV1Awf+Lep4kpg@mail.gmail.com>
Message-ID: <CAKYAXd8qZTiSBR3aSUk4YRSo+LG-Z20FRJfGgV1Awf+Lep4kpg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: prevent memory leak on error return
To: Zongmin Zhou <min_halo@163.com>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <lkp@intel.com>, Dan Carpenter <error27@gmail.com>, Zongmin Zhou <zhouzongmin@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

2023-11-08 17:15 GMT+09:00, Zongmin Zhou <min_halo@163.com>:
> When allocated memory for 'new' failed,just return
> will cause memory leak of 'ar'.
>
> Fixes: 1819a9042999 ("ksmbd: reorganize ksmbd_iov_pin_rsp()")
>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/r/202311031837.H3yo7JVl-lkp@intel.com/
> Signed-off-by: Zongmin Zhou<zhouzongmin@kylinos.cn>
> ---
>  fs/smb/server/ksmbd_work.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
> index a2ed441e837a..dbbef686e160 100644
> --- a/fs/smb/server/ksmbd_work.c
> +++ b/fs/smb/server/ksmbd_work.c
> @@ -123,8 +123,10 @@ static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work,
> void *ib, int len,
>  		new = krealloc(work->iov,
>  			       sizeof(struct kvec) * work->iov_alloc_cnt,
>  			       GFP_KERNEL | __GFP_ZERO);
> -		if (!new)
> +		if (!new) {
> +			kfree(ar);
Looks good to me:)
Can you add the below code to rollback ->iov_alloc_cnt ?
                       work->iov_alloc_cnt -= 4;
Thanks!
>  			return -ENOMEM;
> +		}
>  		work->iov = new;
>  	}
>
> --
> 2.34.1
>
>
>
