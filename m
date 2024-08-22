Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF213C3C;
	Thu, 22 Aug 2024 00:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724287632; cv=none; b=Z/ingH1fwmql+8qi8oBpOqMn1QdoMpXrnL7DZLw9RZ3kT/QITU4AUkh0xSdwpCiMuQBbCc3l18LNFBwDUABrZQ4jVpOXxBhoPY4rxoWHbOjx6q4m37Xu5oLRiA6zX3DpaMvmJNSfecf9yRNmdZWFFwYEy4FILtVs33rBBDYnskg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724287632; c=relaxed/simple;
	bh=PnIQlKdwHT3ouDtAl2OxtHvds/KM2tmAfTOFARz2KEk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EWuZJEmTabKuWUxY79uVkFkgsp3hTlzrGlpXsUMkJAzrIxuzw3Q6lrGfyH53PQSRxaioZ7Z9vYng4eIxOtkaj2LgyN2gEkGK3Csg3ofqHZtyvUIIXOA2SZskfKHAydCTTe9yfHwT+N1oAXz7kQTbiThMeDFCTi/kEakX4s8cHMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rGQ/03we; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rGQ/03we"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272F7C32781;
	Thu, 22 Aug 2024 00:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724287632;
	bh=PnIQlKdwHT3ouDtAl2OxtHvds/KM2tmAfTOFARz2KEk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rGQ/03weuM3hTvSXL13QTXyvn/oMBanymPc+EbIsWAsUd44JN23CejXD+VwYK/JpE
	 FSHnuNzPWUaHJ82yvqhKf3ZGtMLvEfG/vb0zVo8blxtplbGDN1DVluKWIzLYijexTY
	 vkKefthkIDuOv6lBb1eSivs3j1ijuYd90FzfZNkqIjusLmfiGk76eTA5aK2FA6Nx+S
	 5ZKOg3R9pgm5OsxGBAqL6ToPzBen0pOAfPqfA1oNBN5YWdF+/lW7lr0hr+J79xX6LT
	 I5uKHn8GVw52+Q3Cy6lZgRteBNIGl6c5PR8avykIpBx7hGMEMPN1XVF6+lk0anfpNz
	 P53fqt+ijEXJQ==
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-27012aa4a74so140363fac.0;
        Wed, 21 Aug 2024 17:47:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV7eFAZE/4M+f5pbYpMvCTntur4zzlkuFUuFDfqz+zKqx5QzgwIZ1QxJpTQWNycoctsqkfPH5brw11cAZCx@vger.kernel.org, AJvYcCWNIK1Zim9fbMqdot5rfmzcE4unwuqoYQ/lt3ttAiZW3QJBPtBlKQvSNXzs++H2KwEtJdQ/XAetgn/h@vger.kernel.org
X-Gm-Message-State: AOJu0Yzsa0oWqkQaaPy6SeUqt/amOLieOhwbuZMNj30J1HJZ3/aOiEME
	S4IdypPieBjtkT5TfwNqhsPkU8WpHUDnO59xy6KyybtSXCXvGJ8Qfv+jS1tLy/lUhOwTxptS1gs
	DY6ScjImWATjfOFiwMQIwKby1coI=
X-Google-Smtp-Source: AGHT+IHVJAHhczihjudA1XVCQrSa6mkdzyAJ/POhyJhgfnTmBbK6ZEw29zdBnEtPsLACyRV66/q2vzdeAcws8bXp0JU=
X-Received: by 2002:a05:6870:169e:b0:264:9161:82e8 with SMTP id
 586e51a60fabf-273cffcb6bcmr412044fac.41.1724287631525; Wed, 21 Aug 2024
 17:47:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com> <20240820143319.274033-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240820143319.274033-4-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 09:47:00 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8NkQi1+OQqk3_YFo60erMmZ79jBrXmOchRGWvHpNsj4w@mail.gmail.com>
Message-ID: <CAKYAXd8NkQi1+OQqk3_YFo60erMmZ79jBrXmOchRGWvHpNsj4w@mail.gmail.com>
Subject: Re: [PATCH 3/8] smb/server: remove useless variable assignment in smb2_open()
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
> The variable is already true here.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Looks good.
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.
