Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E99A1D12E2;
	Thu, 22 Aug 2024 00:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724287722; cv=none; b=tpxy/rTjZDmbIdJDC3zx0ghNJOS0sHFzmkqdRwv4hFErKnryab5vAQjoaICMUE2d6Wtr1TlpmbobPeBcOfKYzLrmqK97FqC73KW3VcDk3Ntay6bMVllvxr4wvVoQVWzHVSw6IHm4jN/LbmDE+LHhoDQjT/VuX9h5MAe7KitPhS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724287722; c=relaxed/simple;
	bh=wPdc9KPKjwpWYqZu78slSkiGuyAB5AygFu5R3Krp6/E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A+pedJKLaPEoVQnjbNAV2k0MKYq8vTtBnM6XbsoVlO81pRNpMRmGPyCqhci2R0p3W8pqtKuqvSpsmfnQhZNdTU5CJ7u4O7DPH77CB0fh+tBSXvfEbEmUeCP0gEuR9XupGzUorBhnds8hs27ZpWKzmLPzyV568HUVg10Il49FU4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UIsRV3dS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UIsRV3dS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AADEC4AF14;
	Thu, 22 Aug 2024 00:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724287722;
	bh=wPdc9KPKjwpWYqZu78slSkiGuyAB5AygFu5R3Krp6/E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UIsRV3dSXKX5Unj4Mgg7WqCtKMO/UYZpQKZzLMKefYxmU346W4WaGWG5zRwWPoS5o
	 k1UYGfxdcdE4w0BLbqK77kbNaExJSoeVUaw13ew6ETKA8Qo2glrh90OrZCgw0uRo+T
	 2zCr4ooCdVRXk54t3VgyYHI+X23Gn3bpEi8Ns/h+oHq94DCLbxlVTI+j2bWQDr82xK
	 /X5d6lcuNKtpg48alkueBTcGHnvnRlcvQrfNDLtW7y0Zy4ZgFXP9vzmC8NrjYyWges
	 RexhVX6jsPWhnh+K/HcLCMYDonA/1MOztnEtFUr3rjH9tty/vMQeTUaNjKjA0yxlxw
	 +Ya8KlqeqSW2g==
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-270298a3b6eso108922fac.3;
        Wed, 21 Aug 2024 17:48:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV7oeTsRxLLxfm483I7h68nYaNgrRAdKrcB+fyuARGg1SM5Cg+nwZEL6s3FqIDvbZxZ6xPcZ2jBT6Sa@vger.kernel.org, AJvYcCXXAinhnRHQMxEe7DrhTB0Xs8ksq/h9LWCA5T9wN3/EqI7OTV3fnot1JJZZp8+pe+yw8U3HnKy6nKpflkMO@vger.kernel.org
X-Gm-Message-State: AOJu0YySorq5qzp0JalUD9C95tIlw0+FchOtBMkIHkZ7k3c+MCwTLWaJ
	IyUpu6cTNb7rEXf+TMwCTXqv/jcE9B888drHUImc8wq+66eQFAR9Yvi0nGxmTOeZvHxM+M3Nc4f
	n45rIr/GL1HwH8Q+M0Rw5WnDduPk=
X-Google-Smtp-Source: AGHT+IFH/7Rt1lMc4wFQpva9B/4GRGvPm63Kj3gSiJENq6GJToiOB8R4QkoIAATEUZReXoohhXurhHmZwzOQc+YUz3w=
X-Received: by 2002:a05:6870:a9a8:b0:25e:de4:9621 with SMTP id
 586e51a60fabf-2737ef50fffmr4282442fac.24.1724287721363; Wed, 21 Aug 2024
 17:48:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com> <20240820143319.274033-6-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240820143319.274033-6-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 09:48:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9vMOTdpT7NvrO0v3QAYvpytgK_-MmhNOOo2yJ8mhwWng@mail.gmail.com>
Message-ID: <CAKYAXd9vMOTdpT7NvrO0v3QAYvpytgK_-MmhNOOo2yJ8mhwWng@mail.gmail.com>
Subject: Re: [PATCH 5/8] smb/server: update misguided comment of smb2_allocate_rsp_buf()
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2024 at 11:35=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wr=
ote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> smb2_allocate_rsp_buf() will return other error code except -ENOMEM.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Looks good to me:)
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
