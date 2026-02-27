Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFBB25FA05
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 10:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772187916; cv=pass; b=aoDjKihCurbTdlVeZnbQEASAA/GUEQ7l55uXUSLR03wjfnAxx64N/ehNqu9RaksFKZKafO6w/0ERvyc2CM9cTTMiVQtrrlfOyFVNa+1Mqs6Z00oLr0lopWzTIlaTVHHVG3EicGDvBbaT24TTQppZG0slyHb2eZ3JFDx6dMNrCkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772187916; c=relaxed/simple;
	bh=RJBOQYX0Pp3A8/SMhWfr+8fGlBaTgeZwacGybWf4+WA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LKmq4tNr1gK4BdD0RV+He1dvsY2xmr7oFHlTLU49at4wwBqBX98tMATVM/zqMzgzZFIaNOC/S2vD4sQzHlWDqoY20xXuh2h1nIkHgNkGTeUJid3yboD4Q+eHI+nt2vA4s4XnA1h4WI8DVzwsfrXoN4XbZSxGC0aqgWZATZIXtL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NOVbWqGO; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NOVbWqGO"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-65a26c220b6so2618955a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 02:25:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772187914; cv=none;
        d=google.com; s=arc-20240605;
        b=COIN1GwxlhXglt/RpMQFNQqb/fNmab0kyxjnMBRjlgHTZ9AD1D/F+5+O99pyAD5Yod
         9tlC4cbymk/MeaYQDthcusjx22f7sanbUkqIW78K68iInyuE1iw09AU4ycOMjLMjG4Z4
         Zj5dLN1VTCPUqNxrzbYm85mUS1oQZEAtcX0bhuKA54+0DwQTOU1uHHI6SSNnEwu53dcJ
         6JtwYbzZzGIjqyjBGzLicNQXPIGLPBYc4SzUrSoUjzHkqT13HB5BdOCcZHe5r+/3lhrx
         T83uanGIakgVQ7NIQIwZ9hlE5MrI4ow2NNRsQwyVYDa+eaTAW0SUymZ0sYbhRrHvF0lw
         NA1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QEGgC2xnE+GR/vDIjG+6vP3Pe3y3IP0TYiEVmUz3f8c=;
        fh=K9dBFgA4rcVCd6q/HmCHvDEvg8Z4K6HEDrACv4s2ZiI=;
        b=IwjBMwpUjMSILFkhaZM5StNkdotUfqwMSk3cfYHdtbJcERr6AevQq2RZKkryzOmhvX
         vjCOY27unddm43f1GOGvsLudHJ1Rdj5yUqjqdpUy7qgQWPQlQMQD6kGEeAeunoSI5j6J
         qNNK4Sb4oS0aGvxhs9ET3qpk1GtlbKZwcjhF/yyUR/IWEIqW3gYwFW04tTiMSA7IJ+cB
         OcsYl9ryvRddCmU7H34Ro4YP7dykcLoIgL2dthl1FrjE5W91EEH4Wv7jk+BXHf2fY7AM
         /iuitNrdIRdpus+uBHnTq077MUb3p1OzVLPkpoaD5Y21HH6mqrvF2Z7cjpOHo9pGX2IG
         Leig==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772187914; x=1772792714; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QEGgC2xnE+GR/vDIjG+6vP3Pe3y3IP0TYiEVmUz3f8c=;
        b=NOVbWqGObgFISGWqGlxJP2dCuy1Xn7t+ef00+WWz24Yk+JvvUEsWsJFTKPpbU566wb
         iwvw+A0Y3KhzB0Sw7/kJltxQaRayEXGWBI/1f5Cc1VfLLR9bsqN2HbDxDc2aWpMTvObf
         Uj2Hbc+ui/OB8k56uQURo2ZFxm7HTM4vagD7GXnoeV+lfFxZmuSVJ16ZbbSBRBixBVAk
         t1gtKpPySznzsUJPVF63w6EyJb14pBjC+NvkppzNp8Lt1kPgko3Wty94TqY7ayrB6gD8
         pCvLjS7RzzzVv3/zRpZ+och9CYtdPs9R9IgWRnDB2D0esc4M00UDp1LuX1+4tTzAGPt3
         xILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772187914; x=1772792714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QEGgC2xnE+GR/vDIjG+6vP3Pe3y3IP0TYiEVmUz3f8c=;
        b=AOIDSaYxBMsEuNjYuo/zkWU/Fs42fOz+Qm9SSvD98V4npazztL7qNfAamV/0QnGxc1
         JENgakTOd8TBeFG5vY+WMsq0IytmDtrV8LkeRLYUVoR25cApAzCuKBu8u4fxfc2CNHA6
         pM4rLi+Gi/kvfTt6DcQcXzrlBZgRqMcH9BH3V2T5y8/0fztV5jaDz5n6fRzPMKyj5NhS
         yOUNzfOk7c3gJ7ppgPlmxlu+5ui8SFGfJpfYWOaOwkyzfLZ0qX555ahiro9Rk5MoKmsy
         3jlEdmjeLUYWIdIUUzo/Dh9O41wqW2sAG1AA+0t1bK2pvpKed5B2q6ZbLmFDcQRynu1G
         DJ3A==
