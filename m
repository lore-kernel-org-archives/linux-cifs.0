Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2231C2AE78
	for <linux-cifs@vger.kernel.org>; Sat, 15 Nov 2025 07:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763192759; cv=none; b=mKt5sGBAwHsCLIge1sLSMVTsJJ3j/dwrqsPON8zAEG9ynQbXSWj2w2+CgJ8sVd6ckX96aIKygu6kjrqPFdFh4XBnf5SCmKAv+m2CwfcC30E1Cq05Z5oe/+ZJnkB9YB6WI1+fe/BzYlEAUpTMY98FWw+Ng0vhSc8kH1Kkx6/YPcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763192759; c=relaxed/simple;
	bh=b0OEEb+jZR4MNOdIK7IKfneCzqrx8sYjM4Vnq0B4D6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AXPaJQfDuzAtta1CgpLnp0S8xxDrlA2Iy9LB+pnkzEKzxLtIKYvyA4bfqSschYoWnd892lQjDBPdOmJXTeAtJoKZVKet0b1d6oIKJhLFKL7wVZ49EG/wg6P8SRr1vkxk//Hi+2M3zAQx26GipEKABtHbFblpUF2rcrjnmnejAF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qtmb3qde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qtmb3qde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA20C113D0
	for <linux-cifs@vger.kernel.org>; Sat, 15 Nov 2025 07:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763192758;
	bh=b0OEEb+jZR4MNOdIK7IKfneCzqrx8sYjM4Vnq0B4D6U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Qtmb3qdedDCNiZO/02h2ds1ZkKUuE8QmzpFWlcDmlMZbzgXmh8w1rnz3vnEJyLE5q
	 sglCZW8jLp5zWyo00aHz6Ey60FfYad8luGa83PqbEkSxa0ABIk8Pgncvrt5tK6zSAR
	 +sMwTxXs3kgPqivOhTQDyQ6+TLCG28aOsgnsLaMx6kqcsTGCQ/cbi3ReAAOQtmY/hq
	 HzeBBX70A6hXjn2S/nr1XQxPyhhsSv3hwfmPGkxHHigzzx3ybaJ9b30SFBtJCpYWG9
	 sFVO1VPKRVlM7dtgi5mfwKIIang0j2AYASmKM06AKh5MvhrMQ27pKAxPT6X5lJWEsP
	 0Z/KxkOb21YhQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b7370698a8eso157149666b.0
        for <linux-cifs@vger.kernel.org>; Fri, 14 Nov 2025 23:45:58 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVQDQ9I/n/9d++xVj3091XGtRoyvfz+6QCIuHDcrCCOGYOGaKqaewCv1IhymJMKuKZZqW02klBOeWzA@vger.kernel.org
X-Gm-Message-State: AOJu0YzaM9+pbnXGvPQ2o08q9oXm8lvR6QnVxId48OwxA74fUGedYqDZ
	X9WVYry6IjF/ccKYgVGS/0nd+UX6fwN3Fgn7OqimsgtWeckmWFOKKWDflB4ROj5izNe2YkgxxPq
	kAWYSiGzQowkSS0CHX8D3ffhJfuxYl6c=
X-Google-Smtp-Source: AGHT+IHsgw+PfYrWKbbcQI5Pe+yQPOwX4OC/RkXQA8eqINt5TGDmKzZP6c8vNrF1BesS3y1USAkinfkhnriwlQCAtgY=
X-Received: by 2002:a17:907:874a:b0:b73:6f8c:6100 with SMTP id
 a640c23a62f3a-b736f8c6d99mr460072266b.39.1763192757227; Fri, 14 Nov 2025
 23:45:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113133252.145867-1-chenxiaosong.chenxiaosong@linux.dev> <20251113133252.145867-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251113133252.145867-2-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 15 Nov 2025 16:45:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-EwaXmNViyUQMgPb-bPfpUPuoSQ+6GWdbqA5nZ-6Z97g@mail.gmail.com>
X-Gm-Features: AWmQ_bkxGIwNEB1cgJJxsleOqO9vhnIee0Oq62wJJ0XaXIqvn324fi8ag7P2jlE
Message-ID: <CAKYAXd-EwaXmNViyUQMgPb-bPfpUPuoSQ+6GWdbqA5nZ-6Z97g@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] smb: move CREATE_DURABLE_RECONN to common/smb2pdu.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, chenxiaosong@chenxiaosong.com, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 10:34=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.d=
ev> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> The fields in struct create_durable_reconn_req and struct create_durable
> are exactly the same, so remove create_durable_reconn_req from server,
> and use typedef to define both CREATE_DURABLE_REQ and CREATE_DURABLE_RECO=
NN
> for a single struct.
>
> Rename the following places:
>
>   - struct create_durable -> CREATE_DURABLE_REQ
>   - struct create_durable_reconn_req -> CREATE_DURABLE_RECONN
>
> The documentation references are:
>
>   - SMB2_CREATE_DURABLE_HANDLE_REQUEST   in MS-SMB2 2.2.13.2.3
>   - SMB2_CREATE_DURABLE_HANDLE_RECONNECT in MS-SMB2 2.2.13.2.4
>   - SMB2_FILEID in MS-SMB2 2.2.14.1
>
> Descriptions of the struct fields:
>
>   - __u8  Reserved[16]: DurableRequest field of SMB2_CREATE_DURABLE_HANDL=
E_REQUEST.
>                         A 16-byte field that MUST be reserved.
>   - __u64 PersistentFileId: Persistent field of 2.2.14.1 SMB2_FILEID
>   - __u64 VolatileFileId: Volatile field of 2.2.14.1 SMB2_FILEID
>   - struct Fid: Data field of SMB2_CREATE_DURABLE_HANDLE_RECONNECT.
>                 An SMB2_FILEID structure, as specified in section 2.2.14.=
1.
>
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
I have changed struct names like the following ones and applied it to
#ksmbd-for-next-next.
 - struct create_durable -> create_durable_req_t
 - struct create_durable_reconn_req -> create_durable_reconn_t
Thanks!
