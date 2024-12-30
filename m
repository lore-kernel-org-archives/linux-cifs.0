Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F871A76DD;
	Mon, 30 Dec 2024 13:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735566812; cv=none; b=M6ISzyOL/fzenIV4S+y0MnIYpyT/s831gfNfxx94hnMJVmMimQCTxl4nLE2OfiXJXWfd9TQNCl4N8fDg3Hhdm5ro5bcmlhPpdzCRCfW4Xa89ycocGqnIgPMFkbIO+4LJeTnP7tg+nkEWYGgZJGiBWs5d5jvZaVJC1Z5UrKFDVBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735566812; c=relaxed/simple;
	bh=oR+/BNP8Aiumkd2x2wNITN+nM/UOdOlArvQo+TiLSag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p+H9Kv1qZ0gSczYYDI/evDAuZf8Y2Ja3uajBz+vHLplm3ABPO7BXkqz/cOeG+BBh5DH6FvkpuJNOPWUO6qVaZxT+V8FAZ0DzTFH922EgZjzXfzsnoItsKtPYfUVinqK/PyeXbSXGtnoxRT1wu5LLEnMmootg5FjXKQln/Q8PDZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LhjncJ5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LhjncJ5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B270C4CED0;
	Mon, 30 Dec 2024 13:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735566812;
	bh=oR+/BNP8Aiumkd2x2wNITN+nM/UOdOlArvQo+TiLSag=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LhjncJ5EPdDI0u5PW8zNIpBNZw3Zlsdpn8/KLUxz6UVA6giliKgFrM5SbYbsK2Ahe
	 aGsCGcm0L2Yu5FKcRuK0E6fP53U59bZvjPSlFyZdXjULOGsRN2um0Xa9tDw7kSCc6R
	 44cSsts1+cio53P3QGicW7cu7Zgdm6CHnUu8soiWhqgHK6BKXtoM/0bn1BL8YuVavd
	 Ob1kTI/MzKlVkJa/i3Us8vmQX/a/MXHQofBhsjAYLb8Ose+e1aIWhd4U3dX2LUO7kH
	 PedbVLY7x9hAbVfCaJldLJkGjPTji3VuVfptF45tLkYVOxVcYjwjNGMlIUgPIf2AVM
	 Zn9Bm+fOELMxw==
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-2a7ccb2c618so4788421fac.2;
        Mon, 30 Dec 2024 05:53:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW6WHFXTQDmgDucgBiKkHbLq4CvAbE8cvMRZaTXg7bFg8Vqk+8RRj3M2lZs1tQEK/vfv47b6Yg/1oAc@vger.kernel.org, AJvYcCXkFKXZAWy3jgMx1yd4ZdyMiJ6lMbqeVLEQ3PcfKB6uNuZP+Qmtf7FbHLIUjQc1UeViN/lORb6HnLQaSSRo@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq0wP4wYi2iRzPchF/OCn5L5mPIDHSWJhBGo26imhMIX7m3hLC
	HAeSfGGOg/7+SBkpd5WuJYr1eL2z04+0IsXmE9agSqtje8FXOiCbS3N6n7DrN8P0nQDFACefFSE
	7+KeGxMwQXYO1SCKi20qTg6P/T/k=
X-Google-Smtp-Source: AGHT+IEE/+VbOcNTXjv7B8uPV0bmXAQ4R2dcw43W8HBYZbN3xrYUl67vRLQQ3jF6IS/aBKU7pspOWASZuclisiYU/v4=
X-Received: by 2002:a05:6871:a401:b0:296:dded:7c14 with SMTP id
 586e51a60fabf-2a7fb558c24mr19195968fac.36.1735566811480; Mon, 30 Dec 2024
 05:53:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241230124457.884986-1-thorsten.blum@linux.dev>
In-Reply-To: <20241230124457.884986-1-thorsten.blum@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 30 Dec 2024 22:53:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9uJTxLgN+P1TkSwCV-C_mVf2AuDad0ACfhm26148hL6A@mail.gmail.com>
Message-ID: <CAKYAXd9uJTxLgN+P1TkSwCV-C_mVf2AuDad0ACfhm26148hL6A@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Remove unneeded if check in ksmbd_rdma_capable_netdev()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 30, 2024 at 9:45=E2=80=AFPM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Remove the unnecessary if check and assign the result directly.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Applied it to #ksmbd-for-next-next.
Thanks!