X-Forwarded-Encrypted: i=1; AJvYcCU9A3ZDFiNsKXAQQt6p+IKtY+dXdrZV1UbOt+Yo5ye+9IuB2q/p54ToJgZEOx2O+hRXjqs7QeGO9rXE@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9nGGMN7l8JQB4fKl0U64y5WRs9CQX8Yt5mynedQOmVsGtn/lp
	eKY8mjbChAl496zHfX9WWYhj0z9g7dRJ6qwerFZ6f2Deiz7OmlGeSNDGF8aJ1Xu1Oy8a/RZCelR
	+mzs0jBdo/HnJSqLmLAPIgGW9XI2kpck=
X-Gm-Gg: ATEYQzzlr+LNlY00036CcoAf9VqTPK2il9moBqQ3wc+/Qow+Id7OtCccu81KatXXiLd
	89ivWjk/aEGu0gZirlX3NewK/TXt3k0EWkE9uPfs6SkAwS2DaiWXmPvtxVXRpzthFOi95k8KXyD
	Mxc/X1uA4K3wkjHqskMaRZkT/qU+rHeXltwd24mZfr7N5FI67wOtWDyubH7tzEi4WELZtVvof6k
	oujslEA9NAOaZ6ecW0mb0jKEiDkt0TJQPDkcwJ1uJ58ktyldXBnY0VNvrnYAPFd/990BXbtPKDz
	/sp0Yg==
X-Received: by 2002:a05:6402:26c5:b0:65f:8e80:4108 with SMTP id
 4fb4d7f45d1cf-65fdd6c0961mr1767288a12.11.1772187913362; Fri, 27 Feb 2026
 02:25:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGypqWyDOfspVUMe3fm5bfQtC_wH2eEzRgppYvWUVDe1RHLy9Q@mail.gmail.com>
In-Reply-To: <CAGypqWyDOfspVUMe3fm5bfQtC_wH2eEzRgppYvWUVDe1RHLy9Q@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 27 Feb 2026 15:55:01 +0530
X-Gm-Features: AaiRm53E8fzhZYzHDwzInONMWS_7okJV9lrIOMIkVUYNrkKfehamg0SxqX1C4V8
Message-ID: <CANT5p=rRqPFdieYHeLqtOLtC0Jr-e9jMihj7a+SgCqQt3YWqfQ@mail.gmail.com>
Subject: Re: [BUG] [~6.6 Kernel] Corruption when retrying encrypted sync writes
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Shyam Prasad <Shyam.Prasad@microsoft.com>, Steve French <smfrench@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.com>, 
	Enzo Matsumiya <ematsumiya@suse.de>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 18, 2026 at 11:30=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.co=
m> wrote:
>
> We are noticing a data corruption issue in kernels based on stable
> 6.6.y. Especially, when a synchronous writes retried after a
> connection reset.
>
> Based on investigation so far, it looks like we are having issue in
> the following code path:
> When SMB3 encryption is enabled, partial-page buffered writes hit the
> synchronous write path in cifs_write_end() when the folio is not
> uptodate (!folio_test_uptodate(folio)), it calls cifs_write() directly
> with the kmap()'d page cache buffer, bypassing the async writeback
> path.
> cifs_write() calls SMB2_write(), which places the write payload in
> rq_iov[1], pointing directly at the page cache buffer. When
> smb3_init_transform_rq() builds the encryption request, it shares
> rq_iov by pointer (new->rq_iov =3D old->rq_iov), and crypt_message()
> encrypts in-place via aead_request_set_crypt(req, sg, sg, ...). This
> destroys the original page cache data. If the write gets -EAGAIN after
> encryption (e.g., connection reset), cifs_write() re-sends the
> now-ciphertext buffer as if it were plaintext, resulting in
> double-encrypted garbage on the server. The server accepts it and
> returns success.
> Please let me know if you have seen this issue in the past, your
> comments on the analysis and probable fixes.
>
> Repro steps: Attached repro.zip with repro scripts and instructions:
> 1) Mount with SMB3 encryption enabled
> 2) Perform buffered writes in a loop (e.g., echo "known_pattern" >> file)
> 3) Kill the TCP connection during writes (ss -K dport 445) to force
> retryable errors
> 4) Read the file back and compare against expected content
>
Looking at the callers, it looks like simple_fallocate_range*
functions that make use of sync writes are also susceptible to this
issue.

