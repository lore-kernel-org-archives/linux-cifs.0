Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77AC63CB
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 02:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787884787; cv=none; b=G0VQq8iBvup/XvYXFJ4BFHDmJr4u8q6uXvv1ZCo4Mz/zlZZGonM02jwV078Yiu8pd0AY7uJ41n7UUjhlncJpou8sYY8wwa3ivq3fbJauiFKT+SXZo28l3CEcpv0zXWVVExG92yJ+4cC3OvVN4JQQETYBVL5D/UESf1blmvQBgI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787884787; c=relaxed/simple;
	bh=clrm+UB2pAIOoHISv2GMOdStzYiwVebiOlFekPJmh1E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lIcK1nHNjhiagcG7yLHKvTn4boFeORvG9G6snduwzAVoUfq0dJXVrP7nOfMqTYFe4fV8Eerr7d2C0KLxQs0EKOh+0RoyEndfcE63FHBya8SH7+pNHZ2jsp7o4cXCWL5UY/VeTw6jaBqE8wpwLduMX3H9VpOb1G1YHZsmMfvtnBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5y+h3UJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5y+h3UJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2101F00ADE
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 02:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787884785;
	bh=pWLL30NNWs4Aa57GYS6yD9hVeDty/ol1mACnY3CTkkg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Q5y+h3UJ0jR/muEiRXvN2CTVdzs/sK7JcgdoSiqli3VVhCCzNtYtEMf8nnB1+86ep
	 4c9sVlJtZZH2v95rcC8hdFAGkf6s2mESuc41WQc9o10p5XMWbXNhS6TC0Wz1BHk7bm
	 Q2Rk8NhaJVzb6TSEB7vVm/duPCzf76V3DgRqPnhLhcSy75n0rNvtzrQuucmPYevZLO
	 jxdBmeZ2bubcI6tSO7WWmOtqNI9wvnTsc/7vltqdowixFi15ZUupYHNk23n2BfuchW
	 QA1Qg5kZF0l04Pym7WCLEL/g7fPFk58taaDqRb5gmdS9Od45TL1V0LJp/EEG6oco0c
	 xHGtdNwXx1Asw==
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-66d14734b9fso2727931d50.0
        for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 19:39:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro0edQnbWQSptzALHkEGZx78A9tqdU2U04j/v/k4dGK6qsLJWnReqiyYKNmppVZCqTfvgupHpjfUe+m@vger.kernel.org
X-Gm-Message-State: AFuF++lP/+S2RwVOnpJtr8yw8hOWs5aPDeizmdhmdKvqjt5XXQgzWCet
	Gnd+2lYnFei64GLvrjG7NYC3g4U+xf9iSH3XQakOgWd7ZtChe6fJENfL71cpf9kU6PmBm8G1wrq
	4ZyCO+YJQ2mnJv+WyAdeHnb5F7F11BO4=
X-Received: by 2002:a05:690e:120d:b0:667:82d6:eb47 with SMTP id
 956f58d0204a3-66e1185c136mr4491664d50.17.1787884784849; Thu, 27 Aug 2026
 19:39:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+0ovCjUB=g+56ZCrT4MPfWjqBJX_CO=vfp12JLOrh7B53uVWQ@mail.gmail.com>
In-Reply-To: <CA+0ovCjUB=g+56ZCrT4MPfWjqBJX_CO=vfp12JLOrh7B53uVWQ@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 28 Aug 2026 11:39:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-+bctZycpVKNkQTifthktnWdfOHsKdsNBzL2droo_yHQ@mail.gmail.com>
X-Gm-Features: AcwNN1WcC01hhCfvQHHjtzAoo8ruIVL9eEzBaRrW1sNfSt2CQLnk01_H3hWkzWg
Message-ID: <CAKYAXd-+bctZycpVKNkQTifthktnWdfOHsKdsNBzL2droo_yHQ@mail.gmail.com>
Subject: Re: [BUG] ksmbd: use-after-free on iface_list from the netdev notifier
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Namjae Jeon <linkinjeon@samba.org>, Steve French <smfrench@gmail.com>, 
	Steve French <sfrench@samba.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, falemi@asu.edu, linux-cifs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000080702e065a125de1"

