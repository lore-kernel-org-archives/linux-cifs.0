Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3681A38DE
	for <linux-cifs@vger.kernel.org>; Sun, 24 Mar 2024 05:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711256824; cv=none; b=FAd3iH5cAZGvEtL748wIDebudSDGMv/iEHyJfUTi9UFgq/RkwTIqLk9jxxrpHFcBGVHfAmLsXR4OmysQ8JBiJOPg2jJ5Ufaicj0zjaMnt9L8E8d7h0SBPPwgbGyhva9iTPKNLgZk2xk37ze2WNyl6/YHSNEVr/Ba8SLCaezZAvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711256824; c=relaxed/simple;
	bh=ncV0v/GBgCE1cXW8ubWdMNaflE8Tslwj0jY6Rx+cNu8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=r/QrAzNUBivTx74mzSwhOoGnZOvP0EaS6nU2gaGFZiKYFCmOhnvLvpMRswBnqvrgAzilcvPpWpj4QRnLEPSmtGHx57G7V85h5gP5j5GTV/A760J29cOd66q9TgrIZykAVAAlrRtkn1mNWvejEU51SvVchJOUcZAUn1mFRyQKoIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TUWA1PhG; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TUWA1PhG"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-51381021af1so5246580e87.0
        for <linux-cifs@vger.kernel.org>; Sat, 23 Mar 2024 22:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711256820; x=1711861620; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kcQ7aqapAzWh9V2jYgjZvNL++i4wCg6TaQgakyEunLo=;
        b=TUWA1PhGt3E/xUkhZzJnYVARHSoUYQzLUSvDgJMxpg5EmIbHbdbLCF5I5YmXxq9Ld1
         ZRIH6Va+YQZIj5TIbS5p684yrHx2ImpljPq93h0havdn5wNgbyuO86wuZVRjMGVCPJRW
         Mn6dZJKAGFycOVnVWP90dvbZj6OhJDkt8E4xKs8JZnr7RgzaiBablsG+/yilnzIQKknC
         cYM2JbLN8UrHKdE/+SZaOz8gxWO72fP6cpU3UAw1dal7gO/WI0/lKPP0bym5OzrFIO0q
         w0eIuDbDZq4rBM8Te4zMnE4kGqS+wnWNSnzltOqO/amJj1fq8MCN/DIvhx0Jf3a3vpfR
         pQWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711256820; x=1711861620;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kcQ7aqapAzWh9V2jYgjZvNL++i4wCg6TaQgakyEunLo=;
        b=FRlWPSP7qf9trkHgJiByWVoSUJmLG8Cvj3xAP3rsg7RK7TTAxrvkrcmTlm0adORfFG
         YY7qonmRYjkKXB1owCrZhLL+/W5uSDS3WL9e3U/OdukNEQUGFsQiIgtq/0BVIq37aFcX
         CeVav8LKjgGkeEjRrXQEd7s6mxOjs8rHYdgk5I351RlesOAxIcd0rjWcmA3/iNqATZIg
         so984/oVd3UbwSsvvCGyLIMMLDfYl+XGgHqKAjxe/fYDbO/yOtRQ7bB0pXe/5mId8xBE
         yVj1U1NVZF8uMWgQVNxZbUtbyYlKWQsOYiqE4tNUdho5SkD39TQ5D3iw4B/+TF6c63wE
         xRlg==
X-Gm-Message-State: AOJu0YyORfS8dxrul7upsF6PmHFVkZI+AHb9qqj2KsoyD6+EIX1CFjgW
	haeAYpQ+Oe/+DHFgPfPq0n4x/CioEdMxT0gqDT0zXisL3LWYr42h45Z5fz2FHPnLIsCKdYzAPe3
	bV6dWJ0cjvxFSfEfFaP2mzibB1VPYP8rY4+Q=
X-Google-Smtp-Source: AGHT+IEjiRV5XamzppIO6hae9gz9OzZSCuvxxDzciOqIO3plgnEYfQJ8Z1a7g7B/mvxwm+w4orKTmCSUKzZgcjakZUU=
X-Received: by 2002:a05:6512:715:b0:513:2f96:72b5 with SMTP id
 b21-20020a056512071500b005132f9672b5mr2482250lfs.33.1711256820226; Sat, 23
 Mar 2024 22:07:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 24 Mar 2024 00:06:49 -0500
