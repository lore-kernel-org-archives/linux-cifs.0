Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EFC31E83D
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 03:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787627136; cv=none; b=UHRqVzGGpI5/84Iuo5XGN1eOkQ/1nTsLOyYCUA+4fMbkRtNpkCA+XctB2jt1Hu86yGp2YTo9eYcrZ0Nc3K+LcD7sQ3dhP8Ymw6M8FWgvyd5yYU5YH0ZaJ5UkPLLoh+5cWiEaSPTaU28b8lg1kUDrkNzI6yi2e/zs2Yp3maptWRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787627136; c=relaxed/simple;
	bh=+4kRiQR90K95HPk0opMxFvPkZ31WttNqYptc9qDo14Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rCJDNxT97RcfXnuh7fWNozKLm1IbzpQkrWjhiRGoxdHQjWNoIczQVIgE81bhG0t6sM1PhaSVQgG6excexpBZObWJo493dDDFVBPBkQPG/VtbzWHQHVvyRLeuA4zY9L05XfpVeav6wB4CuDuG+sWfTUjDI5Uj+MF9e5QcSZN7RnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mZa85Qs4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZa85Qs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88591F00AC4
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 03:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787627134;
	bh=4JFCldyzGVZ1EU8B+m4vCG1S0Fw3VTwb2eBUiaBtDO4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mZa85Qs4JAQictPxerfUvyM1hq4ADfqBCTPQRYe6foBIj5ANjZZe7JMSId1CPmoww
	 jDk31rqTde2JlulgvB4x1TiPMbDmFZfYcsJVSQPlINtn+EyM/ECouPU25Y/6nMVjhn
	 Jkp1oC1pdWz0Eb6xxFPr3c8Y+j6YYkGzUPgojGAM81lZqHi6Q4gZywgby4MU700HEs
	 7CpoSNDYFqecmt2tKem0mA/2SlpgKOfVjCLtdyWV6NP+Wvl+UNZvvkrfcCH2sXf6AL
	 J8dGZtRIw5NAua8uaM9YPvqUmzWLIUaT1Kg1/wayxjSNW5w6vybYBIqiAmiQ3E2Qz9
	 HBh3D5KMR6ZKw==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a18e24ad25so5729485a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 20:05:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rocsqbj+GZUhJqf8uCdLWSSZqE4bqlIS3/LbV89Lr1k/bADOW9jSAILRFBHmDlIAFzWe+cE1H69ANDf@vger.kernel.org
X-Gm-Message-State: AFuF++lrkBH2pEN4JoNdDICi2ZBJj8NS5ON35+H5Ovfd/B/iAlcEzMz1
	D/1h72/ddjMsXePlyZDuapcKT6LwNZfomROKHLdzEZIBT2CZZ7TQmqR107wVw+26/BrapNHYdj7
	l0ZStaTFw6P3Vo3BW3DmrTfas7DNvWxM=
X-Received: by 2002:a05:6402:24a1:b0:69c:76c6:9bef with SMTP id
 4fb4d7f45d1cf-6a582b6278emr24784589a12.10.1787627133403; Mon, 24 Aug 2026
 20:05:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824102248.178152-4-haa@amicon.ru> <20260824144030.444300-1-haa@amicon.ru>
In-Reply-To: <20260824144030.444300-1-haa@amicon.ru>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 25 Aug 2026 12:05:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_EX1m=M2KCdEfZONarZr_yo45euLrS_8CeADoMytrQwA@mail.gmail.com>
X-Gm-Features: AcwNN1VFtko6yw2m9m1jkOSU_aU7HRH8Aluh3_qpGcRin430k9Jml0o8vSoLkII
Message-ID: <CAKYAXd_EX1m=M2KCdEfZONarZr_yo45euLrS_8CeADoMytrQwA@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION
To: Aleksandr Khromov <haa@amicon.ru>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org, rrv@amicon.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 11:40=E2=80=AFPM Aleksandr Khromov <haa@amicon.ru> =
wrote:
>
> smb2_get_info_filesystem() reports 56 bytes for FS_POSIX_INFORMATION,
> that is the whole of FILE_SYSTEM_POSIX_INFO, but never assigns
> FileSysIdentifier.  Those eight bytes go to the client as they are found
> in the response buffer.
>
> The buffer is zeroed on allocation, so a standalone request leaks
> nothing.  A compound request can leak: the offset of the next response
> is advanced by the length pinned for the previous one, so a reply that
> was written into the buffer and then dropped in favour of the short
> error response of smb2_set_err_rsp() stays there, and the next reply is
> laid over it with only the header cleared.
>
> Report the file system id statfs() returned, which is what the field is
> for.  FileSysIdentifier is __le64 and f_fsid is a pair of ints, so
> assemble the value first, val[0] as the low half, and convert it on the
> way out.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aleksandr Khromov <haa@amicon.ru>
Applied it to #ksmbd-for-next.
Thanks!
