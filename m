Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA548BE8
	for <linux-cifs@vger.kernel.org>; Tue, 21 Jan 2025 00:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737420573; cv=none; b=qPY/XWWKaevhLOG9NDitQEiLfS6BB5egBIXlKbXWSCY361YX0rKvrQnWjbkc5BEx4PNTdbY/SZTjldef18kSsERFiUCx+dRiU1Uy6z3jz4NA/AS7WFU15UtHpveJhN9Q/KrewJGO4M18ef5DjyE84zyZMtYe3Fm5TgFqfzUKfK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737420573; c=relaxed/simple;
	bh=Q1g8s/x8vcKYx27QtCyPr/MWIVaWCATQBdsGXa2Kfj8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dG/YnhnD4ZItpodpys+UvRI797iDcnQR/rIzLOcihLpb+7e9YeCK+gvQ1kMPsUBTwDwUc+TgK6Fypjbkm3iP5SA4FhSS2wIUgDrDJowr4sHgqysI3AWp1sUmp65H2vjyoDN1mVgCnFR44HwQTdU17H5l8a1SDJJCThG/sY2JrTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=afDjHOPX; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="afDjHOPX"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-54298ec925bso6047456e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 20 Jan 2025 16:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737420569; x=1738025369; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gP6qn/FApXQMq6lfA//qwEAQ2ecx1WiySyCatf4tjXg=;
        b=afDjHOPX4ZtV8vLMKcQAP6YLNzSW867yeOK7Z/Xb7aIe6uAnkkVXikMZhQ9ZG1+2VE
         0IOAT4/QvPKPc3oABVYHX5Suf+dNX2dAEfbVXIvkP+wvwQlouL5dyv2lhf89H0nwARh5
         2JUdEtTDd8ThCz5PnZEmkTy9vbwpCBlQVMQdbatVINI9hpEnx0G2ioc/1cmto220iBfn
         g4UHRU70gnI4Q+SsmjF9v59x22WCVQCRMSmZWRD01Zne2GzdLPa4idMKpx3ft28ELHJ7
         g0jJM97NkpcBw/6Dto6Hj3730u4CzQrZdEcQCWV+uKuBdai8jg8ZQGixaXWWx8h1DfUm
         nfSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737420569; x=1738025369;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gP6qn/FApXQMq6lfA//qwEAQ2ecx1WiySyCatf4tjXg=;
        b=SrSpJs08+SQwBz5XCOyPQXheABuN+HMYchk/vhdGUrJg7cdmqWo/UfMGB42eKJ/W+A
         SSP9XF0vAokW04lotbFijuqFUzXZlJj8gx2Jh8+6k8rneK3gmgU/Fznjn/79s762EYAG
         m8Rsd5YeWM2xdIuA3C1msdKIuTiabijlCFq1rtKogjAmrgLhAluOjIJJbUIF5O5lGZG3
         Pmkt6rMH/CcaVcpUDEIaHTi9DJMppqpvPHaTIDYkkOQWrMzzsga1Ug1B16ikRz4nEFBJ
         CpJC9YBHb7xHddwB1gG+4iws9h0tD+SHKQ+IzG2Boreqin4OyIvksTkIWUsi/gtF1DmQ
         lWsQ==
X-Gm-Message-State: AOJu0YypAz/ggWndWWdJv/ucWhh9DTe0itH8ClZ8BJtNFP/MFYcQs8rG
	yP8hwkBdh2ritMOv19MLEThvdfjM4qEICzwVSb0Y22L5xQg6V4bfuPKpDfNM2j5lfCcEKINdT+7
	JNnRqw711jAsWHCyS2sh9pDbv+vUeFvNF
X-Gm-Gg: ASbGnctXkdTtOI+xVdzRl7hdaGe0kPlvYye5Ev8DHB/5maEeoYEO6ctulDYKUmguhc0
	hpYarknIZtBhqi5m2oMuczkeIA5lgKRtBTGyh1lwIDzQsfu05AaM=
