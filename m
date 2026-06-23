Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528F9359A81
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 05:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782191022; cv=none; b=Sj727GrSGTo5iURGMq09nF+NFXAV2tjyCokXhAfVBtk/3tZTHvIE4KLVnutnNIIvqNSu8IzQRWgZkwUzz7S+t985BnopyNnn6vgRnm9TPrbj8s+1SCihe060Sdv1kQL9eKgbVBNiJIj625FJ+YdqGJkXbblelnRCzzf2Rj38NGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782191022; c=relaxed/simple;
	bh=HwdwdN/i24s8Khq4+L8CQmqE8iERrDZA/xLmUxUS/a8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jpRMDguZIIKSarUe+9ykyFc842qgYtcVc8q28NThLDmqJizsMsMx9UlqrM+sYmaSNfmdAj711v00SB4ucDprjXI75DNcm/OH83nBKqT6W2jXPUppQj9rV+fUx1sCWCnv1Qn+r/Wq5ShcRKg7OJUvukTTYQUe06wWEsnb9T3rYLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4LXLrwn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4LXLrwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C42B1F01559
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 05:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782191021;
	bh=blPcwB+IDp0Rlxbeolo5E1LM7/PA3gvnYlhhH8iZT+U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Q4LXLrwndFp1nfy9GWQvZPjDtFwG7meKx1PzjKgKYTULsvIggFSjvIPQHeJjDkQvw
	 im20ysZrUAsMAYTUFRgm2/eC6KzQI1GFn5y9mq4am+j+kDfvh0eZFuRBbhWy3tC+MS
	 aSTH9ZWUFp+XD6WViC0tVwzDG8HS6bVY3rcIwZ+7mwaA0nVQiV0BgwXczC7in3BUfp
	 8SQ0tSmxEoBGL3koXG4huIkSYGi4WBcnJ3u4FbZDb2lplA9DW1aUc+8veLZqWcWE7d
	 9mQ0Z8CFv12h46+LP8oMrY8l6UbKoC7n74LWrIX9wXoGYlcXzWI7Eku8JrdXrx5IUo
	 2mq/ST4t+5o4Q==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6974ef0c3b1so5255222a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 22 Jun 2026 22:03:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+QoOMVIAyaAIh8iclM/bhMezLgdetfapHRQzJ8dTNybUaFcqbT0Iz9ICGdazFs1xcDyHVIUflvO0vp@vger.kernel.org
X-Gm-Message-State: AOJu0YwSq3x16QXVx43JXWGbZu+c9B/0p+EsiEH0NeJt4e3lu9FPBQ8J
	WnsN5yIVVe79V0OxnSJVYdPDVhbqIMnVsOkuqgrAL44Ntd7aYEFtHOqmrt8Fqab3cuKIUFkAuMv
	nJ3lxA3Doy3+mSGEyA2SUtGqk3aWh2tA=
X-Received: by 2002:a17:907:c28:b0:c07:fcdd:7043 with SMTP id
 a640c23a62f3a-c107dfe56f1mr44266166b.16.1782191019789; Mon, 22 Jun 2026
 22:03:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <tencent_160379D932900C07E87A916577DA03F73609@qq.com>
In-Reply-To: <tencent_160379D932900C07E87A916577DA03F73609@qq.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 23 Jun 2026 14:03:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9nesneEmhr8pm_=4CtvyC8q7Ac+H7uhtk5R8QPf_VLbg@mail.gmail.com>
X-Gm-Features: AVVi8CfI9vH_6OzZJe2sGliwnfyi2pkRUvcWLOU62_j1qNSl4sjfVYBLCHwJNYM
Message-ID: <CAKYAXd9nesneEmhr8pm_=4CtvyC8q7Ac+H7uhtk5R8QPf_VLbg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl
To: Haofeng Li <920484857@qq.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org, 
	Haofeng Li <13266079573@163.com>, Haofeng Li <lihaofeng@kylinos.cn>, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> ---
>  fs/smb/server/smbacl.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
> index 340ea98fa494..34f0fa43428f 100644
> --- a/fs/smb/server/smbacl.c
> +++ b/fs/smb/server/smbacl.c
> @@ -740,6 +740,10 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
>                         if (nt_ace_size > aces_size)
>                                 break;
>
> +                       if (ntace->sid.num_subauth == 0 ||
> +                           ntace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES)
> +                               break;
Instead of using break, would it be better to use continue? Using
continue would allow us to skip only the invalid ACE while still
returning the rest of the valid entries.
