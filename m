Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075042264A8
	for <linux-cifs@vger.kernel.org>; Wed, 18 Mar 2026 01:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773796054; cv=none; b=ZA2SYmE4Ss/SQ3YaL5HeLJpXMMQ6ffKM+ej0bivbeGIA/M7PfoY/WpQ1i1iyIBZOu1PKW8lm5yLyL0B3/i0dEbaZgBLM4fltIEmZ2wMiiSYU3Tpk3896/gTr0YJZrWVfbvKs8VJFHWJoJBHp8tjGY5jO4r1B8NS8MgbrZOt2drk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773796054; c=relaxed/simple;
	bh=5L2HrBeDgS3IjdtBDs5XNbBpQa3jsl53WayKF9yDnAE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tsv/h3bdBxyoQ5LAjgAXr3Xi/BTTzxqx4xm5jwVH50Nefb0jKND6vbsHUtpjj/TMXB6IVE2Vakx7dpVSWFss2FeCKD9b7g7ca6MIHU74UvV5yH02h5aP6pyl3hVJrHdzmvAhimjsZfgwdmoTVsYO3aACU1RhFJf0223WxpYZdws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BCISaDPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BCISaDPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1A5C19424
	for <linux-cifs@vger.kernel.org>; Wed, 18 Mar 2026 01:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773796053;
	bh=5L2HrBeDgS3IjdtBDs5XNbBpQa3jsl53WayKF9yDnAE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BCISaDPdwc99HnHhHQH7vwJeRFEw6VvmEWpqutaDnORjdsHWJdgh0QdMKRtZSMFwR
	 7m8JyU7A/9x/nNmkiEMPsvnuAon9zHa/dxEwelkHQxjcstlhCy3NY0swXBAdtGd4Cv
	 01unhrxdhsFNKiAdbvAqTrCtiTEfc3r1Mk3tchY3CnPBvcLOMi0iorVBifJtG0RURr
	 QjrjS68vTkRch1V/9hqxw83INAhxkxp4YhTxuJthKRX4MslMdvA4zCPy6w/Mnwoljv
	 f88zI0vj8h9jeKgDYu2boud9XIsAy3/Dfw/+FDaCLBjOci/Yd4Vr/18IwcsPkE7MJw
	 vDEGoxoGhDMmw==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-660a293515fso12096049a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2026 18:07:33 -0700 (PDT)
X-Gm-Message-State: AOJu0YwLs4JJmNuD4Apm5kBaSfGZSgr6RkUPVs9BnxjlvOAAArmNrh6L
	Wb5bkzMrCBXxeO739Fiue1a0j1kKRGHfZQtSKho1CwYmxgBrK0uM5KJD7zv5qORJxYbXdA221zY
	ZmPKycTAaLtBBoCrD+QORPREsUgi5x8E=
X-Received: by 2002:a05:6402:4301:b0:665:3438:2735 with SMTP id
 4fb4d7f45d1cf-667b1984daemr1060681a12.1.1773796052196; Tue, 17 Mar 2026
 18:07:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260317065253.1743552-1-werner@verivus.com>
In-Reply-To: <20260317065253.1743552-1-werner@verivus.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 18 Mar 2026 10:07:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-mw8ZJiRVkFWJgN1HPFVFj8QWgu69q0_GxYSSr8s+18w@mail.gmail.com>
X-Gm-Features: AaiRm51sakxigjvUSE6xf1rgQc8fpNmQ4fFmlSQ6KG4IMvyu1xYPsvbPCKmli1A
Message-ID: <CAKYAXd-mw8ZJiRVkFWJgN1HPFVFj8QWgu69q0_GxYSSr8s+18w@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: fix use-after-free and NULL deref in smb_grant_oplock()
To: Werner Kasselman <werner@verivus.ai>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "smfrench@gmail.com" <smfrench@gmail.com>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"chenxiaosong@chenxiaosong.com" <chenxiaosong@chenxiaosong.com>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 17, 2026 at 3:53=E2=80=AFPM Werner Kasselman <werner@verivus.ai=
> wrote:
>
> smb_grant_oplock() has two issues in the oplock publication sequence:
>
> 1) opinfo is linked into ci->m_op_list (via opinfo_add) before
>    add_lease_global_list() is called.  If add_lease_global_list()
>    fails (kmalloc returns NULL), the error path frees the opinfo
>    via __free_opinfo() while it is still linked in ci->m_op_list.
>    Concurrent m_op_list readers (opinfo_get_list, or direct iteration
>    in smb_break_all_levII_oplock) dereference the freed node.
>
> 2) opinfo->o_fp is assigned after add_lease_global_list() publishes
>    the opinfo on the global lease list.  A concurrent
>    find_same_lease_key() can walk the lease list and dereference
>    opinfo->o_fp->f_ci while o_fp is still NULL.
>
> Fix by restructuring the publication sequence to eliminate post-publish
> failure:
>
> - Set opinfo->o_fp before any list publication (fixes NULL deref).
> - Preallocate lease_table via alloc_lease_table() before opinfo_add()
>   so add_lease_global_list() becomes infallible after publication.
> - Keep the original m_op_list publication order (opinfo_add before
>   lease list) so concurrent opens via same_client_has_lease() and
>   opinfo_get_list() still see the in-flight grant.
> - Use opinfo_put() instead of __free_opinfo() on err_out so that
>   the RCU-deferred free path is used.
>
> This also requires splitting add_lease_global_list() to take a
> preallocated lease_table and changing its return type from int to void,
> since it can no longer fail.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Fixes: 1dfd062caa16 ("ksmbd: fix use-after-free by using call_rcu() for o=
plock_info")
> Cc: stable@vger.kernel.org
> Signed-off-by: Werner Kasselman <werner@verivus.com>
Applied it to #ksmbd-for-next-next.
Thanks!
