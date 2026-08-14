Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2A720D4E9
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 05:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786686662; cv=none; b=opR9Og+JmH0unBf1AKCdNC2Noy7EkNIbhgQw1AgJSR3Rpj7Fj/hJAoBuxbGOnj22tUy7SoA9A3NkiFIX1R4gFZ7vEY8h74uvDxbOPuXTxj8YNunyoBvVVFsw6ybIqnoQ2FdcpstcB3vjNQtY9YisTgNlP5oZoR40TMkQdyKxc3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786686662; c=relaxed/simple;
	bh=MSJ7MtZ2YYYtR8HDvxaABjaCBVU2JY7V1K4PYEiGDow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hngqKR34xZfgXgkcz9IxZ1bQdKLkgrP3Z7RE7ORaF2GMuEZLLq078wstv5n60L4sV0W054fjwiZ+NM5IaLmp2BTDv5K+P9pVyk6ujycoS1bjXqGCOdShSRfGokucTNbrj8oJXeVNcSMwNdzhtrxQRsDf7+hp8Wx5n8qYDOLJVEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=id3LhRKM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="id3LhRKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2FE1F00ACA
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 05:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786686661;
	bh=MSJ7MtZ2YYYtR8HDvxaABjaCBVU2JY7V1K4PYEiGDow=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=id3LhRKM1hV8vqrFN1gTtLZUZakQpUzJbDbx9P3kS7doAAbRpVQwrDy+M6KmBCs3S
	 5m1QHmURTXUH3fziRDcNmCsA4COjSLUvNK8rKXIjppJ6QahZ69cp6zLUXC2hWmnuuJ
	 xgL1wzKK3tZoT3o96CxFyZQGjpf4IYyrbpLYH3x3I7dvnOEh5vT0cyoQSb+417v53V
	 WFONN86OWpRyITxHY6JBxQedJlsMVI3DPud70WLUhA9Bb/Ui8WV9RC332AYEeF4ciN
	 1qDgET656619FVjPDYd3BiXXZH1QSwPqR/IGQOeYlJLVvMnWhkSqKduHUWe1ptrplv
	 TL8dVhu7MOT9A==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a0c8283146so884822a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 22:51:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqBYINi06tknkMCD025m0W2tMBXrY0K7Muc13YxRSt67ZfgL3i7o+es6kebKEyVNEmeRlYyFJpMmnF6@vger.kernel.org
X-Gm-Message-State: AOJu0YxxFcBE4SUU+b1Ql/8ga+CAMonhzp3qeIyBMb6zWcl/GgMxRYrR
	kDsUlqXGevrtaOtF4pMs7MdeJ/J0xo+3a+2+htp1ZdRxn57cfslZsBhU5QiqRI5WM0R+SMSZBMM
	ZN72lbehd44i8aSbiuYX0Mul6M8vNn40=
X-Received: by 2002:a17:907:9482:b0:c16:8404:4631 with SMTP id
 a640c23a62f3a-c212aac6dcbmr125888366b.26.1786686659920; Thu, 13 Aug 2026
 22:50:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
 <CAKYAXd-B1mjT-JONqToLMeQKmV_GRdR1Pogi9VugyCADATpO3g@mail.gmail.com> <930abff2-18f6-4a68-ae07-1e3675c90ae3@chenxiaosong.com>
In-Reply-To: <930abff2-18f6-4a68-ae07-1e3675c90ae3@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 14 Aug 2026 14:50:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8NVrKjfmKCvZwsYo2PGPu4hAzcmBaGuOmM8BDQiKT78w@mail.gmail.com>
X-Gm-Features: AUfX_my-S3k9_bXVbNaAqHQJqXRCH6vV1v6JUnQPUeJ7a55p-ughZeNvdccMli8
Message-ID: <CAKYAXd8NVrKjfmKCvZwsYo2PGPu4hAzcmBaGuOmM8BDQiKT78w@mail.gmail.com>
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Blue bird <obnred@gmail.com>, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 2:13=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Hi Namjae and Kyenghwan,
>
> Namjae's patch can fix the BUG_ON issue.
>
> Tested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Thanks for the test and review! Applied it to #ksmbd-for-next-next
with your tags.