> Issue can occur when all below conditions met in buffered writes:
> 1) SMB2 encryption is active
> 2) Sync write path: Writes reached SMB2_write via cifs_write
> 3) Retryable network error for writes: When EAGAIN or ECONABORTED
> returned from  cifs_send_recv().
>
> Here is a the sequence of operations leading to issue:
> write(2) syscall
>  =E2=94=94=E2=94=80 cifs_write_end()                          [file.c]
>      =E2=94=94=E2=94=80 cifs_write()                          [file.c]
>          =E2=94=82  iov[1].iov_base =3D write_data      =E2=86=90 page ca=
che pointer enters iov[1]
>          =E2=94=82
>          =E2=94=94=E2=94=80 server->ops->sync_write()         [file.c]
>              =E2=94=94=E2=94=80 smb2_sync_write()             [smb2ops.c:=
]
>                  =E2=94=94=E2=94=80 SMB2_write()              [smb2pdu.c:=
]
>                      =E2=94=82  rqst.rq_iov =3D iov     =E2=86=90 rqst po=
ints to iov[]
> (with page cache in [1])
>                      =E2=94=82  rqst.rq_nvec =3D n_vec+1  =E2=86=90 BUG: =
payload in
> rq_iov, not rq_iter
>                      =E2=94=82
>                      =E2=94=94=E2=94=80 cifs_send_recv()      [transport.=
c:1305]
>                          =E2=94=94=E2=94=80 compound_send_recv()  [transp=
ort.c:1071]
>                              =E2=94=82
>                              =E2=94=94=E2=94=80 smb_send_rqst()   [transp=
ort.c:427]
>                                  =E2=94=82  if (flags & CIFS_TRANSFORM_RE=
Q)  =E2=86=90
> YES for SMB3 encryption
>                                  =E2=94=82
>                                  =E2=94=94=E2=94=80 server->ops->init_tra=
nsform_rq()
> [smb2ops.c:~4398]
>                                  =E2=94=82   =3D smb3_init_transform_rq()
>                                  =E2=94=82     new->rq_iov =3D old->rq_io=
v     =E2=86=90
> SHARES pointer (not copied!)
>                                  =E2=94=82     size =3D
> iov_iter_count(old->rq_iter) =3D 0  =E2=86=90 empty, no copy
>                                  =E2=94=82
>                                  =E2=94=94=E2=94=80 __smb_send_rqst()  [t=
ransport.c:272]
>                                      =E2=94=82  =E2=86=92 crypt_message()=
  [smb2ops.c:~4280]
>                                      =E2=94=82     =E2=86=92 smb2_get_aea=
d_req()
> [smb2ops.c:~4196]
>                                      =E2=94=82        sg =3D scatterwalk =
from rq_iov[0..n]
>                                      =E2=94=82
> aead_request_set_crypt(req, sg, sg, ...)
>                                      =E2=94=82
>    ^^^  ^^^
>                                      =E2=94=82
> src=3Ddst =E2=86=92 IN-PLACE encrypt
>                                      =E2=94=82
>                                      =E2=94=82   iov[1] (=3D page cache) =
is now
> AES ciphertext
>                                      =E2=94=82
>                                      =E2=94=94=E2=94=80 kernel_sendmsg() =
/ sock_sendmsg()
>                                          =E2=86=92 sends encrypted data o=
n wire
>
>          =E2=86=90 rc =3D -EAGAIN (connection dropped)
>
>          is_replayable_error(rc) =3D=3D true or cifs_write while loop det=
ects EAGAIN
>          goto replay_again                    =E2=86=90 loops back with c=
orrupted iov[1]
>              =E2=94=94=E2=94=80 SMB2_write() re-sends...
>                  =E2=94=94=E2=94=80 smb3_init_transform_rq()  =E2=86=90 e=
ncrypts ciphertext AGAIN
>                      =E2=94=94=E2=94=80 crypt_message()       =E2=86=90 d=
ouble-encrypted garbage
>                          =E2=94=94=E2=94=80 server writes it to disk  =E2=
=86=90  CORRUPTION
>
>
>
> Modifying SMB2_write function by adding payload to rq_iter seems to
> help here. Need to further test.
> With below fix, when rq_iter size > 0 code in smb3_init_transform_rq
> allocates fresh pages, copies the data via copy_page_from_iter(), and
> encrypts the copy instead of the original.
> Please let me know your comments.
>
>
>  rqst.rq_iov =3D iov;
> -rqst.rq_nvec =3D n_vec + 1;
> +rqst.rq_nvec =3D 1;
> +iov_iter_kvec(&rqst.rq_iter, ITER_SOURCE, &iov[1], n_vec,
> +              io_parms->length);
> +rqst.rq_iter_size =3D io_parms->length;

Another option is to initialize iov_iter_xarray with rqst.rq_buffer,
similar to what smb3_init_transform_rq does. But this should work too.
Changes look good to me. Please submit a formal patch.

--=20
Regards,
Shyam
