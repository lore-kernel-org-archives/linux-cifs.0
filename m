Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75D9383A5;
	Wed,  1 Jan 2025 17:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735751151; cv=none; b=m/hiIAYaiIGXis3fHjcnc97okvs2fQAvKIF9uCgQAw3AlP22CftOO1fIFeVaXJLsPPTv9jJ7jVNQ7u7reqbtDarmMOV0ycUkD3Mc6g/N3Gy8TYtLEowWXTUUWaHuq/bT1KRHV9918K/WoiTfLEzEknAhlMEYHq7TpqtL6YIZXrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735751151; c=relaxed/simple;
	bh=feFWZW3rkzOtU7RfQnwUIGVEN7+7bZAkc/w06X3jcdM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=nXxu+6t5+tPWeJad292KnA7bNOiSOeL8CGTAyI0HQorbRlRxdS8ysKyRgnANw/XMt2NGSjFt/lzgFzdwKaTSh1RhAMFoNwNgZ8F9ZJv/S0n68xzWY2nfxLohp0t7lCKbtaEe95W7I0IZDZJoejMQb88ekRCmxXs1uWk1CuAAK6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e3wIQi44; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e3wIQi44"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-30229d5b229so114954691fa.0;
        Wed, 01 Jan 2025 09:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735751147; x=1736355947; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=feFWZW3rkzOtU7RfQnwUIGVEN7+7bZAkc/w06X3jcdM=;
        b=e3wIQi44P+Jm0L7FEzYvt0LHtZPLfcBdQK2S9NzyojZjohzVaBQEg3H6MldFagDcYl
         voeAepGHryxO4btK64uCsR214f9eAvjfMH11fLpklA4LXP1Kd1eK9Y7n9lq6p0iAR2PJ
         GHAtIur8EQ8qHpA5/2noGDn4DoF7gC+VDWMfb2VBPIHMogypyGAT9Ly9Lviv2VVVALBp
         0vf6syQVgGCNb2fbKAbXC2DDyaVMzpGE1TKkKmyfZVLL3mDe2FnmrqzP0kiBcuqoIJdU
         2r/HnFUjhaviTTset1GodfdWRaOs7HOsX6QGi6pmCT7SO4EvcKzAjVgEXUHlqFpd7Fao
         Pl7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735751147; x=1736355947;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=feFWZW3rkzOtU7RfQnwUIGVEN7+7bZAkc/w06X3jcdM=;
        b=WSKvsDGZQsx7JkvQDNf1ul3DWpCN0o+AWEowJGLxIxPgVXehlQyVhlSZojQ+RWxSBi
         xb/zhdZ6hn9cU+irWpFFvMeKfxmr7KOxiByBMk6QNBGB+0DPF0JJ7nqkud78mTsRBofA
         e5DdxeLk0F7DI58fuxVTXnDpBI26XSNSAOgFsEWX9tz2lZg1IplhBUbVObp4crkrBOt6
         OkZhplC4abp1y9VyypvgDzHGe5hW5U50Fu0u5Z0sVZUbHDXgZgYusK8bycITx4otgOMF
         jxMdoiz6C3/MV2visun+8rpLevKuyHmf6mTpdE89LOp1WkOLMA/Q2u23nki/vAuNlda8
         OT7A==
X-Gm-Message-State: AOJu0YwzxEnGZFiam05O+yxXgDsDUu6Zr4uFJa3ceDuVR3/Wn88aacnH
	Yo3mLqzuXMNmKi795cNHaCpger5dhz//XMDNGj6PN85nxahQ1oFKZOuTVN5RsB4E0+cEYmQKkkj
	DjuKVyiPcouDAuXhjT5/yt0szp53X1w==
X-Gm-Gg: ASbGncuDr27FAbhWpcpEKtTgwkt/NoYH0l1+5R7h9mVe6uejywAVNeISR4fDckdiQBC
	78D+6clWKt1oQ+jA+o7hmF9Pgg8tnQm/K9O5vcQ==
X-Google-Smtp-Source: AGHT+IEo0bo4Yodqf4QD4aYOmZ/S3HQH4TfRqlMDRbYTNOgOmwseVmLgPbkViXYZ3Augr3T+AS4kVcIrirwSl2n6xPw=
X-Received: by 2002:a05:6512:3a90:b0:540:2a76:584b with SMTP id
 2adb3069b0e04-54229581e83mr13244695e87.36.1735751146576; Wed, 01 Jan 2025
 09:05:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Oleh Nykyforchyn <oleh.nyk@gmail.com>
