Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CA885640
	for <linux-cifs@vger.kernel.org>; Tue,  5 Mar 2024 12:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709642626; cv=none; b=pUZNMY4fIQe1jYSUT4ltEl1ZUisS3mZP9BHiQV2vQ311VLNL7/+l/3AqbAEw3cU5R++HSBn+VUTI8twFpkBEiWvxltxf9l6Pr7pTadhfjXiz96ZSBDVLBbnCnUTPjqyxa1laBMefxhFgUkIZKeVTerjwlOZQLmgZy47Es70HUe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709642626; c=relaxed/simple;
	bh=hqXu4Imvd+YZYd3LEDpX+ZnPOXEZjX0E+C7N/22uaKY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YKmpfLfUzdUhJDMkmN2FuS6/ucTDcWjkIy5xZRoEGVxdz3kN5ad4AFRutdCweYG5blMe1es7QXLU7evo6n7AouyT3bj9NUMQ/OCt82NDMnm4Nd/5lxAK1Ec7IZ61DpxWNMLo4Y/udmGeQekfNV/jYED4OlwTT5mW8ZoLxQh7Yu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=dKC+KEve; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="dKC+KEve"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d3b93e992aso27908751fa.1
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2024 04:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1709642623; x=1710247423; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hqXu4Imvd+YZYd3LEDpX+ZnPOXEZjX0E+C7N/22uaKY=;
        b=dKC+KEveoMrJox2JYoN1rvvJPEQQ5mCmK3iLWi4q4dPWC+fFRrXaIlNn1m/iKZ10cP
         nZeuPDRqkY+/3JruQ5n7cNfVoY9390s/JhFXC1tW0Qhc1LLfB2JFqWhBMHgPOxs48N93
         WQ+YO514bBN++CfZKG7X0nrtv1qxDtPJMscfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709642623; x=1710247423;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hqXu4Imvd+YZYd3LEDpX+ZnPOXEZjX0E+C7N/22uaKY=;
        b=fslBjQX1PMgns6xmezkBftd5kDVD2Z7nQIaMTqmKggCkMdd1bAyFn2T/lqBr2O6HpC
         lHH2EhoxtyWhyawbUmvx3TPeDalyuSqz48WgXchwOyu3LO86YiHlr9h+TILzJrnY5xjf
         8x+20cjp8BOimsMb1imEyGGDAWlas9i6H0wC1n0EZX9ao5QYIjg/RXJvODB75TxKMqAx
         JXI/D3/z9e9y9AGhrPTaUxHotJwkofvFT4qEGzkdwQGcmYTLeJNw4NJaLKBo+larUAyQ
         FjP2Z1ndjRXe6kFek0NpHk8K6hf1y9ijwI4ZUGAPbCAdQByfjWTDNRg3BNywxhWu3erT
         z/iw==
X-Forwarded-Encrypted: i=1; AJvYcCX3EYCYdgiL8V1b2Rujid9bfNlvZPReCgi9Bn58TXJ7Knwet3gLVeQsfLSRl3+ypros74/4QY7DclNpxLH85LDdhpQVc8TFTiKA4A==
X-Gm-Message-State: AOJu0Yx8Ev/wwuEdebcchGfcwV6m+FvOXQF/OkMrIo/GvUrv4Pl5ZGhK
	Ko/70W6yzUsNoKg3YhJiaOqbGg0KeG9pF2hPfV5407LIlwuRT7qGhwftyTW1n7dzrramUKidwk1
	0sxJecoBEv7JxoJNj2TeCFN+SduoNq1avL0h91Q==
X-Google-Smtp-Source: AGHT+IFDaUTfRvZDVguiUspJ8bW9xNWfKoMVLiqWzzQ2oinl9J77SQ70Ly+nbCnni8ZMPAqYVspxryxBQbzNkvrnVDU=
X-Received: by 2002:ac2:5e7c:0:b0:512:f5af:3bdf with SMTP id
 a28-20020ac25e7c000000b00512f5af3bdfmr1088535lfr.68.1709642622758; Tue, 05
 Mar 2024 04:43:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240204021436.GH2087318@ZenIV> <20240204021739.1157830-1-viro@zeniv.linux.org.uk>
 <20240204021739.1157830-11-viro@zeniv.linux.org.uk> <20240205-gesponnen-mahnmal-ad1aef11676a@brauner>
 <CAJfpegtJtrCTeRCT3w3qCLWsoDopePwUXmL5O9JtJfSJg17LNg@mail.gmail.com> <CAOQ4uxhBwmZ1LDcWD6jdaheUkDQAQUTeSNNMygRAg3v_0H5sDQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxhBwmZ1LDcWD6jdaheUkDQAQUTeSNNMygRAg3v_0H5sDQ@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 5 Mar 2024 13:43:31 +0100
Message-ID: <CAJfpegtQ5+3Fn8gk_4o3uW6SEotZqy6pPxG3kRh8z-pfiF48ow@mail.gmail.com>
Subject: Re: [PATCH 11/13] fuse: fix UAF in rcu pathwalks
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 4 Mar 2024 at 15:36, Amir Goldstein <amir73il@gmail.com> wrote:

> Note that fuse_backing_files_free() calls
> fuse_backing_id_free() => fuse_backing_free() => kfree_rcu()
>
> Should we move fuse_backing_files_free() into
> fuse_conn_put() above fuse_dax_conn_free()?
>
> That will avoid the merge conflict and still be correct. no?

Looks like a good cleanup.

Force-pushed to fuse.git#for-next.

Thanks,
Miklos
