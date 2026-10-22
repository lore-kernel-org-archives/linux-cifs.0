Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792712789;
	b=SAY17fuQF7MX38chzgc53csaeqthgGM0+0Z2lgfTckGLPXEL7vMK50bFN6ciPwRZAe2/
	 b2lGia2zykNoNiRJM25PluPghtnwesBvN9PfB7BpvmN13W5gLSrx+q0lIpvu0iad3IFVQ
	 gLJVWv4lMuml4nHFkYrNebfeUMS04C4xmWX+n6NBmHjKUTFGdc+qM+8GYi8H63hdrVdSe
	 p74cAooS99ScH6qzHABA8bEYLDdaHdh7OiTFFChZB173LCDZLqiQcnsmEhpeZYAsm5WMx
	 Gfsk1NGkZPyMDIATfOD8ZaZYe9ZanNHYEErjnd3+afZHJ0kXZFxU9ujP/eF9Q0njlnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792712789;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=fi4Wn+lh1Z/zpvInQk71rHUv00wJPQShP80oT8WfkFc=;
	b=5mV4c3n6/MKPr/Y6NaELcYRvkFPVw5YH6njJX66V6EpmbkfWaibo7m3Olbf/WieQKPkJ
	 MjNdb667pybQahyginGwDj13MBDOt/TPXqJva/ZUD4F/E4bq/oeoOzHD+V21t8yMxAB+A
	 Gl3sjij0RA+Us9cXl94M+/f9CBRnUIWWxH1RhKpPQDFQt72qiiIvwBj33zpTWNGuzeCq7
	 6FllARxyWyzzB9LdWws2Lt53ORWmBSBJD3ylFZ5twlKnTbhvhHriYsd3AB/pMu5vF5n7U
	 rlZrfqTWAx/qOD8GlaLJ7BjDzf8dv4+U2uc5Q9yjryr+gilNh/QJ6YANkKVasb0+4mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TKVEd+Un;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BFE606A319
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 23:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TKVEd+Un
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F1A1F031E2
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 23:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792712789;
	bh=fi4Wn+lh1Z/zpvInQk71rHUv00wJPQShP80oT8WfkFc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TKVEd+UndD438MIOUAjwBqyuR8mYz7+RLGZ7ygAaY/4FUMdjnIUfQenwO3XDqRGSu
	 FAd6PeGLQZRzqTVxZ9ptmBWiX6mZpgtBffWDr080VBU1t1cSVN/itZnT9zFYiNFzr8
	 4qQR1UZIIwxFVA6ckYci6rOVhV04/joFykfAqtQL4D5V15dJWBVcPX+2ZW7sHtym4D
	 HvF6csEwwq51usBjazqfWR9piIdwqv5iieyionnaX5b1THVwrReWrB0LN0p1+06eVg
	 KRPKycHYrat+2bOECzKYYH55FrZ6ex7FDKikxQVb126mcHHiwYtbSzM8drkKq5Og8I
	 AxAXnJF459PVg==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c468bd799ecso45057766b.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 16:46:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw+4O2lpjtMhXw/C6ePR6fRs4e1gUH68qVGq+RhfY/bGp7eLaaqJnGQdChqAhq0NhM0yVqdlz1Q+hjW@vger.kernel.org
X-Gm-Message-State: AFq9FYKdCT3MylgVFey8hXF6lW555Ao0JxFsfzZY78e0zPgSJsoj6gDj
	tT+tEUhMwF6z0IQzXa+VB8O8E8RMx+YmXUaNdIdu44ZEkYZVunXsDG53f7xJGp17iDw44e8vbN4
	eVBOjx7JLZ3z1Zg8k8/zxRBKaM1lKAJ4=
X-Received: by 2002:a17:907:9446:b0:c29:4fcb:2886 with SMTP id
 a640c23a62f3a-c46a948d935mr87657766b.39.1792712787878; Thu, 22 Oct 2026
 16:46:27 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261022173832.14696-1-d3bugee@gmail.com>
In-Reply-To: <20261022173832.14696-1-d3bugee@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 23 Oct 2026 08:46:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_BRG+M96UurdeeeUaWmhkQSnXupk5JWRmKAf5g26kaZw@mail.gmail.com>
X-Gm-Features: AclHuK9yKdvGpizgGXSa7ZGgAUoWzc6AaCk5JarpvFhKat0FEK8DS9LWvWooc7Y
Message-ID: <CAKYAXd_BRG+M96UurdeeeUaWmhkQSnXupk5JWRmKAf5g26kaZw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: serialize directory emptiness checks with readdir
To: Yongjun Gwon <d3bugee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 2:39=E2=80=AFAM Yongjun Gwon <d3bugee@gmail.com> wr=
ote:
>
> SMB2 QUERY_DIRECTORY holds fp->readdir_lock while it calls iterate_dir()
> on fp->filp. An SMB2 SET_INFO request with FILE_DISPOSITION_INFORMATION
> can resolve the same FileId and call ksmbd_vfs_empty_dir() on the same
> filp without that lock.
>
> iterate_dir()'s inode read lock permits concurrent readers and does not
> serialize per-file iterator state. ext4 stores its dx readdir cursor and
> fname RB tree in file->private_data. Concurrent reset or refill can
> therefore free a fname node while the other worker still traverses it or
> retains its RB-tree link, resulting in use-after-free accesses.
>
> An authenticated SMB client with list and delete rights on a directory in
> a writable KSMBD share backed by ext4 can trigger this when the directory
> takes the dx readdir path. The client overlaps an SMB2 QUERY_DIRECTORY
> request with an SMB2 SET_INFO request carrying FILE_DISPOSITION_INFORMATI=
ON
> on one live FileId.
>
> In one x86_64 SMP KASAN multi-shot guest using ksmbd-for-next at
> 171df27077fb, the unmodified kernel reported a cross-worker use-after-fre=
e
> before a panic. The first report's access and free stacks show the two
> request paths directly (trimmed):
>
>   BUG: KASAN: slab-use-after-free in ext4_htree_store_dirent+0x488/0x550
>   Read of size 8 by task kworker/2:0/29
>   Workqueue: ksmbd-io handle_ksmbd_work
>   Call Trace:
>    ext4_htree_store_dirent+0x488/0x550
>    htree_dirblock_to_tree+0x535/0x990
>    ext4_htree_fill_tree+0x319/0xba0
>    ext4_readdir+0x175a/0x2f40
>    iterate_dir+0x1b6/0x630
>    smb2_query_dir+0x1003/0x1cc0
>
>   Freed by task 279:
>    free_rb_tree_fname+0x67/0xc0
>    ext4_readdir+0x13a9/0x2f40
>    iterate_dir+0x1b6/0x630
>    ksmbd_vfs_empty_dir+0xa2/0x100
>    smb2_set_info+0x2ffa/0x45d0
>
> Take fp->readdir_lock across the entire emptiness check. This places both
> iterators over that handle's filp in the same lock domain while
> preserving the disposition status handling. The exact code change
> completed a warning-free x86_64 KASAN bzImage build. Tracing three reques=
t
> pairs showed that the two iterate_dir() calls no longer overlapped and th=
e
> expected statuses were preserved. A further 1,600 reproducer iterations
> completed with expected statuses and no KASAN report, Oops, or panic.
>
> The reproducer and complete guest configuration are available privately
> to maintainers on request.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Yongjun Gwon <d3bugee@gmail.com>
Applied it to #ksmbd-for-next.
Thanks!
