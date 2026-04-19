Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AD73783D4
	for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 07:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776583792; cv=none; b=Bg8rsXjN8n3GCao5yIMLctaYbuhrzEvAn74SFR35rdRUGg4t86eAmQFBFFI/6wzrf38+64QCIp7V8BJrapIdPkmXTs+l1rSNUkKeZH9RW597KUCt99Vp1ze4KfO64siRrw5LxauqgmudP7xP+Zxly/cz4X1dTuqOAhSJ/O82F00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776583792; c=relaxed/simple;
	bh=QJqUE+KIWv01jPr0qaOhAYIMdk3vkM2VjM9uMykgIa8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pd7lFPI+57RYo2KQS9DuOfXV3PUFR01MbAf+0+7A9hbehBmJdzeTLkB2w8Y7Cv0Dh4IMrmLKZFoVQ3av+WWKgXuJVxaNKyuiujg2Hp53cTfdlHAJAWq2Mn/nmNM0Tzv0sZSi+MRxQFv9UFNWfJy5hG8r2hD1riwIpLrvqo0dh5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlkF91Sc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlkF91Sc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40F0C2BCB8
	for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 07:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776583791;
	bh=QJqUE+KIWv01jPr0qaOhAYIMdk3vkM2VjM9uMykgIa8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nlkF91ScFrhpJeWmo1aO+q9hRzmgOcNKxtcqnRMBVcf9SjhY9uEGOy0rXV/+addoR
	 39Zn9iZBa0yim4uCArlyeqAtJIoKPYE0b5MWFHpVrf68eDBztMYO7Jf7/ZMjFQSTF1
	 FUfB1Zr+NGRCkq54I/unG5GC2ACKao4OFLTVSOgzLtmrIlbo6OLhjPRPd14N7HNdnf
	 Eag/SWD1qUrqi7ck1AzlIhiwxMv75FB/zbo/gCucQBggWMxQ7njYlD2nCsUo4K9Mfy
	 7AXCir9HquZyqrmaUaXwSQtC17FO3Q6qAZkkLG64i4klgiPyIEkM/ibh3YSztGNyEB
	 9mt7dEfYqFcCg==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-672c23aa064so3718008a12.2
        for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 00:29:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+HjQvwtaFKtposhuVLDw0iqvrDIeqavHR4uUw3WvAM3kQ4zi4JtYlh46pY9mmDYJU6lAIK9WOp1cYp@vger.kernel.org
X-Gm-Message-State: AOJu0YwcA00cBRHgZpqnjq2IEVAsbyC75qJY9FWdPMLShIHQLF9t/GRk
	gPEiQ7KnqIUKzqzEu1z0GznWXcEI39lCFCDRnwOyGMj/819x47o6ftDjr/Xa60WyqeW7iMJDVNK
	UU+uVaAr9DEqfjD9QololMxvCPTTRCcg=
X-Received: by 2002:a05:6402:a54e:10b0:669:cc03:334a with SMTP id
 4fb4d7f45d1cf-672bfd9db0dmr3075102a12.11.1776583790183; Sun, 19 Apr 2026
 00:29:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260418172844.1333378-1-charsyam@gmail.com> <20260418172844.1333378-3-charsyam@gmail.com>
In-Reply-To: <20260418172844.1333378-3-charsyam@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 19 Apr 2026 16:29:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_0-qXXktu0EBmLWATqthSXetVvQ2EzpgBnsOkq1bU=wQ@mail.gmail.com>
X-Gm-Features: AQROBzAOKLjcpFyO0NiqvNftv3mmS9SxvjLG3WX0f-Iq4zWubKruu_tv2He3XbY
Message-ID: <CAKYAXd_0-qXXktu0EBmLWATqthSXetVvQ2EzpgBnsOkq1bU=wQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: reset rcount per connection in ksmbd_conn_wait_idle_sess_id()
To: DaeMyung Kang <charsyam@gmail.com>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Henrique Carvalho <henrique.carvalho@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2026 at 2:30=E2=80=AFAM DaeMyung Kang <charsyam@gmail.com> =
wrote:
>
> rcount is intended to be connection-specific: 2 for curr_conn, 1 for
> every other connection sharing the same session.  However, it is
> initialised only once before the hash iteration and is never reset.
> After the loop visits curr_conn, later sibling connections are also
> checked against rcount =3D=3D 2, so a sibling with req_running =3D=3D 1 i=
s
> incorrectly treated as idle.  This makes the outcome depend on the
> hash iteration order: whether a given sibling is checked against the
> loose (< 2) or the strict (< 1) threshold is decided by whether it
> happens to be visited before or after curr_conn.
>
> The function's contract is "wait until every connection sharing this
> session is idle" so that destroy_previous_session() can safely tear
> the session down.  The latched rcount violates that contract and
> reopens the teardown race window the wait logic was meant to close:
> destroy_previous_session() may proceed before sibling channels have
> actually quiesced, overlapping session teardown with in-flight work
> on those connections.
>
> Recompute rcount inside the loop so each connection is compared
> against its own threshold regardless of iteration order.
>
> This is a code-inspection fix for an iteration-order-dependent logic
> error; a targeted reproducer would require SMB3 multichannel with
> in-flight work on a sibling channel landing after curr_conn in hash
> order, which is not something that can be triggered reliably.
>
> Fixes: 76e98a158b20 ("ksmbd: fix race condition between destroy_previous_=
session() and smb2 operations()")
> Cc: stable@vger.kernel.org
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
