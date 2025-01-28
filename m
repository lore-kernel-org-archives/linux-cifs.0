Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94381C878E
	for <linux-cifs@vger.kernel.org>; Tue, 28 Jan 2025 07:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738048410; cv=none; b=aFf2GscAu2vJYYrlsbjcaanEbsEqS8SAdhjOW2j1muixBoSNxx8T97+R3cfQsBXpfF70Jpz5cNbcuJDJLTrbk3Tzasjsgk6uRQfbq6gq8ZE8T5Vd/i6i+ICZkpvQcQcI0QBj04hoNPXTrSZUtCbpduDqnodSNNRjfwBBJfEBids=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738048410; c=relaxed/simple;
	bh=5U+q8G47oNRn/ewSSC7hApC27P6RL4NTAgE+ob+bYmE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=iduuAvlETHvtsYwb6qZz+S3D70iM8pi3/sNeB0SKtPYFr0HsDtYNMHNyclGvshZ1tKPmeDOas3R/u0+XywF9kMDIjYuDBn8YA6/Z61HTwfisZmiYk1TthElxOYMuq3QRr6SeHdj89f6+p12ZbBk3lO9nAeMUbtnJpMSPgjNQK98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mwnPjy3C; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mwnPjy3C"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-540254357c8so5312120e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 27 Jan 2025 23:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738048406; x=1738653206; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WusTfgPBKYdPXO28CMdbQyIwxw9Tkvpu+VYEDGlZQyQ=;
        b=mwnPjy3CE1wAFNCfJXnoui5JRpTVyCD7rpySHYYT2J8dD3O1JTIdE+COO0u+Z1iFa1
         lRI9SyeEjbRIE+WuCcshYb4+46CHoOZwaHbkrhjzaWcEpZxtvyb5/TssXaruLdftsclg
         0aS8J1kvJQhiRbwwJ7hzaV4rAtBXN61UjzI9HU0sZhcM5V6s1LiFXMsgN52nAsnxsbZs
         pO++iaV3t+brGRfaUrgz2NxeD+fBZyUIIW1ycLGnszQ7MkYC3KnqRJBFu+juqSCVnP9t
         Hm8dVEwV3DsJe+FDG2agS4hrf17XhuDUyz+YzKgimoFqKkXSCp2YkfB0dBedfG2VFRzJ
         UAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738048406; x=1738653206;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WusTfgPBKYdPXO28CMdbQyIwxw9Tkvpu+VYEDGlZQyQ=;
        b=c125pCrf19zPLLF7iGfV8M+j5q24laq9crsYnEbGlR1dIHfbwdr1KeZFFlMMjyfj5j
         enD5qSjhJJw5KPXXW11yjzz3W9B9QuUdtfaAH51R+HsshSepvs5SJdvxQi9mVo4I72FR
         tBBCFm4TdY16QsAmuAlCx2XrJsK4CiCmi4f43yj6uHIcA/EpWp+PTspJGDTTdAZeDQUD
         4S2GOCfnV2H7rY+8nTvMHrWEsmpQEp8SEIAJosUi35NBPkbC3EDetzdobU7l4ue2kOfe
         Y7u8VekFFdqgaqwAsVgbPWzzhyHsVd6oJtlSyuBja1PE/jWKSK9vHNsutN8Bc0GoGbMM
         8FjQ==
X-Gm-Message-State: AOJu0YwgZJzuaePKv1m/YrQYpr3LU4DyRKhlr/SiAG/gdkwvjJZ7vhoS
	spE+p6f4kjzei/EKUXRzGsbPsJCIN1H8s6SAdd9H0QNP9xjquIWWoLl+Pi5soEHYqaKsv+TxmxI
	VSiOSWt49NEoYoNvP+LgyJanlqisGvn30
