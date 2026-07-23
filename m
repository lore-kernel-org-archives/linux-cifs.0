Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DD11DFDA1
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 00:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784765960; cv=none; b=aidQXQBUVnCtSHM77edw0QIKU3njfiAMU5M7GA10w4i5xnUqoLfe/aeGQT4/wAGGyNJnhiwx4/sQPgSGAjtFLhBvnqzQIj4qRdFfAVJM7ujFdD+6Th8z6aq9VjTlZDb6xZ9Yh2zQRbqq7zgMwUhSb2tki9VUx00z6uTfasyRRHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784765960; c=relaxed/simple;
	bh=lRoYBN+TxZk9yePHwJjx1fAoXKkUQhu5fZuONLfLj+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hscQoGE/HiJx6EfELiMO3WxQmlBQxjwQASQyFKZTQ5BHywtL+Pdl1M1o7LfNcb7WeDtrBI8xtTHpOq4h8x7OvzDnmDwqFu3rZ+xg/x3sENNGXcNYVJudaWVTM25R0/JQ3VSCrpVXjXzemme6XY+bol6V32uYmD6rDNob63gcTPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g5SFbReQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5SFbReQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9471F00ACA
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 00:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784765959;
	bh=kEMjQns1Y83Joq2sQu0IMYlzpE9WIBdm+SjU5PdDmM4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=g5SFbReQ+3rExs/bG74xieJjUenKys3Ns10TzcmhVXTanLF3RhGtTrkesCxdGae8w
	 HtTZ99Bijv7j3sx+5+FfpJldhiKNWF+FwxD/JDCJoPHvRt7NkGa5gLjbyNdL8AW73Y
	 4pV3YZWvIm5TmhrOskyjfvYCXFJY27ShS7RQoAPEadVGJ2tSmzQuHeJqipJw298UbM
	 K/js31SWtm3XgD8UvK6fnXFX6r18IFv67+0Yz8MrQrYhf/d4Pnsc3fG5ZfxgdHhD7q
	 +qX6YwU6M+g29ayizyTuAoqeV3RV83bhsw9yvqrYXm9Yty6kIWT4WkXifr9w+46PgJ
	 wFN0hXq5MkvCw==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15d111ca99so11659866b.0
        for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 17:19:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqh321Bghl/V8So/KVMbP+OJyMu2dE4aZjk1tNQsth5PbLfaV1DasBKXAc312V2CQHg8ZhDbllfqI/y@vger.kernel.org
X-Gm-Message-State: AOJu0YwjahcUXAExZ0IzA59aP99hDihqJwBmbd6WC6YRJVZi3qROJzFO
	FwdyH/WBnqSUHGmECsrALgMiADWOyG6/4NWSvJjXZJxt3u9HfCFhP5KN4EFKfk8abNBOakoGbJ5
	QiXkHPinytLnOBvXwaBManuHMh9jGZY8=
X-Received: by 2002:a17:906:8f15:b0:c12:979c:5a5e with SMTP id
 a640c23a62f3a-c1c5062db06mr38895866b.0.1784765957650; Wed, 22 Jul 2026
 17:19:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722235908.3564560-1-xmei5@asu.edu>
In-Reply-To: <20260722235908.3564560-1-xmei5@asu.edu>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 23 Jul 2026 09:19:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_iJjEWhFQ7tJSDVaK66Lo8TOazAG+798ty5JUPj+bBDg@mail.gmail.com>
X-Gm-Features: AUfX_myFAFLG4QuyGHrwwIENN2-4jVmMrTDMwnGqrmWexjlti5-D8LE_ilQBANg
Message-ID: <CAKYAXd_iJjEWhFQ7tJSDVaK66Lo8TOazAG+798ty5JUPj+bBDg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: use copied ACE count when walking DACL in set_ntacl_dacl
To: "Xiang Mei (Microsoft)" <xmei5@asu.edu>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hyunchul Lee <hyc.lee@gmail.com>, Ronnie Sahlberg <lsahlber@redhat.com>, 
	AutonomousCodeSecurity@microsoft.com, tgopinath@linux.microsoft.com, 
	kys@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 8:59=E2=80=AFAM Xiang Mei (Microsoft) <xmei5@asu.ed=
u> wrote:
>
> set_ntacl_dacl() copies ACEs from the stored, attacker-controlled DACL
> into pndace but may copy fewer than nt_num_aces (it skips ACEs with a bad
> sid.num_subauth and breaks on size overflow). It still passes the raw
> nt_num_aces to set_posix_acl_entries_dacl(), whose dedup loop then walks
> that many ACEs and, past the last one actually copied, reads
> sub_auth[num_subauth - 1] from uninitialized buffer memory - an
> out-of-bounds read whose offset comes from that stale byte.
>
> Pass num_aces, the count actually copied, instead. For well-formed DACLs
> num_aces equals nt_num_aces, so behavior is unchanged.
>
>   UBSAN: array-index-out-of-bounds in fs/smb/server/smbacl.c:651:27
>   index -1 is out of range for type '__le32 [15]'
>   Workqueue: ksmbd-io handle_ksmbd_work
>   Call Trace:
>    __ubsan_handle_out_of_bounds (lib/ubsan.c:455)
>    set_posix_acl_entries_dacl (fs/smb/server/smbacl.c:651)
>    build_sec_desc (fs/smb/server/smbacl.c:776 fs/smb/server/smbacl.c:1078=
)
>    smb2_query_info (fs/smb/server/smb2pdu.c:6269 fs/smb/server/smb2pdu.c:=
6339)
>    handle_ksmbd_work (fs/smb/server/server.c:308)
>    process_one_work (kernel/workqueue.c:3322)
>    worker_thread (kernel/workqueue.c:3486)
>    kthread (kernel/kthread.c:436)
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Reported-by: AutonomousCodeSecurity@microsoft.com
> Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Thanks for the patch.
Could you please check whether this issue is still present in the
current ksmbd-for-next-next tree?
