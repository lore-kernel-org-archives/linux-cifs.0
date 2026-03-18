Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1B022B584
	for <linux-cifs@vger.kernel.org>; Wed, 18 Mar 2026 01:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773795991; cv=none; b=tgenklEBtuIFXvLu/H7YZf/bR6VnsTLCrVJHxXzWpp7Wc3ZJmTlejSj6mAwRGRJIeBjE/cWFxjlQegA03XJdpIquFOZek1q1YhO+BfpWlclgtnzi5kaBhtehxG3ZET12fMqo0esXMBcsyxiCeS/MJpXkdHV1b3H7c8YeLcteM18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773795991; c=relaxed/simple;
	bh=keebvrsQ3OBWSNrMfbTJBtQ11kyCtS7uTdhCEXjCWD4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UgfPkI/vJq1UV1mtz2Hi098FgNPfrG8C4QZ2creqe5rFNko2LrfwW/b1yXmZVdJwqtZz4HRRIi1hufhCgmr43PdMVkJ82CnO+tZo3EKPzgzxWfrDVHIJXlSUIrFcdtbRa0AgZVMI8Uffg+K034rPVl2fkHMQzveavuNvPVhBiVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oy+J0caO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oy+J0caO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E03C2BCB1
	for <linux-cifs@vger.kernel.org>; Wed, 18 Mar 2026 01:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773795990;
	bh=keebvrsQ3OBWSNrMfbTJBtQ11kyCtS7uTdhCEXjCWD4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Oy+J0caOvEOJDSlc/H0HWRZclIPK+he2LpUtMxw+1CoDlJqwEsByJYBpgbcuYVZwz
	 mwMWakKwhOTjh3TAOPlXrK23vxmkC+oC/TQoe4tHpK6kRhQzWCwFr18TgWlokttO02
	 oZ/RutHQticxOvcqucRaOYt5jb8x87KpYb8vYUyJmZgOkEIFpVlDe1CLUxl+N6Gvk7
	 wohbD6exL/qE9LQAwhIr7SmZP6dJd4meHLAMByJitgTPHLrjpgeqvkhrSkBgCfTrHH
	 m4FgF9reEqtoctvKmPyUFarrkpI1iWso68QlqA+KQNtZp8QgFa/gjAcC3KW0yS6ZlO
	 U53LOEfkVwzmA==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-664f8bef4e7so4487125a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2026 18:06:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVvjpTjekiWgLwFDyWhOeCcrTopW8sXqEpu/+zcF//8yQ4Euj4Mfzmt8t5zlRHl0W6wWW4oHzBxmXku@vger.kernel.org
X-Gm-Message-State: AOJu0YwMS+kVc4P7wJNLLJEkw+GdaDAljFdaDdti4fo/vgiazsZ/CnSF
	+pWl1LDRVSNvOJZLUZ+crYeYtz/cO8850QZgQNmKabAcG93DHxFC0jfTpZoBsOi644mVTRGv5Vh
	lnTde6gkzL4KL52Ly/2po64RmEQTpqc0=
X-Received: by 2002:a05:6402:444c:b0:661:6cbc:2765 with SMTP id
 4fb4d7f45d1cf-667b33dfa04mr659678a12.26.1773795989241; Tue, 17 Mar 2026
 18:06:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260317094653.2236624-1-werner@verivus.com>
In-Reply-To: <20260317094653.2236624-1-werner@verivus.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 18 Mar 2026 10:06:17 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9ykVO+_xffR=SwWdCf+FScRWnfvRR6xTa9OWgwaXuXcQ@mail.gmail.com>
X-Gm-Features: AaiRm52Qor9aySSdYVIj8poIP9tGiZ_BnVF2dCThZozx7hSRUxYFKi1EF2J7a1Y
Message-ID: <CAKYAXd9ykVO+_xffR=SwWdCf+FScRWnfvRR6xTa9OWgwaXuXcQ@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: fix memory leaks and NULL deref in smb2_lock()
To: Werner Kasselman <werner@verivus.ai>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 17, 2026 at 6:53=E2=80=AFPM Werner Kasselman <werner@verivus.ai=
> wrote:
>
> smb2_lock() has three error handling issues after list_del() detaches
> smb_lock from lock_list at no_check_cl:
>
> 1) If vfs_lock_file() returns an unexpected error in the non-UNLOCK
>    path, goto out leaks smb_lock and its flock because the out:
>    handler only iterates lock_list and rollback_list, neither of
>    which contains the detached smb_lock.
>
> 2) If vfs_lock_file() returns -ENOENT in the UNLOCK path, goto out
>    leaks smb_lock and flock for the same reason.  The error code
>    returned to the dispatcher is also stale.
>
> 3) In the rollback path, smb_flock_init() can return NULL on
>    allocation failure.  The result is dereferenced unconditionally,
>    causing a kernel NULL pointer dereference.  Add a NULL check to
>    prevent the crash and clean up the bookkeeping; the VFS lock
>    itself cannot be rolled back without the allocation and will be
>    released at file or connection teardown.
>
> Fix cases 1 and 2 by hoisting the locks_free_lock()/kfree() to before
> the if(!rc) check in the UNLOCK branch so all exit paths share one
> free site, and by freeing smb_lock and flock before goto out in the
> non-UNLOCK branch.  Propagate the correct error code in both cases.
> Fix case 3 by wrapping the VFS unlock in an if(rlock) guard and adding
> a NULL check for locks_free_lock(rlock) in the shared cleanup.
>
> Found via call-graph analysis using sqry.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Suggested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: Werner Kasselman <werner@verivus.com>
Applied it to #ksmbd-for-next-next.
Thanks!
