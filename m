Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E644A1C93CF;
	Thu, 22 Aug 2024 11:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724327387; cv=none; b=kQt5yj9CpcqNkuxwji0TALHrc5keOCdIf0N3Ewd82ja77y1yAmQoWF0qYJD39W6gmuIn3JKTvvXCcthbt9WbshbMjjnKCTKKsEvLmYzg3kI9c2XmQ/MqSaA5TmeXYd55l+ypsH1YKCkolbQlMUdtvSFuNhoFHJ856oxxi7zo32w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724327387; c=relaxed/simple;
	bh=HOjI1j/F8IvocLQ582o5an6TIdQNJ0WAYju0fU/Z3Cw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uL0W+ZmWZBPPypRqIWEJ52oel2M8QTrjLmWc0Kmj885yHMBzSzTXJ0GWdmfuadXQWRci2+O8R0ffZmLB03xFw50u/OvLkcKZrjyvTBgSIvaECCriJ0uv1zgkd83KJ+6RR0hFl8mcS9kLzXgi24kf0aGjkvVtDu3fH2LV6zZ2vQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/57quzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/57quzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA0AC4AF09;
	Thu, 22 Aug 2024 11:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724327386;
	bh=HOjI1j/F8IvocLQ582o5an6TIdQNJ0WAYju0fU/Z3Cw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=d/57quzZAXaJ7Xk9EWdL09OvCxlPg/Erlst9VSKQ227nB4r+fW9VHSNAhUDyD+0kE
	 81C4zfl5FV0hFcKwGjFsWsQHiRcPJSlpab/c8A5s5AQVunKq37M7yid1SzNGYh3v+4
	 4tXkBsvM9UyHTdqw3eoUtKA9m8NqAWeoPQAmPN/RV5h/FH6fX8FElEcbsU6AnREJCk
	 xmd5sb5b7EG5EEPQc1JJt6eOOs96ung5ZHIxMwApD/Gmncuv+f5mNtpZstQ9b1oChf
	 CRuMeNP8ln3g8MylahsPnHJRvUJlzHKtXfclR/VHDQwsbS++XLMcOGdmwJMNRuD4S+
	 0aucmTAMzWKHg==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5334a8a1b07so1008565e87.1;
        Thu, 22 Aug 2024 04:49:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV3jDGiKKo7ughAagBQGYQbKcJzGFAY3JrTIrDy4SmIPT5xlk5+5U0P4FHmizNl+gfru5cUCL5HiX5spmAO@vger.kernel.org, AJvYcCVZTaU/+qJ+wRh/tDLwtCK470+xqm8tnaOs9RGIuSO3915dFMI9QGFV0C6gkEWp/e7Fz+UgyLpgbzg3@vger.kernel.org
X-Gm-Message-State: AOJu0YzlfoSn+AEg1yjrFXe8PJAOhxGSe0+iDCPOUH+dA+4ocZBAsfgo
	wL01DtHkb2KYORDo7HtTfF23hg8AdEk1dKoqL0vvJOxR8l/6KaF5G2Gkiwye0Ggz3jZBnu2FZPd
	BwURehBh/aigL1hO9PaUhCxQ3EAk=
X-Google-Smtp-Source: AGHT+IGoN1iEwIqMPaAyD6YA5zDMEsIlWdpU4CHx98XfmAg0+A6hCvl3rzlga0Gzh7ipMsLWASuz94vY5Gx0uOO/y+Y=
X-Received: by 2002:a05:6512:104e:b0:530:dab8:7dde with SMTP id
 2adb3069b0e04-5334fcf71bfmr1068117e87.34.1724327384933; Thu, 22 Aug 2024
 04:49:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com> <20240822082101.391272-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240822082101.391272-4-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 20:49:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9eZOmvG899tJuXAqP4=u_OCmN1MaGWieQsrEtC3NFoGw@mail.gmail.com>
Message-ID: <CAKYAXd9eZOmvG899tJuXAqP4=u_OCmN1MaGWieQsrEtC3NFoGw@mail.gmail.com>
Subject: Re: [PATCH v2 03/12] smb/server: remove useless assignment of
 'file_present' in smb2_open()
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2024 at 5:22=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wro=
te:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> The variable is already true here.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Applied it to #ksmbd-for-next-next.
Thanks.
