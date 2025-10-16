Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25524A21
	for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 01:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760578784; cv=none; b=R4LcKiBJ3NIWLPio1QGsaYjDyhZYa4NHxoh/BjLTEGA+KvOMGi4hEg9KP6L3jO6ByvCfx4foX9HsGezNCT2JDo3RXfsib+YgTHPDsZGreDMx62TxRqbY67bMIfsciZtqzY9l1m+nF7ASEFQy4QEIbVFYNf9V9kQqPk42KrW1H3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760578784; c=relaxed/simple;
	bh=NhXpNt5UXUXiz5jBvZva67jJz20jfIcaD8d1CiGWqnE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m1cV5/zC2aISJ+LUuo+z+AswH6rznqP12+mRgFDfvxtvEKy75GTLNLW3qd9KkJdcHU9UzTTBctJURO8x41DskNNrs9PGfaXHFSBGA54VlwZX6OI7+ma6FQZVqWUrPwo3qmFMakxRKoMZJihqcw0G+8KzQzbVgvoSsUlzWiwYbug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehR4mtxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehR4mtxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323B6C4AF09
	for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 01:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760578783;
	bh=NhXpNt5UXUXiz5jBvZva67jJz20jfIcaD8d1CiGWqnE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ehR4mtxZpG1HtChuZG0ohdH4pnl84kRn0mCw9JtZq/csxlFhXIJFvHzsN/kXkjjWI
	 PxWERL6D8BLhYCmnN+W7ve2qwHm8eDHy6liyFH8kbGLTfJruUO57GPdm/I3sxwgNZf
	 7sdpZkWd8xQ4tc8m4PKclyO5iJ57Kya8xDY2EG76iNkeQlsgnhWV/pKZwCMs1wfgpg
	 z6Neh7XgsjmjnVt7WXB0AzOIcwVrD2DbYT6Zxf6zxozuhmHpqovuOJ2nqeNYQsLx0u
	 2j27TErBU3/vybHGhQ6rbQaj+95pT4q5+Uel6lA804gs2cgQEjgaN+MLzeQ7HdYt67
	 ZHT6fKaOLhvyQ==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b5e19810703so23621066b.2
        for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 18:39:43 -0700 (PDT)
X-Gm-Message-State: AOJu0YwNDZSe2cJcr4o/iZxqo6dA2fa9dvGCqth48ACQcQ5XN0wIh8EN
	pJtAIVGJQsTAAYDNWkQAr+eNCK0kXB0XGlSFrhmIURqROAgiSkVvc+mLx5sehk6gIndGxasZ4Co
	h4F814Xg8LQzLlPcmcQcg7IIVMpuGrYs=
X-Google-Smtp-Source: AGHT+IFkuj2gn7j4EKFSb8mXxfaPao6rWf4LSgGhFV/1DY7kYAtV9Z2dgD6/f3T5VanUmKryMjD3HNMvXh6rn8NDpWk=
X-Received: by 2002:a17:907:80a:b0:b48:6b19:e65c with SMTP id
 a640c23a62f3a-b50aba9d735mr3027700166b.42.1760578781745; Wed, 15 Oct 2025
 18:39:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251015150527.1109622-1-metze@samba.org>
In-Reply-To: <20251015150527.1109622-1-metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 16 Oct 2025 10:39:29 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-qN17m=CCnyUksiZZD0F7221kFh9xpV0FhRk8hSQiNgQ@mail.gmail.com>
X-Gm-Features: AS18NWCrRIOBjY9SmWEj0Dw7rfBTOpn4PjO_y6WdvXCqZgpA9Y4_1st5Jo8ZUec
Message-ID: <CAKYAXd-qN17m=CCnyUksiZZD0F7221kFh9xpV0FhRk8hSQiNgQ@mail.gmail.com>
Subject: Re: [PATCH] smb: server: let free_transport() wait for SMBDIRECT_SOCKET_DISCONNECTED
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2025 at 12:05=E2=80=AFAM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> We should wait for the rdma_cm to become SMBDIRECT_SOCKET_DISCONNECTED!
>
> At least on the client side (with similar code)
> wait_event_interruptible() often returns with -ERESTARTSYS instead of
> waiting for SMBDIRECT_SOCKET_DISCONNECTED.
> We should use wait_event() here too, which makes the code be identical
> in client and server, which will help when moving to common functions.
>
> Fixes: b31606097de8 ("smb: server: move smb_direct_disconnect_rdma_work()=
 into free_transport()")
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
Applied it to #ksmbd-for-next-next.
Thanks!
