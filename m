Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAE42CCC5
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 04:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784692934; cv=none; b=s5y4228hgvE3O5MTInyvHSfHOkb2/mc7O+d2TKRIdxsHE5ci2+HBNlssRk28UxFdE62eD9dW7hfXwxRI28norudJS6OpQlxtIGhBpqpnH1sg9HDW1OaXBgbYrD7AGxu/HK66MwnXNAvs67m+8GoYTy0+Mc3/zL5vD24wzI0DE88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784692934; c=relaxed/simple;
	bh=aAtgGHGgce56fzy+XEh2zavJ9uCwnEEK1ZQehzOjk7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PpLBZfBaM/2oN/r8qey8QU9JGfVuWyCARhUZzG0Qzo3aZnX9M2TvGjRpVNq4y+9W2SRkC9p2QLBrR4KwrekcW0n3j4qC29Lm7KttxM/hGzXwbTTWgLI1LnEDlYC5+YUSWPyLGAKaQv8mKx3dJG5yC1NjP/EEhe+H+Y6SGLOlEco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VfRwpVmI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VfRwpVmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7831F00ADB
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 04:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784692933;
	bh=aAtgGHGgce56fzy+XEh2zavJ9uCwnEEK1ZQehzOjk7E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VfRwpVmIVLY/Lbw6q53yInWVYu4Kgv8xIlYEGhoLAlqPUz+IBdYWcbd0iE4kd4R3D
	 8QJf4pO0Kd9af16QuHV70mYTtC52ul/AHm+9BtEdRcMeJTVC6frTMCkxyOEiZ5Uk9J
	 MlcUPLa/mS7+Mg8uPhUle7lXX/oMbxaRevizQ4GheNJd6JSLOlSdnAM5Qd47Qcu5bi
	 mqbn7PmC9WUVGS5J/oS8RxBe0gKwe02hGzGx026BUTGkHGqusLWlmehS6KZGAZS7a4
	 6PSp88uJx5rR+JbeYRFVp/b/GTECdBQECj0coTJBesh23IUrpEzW34F6FQOc1S6Xha
	 Ru3NYVORZ8HUw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1740c36c5cso679376966b.2
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 21:02:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr4pW9RhvMw3rLZVOe6vzJfj69i2d/qDy+96fNJKO/7vG486kiPbmVTcFC80s6q1WCb6hhTjJNvEjeo@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo/Ar5loHBVLmNBa9jBWe7Tpg0IoO7VmVTF4wEl3+EvI2h8qLH
	ZNXdwH0vHp7FfS5T0zRWM9PMVRKSeicmDHou0klMYg6pD4BlTcYEFRG91PrnQYQ/Jpfqt6mJqwn
	i2BTkgOMZ6veiWSQQOVO/Bm7vkilISDs=
X-Received: by 2002:a17:907:ba07:b0:c05:abc0:dc7c with SMTP id
 a640c23a62f3a-c16b48533f3mr763855066b.40.1784692931860; Tue, 21 Jul 2026
 21:02:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1de1e19c-bd57-403c-b91f-70b2d3b51fe7@chenxiaosong.com>
 <CAKYAXd-p=8p6c4HTfH9Su1bRAUwZsxpU=PXtRm0Y+ycge81Zaw@mail.gmail.com> <2fb95851-8416-4c74-a0b3-4b682cff472a@chenxiaosong.com>
In-Reply-To: <2fb95851-8416-4c74-a0b3-4b682cff472a@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 22 Jul 2026 13:01:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_74L_w+7YZN2D54wAieJHWTgE_xzRd-QM70VGbRXXiRg@mail.gmail.com>
X-Gm-Features: AUfX_my57CFCkMb8Ijgf2T5m21-F8ZBPiG8ICnqC6ngWd1ffVXMumEMYs0pNEp0
Message-ID: <CAKYAXd_74L_w+7YZN2D54wAieJHWTgE_xzRd-QM70VGbRXXiRg@mail.gmail.com>
Subject: Re: [BUG] null-ptr-deref on ksmbd-for-next-next branch
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 11:14=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Yes, you are correct. Checking conn->ops->is_sign_req is OK.
>
> I checked work->sess because signed_req is only used by the
> session-dependent signing checks below.
I have updated and added the tags the patch in #ksmbd-for-next-next.
Thanks!
