Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3262FFFA5
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 02:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784168764; cv=none; b=sFA+SxdA5S3BteeACK/JuXH88BIrGQ4gKaMXvWL9m5mpfQFpiiam/acM127xYWBO8u3jYDnPh6I0+LrL5tcsEQPaIuNxMqIxH6YV6eIxmX1MbNtEuQrfLSKcjdQ9X16fONJTyV6Y/M9CUF4r8iRFu/xwkl0zGar7GWPVl3mU0Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784168764; c=relaxed/simple;
	bh=6noZXBnx7p68SqwG0kC87JZUFtACicYarkzgg+q9U7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aTJEYWb3ZFtkIto7q/qy+Km4qB+oEAL67/v9YEuqUJ/iQFpd4tfvf8NVB3Wq63xNujx4PpJNZXzOFp9FQgzLQKigmu4torcLGWikImtgsh5y54MWNCHNFie2YG4k+jG/AaGNNtckTGfHRfVoBzT9TLSr8uwMyD0lmpssBJ5yrJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0CkPhAR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0CkPhAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EE71F01558
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 02:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784168763;
	bh=6noZXBnx7p68SqwG0kC87JZUFtACicYarkzgg+q9U7s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=a0CkPhARdWhpAe9XhQKQXunNkThoEPy2XlpeigZ9P/gJbEEgQZgo9fO6c0XGugLNK
	 W9V10R967vV4JikAFdsjKRqUaMc8tAuIzYo9CW6km218IlBZFXMM+PruQfhqCpSiKe
	 5eil6rt/VhHoArSzZs2UAMZQB3ujkP/3Z7RG87WbVtc4RvppTdXDjhRy5SMw0IJIgF
	 eYgoR8JmohpKmCBZaqvEcrikzy6Ef28ScGVdpBYbGhokpJxH8+PEK6WHyrC+YKKwUt
	 XX6vRUJNFt7cHFTZf6Sk9WFpiySO0nYZdtPxMt0Yx3N5hgtLxLA3HpLtwVDwRCzNZr
	 q+x7btCvjtV1A==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c1601d552a8so635893566b.2
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 19:26:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqyfUCXABLHWSDWlNZCqKnK/6x9C0VmTWgi2G6kPQSu4Nv+oeojqbLRPL98nIl8lSTBOAPAyNFFnB2S@vger.kernel.org
X-Gm-Message-State: AOJu0YwlsoRKoc6S3lEBOWnTqJECejm05ilxjcOXdxqRakf9Ry8JyO46
	2CPENATRq28ixtQCSQCDpCr6xWiITc9BlXzfNRbIVrgtAhAKP4MG+wtsqzbT5Kg5xI/2RRyt8+u
	/jpENqA8NDi4TZWUwAQ+YavlrzDlrUJM=
X-Received: by 2002:a17:906:9fcd:b0:c16:6669:a4aa with SMTP id
 a640c23a62f3a-c1667b31c6dmr616958466b.48.1784168761512; Wed, 15 Jul 2026
 19:26:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260716001156.671587-1-chenxiaosong@chenxiaosong.com> <20260716001156.671587-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260716001156.671587-4-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 16 Jul 2026 11:25:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-UsvUOK6A_8k8pdtYXANKeve+yDpVwXyRFa0wpyQ=nRw@mail.gmail.com>
X-Gm-Features: AUfX_myx3MSG7IE1V0rN6p4s7I7kdkblwTWzvOgCitTmXek7zmGPoc8n8KbbcrY
Message-ID: <CAKYAXd-UsvUOK6A_8k8pdtYXANKeve+yDpVwXyRFa0wpyQ=nRw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] smb/server: stop new async work when closing connection
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	gael.blivet@gmail.com, andriy.shevchenko@linux.intel.com, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 9:12=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> A new async request may be added while a connection is closing.
> The close code may miss this request and wait forever.
>
> Check the connection state before adding the request. Return an error
> and release the async ID if the connection is closing.
setup_async_work() protects only work items registered through that
helper. However, smb2_notify() later creates a synthetic in_work and
adds it directly to conn->async_requests. Therefore, the
connection-close path can finish scanning and cancelling the existing
async requests before in_work is added. in_work is then registered
after the connection enters the releasing state and is not cancelled.
So, we need to protect this direct registration with the same
connection-state check, or use a common helper for all async request
registrations.
Thanks!
