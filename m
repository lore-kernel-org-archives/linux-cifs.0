Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9467D6AB8
	for <linux-cifs@vger.kernel.org>; Wed, 29 May 2024 23:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717025437; cv=none; b=kZql+/rgrgssegZVhoRc9VNtIGz3fooqJkQe2MLcGCU/WNj5UkgbfhNbKjMNZbCT7AQBafthmuDiwWAVEozL6Lli751+usqyRFNH8SSzAjmqqv9E/yYJIqseTIDeWKSHkNn8IuqhDE7wgsYDEoevxpDs9c6EPrFpV7vqAbV2eL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717025437; c=relaxed/simple;
	bh=be3xYegWtREqlZXf54qmLIYyJKDlfD3/Q7TvzRdPLwc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=a6gSh4cxEeqThTGY8DRXE5YfKHhJcyfWw/EqwZyv08ytYb+jUd24g/Aj9WQPdF4dUxnyikEw0phdI8xX4LP5KLBHNz//icdpOqC3G8Zj/24KXyNheCY8Sn/O3Zf6LXq8wH4ZaNXex6MbyxdKe0v4e3TG5PZAVxTULDWrnUoOb6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K29ZAA7L; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K29ZAA7L"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52961b77655so338043e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 29 May 2024 16:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717025433; x=1717630233; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U4wy0G0NxHEn49dyt0bFP6nspNhe6kcAzngHd8yws04=;
        b=K29ZAA7L9RbrsikIG3MS0fDfAndL2KPKDYSNOrwV44zKHItARelZz/4Wpteg0bkyx9
         PojcDfx+jXZmtDyhBrbUvBoy5TKMqX/6axxQ3GVSbABnnHAYULCCkJR0+yZZDcdNT3wg
         tQYrAt45TQbDKOFofAiFidA8RoC4aBJDt2cpIaS3Xv/Ppiw/INjWdMei0HIKlFu9gJA+
         g8VpbM67FYyq2sB932heOVCRCfvcOGnjy8M721pASZw+CJrMkMjLyrsWpR5E8HShwOuI
         u+ONNC63pvbQ9C7YGpfMdHRwPHSv7x/bfm4p7RFMCAW+Tvoi6o4CIOsk9vImP6aW4I1b
         g2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717025433; x=1717630233;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U4wy0G0NxHEn49dyt0bFP6nspNhe6kcAzngHd8yws04=;
        b=nkzT3u+vDE9metjc0va7oQqBbDBEet43NIeIFg681ngo4FbOO+P/T8QidUha1hyRCn
         Ak4p8z4JY28UFdLnu4pJoMBiWBH5ln+Sr8I/RPNCWIKZlU65qcCA5/wQJVtTB9EXYxVi
         oTa0Ua0IjhPk/c5MjKUTADZJQi2gJ0/LBC4v0oiVxsjcWUX1q1N+4iwtRux3VaKMPsp2
         W5QkWyOZNyPby6e/AOkbgsZ/Bh1rqgnLomDVZfNIe0QllCxv7+1aPsJacrMUkLxncIHg
         5e8+X+aM63eFtzLdVeXZ1CNPxLQ0qGaMZwQ72wHJqMsfQ69waPnIzPccBJGqvzQLLkl1
         +FVA==
X-Gm-Message-State: AOJu0YzQmtm9yDucUDPO9aXHTmtpQ0SA9J8PCscmHf7V23w+udyXbcEj
	9RaRcpazjwtZk4bCxfTOyrR4sSF30wcX95tb7eq05joHDJrFf2ABjBbguHkPR+y4ptzbAeXxafF
	3Km9j81hAWGIYAFSTNcH1WWmDKcUZUtpi
X-Google-Smtp-Source: AGHT+IHmVpSCcBlWadWmrRrbVNx0kZ7AoAPtAzH7V+NipPSEGVB09fzAIg3NmSbpGqeqormnecbRaOzx8HSSRrhAx34=
X-Received: by 2002:ac2:5923:0:b0:529:b1be:8fe1 with SMTP id
 2adb3069b0e04-52b7d490d07mr258219e87.63.1717025433224; Wed, 29 May 2024
 16:30:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 29 May 2024 18:30:20 -0500
