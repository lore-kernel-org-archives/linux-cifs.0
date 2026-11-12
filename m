Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794470665;
	b=sUhp92m/i4ZV+uu4HeuuDTB5oHTTH/Xq/R1xy813xcqhsE5iI5oW1DZe0R3K/RNbvZN3
	 ZDeJnsVwp5tJpcVMUTIS0JSM5Wg/+AYhHIFdQ+owhnsx8FKSJEVauXei0eRmvJbO02Cr/
	 o0gVJF9allFcnguUHEZrxpmY3UVZjuTQIZ238jW50o6KI/8EjMRniQ3SK9ci6vDk1HfBo
	 FZYCiHeNMmMtHOrIXoeqRyWDRIsVuD+3lj52hbSGqb7xoaywPpcn1n1GFSi5l0C48sCOd
	 HkMZcKHTiDHx/9hDPRG0tjODRB2HW12vwbDCsLmz4aUBaJ20Rs1dl5g05gdKg78J/Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794470665;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=urX3RICoBxceIT+XA28WODylzdo5p8L+qYkoDoKFlCY=;
	b=5FU16ppOTXaPOHc5FQBjJ0o5+rMUp69WXe4dNp/JPEHEFBZ/OOXX66SIpsXK6I801904
	 Wh/d6xIn+Ck8/luHs49PSxEkp36Te5qgGIysiNWrX/6kuH7pt02mVclf4McVF0h8P8T/v
	 vvifM83hzC5VqTuGTqwGbDBR8UX1M8pjBy2CN0jtZ00ARa4St8Bq7n2yOtEC1H3DIt9z/
	 vn+1wVdAFK2wliSDYadn/Lc/uBqVq1T5dLvDXb5aSv/hUdj63oAvXiWpAtGzhS16XjRWG
	 85CQ10nh9ZxKvV6bJrsMNR52NMwTlMdWkoF0AzReKbNiNWYIvLYlSTRlKv2AvnqhCbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="K/riakyQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3D3606A321
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 08:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K/riakyQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C88B1F00A07
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 08:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794470664;
	bh=urX3RICoBxceIT+XA28WODylzdo5p8L+qYkoDoKFlCY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=K/riakyQl0ZGUvrkZE3wkobQfHGpspERskTgajQQj/qINJJI0GLsxHgkd8Hi9FYu7
	 mIDzNXJZrVVjrkcka2mNlSgttDcw2656pS6kX5W/YSsfmd6UnL6gGstMDNY04NYizW
	 CcQAgR3TNYPBUhIWSb8p9rzhI5aiR1cQNikDKYmR0T9I2eGtnY69TpLmU2FtDc0dnS
	 LHJzkmmH5961CTcgoqHDYKQ9PQQoNvbKVdgCYEGFTLDILSPbeij/DezJsOXm96Bqc5
	 i5qoDTIcO0jhPJ19VN4jvEAAt+BNHX179Xi7vTdtRjOB7y/ZZh75Dq7QnpnBDFtEbr
	 xk7i2jquiZvPQ==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c247f6687dcso646191866b.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 00:04:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGSyh+W2z5y8TFnR7IuFDx+0YEnJArU+cX59cqpT3OCXKMYwrnzd2ZhtRyOs38UesA7NIrIpusWwFAF@vger.kernel.org
X-Gm-Message-State: APuU4Z9krbA8ZMiQy5Z1uPEefFz0jAv+RybAD5jX5jb4ph3B37CICbpj
	pR5JQ3rZG+8X9PdNiKujsRqV/d9eWX2Q5eRhDnOKB7z98fvFjtFzh/eSIqNDInEsfJGcs28UH5F
	D+x6O1949RWHPUSXDl20225sSA2u9NvY=
X-Received: by 2002:a17:906:4fca:b0:c50:6005:9133 with SMTP id
 a640c23a62f3a-c5066aaaac4mr342294866b.8.1794470663283; Thu, 12 Nov 2026
 00:04:23 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112045238.4688-1-mike.michalo@gmail.com>
In-Reply-To: <20261112045238.4688-1-mike.michalo@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 12 Nov 2026 17:04:09 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9h0jr3BA3tzh9xLP=Kb1Az1C2d+iEFaybzqdZ9dq84zQ@mail.gmail.com>
X-Gm-Features: AclHuK92ID_U7ycQrHXwV5e-9b_Q98zbuWa52wf8PsvE5qRXVAEL0gUhY9EpaQw
Message-ID: <CAKYAXd9h0jr3BA3tzh9xLP=Kb1Az1C2d+iEFaybzqdZ9dq84zQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix out-of-bounds read in expired-session LOCK check
To: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Cc: icb@fastmail.org, senozhatsky@chromium.org, tom@talpey.com, 
	chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2026 at 1:52=E2=80=AFPM Michail Andreas Michalopoulos
<mike.michalo@gmail.com> wrote:
>
> On top of linux-next 20261105 with the four newer ksmbd-for-next commits
> up to a4277e7b7682, under KASAN, with session expiry forced by a
> test-only hook as in your notes. With well-formed requests on an expired
> session, before and after the patch:
>
> - an unlock succeeds and releases the range; another client can then
>   lock it
> - a new lock, and a request that unlocks one range and locks another,
>   both return STATUS_NETWORK_SESSION_EXPIRED and change nothing
> - a compound of an unlock and a lock returns STATUS_SUCCESS and
>   STATUS_NETWORK_SESSION_EXPIRED
> - READ is refused; CLOSE and LOGOFF succeed
>
> These results are the same with and without the patch, with no KASAN
> reports.
> I did not test the malformed request itself.
>
> One difference, for the better: a LOCK with a bad signature on an
> expired session now goes through the signature check in
> __process_request(), so it gets an unsigned STATUS_ACCESS_DENIED instead
> of a STATUS_NETWORK_SESSION_EXPIRED signed with the session's key. Patch
> 5/8 of my v5 signing series fixes the same thing for the other commands;
> the two patches do not overlap.
>
> Tested-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Applied it to #ksmbd-for-next.
Thanks!
