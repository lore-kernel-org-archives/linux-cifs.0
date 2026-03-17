Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A7B385517
	for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2026 21:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773782516; cv=pass; b=QgTiw+11Y8+l4iEa/kUrNEsr15TdjEqZBO/xRsh+Skc1HoYhp5TmQUCgedo7ZzcbWF8xBq4c6bMZEs/VvpJUuLSwhEhN8BxwWdQ8AuyTwpOxYhGWBHh2GnaOx/YoxOJTGEBFYQ0UkqVygQ4ZQb5xR167LSgY2bv0H96tSIlYnRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773782516; c=relaxed/simple;
	bh=TlJCQUFeA7wXwWNxxCXKjq8200d9TSWk2kbn4D4a0F4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BFvJk2FQwpf1Y/7gDmEO6byiwAiv6Z1PbD/mq5HVqU8eeAEndygIbF9Fxdt6Jdzm4Mt89LjZPSShAfzHEjBd5bPeMbJG5uY6QZxcSntHRzQ7qq3bQlmf66IS+r+/nQYnpgDke+xJ+j7efPW+ySukeoT2quEqx3CpvmuIREz6hZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c/H/oSp9; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c/H/oSp9"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-89c43c4c383so34875326d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2026 14:21:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773782514; cv=none;
        d=google.com; s=arc-20240605;
        b=cgPkC4VMtYpHVpdSYpputCaOkAIjR+OY+8niXj28u4OqYgQhIYdq0X3xhFH5QBhK37
         XtQgmsqJE97XhT7KvBINQbqCseAlwWVBHKnwxwUZmCrsV5ouId928DyaVX8LrM2JtiyQ
         co5TBxq/KcDr/ygxgdJ1N0N13pYVA8/+XGVScy61t2+7mlPHZG8RXlhkEQDUhY6BAQ3w
         I3zNa/T/2+zJ03zvYcYdEj3MLIckh6YtgvfbM9ai4aAyQiQoBCpyS8oepNXFdMtLL8Ae
         iK7FD0UsZAdjzSNfnUXdoHH7PPt3L5R6wrTSb5dtpz/11X2uKWR4qydfsmaod7/3BDl0
         uvuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IW/QZFjwdstBVjqcVjvGz0a1qDUdxk2SOzhF/DKvYEk=;
        fh=/SzcIXCSxcVYENj3+hSjLBZOMGlRd9QE1hjC9xORfPY=;
        b=SRh/3jjeqD0dwxDr7Z4envjMjBChbfVToeLXEaByTLT/Sokh8nhozeCQvZcdOVw3AR
         9Bxwbt+ek3wuqU/jJ/3xa0Ek5vaCQv5fOynl/RgzVJQvp1xiJ7Ux/36l2mDJac3wL/kg
         ACQyPrky5ty0Ixun4QmOP05Hvxy/ZSMKeZna2gK5Z0JqDMM/aqTmugQL1AEzL0+qPAju
         fq7CHMyEI3GScEuhoKE6uOXbt0dBDH2tled2rq4tA5q2F8Dvim7+G2G9sG6Sk/RZMLpj
         YpdtptroD8uB9KZnHqOs6jphcakwN8LQY6O3Qx7Su/leYMZ8enh+c3s/ew1ySx8LFSkm
         jIuw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773782514; x=1774387314; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IW/QZFjwdstBVjqcVjvGz0a1qDUdxk2SOzhF/DKvYEk=;
        b=c/H/oSp91/Hvrma4o2VlwKyyV5Bkwm0b3e4fhaP3aSjHn5M2S9uYe/8JQZtKMbJHJh
         skRi85PPxleS4WIuW7D9z1E/CGCUy6fbZBHcYsC9BQ9DTwWB7yWVqYM5zLYuNvUpOE52
         wybdL7rSP72OreVTYDD5NDEGw8GuOoZpPc0icjtabGkPJYRN0Rxc/ZAJ7yHOwKx2GHz4
         Q7R/OxuoSaheotF1EL6AvzKeBOa2kmxZfDKqiPX3+RxEhqERFaC7b4vOvPNY4DTsRT2I
         bfZPSKennk/sK2AXwIfS+ngTP1KEdqdVNN5qhVNaXja0Ub91vrGtEo0hVebLtWubDfQP
         1dEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773782514; x=1774387314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IW/QZFjwdstBVjqcVjvGz0a1qDUdxk2SOzhF/DKvYEk=;
        b=UxLpQPo8yfqXMTeI9RFGNPIOYe8HO8LaJeXVVBWSk2GHBD705L9R+XXtwD4etaqFPh
         ZJVRChzJc/blAb3HFkNu8Ga83jW5ImXlQqTKDUPBKZYXz17hFc3PcMzJiCxnc0REoypj
         Rt+XFwk/uLtJjPRN83Bou1hridaOTGNitmpPZYX1HMtlI23pOVB5zbCG1A1TN30Ejg2l
         4ITtKT12W6+nwcxijXJW0naoPqT/+iAkGILIbMcbkWzeE1YEGOABEqiprO+7nKKfQdvx
         8CfWZ1EoLDsU65GEMEjwb/Zzo3f7mlPqmjqxZpyVUEbFoA/iEXLWtGMwB6yW2ZpOZwuw
         B63Q==
