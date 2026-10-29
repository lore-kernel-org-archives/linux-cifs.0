Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793261219;
	b=azWYqzGHz0OVZ0YnZyWedQPIpawkIWiGXXQrU5ZfxrLrT9GvOWHOciwQmWQQtfS21pDv
	 ECUouu6MFPI1E+NXJC4GuNpDGisebBDqmpcyvQfOBFXs1Lbr/aPfGnfOM7ZzHNfeuDk3p
	 Fw9vyOWKGMOdG1uePq9tp52498LZvVPJRhefW7m6OT2ev8/N+aJZ55K97thObeZDPvWBO
	 Gt6mCDCW2xl1ohMf5VzwrBEPULD6VwAZ3kjj1KOgkEwHb4bhjAHQwQ6AJdhLvQyjCFtdC
	 xcQeEykavX2VotHj0MzpZZqd4ytnLSGNHNpeDBDhYkZd+VrfcD3X5CGresMslPY8fgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793261219;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=DQA0c4GgJttnHROpDsPWPzxDnzeW3nyxJjlegQaZKTI=;
	b=CqPvQ6eKWNSglMzCU2flid55RVDGVFR5YkwvhpQslZA7rKtAMuKf/I3uXoas3fM4TKpx
	 5lW7egmVH2FZfsimtlu7PWSJ1iKFjn1Q3gpx/4n8yT9FJ0Dz7OMWQN8axiXFQkc8yKXoT
	 x03hO92Vk4qIIufg0nOLyTQJCg2rO7sNZIq2+9YijPLj9LVxPMr/3iTPLnI1bVAwqHZaH
	 ijflvbt2Hi7s+TP5lz6Bwf+SEewvTokN4jX0aqlyax2kvC78CI5YTdFAlpDUBF4lj4FqJ
	 GdvPNs5vzO84K+XMKXe33qOpr16jBIOg18Ahh+1BIBbq2UkUFyRHk/4mYGZl2WvK4/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B7A72a4f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9CC606A31F
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 08:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B7A72a4f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AFF1F01829
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 08:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793261217;
	bh=DQA0c4GgJttnHROpDsPWPzxDnzeW3nyxJjlegQaZKTI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=B7A72a4f8qIcgwIsnpX0bOK7EfEaWucmxSfnvkTwvXduwHlM6tVe/g6V9V6MHnqLU
	 jEDRBX7LQUlgNUcdL7c3wTkzS5n3zP0HfKr7qTSdcg/8nKwktBPQCihuVXZ1qW4JmH
	 CIsa1N7p3T91LEIunF+A/+sIaRG18LMH80NEttp53BCkQAnDUTq6MKFIVguBUOkTGH
	 RX62QrzJ6qMorzQ3V60JbTdP9De5d2nVk0COJKtKmtf/0v6cT2zW+FxKHe01G3M5vT
	 sg91EviwzbIGviwaDIkJjH95V/4URIzx5BcF7kpGwFgKdlUd+CwgK/o7dgMJlWhjcv
	 ewbe+MncTtsbA==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b1f31c63ebso749716a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 01:06:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwJ8Exqn5rilPyUhCvLnJy+EatooIgXYfuphsANdI4Bms6RfdLmki9uJPuwCc0w5Qd6na3ZOPqkpiRO@vger.kernel.org
X-Gm-Message-State: AFq9FYKAWRIS19I8WyM965P08dAqRDQtbWX63UDXYzBv5eTqo5dL6sOv
	j7TuS6HIX5qtCnTnDawqbiJru/VDDOCaYlXfuC2TdzooGZ9ey95QqYusx/jCDWEnOEaV1qqr86W
	O2/eXApJOija4bQVJJMBnINJzYNkcHWI=
X-Received: by 2002:a17:906:ef0b:b0:c25:f7db:4bec with SMTP id
 a640c23a62f3a-c49d122c185mr148746666b.18.1793261216577; Thu, 29 Oct 2026
 01:06:56 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028152413.183380-1-icb@fastmail.org>
In-Reply-To: <20261028152413.183380-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 29 Oct 2026 17:06:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8Tnd-ZRn8rGQDW31X6Pb3E_zq-jk6YgBxW2NaT+z_qJA@mail.gmail.com>
X-Gm-Features: AclHuK_c4LwhWe3o8v5GJHI7id17o2L5wn3mprz_dMLI_MMQNi1Z_QYTtcbBjwY
Message-ID: <CAKYAXd8Tnd-ZRn8rGQDW31X6Pb3E_zq-jk6YgBxW2NaT+z_qJA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: require DELETE access for delete-on-close opens
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 12:24=E2=80=AFAM Ian Bridges <icb@fastmail.org> wro=
te:
>
> smb2_open() accepts FILE_DELETE_ON_CLOSE on an existing file without
> DELETE in DesiredAccess. When the request asks only for
> FILE_READ_ATTRIBUTES or READ_CONTROL, it also skips inode_permission()
> and the parent directory MAY_WRITE | MAY_EXEC check that delete-on-close
> is meant to get. The file is then marked for deletion by a caller who
> could not delete it.
>
> The unlink happens later, in __ksmbd_inode_close(), when the last handle
> on the inode is closed, and it runs with the credentials of that handle.
> If the caller closes last, the unlink fails. If another user who can
> write the parent directory, such as the file's owner, still has the file
> open, the file is deleted when that user closes it. Until then new opens
> of the file fail with STATUS_DELETE_PENDING. So a user with only search
> permission on a directory can delete a file in it, or block opens of it,
> while the owner has it open.
>
> A MAXIMUM_ALLOWED open that also requests DELETE has the same problem.
> The requested access is replaced with the maximal access, which does not
> include DELETE when the caller cannot write the parent directory, and the
> later permission checks are skipped as already done.
>
> MS-FSA 2.1.5.1 requires an open with FILE_DELETE_ON_CLOSE and without
> DELETE in DesiredAccess to fail with STATUS_INVALID_PARAMETER, and Samba
> does the same. Add that check to the CreateOptions validation, using
> the generic-mapped DesiredAccess so that GENERIC_ALL still qualifies.
> This also refuses MAXIMUM_ALLOWED with FILE_DELETE_ON_CLOSE but no
> explicit DELETE, as MS-FSA and Samba do. When MAXIMUM_ALLOWED is
> requested with DELETE but the maximal access does not include DELETE,
> fail with STATUS_ACCESS_DENIED. With DELETE requested, delete-on-close
> opens go through the existing parent directory check.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