Date: Wed, 1 Jan 2025 20:08:06 +0200
Message-ID: <CAPhCUnV5ocw5HfW+jNRaRPgntoM4uXeHNcC03XL00wLZjSm1Vw@mail.gmail.com>
Subject: Bug in getting file attributes with SMB3.1.1 and posix
To: linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>
Content-Type: multipart/mixed; boundary="00000000000082c072062aa80e8b"

--00000000000082c072062aa80e8b
Content-Type: multipart/alternative; boundary="00000000000082c06f062aa80e89"

--00000000000082c06f062aa80e89
Content-Type: text/plain; charset="UTF-8"

Hello,

I encountered a funny bug when a share is mounted with vers=3.1.1,
posix,... If a file size has bits 0x410 = ATTR_DIRECTORY | ATTR_REPARSE =
1040 set, then the file is regarded as a directory and its open fails. A
simplest test example is any file 1040 bytes long.

The cause of this bug is that Attributes field in smb2_file_all_info struct
occupies the same place that EndOfFile field in smb311_posix_qinfo, and
sometimes the latter struct is incorrectly processed as if it was the first
one. I attach an example patch that solves the problem for me, obviously
not ready for submission, but just to show which places in the code are
subject to problems. The patch is against linux-6.12.6 kernel, but, AFAICS,
nothing has changed since then in relevant places. If I have guessed more
or less correctly what the intended functionality is, please feel free to
use my patch as a basis for corrections.

Best regards

Olen Nykyforchyn

--00000000000082c06f062aa80e89
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<div><br></div><div>I encountered a funny bug when a=
 share=C2=A0is mounted with vers=3D3.1.1, posix,... If a file size has bits=
 0x410 =3D ATTR_DIRECTORY | ATTR_REPARSE =3D 1040 set, then the file is reg=
arded as a directory and=C2=A0its open fails. A simplest test example is an=
y file 1040 bytes long.</div><div><br></div><div>The cause of this bug is t=
hat Attributes field in smb2_file_all_info struct occupies the same place t=
hat EndOfFile field in smb311_posix_qinfo, and sometimes=C2=A0the latter st=
ruct is incorrectly processed as if it was the first one. I attach an examp=
le patch that solves=C2=A0the problem for me, obviously not ready for submi=
ssion, but just to show which places in the code are subject to problems. T=
he patch=C2=A0is against linux-6.12.6 kernel, but, AFAICS, nothing has chan=
ged since then in relevant places. If I have guessed more or less correctly=
 what the intended functionality is, please feel=C2=A0free to use my patch =
as a basis for corrections.</div><div><br></div><div>Best regards</div><div=
><br></div><div>Olen Nykyforchyn</div></div>

--00000000000082c06f062aa80e89--
--00000000000082c072062aa80e8b
Content-Type: text/x-patch; charset="US-ASCII"; name="linux-6.12.6-attrs.patch"
Content-Disposition: attachment; filename="linux-6.12.6-attrs.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m5e7mgl50>
X-Attachment-Id: f_m5e7mgl50

