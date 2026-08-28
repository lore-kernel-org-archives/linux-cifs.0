Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C33263CB
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 02:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787884590; cv=none; b=b5YIlc+1Ro3IJG9R9JoCmoR05YgR8+/NZKTSSDfMmdezTFUm297nB4MOapG1fT1aW9vdrGHULTgPYaYVT7F0tl/0SGLLg5mlIi8aAJGYD1Z7U0NGXH1so8mS27sQs+LJvuHtwdbf8wiB8NJmvKm6ybVA4JDuBwfEFYaYHtdbhw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787884590; c=relaxed/simple;
	bh=1j7F5oxWeCno+ff7IxctGk58bImuv2aGiO5bOlftMx4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cQ5Hi6rhMglb23Pq9qOkDZ2CQbx/UNI+Bc3TtQ0iNZh8IsAXd/uo4yxljLP+2QZdAHn8PvjzK1N71dT3ZYsC6sKUCA8abgX/vFfOhlJOfGGoWq5TUglC/ZyyuZApql/Vkoi8xVGYcF5TgUSLpgYLAtUikesQelxmaao2n3zEyC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FRtPt7WR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FRtPt7WR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A501F00ACF
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 02:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787884589;
	bh=VhhFobBzZTeEWr8ARY0JLT2FoTyXX1lTN5dBFGSlf4U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FRtPt7WRHy72rsYfxqDzXnsc/X5ayUvm7SurVk+/4SkV3gu4y8XaqD+cceEMTupoN
	 Np6Y0o8Hpo+lo9sOaiyzTdmtmuPFzthVc7zUrShmRF96QjLuftaKiUg1NF7nFKCInS
	 R6u8z//mSpOZzF128s+J/MX/3Il/fplPJPSMH6vHUIKfvUXIvGSwoRhW4CUrMQ9BW/
	 imDS6Sbb1Iutk586nmcqK9cJ453IU5X/QVuAkxCwRyhjS8vrUamW9zardMKg6k6O3o
	 i2ox4QuRgxEHLmeYWDQkWrVLSXgahR5gzssuyAUNBt9b1vAiMWShRl38XQGbwnFRWg
	 JT+tomiCUa8/g==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7ff05e5d009so6474567b3.1
        for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 19:36:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RojOs9bfenqD0wqa6JgdFW3HzmnEYQg8N+zgCMNp7TRkOcBVtpAYJ19Z7FiuDy3Vez7G/ZtziD2y9A2@vger.kernel.org
X-Gm-Message-State: AFuF++kY/gcjghefEeXdRVjeX0BTuy4HzpTqvg0i4s5FIHIetnMY6KN7
	Ht8BODCPGBo+xifVajXsFB30K4JlzSlxHl1FEYspAKRR9VN6VXKddm4Qiqv+fjFZ4hmjBV87Pjl
	yV15eETHhZ4xlAanq68XyYJ7r0fzvv0E=
X-Received: by 2002:a05:690c:8f:b0:81f:64cf:2c44 with SMTP id
 00721157ae682-85d69ff9e9bmr19138727b3.14.1787884588084; Thu, 27 Aug 2026
 19:36:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+0ovCiMX1XFqCf0z=tPOb2nnQaqsxG=FEf2X6CshAQ86gAYMg@mail.gmail.com>
In-Reply-To: <CA+0ovCiMX1XFqCf0z=tPOb2nnQaqsxG=FEf2X6CshAQ86gAYMg@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 28 Aug 2026 11:36:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-Z_H2O3W=_KrUifR44yisJJhR=-bQQp1mML7vHgfcdDw@mail.gmail.com>
X-Gm-Features: AcwNN1UpKOtxjXvx7rftrJp9Avgzs71TwStDl-xC5gFLkRj69gDweo6N6WAnQGI
Message-ID: <CAKYAXd-Z_H2O3W=_KrUifR44yisJJhR=-bQQp1mML7vHgfcdDw@mail.gmail.com>
Subject: Re: [BUG] ksmbd: OOB read in share_config_request() when payload_sz
 == 0
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Steve French <smfrench@gmail.com>, falemi@asu.edu, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000c5ed0f065a12515c"

