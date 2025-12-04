Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049C62D8DC8
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 00:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764892802; cv=none; b=MHKcdX8xhl4L518fWdUSGV9DKGymlRaDdzQixGGubPm0l4vAaAiqnio85A7gQSOwMieZbI9GUhKQBqDBXgK3/6ShhZpENw9FMUgHsjrwWr6BMbuW9ixjz0dpg/DUjE8em37CQj4NTtjiz4JgeCVhRPyTJ8oEW/3dr4ALaPn/2RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764892802; c=relaxed/simple;
	bh=bjKRBtapwtWZggmLJJM5F/wxW5WAPUqqxygXSkPUqEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TBvY2a9xPaZpBkW89u+77hR3IHTu+KzSnVZIt6khrl/JiMjSoM+9TPy2NiirD/CdogM/YEUD8a6N/dM91BIpBMwQeezPLq+IcrR7UVktBZdRls76czcesregvZrifVVn5IgwNy1/CvPQmgt3DBQisGUWlP+4GahlVVRRvYpgYzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBPLNWcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBPLNWcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ED4C4CEFB
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 00:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764892801;
	bh=bjKRBtapwtWZggmLJJM5F/wxW5WAPUqqxygXSkPUqEQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WBPLNWcLattnd5d4gELwGEfMmwxn4NmHg6k8Jwm/O+g9ppz9CFX6EW90bpLXj0TZT
	 fyN/8NwHIKLiH0elWhdHItOTnJ5qE0abvvV1NGFQNQ2gy5JSHB3/ZUqCmcafArINpy
	 V//CBlhI02fL5TSNno4sPrYtE7dzmC3lUnyoedr5+ff0OOlNoxrs7XL7NRLGRqp5Qy
	 NFQjnYLI1SCpfmkQhksSZh+HArNM30kbT7VpdNHIPJ8RjhcongXxNXlQGm8Dp9M2Ru
	 f8sP1SxZYzdy10580pId2EywTtI1ofL3gNxZ48nwP5q/ALrO7OB2dKdWKts6158oFa
	 VouOJs07Vx2rw==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso2502216a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 04 Dec 2025 16:00:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWAqYOvzwx+k70XQ28iXjjW7HD3koQJ9Dz2EriZekDCT4QHo4z3+ATT9Ds/8g+udlxM04/anhL3CvvP@vger.kernel.org
X-Gm-Message-State: AOJu0YxZhIZFlAvG3r4RDdr/X3foa9efo6S3WrcQto+aIQRPGfsUw0F1
	o06pLeqqRhZwiSgDYWhirP8uRYKDv+HUZIJw1RA7xnRkV4VORsCGE1GDp+xdrLo6+9xmNhRp1L9
	L+Ztu38PeaHnmEjxznOXSbvUroOEnh0M=
X-Google-Smtp-Source: AGHT+IFUYEz+b5MkeRVtzV07paeC5PvEL40cqAQHlggm7KK2diNsmuw6DWqYA9qKd1jn6ZlI1BqPtG1IpljoLKioYAc=
X-Received: by 2002:a05:6402:2219:b0:62f:9091:ff30 with SMTP id
 4fb4d7f45d1cf-647a69e3e89mr3410516a12.3.1764892799844; Thu, 04 Dec 2025
 15:59:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118013229.283900-1-nichen@iscas.ac.cn>
In-Reply-To: <20251118013229.283900-1-nichen@iscas.ac.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 5 Dec 2025 08:59:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd92o94vzBx9AbwJunP6w5y7EQ2uzPPikXUDPQVtVVadtQ@mail.gmail.com>
X-Gm-Features: AQt7F2pFo6bB-hlbbtr0OpoFHHPZbm75ikbfL5rC_oh2K5KkXP1aFjEHVVJbD98
Message-ID: <CAKYAXd92o94vzBx9AbwJunP6w5y7EQ2uzPPikXUDPQVtVVadtQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: convert comma to semicolon
To: Chen Ni <nichen@iscas.ac.cn>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 10:33=E2=80=AFAM Chen Ni <nichen@iscas.ac.cn> wrote=
:
>
> Replace comma between expressions with semicolons.
>
> Using a ',' in place of a ';' can have unintended side effects.
> Although that is not the case here, it is seems best to use ';'
> unless ',' is intended.
>
> Found by inspection.
> No functional change intended.
> Compile tested only.
>
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Applied it to #ksmbd-for-next-next.
Thanks!
