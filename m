Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3A5417D87
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 12:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787574346; cv=none; b=Ub5CK24T2t4QqoZpXFb67YbQVrN3RuVWHBX86iiB5biiHRdU+OQkii/ScxnlPRmrcrlF7fpvVL0XGr//LK5HoTAgzOCreLje9S2kKD8FFqEjbNSaNxX2E5A+uQQWdxx4qol6ky5jDh0RexZjt0bvh1Wxhc8/YA5HL/PnvH/iDCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787574346; c=relaxed/simple;
	bh=OvFKDfLaP5H3kiXJuthbGhWnv6MzcLEwBz7vL/KSDiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qia1xFhi74Y0B2C0Fo9ltzVtUJWOwkyZuj+nKtjAeMHEYnuSqkI4WiO5pqxvgXpx5pGWTU6HzTOex6xhKpfvI5O6XzW/tQR3tBwl98nVvHws0bPYDo7FtpTiLhavTv2LwIgrgu/ZX8w7JK3WhrOpAY4vC0y0mq99z8EKWQrp3O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OTrx+Yan; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OTrx+Yan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D541F00A3D
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 12:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787574343;
	bh=Hxh1SLowI/GcWlg8VHB8ml7zprM76H5r/djvRfhrRfc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OTrx+YanbLOaR20+Oz19gc6U0npQqrG49xGlDUKXrZ3nNuXmNRivgF+ZpkUNgJ4Co
	 o/xQLEbkoGgY3H+kzraZ9dlttcG7LjdInzUQKWPbI7OxkpQcnK9dphWa6xpWALrYGD
	 3JoqE1/637sU+YzFM8FtZ20fkr5R2NBktDtGUbUA1dkMRZh1W5uvRmCAljDHgYUJ8t
	 hHc9LyXwmwecmTjV36vu26s/Gz6agN1eYTVTJiyCtIArOefI199VSZYpwBFLKBaiVH
	 tn3mMgeOaWlNR/oQmR+Aw2aU/gQQsCEUVHclSxoizcyeRMSBgyqV0Wkq/6994zI39P
	 5ZTt+t5Scy/OQ==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6983d3dae7aso7132764a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 05:25:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rocy9fRze0O/YUWFdZwE1cqilH21GWc/P+qjRLA8KKfzVnOh4UQDEmDaNf4MHTbdC0qc3PAQPAHQGM7@vger.kernel.org
X-Gm-Message-State: AFuF++nMLHaJlOS8KsPkRoxe5XRtmQoyO5e64I3KaVfCYg2otw8sfNNs
	w0EpQjo3atOQRmKgh9ev50BlK11v7lr3CYzRtFB9dxRBzOYMqOLqii0ppA5INZ9LLSoybPfbIic
	YMrmMrw8x05eyey7D8LAsBFTX+gJyPgU=
X-Received: by 2002:a17:907:c719:b0:c15:a7b9:2ae1 with SMTP id
 a640c23a62f3a-c246dc5ba9emr2827327266b.6.1787574341846; Mon, 24 Aug 2026
 05:25:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821135801.3790290-1-haa@amicon.ru> <20260824102248.178152-1-haa@amicon.ru>
 <20260824102248.178152-2-haa@amicon.ru>
In-Reply-To: <20260824102248.178152-2-haa@amicon.ru>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 24 Aug 2026 21:25:29 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-gVKqe9vbQY1UCANbuOJMb+FRLWh4qyyo_yiRb8C8kaw@mail.gmail.com>
X-Gm-Features: AcwNN1V-1mlIFCvIBDxzGVfaUdOS40Eu-jUy_LcfWVmYTzKE1j0FpYDBFXME2WA
Message-ID: <CAKYAXd-gVKqe9vbQY1UCANbuOJMb+FRLWh4qyyo_yiRb8C8kaw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ksmbd: zero the FS_OBJECT_ID_INFORMATION buffer
 before filling it in
To: Aleksandr Khromov <haa@amicon.ru>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org, rrv@amicon.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 7:23=E2=80=AFPM Aleksandr Khromov <haa@amicon.ru> w=
rote:
>
> smb2_get_info_filesystem() reports 64 bytes for FS_OBJECT_ID_INFORMATION,
> that is the whole of struct object_id_info, but writes only 46 of them:
>
>  - objid[] is 16 bytes, and when the volume UUID is not available only
>    sizeof(stfs.f_fsid) (8) bytes are copied into it;
>  - extended_info.version_string[] is STRING_LENGTH (28) bytes, and only
>    strlen("1.1.0") (5) bytes are copied into it.
>
> The response buffer is zeroed on allocation (kvzalloc() in
> smb2_allocate_rsp_buf()), so for a standalone request the remaining 31
> bytes are zero.  In a compound request they need not be.  The offset of
> the next response is advanced by the length pinned for the previous one,
> so if a preceding command wrote its reply into the buffer and then
> failed, smb2_set_err_rsp() pins only the short error response and the
> next reply lands inside the area that has already been written.  Only
> the header is cleared there:
>
>         memset((char *)rsp_hdr, 0, sizeof(struct smb2_hdr) + 2);
>
> The client then receives up to 31 bytes of a response it was not meant
> to see, including one that failed with an access denied error.
>
> Clear the structure before filling it in.  As a side effect
> version_string is now NUL terminated.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Suggested-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Aleksandr Khromov <haa@amicon.ru>
Applied it to #ksmbd-for-next.
Thanks!