--00000000000080702e065a125de1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 28, 2026 at 8:08=E2=80=AFAM Farhad Alemi <farhad.alemi@berkeley=
.edu> wrote:
>
> Hello Namjae Jeon, Namjae Jeon,
>
> While fuzzing Linux 7.1-rc5 with syzkaller, as part of research at ASU's
> SEFCOM lab, we hit the crash below. Crash reports can be found here:
>
>   https://github.com/farhad-alemi/public_bug_reports/tree/main/117-ksmbd-=
unlocked-iface_list-uaf-netdev-event/
>
>   refcount_t: addition on 0; use-after-free.
>   WARNING: lib/refcount.c:25 at refcount_warn_saturate+0x9f/0x110
> lib/refcount.c:25, CPU#1: kworker/u8:3/9983
>   Modules linked in:
>   CPU: 1 UID: 0 PID: 9983 Comm: kworker/u8:3 Not tainted 7.1.0-rc5 #1
> PREEMPT(full)
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.3-debian-1.16.3-2 04/01/2014
>   Workqueue: netns cleanup_net
>   RIP: 0010:refcount_warn_saturate+0x9f/0x110 lib/refcount.c:25
>   Code: eb 66 85 db 74 3e 83 fb 01 75 4c e8 db 45 27 fd 48 8d 3d 04 03
> 1a 0b 67 48 0f b9 3a eb 4a e8 c8 45 27 fd 48 8d 3d 01 03 1a 0b <67> 48
> 0f b9 3a eb 37 e8 b5 45 27 fd 48 8d 3d fe 02 1a 0b 67 48 0f
>
> Our reproducer.c is available upon request.
>
> Happy to test a patch if that would help.
Can you test if the attached patch fixes this issue?

Thanks.

--00000000000080702e065a125de1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-ksmbd-fix-listener-task-lifetime-on-netdev-events.patch"
Content-Disposition: attachment; 
	filename="0002-ksmbd-fix-listener-task-lifetime-on-netdev-events.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mtccep9i0>
X-Attachment-Id: f_mtccep9i0

