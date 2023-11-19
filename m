Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZE00JxRQ"
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35CC11D;
	Sun, 19 Nov 2023 01:14:09 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6c398717726so2889555b3a.2;
        Sun, 19 Nov 2023 01:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700385249; x=1700990049; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M+p8pqMrpXZyEZIe5esFa4AbHp5eeTaCs5mJkwXEzzc=;
        b=ZE00JxRQ4Czu9CK4e1LZvefrdugZGUUpXvFEuTjKXSoZlu19w7B3pNHiOTvnDlEQQx
         UA1eUQ5c4Gr/HvJgqkRgds4B1V0sPh4P7NZXtjVTYm6Tqp2MMyjmm/hxnNlV9kpIAyIo
         XUGPI7l3dEVIzlnxt26WrCN5/s2k7bBXFfktzKfrXw8lHjmVH9DPdm72m6VWzNHsGC1D
         aUyg/r7Jc4Tobp0zQCfYGV5Uv9mXQRX3WXtqTHj/6aWCmZkFed3nnooegS7zWsE+oWso
         RzV9p31AZoUdxNw5Hq3ZiyYptNRqCiJAAkArgHx+yoyaYtglozQ0MKIf8lEj4In0TvIB
         +l3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700385249; x=1700990049;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M+p8pqMrpXZyEZIe5esFa4AbHp5eeTaCs5mJkwXEzzc=;
        b=CgWuNJKXypc+lUVjQ01O04KUFhE6AbarERza+mUA7Xf72blU3bfWB5Vq6ksyEtMzX3
         T/VOvivgH6IQzjUUWAtiAOlxFAJi/Bao8I7/DB6xfiSe96w3jxQiRhj8EuamSpHMjuP7
         zgLu7HRf+iRjp1ZIGV4LC7bgYjamP+L3ErMj2r3/6K+XmXLpziMw6upcjhRU2QVQzw1h
         udRKGNNyzCMCdlHsw46IWhMqhYVvzEGLNJHOju8rwoKUrXBy+FkEARCip7R38Ms3YzwM
         ZfMGhjLFup8TxWot5ZIoWAhPehe1pJ4lLKX2XKgMW4h7tvOwu7YsBdcNvuXsUqinBYVV
         UmbA==
X-Gm-Message-State: AOJu0YyCy1a7DhmyCX4rl+cRRJKbR+apyydd4N5/U1VR7TErY681L/rc
	4AHdNybhJ2nx4k6LU/LbjO8=
X-Google-Smtp-Source: AGHT+IEsVyXir4hby69YJEQRz3oyzWpCAybRDINiHwCtq9D6F64T2biYeLp0Vulwa+n/S2PW4P28Gw==
X-Received: by 2002:a05:6a20:8628:b0:187:440b:6e40 with SMTP id l40-20020a056a20862800b00187440b6e40mr2186180pze.17.1700385249040;
        Sun, 19 Nov 2023 01:14:09 -0800 (PST)
Received: from [192.168.1.170] (c-73-109-30-110.hsd1.wa.comcast.net. [73.109.30.110])
        by smtp.gmail.com with ESMTPSA id f17-20020a170902ce9100b001cf5d4f8f26sm117015plg.248.2023.11.19.01.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Nov 2023 01:14:08 -0800 (PST)
Message-ID: <b503d929-ff3a-4dc3-9de8-aa0eb00d181a@gmail.com>
Date: Sun, 19 Nov 2023 01:14:06 -0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ksmbd: prevent memory leak on error return
Content-Language: en-US
To: Zongmin Zhou <min_halo@163.com>, linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 senozhatsky@chromium.org, sfrench@samba.org, tom@talpey.com,
 kernel test robot <lkp@intel.com>, Dan Carpenter <error27@gmail.com>,
 Zongmin Zhou <zhouzongmin@kylinos.cn>
References: <CAKYAXd8qZTiSBR3aSUk4YRSo+LG-Z20FRJfGgV1Awf+Lep4kpg@mail.gmail.com>
 <20231109011725.1798784-1-min_halo@163.com>
From: Pierre Mariani <pierre.mariani@gmail.com>
In-Reply-To: <20231109011725.1798784-1-min_halo@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/8/2023 5:17 PM, Zongmin Zhou wrote:
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
> ---
>  fs/smb/server/ksmbd_work.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
> index a2ed441e837a..44bce4c56daf 100644
> --- a/fs/smb/server/ksmbd_work.c
> +++ b/fs/smb/server/ksmbd_work.c
> @@ -123,8 +123,11 @@ static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len,
>  		new = krealloc(work->iov,
>  			       sizeof(struct kvec) * work->iov_alloc_cnt,
>  			       GFP_KERNEL | __GFP_ZERO);
> -		if (!new)
> +		if (!new) {
> +			kfree(ar);
> +			work->iov_alloc_cnt -= 4;
>  			return -ENOMEM;
> +		}
>  		work->iov = new;
>  	}
>  

A few lines above, ar is allocated inside the 'if (aux_size)' block.
If aux_size is falsy, isn't it possible that ar will be NULL hence
we should have 'if (ar) kfree(ar);'?  