Message-ID: <CAH2r5mu0HtRs_5hmKFLoh+OhWsHroAAHwvH51chaPJWWmpGPSg@mail.gmail.com>
Subject: [PATCH][SMB3 client] add trace event for mknod
To: CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>, Paulo Alcantara <pc@manguebit.com>
Content-Type: multipart/mixed; boundary="000000000000e3fe3f06146106ee"

--000000000000e3fe3f06146106ee
Content-Type: text/plain; charset="UTF-8"

See attached

Add trace points to help debug mknod and mkfifo:

   smb3_mknod_done
   smb3_mknod_enter
   smb3_mknod_err

Example output:

      TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
         | |         |   |||||     |         |
    mkfifo-6163    [003] .....   960.425558: smb3_mknod_enter: xid=12
sid=0xb55130f6 tid=0x46e6241c path=\fifo1
    mkfifo-6163    [003] .....   960.432719: smb3_mknod_done: xid=12
sid=0xb55130f6 tid=0x46e6241c


-- 
Thanks,

Steve

--000000000000e3fe3f06146106ee
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-trace-event-for-mknod.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-trace-event-for-mknod.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lu523hfx0>
X-Attachment-Id: f_lu523hfx0

RnJvbSBiZGEwYjA2YzAyNjNkNGQ0Mjk4OTEyNDgyNjc1MWQ5ZTdmYTgyOTc4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMjQgTWFyIDIwMjQgMDA6MDE6MDIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgdHJhY2UgZXZlbnQgZm9yIG1rbm9kCgpBZGQgdHJhY2UgcG9pbnRzIHRvIGhlbHAg
ZGVidWcgbWtub2QgYW5kIG1rZmlmbzoKCiAgIHNtYjNfbWtub2RfZG9uZQogICBzbWIzX21rbm9k
X2VudGVyCiAgIHNtYjNfbWtub2RfZXJyCgpFeGFtcGxlIG91dHB1dDoKCiAgICAgIFRBU0stUElE
ICAgICBDUFUjICB8fHx8fCAgVElNRVNUQU1QICBGVU5DVElPTgogICAgICAgICB8IHwgICAgICAg
ICB8ICAgfHx8fHwgICAgIHwgICAgICAgICB8CiAgICBta2ZpZm8tNjE2MyAgICBbMDAzXSAuLi4u
LiAgIDk2MC40MjU1NTg6IHNtYjNfbWtub2RfZW50ZXI6IHhpZD0xMiBzaWQ9MHhiNTUxMzBmNiB0
aWQ9MHg0NmU2MjQxYyBwYXRoPVxmaWZvMQogICAgbWtmaWZvLTYxNjMgICAgWzAwM10gLi4uLi4g
ICA5NjAuNDMyNzE5OiBzbWIzX21rbm9kX2RvbmU6IHhpZD0xMiBzaWQ9MHhiNTUxMzBmNiB0aWQ9
MHg0NmU2MjQxYwoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3Nv
ZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvZGlyLmMgICB8IDcgKysrKysrKwogZnMvc21iL2Ns
aWVudC90cmFjZS5oIHwgNCArKystCiAyIGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2Rpci5jIGIvZnMvc21i
L2NsaWVudC9kaXIuYwppbmRleCA4OTMzM2Q5YmNlMzYuLmQxMWRjM2FhNDU4YiAxMDA2NDQKLS0t
IGEvZnMvc21iL2NsaWVudC9kaXIuYworKysgYi9mcy9zbWIvY2xpZW50L2Rpci5jCkBAIC02MTIs
MTEgKzYxMiwxOCBAQCBpbnQgY2lmc19ta25vZChzdHJ1Y3QgbW50X2lkbWFwICppZG1hcCwgc3Ry
dWN0IGlub2RlICppbm9kZSwKIAkJZ290byBta25vZF9vdXQ7CiAJfQogCisJdHJhY2Vfc21iM19t
a25vZF9lbnRlcih4aWQsIHRjb24tPnNlcy0+U3VpZCwgdGNvbi0+dGlkLCBmdWxsX3BhdGgpOwor
CiAJcmMgPSB0Y29uLT5zZXMtPnNlcnZlci0+b3BzLT5tYWtlX25vZGUoeGlkLCBpbm9kZSwgZGly
ZW50cnksIHRjb24sCiAJCQkJCSAgICAgICBmdWxsX3BhdGgsIG1vZGUsCiAJCQkJCSAgICAgICBk
ZXZpY2VfbnVtYmVyKTsKIAogbWtub2Rfb3V0OgorCWlmIChyYykKKwkJdHJhY2Vfc21iM19ta25v
ZF9lcnIoeGlkLCAgdGNvbi0+c2VzLT5TdWlkLCB0Y29uLT50aWQsIHJjKTsKKwllbHNlCisJCXRy
YWNlX3NtYjNfbWtub2RfZG9uZSh4aWQsIHRjb24tPnNlcy0+U3VpZCwgdGNvbi0+dGlkKTsKKwog
CWZyZWVfZGVudHJ5X3BhdGgocGFnZSk7CiAJZnJlZV94aWQoeGlkKTsKIAljaWZzX3B1dF90bGlu
ayh0bGluayk7CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3RyYWNlLmggYi9mcy9zbWIvY2xp
ZW50L3RyYWNlLmgKaW5kZXggZjljMWZkMzJkMGI4Li41ZTgzY2I5ZGE5MDIgMTAwNjQ0Ci0tLSBh
L2ZzL3NtYi9jbGllbnQvdHJhY2UuaAorKysgYi9mcy9zbWIvY2xpZW50L3RyYWNlLmgKQEAgLTM3
NSw2ICszNzUsNyBAQCBERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRU5URVJfRVZFTlQoZ2V0X3Jl
cGFyc2VfY29tcG91bmRfZW50ZXIpOwogREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VW
RU5UKGRlbGV0ZV9lbnRlcik7CiBERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRU5URVJfRVZFTlQo
bWtkaXJfZW50ZXIpOwogREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKHRkaXNf
ZW50ZXIpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKG1rbm9kX2VudGVy
KTsKIAogREVDTEFSRV9FVkVOVF9DTEFTUyhzbWIzX2luZl9jb21wb3VuZF9kb25lX2NsYXNzLAog
CVRQX1BST1RPKHVuc2lnbmVkIGludCB4aWQsCkBAIC00MTUsNyArNDE2LDcgQEAgREVGSU5FX1NN
QjNfSU5GX0NPTVBPVU5EX0RPTkVfRVZFTlQocXVlcnlfd3NsX2VhX2NvbXBvdW5kX2RvbmUpOwog
REVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0RPTkVfRVZFTlQoZGVsZXRlX2RvbmUpOwogREVGSU5F
X1NNQjNfSU5GX0NPTVBPVU5EX0RPTkVfRVZFTlQobWtkaXJfZG9uZSk7CiBERUZJTkVfU01CM19J
TkZfQ09NUE9VTkRfRE9ORV9FVkVOVCh0ZGlzX2RvbmUpOwotCitERUZJTkVfU01CM19JTkZfQ09N
UE9VTkRfRE9ORV9FVkVOVChta25vZF9kb25lKTsKIAogREVDTEFSRV9FVkVOVF9DTEFTUyhzbWIz
X2luZl9jb21wb3VuZF9lcnJfY2xhc3MsCiAJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwKQEAg
LTQ2MSw2ICs0NjIsNyBAQCBERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRVJSX0VWRU5UKHF1ZXJ5
X3dzbF9lYV9jb21wb3VuZF9lcnIpOwogREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VSUl9FVkVO
VChta2Rpcl9lcnIpOwogREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VSUl9FVkVOVChkZWxldGVf
ZXJyKTsKIERFRklORV9TTUIzX0lORl9DT01QT1VORF9FUlJfRVZFTlQodGRpc19lcnIpOworREVG
SU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VSUl9FVkVOVChta25vZF9lcnIpOwogCiAvKgogICogRm9y
IGxvZ2dpbmcgU01CMyBTdGF0dXMgY29kZSBhbmQgQ29tbWFuZCBmb3IgcmVzcG9uc2VzIHdoaWNo
IHJldHVybiBlcnJvcnMKLS0gCjIuNDAuMQoK
--000000000000e3fe3f06146106ee--
