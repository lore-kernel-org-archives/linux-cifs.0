Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C5234E765
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 12:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769085320; cv=none; b=M4SnbMpJ8hjyVvDZM2//HV7weEce1ZwUSPpjQy4ow0QfcmCN0D+H7xygbsF8t0W3Ms127Qp2r2nyjJKfm1J5tY0OE49YwdMDBf5hAatmnnBttQi8msni+5KUsEmf3dB7W7739j+W4XDzS4xGUcOtEizIp3368VKsQMLkst3gmrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769085320; c=relaxed/simple;
	bh=boUE8pQjgwsiUXbOQjcunckhvyCOB8FiKWTL25NVljs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ayj8fiL1yhXjgAW/4Pef3aeX4aM+m4/PJCxO2YV+IEUNtD1dixHBEHJt7EyqJADkP2skyZ/R92B8pdnqENRk3kg5/g6g67qRwO1YxSijUTOF1/J6PyUc1bfZRbl5zzBL1+Cy1zHyOxp19DMH3LaV4XsB8liDcbk8Eu2HIrOVhv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b3zC6zRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b3zC6zRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B35C116D0
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 12:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769085320;
	bh=boUE8pQjgwsiUXbOQjcunckhvyCOB8FiKWTL25NVljs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=b3zC6zRgVGNafpM9OXzAz5SiXPNOyghIEUjzSGetQ4lYQUJTP97GaICNKczceRAhJ
	 V+OshP/XDWbb2QvKx/XUmVaTvuDl3ZMayzcdxQSERy0eVYy3J+1ShtE1Bb8bYmVG2D
	 9g2nfPwLLdOm4/MqRLfigGHTyEthp7LkHE2pJxLb7IDizkBhK8WncuCetEkZFH7gPX
	 uQp4icbXEZ+ald0t6azs3WPyqTyxNl9eE6OX/3vlH83h7Vw3UrS5geQsaI8DQ9VTUd
	 muEFLAfzaPt7Zn2yirzaX6ckkNKzSgiO59izfoo3B+XDNH2Ckh3OETz5/BHlNlGan5
	 lM5/oESuqozXQ==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-65832eb9723so1750862a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 04:35:20 -0800 (PST)
X-Gm-Message-State: AOJu0YwWpPsxTbmPVnm/fcEcvVzCLBaAttvBpmJDL4Ng7mBgXBuT/5W8
	Z4ZmZZYPYgTzd6q6shuOo4UJo5B77+8GiMHTxHvTzYcdsiYZp0XR5/wjrl9BZUpYQQAO6EJ8dMv
	rtQrFHAiHulTa3jpRxq6qf7uRxTrfQWo=
X-Received: by 2002:a05:6402:42cd:b0:64b:bb79:96a8 with SMTP id
 4fb4d7f45d1cf-654b93652f4mr16573514a12.3.1769085318726; Thu, 22 Jan 2026
 04:35:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1769024269.git.metze@samba.org> <d70a09dfb7346e2c1a467610acda96699c91cf55.1769024269.git.metze@samba.org>
In-Reply-To: <d70a09dfb7346e2c1a467610acda96699c91cf55.1769024269.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Jan 2026 21:35:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Qh36djuPHKhfWWwLWDKE2vPcHRruYhFUqnxEu+GLHSg@mail.gmail.com>
X-Gm-Features: AZwV_Qh5PtPM6w42YvUDbEqOcSKfAnofI7lHzP9u7rG7mxVeuZ-kYfn0v4dPT48
Message-ID: <CAKYAXd9Qh36djuPHKhfWWwLWDKE2vPcHRruYhFUqnxEu+GLHSg@mail.gmail.com>
Subject: Re: [PATCH 03/19] smb: server: make use of smbdirect_socket.recv_io.credits.available
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	stable@vger.kernel.org, Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2026 at 4:51=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> The logic off managing recv credits by counting posted recv_io and
> granted credits is racy.
>
> That's because the peer might already consumed a credit,
> but between receiving the incoming recv at the hardware
> and processing the completion in the 'recv_done' functions
> we likely have a window where we grant credits, which
> don't really exist.
>
> So we better have a decicated counter for the
> available credits, which will be incremented
> when we posted new recv buffers and drained when
> we grant the credits to the peer.
>
> This fixes regression Namjae reported with
> the 6.18 release.
>
> Fixes: 89b021a72663 ("smb: server: manage recv credits by counting posted=
 recv_io and granted credits")
> Cc: <stable@vger.kernel.org> # 6.18.x
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
