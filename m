Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4699D3FC2;
	Thu, 22 Aug 2024 00:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724287780; cv=none; b=YWfvoOejm9WQr7CxW9JNG+KlNsWlGdBUx3Axe9w88kwZ4uXxtkY023F+J2BlLrp6c1ZKTHHvMz8YLBVbzX5k54X/nu4cyILSfT1fmfo0GXJCtOWKNLSBVfeIjx6baHQs+3qtoUDgGUg14VL29B3VaaiBI7LNB8uj1bvsoTonFyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724287780; c=relaxed/simple;
	bh=MR2WzbHtGLe4mke3254+5LBiSLiLbyAcXID9O7WCBMg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BNk+HgWO/ckpgcDqZb4I776K2OL3gA4HhSkr/yx2Zdr7MSqUDS8Op01rYqPXej4V2PQYzpwOFeHSP5MUQCBcxRKMBxGKLNJHYk5AXimon0qWqOhfEVodxMbKtUhInStnqTJjbT+nNMRTtvQMq5NIMW9sdjgvMU0iq3X0gudnBPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K88hSpBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K88hSpBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCA9C4AF0E;
	Thu, 22 Aug 2024 00:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724287779;
	bh=MR2WzbHtGLe4mke3254+5LBiSLiLbyAcXID9O7WCBMg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=K88hSpBLA1GNELJ4hLAciDjrBWVNFSecQN1Lyvi4cYpMz+lSAL9ut+3iDK1E8WWIS
	 14rgYbjKlcRriUvUfUb3ToLiUMeMrEf8Ndy2ZzJgN5rwUBz3ns+OviOsptfT8WHZce
	 ek+qD0hXtFYZceUmMDsWm72eXv85kHgEbf69H6G7kTDmeQAsz9+saHcRVbyLyt1f+9
	 VUcQNSlKHCT60ujJRc+gHlpCifoIOWwz80vfIbS2fuM3543DUKhwchv5dkI729mjLA
	 RDXHwvrtwpNTT6eD+I4bH5lLi+2ZWOK2QXwRjCehyQtNQ/xxjNdnowoG1JgEQsE0ea
	 1TKLxcQUt/C8A==
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5dcad91e64bso251265eaf.2;
        Wed, 21 Aug 2024 17:49:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV7O7Sdcptzu4WQ0TkilAVcbPjZn7Y7OzSeg8CyPIzWjTS2IrLDH1aKo26BaD3m+2PMw1hIoTydn/4MBeTh@vger.kernel.org, AJvYcCVAG5Jc3qhlfJGpARlkzsPmyEe2CoqYfQ157c5HZyzXSrISg05LkTqEe2Xc6fo+iFShn9WEZ7lx4u8I@vger.kernel.org
X-Gm-Message-State: AOJu0Yyvw2oCA1EFppuJ9tRjaocsMG8NSeCv8hEwtRGLyxyGosVIoAFo
	2l5T+syNMcWJONdKrH1DzuEjH0MvB5O3I2DO42Cjl9mcKQTYRk5aZCSMSBjkJ0sKGqipIpY9fno
	q00hAqtgv6EHxadXAXqIPLavTUfo=
X-Google-Smtp-Source: AGHT+IHe9VPW9JZ2mTRSVzwJ0b4dGdty3s/O3NyHLvkywr5UoogX3YKPgFwGYoRSolV/aWsWdl1gNiJergVVQR8buuA=
X-Received: by 2002:a05:6870:c1d0:b0:270:2e03:d261 with SMTP id
 586e51a60fabf-2737ef51561mr4508941fac.26.1724287779211; Wed, 21 Aug 2024
 17:49:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com> <20240820143319.274033-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240820143319.274033-2-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 09:49:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8iUmE9GmaSc=5dw4bT0prbNai0uW+QRc6YgnSuf0dtWA@mail.gmail.com>
Message-ID: <CAKYAXd8iUmE9GmaSc=5dw4bT0prbNai0uW+QRc6YgnSuf0dtWA@mail.gmail.com>
Subject: Re: [PATCH 1/8] smb/server: fix return value of smb2_open()
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2024 at 11:35=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wr=
ote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> In most error cases, error code is not returned in smb2_open(),
> __process_request() will not print error message.
>
> Fix this by returning the correct value at the end of smb2_open().
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Looks good to me.
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
