Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6752238E5DA
	for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 08:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787388553; cv=none; b=NtT9aL8wumU8oPAgwo36UV5u3JsV7UGyNUmEv8r/cUOOstpRiwQV4UNQFujpoTX0cYaT/aIAytUe+3syP1nJMLi/k4aPXiZtiJT7e1LQAJE2r9TWOwAeVFiJ/qhJYxiNMcrsUQu40vY1XxCaUqPu9AqSXbYw9O4zoZWhSU3Gekg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787388553; c=relaxed/simple;
	bh=4vXngXKZDUoUllYcKBkficNbrVYfStS2jVIk8YuZGSE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=auCuPbb0V4MKYh/LaCgaUcg0z6VieL3uj/MgY05ncMzGJXc7jSS6ObxpPhBxEP1TOBCUCi5xUga7oy8eUIxV4R6RYh42AtAMa0OD7jP0gDtxxotvBhD8tr+6JA8/pcw9CYDpdzxpGjxmfB1x5zjhhhyPFB+ZKixTetpL2jCxLtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FpqdkhDg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FpqdkhDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1401F00AC4
	for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 08:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787388551;
	bh=4vXngXKZDUoUllYcKBkficNbrVYfStS2jVIk8YuZGSE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FpqdkhDgRrsdAEqZqnxVgJiQKsElFHckCYWDNkpqy9u0YlcpXRU4UK7puNiHyOveW
	 DarKWESnDc4A8e+85DgHddLqD63JTka3ctzoC5kR5zgLMBfirNiwijejqFg09MrI/8
	 xXnb+pdjZVvODxdlul0s+N7oCHpIB720WycNnjUHs8eYjuEmHFdGIXSfz6sLPRcuSA
	 xuGLJZHLk5PZDP6VdzPeblzRo4DD5E4HZbBtPvzXjtLzSMLyvJkTkp0T8u20WVlmtA
	 g9IPpYVBJNq3Rx/6CnnLiierHU7ebPbk0F/h/3BIEMnqnteXL/Wn21Han+INyvGBdb
	 rL16bfed0Pc1Q==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c15e2dab83eso345669766b.1
        for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 01:49:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro1AdnlRnbZu1njkKIXKOs9oGdhMvblBUbrZf+rS9wud6/u9EEai9Q71X0EYPsYcYwUcVf2UYHMiCzl@vger.kernel.org
X-Gm-Message-State: AFuF++lgFuaZUY+uEAETg80gH7rPJ3OSdBN/hD7vju8bcIax1PLb0Nh8
	SsfqRZ8KiabrVRe0o0QDEbLb5/AnVs2jFE1HWZKIBC2qAEmrpO5w7MoeJxTSYqfvsfdmFALCVE+
	jGIutfAm28dxtZjsnFZTVvsiKnGF/gq0=
X-Received: by 2002:a17:906:2481:b0:c1c:2007:298e with SMTP id
 a640c23a62f3a-c246b4c5e33mr1042607366b.24.1787388550512; Sat, 22 Aug 2026
 01:49:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd84UnfdQ6Ef2nqybnhdgURFo9uYpB1mHZpphFyCiMhutA@mail.gmail.com> <9aeb9ccf-dcd0-48a7-bc24-4b6948943f62@chenxiaosong.com>
In-Reply-To: <9aeb9ccf-dcd0-48a7-bc24-4b6948943f62@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 22 Aug 2026 17:48:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8JMs25fdyZhPn9KYEfv1WH297nxAV0enFHm6T+q=VTFQ@mail.gmail.com>
X-Gm-Features: AcwNN1XpWdJA1Za5-BIoYSJN27a_FoNhZEBta0SpDkzpn3D4Q1325ar3fZ2wExU
Message-ID: <CAKYAXd8JMs25fdyZhPn9KYEfv1WH297nxAV0enFHm6T+q=VTFQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] ksmbd: refactor smb2_notify() to a blocking wait
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, tom@talpey.com, 
	senozhatsky@chromium.org, slow@samba.org, gael.blivet@gmail.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2026 at 3:47=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Hi Namjae,
>
> Before this patchset, the two test cases also failed. I would like to
> know your test results before this patchset. I am not sure whether there
> is something wrong with my krb5 environment. But I tested the
> `smb2.session.expire1s` and `smb2.session.expire1e` test cases, and they
> passed.
Can you check if smb2.session.expire1s/1e tests are passed after
applying these patches ?