X-Gm-Gg: ASbGncv+xvYpZFun3q2opnqSzg8xDe8EYGFjLU9sd9HYr2byYrJXA9wSG9j4Pfc0M76
	f5ixVPFFo1JgjgTZvPZ/McgF+wxpEYZmLUs59XA77I/Oegc/yJdxBBbNn76CLru/1d7B+OBHcB/
	6Sml7x24oblKaWIQgLQKa3sNEnlPAKITE=
X-Google-Smtp-Source: AGHT+IHpnD3Jykh2NVNzhMAIMj3SA4VjCmtgIAevK5z3WKsdC0sDcs3lciRMCz2uMPEok9tSY4wLBK3eQPeyV2nICb8=
X-Received: by 2002:a05:6512:2346:b0:53e:23ec:b2e7 with SMTP id
 2adb3069b0e04-5439c2805f9mr16949223e87.34.1738048405980; Mon, 27 Jan 2025
 23:13:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 28 Jan 2025 01:13:14 -0600
X-Gm-Features: AWEUYZlQViSD1GYJ0S4TtC3UGoP482C6Dvz7VN2iCBkZw-Eu1oqzj9CvCS0YZX0
Message-ID: <CAH2r5mvq8F6o3+FQxFrJODndYrG_4Gb_A7n_i2Qae+8tZdR58A@mail.gmail.com>
Subject: [PATCH][SMB3 client] allow us to get kerberos ticket when server
 advertises IAKerb
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d76b2f062cbeed05"

--000000000000d76b2f062cbeed05
Content-Type: multipart/alternative; boundary="000000000000d76b2d062cbeed03"

--000000000000d76b2d062cbeed03
Content-Type: text/plain; charset="UTF-8"

There are now more servers which advertise support for IAKerb (passthrough
Kerberos authentication via proxy).  IAKerb is a public extension industry
standard Kerberos protocol that allows a client without line-of-sight
to a Domain Controller to authenticate. There can be cases where we
would fail to mount if the server only advertises the OID for IAKerb
in SPNEGO/GSSAPI.  Add code to allow us to still upcall to userspace
in these cases to obtain the Kerberos ticket.

See attached WIP patch
-- 
Thanks,

Steve

--000000000000d76b2d062cbeed03
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>There are now more servers which advertise support fo=
r IAKerb (passthrough<br>Kerberos authentication via proxy).=C2=A0 IAKerb i=
s a public extension industry<br>standard Kerberos protocol that allows a c=
lient without line-of-sight<br>to a Domain Controller to authenticate. Ther=
e can be cases where we<br>would fail to mount if the server only advertise=
s the OID for IAKerb<br>in SPNEGO/GSSAPI.=C2=A0 Add code to allow us to sti=
ll upcall to userspace<br>in these cases to obtain the Kerberos ticket.<br>=
</div><div><br></div><div>See attached WIP patch</div><span class=3D"gmail_=
signature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature" =
data-smartmail=3D"gmail_signature">Thanks,<br><br>Steve</div></div>

--000000000000d76b2d062cbeed03--
--000000000000d76b2f062cbeed05
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-smb3-add-support-for-IAKerb.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-support-for-IAKerb.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m6g53z010>
X-Attachment-Id: f_m6g53z010

