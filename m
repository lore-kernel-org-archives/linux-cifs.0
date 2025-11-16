Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4540F1624C5
	for <linux-cifs@vger.kernel.org>; Sun, 16 Nov 2025 23:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763334047; cv=none; b=irsgJPYQxVoQACCrgCExe9lQozSnGm8pZ5wymdYEUpmsl/50BWldMUrMaQp9ATFmdpWrYB2mhFfdm4tenXhRl02qD+hCnGE2eYy2h5rYqXndtfylfLZAcKue2RexTJyw3aGfGvrWBUPvTAayA5gjDg+4ialCmQYUJ1pvyE/TQbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763334047; c=relaxed/simple;
	bh=A+0kmn02cRiugeRwp3Ug0B3X4jAyuuKXBlyxOLml0kg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aMblTSABVKRvpCduLmCZhTkUVOPbNo9p+9jhW4tygAMShk+qzPq32AFyVZ0c922pkyZh6N/jp/9Xi2x43ad12o14SzvHguzHlzI9Modwji88JATby72FvDNSxphZlCBmVcrWYcj96bG3vsS876rcQkhkFFNcf7KCGd/AH8CR4R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vEwRCsSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vEwRCsSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFE4C4CEFB
	for <linux-cifs@vger.kernel.org>; Sun, 16 Nov 2025 23:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763334046;
	bh=A+0kmn02cRiugeRwp3Ug0B3X4jAyuuKXBlyxOLml0kg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vEwRCsSVLmzdhCA29GCikB+envLuxECJbnitosGpvVR/VSLplFjJ6bK5gTIcxfkMp
	 yM0Ygvj/1pp9A6auMMJ05rPxAWay0C500Ej18uD7Y8ohizLpK7ZNqxhzY9M8NmvUy3
	 BwTgz3BQswQuwI/PtOG3SO+txFcWs9TGk3iQ3av9Qtb5IqM3rCvESIRZuEDb6Ynb9b
	 5YgjTqs+hgLEbTP6EjiOp1H+TWHFp5Wu/g0THQKgUnjBr4Neuflz1n0VsZLoA713h1
	 /ThjZNYkD+NyL3QEJrg3lVKHrq+WEQUN/ns5sYt4MnPUuNozKNTPtj0oWXYQjRK4L2
	 oLjy5iiTI8y1A==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-64180bd67b7so5117820a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 16 Nov 2025 15:00:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXZE/D13Lha+MqsKy09Wg9LU28ZEC5STJ32ZCTc4xPDQJtHTX5zBoiIA0vg87oY3YIpygLhbhBJRfRS@vger.kernel.org
X-Gm-Message-State: AOJu0YyasDzCwQCZVoLWLKgNIFjp7FXoTWAmfsZAQ6rrZR+VqftPA9PZ
	cDOUR86BFi+7RvNxRKaxOSwEPJ2sBSV42D04VLcNHk3dYEqHEiVspAIWC1y7KTh3jAtvkgLaNT/
	UWG+XGsPlgSB2Cf31lSRn9vFRWFCZl+Q=
X-Google-Smtp-Source: AGHT+IH9xf/Md7HDK7HqPVnaba/6QNdpk+kb6RcBMo260YB7r5j6suwYuqqJDGwkRl2qi5xVL8CRiN9MNFL7munPylI=
X-Received: by 2002:a17:907:86a4:b0:b73:9b49:3042 with SMTP id
 a640c23a62f3a-b739b494247mr220363966b.31.1763334045281; Sun, 16 Nov 2025
 15:00:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251116065213.282598-1-chenxiaosong.chenxiaosong@linux.dev> <20251116065213.282598-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251116065213.282598-2-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 17 Nov 2025 08:00:33 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_ZcmQnxAD8iLMjnCvtTrqHvkgPcd_8QSRmfFn1avZ99g@mail.gmail.com>
X-Gm-Features: AWmQ_bnpr368YaOMaNZnWzMvoY49Pdvdsa5EwWgumxKQlRQTTtrTnRcM_UUA6ng
Message-ID: <CAKYAXd_ZcmQnxAD8iLMjnCvtTrqHvkgPcd_8QSRmfFn1avZ99g@mail.gmail.com>
Subject: Re: [PATCH v8 1/1] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/fscc.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, chenxiaosong@chenxiaosong.com, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 16, 2025 at 3:53=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Modify the following places:
>
>   - struct filesystem_attribute_info -> FILE_SYSTEM_ATTRIBUTE_INFO
>   - Remove MIN_FS_ATTR_INFO_SIZE definition
>   - Introduce MAX_FS_NAME_LEN
>   - max_len of FileFsAttributeInformation -> sizeof(FILE_SYSTEM_ATTRIBUTE=
_INFO) + MAX_FS_NAME_LEN
>   - min_len of FileFsAttributeInformation -> sizeof(FILE_SYSTEM_ATTRIBUTE=
_INFO)
>
> Then move FILE_SYSTEM_ATTRIBUTE_INFO to common header file.
>
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

Did you check if it is being used here too?
cifssmb.c:4866:        sizeof(FILE_SYSTEM_ATTRIBUTE_INFO));
