Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A91368
	for <linux-cifs@vger.kernel.org>; Fri, 29 Mar 2024 06:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711693858; cv=none; b=URxhXqBHedEoDdx5xI+Gb6F5khrIY9/GGMc39dsr09Xcj2sGYz6m6QEupmxogWcGssAb13yhl8ypqQW4g0RFPw7N/4Y9tpudbmeAR51P5T+P+6hw7QT8AaAutXs3sAXW/yNb2Kw9eVaxt5oGc7sct1Z6AAInFVYBL3713g+kkmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711693858; c=relaxed/simple;
	bh=yefb00dYkOw4HUkVqK7aKYEePX0QeskAqyXWT3nV72E=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=ontrSkaTGpdLx+wEuFmBXF9PBck+QBnbfjIh8lJypEg7BX1C3g0CVM3NmGvT8rn1PYDGR/PpOdM5Jtxq6SIcAUYKh/+1okj5DZYf7UkhOsz13eGS4st+ca+b6/uwPrFbn1sFzai9NmKpRkZ8gN/a4htu0gIK7S4gHcnMl2FWocE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Un6dT+s2; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Un6dT+s2"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-515c50dc2afso1802713e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 28 Mar 2024 23:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711693854; x=1712298654; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=M99wBygfGsxC5Fq3pgTqPVft4uFNhZ02XjuB4v30Nes=;
        b=Un6dT+s2so8b76afjxwSS5im8sTl+zkpKj1LllBIY/BUUBu6gL29bRD6p3aqFXAXeZ
         a3VASP5Lr6JERqT9mWIEuI0O01J/C+R0G/s1oIBYlPGyYJsl6Ku+rLgvPDJzJJj8fmw2
         UKTQywZvcb/ed8HrteAjpDUOWwion+IvAVjDAu0ho2KkGtMlHGVmvqwcYObnbwdIOxdv
         8SiVnuE9ArnNuOFl6VPw6qpHNYkyN1BzFALtxI4x7cOMqOe/pOVixWDVepcFhqAnifpH
         DpCQyJVLJyGl0ZfNfiqRAKtXye9qPd2K2gGVELM+TvAy0Ex5okYXiZJEAeQHWIVyx2ks
         m4OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711693854; x=1712298654;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M99wBygfGsxC5Fq3pgTqPVft4uFNhZ02XjuB4v30Nes=;
        b=lmPb0CQJFfiRjhr6FHGZVEdfNrZrhYnTN4PcrX0QwRBUYCPY+6GC/+8Bsa9iW1Gssw
         AmQoNOfoxv+jLVnIhOSES5kQEl9/fzN0K6lKroHGvSHqFW5O1O3h34zGryHVrShjqnGG
         U5AAExVyEUd/SrVpuTWgsIQgolpdXowG8FRt6GesRLJ6BaXUMEY+oUvMWDEzcgQPayPZ
         +c2BReHTtSz4L73nVB7SBeFtKqYO7owxd77SdPelhkSpcfSKeUkTlgO9CNHJU8Vm6DOK
         kSb2j3wY5KHeMzLk2chAmY2CUolgMmvaRqQwXe4AfkgIWXatKWKWo5QP1/XlxxyU1uMk
         MI/Q==
X-Gm-Message-State: AOJu0Yxrqexa9szFeKsNDTm5TG0aUwgfVWea8TJ1yTCyslnqVDJwrLpD
	7vZk1/FXYUn4KrGjsOKV7dy+7aDgNxPxTQcwdmxdsV6ah6cF/yo+NZ+KwkAvcl0HVI7Che0q5Xg
	CB/fBt4VhD5QIRJcFSmzZ0hdC9J8XxMaQrbE=
X-Google-Smtp-Source: AGHT+IFCrzw2EW7Rs5fpfTVOyMybC5a4YPCWuZtNq14XUWpTYFqCr/K3jGnGZLkLlCQxU0RnuREZWHmYfDOYVfR+ezc=
X-Received: by 2002:ac2:4642:0:b0:515:b764:9057 with SMTP id
 s2-20020ac24642000000b00515b7649057mr1020533lfo.35.1711693853910; Thu, 28 Mar
 2024 23:30:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 29 Mar 2024 01:30:42 -0500
