Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D71C191F68
	for <linux-cifs@vger.kernel.org>; Sun,  6 Apr 2025 19:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743968576; cv=none; b=TuhntZq0emeGVbLZLUWv/Vr3wxl7kAgyTGrIbZ/VNpm2ngQlPzebXzUfkpvAvmC2mAWO76lkL0ybWYpETCaUJI8wudJ5nMOFHAeBjx9w5fhIYfr2M9MkyhLqqdMt75jNilW0hFchJycLPLJiaa0NcZoSDVcp1ioahwc0JvYVWHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743968576; c=relaxed/simple;
	bh=RD3Ljt82KJuAcNiSSGTajVcTflVUNMKhzR5tj82r1Iw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=CSjDPSqtgwwprpRL7eEkiLZJM8vcfQYKij/1Ewk5Ynf1O2kIHd2X9DjT0a3SqKybdFOPKQ5/iZl3lzS/EhHUzLhD3VSAp9//ZKM3plAzD7bSTzT/hxzuAHTvYg64hcnxPCnpwntZoFwpJsm/HjZAwG4RG5YwWwWYt/u++ICticY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YvTyABeJ; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YvTyABeJ"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5498d2a8b89so4225936e87.1
        for <linux-cifs@vger.kernel.org>; Sun, 06 Apr 2025 12:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743968572; x=1744573372; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e3JJQm1qSjqMwiJoDddskYf4wu3viUAhC4IlUYhjc9M=;
        b=YvTyABeJU3/xS1Be7FWAHIwXD71NWpJOijzsk4spin44t6RmimVDfY9GB7aL6LcfaG
         FeCMhIMtiSRMx1L6ddcDGxfBn0HmRwaAdWwsFcBgIfsUrM5PwyajkIbKPjfiydl1FWPF
         sWONPm1xJ0rD8JC43XBrz1cvX1lHQXr3kjQm5pBPRDTo55mXYGv6pr0naerzCQri7UvW
         DwrfyQBiUseupoXE/TosKxe5o+Mal/UqOa2up/1645M8q+/9Wp1gbRtV4qQjEuQUdJhv
         YBSVp3ImzrBnbSrR6Co4uR72qi8FNJme2fwRQTsjP/4JdQQ9FrX/X5UEG5fUQV2oONcP
         a0zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743968572; x=1744573372;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e3JJQm1qSjqMwiJoDddskYf4wu3viUAhC4IlUYhjc9M=;
        b=RFK8kCJDTIs3HBWJSrKzuQRNnaZJ8crZfpS6dxDjC/pXanXYo/npgHOaH02rQcCHST
         t8M+Pm5xCkEQ5hua4nqmaYdootdwArU2Y/izs9LmNmQksERvEwYGK0RVUZ0IO/5v7x6x
         YJLERrBtuVqTM/+LBtS3e/b4TvYOktElcbDa/bzFeF8QDN9YRGyoVwTXELb3+j3T2GKg
         KDnCbb7E6kGOA1k1egYPjUTgv+fdMBZGX5JZDk3HvSrt+JM8zWXwHTdin9pWnG8fCi5u
         ToRIA0NgU/mPl427MMAD0x25BBqn2VlNaJOIjjzm5CqEy+T5hyyOS/jZ6wWyPCk/Mk/j
         1mQQ==
X-Gm-Message-State: AOJu0YxfCReoNp+2zje4Y88mjdceZOJ96TDOLKLm4k9WMCu/FVUiZ3gw
	z0AVLhB1tkqAL7kYczE7aJ3unIf1B5mrpmvAofebDeVV6eVWJo06JEiMmd5/Gg0KEyz1KZ34hsJ
	+GJR6O00Ex3zGjxwvPNsafFydNfYY8Enc
X-Gm-Gg: ASbGncsmnKONWHLTTRyWLNN939SGu0/8fQPzwkqcwljXAGEq2h+bWkN4iy0F7gp7uGD
	QT8iXXvyE8Op9YOyzXM1ee+R97QFMYtCAkv7YYOZuEZPZ3FFtVOsI7P1lVsUhQPSyhN2lJGKfBy
	uWawoAnbZMj07meQHHl/4r8dqTzn/uf1Lrnp1wH+zl03e+WOyrqxQjilVmWpb7
X-Google-Smtp-Source: AGHT+IHWWr+G0ug9xKZyoZJuvyly2ZVJ59MwzJgAOV7qKnn3lEIQ1VdJytZJaOS9VU9QnzeBQnM3n5Vxw1SMuXXevXk=
X-Received: by 2002:ac2:5683:0:b0:549:5b54:2c6c with SMTP id
 2adb3069b0e04-54c22777b0fmr2764388e87.23.1743968572010; Sun, 06 Apr 2025
 12:42:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 6 Apr 2025 14:42:40 -0500
