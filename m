Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1767217BCA
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 00:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782432583; cv=none; b=mztJwrvj7fimzJk5F0yjxufWOkEIPxoOkpWN+29QR+RBnV+FBZZ5qUShYaRJarTZ1hePP+ZUNrkvi/W/QtDP8hdjNtzbx9GGUnDXW7P7TJsa3SM0Yxl9b53uljl31DJyld6a80hMNldiw7gUfKb33+wWBTIcSHjV8i80oWTXZ8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782432583; c=relaxed/simple;
	bh=vbTcIutlUDiUSBpFqKMEzvnF4Es/WUHYJfz58vtl1uc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CmKp+CFA4ApvQwAs4zgXY+ojzQ9hokRB3cM94Y+8sqfk5DDIg7H5uYosA9ThDpqR+QLVbNkqxBFqdMlTbBErnXclEZ9Fxltnrgp615Fa+K/QKM/amKaRlT5QY8hSaHG6v4um+Y2YNwx9ZbBF7tDd0cm8V4CtCYSfDo4S1/QmrHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JFlK8sKV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JFlK8sKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88B11F01558
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 00:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782432581;
	bh=+9kKf1u6lTZby8wElp1YVYdELToeLFnut3qtFkNP7mU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JFlK8sKVIDvbOGx3AFC/XB4PEPA/mHiDV2gMPL14W+x/QgxTGcq7rZDFsh07Ice7D
	 VsBD952PZ0eJjCfRDKHACz5XNX8Wof3qZc57IjREY7jH91mtRMfQK+vdjVmxBFGBNK
	 5BbeeScO1C5kcZrH0kAF4BnqVoobI/869kpoj8DJx5Qadz+T0RZWt9chGR383Zj5rJ
	 Yd95OIPxfMJGQRXeKbgLlYQXuVYY9dKIvQOzuWk29yrBONRPuTxUm2TcwgCJi24DME
	 8e+vKZD5ZZ0cWLZCzUu5PYkmDSkkI4AGJHw+Tb6WpC3cNT5SoItAIMV/nR6pT07N/m
	 HsvPgBHYXYRsQ==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-695f6438518so520769a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 17:09:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoIUl7LiWQriXCNzqKJESZaUMMZxTC+Imcopx8OMAc9NCAXgRLr/3r6ZvMlLPuXMKFOSkGWkBzcqbMZ@vger.kernel.org
X-Gm-Message-State: AOJu0YxuX8Vf+Fqfvl+x6ZdDCE27r9ttZmyuGeruTX18EY6GFpxQ0iM0
	8G2+t8QnbGaMG+MGXtveUlIk5lKq0MVCMUSqg8D/c+ZB9IRHVrIOBPHOYEq7OO3MXQAow19iQ9U
	kz/VqmEK4I5RYfcPAj48+OcEviVXJMuw=
X-Received: by 2002:a17:907:9443:b0:c0c:d278:cc31 with SMTP id
 a640c23a62f3a-c1205f56599mr319572066b.53.1782432580290; Thu, 25 Jun 2026
 17:09:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260625144021.513613-1-lihaofeng@kylinos.cn> <20260625144807.513701-2-lihaofeng@kylinos.cn>
In-Reply-To: <20260625144807.513701-2-lihaofeng@kylinos.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 26 Jun 2026 09:09:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9T7nNCCBYhQjerbu7a+_1E--hrK5YpGtysdG2_9GAUPg@mail.gmail.com>
X-Gm-Features: AVVi8CcpYg7B7nUgs2cjX5MHhqVSHwgXIoSX7ecTLXC7zJx9Gk6UAUMlk73DD-o
Message-ID: <CAKYAXd9T7nNCCBYhQjerbu7a+_1E--hrK5YpGtysdG2_9GAUPg@mail.gmail.com>
Subject: Re: [PATCH v2 resend 2/2] ksmbd: reject undersized DACLs before
 parsing ACEs
To: Haofeng Li <lihaofeng@kylinos.cn>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, chenxiaosong@chenxiaosong.com, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026 at 11:48=E2=80=AFPM Haofeng Li <lihaofeng@kylinos.cn> =
wrote:
>
> parse_dacl() limits the attacker-controlled ACE count by comparing it
> with the number of minimal ACEs that fit in the DACL size. The DACL size
> field is 16 bits, but the expression subtracts sizeof(struct smb_acl).
> Because sizeof() is unsigned, a DACL size smaller than the ACL header
> underflows to a large size_t.
>
> A malicious client can reach this with:
>
> SMB2_SET_INFO (InfoType=3DSMB2_O_INFO_SECURITY)
>   -> smb2_set_info_sec()
>   -> set_info_sec()
>   -> parse_sec_desc()
>   -> parse_dacl()
>      -> init_acl_state(..., 0xffff)
>      -> init_acl_state(..., 0xffff)
>      -> kmalloc_objs(..., 0xffff)
>
> Thus a malformed security descriptor can make num_aces pass the guard
> and drive large temporary ACL state and pointer-array allocations.
>
> Reject DACLs smaller than struct smb_acl before doing the subtraction,
> so the ACE count check cannot be bypassed by the underflow.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next-next.
Thanks!
