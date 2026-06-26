Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A972376BEF
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 15:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782488233; cv=none; b=nwIA+iKwZgEDP8XKAP+NU4T0NLyH+ac+zMKlCREaWXVP7x1ShxwIEWVmshkr43X4u8yIUskdhySX4nrH+JGyyx7Yg+HXxMhsMVgKSV2ABg2MBa42CfeO37E+H4v4IsPOVmhVakDLiS/Mal5df/InKyKCMSPxDLqomyhStRcWnxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782488233; c=relaxed/simple;
	bh=OWe9BPh1RLAPYQds2FyA0Mx1nhYQMdUVA3mgKUu5jt8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=unMe3b829ntAG2S0773cCr6+CAhECvYaJENF0kFk3KgY+xXM8rhtdLG4SNjRf+OfEnvlVkTsEXeXhi7ULr7943O64b5o10ZV5+ijeNX3UCarFWazfvxthi5tYuUGoEHKU1ERvqP9SoqP3/06D+sEEaiLqD/gyBuJJ1D64sce38A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E7JNi10s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E7JNi10s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF431F00A3A
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 15:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782488231;
	bh=OWe9BPh1RLAPYQds2FyA0Mx1nhYQMdUVA3mgKUu5jt8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=E7JNi10ssZNTbLTicHBsdCgoT8C038gzQSa1D2vmSglxt3/v6sDHwtAK4SuiEj3PW
	 ExQhiUmhiXM/yXWpEb2H3OSfhQKpCDm2Jq2UJ2fpeRocWb4hPgRZ76E2FtTcESGg2T
	 53eEVxbDJRj0qryC2LxS3e0OvwLf2NjOUT402q4mBOhuf8Guisi6roT3HQFJ/myADw
	 ygMYdjIz6JUxAOSXbk9odW0Rq9PfSOgermv0P894nEvcR6I62MjExF+XhcG2YKoCCh
	 ejc3yRR93hHehhe2wwer60QDuxOy04SDNhxsRLWEILn08Fpol4niaXOr5JMMSg+iXi
	 4iC5SJ5ZB+9kw==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c1214dc027cso115082766b.1
        for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 08:37:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp+2o2qyhRCOnAq/IqC6bVqPIeKJGa3bSdEyq+LKz1c0e9Ssgbc3EpMAMsf4LnTsdZ3O0od36OrYhmG@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6oXRClegG7OwKO1jbM2DC5oJLq8vIGCi8TDr2BoBBeP0m0QcI
	85j1k3IGyubjYV7isr1DHbX/QB2MeQ2uCuyvzo7D0b82AHozp3AZX8FqzysyE5VsxCg0XBFHx/H
	sRf9nQPK8x21RKKbYt/xdwQ31vw9Q+8w=
X-Received: by 2002:a17:907:6d10:b0:c11:fa95:43de with SMTP id
 a640c23a62f3a-c1206175cfemr458957566b.46.1782488229793; Fri, 26 Jun 2026
 08:37:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260626040422.1631299-1-runyu.xiao@seu.edu.cn>
In-Reply-To: <20260626040422.1631299-1-runyu.xiao@seu.edu.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 27 Jun 2026 00:36:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-s1WerGPxaf2bYLUsvh_OMNrEtvruC5YBgtHJjGSu9Sg@mail.gmail.com>
X-Gm-Features: AVVi8Cdtwmsv-RBedn_ye9JeTRJ7s0EjRImSxnQmZ1H0BDczzXkJKit3YKv6hEs
Message-ID: <CAKYAXd-s1WerGPxaf2bYLUsvh_OMNrEtvruC5YBgtHJjGSu9Sg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: annotate oplock list traversals under m_lock
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jianhao.xu@seu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 26, 2026 at 1:04=E2=80=AFPM Runyu Xiao <runyu.xiao@seu.edu.cn> =
wrote:
>
> session_fd_check() and ksmbd_reopen_durable_fd() walk ci->m_op_list with
> list_for_each_entry_rcu() while holding ci->m_lock for write. That is
> the local inode/oplock serializer, but the RCU-list iterator does not
> currently tell lockdep about it.
>
> Pass lockdep_is_held(&ci->m_lock) to these iterators so
> CONFIG_PROVE_RCU_LIST can see the rwsem protection already in place.
>
> This was found by our static analysis tool and then manually reviewed
> against the current tree. The dynamic triage evidence is a
> target-matched CONFIG_PROVE_RCU_LIST warning; the change is limited
> to documenting the existing protection contract.
>
> This is a lockdep annotation cleanup. It does not change oplock list
> lifetime or durable-handle behavior.
>
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Applied it to #ksmbd-for-next-next.
Thanks!
