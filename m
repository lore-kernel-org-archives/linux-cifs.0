Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794912357;
	b=MdX5u7zV+sbYWuJycSODMnxFogv8vyPtyjvffPcA9ZVYmuVBXTaLbQJRGPmdDQaKUhI3
	 BYypD7UAxfbxVrE8X0h3dlwAfaGg9KOY+HJ8MDYJLXy1VumNiydqD/SS4HDCMq1ed7Pbh
	 SkY/o/iZQ44dJ4HWiGMiYCx26tPFcuYWdVwVChmfR1jpmcUfN+elIKHqm6FAcP9b2COC2
	 NMgRNCBS4P4yZYbWAGWbZ46G5/xiAolQaxU17A82ZLVmJalGEStMfZ0cT4l7UZdMHFZW/
	 1Xm1Czsl5L7c236iXavAg5rc/kybMQ0OLAuKh8xIDhoyfrh9e13PTBAqFG//bNQrmZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794912357;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ljC7x4T0g8LuC9S2NR7Y8EuueQxUjNwhNayArSrSdvs=;
	b=GLdBXxlPWv8gG2GOtnNyHnnpa3U984kR65bWt5FP5z9DprsUff/RwIYrziFsTWPIbEF4
	 jvQQ3lMQQf+eRS04x2rlLz6YbLcMRownVIV4zr0bvBcJPWd9LSRqMu4Rr6YveD4FOLYj8
	 HyVf+b9gRcUcXW9gLTP3QRDOIkZvmlnZTwsF+Q8WNOBl56HVwK+qNMDJ+YFDjcj3BuKO+
	 1Lz0V7lbgnp9YRPTNymGMnrrF5QE/My+/8pm9X2p2M+/k2mwTmUw8UOpZ4Unuy7w17pRi
	 CCSzNGtWyUAILjT1TcEa/F4k/AxnnjlZoCOK39RbKCftrwYSeHJhHrmloysevlJ1CSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V0D6g0XN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFB4606A332
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 10:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V0D6g0XN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC9A1F000C9
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 10:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794912357;
	bh=ljC7x4T0g8LuC9S2NR7Y8EuueQxUjNwhNayArSrSdvs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=V0D6g0XN4m5Bi+1yrhG7Ka/Zfi8mF5XBrB38c+I/pXWHPu376J4djahmED6Zu0Tf3
	 0K+m2z+lUvhT/cGvk8MC+b/MSfmVqfM/vt1HKDCWnVUo2353+MsqmIbozmhRu0j/mV
	 lHlDf9jBqiXo9m0ohRI1aUZBqfAaps68ySxPTQkwDkZLlBfjwjxSjlbgFSWR+YStyb
	 eT5rt9D50W/XgO1n655v8IZuSGq1rZHCdGDIlpDjSrJ/uC4nM63DFtg4sniwtnfmI5
	 KvZ2wWNDrU9KLxElIOa0Tl1tSWkv+W+e6M7M7HUHrCjkcR3bbvIwoq05andPieCIsj
	 UQvlT0jdO/v6Q==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c505b2e1cb9so660678566b.2
        for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 02:45:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHW9/etRNMwxNu9SYvf/PyvCXzYzHWGah1djNcu99vZgrz11QgxtznoUT0d8kmrDiReK5PsO2gWENEq@vger.kernel.org
X-Gm-Message-State: APuU4Z9PTRW8H57MKpx0jtACgAg53PAG85MonILNnKLN8wWKxVF9uZTW
	WQtqgiNUQzHVZWYg5LgSi15w6XtK3RbXakl+/nvCcrfEYrm4lQBYthfbQEIw+RjxrmF1vpmExVj
	v/7btH+s8xqRFjxkqyXWYu3ZiGAWnHjE=
X-Received: by 2002:a17:907:d06:b0:c45:c030:732a with SMTP id
 a640c23a62f3a-c50963b5e20mr1117781266b.35.1794912355691; Tue, 17 Nov 2026
 02:45:55 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116231923.2587994-1-icb@fastmail.org>
In-Reply-To: <20261116231923.2587994-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 17 Nov 2026 19:45:42 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9VH3wkHvDsUXjxpZe9AB-MW7Xh1A+JcbCPL49oty++Jg@mail.gmail.com>
X-Gm-Features: AclHuK8fiNc9ZsWU2pMCJRr3yCpno-tCINeQbyIc0MxW3Yc5S64LttYNY55lpsc
Message-ID: <CAKYAXd9VH3wkHvDsUXjxpZe9AB-MW7Xh1A+JcbCPL49oty++Jg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: store the security descriptor from a copy
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 8:19=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> Storing a security descriptor changes the buffer passed by the caller.
> ksmbd_vfs_set_sd_xattr() adjusts three offsets for the on-disk format in
> place. For SET_INFO, and for CREATE with a security descriptor context,
> this modifies the client's request buffer. Current callers do not reuse
> the descriptor after storing it, but a later reader would find incorrect
> offsets.
>
> Adjust the offsets in a private copy and make the input argument const.
> Reject a length shorter than the descriptor header before copying it.
> This keeps the caller's data intact and preserves the stored format.
>
> Add a KUnit test that checks the input stays unchanged after a
> successful store and after a short length is rejected.
>
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks.
