Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F702E8DE8
	for <linux-cifs@vger.kernel.org>; Wed, 22 Oct 2025 06:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761115158; cv=none; b=m43+gZctQieJZTBBNRYplqCQ+OmQGUoolmjILAI4+7PYHlCUyrS3TrFnSJ/66CN9RJKF/b00Q8OluzTxf9G1Gtc1Ae9lN81joQQ7v4vrgQjlX2ccBEd+2mNlaxvpvpFxKc6nGLPytjWBrcuT6TZJePuFK6wUay+VJNVVAQfkZRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761115158; c=relaxed/simple;
	bh=hm4nlhtNPGmEi69KVa2bKeYCOGjdSHFu7LVZDz9W3nY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cFJukxGZZVf5WP4B3SDSBA3THHPxe9QQmu8RiUYaqrxkTu59bNSdxwm37Y4mQ9RP+0MaOAxBv1BDvkJga51G8x+qNQybywMhTHfBNWY0ktjWZ9WCfWnAH96crVEGFx0PFjY2krqLViRYPwgKeSwrk5Bf6D1AmAD561k9QKBSrFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPrhTjdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPrhTjdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8BEC116B1
	for <linux-cifs@vger.kernel.org>; Wed, 22 Oct 2025 06:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761115157;
	bh=hm4nlhtNPGmEi69KVa2bKeYCOGjdSHFu7LVZDz9W3nY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iPrhTjdtk1xC+sPY84Z3bYO9UV8Ek7rfvrmG8cIeTnOFtXE6kc0tdo/lT9MVfGfHG
	 4Md+zJekPfm3E1Bqhsjsnc8JTL+zJE5US1jOiEWTz/EQGNLprrOf3bfZEcX60jOlja
	 QXg4vReraVA6IQD7ofFajXhHtt36Z+MSz/BIWB/o6Z6rV5O/bCec9/vlhaF3hql+OH
	 Vz59YZ6eLJSZKN8BCUVB1I0Bn1jJpgpaBfO4XtHvVyOBZ+++r+7n2Vy05w/LDlpNb1
	 brj3JruW0aknAiaGUuBcV4fZ1ivE4d2CMny2yPO4qaBsfg4Oq32NmUFmf8+b50yAx1
	 dm6Z+5SAf4+OA==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-63c4b41b38cso9206405a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 21 Oct 2025 23:39:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVrEI0e61b5eQXa3j2pR4kEmU2geZw4VrVCpde1BZ/zdIfeJ7ej3pic2C2bb+s+tIQ/ZhZzDZybZXP9@vger.kernel.org
X-Gm-Message-State: AOJu0YzvHiQGfnyCqhQd/taQcCz4Z5OAoLm40ADFa0U2nR3dqPtvzWJ+
	p6v28Gwlun2X7XtF24nP+ZxB9Qc3PrPPYmYtF02ZSl4U1laOCmOkJ6TBbA7aumof3iObhfUFHbC
	oAtFQtp6nKb8TiVz+TKKbw+x5VtWgzk0=
X-Google-Smtp-Source: AGHT+IEVbw59KyPcLUZsUJMNGGcdxdAw21EgXFnRXyi6U3bIi41kp6ndgSXyQYRN4XBLaNJoZbyTlyQ4X/MV3FzOgwU=
X-Received: by 2002:a05:6402:358a:b0:61c:9852:bb9f with SMTP id
 4fb4d7f45d1cf-63c1f630745mr18498531a12.1.1761115156420; Tue, 21 Oct 2025
 23:39:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2025102125-petted-gristle-43a0@gregkh> <20251021145449.473932-1-pioooooooooip@gmail.com>
In-Reply-To: <20251021145449.473932-1-pioooooooooip@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 22 Oct 2025 15:39:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-JFuBptqzEbgggUhaF2bEfWMRXCSK9N_spiBxvi1v0Wg@mail.gmail.com>
X-Gm-Features: AS18NWCL_qZDAmZMV5o8SxFrFzgvvH5lIHZHd4Cjd8dpv-koKZ4OHU2zTrTPt68
Message-ID: <CAKYAXd-JFuBptqzEbgggUhaF2bEfWMRXCSK9N_spiBxvi1v0Wg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: transport_ipc: validate payload size before
 reading handle
To: Qianchang Zhao <pioooooooooip@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	gregkh@linuxfoundation.org, stable@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000004ef5df0641b993b8"

--0000000000004ef5df0641b993b8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 11:55=E2=80=AFPM Qianchang Zhao <pioooooooooip@gmai=
l.com> wrote:
>
> handle_response() dereferences the payload as a 4-byte handle without
> verifying that the declared payload size is at least 4 bytes. A malformed
> or truncated message from ksmbd.mountd can lead to a 4-byte read past the
> declared payload size. Validate the size before dereferencing.
>
> This is a minimal fix to guard the initial handle read.
>
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing an=
d tranport layers")
> Cc: stable@vger.kernel.org
> Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
> Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
I have directly updated your patch. Can you check the attached patch ?
Thanks!

--0000000000004ef5df0641b993b8
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-ksmbd-transport_ipc-validate-payload-size-before-rea.patch"
Content-Disposition: attachment; 
	filename="0001-ksmbd-transport_ipc-validate-payload-size-before-rea.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mh1mgnbo0>
