Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793611499;
	b=IACUw71rV7o3VXCp2H7OKwLd38PDN8dYD/DUcv/PS1lgkqZU6Bukj5lE9nPJ7ziUuWxJ
	 Lm6jgta65gkbqPu/YqxXG+01Ez1IGwk9raetXixj1RXPKLk9pZjEA6SgyaA0xlBvglB01
	 aXy3S980F9DjbN3rZWh//VQsRJ2lP7PW/yl/gB1f+eqiPU/eWJLPdXQc7oB1s/KR9UfKz
	 ImC5eXtBlxi8t3ZRTopm+gZ1wml43t2+RJn8WGMsmkBG4NwIl7H27rBKqMJoahbnc9b8a
	 HBAPSu3X6P5nbBCI8QgPITCRuezeGNMVI/dZx9ILBmDd0lHIZSeSqSA/O8Uig17digA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793611499;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=oMtMzNhNHZh8/goL8TNHFzkhOp6wv718swehnopLCng=;
	b=AwDf9JGGUF/ygreuqcwXWW/ZSBI+EJii8zXtqLVszd+o1MBWSXS6qxmUUaP5B/64BkO2
	 KnL/1jBySc3JNlaI05SmhRj69gFxv10AIjAAG4nYxw90ivBq84j0ZDgAFka/DTVhHxgs4
	 86csj5cx6k5DxOQl2aOdcTaCPOk/9g9nmRHiXt7/XnmTHkQdEMy8oICF5OJvvPhFK02XA
	 HxgIRZ6mZ3EhFZPYx5FQJSw2gvbo1tpZkn3sNXVxajxygzKs/zHm4MuW4e2XzFUBXoxLj
	 qmzXrCIwrylxBliROA4Sqh5ZNjTY4IJ9MsYaS+Rd5A7Ue+vDFBBmoOu6WlcJ2CAVJZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kvwxdFyO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19A5606A324
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 09:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kvwxdFyO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC81E1F000C1
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 09:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793611498;
	bh=oMtMzNhNHZh8/goL8TNHFzkhOp6wv718swehnopLCng=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kvwxdFyO0HXMFeGT0iQgIaXEFLeqzRxWYhlxg/cLRyd1j4Urey+IB3pi2vxOZLw9P
	 ABj9uooAFvFw1TXTfBkjKN9V4s6z/hFtJDJTlekjfW1tSG7as2NAfVGKJMQeeH7Ksr
	 inUNl/RoGQ39sNdFThAULDLpXGm24no7740pnHb1FFXniI4xEY27zelM1Cw2/FAM9T
	 sTYoainuR3SPgHVxKEF7x94/b3yLIF7YAOGTIrh/Jy26rd6PBvirEzIJRt3TR8MUkk
	 mg3C0RjbL0Mb0WLBvN4basNBOj+FNaoUDwaUk1g8TIFj+9ZrfYaHKpBGCDXNVhrLsT
	 3zmc8oDCgcaZw==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4682977f9aso331506366b.1
        for <linux-cifs@vger.kernel.org>; Mon, 02 Nov 2026 01:24:58 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByUcuZSPGb7/uae1PS4prdPFADPNehY1vSUCxGP6qpLlIhIgvLbzicleI+q9rroKfwAJkxXEB8vV07C@vger.kernel.org
X-Gm-Message-State: AFq9FYKPV1TjfQMN43leX6BU4FaFD2z3opwrL7Jngz0qaE7fMfy02iUn
	z5NjLqUGM1XkYbPLRQ5Uh6fmE4HTVdH63YOfZ1Gf2XDv28jmS15TUBi29azQhtPwGaBMfVj5U+b
	bjwelaUEm3cHd2tuFPqhseZPcp+jSPiw=
X-Received: by 2002:a17:907:9485:b0:c3f:dce3:20d5 with SMTP id
 a640c23a62f3a-c4ca7a41304mr777835866b.22.1793611497501; Mon, 02 Nov 2026
 01:24:57 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102050915.816373-1-icb@fastmail.org>
In-Reply-To: <20261102050915.816373-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 2 Nov 2026 18:24:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8MsohzNcYF41R2+xdJ0rguuy3rRHFbJV+kwTX6ERTuCQ@mail.gmail.com>
X-Gm-Features: AclHuK-MApDjs-MN4JdE4srSXyMSRjTHCFp7gFx9jom8YoDqHu5Q7KgyHGUtiRE
Message-ID: <CAKYAXd8MsohzNcYF41R2+xdJ0rguuy3rRHFbJV+kwTX6ERTuCQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: do not read past the DACL in the access denied
 debug message
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 2:10=E2=80=AFPM Ian Bridges <icb@fastmail.org> wrote=
:
>
> When smb_check_perm_dacl() falls back to the POSIX ACL and then denies
> the request, its debug message prints the access mask of the ACE that
> the second DACL walk stopped at. On that path the walk ran to the end
> of the DACL, so the pointer is one past the last ACE. If the DACL is
> the last part of the stored security descriptor, the message reads 4
> bytes past the buffer, and KASAN reports a slab-out-of-bounds read in
> smb_check_perm_dacl().
>
> Print the requested and allowed masks instead. They are what the check
> compares.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
