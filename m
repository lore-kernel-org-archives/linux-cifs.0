Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794104211;
	b=iG6QsBy2RizjHq1Bnwn8twRqK9xoo34JYhpvtf9nLeJGfrbhcUIgJ1WtSmNmOx7DLroB
	 7QD+QjHWXSBHyRFu708CPWvZRND4Lzu8gafk6SNTBwp+MzlelLV7w+nwWtwSw4ahvjUbP
	 ibqZYbZkyYOl36QOeQEwTQ6y6qOt7uLGQ38nvv1Dzx3ZjPYtpzFN9GVlN1TCWJCT54o6k
	 S/nq8r9UHjQKSVJ5oqgKMhs3DJJMeq2c2QykLO2GC4gJJ6EO4pbjUT8wzb6w/gtoSJuyj
	 JtvyTL2gb6QFyMVRRC9McwCuR13rUlIOtKnzCzWXvrcbeWrjI4+jM+tFjsl9tPdeMbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794104211;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=rhaNAYOBGQbAJRxA/86LGQPp9w1ZXItaLYNXRKOAJ+0=;
	b=xVD0dLuKx9xNbS0LjUNASr6xkLM20/wZgQA35SNde0Judd18m0nicV3r0YioiQNJFboI
	 J1aGyNuR3VumITioHN1sGQzo4FSo9osfDuPqsXOeFX7hrBqD+tjC6ZArQTCkTHfWnTGkG
	 pk7UK/tAOsOEsmAYGClQAx8LoroTT5W+gNZTPFcb8ZFlYk6VLhA74MzWyxhf2ifyUDE6v
	 OfeCw0QucpwcMsli/E3gphfXr68pjPGCiCVH9zcBmRe0E/p6ZfscfoZtpjZ/9uxuMP5XX
	 gL0W8+JybNTSHZaR1yU32z9B+x+MXHxES97SOpgCTMAkaXkpUI2a6VKuozpkEEY+ugg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JPZBwQn5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D31C606A31C
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 02:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JPZBwQn5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81F31F008A6
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 02:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794104210;
	bh=rhaNAYOBGQbAJRxA/86LGQPp9w1ZXItaLYNXRKOAJ+0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JPZBwQn5OcX5oFVQPgyAPLyVxbtqjTdwXPBbqr59GJ+EGHmMMcyOc3wYkIplUlShs
	 U/zXJ+b7aMhCTzW/elSfIhwcFZ1lCGiyFLq+XCS6k+OwPeXzu5tgsQ+3e3M7REVEu7
	 tlQtQlYWzQwfjxhjmQXn68y5OKe6VnxkKZSZwS9j4xKDsUIRo+w7c195jn/bV/NIlJ
	 XPbOEXWWppZtgc94J/5zA8UeEH6go7PKc/kJo81exelZhH4PoAiA28DdP3ovrxGmZl
	 FocEBvQV7NAMCGiVX0Y+annnOKN6r4odq3oYSyCxLrbdttbm7Z9tPBFAHUdMneg6T1
	 +FuIyqF60OZyg==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4ceaee6770so13783366b.0
        for <linux-cifs@vger.kernel.org>; Sat, 07 Nov 2026 18:16:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwWF2/PLJuBqvU+EOqWdlpsrbWk4rw35LBTcZbfBp+a0kNpele7ZvBEyf3B6b9T7UTbXIn+Cs0p54mS@vger.kernel.org
X-Gm-Message-State: APuU4Z+Q6vQK6Ci7jOKNfGikaVaylkIQPpEoIn1G+wy5UZ+jQrqTVkHC
	Yg2Ue3opdyVKG862GiYEyr4/x9Y8hL4+2u9TGHcivP2YvIBGZGlSSkGaGtxMjNuheSkrDG4eC1/
	4UkYGfg48zl8arlk1lcbkiRfVDZP9B/M=
X-Received: by 2002:a17:907:84a:b0:c33:9fab:5f61 with SMTP id
 a640c23a62f3a-c4d6db7fe58mr44458366b.29.1794104209459; Sat, 07 Nov 2026
 18:16:49 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261107020257.363811-1-fredric.cover.lkernel@gmail.com>
