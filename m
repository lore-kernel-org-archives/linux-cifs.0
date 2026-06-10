Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3C13002DF
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2026 02:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781057664; cv=none; b=TYG62JJ3ZPPMmztXPrWdbAKTT1tbgGpKwprYIJFBXkCiFNCqDEixl51VnHoR/Sp1fvKL4t2YeAauyobdYRK+8+Qo6Pde6Uq/tyoo4qKAaraIzn5AzUSgTmApHv/+uNwTlf0UwzsPxqgDOZAJHRomW7nVhls88GPF8BBCgBDMrn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781057664; c=relaxed/simple;
	bh=ujkZ2aIeVY6Qz11YoAD94fZrq2maHO5pJmW/qpgIWUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eAAaPueHgUAxRWmusD7PCCrpbz8C2OU4Yyd2FmaaHzL8nA7r4ghYbqYoMTQV0qOoeL3ozFDkic1+7wFUzr1STjIJPrGwieYXOsbAiW3wQEgO4p8Sep98kREx3M7YXsQ6v5UdKZUapcTsWccHo3QQ5PUyQ2QadUACagGTQK1KxJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5O4vbok; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5O4vbok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9671F00899
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2026 02:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781057663;
	bh=ujkZ2aIeVY6Qz11YoAD94fZrq2maHO5pJmW/qpgIWUk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=f5O4vbok1FeM2Lwsr4kdRfUl7uKlkFAqNLCX1XRuI4FZ2qgzQJy5IsG1QobqeWExi
	 9Iq0XbUpLKehdq9ecl8h7t3mKtsks+Uf0WTnzKMVuoVMsNlC/Z4QqHFTisg1VLRvZH
	 EdeZQn3cYlbpOgMcPFqilyUuJQTG2w3rkcoy6V51cwt5S3fupCECoqJnuJC5E2QvWC
	 yLJASV6TSOHg655paKdBZt92hBtMP2UUUKpVhuW9ecHWZief3ezD1mkhkYvr9xri0w
	 f7+vOiqNOp2Aw+UlGwQ1o9ceVBddZu/sfIEJkia0a6Gv0l/MPbXEopufVdt1hz4xg/
	 u88pN6qGeLJWQ==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-beb7f26ed62so713241066b.0
        for <linux-cifs@vger.kernel.org>; Tue, 09 Jun 2026 19:14:23 -0700 (PDT)
X-Gm-Message-State: AOJu0Yxg2S89phMGM6Rj9TusO5ocCn6unH6B66is2gHj3u5fdPxUCJqZ
	NJdgZWlTuhKmulpnpNVHjsmhNms6YvQYRwU7byfJACEBBL3R1lcH3e0fA2ez0CkjHn1mO4QZM8A
	402q9IaEDGTZQzdVuQLU9C37Zw3XOLdE=
X-Received: by 2002:a17:907:1c0c:b0:bd8:f919:5c0 with SMTP id
 a640c23a62f3a-bf938e23e8amr308827966b.27.1781057661929; Tue, 09 Jun 2026
 19:14:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260610014427.38708-1-enelsonmoore@gmail.com>
In-Reply-To: <20260610014427.38708-1-enelsonmoore@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 10 Jun 2026 11:14:09 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9bDPTMpKGabuhOJfRcimWOetL0YQ3Up2gzGXr=c+Mn-g@mail.gmail.com>
X-Gm-Features: AVVi8CfN6v5ZTdIGRkp8dpeE85q4bCT7jzGFpNDi3q57YhtVu1pszCe9XXZ1EWM
Message-ID: <CAKYAXd9bDPTMpKGabuhOJfRcimWOetL0YQ3Up2gzGXr=c+Mn-g@mail.gmail.com>
Subject: Re: [PATCH] smb: server: remove code guarded by nonexistent config option
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 10, 2026 at 10:44=E2=80=AFAM Ethan Nelson-Moore
<enelsonmoore@gmail.com> wrote:
>
> A small piece of code in fs/smb/server/smb_common.c depends on
> CONFIG_SMB_INSECURE_SERVER, which has never been defined in the
> mainline kernel, but was present in old out-of-tree versions of ksmbd.
> Remove this dead code.
>
> Discovered while searching for CONFIG_* symbols referenced in code but
> not defined in any Kconfig file.
>
> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
