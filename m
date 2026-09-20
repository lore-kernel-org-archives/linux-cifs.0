Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4510E2EEE79
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 13:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789912660; cv=none; b=p2cX8UbpZzgW1j1a3ctT6nHbm/cYB6jIlj5nk9c+02H9nP+ZBbaxFTLEu7QT1SWs0fVaZ9EKx5VMD1IQymy4RPzFQYOgTzBY0DMvZsy4Ap8KM8TFEMbwyl91v2V73ehpXGTzPK/anEWnqtDybcpsuGiS7aIyHuH1hUMG30YplnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789912660; c=relaxed/simple;
	bh=rMzGvmMSYw0s2I26d93/OwtHHDlpc0xslmehj8MrxNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AgpSEWcUCh4S7rYCiKpYFuF726A1tAAXQwryLGyxSvNkmZD8EBNWRsaSe0whIw+eGo8TOKVdjLh3KDqzDed8K3czFfloBzWmnNhrvIW2jDiolRJqCXdqZitA1UVmemG4nY8nGNMf+yKGMzET+DKO9V2C3Sq4Ou9tpe5HHpLKmDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4hoZzpu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4hoZzpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8711F00893
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 13:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789912658;
	bh=AQcwCeLbietMNfeLliqZHBEaC6roYtrekeLRpBdYUqM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Q4hoZzpuXPAzuL9O7id0apDZOAnhRBjcq9H0IFdVdIi18ssh901sAV/bLu2/WBpIP
	 D/Jnfat/ibWB/8P14WSKzr9ZKt0UJ2ntAs1H2pMTJL3OHbvU3B505UQeZu3gbOqM8v
	 Uc3SgbAIqiDTo8L+rPVD7gorUWWa7tzLB5K/jPb0YmGwIlViVLCHfXNSTJluyKZKt+
	 EFykbIA+yTgziqckPIOFg6fxTYI1U3LowWBBOIHB+eZ8TicbEU09T040CAXnhIRwAz
	 GuGaZfbOWLWpIBiDDHiOlIRNqQaL0i2CqR3Vl6j4cVgeEURLBBKnWHqmIkEMupoik4
	 4wJ7o6EmtOR6A==
Received: by mail-ej2-f31.google.com with SMTP id a640c23a62f3a-c29703cb796so294220466b.2
        for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 06:57:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwbF4uxeM6vSZoEyl5HGL1XqoGl6cwqCqZvEajCZ2h/acgYf2rI6MeohtbSPBJhcuAcqXfwI/Wg9Bx/@vger.kernel.org
X-Gm-Message-State: AFuF++mVBWUbhgJjFd6PNUmq/6kp7ZO/EYJq19ify7aQTRdBBTTselV2
	mDdn4biDnboxuZ7C2gaVTTqQ5av9DG5j9hnD/KFIEZzCoHdpDF2shlPulPmRlf1KK1tRdP4MoWa
	O9RSAp2BJ3YMmYf3cCUUizljsSEddehM=
X-Received: by 2002:a17:907:c70c:b0:c29:d31f:7d73 with SMTP id
 a640c23a62f3a-c2a1584686cmr671031566b.9.1789912657563; Sun, 20 Sep 2026
 06:57:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920055653.114794-1-zhang.guodong@linux.dev> <20260920055653.114794-4-zhang.guodong@linux.dev>
In-Reply-To: <20260920055653.114794-4-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 20 Sep 2026 22:57:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9YE9w-Ddh1ATUaRoaxOM4fSbDBk0wH-7k-iC-Y=0m3Tw@mail.gmail.com>
X-Gm-Features: AcwNN1UMD-EwCEtyPYW7XtA8bT3DKd_V6f8KIgPHF37tBkvzXPE6gHK51VhnU-E
Message-ID: <CAKYAXd9YE9w-Ddh1ATUaRoaxOM4fSbDBk0wH-7k-iC-Y=0m3Tw@mail.gmail.com>
Subject: Re: [PATCH 3/3] smb/common: update POSIX extension specification references
To: ZhangGuoDong <zhang.guodong@linux.dev>
Cc: pc@manguebit.org, linux-cifs@vger.kernel.org, 
	ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> @@ -575,8 +575,7 @@ struct file_notify_information {
>  } __packed;
>
>  /*
> - * See POSIX Extensions to MS-FSCC 2.3.2.1
> - * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/fscc_posix_extensions.md
> + * See POSIX-FSCC 2.3.1
Please also update the reference below, which still points to section 2.3.1.1.

/* See POSIX Extensions to MS-FSCC 2.3.1.1 */
#define FS_POSIX_INFORMATION            100 /* SMB3.1.1 POSIX. Query */

Thanks.
