Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082C62C181
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 01:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762996782; cv=none; b=V9uiV9Rn5rs1ig/SlsejHI1rB0rc8OtW+fG4tSI3O1umwEiTPrmi9eRAj6OqTR5QZWlWxUt9xqtiIaxagbO/GEilMQ8CP6tUdlX0fiajuF+wSPz4rp7G0yfN75zsrG5yNPhqiOdTrH6YWRj/xhvyXy9Vd9txqfgrxt2Sm5ihGuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762996782; c=relaxed/simple;
	bh=7FPSBOEc5+aqrhL8867Hnsv8NNqxIjSIlUp41kin0sg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e6bBEp+1mbQgVhhVBWR5TYt9F1P7BP2qwN8Bu/9yq1YGUYKj1sCx/tNko+UseutzROkzE9a0UOcQOYpjSaV33TEEqtpNk0vznBExPhMWHQ5cKJoxMnkxbIi7ILcVn/Eu5fd8Vh2+1fCsRZSAVBJQm8xh8nwZVeDD6e8BwRBhsug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DRgMF60a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DRgMF60a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6FEC19424
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 01:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762996781;
	bh=7FPSBOEc5+aqrhL8867Hnsv8NNqxIjSIlUp41kin0sg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DRgMF60aFWMIE+glOLy6tGuEEI6CaI1q9H41bugnc35xJ72H79jQfF8aE2FT1AKph
	 joLJz9FjWSm3Yf4JpCHVvii/XsKRArnQ+I6wdMmDN0CVSFLIZO7O33DIQija7exv/K
	 uF/cm6FYS/qZtoAT0CMrc0zHaEM9aRO8nTA3PAzTZepHfpNwzIHrzlki4EVxE/qp5h
	 V6XJk5MQJdgFtrRrQF9RJLqUoBtvtYBjGDD8qGl/hT9ITpkCc8Kv3YJX245lYILLfI
	 ySKi6ENAz5JtxzZownS0DsW+wXU0gzN4FtJhF7WDl1syIGnhS1h43/lNfKFSLtSBcb
	 aQQ+cT5dxLqQQ==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso486546a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 12 Nov 2025 17:19:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWcmqh6Ke1JGUae7uso/uxv5WW5fJGUBjhJdrfsVss/7SDoxv9kqQkPsWhRa9MLen8SpPM8Q4vpWcJ/@vger.kernel.org
X-Gm-Message-State: AOJu0YyNBIkn/zj6fJWcuXjyS3P7yeBzl0U5CqVKSUR+s94hDOrS3FWG
	x2P2fBQAQBYEV+sgYLSrAxN7EPqCO4voZJSgIsaaF86hlLneSKj11bofLpJrNmtBgysHHwoEfnf
	3xEHk9/I1+tyiKbXOoNlrnwafUewrOX0=
X-Google-Smtp-Source: AGHT+IH3OJZdCnys5PZEXpc+3YruRfI2mIC69GRGRXC8tf1kMdgC6Beey79mvjWhmhmETHR7O1KBhw8Tom7UH9eNUnA=
X-Received: by 2002:aa7:dcd8:0:b0:62f:9091:ff30 with SMTP id
 4fb4d7f45d1cf-64334c73405mr938039a12.3.1762996780194; Wed, 12 Nov 2025
 17:19:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev> <20251102073059.3681026-7-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251102073059.3681026-7-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 13 Nov 2025 10:19:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8o3CKcaArMzEifR+oaX2G_g3XuEjFkBtPhyO99pKQO+g@mail.gmail.com>
X-Gm-Features: AWmQ_bkew1tHJwUxtyLjNCkvCk2g3GSBubsHa87-IqewxPm-jIAhCjQH120o770
Message-ID: <CAKYAXd8o3CKcaArMzEifR+oaX2G_g3XuEjFkBtPhyO99pKQO+g@mail.gmail.com>
Subject: Re: [PATCH v5 06/14] smb/server: remove create_durable_reconn_req
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 2, 2025 at 4:32=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.dev=
> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> The fields in struct create_durable_reconn_req and struct create_durable
> are exactly the same.
>
> The documentation references are:
>
>   - SMB2_CREATE_DURABLE_HANDLE_REQUEST   in MS-SMB2 2.2.13.2.3
>   - SMB2_CREATE_DURABLE_HANDLE_RECONNECT in MS-SMB2 2.2.13.2.4
>   - SMB2_FILEID in MS-SMB2 2.2.14.1
>
> We can give these two structs a uniform name: create_durable.
Please use typedef to define multiple aliases for a single struct.
typedef struct {
  ...
} create_durable, create_durable_reconn_req;

Thanks.
