Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E79233151
	for <linux-cifs@vger.kernel.org>; Mon,  9 Dec 2024 17:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733765973; cv=none; b=QR5hL34c3bZAZbvAXL4li8a697IxtITYM+9rYBbPv1HFzMdjXWUWbVnCjLemyD/Pje1AmZmF+0P9LsbvB+X6ErkJoIi4d1DnHG+piS6DnhSEJ4CP5/HIAa/UYVfQipRRNZoNNYDNniq8WmGyZGhNMzdm+v6YHsOmt5sCF7o6aUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733765973; c=relaxed/simple;
	bh=J5GW5tpVZTXAs9VlnXGfaR8T9ipsPPWcK7ZwyOq0NMA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=hAZ6YWd0z0QpcL14+tcMQvi1UHJ84e6NA1Rw1m4TXyki8hmANptxoDAAu8pjoL6OvC6Z6AuyI1auyQOXjJ6xyCiT1vGy8WgPlRVwUksToVUFzFaMnzaRCBHUyzgmDBWjCPW8F0kvORA1agv7ewtZngz1eIKQz5cUECzEA3/1aSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NtI7ugO2; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NtI7ugO2"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-53ff1f7caaeso2175534e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 09 Dec 2024 09:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733765969; x=1734370769; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uGse4tK6EmtmyQY9l/bRP1zAK+2tZ1RqJM/NhRIyaec=;
        b=NtI7ugO29tY+TqGj+yIMtyfT1BIs5NCYVNvKWhLrgt96K2Gw5+zb53z3yI3Ea92P9U
         7/mGoz05rcSdMycIdUOcVXQqYSjwhYzkJO/6JRD/YiLw3vRHb7FWRqyUYkdysmEdr0q4
         kTkIN7Yic5usrwReBfZkhG7KZNcteKo3dxmkzvow9//boWyK5TiPaWEfy0epeMab4D1t
         HA5DmnoAgB/ZyMj/P4g8m5j3aaAdNc9sTv5FAV8l9m1tNDKpnZOqVJm3b2x2a8hDOBFL
         IcBBnhNkIKrd/xg7iXlTuQbSpp/5MhdgSYZU9Zspf1mSrfUKvlhLSU+yNNbFSnfidckA
         APDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733765969; x=1734370769;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uGse4tK6EmtmyQY9l/bRP1zAK+2tZ1RqJM/NhRIyaec=;
        b=SnO3TrPbjUAn0sOs0g8S8O9Ma4PBPpTHj09o2ByaJaSv2dVKbeALevszKzbLa8+rVJ
         nnlr7iRBkIM+AM3LdJ8MqiXpelIRDSDlsTsdLtx2xdx1qBEnU3HehtK1/tjycQdQ+dc/
         woExGcrBTmJlXrplE3+wUTcjCVn+E48tJo2A/37Ssg1PRCTyc5jlB0aGqLW9KADRL35s
         7lJRzNXw/wpXoj5l2fSoqITDt6/VlRBPpX/9sBqn33kLNWLrwjGXhUXlN/lpt2KaFWXA
         kOmBDuHyN7JRRtZlHkKLyKIuqu5TjiNwH9ynnPUYyULUag636XIBMWX9JF1V/l5LUyTM
         mdPQ==
X-Gm-Message-State: AOJu0Yx0xY8Hs1MeBMjrXlTCRjFddU392SYRCB3sxyH3xmOAw5pa7a8u
	+qu1aKFAVe1p3YNEoNEoK1qxJUha5z7P1zGDprltKtD7msYzA9tiYAsboSTf427WUmpiE2GPdOh
	46L0dNjyYQoTsgT69A8JI0NtN+VHj7P1O
X-Gm-Gg: ASbGncterW39rA9Au3FGK2wrjyGLbmJ+a6E8SJfn2x8uZWQXqXTr+xzUGLzSsOetX2H
	PoT1dadLkSLFpBTbxrmMwGmqtQZo05t5ZqLw6x4pOILl0vY82H5Ygb/oLSDtfPgcS
X-Google-Smtp-Source: AGHT+IEbVC7zJc4CKHyJXcE8tezPw8SCdPyg4oyxFccrbERTyFvlahYatvctPXM4wSOa4IcCG/mydwxQNwaLLwJvoDU=
X-Received: by 2002:a05:6512:108c:b0:540:1a33:ded8 with SMTP id
 2adb3069b0e04-540240c04fcmr672513e87.17.1733765969180; Mon, 09 Dec 2024
 09:39:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 9 Dec 2024 11:39:17 -0600
Message-ID: <CAH2r5mss-vX3Fu+0MGrowFONRBshLuPicQa9nEcub7VhPqNJ9w@mail.gmail.com>
Subject: [PATCH][SMB3] fix minor compile warning in parse_reparse_wsl_symlink
To: CIFS <linux-cifs@vger.kernel.org>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: multipart/mixed; boundary="000000000000b7b4580628d9d804"

--000000000000b7b4580628d9d804
Content-Type: text/plain; charset="UTF-8"