RnJvbSA0NzcyNjUxZmYxODkwMDA5OGY3YTNlZTcwODhmZmJmZGMyMGM0YzE1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjggSmFuIDIwMjUgMDE6MDQ6MjMgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgc3VwcG9ydCBmb3IgSUFLZXJiCgpUaGVyZSBhcmUgbm93IG1vcmUgc2VydmVycyB3
aGljaCBhZHZlcnRpc2Ugc3VwcG9ydCBmb3IgSUFLZXJiIChwYXNzdGhyb3VnaApLZXJiZXJvcyBh
dXRoZW50aWNhdGlvbiB2aWEgcHJveHkpLiAgSUFLZXJiIGlzIGEgcHVibGljIGV4dGVuc2lvbiBp
bmR1c3RyeQpzdGFuZGFyZCBLZXJiZXJvcyBwcm90b2NvbCB0aGF0IGFsbG93cyBhIGNsaWVudCB3
aXRob3V0IGxpbmUtb2Ytc2lnaHQKdG8gYSBEb21haW4gQ29udHJvbGxlciB0byBhdXRoZW50aWNh
dGUuIFRoZXJlIGNhbiBiZSBjYXNlcyB3aGVyZSB3ZQp3b3VsZCBmYWlsIHRvIG1vdW50IGlmIHRo
ZSBzZXJ2ZXIgb25seSBhZHZlcnRpc2VzIHRoZSBPSUQgZm9yIElBS2VyYgppbiBTUE5FR08vR1NT
QVBJLiAgQWRkIGNvZGUgdG8gYWxsb3cgdXMgdG8gc3RpbGwgdXBjYWxsIHRvIHVzZXJzcGFjZQpp
biB0aGVzZSBjYXNlcyB0byBvYnRhaW4gdGhlIEtlcmJlcm9zIHRpY2tldC4KClNpZ25lZC1vZmYt
Ynk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xp
ZW50L2FzbjEuYyAgICAgICAgfCAyICsrCiBmcy9zbWIvY2xpZW50L2NpZnNfc3BuZWdvLmMgfCA0
ICsrKy0KIGZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaCAgICB8IDQgKysrKwogZnMvc21iL2NsaWVu
dC9zZXNzLmMgICAgICAgIHwgMyArKy0KIGZzL3NtYi9jbGllbnQvc21iMnBkdS5jICAgICB8IDIg
Ky0KIDUgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2FzbjEuYyBiL2ZzL3NtYi9jbGllbnQvYXNuMS5jCmlu
ZGV4IGI1NzI0ZWY5ZjE4Mi4uMjE0YTQ0NTA5ZTdiIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50
L2FzbjEuYworKysgYi9mcy9zbWIvY2xpZW50L2FzbjEuYwpAQCAtNTIsNiArNTIsOCBAQCBpbnQg
Y2lmc19uZWdfdG9rZW5faW5pdF9tZWNoX3R5cGUodm9pZCAqY29udGV4dCwgc2l6ZV90IGhkcmxl
biwKIAkJc2VydmVyLT5zZWNfa2VyYmVyb3MgPSB0cnVlOwogCWVsc2UgaWYgKG9pZCA9PSBPSURf
bnRsbXNzcCkKIAkJc2VydmVyLT5zZWNfbnRsbXNzcCA9IHRydWU7CisJZWxzZSBpZiAob2lkID09
IE9JRF9JQUtlcmIpCisJCXNlcnZlci0+c2VjX2lha2VyYiA9IHRydWU7CiAJZWxzZSB7CiAJCWNo
YXIgYnVmWzUwXTsKIApkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzX3NwbmVnby5jIGIv
ZnMvc21iL2NsaWVudC9jaWZzX3NwbmVnby5jCmluZGV4IDI4ZjU2OGI1ZmMyNy4uYmMxYzFlOWIy
ODhhIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNfc3BuZWdvLmMKKysrIGIvZnMvc21i
L2NsaWVudC9jaWZzX3NwbmVnby5jCkBAIC0xMzgsMTEgKzEzOCwxMyBAQCBjaWZzX2dldF9zcG5l
Z29fa2V5KHN0cnVjdCBjaWZzX3NlcyAqc2VzSW5mbywKIAogCWRwID0gZGVzY3JpcHRpb24gKyBz
dHJsZW4oZGVzY3JpcHRpb24pOwogCi0JLyogZm9yIG5vdywgb25seSBzZWM9a3JiNSBhbmQgc2Vj
PW1za3JiNSBhcmUgdmFsaWQgKi8KKwkvKiBmb3Igbm93LCBvbmx5IHNlYz1rcmI1IGFuZCBzZWM9
bXNrcmI1IGFuZCBpYWtlcmIgYXJlIHZhbGlkICovCiAJaWYgKHNlcnZlci0+c2VjX2tlcmJlcm9z
KQogCQlzcHJpbnRmKGRwLCAiO3NlYz1rcmI1Iik7CiAJZWxzZSBpZiAoc2VydmVyLT5zZWNfbXNr
ZXJiZXJvcykKIAkJc3ByaW50ZihkcCwgIjtzZWM9bXNrcmI1Iik7CisJZWxzZSBpZiAoc2VydmVy
LT5zZWNfaWFrZXJiKQorCQlzcHJpbnRmKGRwLCAiO3NlYz1pYWtlcmIiKTsKIAllbHNlIHsKIAkJ
Y2lmc19kYmcoVkZTLCAidW5rbm93biBvciBtaXNzaW5nIHNlcnZlciBhdXRoIHR5cGUsIHVzZSBr
cmI1XG4iKTsKIAkJc3ByaW50ZihkcCwgIjtzZWM9a3JiNSIpOwpkaWZmIC0tZ2l0IGEvZnMvc21i
L2NsaWVudC9jaWZzZ2xvYi5oIGIvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCmluZGV4IDQ5ZmZj
MDQwZjczNi4uYTc2NWI5MTg4NWZkIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNnbG9i
LmgKKysrIGIvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCkBAIC0xNTEsNiArMTUxLDcgQEAgZW51
bSBzZWN1cml0eUVudW0gewogCU5UTE12MiwJCQkvKiBMZWdhY3kgTlRMTSBhdXRoIHdpdGggTlRM
TXYyIGhhc2ggKi8KIAlSYXdOVExNU1NQLAkJLyogTlRMTVNTUCB3aXRob3V0IFNQTkVHTywgTlRM
TXYyIGhhc2ggKi8KIAlLZXJiZXJvcywJCS8qIEtlcmJlcm9zIHZpYSBTUE5FR08gKi8KKwlJQUtl
cmIsCQkJLyogS2VyYmVyb3MgcHJveHkgKi8KIH07CiAKIGVudW0gdXBjYWxsX3RhcmdldF9lbnVt
IHsKQEAgLTc1MSw2ICs3NTIsNyBAQCBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvIHsKIAlib29sCXNl
Y19rZXJiZXJvc3UydTsJLyogc3VwcG9ydHMgVTJVIEtlcmJlcm9zICovCiAJYm9vbAlzZWNfa2Vy
YmVyb3M7CQkvKiBzdXBwb3J0cyBwbGFpbiBLZXJiZXJvcyAqLwogCWJvb2wJc2VjX21za2VyYmVy
b3M7CQkvKiBzdXBwb3J0cyBsZWdhY3kgTVMgS2VyYmVyb3MgKi8KKwlib29sCXNlY19pYWtlcmI7
CQkvKiBzdXBwb3J0cyBwYXNzLXRocm91Z2ggYXV0aCBmb3IgS2VyYmVyb3MgKGtyYjUgcHJveHkp
ICovCiAJYm9vbAlsYXJnZV9idWY7CQkvKiBpcyBjdXJyZW50IGJ1ZmZlciBsYXJnZT8gKi8KIAkv
KiB1c2UgU01CRCBjb25uZWN0aW9uIGluc3RlYWQgb2Ygc29ja2V0ICovCiAJYm9vbAlyZG1hOwpA
QCAtMjExOCw2ICsyMTIwLDggQEAgc3RhdGljIGlubGluZSBjaGFyICpnZXRfc2VjdXJpdHlfdHlw
ZV9zdHIoZW51bSBzZWN1cml0eUVudW0gc2VjdHlwZSkKIAkJcmV0dXJuICJLZXJiZXJvcyI7CiAJ
Y2FzZSBOVExNdjI6CiAJCXJldHVybiAiTlRMTXYyIjsKKwljYXNlIElBS2VyYjoKKwkJcmV0dXJu
ICJJQUtlcmIiOwogCWRlZmF1bHQ6CiAJCXJldHVybiAiVW5rbm93biI7CiAJfQpkaWZmIC0tZ2l0
IGEvZnMvc21iL2NsaWVudC9zZXNzLmMgYi9mcy9zbWIvY2xpZW50L3Nlc3MuYwppbmRleCA5MWQ0
ZDQwOWNiMWQuLmZhYTgwZTdkNTRhNiAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zZXNzLmMK
KysrIGIvZnMvc21iL2NsaWVudC9zZXNzLmMKQEAgLTEyMzUsMTIgKzEyMzUsMTMgQEAgY2lmc19z
ZWxlY3Rfc2VjdHlwZShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIGVudW0gc2VjdXJp
dHlFbnVtIHJlcXVlc3RlZCkKIAkJc3dpdGNoIChyZXF1ZXN0ZWQpIHsKIAkJY2FzZSBLZXJiZXJv
czoKIAkJY2FzZSBSYXdOVExNU1NQOgorCQljYXNlIElBS2VyYjoKIAkJCXJldHVybiByZXF1ZXN0
ZWQ7CiAJCWNhc2UgVW5zcGVjaWZpZWQ6CiAJCQlpZiAoc2VydmVyLT5zZWNfbnRsbXNzcCAmJgog
CQkJICAgIChnbG9iYWxfc2VjZmxhZ3MgJiBDSUZTU0VDX01BWV9OVExNU1NQKSkKIAkJCQlyZXR1
cm4gUmF3TlRMTVNTUDsKLQkJCWlmICgoc2VydmVyLT5zZWNfa2VyYmVyb3MgfHwgc2VydmVyLT5z
ZWNfbXNrZXJiZXJvcykgJiYKKwkJCWlmICgoc2VydmVyLT5zZWNfa2VyYmVyb3MgfHwgc2VydmVy
LT5zZWNfbXNrZXJiZXJvcyB8fCBzZXJ2ZXItPnNlY19pYWtlcmIpICYmCiAJCQkgICAgKGdsb2Jh
bF9zZWNmbGFncyAmIENJRlNTRUNfTUFZX0tSQjUpKQogCQkJCXJldHVybiBLZXJiZXJvczsKIAkJ
CWZhbGx0aHJvdWdoOwpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIycGR1LmMgYi9mcy9z
bWIvY2xpZW50L3NtYjJwZHUuYwppbmRleCA5ZjU0NTk2YTY4NjYuLjQwYWQ5ZTc5NDM3YSAxMDA2
NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zbWIycGR1LmMKKysrIGIvZnMvc21iL2NsaWVudC9zbWIy
cGR1LmMKQEAgLTE0MjksNyArMTQyOSw3IEBAIHNtYjJfc2VsZWN0X3NlY3R5cGUoc3RydWN0IFRD
UF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBlbnVtIHNlY3VyaXR5RW51bSByZXF1ZXN0ZWQpCiAJCWlm
IChzZXJ2ZXItPnNlY19udGxtc3NwICYmCiAJCQkoZ2xvYmFsX3NlY2ZsYWdzICYgQ0lGU1NFQ19N
QVlfTlRMTVNTUCkpCiAJCQlyZXR1cm4gUmF3TlRMTVNTUDsKLQkJaWYgKChzZXJ2ZXItPnNlY19r
ZXJiZXJvcyB8fCBzZXJ2ZXItPnNlY19tc2tlcmJlcm9zKSAmJgorCQlpZiAoKHNlcnZlci0+c2Vj
X2tlcmJlcm9zIHx8IHNlcnZlci0+c2VjX21za2VyYmVyb3MgfHwgc2VydmVyLT5zZWNfaWFrZXJi
KSAmJgogCQkJKGdsb2JhbF9zZWNmbGFncyAmIENJRlNTRUNfTUFZX0tSQjUpKQogCQkJcmV0dXJu
IEtlcmJlcm9zOwogCQlmYWxsdGhyb3VnaDsKLS0gCjIuNDMuMAoK
--000000000000d76b2f062cbeed05--