X-Gm-Features: ATxdqUFMYDnAg8R0wPb559vnE-jhH0ijzywm72TsyA-1gmOWcqD_GRmFkVVf0gc
Message-ID: <CAH2r5muN630v9cDmMJ9hmavf2qdb0Gdpe80i6NAQnsB2C7eAgw@mail.gmail.com>
Subject: [PATCH][SMB311 client] fix missing tcon check when mounting with
 linux extensions
To: CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000003c11900632215344"

--0000000000003c11900632215344
Content-Type: text/plain; charset="UTF-8"

When mounting the same share twice, once with the "linux" mount parameter
(or equivalently "posix") and then once without (or e.g. with "nolinux"),
we were incorrectly reusing the same tree connection for both mounts.
This meant that the first mount of the share on the client, would
cause subsequent mounts of that same share on the same client to
ignore that mount parm ("linux" vs. "nolinux") and incorrectly reuse
the same tcon.

See attached

-- 
Thanks,

Steve

--0000000000003c11900632215344
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb311-client-fix-missing-tcon-check-when-mounting-w.patch"
Content-Disposition: attachment; 
	filename="0001-smb311-client-fix-missing-tcon-check-when-mounting-w.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m961soai0>
X-Attachment-Id: f_m961soai0

RnJvbSAwMTVmZTk4NmMzZTA1ZjJkMThlMmI3ZDBjMzU2MzA2Yjk4YjY5NjU2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgNiBBcHIgMjAyNSAxNDowOToxOSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjMxMSBjbGllbnQ6IGZpeCBtaXNzaW5nIHRjb24gY2hlY2sgd2hlbiBtb3VudGluZyB3aXRoCiBs
aW51eC9wb3NpeCBleHRlbnNpb25zCgpXaGVuIG1vdW50aW5nIHRoZSBzYW1lIHNoYXJlIHR3aWNl
LCBvbmNlIHdpdGggdGhlICJsaW51eCIgbW91bnQgcGFyYW1ldGVyCihvciBlcXVpdmFsZW50bHkg
InBvc2l4IikgYW5kIHRoZW4gb25jZSB3aXRob3V0IChvciBlLmcuIHdpdGggIm5vbGludXgiKSwK
d2Ugd2VyZSBpbmNvcnJlY3RseSByZXVzaW5nIHRoZSBzYW1lIHRyZWUgY29ubmVjdGlvbiBmb3Ig
Ym90aCBtb3VudHMuClRoaXMgbWVhbnQgdGhhdCB0aGUgZmlyc3QgbW91bnQgb2YgdGhlIHNoYXJl
IG9uIHRoZSBjbGllbnQsIHdvdWxkCmNhdXNlIHN1YnNlcXVlbnQgbW91bnRzIG9mIHRoYXQgc2Ft
ZSBzaGFyZSBvbiB0aGUgc2FtZSBjbGllbnQgdG8KaWdub3JlIHRoYXQgbW91bnQgcGFybSAoImxp
bnV4IiB2cy4gIm5vbGludXgiKSBhbmQgaW5jb3JyZWN0bHkgcmV1c2UKdGhlIHNhbWUgdGNvbi4K
CkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8
c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L2Nvbm5lY3QuYyB8IDIg
KysKIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9zbWIv
Y2xpZW50L2Nvbm5lY3QuYyBiL2ZzL3NtYi9jbGllbnQvY29ubmVjdC5jCmluZGV4IGYyOThlODZh
M2MxZi4uNGMxNWVkMDU4M2I0IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYwor
KysgYi9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYwpAQCAtMjU1Niw2ICsyNTU2LDggQEAgc3RhdGlj
IGludCBtYXRjaF90Y29uKHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIHN0cnVjdCBzbWIzX2ZzX2Nv
bnRleHQgKmN0eCkKIAkJcmV0dXJuIDA7CiAJaWYgKHRjb24tPm5vZGVsZXRlICE9IGN0eC0+bm9k
ZWxldGUpCiAJCXJldHVybiAwOworCWlmICh0Y29uLT5wb3NpeF9leHRlbnNpb25zICE9IGN0eC0+
bGludXhfZXh0KQorCQlyZXR1cm4gMDsKIAlyZXR1cm4gMTsKIH0KIAotLSAKMi40My4wCgo=
--0000000000003c11900632215344--
