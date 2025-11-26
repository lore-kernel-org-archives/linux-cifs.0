Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A531F30DD39
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 03:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764127708; cv=none; b=i7/j4RuH53ZFs8eJgU+bG7ukch/oaw79YBxjPo0p+rlr6nBUUzXlbJf7SOpcsycr7PbbLJHro+qgWMetywfUnckYH5Rkj8PEBtVMzYJXFGmmwwbU1j8diZiE2STaaThnzFidkgu1QsXob77B+Xz6L8mlyPo9DN9HKvaPZ2NxtV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764127708; c=relaxed/simple;
	bh=Lu5N6inwW+tz5t8BGYRwY1h8KMhRWG6gft21lmfUKtE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FLx6O2BgSXVkfq0SokET2EypZhTrd/OqRn2+MjzIBHR6WA0qVQtFiQcPAATADIPbb5M/xsVyuTXFjVuFaR9j100y8wMcQKMwCzqM/DR57BI6cvoWkHS8xYVD5CbViDxWaIeEuCejIfP8/zEg4s/9aFovmnLp6u96kSklQ93ljwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2YtQ+Vb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2YtQ+Vb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585F6C19421
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 03:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764127708;
	bh=Lu5N6inwW+tz5t8BGYRwY1h8KMhRWG6gft21lmfUKtE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=o2YtQ+Vb3boPIDZyoqcX9NkXSE2WSf04U8/h/H/6WUlmXxcOs3kw/4qLoQd3lrtfD
	 YgdjrAVsvQuLDCh0K6tFhPEC8kJlsJEHVfKONBgDT+WDOHGhbRpy9MzCjeSDXJf7qa
	 Y9SzqBVFzN2hEY08P+XZeUCqU1C7spJ0Lnxh29iyR5Um+EK37lZig8R3Bbc1f4wHf4
	 OhUpCHA2czsIJIaSviHm0EUnZP+hLGJqiWazpIX53QaOydici/3rpar1QnT6vtdVsl
	 kut5Wkd+kJn4JSZAXofljwPHyf/tfpvB6LuSoyLBQsiI9CS1uLLTJ97pskIhSaUAYE
	 VIHOBNrEzBmZA==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso919415a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 19:28:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUZpNIaFqWLXyiujJ+qLwyADSQM0TBmADQFxRGnMoVMtEIDQ0d0yrnvHfXX4qUJGO26P5kbf8TdqQYf@vger.kernel.org
X-Gm-Message-State: AOJu0YzAngRnxLZ3eLZ/GEmzRtE50wateTbRzC+UPS017wSLT+dVQuzk
	zdOjA27W9A3rwE99Z4X3ejsWEA6dIZi9qrfJzgPMQEE0atU8gSsP89vZ6NgUUXi1uv+f34niKjv
	p4ExIWHxevtVolrxCfyq9lc/SF1nJVZI=
X-Google-Smtp-Source: AGHT+IGbYpV7qsBDltxociGa2DuCApHME1J2Vp7kiM/cYEyQ7yYZYmKpuI5tekI1dv752JhsAahwqIsKQ2dy7Dw+YXc=
X-Received: by 2002:a05:6402:5343:20b0:640:abb1:5eff with SMTP id
 4fb4d7f45d1cf-645396588c5mr15692547a12.8.1764127706874; Tue, 25 Nov 2025
 19:28:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKYAXd8=buKQRve+pdBFp9ce+5MiR02ZnHtGHy-hYDfhGWn=pQ@mail.gmail.com>
 <20251126014933.10085-1-pioooooooooip@gmail.com>