utf8s_to_utf16s() specifies pwcs as a wchar_t pointer (whether big endian
or little endian is passed in as an additional parm), so to remove a
distracting compile warning it needs to be cast as (wchar_t *) in
parse_reparse_wsl_symlink() as done by other callers.

Fixes: 06a7adf318a3 ("cifs: Add support for parsing WSL-style symlinks")

  CHECK   /home/smfrench/cifs-2.6/fs/smb/client/reparse.c
/home/smfrench/cifs-2.6/fs/smb/client/reparse.c:679:45: warning:
incorrect type in argument 4 (different base types)
/home/smfrench/cifs-2.6/fs/smb/client/reparse.c:679:45:    expected
unsigned short [usertype] *pwcs
/home/smfrench/cifs-2.6/fs/smb/client/reparse.c:679:45:    got
restricted __le16 [usertype] *[assigned] symname_utf16


See attached patch

-- 
Thanks,

Steve

--000000000000b7b4580628d9d804
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0001-smb3-fix-compiler-warning-in-reparse-code.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-compiler-warning-in-reparse-code.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m4hbf34l0>
X-Attachment-Id: f_m4hbf34l0

RnJvbSAwMDk2ZjhlNTdiNGI2ZTUwM2YwYWJlYjBhNzllMmIxYTc3MTU3YTUzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgOSBEZWMgMjAyNCAxMToyNTowNCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGZpeCBjb21waWxlciB3YXJuaW5nIGluIHJlcGFyc2UgY29kZQpNSU1FLVZlcnNpb246IDEu
MApDb250ZW50LVR5cGU6IHRleHQvcGxhaW47IGNoYXJzZXQ9VVRGLTgKQ29udGVudC1UcmFuc2Zl
ci1FbmNvZGluZzogOGJpdAoKdXRmOHNfdG9fdXRmMTZzKCkgc3BlY2lmaWVzIHB3Y3MgYXMgYSB3
Y2hhcl90IHBvaW50ZXIgKHdoZXRoZXIgYmlnIGVuZGlhbgpvciBsaXR0bGUgZW5kaWFuIGlzIHBh
c3NlZCBpbiBhcyBhbiBhZGRpdGlvbmFsIHBhcm0pLCBzbyB0byByZW1vdmUgYQpkaXN0cmFjdGlu
ZyBjb21waWxlIHdhcm5pbmcgaXQgbmVlZHMgdG8gYmUgY2FzdCBhcyAod2NoYXJfdCAqKSBpbgpw
YXJzZV9yZXBhcnNlX3dzbF9zeW1saW5rKCkgYXMgZG9uZSBieSBvdGhlciBjYWxsZXJzLgoKRml4
ZXM6IDA2YTdhZGYzMThhMyAoImNpZnM6IEFkZCBzdXBwb3J0IGZvciBwYXJzaW5nIFdTTC1zdHls
ZSBzeW1saW5rcyIpCkNjOiBQYWxpIFJvaMOhciA8cGFsaUBrZXJuZWwub3JnPgpTaWduZWQtb2Zm
LWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2Ns
aWVudC9yZXBhcnNlLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEg
ZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3JlcGFyc2UuYyBiL2ZzL3Nt
Yi9jbGllbnQvcmVwYXJzZS5jCmluZGV4IDUwYjFhYmEyMDAwOC4uZDg4YjQxMTMzZTAwIDEwMDY0
NAotLS0gYS9mcy9zbWIvY2xpZW50L3JlcGFyc2UuYworKysgYi9mcy9zbWIvY2xpZW50L3JlcGFy
c2UuYwpAQCAtNjc2LDcgKzY3Niw3IEBAIHN0YXRpYyBpbnQgcGFyc2VfcmVwYXJzZV93c2xfc3lt
bGluayhzdHJ1Y3QgcmVwYXJzZV93c2xfc3ltbGlua19kYXRhX2J1ZmZlciAqYnVmCiAJCXJldHVy
biAtRU5PTUVNOwogCXN5bW5hbWVfdXRmMTZfbGVuID0gdXRmOHNfdG9fdXRmMTZzKGJ1Zi0+UGF0
aEJ1ZmZlciwgc3ltbmFtZV91dGY4X2xlbiwKIAkJCQkJICAgIFVURjE2X0xJVFRMRV9FTkRJQU4s
Ci0JCQkJCSAgICBzeW1uYW1lX3V0ZjE2LCBzeW1uYW1lX3V0ZjhfbGVuICogMik7CisJCQkJCSAg
ICAod2NoYXJfdCAqKSBzeW1uYW1lX3V0ZjE2LCBzeW1uYW1lX3V0ZjhfbGVuICogMik7CiAJaWYg
KHN5bW5hbWVfdXRmMTZfbGVuIDwgMCkgewogCQlrZnJlZShzeW1uYW1lX3V0ZjE2KTsKIAkJcmV0
dXJuIHN5bW5hbWVfdXRmMTZfbGVuOwotLSAKMi40My4wCgo=
--000000000000b7b4580628d9d804--
