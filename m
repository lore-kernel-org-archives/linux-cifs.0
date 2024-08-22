Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DC01C93DE;
	Thu, 22 Aug 2024 11:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724327406; cv=none; b=t9wrZIcUcfCrHkT2w9hyd3UM9mzW7F1zRG4dOzzdg3wob9A8uR8LcBQVcQ5GcUKz4jH6xA+SqCU2PuZ0b+FWKrGaJFmipx4/1M+uRBImjz/SYhwstYeZBVEf5hILBhjjtB2TKJUv7MQ1+NaUCWzRxSmzSnwLEhiUNrDs844YN9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724327406; c=relaxed/simple;
	bh=BRR8cZw/2FBFfSKaA2Okh25hFuvzXlGXcTutxcjQ57g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QMVJ3dYKxVgZrkLP7720fuQKlsYVpKZ94x17LGXbXktVqLZ23PJeO4hxgi9r+6NZuX1ixOpotNRl38RnXJG4D4MKqHptjJwEMUbqrCpntmQ5rH8pYXSarYTHPCv50M7NypRYvkBnIabeSfcc5fXMI24hEKjioLFhQbdkbsLGynE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PgtsuKD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PgtsuKD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852C9C4AF14;
	Thu, 22 Aug 2024 11:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724327405;
	bh=BRR8cZw/2FBFfSKaA2Okh25hFuvzXlGXcTutxcjQ57g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PgtsuKD8bOMmbySilfmR0rrBYw3wR3F9twvWL+CFPsbg12d3pRufOVnnzFvIFRYWr
	 tZILs9qj5G4/gne/a/pyRGqs4lgnekqt+YBAlgvLHii8tN3FhiSv0FwRUVzc6+ZZvJ
	 inJWcJw4PbG71KiO5b9l5yPS7wh3g7vAftKQ+HfdqLS75CaAI6jYcm5YfACg3T+Pw+
	 SHkfzlXyJUU029LdNKkw5XmeiUMZLLnTr8iJq3DSyfjrFVBvdTr4SfTaynAiV6bf14
	 cuzL1ydaWTX0LjoKuuuRlMl1mdXagL6A6IJEmlA2ZENRkLRdTeDDOISC2TVz0Smnj1
	 5VtrVyLhHb+Zw==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-52f04b4abdcso854439e87.2;
        Thu, 22 Aug 2024 04:50:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU2ziUSyTx7Eki9VCA7lNx6ZB5VDJ4ZJYJaO7bmHVAqXh8FG2QvnxsnupfHgIToJuPS+G+Cw76TbXrcULjk@vger.kernel.org, AJvYcCW91AmAQ37vYP+74Q/8aOiFSSQQ59r86FPuH4Ql5fo7c4/DJxW02XviIjQm5YiSluixKTXg9TucumsT@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4tKV+oYOPMMp57oyA7PJ6H2y+JdSZ8ij0c8eWBext5jJmzAkk
	m9IMdoY4+3oaWWEQPA9U5rQNNw2gKK9GBOoBWXKEUT2quZcioU2BRQtDaHt4PC32U/Yw4UFj1mX
	TZilzhxf1yD/55tXb0qeXKfBHAiU=
X-Google-Smtp-Source: AGHT+IEqCkKqQOdlMH69y6J1zM2/Rghrx3kBXgfAEdcQWkpHj1VI5bPp8fyp876xka18ETcCIojilHnIzAlRNmls97Q=
X-Received: by 2002:a05:6512:2811:b0:52c:d80e:55a5 with SMTP id
 2adb3069b0e04-5334fd2fd70mr984694e87.41.1724327403908; Thu, 22 Aug 2024
 04:50:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com> <20240822082101.391272-6-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240822082101.391272-6-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 20:49:50 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9hXJssgKK2ALkj7H162rAbSzwfydcMqRSC3c7R9bW0Ng@mail.gmail.com>
Message-ID: <CAKYAXd9hXJssgKK2ALkj7H162rAbSzwfydcMqRSC3c7R9bW0Ng@mail.gmail.com>
Subject: Re: [PATCH v2 05/12] smb/server: update misguided comment of smb2_allocate_rsp_buf()
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
> smb2_allocate_rsp_buf() will return other error code except -ENOMEM.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Applied it to #ksmbd-for-next-next.
Thanks.