X-Google-Smtp-Source: AGHT+IEWaxK+9wGppAbFwsHDURuk8fWxO4/Lgd421+KZSS7CoVqSju/Hl3Qmjm7w9bBbmpashEJmLLCNgKfk5TzEKro=
X-Received: by 2002:a05:6512:4808:b0:542:2e09:639a with SMTP id
 2adb3069b0e04-5439c22a678mr3884436e87.10.1737420569281; Mon, 20 Jan 2025
 16:49:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 20 Jan 2025 18:49:17 -0600
X-Gm-Features: AbW1kva4btopGe5bFJjKlsMP0x00iSujiyZn9EhKmArgYPguVTyvomDkrZTAqS0
Message-ID: <CAH2r5mscBfMimoxO8yYQAB1SEdDhdjpwQxkw-45+tWL5tcsqZQ@mail.gmail.com>
Subject: [PATCH][cifs-utils] avoid using mktemp when updating mtab
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Content-Type: multipart/mixed; boundary="000000000000dbc8fa062c2cbffb"

--000000000000dbc8fa062c2cbffb
Content-Type: text/plain; charset="UTF-8"

Attached patch to  Fix build warning: cifs-utils/mount.cifs.c:1726:
    warning: the use of `mktemp' is dangerous, better use `mkstemp' or `mkdtemp'

Use of mktemp() has been deprecated (e.g. due to security issues with
symlink races), and instead mkstemp is often recommended.  Change
the use of mktemp to mkstemp in del_mtab in cifs-utils

Fixes: f46dd7661cfb ("mount.cifs: Properly update mtab during remount")

Opinions? Better way to address it?

-- 
Thanks,

Steve

--000000000000dbc8fa062c2cbffb
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-utils-avoid-using-mktemp-when-updating-mtab.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-utils-avoid-using-mktemp-when-updating-mtab.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m65r92vq0>
X-Attachment-Id: f_m65r92vq0

