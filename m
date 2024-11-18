Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E982907;
	Mon, 18 Nov 2024 02:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731896285; cv=none; b=bLb/vb+PDjAdde0sqigm1zr5KdxD40wxvFF+fsLxmdCczPX7rp3OPKxLR0YsqcYeyJFvjJkvNRZ43snUI9WIiKhltvODSANX4sRi1Bo7tk5VQd1wcbCaFTlPsyoDNVzUkz2IQET+XCEThuz00zKEoHIjPS5OWdIokchtU+8j5nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731896285; c=relaxed/simple;
	bh=bup4rUewPp03t4U8vjVhWSVu/1bFX3dKG/XZG/QXuIU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZFcvVwtkv/iSiE1QTZbPivrOXJkidbvxCW9YMIxKF0E51mhVOjJz/WDt9/jI4JwLlu/UkDBPYNnBRMwYhXM4MTvHI+MCh8zX+hKMzsY8+ZQmIwPaeyJkduz4hnCSLjpQiyiPW3SeFygfJzGRwm7UUUMeomVZ0pLX8nDMJAeRZHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u2rEQ2/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u2rEQ2/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40709C4CED8;
	Mon, 18 Nov 2024 02:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731896285;
	bh=bup4rUewPp03t4U8vjVhWSVu/1bFX3dKG/XZG/QXuIU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=u2rEQ2/jAXp+XURt0u3TA4By7SrBimi8OBpG434o/ivR6W2IZlI1WH6P18rJOuxjT
	 a+2blm7kv3VeSEl/Mgw0SJWUB6CaIqx71xzqdmf9ppQboQYN/Vg0eRUK5/yJvsZ7ur
	 84hUitT4p5h+FhfntlrQ6nnkRiiXtGUqBBhiMOqqm4hNquNmqbyrEI8qipByYal7UJ
	 xk3sUHv2iIr8VLKVCQGFKqnvTNbPDR4jt+ifQlD2Jom3L1O+nefr8MweJcL2Eg8xvY
	 YGg0f0BAXwaW2saVnB4dyIDEFwyXvTCuXns4sW3NJYfAy2Uubhcp63ddKLgE1s0Ola
	 w2N15ci6w6gjQ==
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3e5fbc40239so459037b6e.3;
        Sun, 17 Nov 2024 18:18:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVv56wDi0qGxqR/TgwHD2wcCo3bjO8f5eax91O8j3ucF11uzY42ZdXCBHVY8OS6SgwuHNkOqenlSOp9@vger.kernel.org, AJvYcCWr3cCvTs9+Qfct720TlYeV+iAZw8EgDpoNQJ7t8TC2yl6GhB1lBmrflsEqp2Bb6k9N0zLX+hEv/gKETlRk@vger.kernel.org
X-Gm-Message-State: AOJu0YyABQCXuW5QLqtyzVUW1UDlmTBNNOo4+5QgrdfU1JgVF2o4y6du
	liGvTE4zzG7rFZ/YXQj4CiEu9D1TD+H0YTIFcjQpBKo0CO2uVGY8FjB8z9MOR/HSulaAdUX1FnC
	3QxBIURiTy0ENXH+Wg7u+lYPcV74=
X-Google-Smtp-Source: AGHT+IFQlhJVEGO188jp6Uyc1QT8eEFtfELf30pohcInWrKUP0IAFJLg/sq0Jtu5VDga+1vna/t3VWHsCOPlW+PPPyA=
X-Received: by 2002:a05:6808:189c:b0:3e7:b9be:5480 with SMTP id
 5614622812f47-3e7bc7b1d61mr8158067b6e.7.1731896284500; Sun, 17 Nov 2024
 18:18:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241115083240.230361-1-vamsi-krishna.brahmajosyula@broadcom.com>
In-Reply-To: <20241115083240.230361-1-vamsi-krishna.brahmajosyula@broadcom.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 18 Nov 2024 11:17:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8pWn+fY=kAX_inrAS3TxmSB+qrjDSr7gZq9dn2P5Nfcg@mail.gmail.com>
Message-ID: <CAKYAXd8pWn+fY=kAX_inrAS3TxmSB+qrjDSr7gZq9dn2P5Nfcg@mail.gmail.com>
Subject: Re: [PATCH v6.1 0/2] ksmbd: fix potencial out-of-bounds when buffer
 offset is invalid
To: Vamsi Krishna Brahmajosyula <vamsi-krishna.brahmajosyula@broadcom.com>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org, yuxuanzhe@outlook.com, 
	stfrench@microsoft.com, sashal@kernel.org, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com, 
	vasavi.sirnapalli@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2024 at 5:32=E2=80=AFPM Vamsi Krishna Brahmajosyula
<vamsi-krishna.brahmajosyula@broadcom.com> wrote:
>
> The dependent patch (slab-out-of-bounds) is backported from 6.7 instead o=
f 6.6.
> In the 6.6 commit (9e4937cbc150f), the upstream commit id points to an in=
correct one.
Looks good to me:)
Thanks for backporting ksmbd's fixes to stable 6.1 kernel.
>
> Namjae Jeon (2):
>   ksmbd: fix slab-out-of-bounds in smb_strndup_from_utf16()
>   ksmbd: fix potencial out-of-bounds when buffer offset is invalid
>
>  fs/smb/server/smb2misc.c | 26 ++++++++++++++++------
>  fs/smb/server/smb2pdu.c  | 48 ++++++++++++++++++++++------------------
>  2 files changed, 45 insertions(+), 29 deletions(-)
>
> --
> 2.39.4
>