X-Forwarded-Encrypted: i=1; AJvYcCXusjd3tQLcC4DckyGVzVUb02nhPaGaP3WHMOvgC4uvVNZPEPltSZK2uVnuyW+WbLVwp7lVv8QlQI8O@vger.kernel.org
X-Gm-Message-State: AOJu0YwI7NdfGJzO0Sy/JrYf2AW6/0JEf2bqepymX2gcuykKvzc4kW/i
	T9YraB5ApCoYrb3Ruzb/fSyOejomNpAocmbAqFH3js2iNMkdvTkpSxieGzSTy8nKoHX4uPrMRZ2
	9wed+K5iSdoIBLhXBrSKcB2cDgQCoBXM=
X-Gm-Gg: ATEYQzyTiTCOG2SCYl/rTJNINPpUWQVEv9hdfsEnq+MAA47n1HzZ3un736D6gLQSdvp
	LIlCLbD0PrbtTP1M6O6HjXJqKVX17IVyR06gmWwwgEIMBFuDAj3eyDwEv+ApGnTKmQ8Avhsmixn
	RjS4m6pktXNwxDZtg3KRxMXY2YUCskfCp1Ir9i/zTia/uKtmZT2WYO43s1skJtBlQxOpyhgAWcN
	54hUQ/6KM3MlkdrzMpNgHmDzrnPOsApEskUJKGsyqn5BYMNJNdlPk3qLAX7EoLtzEHvQw1tA9zg
	pzPc2ke3DV+EQoLHqcHka9xwNk9vW7vJbsS2Ep6pU/KJDP9HWGHhse7awW3DCzneUdpbKcGJIZP
	8XOYg46d0mylGuC6nA2Qb24uiOBzxsjDylDC0q2RorR9nqF69WHneg76BM3/vzA==
X-Received: by 2002:a05:6214:3d9c:b0:899:ea4f:12f6 with SMTP id
 6a1803df08f44-89c6b5596d6mr17924146d6.35.1773782514157; Tue, 17 Mar 2026
 14:21:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260317094653.2236624-1-werner@verivus.com> <02e11b2c-a472-46ac-95a4-ffe7013c3133@chenxiaosong.com>
In-Reply-To: <02e11b2c-a472-46ac-95a4-ffe7013c3133@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 17 Mar 2026 16:21:42 -0500
X-Gm-Features: AaiRm51choAslW-OVKrp4xPS0WIxnqiM6ooeRdSaYZeh61kr9v7kXx6SFV22Wzw
Message-ID: <CAH2r5mvCJW4tNhbDRMCuAZOfzrS2FKusiRY3ym-0dF4PfT8c=Q@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: fix memory leaks and NULL deref in smb2_lock()
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Werner Kasselman <werner@verivus.ai>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I see that Sashiko had AI review comments on the patch:

https://sashiko.dev/#/patchset/20260317094653.2236624-1-werner%40verivus.co=
m

On Tue, Mar 17, 2026 at 6:10=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Looks good. Feel free to add:
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> On 3/17/26 17:46, Werner Kasselman wrote:
> > smb2_lock() has three error handling issues after list_del() detaches
> > smb_lock from lock_list at no_check_cl:
> >
> > 1) If vfs_lock_file() returns an unexpected error in the non-UNLOCK
> >     path, goto out leaks smb_lock and its flock because the out:
> >     handler only iterates lock_list and rollback_list, neither of
> >     which contains the detached smb_lock.
> >
> > 2) If vfs_lock_file() returns -ENOENT in the UNLOCK path, goto out
> >     leaks smb_lock and flock for the same reason.  The error code
> >     returned to the dispatcher is also stale.
> >
> > 3) In the rollback path, smb_flock_init() can return NULL on
> >     allocation failure.  The result is dereferenced unconditionally,
> >     causing a kernel NULL pointer dereference.  Add a NULL check to
> >     prevent the crash and clean up the bookkeeping; the VFS lock
> >     itself cannot be rolled back without the allocation and will be
> >     released at file or connection teardown.
> >
> > Fix cases 1 and 2 by hoisting the locks_free_lock()/kfree() to before
> > the if(!rc) check in the UNLOCK branch so all exit paths share one
> > free site, and by freeing smb_lock and flock before goto out in the
> > non-UNLOCK branch.  Propagate the correct error code in both cases.
> > Fix case 3 by wrapping the VFS unlock in an if(rlock) guard and adding
> > a NULL check for locks_free_lock(rlock) in the shared cleanup.
> >
> > Found via call-graph analysis using sqry.
> >
> > Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> > Cc:stable@vger.kernel.org
> > Suggested-by: ChenXiaoSong<chenxiaosong@kylinos.cn>
> > Signed-off-by: Werner Kasselman<werner@verivus.com>
> > ---
> >   fs/smb/server/smb2pdu.c | 27 ++++++++++++++++++---------
> >   1 file changed, 18 insertions(+), 9 deletions(-)
>


--=20
Thanks,

Steve
