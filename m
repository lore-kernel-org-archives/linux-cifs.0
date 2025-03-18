Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A372744E;
	Tue, 18 Mar 2025 13:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742303683; cv=none; b=nyoeFlU0sxokhFYcw0K1LlaORRI2oXZPs3LOB2eGz9AddhQtZ+sdu/A4KqooFELVe2r2mE//zEiT3EpbZ6Si5CEhxi1tEUmLaWKNImxrJ+ZanSYhVGoZixeYq89PwFZOI+T2edpX/C344jabg3EoSYbKhjMUoPe8DeP66RInCuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742303683; c=relaxed/simple;
	bh=6HejigW8S5mq52RlOGJCAYgTQCzcEuJb7/JHUb5q20o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DRiEiYB1rM7uu2JTYlCG+zFsXj7mgHIfcBSNhbUxKn6B+rla+8FjClyWhxOyhtJnIf8W/IFWQexphBfO8excFbL30mN1j9LSBwZ+Yit9zv6lvIrhh7+8BchsawcmszSAmaglepQQ8h2ZPbH8VnjP6Zcgv2YOsamZOJSh/M1T4/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tXfTqxEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tXfTqxEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B55C4CEE3;
	Tue, 18 Mar 2025 13:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742303682;
	bh=6HejigW8S5mq52RlOGJCAYgTQCzcEuJb7/JHUb5q20o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tXfTqxEEgz5KgXVy0s+ZKWpBurYNRE+/VKSUT9cr96c9Ycvj1LZtKGsSQNOQpRg0+
	 v+KvOmYTtovimo6Lz/2IRhwZFUKT5rQQ2UnMogPCfQvdK9Vd4jKWdNdUfei8r7Q0xE
	 MjOp6kRgz+BBO+otAPJbmHj8X+oattyx7+mdFsSfvdcLTZH3wTZ1Vzk0BXjzpmo71N
	 DLOqhxs7rD05SkV50gamLZGxxv7HTHwbcrDvQAcmZeTUvtehdZJVGY4JlYfduisLg6
	 VxQdPke4AAkHhbXO6LnddtkfXBULTxi5g/JHqnkd7VRzg8WEl00J/eEEAaAnpUDMIj
	 t33rMv8xkKGlw==
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3f94b7bd907so3169453b6e.2;
        Tue, 18 Mar 2025 06:14:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVR5h0lU30hS9fMVogQK3/jm5ExzcO9YeZASesNVM6bnf1BPmRJMll3ISQ/5Jx3vK0We+z6qe9GnDqB@vger.kernel.org, AJvYcCXqfJGA3ubiq0uSAA37jk/uv8Kl5vpzuczwZdNW0w34Rh9r5FGf4+IroY3d1xrLt1KzJfjsS1uGhlUrDhUB@vger.kernel.org
X-Gm-Message-State: AOJu0YzDgNy0Za2h8jXRNhLz4YNuCC2LZhj2+kRUO92a1c5HIWwdJ1mX
	auTebE3amZMGjJPOf0tRfL1dbmSyNxMMUNyKc1rMsc9EjqgFvCZKNM+nbS5wtRHoBRkRR6yW/0N
	Upc/VHWlW6lBexN7topKG1wM98g8=
X-Google-Smtp-Source: AGHT+IFre5dXJwwOAxofyl/ONiyx5KRevmtJO0rLC5QtBJvCsol+Ixr+dZ3tfEjfNBHGFnrwQG0havfH4s5oZbgJkxM=
X-Received: by 2002:a05:6808:1598:b0:3f8:f573:2f09 with SMTP id
 5614622812f47-3fdee36f332mr8686190b6e.8.1742303681686; Tue, 18 Mar 2025
 06:14:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250318121234.7756-1-linmq006@gmail.com>
In-Reply-To: <20250318121234.7756-1-linmq006@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Mar 2025 22:14:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_fwXStwWc_f34Wi1eeUAZ-rdgyVXKfw9R+OZNsRQtkkg@mail.gmail.com>
X-Gm-Features: AQ5f1Jow8MOJHvwkZSdfvcdD9wQnj1zt5qJD0CYGwM8UcGWxogvnjZzTWFSBu_k
Message-ID: <CAKYAXd_fwXStwWc_f34Wi1eeUAZ-rdgyVXKfw9R+OZNsRQtkkg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: use aead_request_free to match aead_request_alloc
To: Miaoqian Lin <linmq006@gmail.com>
Cc: Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 9:12=E2=80=AFPM Miaoqian Lin <linmq006@gmail.com> w=
rote:
>
> Use aead_request_free() instead of kfree() to properly free memory
> allocated by aead_request_alloc(). This ensures sensitive crypto data
> is zeroed before being freed.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
