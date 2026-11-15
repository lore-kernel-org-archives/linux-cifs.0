Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794750790;
	b=rODFQ+aH0aQHD5ROJXIOPPrHK6/KXP8AhH292lJgyM8of1MI1E8z2AGkIZzNH7UHU4UL
	 Tckb2v88zbbnYIqX8JR2RcHGx04DWCoJUnGC9QAPyxY4k2Y6Vii+9h1ltR/fCRLv0U2sB
	 huU58qkFXwR6n1Jlxseun07ub+laaoT8KjyOjISX2EgKm5OqwAx5+uLMLC3FeiUO72LBm
	 UjpfXsvYvu38I8lYerInlZo9ItgdI6zrMkE7yOcYD7V8/CMvDzP1C9qeLNv4K9lZ+CkG1
	 JcHpuq5iWLfALdO1X3P2qJ3LRKmAL6QtTfsHYZHf1z7XXzUEIOB1lxkXtM/+Adh6L+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794750790;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=fmKXw7Sp/MNvZTSb4xcRBsLRBVw5OzncMgLzcyPSN0Y=;
	b=uiJtWyKRIcpOBe47M5vwz7ujPPrNKaK5IMkVQQHecbooesMatyBFuN5DmSM8dcm69Qgh
	 LmqV6jWlkxhwV01nYseHg7dKEfeA/QxqqVRKYrn8jjhXqqoCARwVA7CY+0BhXYN8ZK6rv
	 TOvQO1IRicvrFFpE7x4RFLnAi0VknfqadGneYDr2uyebaQo3eEsY7WahiIcahU6OLUuq9
	 8JlJKHCCWFSmYityYpaqak8HRyDIltVFSbZN4fkiGfcIFpT5qFnkI2y9ozBZNnF4U0oDO
	 0KwuplbdwLm+y+a9ZZx/yHLFODnWuP8qWTKDOCPnmNz1pxqNoHkGX6tjabccXOuYz9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Umse5wP1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AA8606A32F
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 13:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Umse5wP1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0015F1F000CA
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 13:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794750790;
	bh=fmKXw7Sp/MNvZTSb4xcRBsLRBVw5OzncMgLzcyPSN0Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Umse5wP1+g5ZjdU/edSukKLDYhwuE+VrhK1TQzLQD/zvn7110aHBYDqcDuvTQ1dmA
	 R6ayqisUdEbD8ztajANSM8AzqaPQ+vawzwQcwQhQU22gzy6JX5TExK8TTCk5EXMqpF
	 Zxj8/GORSs9l9AETbEDWsqd7gaqHuyBoXnuGilYMwZNltaBdCtXs+dqITvWGl1xBWd
	 efyBGNm3ms7nyA0v3yE2cK/GIUIt7fc/sRSgMIn7tFDmShJimQVc1kVMHFflhGee2R
	 J/ONdotLkCbp+hTHlSwd0iB739tyD1V9q1dW8Eogaz/A3duOIpDjLUblOfMhwME3Jp
	 u3iKdGZtJoC1Q==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so460292666b.3
        for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 05:53:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEGpKu39gPfvi4B22rJ3/Qg6bF9I3VL+dL9vqQAM1n4mZtokl5CCRr2jDK72TBfYIOFzrOcAu0B0Xhk@vger.kernel.org
X-Gm-Message-State: APuU4Z+FRvzDHko0Tm9BC74M+WP+DD89UrSS+spAQI4/ruhYbp0vqtXd
	THhd7jAFLgKBm6ux3Dax/5lKQKNKhHxsj0Li9JbJ+NbNfomzGktKkmECvA/d7Mc1YK45MOECVN1
	a5h2d8t/VQ0+g/LoH/dIofq1gkSeIHLo=
X-Received: by 2002:a17:907:94c5:b0:c50:576f:b3a8 with SMTP id
 a640c23a62f3a-c50963d9089mr835079466b.48.1794750788588; Sun, 15 Nov 2026
 05:53:08 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115131047.2338285-1-icb@fastmail.org>
In-Reply-To: <20261115131047.2338285-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 15 Nov 2026 22:52:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_c8GCg58jTKw3shF+aFmR8KaDx8Ve4wQUHMjoZ6PT4wg@mail.gmail.com>
X-Gm-Features: AclHuK98yWzx6FWaTeowYxcy45zR74kQejiLyKPT7sgUKp8qn5-gwUVdz8a4ndE
Message-ID: <CAKYAXd_c8GCg58jTKw3shF+aFmR8KaDx8Ve4wQUHMjoZ6PT4wg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix smb2_cancel() use-after-free during request decompression
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 10:10=E2=80=AFPM Ian Bridges <icb@fastmail.org> wro=
te:
>
> smb2_cancel() finds the request to cancel by reading the SMB2 header in
> the request_buf of each queued struct ksmbd_work. A queued request may
> still be in preprocessing. smb3_decrypt_req() decrypts it in place, and
> ksmbd_decompress_work_request() frees request_buf and replaces it with
> the decompressed buffer. Neither runs under conn->request_lock. A
> concurrent CANCEL can therefore compare a transform header as if it were
> an SMB2 header, or read freed memory.
>
>   BUG: KASAN: slab-use-after-free in smb2_cancel+0x73b/0x840 [ksmbd]
>   Call Trace:
>    smb2_cancel+0x73b/0x840 [ksmbd]
>    handle_ksmbd_work+0xa90/0x2110 [ksmbd]
>   Freed by task 53136:
>    ksmbd_decompress_work_request+0x10d/0x180 [ksmbd]
>
> Record the MessageId and Command of each request in its struct
> ksmbd_work, under conn->request_lock. A plain SMB2 request gets them
> when it is queued, because its request_buf does not change. An encrypted
> request gets them once it is decrypted and decompressed. smb2_cancel()
> matches on these fields and skips a request that does not have them yet.
> It no longer reads the request_buf of another request.
>
> Fixes: 6639b6928ba2 ("ksmbd: handle encrypted compressed requests")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