--000000000000c5ed0f065a12515c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 28, 2026 at 7:38=E2=80=AFAM Farhad Alemi <farhad.alemi@berkeley=
.edu> wrote:
>
> Hello Namjae and Steve,
>
> While fuzzing Linux 7.1-rc5 with syzkaller, as part of research at ASU's
> SEFCOM lab, we hit the crash below. Crash reports can be found here:
>
>   https://github.com/farhad-alemi/public_bug_reports/tree/main/106-ksmbd-=
oob-read-share_config_request/
>
>   BUG: KASAN: slab-out-of-bounds in strnlen+0x66/0x90 lib/string.c:432
>   kstrndup+0x2d/0x160 mm/util.c:120
>   share_config_request fs/smb/server/mgmt/share_config.c:168 [inline]
>   ksmbd_share_config_get+0x5e0/0x1190
>        fs/smb/server/mgmt/share_config.c:243
>   smb2_tree_connect+0x2f4/0x1320 fs/smb/server/smb2pdu.c:2015
>
> Our reproducer.c is available upon request.
>
> Happy to test a patch if that would help.
Can you test if the attached patch fixes this issue?

Thanks.

--000000000000c5ed0f065a12515c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-ksmbd-prevent-out-of-bounds-reads-in-share-config-re.patch"
Content-Disposition: attachment; 
	filename="0001-ksmbd-prevent-out-of-bounds-reads-in-share-config-re.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mtccb09c0>
X-Attachment-Id: f_mtccb09c0

