Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A5B41A542
	for <linux-cifs@vger.kernel.org>; Fri,  2 Oct 2026 10:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790937387; cv=none; b=JYhzSveXFBVrQ4LE731pPCqb2KOFRYrvjFzX2UG0NoG+zq2kFFoGHkwI3tkylItWp5ged+x0QK55qpCRSTJY5zyHTWe+qrOljxP+/hAdq/mzDaP2c8nA1HMhdoGv46jnhu+Z7I2h8uRKp0TkO9wQy0ya/pJFXEwecM8Z3ynO8No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790937387; c=relaxed/simple;
	bh=RON37IV3ohc6Tz0dFpFuBeggvV7j8gYSLt3b/6TZoUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kKmA2w8KnzcfvmX0rn5Nb4iiVLjuiF0wJccs2vDNHEIkUE4+WVCjVxIlq7R2EV7UQOxSVXzVeaB9jbpmUgU4NQ0vd+98xJ2C/ps9YfNTlhxMvF/7LvS/3uDRBSOikCY8vnCtGAV+yQ60cqm+VeIHnOdB2s/Xnk6nTMffxauz1bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QbEc0O+q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QbEc0O+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2EA1F0089A
	for <linux-cifs@vger.kernel.org>; Fri,  2 Oct 2026 10:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790937386;
	bh=RON37IV3ohc6Tz0dFpFuBeggvV7j8gYSLt3b/6TZoUo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QbEc0O+qm2zUWlphPT4PsDPRYkmXKrHHWmaVa6ybESUK3kEBpHCfwy/mRogkOAFYu
	 WWcPBSyLXvJytH/WObr3s8kWqKv0uApf8qFPHkBZnn1Gw0T05+PpWHP5ZV3Go1WEbY
	 PlS6IhSo9FMlQmfGU5fvzFHhNlla+x0Zcn4qvw23SHBK4EF1KhZfQQqBanmZhZ16ZP
	 RC655Nnl4kmSgd01sITjZvD1D+a/h/5oYhTtjLWVDpfxU0IYC1TkSl4TO4zu11NUob
	 j0bb9FJUW9dxwXHutYUwHgpPg+ZSwxxORmKY4JMzm5Kn2bLhKIuyNoqmVX7MbFNZQv
	 XJ6oeQHhSAEZQ==
Received: by mail-yx2-f38.google.com with SMTP id 00721157ae682-8ab41af29caso41957887b3.3
        for <linux-cifs@vger.kernel.org>; Fri, 02 Oct 2026 03:36:26 -0700 (PDT)
X-Gm-Message-State: AFq9FYI3WYVXq3nBdeOQby+SKlXzzE2u6SBqi08BcfKn72+FcM/uEBYe
	YVATqZJk+FNqqzugfE8ynA8HADP0NQICpWOusRH79L0s7+FB5OTQpvtt0V01oeySC+SoGBK+fHF
	TJwtxYNqlgXm0bNkDgm0KJrTbJVuDoN0=
X-Received: by 2002:a05:690e:441b:b0:673:4a02:a126 with SMTP id
 956f58d0204a3-677abf9f160mr660800d50.33.1790937385846; Fri, 02 Oct 2026
 03:36:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260929161930.1894929-1-zhangdairui@gmail.com> <20260929174902.1899561-1-zhangdairui@gmail.com>
In-Reply-To: <20260929174902.1899561-1-zhangdairui@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 2 Oct 2026 19:36:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd90goLZXJvkS+Ke0o=tjEdxuzu5KK0UWDoyUyb9GPg7zQ@mail.gmail.com>
X-Gm-Features: AclHuK-cDzq1Tnza55HV0pLxYQ4XzqVVgRH7cSWNkZ9MwcCQ8-cQ93-_bDMSeu4
Message-ID: <CAKYAXd90goLZXJvkS+Ke0o=tjEdxuzu5KK0UWDoyUyb9GPg7zQ@mail.gmail.com>
Subject: Re: [PATCH v6] ksmbd: verify transform SessionId matches the
 decrypted header
To: Dairui Zhang <zhangdairui@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, pc@manguebit.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 30, 2026 at 2:49=E2=80=AFAM Dairui Zhang <zhangdairui@gmail.com=
> wrote:
>
> Namjae, Tom,
>
> Re-checked v5 against the updated MS-SMB2 text. The ~0
> exemption was my mistake - the spec has no wildcard for
> non-related operations. Dropped it in v6. The other checks
> already match, decompression included. No other changes.
Applied this patch to #ksmbd-for-next.
Thanks!