RnJvbSBhN2NkMGVlZjg4MjliNzAzNzhmNjFjY2U0MjIwZjdlMTUwNGE4MTRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOYW1qYWUgSmVvbiA8bGlua2luamVvbkBrZXJuZWwub3JnPgpE
YXRlOiBGcmksIDI4IEF1ZyAyMDI2IDA5OjI0OjQ5ICswOTAwClN1YmplY3Q6IFtQQVRDSCAyLzJd
IGtzbWJkOiBmaXggbGlzdGVuZXIgdGFzayBsaWZldGltZSBvbiBuZXRkZXYgZXZlbnRzCgpUaGUg
bGlzdGVuZXIgdGhyZWFkIGV4aXRzIHdoZW4gaXRzIGxpc3RlbmluZyBzb2NrZXQgaXMgc2h1dGRv
d24uIFRoZQpuZXRkZXZpY2Ugbm90aWZpZXIgc2h1dHMgZG93biB0aGUgc29ja2V0IGJlZm9yZSBj
YWxsaW5nIGt0aHJlYWRfc3RvcCgpLCBzbwp0aGUgdGFza19zdHJ1Y3QgY2FuIGJlIGZyZWVkIGJl
Zm9yZSBrdGhyZWFkX3N0b3AoKSBnZXRzIGl0cyByZWZlcmVuY2UuCgpDcmVhdGUgdGhlIGxpc3Rl
bmVyIGluIGEgc3RvcHBlZCBzdGF0ZSBhbmQgaG9sZCBhbiBleHRyYSB0YXNrX3N0cnVjdApyZWZl
cmVuY2UgdW50aWwga3RocmVhZF9zdG9wX3B1dCgpIGNvbXBsZXRlcy4gQWxzbyBzdG9wIGFuZCBy
ZWxlYXNlCmxpc3RlbmVycyBiZWZvcmUgZnJlZWluZyB0aGVpciBpbnRlcmZhY2UgcmVjb3JkcyBk
dXJpbmcgVENQIHRlYXJkb3duLgoKRml4ZXM6IDMzMTZhOGZjODQwZCAoImtzbWJkOiBzZXJ2ZXI6
IGF2b2lkIGJ1c3kgcG9sbGluZyBpbiBhY2NlcHQgbG9vcCIpClNpZ25lZC1vZmYtYnk6IE5hbWph
ZSBKZW9uIDxsaW5raW5qZW9uQGtlcm5lbC5vcmc+Ci0tLQogZnMvc21iL3NlcnZlci90cmFuc3Bv
cnRfdGNwLmMgfCAzNiArKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLQogMSBmaWxl
IGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZnMvc21iL3NlcnZlci90cmFuc3BvcnRfdGNwLmMgYi9mcy9zbWIvc2VydmVyL3RyYW5zcG9ydF90
Y3AuYwppbmRleCA4MzJlOTMwODQ2MDUuLmExYmYwNDBiYTU2MSAxMDA2NDQKLS0tIGEvZnMvc21i
L3NlcnZlci90cmFuc3BvcnRfdGNwLmMKKysrIGIvZnMvc21iL3NlcnZlci90cmFuc3BvcnRfdGNw
LmMKQEAgLTM5LDYgKzM5LDcgQEAgc3RydWN0IHRjcF90cmFuc3BvcnQgewogc3RhdGljIGNvbnN0
IHN0cnVjdCBrc21iZF90cmFuc3BvcnRfb3BzIGtzbWJkX3RjcF90cmFuc3BvcnRfb3BzOwogCiBz
dGF0aWMgdm9pZCB0Y3Bfc3RvcF9rdGhyZWFkKHN0cnVjdCB0YXNrX3N0cnVjdCAqa3RocmVhZCk7
CitzdGF0aWMgdm9pZCBrc21iZF90Y3Bfc3RvcF9saXN0ZW5lcihzdHJ1Y3QgaW50ZXJmYWNlICpp
ZmFjZSk7CiBzdGF0aWMgc3RydWN0IGludGVyZmFjZSAqYWxsb2NfaWZhY2UoY2hhciAqaWZuYW1l
KTsKIHN0YXRpYyB2b2lkIGtzbWJkX3RjcF9kaXNjb25uZWN0KHN0cnVjdCBrc21iZF90cmFuc3Bv
cnQgKnQpOwogCkBAIC0zMjEsMTMgKzMyMiwyMCBAQCBzdGF0aWMgaW50IGtzbWJkX3RjcF9ydW5f
a3RocmVhZChzdHJ1Y3QgaW50ZXJmYWNlICppZmFjZSkKIAlpbnQgcmM7CiAJc3RydWN0IHRhc2tf
c3RydWN0ICprdGhyZWFkOwogCi0Ja3RocmVhZCA9IGt0aHJlYWRfcnVuKGtzbWJkX2t0aHJlYWRf
Zm4sICh2b2lkICopaWZhY2UsICJrc21iZC0lcyIsCi0JCQkgICAgICBpZmFjZS0+bmFtZSk7CisJ
a3RocmVhZCA9IGt0aHJlYWRfY3JlYXRlKGtzbWJkX2t0aHJlYWRfZm4sICh2b2lkICopaWZhY2Us
ICJrc21iZC0lcyIsCisJCQkJIGlmYWNlLT5uYW1lKTsKIAlpZiAoSVNfRVJSKGt0aHJlYWQpKSB7
CiAJCXJjID0gUFRSX0VSUihrdGhyZWFkKTsKIAkJcmV0dXJuIHJjOwogCX0KKworCS8qCisJICog
VGhlIGxpc3RlbmVyIGNhbiBleGl0IGFmdGVyIGl0cyBzb2NrZXQgaXMgc2h1dGRvd24sIHNvIGtl
ZXAgdGhlCisJICogdGFza19zdHJ1Y3QgYWxpdmUgdW50aWwgdGhlIGNhbGxlciBoYXMgc3RvcHBl
ZCBpdC4KKwkgKi8KKwlnZXRfdGFza19zdHJ1Y3Qoa3RocmVhZCk7CiAJaWZhY2UtPmtzbWJkX2t0
aHJlYWQgPSBrdGhyZWFkOworCXdha2VfdXBfcHJvY2VzcyhrdGhyZWFkKTsKIAogCXJldHVybiAw
OwogfQpAQCAtNTk4LDEyICs2MDYsNyBAQCBzdGF0aWMgaW50IGtzbWJkX25ldGRldl9ldmVudChz
dHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5iLCB1bnNpZ25lZCBsb25nIGV2ZW50LAogCQlpZiAoaWZh
Y2UgJiYgaWZhY2UtPnN0YXRlID09IElGQUNFX1NUQVRFX0NPTkZJR1VSRUQpIHsKIAkJCWtzbWJk
X2RlYnVnKENPTk4sICJuZXRkZXYtZG93biBldmVudDogbmV0ZGV2KCVzKSBpcyBnb2luZyBkb3du
XG4iLAogCQkJCQlpZmFjZS0+bmFtZSk7Ci0JCQlrZXJuZWxfc29ja19zaHV0ZG93bihpZmFjZS0+
a3NtYmRfc29ja2V0LCBTSFVUX1JEV1IpOwotCQkJdGNwX3N0b3Bfa3RocmVhZChpZmFjZS0+a3Nt
YmRfa3RocmVhZCk7Ci0JCQlpZmFjZS0+a3NtYmRfa3RocmVhZCA9IE5VTEw7Ci0JCQlzb2NrX3Jl
bGVhc2UoaWZhY2UtPmtzbWJkX3NvY2tldCk7Ci0JCQlpZmFjZS0+a3NtYmRfc29ja2V0ID0gTlVM
TDsKLQorCQkJa3NtYmRfdGNwX3N0b3BfbGlzdGVuZXIoaWZhY2UpOwogCQkJaWZhY2UtPnN0YXRl
ID0gSUZBQ0VfU1RBVEVfRE9XTjsKIAkJCWJyZWFrOwogCQl9CkBAIC02MzEsMTEgKzYzNCwyNSBA
QCBzdGF0aWMgdm9pZCB0Y3Bfc3RvcF9rdGhyZWFkKHN0cnVjdCB0YXNrX3N0cnVjdCAqa3RocmVh
ZCkKIAlpZiAoIWt0aHJlYWQpCiAJCXJldHVybjsKIAotCXJldCA9IGt0aHJlYWRfc3RvcChrdGhy
ZWFkKTsKKwlyZXQgPSBrdGhyZWFkX3N0b3BfcHV0KGt0aHJlYWQpOwogCWlmIChyZXQpCiAJCXBy
X2VycigiZmFpbGVkIHRvIHN0b3AgZm9ya2VyIHRocmVhZFxuIik7CiB9CiAKK3N0YXRpYyB2b2lk
IGtzbWJkX3RjcF9zdG9wX2xpc3RlbmVyKHN0cnVjdCBpbnRlcmZhY2UgKmlmYWNlKQoreworCWlm
IChpZmFjZS0+a3NtYmRfc29ja2V0KQorCQlrZXJuZWxfc29ja19zaHV0ZG93bihpZmFjZS0+a3Nt
YmRfc29ja2V0LCBTSFVUX1JEV1IpOworCisJdGNwX3N0b3Bfa3RocmVhZChpZmFjZS0+a3NtYmRf
a3RocmVhZCk7CisJaWZhY2UtPmtzbWJkX2t0aHJlYWQgPSBOVUxMOworCisJaWYgKGlmYWNlLT5r
c21iZF9zb2NrZXQpIHsKKwkJc29ja19yZWxlYXNlKGlmYWNlLT5rc21iZF9zb2NrZXQpOworCQlp
ZmFjZS0+a3NtYmRfc29ja2V0ID0gTlVMTDsKKwl9Cit9CisKIHZvaWQga3NtYmRfdGNwX2Rlc3Ry
b3kodm9pZCkKIHsKIAlzdHJ1Y3QgaW50ZXJmYWNlICppZmFjZSwgKnRtcDsKQEAgLTY0Myw2ICs2
NjAsNyBAQCB2b2lkIGtzbWJkX3RjcF9kZXN0cm95KHZvaWQpCiAJdW5yZWdpc3Rlcl9uZXRkZXZp
Y2Vfbm90aWZpZXIoJmtzbWJkX25ldGRldl9ub3RpZmllcik7CiAKIAlsaXN0X2Zvcl9lYWNoX2Vu
dHJ5X3NhZmUoaWZhY2UsIHRtcCwgJmlmYWNlX2xpc3QsIGVudHJ5KSB7CisJCWtzbWJkX3RjcF9z
dG9wX2xpc3RlbmVyKGlmYWNlKTsKIAkJbGlzdF9kZWwoJmlmYWNlLT5lbnRyeSk7CiAJCWtmcmVl
KGlmYWNlLT5uYW1lKTsKIAkJa2ZyZWUoaWZhY2UpOwotLSAKMi4zNC4xCgo=
--00000000000080702e065a125de1--