RnJvbSBmODVjMGM2M2FkYjQ0MjJiMzAwNzcwYmZjMmQ4NDQ3NDJlMGZjY2Q3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjAgSmFuIDIwMjUgMTg6MzQ6MzggLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzLXV0aWxzOiBhdm9pZCB1c2luZyBta3RlbXAgd2hlbiB1cGRhdGluZyBtdGFiCgpGaXggYnVp
bGQgd2FybmluZzogY2lmcy11dGlscy9tb3VudC5jaWZzLmM6MTcyNjoKICAgIHdhcm5pbmc6IHRo
ZSB1c2Ugb2YgYG1rdGVtcCcgaXMgZGFuZ2Vyb3VzLCBiZXR0ZXIgdXNlIGBta3N0ZW1wJyBvciBg
bWtkdGVtcCcKClVzZSBvZiBta3RlbXAoKSBoYXMgYmVlbiBkZXByZWNhdGVkIChlLmcuIGR1ZSB0
byBzZWN1cml0eSBpc3N1ZXMgd2l0aApzeW1saW5rIHJhY2VzKSwgYW5kIGluc3RlYWQgbWtzdGVt
cCBpcyBvZnRlbiByZWNvbW1lbmRlZC4gIENoYW5nZQp0aGUgdXNlIG9mIG1rdGVtcCB0byBta3N0
ZW1wIGluIGRlbF9tdGFiIGluIGNpZnMtdXRpbHMKCkZpeGVzOiBmNDZkZDc2NjFjZmIgKCJtb3Vu
dC5jaWZzOiBQcm9wZXJseSB1cGRhdGUgbXRhYiBkdXJpbmcgcmVtb3VudCIpClNpZ25lZC1vZmYt
Ynk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBtb3VudC5jaWZz
LmMgfCAxMiArKysrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDQg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbW91bnQuY2lmcy5jIGIvbW91bnQuY2lmcy5jCmlu
ZGV4IGU0NjY5M2UuLjc2MDUxMzAgMTAwNjQ0Ci0tLSBhL21vdW50LmNpZnMuYworKysgYi9tb3Vu
dC5jaWZzLmMKQEAgLTQxLDYgKzQxLDcgQEAKICNpbmNsdWRlIDxtbnRlbnQuaD4KICNpbmNsdWRl
IDxmY250bC5oPgogI2luY2x1ZGUgPGxpbWl0cy5oPgorI2luY2x1ZGUgPHN0ZGJvb2wuaD4KICNp
bmNsdWRlIDxwYXRocy5oPgogI2luY2x1ZGUgPGxpYmdlbi5oPgogI2luY2x1ZGUgPHRpbWUuaD4K
QEAgLTE2ODgsNyArMTY4OSw3IEBAIGFkZF9tdGFiX2V4aXQ6CiBzdGF0aWMgaW50CiBkZWxfbXRh
YihjaGFyICptb3VudHBvaW50KQogewotCWludCBsZW4sIHRtcHJjLCByYyA9IDA7CisJaW50IGxl
biwgdG1wcmMsIHJjID0gMCwgdG1wZmQ7CiAJRklMRSAqbW50dG1wLCAqbW50bXRhYjsKIAlzdHJ1
Y3QgbW50ZW50ICptb3VudGVudDsKIAljaGFyICptdGFiZmlsZSwgKm10YWJkaXIsICptdGFidG1w
ZmlsZSA9IE5VTEw7CkBAIC0xNzIzLDggKzE3MjQsOSBAQCBkZWxfbXRhYihjaGFyICptb3VudHBv
aW50KQogCQlnb3RvIGRlbF9tdGFiX2V4aXQ7CiAJfQogCi0JbXRhYnRtcGZpbGUgPSBta3RlbXAo
bXRhYnRtcGZpbGUpOwotCWlmICghbXRhYnRtcGZpbGUpIHsKKwkvLyBVc2UgbWtzdGVtcCBpbnN0
ZWFkIG9mIG1rdGVtcAorCXRtcGZkID0gbWtzdGVtcChtdGFidG1wZmlsZSk7CisJaWYgKHRtcGZk
ID09IC0xKSB7CiAJCWZwcmludGYoc3RkZXJyLCAiZGVsX210YWI6IGNhbm5vdCBzZXR1cCB0bXAg
ZmlsZSBkZXN0aW5hdGlvblxuIik7CiAJCXJjID0gRVhfRklMRUlPOwogCQlnb3RvIGRlbF9tdGFi
X2V4aXQ7CkBAIC0xNzM0LDEzICsxNzM2LDE1IEBAIGRlbF9tdGFiKGNoYXIgKm1vdW50cG9pbnQp
CiAJaWYgKCFtbnRtdGFiKSB7CiAJCWZwcmludGYoc3RkZXJyLCAiZGVsX210YWI6IGNvdWxkIG5v
dCB1cGRhdGUgbW91bnQgdGFibGVcbiIpOwogCQlyYyA9IEVYX0ZJTEVJTzsKKwkJY2xvc2UodG1w
ZmQpOwogCQlnb3RvIGRlbF9tdGFiX2V4aXQ7CiAJfQogCi0JbW50dG1wID0gc2V0bW50ZW50KG10
YWJ0bXBmaWxlLCAidyIpOworCW1udHRtcCA9IGZkb3Blbih0bXBmZCwgInciKTsKIAlpZiAoIW1u
dHRtcCkgewogCQlmcHJpbnRmKHN0ZGVyciwgImRlbF9tdGFiOiBjb3VsZCBub3QgdXBkYXRlIG1v
dW50IHRhYmxlXG4iKTsKIAkJZW5kbW50ZW50KG1udG10YWIpOworCQljbG9zZSh0bXBmZCk7CiAJ
CXJjID0gRVhfRklMRUlPOwogCQlnb3RvIGRlbF9tdGFiX2V4aXQ7CiAJfQotLSAKMi40My4wCgo=
--000000000000dbc8fa062c2cbffb--
