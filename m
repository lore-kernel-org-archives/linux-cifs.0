Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CCD1FDE2B
	for <linux-cifs@vger.kernel.org>; Wed,  5 Feb 2025 00:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738714971; cv=none; b=H5RZ9KLpCa3t8fLRQeKegLkCuZwc7DXr4/AMns552+uz15ckjciDQDmnacFMOyau4f/47oOkGFuPox12kRDjjFPttBGKvsqM6cCyzhmZz5L442DPAsLvQo7bN59bqdWjKFk+lNHlcljkrZn7piRx1l2E8x6wFlKpOYIHNXIKNMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738714971; c=relaxed/simple;
	bh=fBBWtyZqY3qiopnhnv0Ah33NMGlTQBIjKT0o2GVHUpE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=SgW+k47L/zhMmIqEUP3u7euZWQXk9pX3okx88VWw9bXIIBO+VcniCwtGjeyRa6Gh6gpsGKcaCFwzZULU1rE9imJYblae/YZ0jaWO+DBEIKiaUIndUwfbL5QlgrJDsEABCPz/hnnlZU6dIHrF+0WmBZy8d5ztOCUuYWa+knsGXtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JptirblK; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JptirblK"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-53e3778bffdso6183100e87.0
        for <linux-cifs@vger.kernel.org>; Tue, 04 Feb 2025 16:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738714968; x=1739319768; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8JfxxO3sLYBc9MND2R4By8YrBlkeG7hBPctIo3z5tkY=;
        b=JptirblK+6aJQ9sCMjyy6XLdCJaDhf1M8xEtxcMSoPv0Wh0JGS8dkNCdMKsLckTA4E
         QcXjKEm1tv2gtY+CFMnysIkpKjx465CchquRSjM8Aylq6I9MHXl9k182jRXCODyWy33N
         X7h7s3Eui5Hm49JoRMbKU9K5xUaDI4ZkcYZZZUPhQfcJRSKisYcFjIHe7Jhl46oGuhdt
         CxbHUc6J50uLKl7GcV1PubvZsTBL86KSCP1PtaJ/RtyE/LNj2dZQf24aT6JfPaqqiq6u
         6KykNg8t2pFC5DRHhwlGIOr/60Q29iBOcF3JXAuRXWvvUlG6Y+cYlsDf7XSaUhHySozc
         qjJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738714968; x=1739319768;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8JfxxO3sLYBc9MND2R4By8YrBlkeG7hBPctIo3z5tkY=;
        b=XuLkkeWbXljdL0LTydVKQZiKj/+q1GZaFXsKdlcGhCmk4rgg4iPfx3hCRwynowEnn2
         gzTytb+3ApHO4llChHGMtIEirxxuDzuzdpTaSDX9s+nNG752fpuOpc+4sN2/MdwmBtz3
         v+geuu6jQoYZm/abtKJfobS8FNrj8Z+qcQWfLHu2KOmuz3UgECQewdWnT4Iw/e/03xuC
         hn/l8uiGsqLKRsSqcdyE+mjs81NpVJLz2czmsbSG7wGA1p16hBAx49on84IjnR0i/LHw
         09FZ++GbW8c2Qz6fi0d4ydNbvHIf7WFnZyVrQj4UmI0r3qI01/4mmaB+LGdA7DibR6pt
         wEjQ==
X-Gm-Message-State: AOJu0Yy4WOFFvqvZ7fxd1uyClNrdDLMeoZEE+dmW7YpEa7dPf6hF63Lk
	xPBtbZOnEsparXzppRa00xXdXjsbRbUO0P4PahKZjM23ypyEpxy6tdLPw0HiVBqGzrz6xrn7xLG
	Pjadftc5/kz7ESwWg/gOntriM9JAxiAta
X-Gm-Gg: ASbGncsguXIRO6ZZu3stgdhWnj4E/7BAnfpwijypr1gVaqkxh6uV/8qNG8f2IWptqD/
	/5PEe3N02ryODywztuSx2+4T2eiVbQlA0XLJ2olP2CYn/oOCBJ/oLF886hlll6ROPWvAdx0Hveg
	VETM9nLuugtg8H9CZQvRvL11EjhCUhgLs=
X-Google-Smtp-Source: AGHT+IFzOd4ETKvMr9TA3Qv3YoFQTEObLRbcnxhaH31Pl2eFU6vkiG4CR5TMyeoa5rnYliGHBshB7LYg5WPF6aFPbWM=
X-Received: by 2002:a05:6512:3b24:b0:542:6f70:b484 with SMTP id
 2adb3069b0e04-54405a10450mr195060e87.12.1738714967868; Tue, 04 Feb 2025
 16:22:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 4 Feb 2025 18:22:35 -0600
