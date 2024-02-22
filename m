Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612D7405E6
	for <linux-cifs@vger.kernel.org>; Thu, 22 Feb 2024 11:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708599608; cv=none; b=Ql6StmgoKelDOEd5KfkTrZr5FtZKdv+NtXx2kRvIWgtDTm6lRPB1Q4j4jsDP0SBezU5Ypxx2GNC4sZpOsK8L8d7hmSZnyU3MGikFnseSOeIHpEuZMLEZb3xWOLDhdAa8eM+2wgFXX1Hyae6rK0pt/FeuuzWRA8rqg06puRDeFoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708599608; c=relaxed/simple;
	bh=y7J9garjOFBKVkRwFyzigJ9mw3821TdAVEud7kRnn1g=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ek52Xr1djJmVSqOC/dPHhu+XvAY6GNklhlB0Z8x0+rfG1kddialLFYpbFqsYBHUbG+ynMQrKAZaTkU1qM1RGLbXlVRpuQHp15ucft+VAjSRcuxWO+zASB7fERfeYq5Ohlnv7+vJVOMRageclXUYEN8Wrb+SSIADY18XHnb9ZtQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2bsgfY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2bsgfY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40864C43394
	for <linux-cifs@vger.kernel.org>; Thu, 22 Feb 2024 11:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708599608;
	bh=y7J9garjOFBKVkRwFyzigJ9mw3821TdAVEud7kRnn1g=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=f2bsgfY1BbTTvmNaA9BjzbtnDjDG+csVs/+ryQvmB6wYzwnqs8G10EnFnJe5tAr5n
	 9Xp8cw9m/h7QGqYInUf5IOyzBEG+L0Izvxn5j56DimKg4C+KBikkFGul7YP93H6cXK
	 fkygC1Eh33/b8pLR9XTmWQqiP6pD08/tqPDyZ/DN9n4U1nrhp7Y2dLY3Tb07gzR+WV
	 3NgW6fuzUR/K56nVZYV7Oga1nIS8cciI6XXmmkJu0lJdgG2Z+WYdFzrMFd6qJvcXOU
	 hU8jWrSmYCYFb85h/gulIKfYF4Jpej4R7ODlDa+ha5A0kcoXUxZhmaZdvC5NCCpbnl
	 JkhHiK9XK9ETw==
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-59a1a03d067so1547459eaf.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Feb 2024 03:00:08 -0800 (PST)
X-Gm-Message-State: AOJu0YyUv2+YWgv1BS/bO/JzVrrGBL3nltlfvotJfg194nAfCQ8g1NE9
	uzO3LHJ0tIJKfTaJR0Zo077PR9tPqsexDExyZ5VV3WudM4afnsMvqom8kVtMW7ItJdf5ZqYltJn
	fBPz3RwgDvq6l8kUGEu+LPGCk6PM=
X-Google-Smtp-Source: AGHT+IEXqAU8T1qnfBK3tF0rDZpFj+ee/d/yT5wZ2vRgTN2Ba3nQ31K7eF1FS3pEfwtHVrOyWjqtaBXJE9YJFByMMTo=
X-Received: by 2002:a4a:6b51:0:b0:59f:f3e6:cbc3 with SMTP id
 h17-20020a4a6b51000000b0059ff3e6cbc3mr8622435oof.4.1708599607545; Thu, 22 Feb
 2024 03:00:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:a8a:c12:0:b0:51b:642f:123c with HTTP; Thu, 22 Feb 2024
 03:00:06 -0800 (PST)
In-Reply-To: <20240222095819.2188726-1-mmakassikis@freebox.fr>
References: <20240222095819.2188726-1-mmakassikis@freebox.fr>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Feb 2024 20:00:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-xCNCTE0virFCMC9pfW1NQQFWL3LRn0SeHjLGqxXfpng@mail.gmail.com>
Message-ID: <CAKYAXd-xCNCTE0virFCMC9pfW1NQQFWL3LRn0SeHjLGqxXfpng@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ksmbd: replace generic_fillattr with vfs_getattr
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

2024-02-22 18:58 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> generic_fillattr should not be used outside of ->getattr
> implementations.
>
> Use vfs_getattr instead, and adapt functions to return an
> error code to the caller.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Applied it to #ksmbd-for-next-next.
Thanks for your patch.
