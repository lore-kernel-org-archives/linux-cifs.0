Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94A8211C
	for <linux-cifs@vger.kernel.org>; Thu, 14 Mar 2024 02:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710384409; cv=none; b=Gs7/sDGzVj4AoyvVkL7CDeSSHl2OH1DbjGb1AJ40JOHqY2jk7KFsEbEkNxryoh7y28qIp+kB23c5nSvrGKZ4pAo5StcePyGB3m1L7Zk1hRe3L+DfDrx0aCKPV7/551aKpN+KxvOPyIyb8nXSkyq/+oG9sqdsLSPNysDMakOzHXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710384409; c=relaxed/simple;
	bh=ujjWpNThNQSn3CXM+LmSBWOnS+bSl1jdjEbnvf1WnAM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SRbtKoHL61YiUCpPZzFacO5bThO3TOPnkXr7rHpJYdadl1uCtyqNXQW5EIxkS7m27fc6UZtWuZGTeoIfYN3UxZ+H70oAEwXea1V8EAdhHu4VPoDb8XkU7bDpecVSDSrZ51yvknlAMWG4fpF7Hd6e+JRfM6HLNJ75YsoFz4nbjac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvZTYrfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvZTYrfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D97C433C7
	for <linux-cifs@vger.kernel.org>; Thu, 14 Mar 2024 02:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710384409;
	bh=ujjWpNThNQSn3CXM+LmSBWOnS+bSl1jdjEbnvf1WnAM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hvZTYrfjqgYcCO/sIj0V/RKxeXLsWJHlO6VkRbGDgKttIkQLkSERA2tpwR+sT/R4a
	 1FELTc5I5bebSksZdMuouJvgazRlnelLCYU0YRxE1m87EUd1jSBO3EoqRD2lI/7lVt
	 xS/r/3II5hnYBm7uOV+bWdt8dC/esgOsST/BeC2HIQT0Vf6kQSAV5bhhrbh9JdW2Fk
	 y/Wups6TgZBB3Oylde3PxSHPl4J9xNvxOM4DzhlIc1jTm0nHWNTh2i9gtw13GXLTFZ
	 +hsiq4Y8uPPAuT5PybR7qrdzxbgjfcY8Xe2vF6URbpCrWx6LSg6kbxIYUeqAPtzXOa
	 onfVvYGBAbErg==
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3bbbc6e51d0so359190b6e.3
        for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2024 19:46:49 -0700 (PDT)
X-Gm-Message-State: AOJu0Yzz7dgdMC3qBTadSQQTIFdIZh27TxDP/pVSJjvR0TMZxdw2zDcD
	sy/nq+qAqXoUvGRPfK8AzrtlSfjZ0Cnco1F20Ik89hy+nLtMxLZEbcPJbq6pXx0Sl+BuUy5qEhF
	HCAgaxAtCt1cZKluMLgPxAzarWmE=
X-Google-Smtp-Source: AGHT+IHKPwq5dX82WH2CK1cJ2NX417v88NB4AwIHj6UWbrF2mIVr4nOdNcrweYdRH6Kfhohe0y98urXTcYKAxTOJZfg=
X-Received: by 2002:a05:6870:510:b0:221:8a03:6dea with SMTP id
 j16-20020a056870051000b002218a036deamr695786oao.38.1710384408508; Wed, 13 Mar
 2024 19:46:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240313141138.3058492-1-mmakassikis@freebox.fr>
In-Reply-To: <20240313141138.3058492-1-mmakassikis@freebox.fr>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 14 Mar 2024 11:46:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9j_SvvSY=1_pKpnd7qPS1zkYj37zejtX3=2C9jY9m_xg@mail.gmail.com>
Message-ID: <CAKYAXd9j_SvvSY=1_pKpnd7qPS1zkYj37zejtX3=2C9jY9m_xg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix possible null-deref in smb_lazy_parent_lease_break_close
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 3=EC=9B=94 13=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 11:12, =
Marios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> rcu_dereference can return NULL, so make sure we check against that.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Applied it to #ksmbd-for-next-next.
Thanks for your patch!
