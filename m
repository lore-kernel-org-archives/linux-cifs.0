Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402BB2C0F87
	for <linux-cifs@vger.kernel.org>; Wed, 13 Aug 2025 01:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755047364; cv=none; b=qxvw17f5UORWTWGXv/5BwF57we6E4D+nflvsYfSqmcDNs79Po0/9rVRapC3CEmLTgEFICyW7xsLnv8llo5P5cg0faFYGimUoLEMgCyVUr2UkVTxts0PS6zR5H+KKb4YkIN3mSawzZi5hJY87Ma7q9p2+UxCWtZFY1nqTodOu50U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755047364; c=relaxed/simple;
	bh=iyHbuS794qJWSMl0okaqpUXn3swWc+Vt9V6hwOjIKuQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tcl+9bQWPCa5ymd5uSWP6jM6jaDvq20e5o/rjjDamZOucqpcXuorp7pRRTXVSAYYMXQtOcFyLHoM1bx6QkS9SlhSPSe1fV3gtvaE7bRJK9YlYj3JjFIrHptBQCpWFRroupsUoz6IpJ/ml4EPmvRhI7itPwCv1fe3uAeKVAJ+kII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=snDZ2sZ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="snDZ2sZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1218C4CEF7
	for <linux-cifs@vger.kernel.org>; Wed, 13 Aug 2025 01:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755047363;
	bh=iyHbuS794qJWSMl0okaqpUXn3swWc+Vt9V6hwOjIKuQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=snDZ2sZ9CA+V7IjKjRkOxnn5uCy7R4JAoHcIZnfo4tN7tQ1TiVR3gKtQUaPNGNKti
	 Q2jKGVewUZy7XoRKVUGYPEaAuyqvD6aLj54fR7CNm/DpBNwrChA++Eo8AG8VaRwB3I
	 Y9Ki5H1qpVU/yT7G8QZxDpgo+2OBSG1k1DmiEF3wWt7P4zYuwdXRC1/nIuZUAXo3Ck
	 AdIaKMTdtFxa9RPDAUjK5yfP1/x1iajpFavNdGRZ5qOMLPVPVbjWZ8rGhExb2vOZdl
	 5C9VTGbD1xhqzZrFjUJAwVkNfarjpNQGTPwU8l5bKZW47gE/pDKhF6HrnjWtb7F5pQ
	 mUksbJ0e9Nrww==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afca41c7d7fso67892866b.1
        for <linux-cifs@vger.kernel.org>; Tue, 12 Aug 2025 18:09:23 -0700 (PDT)
X-Gm-Message-State: AOJu0Yzm/cSKGPOYHNeFap0aeXserCfSIe8UJ/aBoVYe31a4NMgJQg98
	/Ol2uM+V4WsnjGdkSNTyksorcVI0AEE/WlxiwJ/UhW9vFO7kx0ciYFy8wdrbgbBWdlCqDNVXwFQ
	LKv0WmJMbKJV+FVbWN8LGCIaBGG2VfgM=
X-Google-Smtp-Source: AGHT+IHNRv9T6lU2HI7jxb9cJ3DbiQJL+YPROXa9axvAHAAfPA+u0t80aECtZAE8etd5G+vTCR/aDcjMpyRSVnIFj1M=
X-Received: by 2002:a17:906:8d2:b0:af9:bfed:fbae with SMTP id
 a640c23a62f3a-afca83aa8efmr43803266b.10.1755047362296; Tue, 12 Aug 2025
 18:09:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250812164546.29238-1-metze@samba.org>
In-Reply-To: <20250812164546.29238-1-metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 13 Aug 2025 10:09:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9C79B+U8rEmWnDBCBMp5jsSMBWfkDFErLCQPHFUBB-4A@mail.gmail.com>
X-Gm-Features: Ac12FXxIDFrkTNQkjh1vqHWpr018EF5jCODh_aaEKcqC7fv5ZbhjZa567-KvyC0
Message-ID: <CAKYAXd9C79B+U8rEmWnDBCBMp5jsSMBWfkDFErLCQPHFUBB-4A@mail.gmail.com>
Subject: Re: [PATCH] smb: server: split ksmbd_rdma_stop_listening() out of ksmbd_rdma_destroy()
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2025 at 1:46=E2=80=AFAM Stefan Metzmacher via samba-technic=
al
<samba-technical@lists.samba.org> wrote:
>
> We can't call destroy_workqueue(smb_direct_wq); before stop_sessions()!
>
> Otherwise already existing connections try to use smb_direct_wq as
> a NULL pointer.
>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing an=
d tranport layers")
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
Applied it to #ksmbd-for-next-next.
Thanks!
