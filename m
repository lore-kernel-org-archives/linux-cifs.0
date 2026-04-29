Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B0643C055
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 22:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777501023; cv=none; b=cl1vYVq6/eK38GGgpIvZzYOSSs+0JRbxtCu3JaR1am/CU4dH8qCHPMW2uMObOfXzMhVXz1Ei0PGu74aheaFMsKYnWEh87h+UcETFv6svSAjQpxsmJNk4Mtg6HaHvQz1cZdaD8+DEGai5XnQ/Hh23iq2JyBApHfOxqun17hvGmN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777501023; c=relaxed/simple;
	bh=U6wVEZglexU3hyekIkrWlMsg6wkVdutkVyGUKW0SSr0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nWrGAxaeuywbWrCf+eNqxw19QUIaKM0SfS3LiC4ImYnF3y/xLDl8TF0QTSjKQ6sCdVIV/klreWzwnV1tS2rje0ZN78Hb/+G9XVOowSpDPEW+4IbI8MCk8UVWCvNiq9e9Q+Z/FvTx+qVeDTDTrLavl24yFBEfjodl/hboXb/sKTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bjw9CWNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjw9CWNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C949CC2BCB3
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 22:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777501020;
	bh=U6wVEZglexU3hyekIkrWlMsg6wkVdutkVyGUKW0SSr0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bjw9CWNzstIrYsH1D06Y1fLzf9uOP0d6e48pSyHh57YxcPFZ4LZAzA0w5msfoyu86
	 28YGLjXhvs00+2vT2g8zTPqzgEqy4wfUn4h+GKp2pMGVZJMFguyc+7MvoP0taosxuQ
	 RYkCmCm+PKJ4KZwfXHrJUJQ9VUeKgBm9vPrKm75RNGYFw6vb9sggJDWKETzRhYglTB
	 RrZNYtwTyDkcEE62Sg0obDLpy4ktoqiHFqKhZNGI7OD4mHFjxDZWLOM3hPJZUJ0KD1
	 Uwqi0OgQ3FkxfFbVx7d5JQtBLUGeUW4ENq5sbmIe6PvgTi9ZXfNb2xiw3+8UquhxXs
	 bLcVRSjF48Rnw==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-671c24f23b1so388868a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 15:17:00 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz5WIg71G+3qp1xYVoirJzXuyCFk/Mwwer27PnZyuRPDu4e/n3+
	QZPafVoCkag0j+1yuQErbzj8a8Bz0pXg1QzUNRLEv0GEL//2YkfNbFIeuAGulDlYusTQHInfrls
	SYH4aIbIT9X2mtZz8LA0pjRz18/uhcQ4=
X-Received: by 2002:a05:6402:4290:b0:679:ba3a:b17d with SMTP id
 4fb4d7f45d1cf-67b5d848965mr63960a12.14.1777501019455; Wed, 29 Apr 2026
 15:16:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777463800.git.metze@samba.org>
In-Reply-To: <cover.1777463800.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 30 Apr 2026 07:16:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8DpU46d9Vnw8GFoazK1UmbgpTWUckomV_JLFJQOroCng@mail.gmail.com>
X-Gm-Features: AVHnY4IrTHzB3kjZ9J2I-I23PXkRkN7JfER773XowhMAqo4krDuAQt0SN57s6K0
Message-ID: <CAKYAXd8DpU46d9Vnw8GFoazK1UmbgpTWUckomV_JLFJQOroCng@mail.gmail.com>
Subject: Re: [PATCH 0/2] smb: smbdirect: symbol export and header cleanups
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2026 at 10:43=E2=80=AFPM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Hi,
>
> as suggested by Christoph here:
> https://lore.kernel.org/linux-cifs/aehrPuY60VMcYGU8@infradead.org/
>
> I've moved to use DEFAULT_SYMBOL_NAMESPACE and EXPORT_SYMBOL_GPL
> for the smbdirect symbols. This actually fixes a problem
> with out of tree builds.
>
> And I've created a include/linux/smbdirect.h
> which also make out of tree builds for cifs.ko
> and ksmbd.ko easier.
>
> Stefan Metzmacher (2):
>   smb: smbdirect: make use of DEFAULT_SYMBOL_NAMESPACE and
>     EXPORT_SYMBOL_GPL
>   smb: smbdirect: introduce and use include/linux/smbdirect.h
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