RnJvbSBkMmMwOTcwYWI3MDZiMWQ5ZTZjNzk2MGFlYjE3NTIxYWNiYzdiMzJjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOYW1qYWUgSmVvbiA8bGlua2luamVvbkBrZXJuZWwub3JnPgpE
YXRlOiBGcmksIDI4IEF1ZyAyMDI2IDA4OjM5OjU3ICswOTAwClN1YmplY3Q6IFtQQVRDSCAxLzJd
IGtzbWJkOiBwcmV2ZW50IG91dC1vZi1ib3VuZHMgcmVhZHMgaW4gc2hhcmUgY29uZmlnCiByZXNw
b25zZXMKClZhbGlkYXRlIElQQyBzaGFyZSBjb25maWd1cmF0aW9uIHBheWxvYWQgc2l6ZXMgYmVm
b3JlIGNvbnN1bWluZwp2YXJpYWJsZS1sZW5ndGggZmllbGRzLiBCb3VuZCB2ZXRvIGxpc3QgcGFy
c2luZyBhbmQgYWNjb3VudCBmb3IKdGhlIHNlcGFyYXRvciBieXRlIHdoZW4gZGVyaXZpbmcgdGhl
IHBhdGggbGVuZ3RoLgoKRml4ZXM6IGE2NzdlYmQ4Y2EyZiAoImtzbWJkOiB2YWxpZGF0ZSBwYXls
b2FkIHNpemUgaW4gaXBjIHJlc3BvbnNlIikKU2lnbmVkLW9mZi1ieTogTmFtamFlIEplb24gPGxp
bmtpbmplb25Aa2VybmVsLm9yZz4KLS0tCiBmcy9zbWIvc2VydmVyL21nbXQvc2hhcmVfY29uZmln
LmMgfCA0MCArKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tCiBmcy9zbWIvc2VydmVyL3Ry
YW5zcG9ydF9pcGMuYyAgICAgfCAyMSArKysrKysrKysrLS0tLS0tCiAyIGZpbGVzIGNoYW5nZWQs
IDQxIGluc2VydGlvbnMoKyksIDIwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9z
ZXJ2ZXIvbWdtdC9zaGFyZV9jb25maWcuYyBiL2ZzL3NtYi9zZXJ2ZXIvbWdtdC9zaGFyZV9jb25m
aWcuYwppbmRleCBiMmQ5NTgwYmRkYzYuLmNjOWYxOGVkZTgwZCAxMDA2NDQKLS0tIGEvZnMvc21i
L3NlcnZlci9tZ210L3NoYXJlX2NvbmZpZy5jCisrKyBiL2ZzL3NtYi9zZXJ2ZXIvbWdtdC9zaGFy
ZV9jb25maWcuYwpAQCAtMTQ2LDkgKzE0Niw5IEBAIHN0YXRpYyBzdHJ1Y3Qga3NtYmRfc2hhcmVf
Y29uZmlnICpfX3NoYXJlX2xvb2t1cChjb25zdCBjaGFyICpuYW1lKQogCiBzdGF0aWMgaW50IHBh
cnNlX3ZldG9fbGlzdChzdHJ1Y3Qga3NtYmRfc2hhcmVfY29uZmlnICpzaGFyZSwKIAkJCSAgIGNo
YXIgKnZldG9fbGlzdCwKLQkJCSAgIGludCB2ZXRvX2xpc3Rfc3opCisJCQkgICBzaXplX3QgdmV0
b19saXN0X3N6KQogewotCWludCBzeiA9IDA7CisJc2l6ZV90IHN6OwogCiAJaWYgKCF2ZXRvX2xp
c3Rfc3opCiAJCXJldHVybiAwOwpAQCAtMTU2LDcgKzE1Niw3IEBAIHN0YXRpYyBpbnQgcGFyc2Vf
dmV0b19saXN0KHN0cnVjdCBrc21iZF9zaGFyZV9jb25maWcgKnNoYXJlLAogCXdoaWxlICh2ZXRv
X2xpc3Rfc3ogPiAwKSB7CiAJCXN0cnVjdCBrc21iZF92ZXRvX3BhdHRlcm4gKnA7CiAKLQkJc3og
PSBzdHJsZW4odmV0b19saXN0KTsKKwkJc3ogPSBzdHJubGVuKHZldG9fbGlzdCwgdmV0b19saXN0
X3N6KTsKIAkJaWYgKCFzeikKIAkJCWJyZWFrOwogCkBAIC0xNjQsNyArMTY0LDcgQEAgc3RhdGlj
IGludCBwYXJzZV92ZXRvX2xpc3Qoc3RydWN0IGtzbWJkX3NoYXJlX2NvbmZpZyAqc2hhcmUsCiAJ
CWlmICghcCkKIAkJCXJldHVybiAtRU5PTUVNOwogCi0JCXAtPnBhdHRlcm4gPSBrc3RyZHVwKHZl
dG9fbGlzdCwgS1NNQkRfREVGQVVMVF9HRlApOworCQlwLT5wYXR0ZXJuID0ga3N0cm5kdXAodmV0
b19saXN0LCBzeiwgS1NNQkRfREVGQVVMVF9HRlApOwogCQlpZiAoIXAtPnBhdHRlcm4pIHsKIAkJ
CWtmcmVlKHApOwogCQkJcmV0dXJuIC1FTk9NRU07CkBAIC0xNzIsNiArMTcyLDkgQEAgc3RhdGlj
IGludCBwYXJzZV92ZXRvX2xpc3Qoc3RydWN0IGtzbWJkX3NoYXJlX2NvbmZpZyAqc2hhcmUsCiAK
IAkJbGlzdF9hZGQoJnAtPmxpc3QsICZzaGFyZS0+dmV0b19saXN0KTsKIAorCQlpZiAoc3ogPT0g
dmV0b19saXN0X3N6KQorCQkJYnJlYWs7CisKIAkJdmV0b19saXN0ICs9IHN6ICsgMTsKIAkJdmV0
b19saXN0X3N6IC09IChzeiArIDEpOwogCX0KQEAgLTIyNCwxNyArMjI3LDI4IEBAIHN0YXRpYyBz
dHJ1Y3Qga3NtYmRfc2hhcmVfY29uZmlnICpzaGFyZV9jb25maWdfcmVxdWVzdChzdHJ1Y3Qga3Nt
YmRfd29yayAqd29yaywKIAl9CiAKIAlpZiAoIXRlc3Rfc2hhcmVfY29uZmlnX2ZsYWcoc2hhcmUs
IEtTTUJEX1NIQVJFX0ZMQUdfUElQRSkpIHsKLQkJaW50IHBhdGhfbGVuID0gUEFUSF9NQVg7Ci0K
LQkJaWYgKHJlc3AtPnBheWxvYWRfc3opCi0JCQlwYXRoX2xlbiA9IHJlc3AtPnBheWxvYWRfc3og
LSByZXNwLT52ZXRvX2xpc3Rfc3o7CisJCXNpemVfdCBwYXRoX2xlbjsKIAotCQlzaGFyZS0+cGF0
aCA9IGtzdHJuZHVwKGtzbWJkX3NoYXJlX2NvbmZpZ19wYXRoKHJlc3ApLCBwYXRoX2xlbiwKLQkJ
CQkgICAgICBLU01CRF9ERUZBVUxUX0dGUCk7Ci0JCWlmICghc2hhcmUtPnBhdGgpIHsKLQkJCXJl
dCA9IC1FTk9NRU07CisJCWlmIChyZXNwLT5wYXlsb2FkX3N6IDw9IHJlc3AtPnZldG9fbGlzdF9z
eikgeworCQkJcmV0ID0gLUVJTlZBTDsKIAkJfSBlbHNlIHsKLQkJCXJldCA9IDA7CisJCQlwYXRo
X2xlbiA9IHJlc3AtPnBheWxvYWRfc3ogLSByZXNwLT52ZXRvX2xpc3Rfc3o7CisJCQlpZiAocmVz
cC0+dmV0b19saXN0X3N6KQorCQkJCXBhdGhfbGVuLS07CisKKwkJCWlmICghcGF0aF9sZW4pIHsK
KwkJCQlyZXQgPSAtRUlOVkFMOworCQkJfSBlbHNlIHsKKwkJCQlzaGFyZS0+cGF0aCA9IGtzdHJu
ZHVwKAorCQkJCQlrc21iZF9zaGFyZV9jb25maWdfcGF0aChyZXNwKSwKKwkJCQkJcGF0aF9sZW4s
IEtTTUJEX0RFRkFVTFRfR0ZQKTsKKwkJCQlpZiAoIXNoYXJlLT5wYXRoKQorCQkJCQlyZXQgPSAt
RU5PTUVNOworCQkJCWVsc2UKKwkJCQkJcmV0ID0gMDsKKwkJCX0KKwkJfQorCQlpZiAoc2hhcmUt
PnBhdGgpIHsKIAkJCXNoYXJlLT5wYXRoX3N6ID0gc3RybGVuKHNoYXJlLT5wYXRoKTsKIAkJCXdo
aWxlIChzaGFyZS0+cGF0aF9zeiA+IDEgJiYKIAkJCSAgICAgICBzaGFyZS0+cGF0aFtzaGFyZS0+
cGF0aF9zeiAtIDFdID09ICcvJykKZGlmZiAtLWdpdCBhL2ZzL3NtYi9zZXJ2ZXIvdHJhbnNwb3J0
X2lwYy5jIGIvZnMvc21iL3NlcnZlci90cmFuc3BvcnRfaXBjLmMKaW5kZXggNGIwYjU3MmEzZTFi
Li5lNTUwYWE0MWFkMmMgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9zZXJ2ZXIvdHJhbnNwb3J0X2lwYy5j
CisrKyBiL2ZzL3NtYi9zZXJ2ZXIvdHJhbnNwb3J0X2lwYy5jCkBAIC01MzIsMTQgKzUzMiwyMSBA
QCBzdGF0aWMgaW50IGlwY192YWxpZGF0ZV9tc2coc3RydWN0IGlwY19tc2dfdGFibGVfZW50cnkg
KmVudHJ5KQogCQlpZiAoZW50cnktPm1zZ19zeiA8IHNpemVvZihzdHJ1Y3Qga3NtYmRfc2hhcmVf
Y29uZmlnX3Jlc3BvbnNlKSkKIAkJCXJldHVybiAtRUlOVkFMOwogCi0JCWlmIChyZXNwLT5wYXls
b2FkX3N6KSB7Ci0JCQlpZiAocmVzcC0+cGF5bG9hZF9zeiA8IHJlc3AtPnZldG9fbGlzdF9zeikK
LQkJCQlyZXR1cm4gLUVJTlZBTDsKKwkJaWYgKHN0cm5sZW4ocmVzcC0+c2hhcmVfbmFtZSwgc2l6
ZW9mKHJlc3AtPnNoYXJlX25hbWUpKSA9PQorCQkgICAgc2l6ZW9mKHJlc3AtPnNoYXJlX25hbWUp
KQorCQkJcmV0dXJuIC1FSU5WQUw7CiAKLQkJCWlmIChjaGVja19hZGRfb3ZlcmZsb3coc2l6ZW9m
KHN0cnVjdCBrc21iZF9zaGFyZV9jb25maWdfcmVzcG9uc2UpLAotCQkJCQkgICAgICAgcmVzcC0+
cGF5bG9hZF9zeiwgJm1zZ19zeikpCi0JCQkJcmV0dXJuIC1FSU5WQUw7Ci0JCX0KKwkJaWYgKHJl
c3AtPnZldG9fbGlzdF9zeiA+IHJlc3AtPnBheWxvYWRfc3opCisJCQlyZXR1cm4gLUVJTlZBTDsK
KworCQlpZiAocmVzcC0+ZmxhZ3MgIT0gS1NNQkRfU0hBUkVfRkxBR19JTlZBTElEICYmCisJCSAg
ICAhKHJlc3AtPmZsYWdzICYgS1NNQkRfU0hBUkVfRkxBR19QSVBFKSAmJgorCQkgICAgcmVzcC0+
cGF5bG9hZF9zeiA8PSByZXNwLT52ZXRvX2xpc3Rfc3opCisJCQlyZXR1cm4gLUVJTlZBTDsKKwor
CQlpZiAoY2hlY2tfYWRkX292ZXJmbG93KHNpemVvZihzdHJ1Y3Qga3NtYmRfc2hhcmVfY29uZmln
X3Jlc3BvbnNlKSwKKwkJCQkgICAgICAgcmVzcC0+cGF5bG9hZF9zeiwgJm1zZ19zeikpCisJCQly
ZXR1cm4gLUVJTlZBTDsKIAkJYnJlYWs7CiAJfQogCWNhc2UgS1NNQkRfRVZFTlRfTE9HSU5fUkVR
VUVTVF9FWFQ6Ci0tIAoyLjM0LjEKCg==
--000000000000c5ed0f065a12515c--
