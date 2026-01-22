Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A632E091B
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 12:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769086075; cv=none; b=W8deCCCSStvHn+ANbJobjiyVfONgSUY/+Pi4PXp/oQw2ZTYvZIvnKSn0VaVn7839+ccX4oJiSVd39E5DQtD8Ytm8fpbhuDoa3Zqnx9dmLx6oNa0hn1ZpDhaQzwE/UhCnWZaY0yoSqYfL/pDQp8wxUVyeaASYWblcZCjBSSKzn5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769086075; c=relaxed/simple;
	bh=zU+rf1tCXpDNUFXYEvhYHREVrhniYHLqDw1SrN7jgsM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gM+e95zSeKzUQRgKzpdhwIN8Nzi74G9dSMnHsbJI3ktH8mbhVapKop/X9T5CxW+NY6kGFalC36K2AqzfgdOw4zDnFQABKjpWhnEjPhMUPqtmrY2+yNQGSCS7s1hIfB+J6W/+sLiw+qtzMHldKv07PDTXNIx9tqJnK3YlxjKgALA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s68Rghmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s68Rghmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BB3C19422
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 12:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769086075;
	bh=zU+rf1tCXpDNUFXYEvhYHREVrhniYHLqDw1SrN7jgsM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=s68RghmxcilXdhdinBZV+UejlGDCJy8f8zZ3r+577oqdlAjzrDCR5NKMLOGjUo/CM
	 QC2L9Ac568vIxZHE0egUGcmdMiQ/yUwbnXY8q70qmwEIdihsPC/mWd0HOIPE8H+t8l
	 V2n2cg5Xb3UVT6flabQZFhbCrOLhQuRYcA3wq2hcnIqcettILfLWt7lGRQN1P7A9AK
	 2MQNaT2fg6T1Hedx1+zoCRZss7SIFAP4l3BVW7wv5P3SEye/atbtxrKWD3PL20YFK5
	 IP+QGaR8GcA3P+XMXF6QlNc4FUI8HUgLM7mGf1V3rrwbZOioXkCW7Ltx4Fd96B3ihF
	 UUkobKqqFgqIw==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b8845cb580bso75821266b.3
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 04:47:55 -0800 (PST)
X-Gm-Message-State: AOJu0Yymn8wDtcFYY9iwHVFdU8LwcS6sc1JAUagBo+3g47epHenzM7KF
	4i8/Y1IMTdYct3B1h+usAUZf/s2TyP3ieekZgQpnOqkzQ/EDqdt0ORb/M88EZMscjwzNg43UnT1
	26APigi3WbVcNZ8hH9PwM/mA2n1lfQio=
X-Received: by 2002:a17:907:3f11:b0:b88:4fc9:a1a9 with SMTP id
 a640c23a62f3a-b884fc9aa1emr11455166b.6.1769086073991; Thu, 22 Jan 2026
 04:47:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1769024269.git.metze@samba.org> <0ea7ea3ae6be53898f3061aab481687ae41f7c1d.1769024269.git.metze@samba.org>
In-Reply-To: <0ea7ea3ae6be53898f3061aab481687ae41f7c1d.1769024269.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Jan 2026 21:47:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8HyWTaXVcwAoDeKpaUEqinHSgUQRzpdWOXM0mF8UtA1A@mail.gmail.com>
X-Gm-Features: AZwV_QhwHX5s6tH3QApzvhEJ9Wa8GD1YOCN0QwBym4v9p--uY_0F0CkX8nzJcns
Message-ID: <CAKYAXd8HyWTaXVcwAoDeKpaUEqinHSgUQRzpdWOXM0mF8UtA1A@mail.gmail.com>
Subject: Re: [PATCH 05/19] smb: server: make use of smbdirect_socket.send_io.bcredits
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	stable@vger.kernel.org, Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2026 at 4:51=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> It turns out that our code will corrupt the stream of
> reassabled data transfer messages when we trigger an
> immendiate (empty) send.
>
> In order to fix this we'll have a single 'batch' credit per
> connection. And code getting that credit is free to use
> as much messages until remaining_length reaches 0, then
> the batch credit it given back and the next logical send can
> happen.
>
> Cc: <stable@vger.kernel.org> # 6.18.x
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