X-Attachment-Id: f_mh1mgnbo0

RnJvbSAxNzdhZjYxMDI1Mjc1NzFlYWEzODEzMjNkZGRkNzA4NGMyMDMzNTNlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBRaWFuY2hhbmcgWmhhbyA8cGlvb29vb29vb29pcEBnbWFpbC5j
b20+CkRhdGU6IFdlZCwgMjIgT2N0IDIwMjUgMTU6Mjc6NDcgKzA5MDAKU3ViamVjdDogW1BBVENI
XSBrc21iZDogdHJhbnNwb3J0X2lwYzogdmFsaWRhdGUgcGF5bG9hZCBzaXplIGJlZm9yZSByZWFk
aW5nCiBoYW5kbGUKCmhhbmRsZV9yZXNwb25zZSgpIGRlcmVmZXJlbmNlcyB0aGUgcGF5bG9hZCBh
cyBhIDQtYnl0ZSBoYW5kbGUgd2l0aG91dAp2ZXJpZnlpbmcgdGhhdCB0aGUgZGVjbGFyZWQgcGF5
bG9hZCBzaXplIGlzIGF0IGxlYXN0IDQgYnl0ZXMuIEEgbWFsZm9ybWVkCm9yIHRydW5jYXRlZCBt
ZXNzYWdlIGZyb20ga3NtYmQubW91bnRkIGNhbiBsZWFkIHRvIGEgNC1ieXRlIHJlYWQgcGFzdCB0
aGUKZGVjbGFyZWQgcGF5bG9hZCBzaXplLiBWYWxpZGF0ZSB0aGUgc2l6ZSBiZWZvcmUgZGVyZWZl
cmVuY2luZy4KClRoaXMgaXMgYSBtaW5pbWFsIGZpeCB0byBndWFyZCB0aGUgaW5pdGlhbCBoYW5k
bGUgcmVhZC4KCkZpeGVzOiAwNjI2ZTY2NDFmNmIgKCJjaWZzZDogYWRkIHNlcnZlciBoYW5kbGVy
IGZvciBjZW50cmFsIHByb2Nlc3NpbmcgYW5kIHRyYW5wb3J0IGxheWVycyIpCkNjOiBzdGFibGVA
dmdlci5rZXJuZWwub3JnClJlcG9ydGVkLWJ5OiBRaWFuY2hhbmcgWmhhbyA8cGlvb29vb29vb29p
cEBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IFFpYW5jaGFuZyBaaGFvIDxwaW9vb29vb29vb2lw
QGdtYWlsLmNvbT4KQWNrZWQtYnk6IE5hbWphZSBKZW9uIDxsaW5raW5qZW9uQGtlcm5lbC5vcmc+
ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0t
CiBmcy9zbWIvc2VydmVyL3RyYW5zcG9ydF9pcGMuYyB8IDggKysrKysrKy0KIDEgZmlsZSBjaGFu
Z2VkLCA3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIv
c2VydmVyL3RyYW5zcG9ydF9pcGMuYyBiL2ZzL3NtYi9zZXJ2ZXIvdHJhbnNwb3J0X2lwYy5jCmlu
ZGV4IDQ2Zjg3ZmQxY2UxYy4uMmMwOGNjY2ZhNjgwIDEwMDY0NAotLS0gYS9mcy9zbWIvc2VydmVy
L3RyYW5zcG9ydF9pcGMuYworKysgYi9mcy9zbWIvc2VydmVyL3RyYW5zcG9ydF9pcGMuYwpAQCAt
MjYzLDEwICsyNjMsMTYgQEAgc3RhdGljIHZvaWQgaXBjX21zZ19oYW5kbGVfZnJlZShpbnQgaGFu
ZGxlKQogCiBzdGF0aWMgaW50IGhhbmRsZV9yZXNwb25zZShpbnQgdHlwZSwgdm9pZCAqcGF5bG9h
ZCwgc2l6ZV90IHN6KQogewotCXVuc2lnbmVkIGludCBoYW5kbGUgPSAqKHVuc2lnbmVkIGludCAq
KXBheWxvYWQ7CisJdW5zaWduZWQgaW50IGhhbmRsZTsKIAlzdHJ1Y3QgaXBjX21zZ190YWJsZV9l
bnRyeSAqZW50cnk7CiAJaW50IHJldCA9IDA7CiAKKwkvKiBQcmV2ZW50IDQtYnl0ZSByZWFkIGJl
eW9uZCBkZWNsYXJlZCBwYXlsb2FkIHNpemUgKi8KKwlpZiAoc3ogPCBzaXplb2YodW5zaWduZWQg
aW50KSkKKwkJcmV0dXJuIC1FSU5WQUw7CisKKwloYW5kbGUgPSAqKHVuc2lnbmVkIGludCAqKXBh
eWxvYWQ7CisKIAlpcGNfdXBkYXRlX2xhc3RfYWN0aXZlKCk7CiAJZG93bl9yZWFkKCZpcGNfbXNn
X3RhYmxlX2xvY2spOwogCWhhc2hfZm9yX2VhY2hfcG9zc2libGUoaXBjX21zZ190YWJsZSwgZW50
cnksIGlwY190YWJsZV9obGlzdCwgaGFuZGxlKSB7Ci0tIAoyLjI1LjEKCg==
--0000000000004ef5df0641b993b8--