LS0tIGxpbnV4LTYuMTIuNi9mcy9zbWIvY2xpZW50L3JlcGFyc2UuaC5vcmlnCTIwMjQtMTItMjgg
MTU6Mzc6MzIuMjUyNjIxMzc4ICswMjAwCisrKyBsaW51eC02LjEyLjYvZnMvc21iL2NsaWVudC9y
ZXBhcnNlLmgJMjAyNC0xMi0yOCAxNTo1MTowMC4wMDQ2NTQzOTAgKzAyMDAKQEAgLTEwOCw2ICsx
MDgsMTYgQEAKIAlyZXR1cm4gcmV0OwogfQogCitzdGF0aWMgaW5saW5lIGJvb2wgc21iMzExX29w
ZW5fZGF0YV9yZXBhcnNlKHN0cnVjdCBjaWZzX29wZW5faW5mb19kYXRhICpkYXRhKQoreworCXN0
cnVjdCBzbWIzMTFfcG9zaXhfcWluZm8gKnBvc2l4X2ZpID0gJmRhdGEtPnBvc2l4X2ZpOworCXUz
MiB0YWcgPSBsZTMyX3RvX2NwdShwb3NpeF9maS0+UmVwYXJzZVRhZyk7CisJYm9vbCByZXQ7CisK
KwlyZXQgPSBkYXRhLT5yZXBhcnNlX3BvaW50IHx8IHRhZzsKKwlyZXR1cm4gcmV0OworfQorCiBi
b29sIGNpZnNfcmVwYXJzZV9wb2ludF90b19mYXR0cihzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZz
X3NiLAogCQkJCSBzdHJ1Y3QgY2lmc19mYXR0ciAqZmF0dHIsCiAJCQkJIHN0cnVjdCBjaWZzX29w
ZW5faW5mb19kYXRhICpkYXRhKTsKLS0tIGxpbnV4LTYuMTIuNi9mcy9zbWIvY2xpZW50L2lub2Rl
LmMub3JpZwkyMDI0LTEyLTI4IDE1OjQ3OjU2LjYwMzY0Njg5NSArMDIwMAorKysgbGludXgtNi4x
Mi42L2ZzL3NtYi9jbGllbnQvaW5vZGUuYwkyMDI0LTEyLTMwIDE4OjE5OjUyLjgxNjAzOTc5OCAr
MDIwMApAQCAtODQ1LDcgKzg0NSw3IEBACiAJZmF0dHItPmNmX21vZGUgPSB3aXJlX21vZGVfdG9f
cG9zaXgobGUzMl90b19jcHUoaW5mby0+TW9kZSksCiAJCQkJCSAgICBmYXR0ci0+Y2ZfY2lmc2F0
dHJzICYgQVRUUl9ESVJFQ1RPUlkpOwogCi0JaWYgKGNpZnNfb3Blbl9kYXRhX3JlcGFyc2UoZGF0
YSkgJiYKKwlpZiAoc21iMzExX29wZW5fZGF0YV9yZXBhcnNlKGRhdGEpICYmCiAJICAgIGNpZnNf
cmVwYXJzZV9wb2ludF90b19mYXR0cihjaWZzX3NiLCBmYXR0ciwgZGF0YSkpCiAJCWdvdG8gb3V0
X3JlcGFyc2U7CiAKQEAgLTk3Niw3ICs5NzYsMTAgQEAKIAkJCXJjID0gUFRSX0VSUihwYXRoKTsK
IAkJCWdvdG8gY2dmaV9leGl0OwogCQl9Ci0JCWNpZnNfb3Blbl9pbmZvX3RvX2ZhdHRyKCZmYXR0
ciwgJmRhdGEsIGlub2RlLT5pX3NiKTsKKwkJaWYgKHRjb24tPnBvc2l4X2V4dGVuc2lvbnMpCisJ
CQlzbWIzMTFfcG9zaXhfaW5mb190b19mYXR0cigmZmF0dHIsICZkYXRhLCBpbm9kZS0+aV9zYik7
CisJCWVsc2UKKwkJCWNpZnNfb3Blbl9pbmZvX3RvX2ZhdHRyKCZmYXR0ciwgJmRhdGEsIGlub2Rl
LT5pX3NiKTsKIAkJaWYgKGZhdHRyLmNmX2ZsYWdzICYgQ0lGU19GQVRUUl9ERUxFVEVfUEVORElO
RykKIAkJCWNpZnNfbWFya19vcGVuX2hhbmRsZXNfZm9yX2RlbGV0ZWRfZmlsZShpbm9kZSwgcGF0
aCk7CiAJCWJyZWFrOwpAQCAtMTE3Niw3ICsxMTc5LDcgQEAKIAkJYnJlYWs7CiAJY2FzZSBJT19S
RVBBUlNFX1RBR19JTlRFUk5BTDoKIAkJcmMgPSAwOwotCQlpZiAobGUzMl90b19jcHUoZGF0YS0+
ZmkuQXR0cmlidXRlcykgJiBBVFRSX0RJUkVDVE9SWSkgeworCQlpZiAodGNvbi0+cG9zaXhfZXh0
ZW5zaW9ucyB8fCAobGUzMl90b19jcHUoZGF0YS0+ZmkuQXR0cmlidXRlcykgJiBBVFRSX0RJUkVD
VE9SWSkpIHsKIAkJCWNpZnNfY3JlYXRlX2p1bmN0aW9uX2ZhdHRyKGZhdHRyLCBzYik7CiAJCQln
b3RvIG91dDsKIAkJfQpAQCAtMTI1MCwxMiArMTI1MywxMiBAQAogCQkgKiBzaW5jZSB3ZSBoYXZl
IHRvIGNoZWNrIGlmIGl0cyByZXBhcnNlIHRhZyBtYXRjaGVzIGEga25vd24KIAkJICogc3BlY2lh
bCBmaWxlIHR5cGUgZS5nLiBzeW1saW5rIG9yIGZpZm8gb3IgY2hhciBldGMuCiAJCSAqLwotCQlp
ZiAoY2lmc19vcGVuX2RhdGFfcmVwYXJzZShkYXRhKSkgeworCQlpZiAoY2lmc19vcGVuX2RhdGFf
cmVwYXJzZShkYXRhKSkKIAkJCXJjID0gcmVwYXJzZV9pbmZvX3RvX2ZhdHRyKGRhdGEsIHNiLCB4
aWQsIHRjb24sCi0JCQkJCQkgICBmdWxsX3BhdGgsIGZhdHRyKTsKLQkJfSBlbHNlIHsKKwkJCQkJ
ICAgZnVsbF9wYXRoLCBmYXR0cik7CisJCWVsc2UKIAkJCWNpZnNfb3Blbl9pbmZvX3RvX2ZhdHRy
KGZhdHRyLCBkYXRhLCBzYik7Ci0JCX0KKwkJY2lmc19kYmcoRllJLCAiY2lmcyBkYXRhIHRvIGZh
dHRyLCByYz0lZFxuIiwgcmMpOwogCQlpZiAoIXJjICYmICppbm9kZSAmJgogCQkgICAgKGZhdHRy
LT5jZl9mbGFncyAmIENJRlNfRkFUVFJfREVMRVRFX1BFTkRJTkcpKQogCQkJY2lmc19tYXJrX29w
ZW5faGFuZGxlc19mb3JfZGVsZXRlZF9maWxlKCppbm9kZSwgZnVsbF9wYXRoKTsKQEAgLTEzODUs
NiArMTM4OCw4IEBACiAJCWNpZnNfZGJnKEZZSSwgIk5vIG5lZWQgdG8gcmV2YWxpZGF0ZSBjYWNo
ZWQgaW5vZGUgc2l6ZXNcbiIpOwogCQlyZXR1cm4gMDsKIAl9CisJZWxzZQorCQljaWZzX2RiZyhG
WUksICJHZXR0aW5nIGNpZnMgYXR0cmlidXRlcyBmb3IgJXNcbiIsIGZ1bGxfcGF0aCk7CiAKIAly
YyA9IGNpZnNfZ2V0X2ZhdHRyKGRhdGEsIHNiLCB4aWQsIGZpZCwgJmZhdHRyLCBpbm9kZSwgZnVs
bF9wYXRoKTsKIAlpZiAocmMpCkBAIC0xNDMxLDcgKzE0MzYsNyBAQAogCiAJc3dpdGNoIChyYykg
ewogCWNhc2UgMDoKLQkJaWYgKGNpZnNfb3Blbl9kYXRhX3JlcGFyc2UoZGF0YSkpIHsKKwkJaWYg
KHNtYjMxMV9vcGVuX2RhdGFfcmVwYXJzZShkYXRhKSkgewogCQkJcmMgPSByZXBhcnNlX2luZm9f
dG9fZmF0dHIoZGF0YSwgc2IsIHhpZCwgdGNvbiwKIAkJCQkJCSAgIGZ1bGxfcGF0aCwgZmF0dHIp
OwogCQl9IGVsc2UgewpAQCAtMTQ4NCw2ICsxNDg5LDggQEAKIAkJY2lmc19kYmcoRllJLCAiTm8g
bmVlZCB0byByZXZhbGlkYXRlIGNhY2hlZCBpbm9kZSBzaXplc1xuIik7CiAJCXJldHVybiAwOwog
CX0KKwllbHNlCisJCWNpZnNfZGJnKEZZSSwgIkdldHRpbmcgc21iMyBwb3NpeCBhdHRyaWJ1dGVz
IGZvciAlc1xuIiwgZnVsbF9wYXRoKTsKIAogCXJjID0gc21iMzExX3Bvc2l4X2dldF9mYXR0cihk
YXRhLCAmZmF0dHIsIGZ1bGxfcGF0aCwgc2IsIHhpZCk7CiAJaWYgKHJjKQo=
--00000000000082c072062aa80e8b--
