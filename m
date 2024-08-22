Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D752513A244;
	Thu, 22 Aug 2024 11:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724327941; cv=none; b=DMlG54jJWRYkO0CQGY9DEhVAe6sKbMY33Rs9vD3ptxJQ0myeXijaSBoXaFTfcdurJHczQ93N3tM7uB6RZbR4yyQw5rwdsq5RGFij0ztrkDoQ5ONT7uxy8F2ivkFCrjYDxpwQ20P+y6p1zDgYduCfX0vcPD1J+9L9XZnDdRkJq4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724327941; c=relaxed/simple;
	bh=4lHN5lEMvuoeTv53bj0M8/Wg05l7rzeFzFkqTpzgu7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R5b0ooceUqw1F2dU3o31XESfGpeEtPyib4r7ogofTYub69bV1TZVpE5lU6ufo7eprYy+ANK1YxQMsBCTaCgzcNS7Gcbd8/y/2Li3VQfh6uozRI6zWI1QasrWzWHHx9Kxxx5/Jv+6H9JFl+DDAxVTs5TPT/U4zKj8+gZgS5EL6lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mgzm8CKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mgzm8CKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F83C4AF0E;
	Thu, 22 Aug 2024 11:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724327941;
	bh=4lHN5lEMvuoeTv53bj0M8/Wg05l7rzeFzFkqTpzgu7M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mgzm8CKwF1MsMXExrViHYzD21Y/PdTMpJkTLyyno1yVIa3zZuuu2LdSNlNApHKE9A
	 q0NaVyis6GjyTnZzqtGseCyUcDJMoXpBpFzH8LIVxokBb89sxuLCocZI1Q86+Q/cx4
	 u96iKr8l5wI0EcmwUmZGL9DgTBdsIcjd4xLoeQv0Wlb0t6mLP152AW1UnbbvrqJ/CX
	 aZUimgF2NLXYa77StMMZ0Y+/AvkC8VuvDSA5LXaMZIWut7JhRh+HfC/p76wybH25Cz
	 E9HgFkiRC2yxRk3GzcxMY7ZKwZ/GIpHFjRy95hM7Er0bEgakDlXg0wvg6MPNf/tXkm
	 Hsml8sHeNVWXw==
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2701a521f63so422223fac.0;
        Thu, 22 Aug 2024 04:59:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUYgddhvvd/x0j7mz0xJByH+/Pg8+i/SUgaDSLpN1gMjwlTMrDQF1W9gjlUBV9ciDRw9rkWTKSIn6MhFDbg@vger.kernel.org, AJvYcCVn93EsgKMFEcA7zbJ9OzEBQ7NPN/FF0PGNDYnFUo2Pj5KnaD+7VQavHRgcZdI8YCDvb/gku3gtpxgk@vger.kernel.org
X-Gm-Message-State: AOJu0YwqOe/35FlSbGAw9gBfxT7ATEe1GSXUij8AW+H+1eW4sxwZ7xFB
	2KX7MriEM7RmV0uouxbi71Tt1+/H1gYGMaaN33VtXo6icgng04MZF2Kog+OsE+daG645/fubJc7
	BkoX+Ql2uXy8Dv4ia/GB2Kvq0sXI=
X-Google-Smtp-Source: AGHT+IGa00mK6cJxqN5lGlzZQmZlmhCZ3QjPn+IQ1DOH4fzQrrwdrJSbqtjVdVS4ZUcLWG/IHAHoE7+6QJoFqdPpO/E=
X-Received: by 2002:a05:6870:2116:b0:261:1342:26b1 with SMTP id
 586e51a60fabf-2738be908e3mr5179101fac.48.1724327940842; Thu, 22 Aug 2024
 04:59:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com> <20240822082101.391272-10-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240822082101.391272-10-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 20:58:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9ynmBr=xcTxUh-PC7x=_DGqvGme8u6nZxj9D9FZWw9WQ@mail.gmail.com>
Message-ID: <CAKYAXd9ynmBr=xcTxUh-PC7x=_DGqvGme8u6nZxj9D9FZWw9WQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/12] smb/client: rename cifs_ace to smb_ace
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2024 at 5:23=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wro=
te:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Preparation for moving acl definitions to new common header file.
>
> Use the following shell command to rename:
>
>   find fs/smb/client -type f -exec sed -i \
>     's/struct cifs_ace/struct smb_ace/g' {} +
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Looks good to me.
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.
