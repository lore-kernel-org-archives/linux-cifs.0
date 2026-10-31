Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793412586;
	b=dRcocSfg8w33/bnSXEKO7q5mJEGLJoguU6wvHlRWJdbYx0CEIok9IYhOijEhpXcqmjbX
	 PDHrv+4/aWl+v2nGCaJE2urp7Qjj6Uy0MMGE759zvfz8u1sjUiy41T2NEwBCTAgfm3jXS
	 Nr1ZyJfBHk4ZI1qXyRzycpzhUsHR1NNf6Mf6P+dowyuyji5oGyiVYppUwspwgXI/p6jMJ
	 b2kFejyPILffunKWewsSz2Woc5fNVgoRUSFYAOzb+oQ4KjgJ/9/OSgwpNm2oCNBojXltT
	 xJv3WP8zyy0aCB98iL9zugELXcE/3xmeky2YbUVvc8wNKWadNVqJ1f/qdvYEnt0ndIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793412586;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=0fhsmLg+/R1e6vDeTMj0qehUFlPHkkHCiukF5Cl8254=;
	b=3XrFIOp3UQbm4uut3YT/OhIoZbQ1nNcJqsBKZtBRJsx9dhwoSc3rwWPSUItMCm6nBHXq
	 M+HvnRgz5+vnQZbwW03y39if8+IHQfzQtqW/tZmSVf7LccGMlth1BVbHNocfxDAMARyQR
	 tpecPnndR9vvWEa1YdxABjqrpLz9mLKUF0yQ+TdpoQVo23hokfhe7JK5HtV7/EjOFA5Fd
	 CURqad7bQXqGe6dxUDuw3S9VeZoK964WWg8uR2fQrJ8WvR4UGqk+A09l71sScQjjhP9nx
	 y2hNGgTRQteTdZ0k6XyoKVChVB9YrgXjsYnHLAHOf3+GuhLZmXlPPGC1wt9srBDYEog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cYco0U6J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2A460A2610
	for <linux-cifs@vger.kernel.org>; Sat, 31 Oct 2026 02:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cYco0U6J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B441F00A1C
	for <linux-cifs@vger.kernel.org>; Sat, 31 Oct 2026 02:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793412585;
	bh=0fhsmLg+/R1e6vDeTMj0qehUFlPHkkHCiukF5Cl8254=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cYco0U6JNhpJm+j9Lu5Q4JNTMLOWJ3wC1e8HjKQGkesV0ebvSZNBMWRFDrDMlu0Zj
	 m04xvzXwuCOJ5lvuXrYAuM9wUXa5xCDk8hLp70X9b900qcUxxEFNb0tzwdSQAHgRLn
	 hiIvkRx/C1E3mnANygmh1Y1k/SeDPqNN+yxCvqfb2ZzMJc01SIqOGOoURQu5IxNTy4
	 DyjWyeXoqgP26JLbsYaLzuZWqGKkndb/c9Zw0B9yg5Qz9r3ml8bSC3ZYlCd6XzrVvJ
	 +UJ1OQX3z1Gk2JPKsxHmywOGVMUU0ycOkvd20CLUEY14HL4s+/0bdCpMzRlm+zdrof
	 P1gMS7+UijRgQ==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso2470246a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 30 Oct 2026 19:09:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByudZQVJ5V2wOJi4JahqIsRDyQJ5tiuoA3iY4eaaxWWLEdHK8/uZ4/RtNrZ+OXCMjXDn1sqQP2H6BGu@vger.kernel.org
X-Gm-Message-State: AFq9FYI9ThEnxBQo1f36sailVml3ph806RAGn7mBfxngz8Yf+NY9/wtr
	7dHs9vhYeXm3MRnkopV9u1xQZyzlgGHLFEVPMWOgQtxaA1IqWVetOzDmvl544ZQrS/IoZ7z0Vh4
	3diBiQ0oeOVltP83N9dvyWST3p4CYKNI=
X-Received: by 2002:a17:907:96ac:b0:c49:b8ec:a9e3 with SMTP id
 a640c23a62f3a-c4ca7abe67amr377807566b.43.1793412583658; Fri, 30 Oct 2026
 19:09:43 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030020523.302085-1-icb@fastmail.org> <20261030020523.302085-3-icb@fastmail.org>
In-Reply-To: <20261030020523.302085-3-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 31 Oct 2026 11:09:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd93czbFD=znZUq_pJLXzDR5N3zc_auvAGWT7pzKR1f9Ag@mail.gmail.com>
X-Gm-Features: AclHuK_pJofjvX5FQy3V3RmY683i0MSmA_O1khwZaSiRXh7FWc04LdLmaOE3Bgs
Message-ID: <CAKYAXd93czbFD=znZUq_pJLXzDR5N3zc_auvAGWT7pzKR1f9Ag@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: exclude guest and anonymous sessions from
 Authenticated Users ACEs
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -1611,7 +1612,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
>                         break;
>                 }
>                 if (!compare_sids(&sid_everyone, &ace->sid) ||
> -                   !compare_sids(&sid_authusers, &ace->sid))
> +                   (authenticated &&
> +                    !compare_sids(&sid_authusers, &ace->sid)))
>                         others_ace = ace;
Skipping this ACE for a guest can leave both found and others_ace
unset. The POSIX ACL fallback then runs. That code compares ACL_GROUP
gids with the caller's uid instead of checking group membership. For
example, consider a guest with uid 1000 who does not belong to group
1000. The file's DACL contains:

  DENY    Authenticated Users   READ_DATA
  ALLOW  S-1-22-2-1000            read access
  ALLOW  owner                         full access

With S-1-22-2-1000 also set as the descriptor's Group SID, DACL
conversion creates a POSIX group:1000:r-- entry. Before this patch,
ABE hides the file. After this patch, the fallback mistakes group 1000
for user 1000 and lists the file, although the guest still fails the
POSIX read permission check. Please also fix the fallback to check
actual group membership for ACL_GROUP entries. The UID/GID comparison
bug already exists, but this change exposes it for the DACL above.