In-Reply-To: <20261107020257.363811-1-fredric.cover.lkernel@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 8 Nov 2026 11:16:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_yf2eU7fJLaE5JR6ddO=EXsDOMBC0xyByuSJ4imPJvow@mail.gmail.com>
X-Gm-Features: AclHuK_rAD0_X9-1rzYyea-9ppXgdhtoO7-wF5lKZILAvB31CXfCLyGzIrTDMfs
Message-ID: <CAKYAXd_yf2eU7fJLaE5JR6ddO=EXsDOMBC0xyByuSJ4imPJvow@mail.gmail.com>
Subject: Re: [PATCH 0/2] smb: client: fix DFS handling of non-ASCII paths with
 non-utf8 charset
To: Fredric Cover <fredric.cover.lkernel@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 11:03=E2=80=AFAM Fredric Cover
<fredric.cover.lkernel@gmail.com> wrote:
>
> Hi Paulo,
>
> This series fixes two problems that show up when a DFS mount uses a
> non-utf8 charset (iocharset=3Diso8859-1, or a kernel built with a
> non-utf8 CONFIG_NLS_DEFAULT) and the DFS path has non-ASCII
> characters.
>
> Patch 1 fixes an out-of-bounds read in dfs_parse_target_referral().
> path_consumed is a utf8 byte count (the DFS cache works in utf8), but
> it is applied to full_path, which is in the mount charset.  When the
> count exceeds strlen(full_path), the unsigned subtraction wraps and
> prepath points past the terminating NUL.
>
> Patch 2 fixes a double conversion in setup_dfs_ref().  The path is
> converted to utf8, then converted again by dfs_cache_find(), so
> "=C3=A9" is sent to the server as c3 83 c2 a9 and the second-level
> referral fails with -ENOENT.
>
> Order matters.  Patch 2 lets these mounts get past the second-level
> referral, which makes the over-read from patch 1 reachable.  Applied
> in the other order, patch 2 would turn a clean -ENOENT into an
> out-of-bounds read (a KASAN report on KASAN kernels).
>
> Testing: Samba 4.23 DFS root with a link named "caf=C3=A9", client on a
> KASAN kernel, with iocharset=3Diso8859-1 and the raw 0xe9 byte in the
> mount path.
>   - On an unmodified tree the mount fails with -ENOENT.
>   - With only the setup_dfs_ref() change applied: KASAN
>     slab-out-of-bounds read in dfs_parse_target_referral()
>     (strlen(full_path)=3D29, path_consumed=3D30).
>   - With both patches: the mount succeeds, no KASAN report.
>   - Regression run: iocharset=3Dutf8 with "caf=C3=A9" mounts as before.
>
> Known limitation, not addressed here: when a non-ASCII link is
> followed by a path component (e.g. //srv/dfs/caf=C3=A9/sub), path_consume=
d
> is still in utf8 bytes while full_path is in the mount charset, so the
> prefix path is offset incorrectly.  I saw this as -ENOENT.  Patch 1
> only prevents the out-of-bounds access.  Fixing it needs the
> consumed length converted to mount-charset units, which changes the
> dfs_parse_target_referral() interface, so I haven't attempted it.
> Paulo, how would you like that handled?
>
> I haven't added Fixes tags.  The strlen() - path_consumed arithmetic
> was moved by commit abdb1742a312 ("cifs: get rid of mount options
> string parsing") and appears to date back further, and the double
> conversion in setup_dfs_ref() also predates 5433c629e8d4, which only
> moved the call. I couldn't pin down where either became reachable, so
> I'd appreciate it if you could add the right tags. I haven't added
> stable tags either; let me know if you'd like them.
>
> Fredric Cover (2):
>   smb: client: fix out-of-bounds read in dfs_parse_target_referral()
>   smb: client: fix double conversion of DFS path in setup_dfs_ref()
Looks good to me:
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks.
