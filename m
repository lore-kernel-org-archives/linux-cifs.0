Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EA6101C7
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 13:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TDznUS3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A101C43391;
	Thu,  9 Nov 2023 13:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699536102;
	bh=W4AZvq3c+e+zUfNPx/HqmVF8sPcfZIynKF5fy4rArXs=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=TDznUS3WDtmh/RfJBMNwVdUUBWTT1K9qvmoZwKgxVkFf1Ky+6VbO03NtVWPF5nj3Y
	 ioxdp2yHzWHocLlwjKilWzZD/4Dz+uZVQ3aO8Nrj43LZftApVsmh1ZZxC7xYylehOG
	 +GVVHHkc3hBW2GHwn5uobcLYtb2DJlwdruMQiPfwqeZ8j1PfdWIkSpCwrILkRZAxkw
	 baw5lsOwFH08rwuJjFP3wEyVnosY0yLh4VkZKs2PShqGE0beu4PnqLgsVb4wDlCEUS
	 bCepFbYyOYdm1TNeEFkdiT7A/g83rGNNFcF2Xd/QiR/nzc7TLgkAT2qoOL3Gpn8w1d
	 0zY5F7WrUPGOQ==
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-589d6647c6cso419410eaf.2;
        Thu, 09 Nov 2023 05:21:42 -0800 (PST)
X-Gm-Message-State: AOJu0YzQ21FwELnaCzjJQ/v3eNIBaVP8KUIYXFxsTBDxBpUwDDkH4OIM
	18mhkDgvDVNC7ILIt9n3VCMcg+7mgBZa/0IK5Ks=
X-Google-Smtp-Source: AGHT+IH7IG2CokYLHaRCu9OeenBcpj7mfEXQDcnGjQjBfVBGI6VogVSVMciok3px8IofZ8eCtByfYDPc7LJsJcvhHGE=
X-Received: by 2002:a05:6820:50b:b0:581:9066:49 with SMTP id
 m11-20020a056820050b00b0058190660049mr6867673ooj.0.1699536101275; Thu, 09 Nov
 2023 05:21:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:67d1:0:b0:506:a3fc:1021 with HTTP; Thu, 9 Nov 2023
 05:21:40 -0800 (PST)
In-Reply-To: <20231109011725.1798784-1-min_halo@163.com>
References: <CAKYAXd8qZTiSBR3aSUk4YRSo+LG-Z20FRJfGgV1Awf+Lep4kpg@mail.gmail.com>
 <20231109011725.1798784-1-min_halo@163.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 9 Nov 2023 22:21:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_A-3kfK40hi9rkoKr=AVKG=_kK3_3ABbsuC0c-S6zk+g@mail.gmail.com>
Message-ID: <CAKYAXd_A-3kfK40hi9rkoKr=AVKG=_kK3_3ABbsuC0c-S6zk+g@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: prevent memory leak on error return
To: Zongmin Zhou <min_halo@163.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	senozhatsky@chromium.org, sfrench@samba.org, tom@talpey.com, 
	kernel test robot <lkp@intel.com>, Dan Carpenter <error27@gmail.com>, Zongmin Zhou <zhouzongmin@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

2023-11-09 10:17 GMT+09:00, Zongmin Zhou <min_halo@163.com>:
> When allocated memory for 'new' failed,just return
> will cause memory leak of 'ar'.
>
> v2: rollback iov_alloc_cnt when allocate memory failed.
>
> Fixes: 1819a9042999 ("ksmbd: reorganize ksmbd_iov_pin_rsp()")
>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/r/202311031837.H3yo7JVl-lkp@intel.com/
> Signed-off-by: Zongmin Zhou<zhouzongmin@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Applied it #ksmbd-for-next-next.
Thanks for your patch.
