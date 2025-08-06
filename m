Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0593A10E4;
	Wed,  6 Aug 2025 02:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754448129; cv=none; b=q/QUqUv3ofhVdkkWOiu15ellXjB7ENlgxLnFvIxuRdT8T5zbLwL8EfLX6Isij/LGf8vLGGjuQ7k+uSJtQNJOusgtvw9NLCuy58Zv36aNWjpTFVZZ2YMueKTLsIS5i7Zw700FqaPww/EDXdAceM05e9DWGOyr8+gPYQR/EpNxci8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754448129; c=relaxed/simple;
	bh=njrD2uEvhzKLIyfcLKc2LojwM8VL4PvMgoEr5zFcRJY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wy7CLrXzse+4bzI6KuoHiMYgckPV4TJua9+lU5TiWwommxlLbpzIDpnyl8/s9fjI/pvCk7Hsh2xO/5WWDw7T9WSfO6bfjLkCQS6ULzzWiqiDCh/Auum6RUpj5T0PxlY9aT69/SL7VWQtB7tqfcA5cyA6/bZSA6fqJxCmK9pU3Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WkSIS0wC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WkSIS0wC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE1BC4AF09;
	Wed,  6 Aug 2025 02:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754448128;
	bh=njrD2uEvhzKLIyfcLKc2LojwM8VL4PvMgoEr5zFcRJY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WkSIS0wCjsae2wk0pvHZXNNSE0xec7Tpy4axymTZypGsPRdD2unoULvN6oDEK8N9B
	 MClbxgOpyycm8FsW8PGbvScpBJHowT7p5FVNoQCrbp1Y8rqlnd3/TD5WAYzPJ3gg5o
	 hH3/Z3Cdhf54wvxCS4Mf+dGnRLXGHCFm61Gv/Qn0lsuCpZwbeE4onRIPoivacg6jWg
	 tv12b8iq4Wb5fWPi6noM0MnCfaZ9tWcdOzkZ03SfWeylIsQNA4X1gUaFD7OFpr9dQk
	 PaT+irNb7FdjYr7jTuMmR00erbEERNo3PEbtPeU4Mc9eIHGTIyjCyM7Z2I5CsjnAaL
	 8SMILan1XE6Xg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-af98841b4abso177678466b.0;
        Tue, 05 Aug 2025 19:42:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW3G+4R41yszkOOMjJl6N0gIahBQpfq9YMOJw3B7ON9bJxMFWmM6/fV1PpFSPfOrxJ0SOdDMfe7@vger.kernel.org, AJvYcCWQD2fTY85A6EBWbQMJXD9nhyrS7jcVSbnUR7e2nPHjjQF0O5jmHl3TfoBLEg92FCEv38UYznDZ3qrGsfBv@vger.kernel.org, AJvYcCX6HZtQzqe/5yH+Pd8oxadY5Pkeq+Xilgn6o/hNXWA4YczKMAgp4YK6gsdDA1YhjOwZtAOQkZuF56zk@vger.kernel.org
X-Gm-Message-State: AOJu0YzMD10g9V3rJXDpLs2BQQ9ieHEF6Ci+mrVSC+fKvDQfKqvT/0ee
	jC6K13jWHd0bpzcYfon8PE5nqkDk5cpt9GR3LN1zjeKexeJyqRfDqSDAahleeQpzrP5ihGETm9B
	q2lXgMdAnZYX1aKolm6rIsXdFCuUYxDg=
X-Google-Smtp-Source: AGHT+IH3A7FQoEaMit/cVYoWseOTTbtTlZti8PYqVwGAZdBcGN9tMrCDg2uRMEe4eB7QCp8aKC5j+nzA/nzmqugskyY=
X-Received: by 2002:a17:907:720f:b0:af9:2e26:4636 with SMTP id
 a640c23a62f3a-af9903f0581mr109720466b.32.1754448127139; Tue, 05 Aug 2025
 19:42:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250806010348.61961-2-thorsten.blum@linux.dev>
In-Reply-To: <20250806010348.61961-2-thorsten.blum@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 6 Aug 2025 11:41:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-43SFJNDEk3CwzXZ5SDVmpDbj9aG88hGAp=dCv63JCtA@mail.gmail.com>
X-Gm-Features: Ac12FXxJXCnaiYx61rOjU6Uck0w4ewXqPZzgC2mgCeRxwiyo8_QkD1j_vN2Fc5w
Message-ID: <CAKYAXd-43SFJNDEk3CwzXZ5SDVmpDbj9aG88hGAp=dCv63JCtA@mail.gmail.com>
Subject: Re: [PATCH v2] smb: server: Fix extension string in ksmbd_extract_shortname()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <lsahlber@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	stable@vger.kernel.org, Steve French <stfrench@microsoft.com>, 
	Namjae Jeon <namjae.jeon@samsung.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 6, 2025 at 10:04=E2=80=AFAM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> In ksmbd_extract_shortname(), strscpy() is incorrectly called with the
> length of the source string (excluding the NUL terminator) rather than
> the size of the destination buffer. This results in "__" being copied
> to 'extension' rather than "___" (two underscores instead of three).
>
> Use the destination buffer size instead to ensure that the string "___"
> (three underscores) is copied correctly.
>
> Cc: stable@vger.kernel.org
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Applied it to #ksmbd-for-next-next.
Thanks!
