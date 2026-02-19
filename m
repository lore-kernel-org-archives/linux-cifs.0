Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E3E218ADD
	for <linux-cifs@vger.kernel.org>; Thu, 19 Feb 2026 01:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771465797; cv=none; b=NiqV7SONshwUVoTZuyKQgcTTH0uT6J2jEVnJLvDpetefrrXBDcfslIgm9hqMsCPP0ap4FUPknrhc7tOunRKFeIV6ddBJuQMExS5agfNbMv03b0dimDmEwIXYeMa8GCk98WJ9uTFmpOZ/4HnxT2e+r/nTOIozx1MwiXunSFdhU78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771465797; c=relaxed/simple;
	bh=gprzKwyelAnbTbil6irDP/l70Ksm+SSNMddfdQb9Y4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bw7TdRWAae+yUWIdAJpGr9AcVEsBhOTVh2A50s4wIoOwquwBKn8mtPq0cZudrXCD3Rboh45X0PgIoiN8UtFsDyra8TNyTD1VhSoEARDyJyJKb/kUqegxxlQ4u0NfW1Otuvz8QOsndeQiQxmNcc1W2uQSuCalI2cocZ4HvK//qrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CTPd/F9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CTPd/F9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EA6C4AF09
	for <linux-cifs@vger.kernel.org>; Thu, 19 Feb 2026 01:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771465797;
	bh=gprzKwyelAnbTbil6irDP/l70Ksm+SSNMddfdQb9Y4U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CTPd/F9QCBL2pXWHEWRBD2xpt13a3jkq5JqEJ0eZBXBZbCMy+H39GZ1l7RXkZXabp
	 KmPjcjZ5y+VVTZL3CptTyXurTzm9xeIn4q3Ek6S/Z80nz4Zh+HyWhrW/aTrnAfavce
	 kY2xaO1O0Dr67XxhNYNFz17FF41KipWvdM+XYTtr+LEopCkmk04HdNri5zCqkCQ1Sd
	 3Ge38m50C7h3/MNQIaSWIzd/UGNBTDedTN442ZDp5UtQRH88d/znZxjkpxim4Ehgmx
	 aNHkoguGhibStCtxCFyuGZm+BhLMYaKehLtkFv1gVwXZDhuJ/rirK/cefzYvIcrebB
	 ZV+LBWRMfkHnQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b885a18f620so79961666b.3
        for <linux-cifs@vger.kernel.org>; Wed, 18 Feb 2026 17:49:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXw4eDDyRbXxYPeMz7rc4keCHINwa/VQhQ3UCscg10wz3NqMSjjdIXRCnFaEbjgXphLiGTXX34P0ljz@vger.kernel.org
X-Gm-Message-State: AOJu0YyhrMUpb8EqluAgiszLLgQKZrmRr4TDHuGNeT7Ug8KLw0rgXlYE
	vZ6erX3ZhZp284zbu4k+AnzWyHCRiM8rtlPC4pCxjqnCjmVJVHgU+qul4mzQvkh7jjo5lbVPEIf
	oYDp3qi9aizvwY+7fm+MoXXb6bVKDLw8=
X-Received: by 2002:a17:907:f509:b0:b8f:9d12:2386 with SMTP id
 a640c23a62f3a-b8face62ee1mr1051037566b.51.1771465796016; Wed, 18 Feb 2026
 17:49:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260218213501.136844-1-ebiggers@kernel.org> <20260218213501.136844-13-ebiggers@kernel.org>
In-Reply-To: <20260218213501.136844-13-ebiggers@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 19 Feb 2026 10:49:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9rQ+pqZrbsBAc+poE5TW7RUBXwFZ-w+zmZ73P_DBxWvw@mail.gmail.com>
X-Gm-Features: AaiRm52LC0cRCytNvmZP31u5klrDIWh3l86YDetcbx0CAz2pxLOClyB6yHn1x6Y
Message-ID: <CAKYAXd9rQ+pqZrbsBAc+poE5TW7RUBXwFZ-w+zmZ73P_DBxWvw@mail.gmail.com>
Subject: Re: [PATCH 12/15] ksmbd: Use AES-CMAC library for SMB3 signature calculation
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-kernel@lists.infradead.org, 
	linux-cifs@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 19, 2026 at 6:42=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> Now that AES-CMAC has a library API, convert ksmbd_sign_smb3_pdu() to
> use it instead of a "cmac(aes)" crypto_shash.
>
> The result is simpler and faster code.  With the library there's no need
> to dynamically allocate memory, no need to handle errors, and the
> AES-CMAC code is accessed directly without inefficient indirect calls
> and other unnecessary API overhead.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
