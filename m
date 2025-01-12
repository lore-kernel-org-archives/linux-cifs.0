Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBEC1C2317;
	Sun, 12 Jan 2025 23:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736725321; cv=none; b=hIGa8iMiQITXiktKrbAZDGGU2oijHp3PNtdtrhVF5nqHldaBzEwfJaEYb0lFTPro6MJLxYuHOaIgyDofBBXbIKfYWXBjRcQOs957GNOO5/8wJ1jOs4f07frxQiX71frsYEmSB57w86env4FIwWzLLu2LvuwLa4Rtei5ucop5qFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736725321; c=relaxed/simple;
	bh=LO7w1Pre0BKkQ4EiKO6f1ITzmXgnY7JX2Qjp9cillM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LauKUCSFlz/vaDvTlhPmbffPR5QUqzFPCvNJ61nYKHGmus93hGr0OBQwYFSYyzaUldh/PTR3soCG1S+nrULBtzpfDI0+RMF6vjJoQQtE8+Zb15BRSBPaPfXq/EqAfUKg2M3LdSetdHUsENYS5jkeLTvId4gKtx64NgRR2EgCevE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qPn0LQ+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qPn0LQ+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6831C4CEE3;
	Sun, 12 Jan 2025 23:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736725320;
	bh=LO7w1Pre0BKkQ4EiKO6f1ITzmXgnY7JX2Qjp9cillM0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qPn0LQ+RRc3SIl3UTQoPrf2R6RTopWYxaELWFjRSHNaWYcrtiSP5h+8PtzMCweyIs
	 gHS0XkD/0drJ/YkrVH8wQJfjQEIjB5VnlfiuAVB3S4AmZUYcLJOkZrbbMP55ZavU95
	 zeCtlDNErq2bbI30/qIvkL46t0GJM9k31YpmtT+SyZQVxPlqb3ppsZblvOmFoUCD9o
	 XPsuoF/WGP8kP9kfoJ39uwGfHF1wOzNyi8ALF3iX+ua7T5JTKZaASwZ4Rjt3Yk3w5W
	 zMGSGBTn/HUvhxMBcCWXBFRRK4DOw7oEv4963LDWgqKX6FLAXmDjx9RwUWywqrz4wP
	 e9mLIBrE7G5Rw==
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3ebbec36900so1977714b6e.1;
        Sun, 12 Jan 2025 15:42:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUB9Wj+fyjPAq84kuGOx3qogHXba8hs7+P4DaV9k2r7jBHOFM83TvCTeA6OESmWf4Bv8y5FmMDZbzhR@vger.kernel.org, AJvYcCWkbNBbLe7zdq54BB2vJ59l85EhrbOCbeEC7KGO9oNTAn+/UC6gvj4c323lOQMmePGNtH2d1z77CzRTuNjX@vger.kernel.org
X-Gm-Message-State: AOJu0YxmQCXU6efhlpD5uV2S2ope/guhWHnC9ehe7b79TY4rlQtbpu+E
	yazsyGpbUIfi8ok9DZNkYd0aUpf0ShWqrIy97hfAq8sZgKAVnRtd19zsCXlGHJp3v8cHJz4hTbP
	6Wx4tTe6a2RdLWtUlzkJv1qfbas0=
X-Google-Smtp-Source: AGHT+IHubZd8i/m4odjvTcyjdLjtAfPAL8PVe5gqI1lm/8llcaAjcxPW88+zgLPJqqpdLGiY5/ysmPPPWIbzf66I5e8=
X-Received: by 2002:a05:6808:3c89:b0:3eb:5c27:f75c with SMTP id
 5614622812f47-3ef2ec96edemr11329379b6e.12.1736725320216; Sun, 12 Jan 2025
 15:42:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250112151637.275312-1-linux@treblig.org>
In-Reply-To: <20250112151637.275312-1-linux@treblig.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 13 Jan 2025 08:41:50 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8CcLRnLBsjXNWmT0nS0jdSOZWPs2m-Wak2EPwc9Y0dTA@mail.gmail.com>
X-Gm-Features: AbW1kva9PxmqxWOtVX7lcKuAD7CassO1ncaXV2g0A6PA7dPej4bKrxae6VzHV_A
Message-ID: <CAKYAXd8CcLRnLBsjXNWmT0nS0jdSOZWPs2m-Wak2EPwc9Y0dTA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Remove unused functions
To: linux@treblig.org
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 13, 2025 at 12:16=E2=80=AFAM <linux@treblig.org> wrote:
>
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
>
> ksmbd_rpc_rap() was added in 2021 as part of
> commit 0626e6641f6b ("cifsd: add server handler for central processing an=
d
> tranport layers")
>
> ksmbd_vfs_posix_lock_wait_timeout() was added in 2021 as part of
> commit f44158485826 ("cifsd: add file operations")
>
> both have remained unused.
>
> Remove them.
>
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Applied it to #ksmbd-for-next-next.
Thanks!
