Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62B421ABDC
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 11:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766145189; cv=none; b=hr7jfGSWNtL201GY6wWOPoWd28YXQoVcef46t4e9Q7oBAcbX15uqnMRLbhdAqmOi32+XQJd1+EN8KMng3ZAclSyI41XVJy+kOd8KbVTCH79RnAtZ0sgrYpruyHiPSfoughzQC1j8ob+LTJuWYkT8RTOFtdSKAbo+cPZKBOjjdlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766145189; c=relaxed/simple;
	bh=KVEw7bwL9ZZOPodgOW69hotv68PBxsxQdo5ga7NcbTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rncSQxXpiLk69I6R8Bm20tUP7EQQ0QwurN+SDN6dKjhhBVcewd1hlGuTRkklhiN1FT9TxhMaVNypNpRz2YQAaHMq9Li7QU+d8sEcHk6h+b1dj3II1aarzw4muI+7BGsvCgY28sgMi+r07xQX777sdo5lD10R3NbARRQ77fl7I44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gK2MCkv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gK2MCkv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D3EC19424
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 11:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766145189;
	bh=KVEw7bwL9ZZOPodgOW69hotv68PBxsxQdo5ga7NcbTE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gK2MCkv+y+3hkOn+6kZpubFRxsYnEPF7PSObHMTuFTLgdwYr8y72u9TsbTGd78dSw
	 Lu1Ag95cHuAuOGb2jKZUJdPbia5uVSlEW0rqStpftEiZK/2qohlHUG5gFFfGIsQKYR
	 eN28uDF22tDfedx19EaViwQzel+BbLpkFlKxrWhXLkkhb9DCLw9KQuXLEVHrVsGLfc
	 aigYK+J0holMosRpYwBhRBGpM7kKqk5Pxjs70K+KXFjcwvcbEL6JqVeMhz4VH16R6u
	 21kXLCZ587YeLuzqxXMJFwD4Xm1mGHteDEttntNDbyo4rP8B39vJJjFPrz7RaRF5fg
	 tMCCO9OT8E6bA==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64b58553449so331597a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 03:53:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVTtjJSgliKyNbrZ0WuJq9e3ISxIrzKYISFmUlFJz7eYbTYbjumBMYqFKKYoJottos0bW7BguyHyoIb@vger.kernel.org
X-Gm-Message-State: AOJu0YyX57+vUerCc4fFKn8vsoahaxiF+oewG9p4qTcJk4BknVLRlgIQ
	0LQJ6yEZXiLVmb3ILi30muImBrZVg4921hNfL9fy3BkGjocjMEIEnwzLfp9tBA/Fj/7ezt55zs8
	ZlPoxSdtrmJuPg30CbuZFfknuHAGfq3s=
X-Google-Smtp-Source: AGHT+IGgerITzEBGMe4LCJqC1KyO/VaA0XE+WGA3vkS+ib/5bPR8yuV56KHSJozJx3EUagW++x499IWXhn9eEmTFTFU=
X-Received: by 2002:a17:907:720f:b0:b73:79e9:7d3b with SMTP id
 a640c23a62f3a-b8036f29b57mr254379666b.25.1766145187525; Fri, 19 Dec 2025
 03:53:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd-W9xN9rQ4_Y9eudV2CJ7ZObys9YLXib-=wHymH4kfExg@mail.gmail.com>
 <9b5eec32-d702-4d77-b4dd-5c33939ae6e2@linux.dev> <CAKYAXd-Lub=zOOE5cW5jEWNYhTJcmX3grZLLXFpZTcwWA4UYBA@mail.gmail.com>
 <805496.1766132276@warthog.procyon.org.uk> <CAKYAXd_owC9vmSF+ukH-GgG5mWwFWGtwrXNT-8gfUZGHVDTcRA@mail.gmail.com>
 <812021.1766141424@warthog.procyon.org.uk>
In-Reply-To: <812021.1766141424@warthog.procyon.org.uk>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 19 Dec 2025 20:52:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-MGFZL5AKPebdnEJhg32rHOTJHXvGd0OmfkWhdQCoi-w@mail.gmail.com>
X-Gm-Features: AQt7F2ptjsxiKNTYdH3u05xqRBkYMZ61unWK3FWdX3fTXT2VcLg7oXkoKmOoV_w
Message-ID: <CAKYAXd-MGFZL5AKPebdnEJhg32rHOTJHXvGd0OmfkWhdQCoi-w@mail.gmail.com>
Subject: Re: [PATCH] smb/server: fix SMB2_MIN_SUPPORTED_HEADER_SIZE value
To: David Howells <dhowells@redhat.com>
Cc: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>, sfrench@samba.org, 
	smfrench@gmail.com, linkinjeon@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, senozhatsky@chromium.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2025 at 7:50=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> > ChenXiaoSong, If you agree with this, Can you make the v2 patch ?
>
> Can I suggest adding a comment to indicate what the +4 represents in the
> SMB2/3 case?
He will add comments for both SMB1 and SMB2/3 cases to clarify why the
+2 or +4 is added.
>
> David
>
