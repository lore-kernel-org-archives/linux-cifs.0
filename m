Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF591C69A
	for <linux-cifs@vger.kernel.org>; Fri,  8 Dec 2023 14:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="un/wZTpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2CAC433C8;
	Fri,  8 Dec 2023 14:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702045261;
	bh=JOtD1DOhXlfVvnrx+f1+DddFHaCUh51yjl0aSXnPpNw=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=un/wZTpM6pSmFo3OZlrs+LL1GzClYj1GO/pdatQS2WgtOatGpPPindQtRwFdxaqCJ
	 MDiNsQwwcV5r9O0stHddLa4yqxX0oi/fqDM/I8OhXdYeeJEyOGwv4voM8foUW/X1SF
	 ao+i7f97U1I82D4P6pSaGRZXh16K0y7mFUpXjyf0ljc6Xfj6Mt/LtJY8Z5CjuHPPYn
	 SZn8d/yKl6s3MUtQ8yufbp3+pZ1qfclRHgymqSlWz7nzF5zflhGA2shqtuMf8rxImr
	 KMx5YQKIyiZI1mr30lDE7Nga61hTqJ9fkaTsoWSMTDLFXRFZnomHHqVQi32DHV82jD
	 scjatOFlGedCw==
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-58ceab7daddso927306eaf.3;
        Fri, 08 Dec 2023 06:21:01 -0800 (PST)
X-Gm-Message-State: AOJu0Yzol8UEc2nYj0C5jmNYW3Wl0LHOW72tbfr1RHVSHV5rqeGDeNMm
	GR9lm3Y0PIr/2XY+KAyRIv2COjsGEKpD7/uXfjA=
X-Google-Smtp-Source: AGHT+IED6wRybN3tBltD6Fig4oscaFf6bVQWuGCEEo/BkOdZILnE6MYcWJ6+EutoYFi/q45V2rPOFwPGLKIwdDQqVf0=
X-Received: by 2002:a05:6820:2293:b0:58d:6e28:853f with SMTP id
 ck19-20020a056820229300b0058d6e28853fmr184045oob.9.1702045260395; Fri, 08 Dec
 2023 06:21:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:5dc6:0:b0:507:5de0:116e with HTTP; Fri, 8 Dec 2023
 06:20:59 -0800 (PST)
In-Reply-To: <20231208065647.745640-1-linan666@huaweicloud.com>
References: <20231208065647.745640-1-linan666@huaweicloud.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 8 Dec 2023 23:20:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9t-J+BV72u_JdYD=MrOyat1Nx1=Jo8rBa59qtsrNviDg@mail.gmail.com>
Message-ID: <CAKYAXd9t-J+BV72u_JdYD=MrOyat1Nx1=Jo8rBa59qtsrNviDg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate the zero field of packet header
To: linan666@huaweicloud.com
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linan122@huawei.com, yukuai3@huawei.com, 
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"

2023-12-08 15:56 GMT+09:00, linan666@huaweicloud.com <linan666@huaweicloud.com>:
> From: Li Nan <linan122@huawei.com>
>
> The SMB2 Protocol requires that "The first byte of the Direct TCP
> transport packet header MUST be zero (0x00)"[1]. Commit 1c1bcf2d3ea0
> ("ksmbd: validate smb request protocol id") removed the validation of
> this 1-byte zero. Add the validation back now.
>
> [1]: [MS-SMB2] - v20230227, page 30.
> https://winprotocoldoc.blob.core.windows.net/productionwindowsarchives/MS-SMB2/%5bMS-SMB2%5d-230227.pdf
>
> Fixes: 1c1bcf2d3ea0 ("ksmbd: validate smb request protocol id")
> Signed-off-by: Li Nan <linan122@huawei.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Applied it to #ksmbd-for-next-next.
Thanks for your patch!