In-Reply-To: <20251126014933.10085-1-pioooooooooip@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 26 Nov 2025 12:28:13 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9wdmE66cg-T9d=+wGAL=0qb77S7uWd7PFi40pJsd9VLg@mail.gmail.com>
X-Gm-Features: AWmQ_blB7nWD4OovujzloM_S5atxtDrOoFe2F9cRKe2lJUCOIuDSGRwhkSNGu08
Message-ID: <CAKYAXd9wdmE66cg-T9d=+wGAL=0qb77S7uWd7PFi40pJsd9VLg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: ipc: fix use-after-free in ipc_msg_send_request
To: Qianchang Zhao <pioooooooooip@gmail.com>
Cc: Steve French <smfrench@gmail.com>, gregkh@linuxfoundation.org, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Zhitong Liu <liuzhitong1993@gmail.com>, stable@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000004eba5f064476fd05"

--0000000000004eba5f064476fd05
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 10:49=E2=80=AFAM Qianchang Zhao <pioooooooooip@gmai=
l.com> wrote:
>
> ipc_msg_send_request() waits for a generic netlink reply using an
> ipc_msg_table_entry on the stack. The generic netlink handler
> (handle_generic_event()/handle_response()) fills entry->response under
> ipc_msg_table_lock, but ipc_msg_send_request() used to validate and free
> entry->response without holding the same lock.
>
> Under high concurrency this allows a race where handle_response() is
> copying data into entry->response while ipc_msg_send_request() has just
> freed it, leading to a slab-use-after-free reported by KASAN in
> handle_generic_event():
>
>   BUG: KASAN: slab-use-after-free in handle_generic_event+0x3c4/0x5f0 [ks=
mbd]
>   Write of size 12 at addr ffff888198ee6e20 by task pool/109349
>   ...
>   Freed by task:
>     kvfree
>     ipc_msg_send_request [ksmbd]
>     ksmbd_rpc_open -> ksmbd_session_rpc_open [ksmbd]
>
> Fix by:
> - Taking ipc_msg_table_lock in ipc_msg_send_request() while validating
>   entry->response, freeing it when invalid, and removing the entry from
>   ipc_msg_table.
> - Returning the final entry->response pointer to the caller only after
>   the hash entry is removed under the lock.
> - Returning NULL in the error path, preserving the original API
>   semantics.
>
> This makes all accesses to entry->response consistent with
> handle_response(), which already updates and fills the response buffer
> under ipc_msg_table_lock, and closes the race that allowed the UAF.
>
> Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
> Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
I have directly updated your patch and applied it to #ksmbd-for-next-next.
Let me know if the attached patch has some issue.
Thanks!

--0000000000004eba5f064476fd05
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-ksmbd-ipc-fix-use-after-free-in-ipc_msg_send_request.patch"
Content-Disposition: attachment; 
	filename="0001-ksmbd-ipc-fix-use-after-free-in-ipc_msg_send_request.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mifg26wb0>
X-Attachment-Id: f_mifg26wb0

