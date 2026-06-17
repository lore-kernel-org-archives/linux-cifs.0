Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4A43112B2
	for <linux-cifs@vger.kernel.org>; Wed, 17 Jun 2026 03:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781667894; cv=none; b=bfjXDXdtpzDnSrzuQay6W+yH7qqip4RL2itV2mW6rTO4wLvGbOEQhQ+6INk0oqsZxvLrnNfp9hP+3P7Z2JTrJGbtNiyWnaUexzwZjDvxdyZjQ842QGNQWOUEDQ7LxLQnI1k/cDG+PwSIKxZm1nVKR9OmuibwF8K7jqPJZHjiaPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781667894; c=relaxed/simple;
	bh=unW95AiuwHyfXd4SvDHElm4zOB95uM2tM5cjOt3/y2s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j6n4UcLhCuMBjDV8n6XMWASBlj4VU7rTjhsK3WhhRriEsZ2ucm6SncyQd3te+g/7spIJQKRVYvI3qo2OKMtQugmLL8XaT48xOmcDmZlI3Q6PNkUmqydalL1++H40yopYRkhU1z+rFbzcgTqi3eZES3VybfnpcJ0RlaPlvjGkHc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9GIF/5b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9GIF/5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10041F00ADF
	for <linux-cifs@vger.kernel.org>; Wed, 17 Jun 2026 03:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781667892;
	bh=unW95AiuwHyfXd4SvDHElm4zOB95uM2tM5cjOt3/y2s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=H9GIF/5bWIITy4PU5jc6XXxXnXCHd+FigsQbShrJMgJHziMUS/Cf18pZZ37FLbjoL
	 YX9vi2Os5EsX+udZLlvCrSSOAxWKRdf/W1rSP4ObHuqRo17XoHPG1+EA/aCbb5G4d/
	 /IDwdro8ZSpqhjA7mBmxEJlRV++mR02KCvLFLRm8E32FegblcV5dAS4vEwVDhd3q8U
	 CMGgzdc6C8Llq0akvKKt1vTketQAMRzqjQrAcM7wuTouU1jUvsYUZ3YQMOntLutp3a
	 qurxwVoWZ2lxG22+8j2oVanA8V+6a9SrIjMVXmRkUk6kTfQpHjBCOpdrCjtMXZnabp
	 cbwyQhjhyGz1A==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bec449cf976so654781866b.2
        for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 20:44:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8d+yKh2hkQnQmWoLoJqtT6fNX+7nucuY5t7QVtlv0XiBkoMvJtaes14ZdmXPT5Uw8ZwORjlJ2KRaim@vger.kernel.org
X-Gm-Message-State: AOJu0YwsE2Iof2Icj9FhofG/vSXgIWnq/V+5BZNU7JGbq8HaudEgpMjl
	XvszNuUFnznMbAeJ4Qsz2pgZ+2X00Y7pQxRTnoJDJGuG2vcxsnKPb7oK/88OuV5p8pyU80PocRn
	Gcav82vqpzqrz7ADuEsMt0vZxsXqQ6SM=
X-Received: by 2002:a17:907:9711:b0:c05:a987:6818 with SMTP id
 a640c23a62f3a-c05d2a8ede4mr90961166b.45.1781667891287; Tue, 16 Jun 2026
 20:44:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260617023632.122384-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260617023632.122384-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 17 Jun 2026 12:44:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8mTewOvwVuF_w_Y7djEveVvsWFYYmf8mADPy5JmZ8Zvg@mail.gmail.com>
X-Gm-Features: AVVi8Cd8bWUNt1pdLWtzir6NYC1VS67c68sZrPGAkAceRK9yd5OdbcFbdhhQDuY
Message-ID: <CAKYAXd8mTewOvwVuF_w_Y7djEveVvsWFYYmf8mADPy5JmZ8Zvg@mail.gmail.com>
Subject: Re: [PATCH] smb/server: fix debug log endianness in smb2_cancel()
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2026 at 11:38=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Convert to CPU byte order to avoid incorrect debug log
> on big-endian architectures.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next-next.
Thanks!