Message-ID: <CAH2r5muYgYr=kxSkzCmNQLaF0br_QZ2s=BLPd_TnOnPmTUz_WQ@mail.gmail.com>
Subject: [PATCH][WIP] populate superblock uuid at mount time
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: multipart/mixed; boundary="0000000000002089d50614c6c85c"

--0000000000002089d50614c6c85c
Content-Type: text/plain; charset="UTF-8"

In order to get the unique id for the volume (the 8 byte
VolumeSerialNumber) we need to issue a QUERY_INFO level 59
(FILE_ID_INFORMATION).  Today we only query the older 4 byte (not
guaranteed to be unique serial number).   See section 2.4.21 of
MS-FSCC.  Looks like Samba and ksmbd do not support this info level
though - although Windows does support it.

Any thoughts on ksmbd or Samba support for FILE_ID_INFORMATION query?

See attached work in progress patch

-- 
Thanks,

Steve

--0000000000002089d50614c6c85c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-update-sb-uuid-when-full-id-information-availab.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-update-sb-uuid-when-full-id-information-availab.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_luca8ywa0>
X-Attachment-Id: f_luca8ywa0

RnJvbSBhNWY5MGI0NmIxN2QyMGFmNGNkYmZhZTZhYzQzZGFiYzFlNThlODdlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjkgTWFyIDIwMjQgMDA6MzA6NDkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiB1cGRhdGUgc2IgdXVpZCB3aGVuIGZ1bGwgaWQgaW5mb3JtYXRpb24gYXZhaWxhYmxlCgpT
b21lIHNlcnZlcnMgbGlrZSBXaW5kb3dzIGFuZCBBenVyZSByZXBvcnQgdGhlIGxhcmdlciAoMTYg
Ynl0ZSkKdW5pcXVlIHZvbHVtZSBzZXJpYWwgbnVtYmVyLiAgRm9yIHRob3NlIHRoYXQgcmV0dXJu
IGZ1bGxfaWRfaW5mb3JtYXRpb24KcG9wdWxhdGUgdGhlIHNiLT5zX3V1aWQKClRoaXMgd2lsbCBh
bHNvIGFsbG93IHRoZSBuZXcgaW9jdGwgRlNfSU9DX0dFVEZTVVVJRCB0byB3b3JrCgpTaWduZWQt
b2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21i
L2NsaWVudC9jaWZzZnMuYyAgICB8ICAyICsrCiBmcy9zbWIvY2xpZW50L2NpZnNnbG9iLmggIHwg
IDEgKwogZnMvc21iL2NsaWVudC9zbWIyb3BzLmMgICB8ICAyICsrCiBmcy9zbWIvY2xpZW50L3Nt
YjJwZHUuYyAgIHwgMTggKysrKysrKysrKysrKysrKysrCiBmcy9zbWIvY2xpZW50L3NtYjJwcm90
by5oIHwgIDIgKysKIDUgZmlsZXMgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdp
dCBhL2ZzL3NtYi9jbGllbnQvY2lmc2ZzLmMgYi9mcy9zbWIvY2xpZW50L2NpZnNmcy5jCmluZGV4
IGFhNmYxZWNiN2MwZS4uYzY0NDVmOTNkOTU0IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2Np
ZnNmcy5jCisrKyBiL2ZzL3NtYi9jbGllbnQvY2lmc2ZzLmMKQEAgLTI2OSw2ICsyNjksOCBAQCBj
aWZzX3JlYWRfc3VwZXIoc3RydWN0IHN1cGVyX2Jsb2NrICpzYikKIAkJZ290byBvdXRfbm9fcm9v
dDsKIAl9CiAKKwlpZiAodGNvbi0+dm9sX3V1aWQgIT0gMCkKKwkJc3VwZXJfc2V0X3V1aWQoc2Is
ICh2b2lkICopJnRjb24tPnZvbF91dWlkLCBzaXplb2YodGNvbi0+dm9sX3V1aWQpKTsKICNpZmRl
ZiBDT05GSUdfQ0lGU19ORlNEX0VYUE9SVAogCWlmIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAm
IENJRlNfTU9VTlRfU0VSVkVSX0lOVU0pIHsKIAkJY2lmc19kYmcoRllJLCAiZXhwb3J0IG9wcyBz
dXBwb3J0ZWRcbiIpOwpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oIGIvZnMv
c21iL2NsaWVudC9jaWZzZ2xvYi5oCmluZGV4IDdlZDlkMDVmNjg5MC4uZGFlMTExNjZlYjZmIDEw
MDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmgKKysrIGIvZnMvc21iL2NsaWVudC9j
aWZzZ2xvYi5oCkBAIC0xMjY0LDYgKzEyNjQsNyBAQCBzdHJ1Y3QgY2lmc190Y29uIHsKIAlfX3Uz
MiBzaGFyZV9mbGFnczsKIAlfX3UzMiBtYXhpbWFsX2FjY2VzczsKIAlfX3UzMiB2b2xfc2VyaWFs
X251bWJlcjsKKwlfX3U2NCB2b2xfdXVpZDsgLyogZnVsbCAoNjQgYml0LCB1bmlxdWUpIHNlcmlh
bCBudW1iZXIgKi8KIAlfX2xlNjQgdm9sX2NyZWF0ZV90aW1lOwogCV9fdTY0IHNuYXBzaG90X3Rp
bWU7IC8qIGZvciB0aW1ld2FycCB0b2tlbnMgLSB0aW1lc3RhbXAgb2Ygc25hcHNob3QgKi8KIAlf
X3UzMiBoYW5kbGVfdGltZW91dDsgLyogcGVyc2lzdGVudCBhbmQgZHVyYWJsZSBoYW5kbGUgdGlt
ZW91dCBpbiBtcyAqLwpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIyb3BzLmMgYi9mcy9z
bWIvY2xpZW50L3NtYjJvcHMuYwppbmRleCAyZWQ0NTY5NDhmMzQuLjg0ZDJmM2YxYzg5YSAxMDA2
NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zbWIyb3BzLmMKKysrIGIvZnMvc21iL2NsaWVudC9zbWIy
b3BzLmMKQEAgLTgzMSw2ICs4MzEsOCBAQCBzbWIzX3Fmc190Y29uKGNvbnN0IHVuc2lnbmVkIGlu
dCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJaWYgKHJjKQogCQlyZXR1cm47CiAKKwlT
TUIyX2dldF92b2xfc2VyaWFsX251bSh4aWQsIHRjb24sIGZpZC5wZXJzaXN0ZW50X2ZpZCwgZmlk
LnZvbGF0aWxlX2ZpZCk7CisKIAlTTUIzX3JlcXVlc3RfaW50ZXJmYWNlcyh4aWQsIHRjb24sIHRy
dWUgLyogY2FsbGVkIGR1cmluZyAgbW91bnQgKi8pOwogCiAJU01CMl9RRlNfYXR0cih4aWQsIHRj
b24sIGZpZC5wZXJzaXN0ZW50X2ZpZCwgZmlkLnZvbGF0aWxlX2ZpZCwKZGlmZiAtLWdpdCBhL2Zz
L3NtYi9jbGllbnQvc21iMnBkdS5jIGIvZnMvc21iL2NsaWVudC9zbWIycGR1LmMKaW5kZXggM2Vh
Njg4NTU4ZTZjLi5mMjYyYjgyNTFiMmUgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMnBk
dS5jCisrKyBiL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jCkBAIC0zOTA4LDYgKzM5MDgsMjQgQEAg
U01CMl9xdWVyeV9hY2woY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAq
dGNvbiwKIAkJCSAgU01CMl9NQVhfQlVGRkVSX1NJWkUsIE1JTl9TRUNfREVTQ19MRU4sIGRhdGEs
IHBsZW4pOwogfQogCitpbnQKK1NNQjJfZ2V0X3ZvbF9zZXJpYWxfbnVtKGNvbnN0IHVuc2lnbmVk
IGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCisJCQl1NjQgcGVyc2lzdGVudF9maWQs
IHU2NCB2b2xhdGlsZV9maWQpCit7CisJaW50IHJjOworCXN0cnVjdCBzbWIyX2ZpbGVfaWRfaW5m
b3JtYXRpb24gdm9sX2luZm87CisKKwlyYyA9IHF1ZXJ5X2luZm8oeGlkLCB0Y29uLCBwZXJzaXN0
ZW50X2ZpZCwgdm9sYXRpbGVfZmlkLAorCQkJICBGSUxFX0lEX0lORk9STUFUSU9OLCBTTUIyX09f
SU5GT19GSUxFLCAwLAorCQkJICBzaXplb2Yoc3RydWN0IHNtYjJfZmlsZV9pZF9pbmZvcm1hdGlv
biksCisJCQkgIHNpemVvZihzdHJ1Y3Qgc21iMl9maWxlX2lkX2luZm9ybWF0aW9uKSwKKwkJCSAg
KHZvaWQgKiopJnZvbF9pbmZvLCBOVUxMKTsKKwlpZiAoIXJjKQorCQl0Y29uLT52b2xfdXVpZCA9
IGxlNjRfdG9fY3B1KHZvbF9pbmZvLlZvbHVtZVNlcmlhbE51bWJlcik7CisKKwlyZXR1cm4gcmM7
Cit9CisKIGludAogU01CMl9nZXRfc3J2X251bShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1
Y3QgY2lmc190Y29uICp0Y29uLAogCQkgdTY0IHBlcnNpc3RlbnRfZmlkLCB1NjQgdm9sYXRpbGVf
ZmlkLCBfX2xlNjQgKnVuaXF1ZWlkKQpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIycHJv
dG8uaCBiL2ZzL3NtYi9jbGllbnQvc21iMnByb3RvLmgKaW5kZXggNzMyMTY5ZDhhNjdhLi5iNTE4
ZjFmZGVkY2YgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMnByb3RvLmgKKysrIGIvZnMv
c21iL2NsaWVudC9zbWIycHJvdG8uaApAQCAtMjA3LDYgKzIwNyw4IEBAIGV4dGVybiB2b2lkIFNN
QjJfcXVlcnlfaW5mb19mcmVlKHN0cnVjdCBzbWJfcnFzdCAqcnFzdCk7CiBleHRlcm4gaW50IFNN
QjJfcXVlcnlfYWNsKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRj
b24sCiAJCQkgIHU2NCBwZXJzaXN0ZW50X2ZpbGVfaWQsIHU2NCB2b2xhdGlsZV9maWxlX2lkLAog
CQkJICB2b2lkICoqZGF0YSwgdW5zaWduZWQgaW50ICpwbGVuLCB1MzIgaW5mbyk7CitleHRlcm4g
aW50IFNNQjJfZ2V0X3ZvbF9zZXJpYWxfbnVtKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVj
dCBjaWZzX3Rjb24gKnRjb24sCisJCQkgICAgdTY0IHBlcnNpc3RlbnRfZmlkLCB1NjQgdm9sYXRp
bGVfZmlkKTsKIGV4dGVybiBpbnQgU01CMl9nZXRfc3J2X251bShjb25zdCB1bnNpZ25lZCBpbnQg
eGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJICAgIHU2NCBwZXJzaXN0ZW50X2ZpZCwg
dTY0IHZvbGF0aWxlX2ZpZCwKIAkJCSAgICBfX2xlNjQgKnVuaXF1ZWlkKTsKLS0gCjIuNDAuMQoK
--0000000000002089d50614c6c85c--
