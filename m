Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC231CD1E
	for <linux-cifs@vger.kernel.org>; Wed,  7 Feb 2024 06:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707286123; cv=none; b=VUdva4u6aTUTBXjKE9jPwFyVepRy9i1hct1Oj6Uqb/WH5A3WJo/Q/6njxybhxbj7ddPYW/KQ/LVxTfGtEKEVYIjtmYvPJ5oJremTsAqxlScDxCCMlazpk2UQmoolw5NndNluuwD3tPvHk8DS2NFtZDJD4lZzIhZ+gapwyGuICwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707286123; c=relaxed/simple;
	bh=zyW37a+MDsit4ffgTm9BBNgOsy5kGiAwPXbNEmGz4qw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=jEFkctYPOaU/SQ667H27VI8nZpvvcD4mZiIxvG1k72Y7YPbGpOXa685MO5ZyXxwd90uFOoQyRecQY+wCbj1XGbuBMyDXObD85LMlQz/h+rKBV6g5o3c+AXkFxjIxVBrW9sPVAO3EGE5FxIxGtcDYGGBB0/ymNh54ZA6onsBwctI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SHL/B3n1; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SHL/B3n1"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-51142b5b76dso392525e87.2
        for <linux-cifs@vger.kernel.org>; Tue, 06 Feb 2024 22:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707286120; x=1707890920; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ADXEMElfjIHUfaepUHiUfsHqNMNprQGCgn7+GCgP9EE=;
        b=SHL/B3n1lefH1kisDT7wNlcTDdTixHtvCA2YzI/rQ6Ave1Fo31dcKNcWtmLvMOLn7u
         fNkaRG/oKryvR8nRvpdZv8vfhB94U9Q16u+cWycq1IV4eiKRaGW90sZxQ3JxDX3eaxV2
         LniTij5vhhj/l4Dg0b1po1Vv+GMynqf5qLdgQU42CBPoS3VDA2MTgcxoZYe3KFnC2+o2
         kU/KLqGEATjgI9SY3xYNTqLHzp4xwbazwqTuoiCIDGhF6+Eb53bc0yoSdhmmj5MwNxiB
         wHp/jm41LDgWq4SptCyNCsSVBWSqfXAi5sCye2wqwKo1j6M/XVJpUrXF4K5JmJjBkxnH
         PyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707286120; x=1707890920;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ADXEMElfjIHUfaepUHiUfsHqNMNprQGCgn7+GCgP9EE=;
        b=vVG77JoZFIaCjwTXx6E6kMA+l8jKu5k+PYgJ6dmJt8XY/iJcJwiUImds61v/hB9bOm
         d9BOArV9EWlks7YFlOlY2DCssqNzSllysiZVnExoX/IAKT46/4tUGpd1m0gkxaIHXH1E
         1WW1xSa036YI4F+bRStdGOrotO5vIhJBZIs7Yac8dpf32DZ0VniuJf43rqCP8KPB2YAt
         E+3r/4otvlU3sTCy8jemx0cpfQJ+b9OeYgVn30BkQ2rHDelFrCMgRF/HtjBuXoCeFket
         txy4DLvGkHiv5n/Y5trPyy6l4yLWWKIMyuIxnmbr4rI6euhTRoxm222YB65xVj2jFfnv
         Uj/A==
X-Forwarded-Encrypted: i=1; AJvYcCXXYmm9m5kSgubmYo6L7/R+9ae+yoep6FnhG4Hs+ZLWgMMFT3dU3G3zJ7hcJG9A1WXxbZ/rRK/l/nZopydEuAC1yjoWxVosiPfXYA==
X-Gm-Message-State: AOJu0YxW9imrnJ7zivB3Gkrdr7RMGjWCA6psyxVjY/nKBNnNC6/s4R/Z
	B9bKughqyMm0uvMp/EF5VAAP3Ipgmq01jHIzpmlaLxm4QaRZ+nHRAQ4F8UUxRDcq3mu3WSqcHvR
	kTUrC0yEmJqXqxtQVll3OqLlNh75NGNwOcLo=
X-Google-Smtp-Source: AGHT+IEegdTGD0uwj8MW5iwQbvbtw0M2QT7eszRTwqGLA3sBmKNqd8Ht3r/OZO5EZ1PXLyQqBWolBkOZK4rd0PPmhyU=
X-Received: by 2002:ac2:5f52:0:b0:511:47cf:d09d with SMTP id
 18-20020ac25f52000000b0051147cfd09dmr3082269lfz.3.1707286119645; Tue, 06 Feb
 2024 22:08:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 7 Feb 2024 00:08:28 -0600