X-Gm-Features: AWEUYZkMxtgBQ8xC-f1Awh_J455x2WCZVmK8u91vuJqbRb-mBJYcas1CkqZEqvE
Message-ID: <CAH2r5msCiefg1fo+p7hsAMc14mkL2fc+rD5pHRKOuPFrJ9MK8w@mail.gmail.com>
Subject: Re: [PATCH 12/43] cifs: Throw -EOPNOTSUPP error on unsupported reparse
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000006abe0062d5a20f3"

--00000000000006abe0062d5a20f3
Content-Type: text/plain; charset="UTF-8"

Do you have an easy repro scenario for the attached patch of Pali's
(e.g. creating on windows, a reparse point that will be unhandled on
Linux)?



-- 
Thanks,

Steve

--00000000000006abe0062d5a20f3
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0012-cifs-Throw-EOPNOTSUPP-error-on-unsupported-reparse-p.patch"
Content-Disposition: attachment; 
	filename="0012-cifs-Throw-EOPNOTSUPP-error-on-unsupported-reparse-p.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m6r5zoju0>
X-Attachment-Id: f_m6r5zoju0

RnJvbSBlNmFhYWIwY2RmNGZhMWJiN2I2NjA1YTY0YTU5OGUyZGVjNWI5NGQ5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UGFsaT0yMFJvaD1DMz1BMXI/PSA8cGFsaUBr
ZXJuZWwub3JnPgpEYXRlOiBXZWQsIDE4IFNlcCAyMDI0IDAwOjE2OjA1ICswMjAwClN1YmplY3Q6
IFtQQVRDSCAxMi80M10gY2lmczogVGhyb3cgLUVPUE5PVFNVUFAgZXJyb3Igb24gdW5zdXBwb3J0
ZWQgcmVwYXJzZQogcG9pbnQgdHlwZSBmcm9tIHBhcnNlX3JlcGFyc2VfcG9pbnQoKQpNSU1FLVZl
cnNpb246IDEuMApDb250ZW50LVR5cGU6IHRleHQvcGxhaW47IGNoYXJzZXQ9VVRGLTgKQ29udGVu
dC1UcmFuc2Zlci1FbmNvZGluZzogOGJpdAoKVGhpcyB3b3VsZCBoZWxwIHRvIHRyYWNrIGFuZCBk
ZXRlY3QgYnkgY2FsbGVyIGlmIHRoZSByZXBhcnNlIHBvaW50IHR5cGUgd2FzCnByb2Nlc3NlZCBv
ciBub3QuCgpTaWduZWQtb2ZmLWJ5OiBQYWxpIFJvaMOhciA8cGFsaUBrZXJuZWwub3JnPgotLS0K
IGZzL3NtYi9jbGllbnQvcmVwYXJzZS5jIHwgNSArKy0tLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5z
ZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3Jl
cGFyc2UuYyBiL2ZzL3NtYi9jbGllbnQvcmVwYXJzZS5jCmluZGV4IGNjNWQ4NmMwMWJkYy4uYTNl
Mjc3NWIwM2Q5IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3JlcGFyc2UuYworKysgYi9mcy9z
bWIvY2xpZW50L3JlcGFyc2UuYwpAQCAtMTA2MywxMyArMTA2MywxMiBAQCBpbnQgcGFyc2VfcmVw
YXJzZV9wb2ludChzdHJ1Y3QgcmVwYXJzZV9kYXRhX2J1ZmZlciAqYnVmLAogCQkJCSBsZTMyX3Rv
X2NwdShidWYtPlJlcGFyc2VUYWcpKTsKIAkJCXJldHVybiAtRUlPOwogCQl9Ci0JCWJyZWFrOwor
CQlyZXR1cm4gMDsKIAlkZWZhdWx0OgogCQljaWZzX3Rjb25fZGJnKFZGUyB8IE9OQ0UsICJ1bmhh
bmRsZWQgcmVwYXJzZSB0YWc6IDB4JTA4eFxuIiwKIAkJCSAgICAgIGxlMzJfdG9fY3B1KGJ1Zi0+
UmVwYXJzZVRhZykpOwotCQlicmVhazsKKwkJcmV0dXJuIC1FT1BOT1RTVVBQOwogCX0KLQlyZXR1
cm4gMDsKIH0KIAogaW50IHNtYjJfcGFyc2VfcmVwYXJzZV9wb2ludChzdHJ1Y3QgY2lmc19zYl9p
bmZvICpjaWZzX3NiLAotLSAKMi40My4wCgo=
--00000000000006abe0062d5a20f3--
