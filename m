Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3234274B53
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 01:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790474247; cv=none; b=KBSr4FrlxozRB5SLNAcPGOap8WH7IbufOumEbr1H/NYT78lmIq6aubwjh5yfY6MlyzoT7FDJQLe500zZwlEblboHQ/vl9p/q/bNpofnzx7x5FMlsYJVRHgp7PJOuBDzsY45M5CWadOfSo1YjlxxPPl62Yz1We+kY30q7x3u1fwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790474247; c=relaxed/simple;
	bh=5zM9YADLAFZ7kXwVM4L9L6kp6GuAb/L9neMpIdYmTww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OSBdIkGaqLdwuWysaYcaY9pqR4VJF6rmZtcg2S/AhkOat/8UySmXW97SmsLJpXGHeSVfsRnAOFCrIx7SaYwqJS23R9MRR0K4xChtZtGv/eVBI0g4V+mf+222jFel64CsBmg6xwvHPDkkuXi+s5uYnmf7mWl9v/y4ycpTuitAeiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mlmSxrIr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mlmSxrIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC3A1F00898
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 01:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790474246;
	bh=5zM9YADLAFZ7kXwVM4L9L6kp6GuAb/L9neMpIdYmTww=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mlmSxrIr71RIhWR6Vh+5/tCW7BtbR9/nSjVIz8Qsz0ApCYNi3jcB7SKV0EMih1qfy
	 i9rMtTeGhSrSDsxgv2RCobIN7zHQsJTYE5hAV1JQLFgpTn7SuIG3pKAQdP8hvA6Jx5
	 b+5afE2FMDWarMBKuR/cA9dLpJrYxEMtNfdOJIY6pGW+rTD5g/Vh9ZZruAOJpxxcTk
	 MDX1I4EpaLpC7M6YV+oNJSKUqUGl13jcEDA/vrYQq/yAmZ0Og0+yAzZn/lFZroCmbp
	 zNq6W35tGmHAfVszcoCDBbbCXtWyaB/iO1qUgdEbPVTYTgdN2AmppPHxc/SKUBaGAY
	 43KzIGdLp75/g==
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aaf5e6878fso2139844a12.3
        for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 18:57:26 -0700 (PDT)
X-Gm-Message-State: AFq9FYJqAJgDSqGKZipEqkxEntgOorcwV99QclLYPlh32wBV5+tHB7a2
	o8uWKLc1iTzO9MVxX1G29RhG2TyxWggS7ziwNFwRNzutMeWPPGG4rDGZSrdtcEJPHW432BSY16c
	OdSHIQfsr6Z18l0JorYtlRO0skW6X2V0=
X-Received: by 2002:a05:6402:3511:b0:6aa:9dfd:fe6e with SMTP id
 4fb4d7f45d1cf-6aac8f54611mr8337005a12.20.1790474245062; Sat, 26 Sep 2026
 18:57:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926081335.1671600-1-zhangdairui@gmail.com>
In-Reply-To: <20260926081335.1671600-1-zhangdairui@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 27 Sep 2026 10:57:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Ws=zcvL8VFL3kGThjai+yjwtTt+WWn5Q-MM-ueNdG7g@mail.gmail.com>
X-Gm-Features: AclHuK_frEaCCpjHoTtZostIzX-Bs8h9m1h7ThqVkcYVrJ3ABXj-OMdv0Q9ZijE
Message-ID: <CAKYAXd9Ws=zcvL8VFL3kGThjai+yjwtTt+WWn5Q-MM-ueNdG7g@mail.gmail.com>
Subject: Re: [BUG] ksmbd: OOB read in ksmbd_validate_name_reconnect() via
 cross-share durable reconnect
To: Dairui Zhang <zhangdairui@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"

> Suggested fix: check the prefix before indexing -
> strlen(ab_pathname) > share->path_sz && ab_pathname[share->path_sz]
> == '/' - and ideally bind the durable fp to its original share at
> reconnect. Happy to write this up as a patch if that sounds right.
Okay, Please send the patch to the list and me.
Thanks.