RnJvbSAzODU4NjY1MzEzZjFmMGUxYzA5OTM0NDE4YjQzZWE2MzM3ZGQ1YjdmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBRaWFuY2hhbmcgWmhhbyA8cGlvb29vb29vb29pcEBnbWFpbC5j
b20+CkRhdGU6IFdlZCwgMjYgTm92IDIwMjUgMTI6MjQ6MTggKzA5MDAKU3ViamVjdDogW1BBVENI
XSBrc21iZDogaXBjOiBmaXggdXNlLWFmdGVyLWZyZWUgaW4gaXBjX21zZ19zZW5kX3JlcXVlc3QK
CmlwY19tc2dfc2VuZF9yZXF1ZXN0KCkgd2FpdHMgZm9yIGEgZ2VuZXJpYyBuZXRsaW5rIHJlcGx5
IHVzaW5nIGFuCmlwY19tc2dfdGFibGVfZW50cnkgb24gdGhlIHN0YWNrLiBUaGUgZ2VuZXJpYyBu
ZXRsaW5rIGhhbmRsZXIKKGhhbmRsZV9nZW5lcmljX2V2ZW50KCkvaGFuZGxlX3Jlc3BvbnNlKCkp
IGZpbGxzIGVudHJ5LT5yZXNwb25zZSB1bmRlcgppcGNfbXNnX3RhYmxlX2xvY2ssIGJ1dCBpcGNf
bXNnX3NlbmRfcmVxdWVzdCgpIHVzZWQgdG8gdmFsaWRhdGUgYW5kIGZyZWUKZW50cnktPnJlc3Bv
bnNlIHdpdGhvdXQgaG9sZGluZyB0aGUgc2FtZSBsb2NrLgoKVW5kZXIgaGlnaCBjb25jdXJyZW5j
eSB0aGlzIGFsbG93cyBhIHJhY2Ugd2hlcmUgaGFuZGxlX3Jlc3BvbnNlKCkgaXMKY29weWluZyBk
YXRhIGludG8gZW50cnktPnJlc3BvbnNlIHdoaWxlIGlwY19tc2dfc2VuZF9yZXF1ZXN0KCkgaGFz
IGp1c3QKZnJlZWQgaXQsIGxlYWRpbmcgdG8gYSBzbGFiLXVzZS1hZnRlci1mcmVlIHJlcG9ydGVk
IGJ5IEtBU0FOIGluCmhhbmRsZV9nZW5lcmljX2V2ZW50KCk6CgogIEJVRzogS0FTQU46IHNsYWIt
dXNlLWFmdGVyLWZyZWUgaW4gaGFuZGxlX2dlbmVyaWNfZXZlbnQrMHgzYzQvMHg1ZjAgW2tzbWJk
XQogIFdyaXRlIG9mIHNpemUgMTIgYXQgYWRkciBmZmZmODg4MTk4ZWU2ZTIwIGJ5IHRhc2sgcG9v
bC8xMDkzNDkKICAuLi4KICBGcmVlZCBieSB0YXNrOgogICAga3ZmcmVlCiAgICBpcGNfbXNnX3Nl
bmRfcmVxdWVzdCBba3NtYmRdCiAgICBrc21iZF9ycGNfb3BlbiAtPiBrc21iZF9zZXNzaW9uX3Jw
Y19vcGVuIFtrc21iZF0KCkZpeCBieToKLSBUYWtpbmcgaXBjX21zZ190YWJsZV9sb2NrIGluIGlw
Y19tc2dfc2VuZF9yZXF1ZXN0KCkgd2hpbGUgdmFsaWRhdGluZwogIGVudHJ5LT5yZXNwb25zZSwg
ZnJlZWluZyBpdCB3aGVuIGludmFsaWQsIGFuZCByZW1vdmluZyB0aGUgZW50cnkgZnJvbQogIGlw
Y19tc2dfdGFibGUuCi0gUmV0dXJuaW5nIHRoZSBmaW5hbCBlbnRyeS0+cmVzcG9uc2UgcG9pbnRl
ciB0byB0aGUgY2FsbGVyIG9ubHkgYWZ0ZXIKICB0aGUgaGFzaCBlbnRyeSBpcyByZW1vdmVkIHVu
ZGVyIHRoZSBsb2NrLgotIFJldHVybmluZyBOVUxMIGluIHRoZSBlcnJvciBwYXRoLCBwcmVzZXJ2
aW5nIHRoZSBvcmlnaW5hbCBBUEkKICBzZW1hbnRpY3MuCgpUaGlzIG1ha2VzIGFsbCBhY2Nlc3Nl
cyB0byBlbnRyeS0+cmVzcG9uc2UgY29uc2lzdGVudCB3aXRoCmhhbmRsZV9yZXNwb25zZSgpLCB3
aGljaCBhbHJlYWR5IHVwZGF0ZXMgYW5kIGZpbGxzIHRoZSByZXNwb25zZSBidWZmZXIKdW5kZXIg
aXBjX21zZ190YWJsZV9sb2NrLCBhbmQgY2xvc2VzIHRoZSByYWNlIHRoYXQgYWxsb3dlZCB0aGUg
VUFGLgoKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKUmVwb3J0ZWQtYnk6IFFpYW5jaGFuZyBa
aGFvIDxwaW9vb29vb29vb2lwQGdtYWlsLmNvbT4KUmVwb3J0ZWQtYnk6IFpoaXRvbmcgTGl1IDxs
aXV6aGl0b25nMTk5M0BnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IFFpYW5jaGFuZyBaaGFvIDxw
aW9vb29vb29vb2lwQGdtYWlsLmNvbT4KQWNrZWQtYnk6IE5hbWphZSBKZW9uIDxsaW5raW5qZW9u
QGtlcm5lbC5vcmc+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9z
b2Z0LmNvbT4KLS0tCiBmcy9zbWIvc2VydmVyL3RyYW5zcG9ydF9pcGMuYyB8IDcgKysrKystLQog
MSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9mcy9zbWIvc2VydmVyL3RyYW5zcG9ydF9pcGMuYyBiL2ZzL3NtYi9zZXJ2ZXIvdHJhbnNw
b3J0X2lwYy5jCmluZGV4IDJjMDhjY2NmYTY4MC4uMmRiYWJlMmQ4MDA1IDEwMDY0NAotLS0gYS9m
cy9zbWIvc2VydmVyL3RyYW5zcG9ydF9pcGMuYworKysgYi9mcy9zbWIvc2VydmVyL3RyYW5zcG9y
dF9pcGMuYwpAQCAtNTUzLDEyICs1NTMsMTYgQEAgc3RhdGljIHZvaWQgKmlwY19tc2dfc2VuZF9y
ZXF1ZXN0KHN0cnVjdCBrc21iZF9pcGNfbXNnICptc2csIHVuc2lnbmVkIGludCBoYW5kbGUKIAl1
cF93cml0ZSgmaXBjX21zZ190YWJsZV9sb2NrKTsKIAogCXJldCA9IGlwY19tc2dfc2VuZChtc2cp
OwotCWlmIChyZXQpCisJaWYgKHJldCkgeworCQlkb3duX3dyaXRlKCZpcGNfbXNnX3RhYmxlX2xv
Y2spOwogCQlnb3RvIG91dDsKKwl9CiAKIAlyZXQgPSB3YWl0X2V2ZW50X2ludGVycnVwdGlibGVf
dGltZW91dChlbnRyeS53YWl0LAogCQkJCQkgICAgICAgZW50cnkucmVzcG9uc2UgIT0gTlVMTCwK
IAkJCQkJICAgICAgIElQQ19XQUlUX1RJTUVPVVQpOworCisJZG93bl93cml0ZSgmaXBjX21zZ190
YWJsZV9sb2NrKTsKIAlpZiAoZW50cnkucmVzcG9uc2UpIHsKIAkJcmV0ID0gaXBjX3ZhbGlkYXRl
X21zZygmZW50cnkpOwogCQlpZiAocmV0KSB7CkBAIC01NjcsNyArNTcxLDYgQEAgc3RhdGljIHZv
aWQgKmlwY19tc2dfc2VuZF9yZXF1ZXN0KHN0cnVjdCBrc21iZF9pcGNfbXNnICptc2csIHVuc2ln
bmVkIGludCBoYW5kbGUKIAkJfQogCX0KIG91dDoKLQlkb3duX3dyaXRlKCZpcGNfbXNnX3RhYmxl
X2xvY2spOwogCWhhc2hfZGVsKCZlbnRyeS5pcGNfdGFibGVfaGxpc3QpOwogCXVwX3dyaXRlKCZp
cGNfbXNnX3RhYmxlX2xvY2spOwogCXJldHVybiBlbnRyeS5yZXNwb25zZTsKLS0gCjIuMjUuMQoK
--0000000000004eba5f064476fd05--
