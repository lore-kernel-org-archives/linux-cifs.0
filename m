Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606246FA5
	for <linux-cifs@vger.kernel.org>; Wed, 29 Nov 2023 04:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X5O51FlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB815C433C7;
	Wed, 29 Nov 2023 04:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701233275;
	bh=YI4fuxLiITTplMPMdCUaoMC9gkukDp8WeBYUthwy3Es=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=X5O51FlSMIA8mrnaokXk/71U+U4uj+W37AvfVjLvchhEkGGtPbGDchtTkq+qZ+bXF
	 U+Z9cVy6RpYC/Op3qo4bYnucpy31LKh50Nj1jqYoSOEz6+FNAYHtanysrqBaaXQ1Qz
	 v3XFfvpTvZwkC50YY9o+KzzuyAFgfEkX9N3wPvuCap7O+VTnhChN02dbCkh+Omwa9s
	 gTvjDdASLkinOJUqYc4D9vIg7afjn+uN9skV4nIBAyBiSrkm8KCDN7xHkmg2gTwer9
	 Z40vnH6f+my/jAzqlV0lPYpGEOgtpV+JP1ASWi0amJTKwxKFMLNdeamq73DgKSONIM
	 IxYPH7MjhhzLA==
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-58d521f12ebso2458906eaf.2;
        Tue, 28 Nov 2023 20:47:55 -0800 (PST)
X-Gm-Message-State: AOJu0Yzep1ftciDa8dDGQTuG6d8b1HYF2QuXXgrBWqaH+2cK0aBTj8nN
	evqhAJfpNDe/VMg5VnbNjh4uqYoAWty6uxQPYU4=
X-Google-Smtp-Source: AGHT+IGb0ugC9E+RvEgS0yj8ZkWshxvDoCAwhaaRXF7Avjz5Pqv71cN5VMYLSwe0bVDR5MICFgpLD2bS7hrmaxhkRY4=
X-Received: by 2002:a05:6820:228c:b0:581:e303:807c with SMTP id
 ck12-20020a056820228c00b00581e303807cmr20742246oob.5.1701233275064; Tue, 28
 Nov 2023 20:47:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:5bce:0:b0:507:5de0:116e with HTTP; Tue, 28 Nov 2023
 20:47:53 -0800 (PST)
In-Reply-To: <328ad7a1-7c54-4028-ae79-eb25c8c7399b@kylinos.cn>
References: <20231120023950.667246-1-zhouzongmin@kylinos.cn> <328ad7a1-7c54-4028-ae79-eb25c8c7399b@kylinos.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 29 Nov 2023 13:47:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_FtiMghZ=LCLmOmJer8dHQS-unnVH5cG+75dnAGjmVqA@mail.gmail.com>
Message-ID: <CAKYAXd_FtiMghZ=LCLmOmJer8dHQS-unnVH5cG+75dnAGjmVqA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: initialize ar to NULL
To: Zongmin Zhou <zhouzongmin@kylinos.cn>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

2023-11-29 12:31 GMT+09:00, Zongmin Zhou <zhouzongmin@kylinos.cn>:
> Friendly ping. I think this patch was forgotten.
Sorry for not sharing it, I have merged it into another patch from
you("ksmbd: prevent memory leak on error return").

Thanks.
>
> Best regards!
>
> On 2023/11/20 10:39, Zongmin Zhou wrote:
>> Initialize ar to NULL to avoid the case of aux_size will be false,
>> and kfree(ar) without ar been initialized will be unsafe.
>> But kfree(NULL) is safe.
>>
>> Signed-off-by: Zongmin Zhou<zhouzongmin@kylinos.cn>
>> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/smb/server/ksmbd_work.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
>> index 44bce4c56daf..2510b9f3c8c1 100644
>> --- a/fs/smb/server/ksmbd_work.c
>> +++ b/fs/smb/server/ksmbd_work.c
>> @@ -106,7 +106,7 @@ static inline void __ksmbd_iov_pin(struct ksmbd_work
>> *work, void *ib,
>>   static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int
>> len,
>>   			       void *aux_buf, unsigned int aux_size)
>>   {
>> -	struct aux_read *ar;
>> +	struct aux_read *ar = NULL;
>>   	int need_iov_cnt = 1;
>>
>>   	if (aux_size) {
>
>
