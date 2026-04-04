Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9FA2628D
	for <linux-cifs@vger.kernel.org>; Sat,  4 Apr 2026 02:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775269715; cv=none; b=O/yIhw/cGNiat+MqH49RzthS1IP8wOeJQAFYFwg67yzfvsNUDcEBon5gwDPmt8hiKwKC1y2D5m6dzMgLaALxIfatbv67vcK4mh1xW1md4VLm9qYKWx2UQCJgfdy8TrOAMnSNLO08pPWQAwZARy0o6OnLSloYAG9rt88VoUhtVjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775269715; c=relaxed/simple;
	bh=u4CUB0iQJSw1BJ7hyMEtZYGmMQ3t+SQ2foySZre2HZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ljSWjd/y51+rfjIOKktBlvX0T0U5KV3prPY5ci+btYM5IUHEKgvmSAb8bx/fbYgZFIo+CNkiUPIyZFG5zBas+/y1CyVLjRIXz7iE4ryF/uSwyKx7VZbL+yE80zdbxdA6vdfBUnA/BGKmxhq0ju3UGt5corXrRfuJJ9e7x/mAOEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GgC4YiP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GgC4YiP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03594C2BCB3
	for <linux-cifs@vger.kernel.org>; Sat,  4 Apr 2026 02:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775269715;
	bh=u4CUB0iQJSw1BJ7hyMEtZYGmMQ3t+SQ2foySZre2HZw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GgC4YiP/yQWr9dXnzXBMmQK2RhCKNaER9+hPUPLQgaEMLY/qPefqEgZ5mEfoSD0SR
	 a819wLoxl+tBXs3iQ0hEsfXPHvskEiuBOQXtAeSI9XnXFvC2YuU8Ck5F2TS2GyLU5o
	 2fCmBgsdYe+IpD+firuy3RmAQ4+a5O7z+ufwzFIwrOHlAvik+pDUXQz2iFd73sWJJI
	 dd9VbHcpDzfEaglgnBDFKEPrlh5FG21j7B9tI7RPlrJLow8x/K6zjE3mRIi9rDkgHz
	 w9Aj7L1ivyZC2vjx3a1tNTfCGStYGMq5nVRegLOlpaJXtI4sHCI7zhRXaOrgFFmMGU
	 dVZcc0ceJvHmw==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-66a33f61d80so4222044a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 03 Apr 2026 19:28:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWyoBAb0ksaPcSg10N8xOg9mpuZNf261B6ETERFxne1D7t9E2HTiOMaOJblHULuoQ+dmIofSyX2DHiZ@vger.kernel.org
X-Gm-Message-State: AOJu0YxQrD4uv9nJGYRpg1vr55X9G+7nUiiHzPZTHLKwqxUZAzVI5a+F
	jk6k3Wavr2bhk/ekbUT4bpogeHrbAKnwowhbnsFqIwDj0NgWPhiSNu0bGeeJQqQoEMHxEfWqyFn
	8cL5cQ+dvic5xJehUkYwXA8+izRW1LpE=
X-Received: by 2002:a05:6402:26d3:b0:66e:8ce7:5461 with SMTP id
 4fb4d7f45d1cf-66e8ce7565fmr201222a12.16.1775269713325; Fri, 03 Apr 2026
 19:28:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402083912.457676-1-munanevil@gmail.com>
In-Reply-To: <20260402083912.457676-1-munanevil@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 4 Apr 2026 11:28:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Qnq6YgTfbS-59YATBvnbtKrX3w+D+WNk=izZVvQOoVQ@mail.gmail.com>
X-Gm-Features: AQROBzCSnlJK3jQXwHW0ZwawgQUy3hrfgEGqFuO6mYbofu7ZSWzZ9MVCsRM4g4g
Message-ID: <CAKYAXd9Qnq6YgTfbS-59YATBvnbtKrX3w+D+WNk=izZVvQOoVQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix use-after-free in __ksmbd_close_fd() lock cleanup
To: munan Huang <munanevil@gmail.com>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 2, 2026 at 5:39=E2=80=AFPM munan Huang <munanevil@gmail.com> wr=
ote:
>
> In __ksmbd_close_fd(), when cleaning up byte-range locks on a durable
> file handle closed by the scavenger, the lock cleanup loop
> unconditionally dereferences fp->conn->llist_lock to remove each lock
> from the connection's list:
>
>   list_for_each_entry_safe(smb_lock, tmp_lock, &fp->lock_list, flist) {
>       spin_lock(&fp->conn->llist_lock);
>       list_del(&smb_lock->clist);
>       spin_unlock(&fp->conn->llist_lock);
>   }
>
> However, when a client disconnects without SMB2 LOGOFF, ksmbd preserves
> durable file handles via session_fd_check(), which sets fp->conn to
> NULL and arms the durable scavenger timeout, but does not detach the
> byte-range locks from the dying connection's lock list.
>
> When the scavenger timeout expires, ksmbd_durable_scavenger() calls
> __ksmbd_close_fd(NULL, fp). At this point fp->conn is NULL and the
> original connection object has already been freed by ksmbd_conn_free(),
> so it would cause a use-after-free or NULL pointer dereference.
>
> Fix by checking fp->conn for NULL before accessing fp->conn->llist_lock
> in the lock cleanup loop.
>
> Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
> Cc: stable@vger.kernel.org
> Signed-off-by: munan Huang <munanevil@gmail.com>
I will apply the following patch instead of your patch. Let me know if
I am missing something.
https://github.com/smfrench/smb3-kernel/commit/319ca5432460b0749e420f7cff63=
7dfbc7e16be3
Thanks.
