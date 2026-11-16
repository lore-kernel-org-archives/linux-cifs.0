Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867004;
	b=SpwIYRklqjnHemm0SlD1WDfV/aSKvDm6SNpmvK4m2LoNlXSJoU/9xpS8DCnsVL83DhTm
	 j23gp53/Y3cT9t9KbFmLo3ief/WOa4mcCAn+NevuyQ1KDmCkhI4Xl0GI01s0C4Daq9wdT
	 xVZMCNvkZ864raMxi9+c+FEIF8b0mdEc46ABIiW+FtgSC7SpxXMLXX348Nurg5gPZKfrh
	 TmxUwhHcFxe8zOmXyXW67MPDG/3m/IJ4SLZhHTHGwBetyWs60409wff6Rs2sNvXRZXAqm
	 lf0i2X7THJGuNw7t9du+ngyu/hcDCIiyMw6ZPYktysDpGlg7zWjolTSg4EqlP76ngbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867004;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=8iYZBjVlYYxNkxBaWuErj357L087f22pPkodgyOQoVs=;
	b=rcw9w3E1aWMzwMVdoFfe/zcsJE1pK9LV6B8C/p36b+2xymEt2eNs6HFwkxszPCvqrr/J
	 na0wyJ1DywwN9GnsOExeg0dGCAEtrFf0j8G4S9pEU/rbE9w9PeI0c/kJ7vS0Bu2/T68Pn
	 Jy23t1JCiQRjZYqhTQIdizqTybGyMLuFGtbMdpbpOfk7CMzPx75ymPGZYcNBTsh+zJtr8
	 si49IpR7mT0CcqYrjfDX3IQNcKVyq2Pip2DVRKJ3spGapmByoeVxdqRb+oBMH2MA3VDA5
	 sek9yctnw4Dtbs3++F4D9HzDE83uwwAB46A7JMTX0HAhTtuYOEQp3me1nYWt98zC+WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mEFQsmDu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818DA606A32C
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 22:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mEFQsmDu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CE71F000C5
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 22:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794867004;
	bh=8iYZBjVlYYxNkxBaWuErj357L087f22pPkodgyOQoVs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mEFQsmDutZy1N/obcPtHewp3laoQcb5AY8Te27ZC+vLDcPv9oW2VST8KsXciFipcS
	 ZmnHf7+rPTgkEUl2RrA13AKeO324rCAdISNqi+NMtY5ViY1DiSa5/8TXWfAsxhNHSW
	 DYflbvIrElUcBpaABN3w09nlFF7H3+OQRF9ry0z1Wsz5f7OSJtaCtyowqsSHroVyk8
	 KokVgOrSiE0uNi4HyRvMIpjK8kbsFnSvBCYRTpdb4PZHA5O/z6tFuhl66gwJcneOTM
	 teKKXBFaqdnhQnQCZgokE9RtRSgSxWj2e8ZZuwFaPRiU2K8dfWcT9puQyOyWohWbWI
	 w7sCkZShDPQcg==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c50e26763a4so205007566b.1
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 14:10:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErF86P+aQdOa+VQgx7Jjjv2m6XANBuszSXgvi1Q/p06oNtdmqegbJyLWp8bL8n1tVGvuTfpIQRnWmsdE@vger.kernel.org
X-Gm-Message-State: APuU4Z+TSQ0utpAWNRuhtSMnSL2ZdJ/K8CVC+L5rOwkiXkhoR5QZjgEJ
	G+wUuDX+5Y7aBF6nH76FU+2Kxqy+1zHWBVWWxwHEzaY8h+9h3VnDikmy17TaUl6LuB7zIkeUYyN
	42oSyZWszwItC5nnu6i8qiGY+ADp/FtM=
X-Received: by 2002:a17:907:3f9f:b0:c2a:34fe:ea4d with SMTP id
 a640c23a62f3a-c509631c9c0mr1078878666b.25.1794867002842; Mon, 16 Nov 2026
 14:10:02 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116161945.348983-1-0xbeac@gmail.com>
In-Reply-To: <20261116161945.348983-1-0xbeac@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 17 Nov 2026 07:09:50 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_2A+LVONLQPG+SppZNc3MPg3V65fJ0Qcw3+TparHjUQg@mail.gmail.com>
X-Gm-Features: AclHuK_M0ohWgSQXOtSZh_EaDA0ukBzDr0Q-FBxFQDqMPeuApASjKf1eWiUERlE
Message-ID: <CAKYAXd_2A+LVONLQPG+SppZNc3MPg3V65fJ0Qcw3+TparHjUQg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: pin parent dentry in rename share check
To: Yuansheng Yang <0xbeac@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 1:19=E2=80=AFAM Yuansheng Yang <0xbeac@gmail.com> w=
rote:
>
> ksmbd_vfs_check_rename_share() passes old_path->dentry->d_parent to
> ksmbd_lookup_fd_inode() without taking a reference to the parent.
> Although the call in ksmbd_vfs_rename() runs with the parent directory
> locked, smb2_rename() also calls this helper before entering the VFS
> rename path, without that lock.
>
> A concurrent rename can move the child to another directory and drop
> the last reference to its old parent.  If that parent is then removed
> and freed, ksmbd_lookup_fd_inode() reads d_inode from a freed dentry.
> Holding a reference to the child does not keep its old parent alive
> across a rename.
>
> KASAN caught this on an x86_64 QEMU guest with a test-only 100 ms delay
> between sampling d_parent and calling ksmbd_lookup_fd_inode():
>
>   BUG: KASAN: slab-use-after-free in ksmbd_lookup_fd_inode+0x28c/0x2b0
>   Read of size 8 at addr ffff88810faa6f30 by task kworker/3:2/76
>   Workqueue: ksmbd-io handle_ksmbd_work
>   Call Trace:
>    ksmbd_lookup_fd_inode+0x28c/0x2b0
>    ksmbd_vfs_check_rename_share+0x8e/0x240
>    smb2_set_info+0x2b71/0x3bb0
>    handle_ksmbd_work+0xad4/0x2110
>
> The read is 48 bytes into a freed 192-byte dentry, at its d_inode
> member.  The stack reaches the unlocked smb2_rename() call, inlined
> into smb2_set_info(), rather than the check inside ksmbd_vfs_rename().
>
> Take a parent reference with dget_parent() and hold it until the
> lookup completes.  If the parent has no inode, skip the lookup and
> report no parent sharing conflict.  The returned ksmbd_file has its
> own reference, so the parent can be released before checking sharing.
>
> OpenAI Codex assisted with reviewing the archived fix and preparing
> the changelog and validation materials.
>
> Fixes: 7f8029591bed ("ksmbd: synchronize lease breaks before renaming fil=
es")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yuansheng Yang <0xbeac@gmail.com>
Applied it to #ksmbd-for-next.
Thanks!