Message-ID: <CAH2r5mutYBiXyBnMWKF66DGrKHd7=ypsPGcg_XSrJW=JykNBbQ@mail.gmail.com>
Subject: [PATCH][smb client] updating warning message for sec=krb5p
To: samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>
Cc: Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000b11cdf0610c4860d"

--000000000000b11cdf0610c4860d
Content-Type: text/plain; charset="UTF-8"

    smb3: clarify mount warning

    When a user tries to use the "sec=krb5p" mount parameter to encrypt
    data on connection to a server (when authenticating with Kerberos), we
    indicate that it is not supported, but do not note the equivalent
    recommended mount parameter ("sec=krb5,seal") which turns on encryption
    for that mount (and uses Kerberos for auth).  Without an updated
mount warning
    it could confuse some NFS users.   Note that for SMB3+ we support
encryption,
    but consider it ("seal") a distinct mount parameter since the same
user may choose
    to encrypt to one share but not another from the same client.
Update the warning message
    to reduce confusion.

    See attached.
-- 
Thanks,

Steve

--000000000000b11cdf0610c4860d
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-smb3-clarify-mount-warning.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-clarify-mount-warning.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lsbdxbje0>
X-Attachment-Id: f_lsbdxbje0

RnJvbSA2MDhiMGQ1ODBmOTE3ZTAyYjZhZmQxYmUzZTQ3OWIyOTU4N2JiODhhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgNiBGZWIgMjAyNCAyMzo1NzoxOCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGNsYXJpZnkgbW91bnQgd2FybmluZwoKV2hlbiBhIHVzZXIgdHJpZXMgdG8gdXNlIHRoZSAi
c2VjPWtyYjVwIiBtb3VudCBwYXJhbWV0ZXIgdG8gZW5jcnlwdApkYXRhIG9uIGNvbm5lY3Rpb24g
dG8gYSBzZXJ2ZXIgKHdoZW4gYXV0aGVudGljYXRpbmcgd2l0aCBLZXJiZXJvcyksIHdlCmluZGlj
YXRlIHRoYXQgaXQgaXMgbm90IHN1cHBvcnRlZCwgYnV0IGRvIG5vdCBub3RlIHRoZSBlcXVpdmFs
ZW50CnJlY29tbWVuZGVkIG1vdW50IHBhcmFtZXRlciAoInNlYz1rcmI1LHNlYWwiKSB3aGljaCB0
dXJucyBvbiBlbmNyeXB0aW9uCmZvciB0aGF0IG1vdW50IChhbmQgdXNlcyBLZXJiZXJvcyBmb3Ig
YXV0aCkuICBVcGRhdGUgdGhlIHdhcm5pbmcgbWVzc2FnZS4KClNpZ25lZC1vZmYtYnk6IFN0ZXZl
IEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L2ZzX2Nv
bnRleHQuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlv
bigtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvZnNfY29udGV4dC5jIGIvZnMvc21iL2Ns
aWVudC9mc19jb250ZXh0LmMKaW5kZXggNjAwYTc3MDUyYzNiLi42OTkzY2QzNThiOTQgMTAwNjQ0
Ci0tLSBhL2ZzL3NtYi9jbGllbnQvZnNfY29udGV4dC5jCisrKyBiL2ZzL3NtYi9jbGllbnQvZnNf
Y29udGV4dC5jCkBAIC0yMTEsNyArMjExLDcgQEAgY2lmc19wYXJzZV9zZWN1cml0eV9mbGF2b3Jz
KHN0cnVjdCBmc19jb250ZXh0ICpmYywgY2hhciAqdmFsdWUsIHN0cnVjdCBzbWIzX2ZzX2MKIAog
CXN3aXRjaCAobWF0Y2hfdG9rZW4odmFsdWUsIGNpZnNfc2VjZmxhdm9yX3Rva2VucywgYXJncykp
IHsKIAljYXNlIE9wdF9zZWNfa3JiNXA6Ci0JCWNpZnNfZXJyb3JmKGZjLCAic2VjPWtyYjVwIGlz
IG5vdCBzdXBwb3J0ZWQhXG4iKTsKKwkJY2lmc19lcnJvcmYoZmMsICJzZWM9a3JiNXAgaXMgbm90
IHN1cHBvcnRlZC4gVXNlIHNlYz1rcmI1LHNlYWwgaW5zdGVhZFxuIik7CiAJCXJldHVybiAxOwog
CWNhc2UgT3B0X3NlY19rcmI1aToKIAkJY3R4LT5zaWduID0gdHJ1ZTsKLS0gCjIuNDAuMQoK
--000000000000b11cdf0610c4860d--
