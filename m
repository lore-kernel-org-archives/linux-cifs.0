Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60ECB335BA
	for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 00:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776904331; cv=none; b=OYBr4pUTG09txk4bUlJoCwN5tN0vNXV2TwZ6WrDpX7iLPjE7x+3TYMPkYeIF3n9YsJm94kiLBxWWfg1RIp/TDN+D3rtaTsw8flAF36VaaXYDWpcWh0Xesj4ILmgnfADxCi0WHy3Jn0I+zt7J9+SjNIHf7bw8kamDU1v3EIx3Ek4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776904331; c=relaxed/simple;
	bh=dp0ajV6z+foaPk/aM9swiABfWlZIcQARCcCbTyZb80I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gwRYhLqY+1SeCBujhTTv3b1n25vBBp9Q/b8oKLzyW0kXS+bB7LLF+u/KsxsYkcFOyX3tSEJDldwQMW+nRRj7FpF9GlCsEChQ9GI8oG7bGKrFVpa3W2dZ3WyXwgyU5NdP6d/MNlygn8MyEqSpsuJJCmgYBfSlLw0ZtapzBUvKNbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VpZLA4cc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VpZLA4cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14961C2BCB6
	for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 00:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776904331;
	bh=dp0ajV6z+foaPk/aM9swiABfWlZIcQARCcCbTyZb80I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VpZLA4ccB8/acMt7cmEWQpurcm4GU865FBMAVPOhGD/Oig6iGXNCHFcuqpYQDwc1G
	 hEv+0sXqfukRJAIUiIJjG53C6R9uDDt24IV+vTt50i36iETlDwonaLnd81DcMKVSrC
	 AWijriE6+TjvSucuWFS/YQj/5k/MunUbGGSJdNwvpYTU29m5csem/w6Ko2P1KAOO8q
	 In61/Jbzk/zvFi0Eyu5pDJFTav5/+sfTqErUswhxLSGtqph3HNLoQqIQBcf5TT3T5a
	 saA1z/vazSJXpMIEKQtb2bZf37AkLUzkPmvJEkcyKKGY1gECx1sROVhME0rJDzL19O
	 vqA7W5G2qVpRQ==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-66d65646c65so118765a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 17:32:10 -0700 (PDT)
X-Gm-Message-State: AOJu0YzGZxviC+sX469S/t6N35HLKT+xG/DzgNxRsQO4LctV/zhKjarM
	Zpazx7rwFRk8DSsrFhjMP+TQwO9GjA8a1GTFUvSCLbYUxlLeyOsOGn7rYRnAlvJUbp2Rj0TsJo9
	tUr7HRe4rLTOkU8dLfcI+gXF/R6t2ZaU=
X-Received: by 2002:aa7:cb49:0:b0:671:547f:28f4 with SMTP id
 4fb4d7f45d1cf-672c128d7b4mr7051921a12.9.1776904329623; Wed, 22 Apr 2026
 17:32:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260422104859.2599422-2-mmakassikis@freebox.fr>
In-Reply-To: <20260422104859.2599422-2-mmakassikis@freebox.fr>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 23 Apr 2026 09:31:56 +0900
X-Gmail-Original-Message-ID: <CAKYAXd96g74+eh0AkbOwgXNvzUsvxMQQZGc8yPyTmQYNOf4nrQ@mail.gmail.com>
X-Gm-Features: AQROBzDnUCuZo67m15dsi0RenbSKZoZ6frCY-Yer46a7UtXAp3wbgbh8pX6yAqI
Message-ID: <CAKYAXd96g74+eh0AkbOwgXNvzUsvxMQQZGc8yPyTmQYNOf4nrQ@mail.gmail.com>
Subject: Re: [PATCH] fs: smb: server: handle readdir_info_level_struct_sz() error
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 22, 2026 at 7:49=E2=80=AFPM Marios Makassikis
<mmakassikis@freebox.fr> wrote:
>
> early exit in smb2_populate_readdir_entry() if the requested info_level
> is unknown.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Applied it to #ksmbd-for-next-next.
Thanks!