Message-ID: <CAH2r5mvv6GS07jY2W_5zXV3YpcHup7rZghRqmpoeSDndgrkDEA@mail.gmail.com>
Subject: [PATCH][SMB3 client] fix creating sockets when using sfu mount options
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000004a34c0619a02310"

--00000000000004a34c0619a02310
Content-Type: text/plain; charset="UTF-8"

    cifs: fix creating sockets when using sfu mount options

    When running fstest generic/423 with sfu mount option, it
    was being skipped due to inability to create sockets:

      generic/423  [not run] cifs does not support mknod/mkfifo

    which can also be easily reproduced with their af_unix tool:

      ./src/af_unix /mnt1/socket-two bind: Operation not permitted

    Fix sfu mount option to allow creating and reporting sockets.

See attached


-- 
Thanks,

Steve

--00000000000004a34c0619a02310
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-creating-sockets-when-using-sfu-mount-optio.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-creating-sockets-when-using-sfu-mount-optio.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lwsgllq60>
X-Attachment-Id: f_lwsgllq60

RnJvbSA3ZTQ3NmE4M2ZjMzVmODI1NzU5ZDA3OWY0YTBjZTM0OWJkOTI3Y2E5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMjkgTWF5IDIwMjQgMTg6MTY6NTYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggY3JlYXRpbmcgc29ja2V0cyB3aGVuIHVzaW5nIHNmdSBtb3VudCBvcHRpb25zCgpX
aGVuIHJ1bm5pbmcgZnN0ZXN0IGdlbmVyaWMvNDIzIHdpdGggc2Z1IG1vdW50IG9wdGlvbiwgaXQK
d2FzIGJlaW5nIHNraXBwZWQgZHVlIHRvIGluYWJpbGl0eSB0byBjcmVhdGUgc29ja2V0czoKCiAg
Z2VuZXJpYy80MjMgIFtub3QgcnVuXSBjaWZzIGRvZXMgbm90IHN1cHBvcnQgbWtub2QvbWtmaWZv
Cgp3aGljaCBjYW4gYWxzbyBiZSBlYXNpbHkgcmVwcm9kdWNlZCB3aXRoIHRoZWlyIGFmX3VuaXgg
dG9vbDoKCiAgLi9zcmMvYWZfdW5peCAvbW50MS9zb2NrZXQtdHdvIGJpbmQ6IE9wZXJhdGlvbiBu
b3QgcGVybWl0dGVkCgpGaXggc2Z1IG1vdW50IG9wdGlvbiB0byBhbGxvdyBjcmVhdGluZyBhbmQg
cmVwb3J0aW5nIHNvY2tldHMuCgpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpTaWduZWQtb2Zm
LWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2Ns
aWVudC9jaWZzcGR1LmggfCAgMiArLQogZnMvc21iL2NsaWVudC9pbm9kZS5jICAgfCAxMyArKysr
KysrKysrKysrCiBmcy9zbWIvY2xpZW50L3NtYjJvcHMuYyB8ICA1ICsrKysrCiAzIGZpbGVzIGNo
YW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9z
bWIvY2xpZW50L2NpZnNwZHUuaCBiL2ZzL3NtYi9jbGllbnQvY2lmc3BkdS5oCmluZGV4IGM0NmQ0
MThjMWMwYy4uYTIwNzJhYjllNTg2IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNwZHUu
aAorKysgYi9mcy9zbWIvY2xpZW50L2NpZnNwZHUuaApAQCAtMjU3NCw3ICsyNTc0LDcgQEAgdHlw
ZWRlZiBzdHJ1Y3QgewogCiAKIHN0cnVjdCB3aW5fZGV2IHsKLQl1bnNpZ25lZCBjaGFyIHR5cGVb
OF07IC8qIEludHhDSFIgb3IgSW50eEJMSyBvciBMbnhGSUZPKi8KKwl1bnNpZ25lZCBjaGFyIHR5
cGVbOF07IC8qIEludHhDSFIgb3IgSW50eEJMSyBvciBMbnhGSUZPIG9yIExueFNPQ0sgKi8KIAlf
X2xlNjQgbWFqb3I7CiAJX19sZTY0IG1pbm9yOwogfSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsK
ZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvaW5vZGUuYyBiL2ZzL3NtYi9jbGllbnQvaW5vZGUu
YwppbmRleCAyNjI1NzY1NzNlYjUuLjZlNGZhYzVmNjRiYyAxMDA2NDQKLS0tIGEvZnMvc21iL2Ns
aWVudC9pbm9kZS5jCisrKyBiL2ZzL3NtYi9jbGllbnQvaW5vZGUuYwpAQCAtNjAyLDYgKzYwMiwx
OSBAQCBjaWZzX3NmdV90eXBlKHN0cnVjdCBjaWZzX2ZhdHRyICpmYXR0ciwgY29uc3QgY2hhciAq
cGF0aCwKIAkJCQkvKiB3ZSBoYXZlIGVub3VnaCB0byBkZWNvZGUgZGV2IG51bSAqLwogCQkJCV9f
dTY0IG1qcjsgLyogbWFqb3IgKi8KIAkJCQlfX3U2NCBtbnI7IC8qIG1pbm9yICovCisJCQkJbWpy
ID0gbGU2NF90b19jcHUoKihfX2xlNjQgKikocGJ1Zis4KSk7CisJCQkJbW5yID0gbGU2NF90b19j
cHUoKihfX2xlNjQgKikocGJ1ZisxNikpOworCQkJCWZhdHRyLT5jZl9yZGV2ID0gTUtERVYobWpy
LCBtbnIpOworCQkJfQorCQl9IGVsc2UgaWYgKG1lbWNtcCgiTG54U09DSyIsIHBidWYsIDgpID09
IDApIHsKKwkJCWNpZnNfZGJnKEZZSSwgIlNvY2tldFxuIik7CisJCQlmYXR0ci0+Y2ZfbW9kZSB8
PSBTX0lGU09DSzsKKwkJCWZhdHRyLT5jZl9kdHlwZSA9IERUX1NPQ0s7CisJCQlpZiAoYnl0ZXNf
cmVhZCA9PSAyNCkgeworCQkJCS8qIHdlIGhhdmUgZW5vdWdoIHRvIGRlY29kZSBkZXYgbnVtICov
CisJCQkJX191NjQgbWpyOyAvKiBtYWpvciAqLworCQkJCV9fdTY0IG1ucjsgLyogbWlub3IgKi8K
KwogCQkJCW1qciA9IGxlNjRfdG9fY3B1KCooX19sZTY0ICopKHBidWYrOCkpOwogCQkJCW1uciA9
IGxlNjRfdG9fY3B1KCooX19sZTY0ICopKHBidWYrMTYpKTsKIAkJCQlmYXR0ci0+Y2ZfcmRldiA9
IE1LREVWKG1qciwgbW5yKTsKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jIGIv
ZnMvc21iL2NsaWVudC9zbWIyb3BzLmMKaW5kZXggNGNlNmMzMTIxYTdlLi40NzdkNTk0YzJmYzMg
MTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jCisrKyBiL2ZzL3NtYi9jbGllbnQv
c21iMm9wcy5jCkBAIC00OTk3LDYgKzQ5OTcsMTEgQEAgc3RhdGljIGludCBfX2NpZnNfc2Z1X21h
a2Vfbm9kZSh1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgaW5vZGUgKmlub2RlLAogCQlwZGV2Lm1h
am9yID0gY3B1X3RvX2xlNjQoTUFKT1IoZGV2KSk7CiAJCXBkZXYubWlub3IgPSBjcHVfdG9fbGU2
NChNSU5PUihkZXYpKTsKIAkJYnJlYWs7CisJY2FzZSBTX0lGU09DSzoKKwkJc3Ryc2NweShwZGV2
LnR5cGUsICJMbnhTT0NLIik7CisJCXBkZXYubWFqb3IgPSBjcHVfdG9fbGU2NChNQUpPUihkZXYp
KTsKKwkJcGRldi5taW5vciA9IGNwdV90b19sZTY0KE1JTk9SKGRldikpOworCQlicmVhazsKIAlj
YXNlIFNfSUZJRk86CiAJCXN0cnNjcHkocGRldi50eXBlLCAiTG54RklGTyIpOwogCQlicmVhazsK
LS0gCjIuNDMuMAoK
--00000000000004a34c0619a02310--
