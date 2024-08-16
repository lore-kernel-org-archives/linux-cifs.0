Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0641C57A2
	for <linux-cifs@vger.kernel.org>; Fri, 16 Aug 2024 21:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845376; cv=none; b=Q5LOGOuvl9QCzyN6UyZ6ns48JPrK/JtTtNJJgV7yUkisnvyRbN/M2cD20KsmW6SLyaIWNpW1cKSZ1BV+j852Xu27aUhUjBLC3veGSMbWDwQe/zd8W/wjoiDpmE19oOVGV7+Kj9dzJRkna9IIAmH15MwyDx0f+xrzvzBv2wD5amU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845376; c=relaxed/simple;
	bh=DH6G7Do3VNrV4NC1hzSpgWY0xRwpoSEvvnC557TN+4c=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Svsc8GTjE9J1gp2Ju3Gew0XPzpZNFWJJ1WIodhxM3KYeJk7wcwTemh4oLDM+Bg7u+eSoWJIP09VcfaObRimu55vOOS+fvkvX6/51WyWgFNY7a3O+15qBNJYiOMqXQ9Z+sZcyPE3fp3OinkxxQTXM2MeLAIRB7MKAmXpOucxOQsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fXELBpuc; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fXELBpuc"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52efd08e6d9so2985253e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 16 Aug 2024 14:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723845372; x=1724450172; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=INqbFCtS7hdtXTA2MpLVGbBQF3MX6s1l66OVT3n4bL8=;
        b=fXELBpucSK2mKefo7JkG+GpeL8+AsRsi2GQmSmXh14z8GQdzN9rUSe+/gTlTsaMyQl
         zGsZuo4af6bMZv9EYC8PcCTxxR/PeyRSG0eeJU9dLUbG5ETg56qppWdNXivROttA3V5L
         7FVZ8pmUhFtK0kWIiJCMlyXrQRpG0qIOI7kAf4oQXBUa3tzW+99LqTWq2IWbh8feLMOW
         Z0TUv11vpL83csq0wi8LutDbfBpT/wV7uVKchaBhRGwN/t8aPAsXzAcw/zz00HJEQyxz
         98eNPWCVz8Ss+einy9FFR1lNYstlh79WDlYKnIjM+qQJ4vkOqaX7hqkp2ChgxcN1yr8A
         90bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723845372; x=1724450172;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=INqbFCtS7hdtXTA2MpLVGbBQF3MX6s1l66OVT3n4bL8=;
        b=myatA7gM1ArRs69mXoRKf/FrFI/iV2mvLDfPsxYtTrTGvK0Y+pOduxEuwwT+Xw8Ri6
         StD2EpesmH20avgIVfOiihI/Ach0SoeyROyrMyhe/JJSlcLwblYlEf3Pg0wfHeeUoUv6
         votEV3/JQetzlt+A0wlT4mE62++7LlDOshiwdjdcynOUR9paMej1EFTFTayEHOUVFE+4
         2sqIWxU3adYBL7h6ZeZoDWafsaaSzWZgkiNpFLT3XXdRAbOwXWcQKKdAF8Et4ofqME5n
         0qtxk7hGROX2AmAmeWuCvIdi2UXByyvn/u8LrDB/LGkqxIA4e9PUsS6ODQ5oDm8ucpe8
         RPGQ==
X-Gm-Message-State: AOJu0Yzf4TdEA7yuQxllODWu05N2e5OD8H5Ly3CzqRbOHpn+Lp2q1tGX
	uG347/0vb50P/qKf6RphKSaWEFOPbCHyiKi8mq6S1k6dGhneD18sF8IhEHsNdjlBNikLH00gH6Q
	m95YLQlUFrThYxGZjJotWiCc/86Xp5bh4
X-Google-Smtp-Source: AGHT+IEeM0mSyThmBLBhahiNK0BRFN90gzP5EYQs9+HEhL+pWyZslh9soOYbi1uNlrPVHr1KgE56c/7Hqu0SVYN/+Cc=
X-Received: by 2002:a05:6512:1245:b0:530:b760:92b3 with SMTP id
 2adb3069b0e04-5331c6b079dmr2805390e87.31.1723845371745; Fri, 16 Aug 2024
 14:56:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 16 Aug 2024 16:56:00 -0500
Message-ID: <CAH2r5mtJA0AO+5YGXUKhnb0rtnezrNufZkpMAAuJ5tEKTibgig@mail.gmail.com>
Subject: [PATCH][SMB CLIENT] fix refcount issue that shutdown related xfstests uncovered
To: CIFS <linux-cifs@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Content-Type: multipart/mixed; boundary="00000000000007fb4b061fd407e3"

--00000000000007fb4b061fd407e3
Content-Type: text/plain; charset="UTF-8"

    smb3: fix problem unloading module due to leaked refcount on shutdown

    The shutdown ioctl can leak a refcount on the tlink which can
    prevent rmmod (unloading the cifs.ko) module from working.

    Found while debugging xfstest generic/043

    Fixes: 69ca1f57555f ("smb3: add dynamic tracepoints for shutdown ioctl")

See attached

-- 
Thanks,

Steve

--00000000000007fb4b061fd407e3
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-problem-unloading-module-due-to-leaked-refc.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-problem-unloading-module-due-to-leaked-refc.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lzx90lgd0>
X-Attachment-Id: f_lzx90lgd0

RnJvbSBkYTM1ZDQ0M2RlYWE2NGU3MDcyOTY5YTQxM2UzNzY5MzMyYmM1ODQ5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTYgQXVnIDIwMjQgMTY6NDc6MzkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggcHJvYmxlbSB1bmxvYWRpbmcgbW9kdWxlIGR1ZSB0byBsZWFrZWQgcmVmY291bnQg
b24KIHNodXRkb3duCgpUaGUgc2h1dGRvd24gaW9jdGwgY2FuIGxlYWsgYSByZWZjb3VudCBvbiB0
aGUgdGxpbmsgd2hpY2ggY2FuCnByZXZlbnQgcm1tb2QgKHVubG9hZGluZyB0aGUgY2lmcy5rbykg
bW9kdWxlIGZyb20gd29ya2luZy4KCkZvdW5kIHdoaWxlIGRlYnVnZ2luZyB4ZnN0ZXN0IGdlbmVy
aWMvMDQzCgpGaXhlczogNjljYTFmNTc1NTVmICgic21iMzogYWRkIGR5bmFtaWMgdHJhY2Vwb2lu
dHMgZm9yIHNodXRkb3duIGlvY3RsIikKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZy
ZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvY29ubmVjdC5jIHwgMyArKysK
IGZzL3NtYi9jbGllbnQvaW9jdGwuYyAgIHwgMiArKwogZnMvc21iL2NsaWVudC9saW5rLmMgICAg
fCAxICsKIDMgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMv
c21iL2NsaWVudC9jb25uZWN0LmMgYi9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYwppbmRleCBkMjMw
NzE2MmEyZGUuLmMxYzE0Mjc0OTMwYSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jb25uZWN0
LmMKKysrIGIvZnMvc21iL2NsaWVudC9jb25uZWN0LmMKQEAgLTQxOTQsNiArNDE5NCw5IEBAIHRs
aW5rX3JiX2luc2VydChzdHJ1Y3QgcmJfcm9vdCAqcm9vdCwgc3RydWN0IHRjb25fbGluayAqbmV3
X3RsaW5rKQogICoKICAqIElmIG9uZSBkb2Vzbid0IGV4aXN0IHRoZW4gaW5zZXJ0IGEgbmV3IHRj
b25fbGluayBzdHJ1Y3QgaW50byB0aGUgdHJlZSBhbmQKICAqIHRyeSB0byBjb25zdHJ1Y3QgYSBu
ZXcgb25lLgorICoKKyAqIFJFTUVNQkVSIHRvIGNhbGwgY2lmc19wdXRfdGxpbmsoKSBhZnRlciBz
dWNjZXNzZnVsIGNhbGxzIHRvIGNpZnNfc2JfdGxpbmssCisgKiB0byBhdm9pZCByZWZjb3VudCBp
c3N1ZXMKICAqLwogc3RydWN0IHRjb25fbGluayAqCiBjaWZzX3NiX3RsaW5rKHN0cnVjdCBjaWZz
X3NiX2luZm8gKmNpZnNfc2IpCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2lvY3RsLmMgYi9m
cy9zbWIvY2xpZW50L2lvY3RsLmMKaW5kZXggNDRkYmFmOTkyOWE0Li45YmI1Yzg2OWY0ZGIgMTAw
NjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvaW9jdGwuYworKysgYi9mcy9zbWIvY2xpZW50L2lvY3Rs
LmMKQEAgLTIyOSw5ICsyMjksMTEgQEAgc3RhdGljIGludCBjaWZzX3NodXRkb3duKHN0cnVjdCBz
dXBlcl9ibG9jayAqc2IsIHVuc2lnbmVkIGxvbmcgYXJnKQogCiBzaHV0ZG93bl9nb29kOgogCXRy
YWNlX3NtYjNfc2h1dGRvd25fZG9uZShmbGFncywgdGNvbi0+dGlkKTsKKwljaWZzX3B1dF90bGlu
ayh0bGluayk7CiAJcmV0dXJuIDA7CiBzaHV0ZG93bl9vdXRfZXJyOgogCXRyYWNlX3NtYjNfc2h1
dGRvd25fZXJyKHJjLCBmbGFncywgdGNvbi0+dGlkKTsKKwljaWZzX3B1dF90bGluayh0bGluayk7
CiAJcmV0dXJuIHJjOwogfQogCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2xpbmsuYyBiL2Zz
L3NtYi9jbGllbnQvbGluay5jCmluZGV4IGQ4NmRhOTQ5YTkxOS4uODAwOTliYmIzMzNiIDEwMDY0
NAotLS0gYS9mcy9zbWIvY2xpZW50L2xpbmsuYworKysgYi9mcy9zbWIvY2xpZW50L2xpbmsuYwpA
QCAtNTg4LDYgKzU4OCw3IEBAIGNpZnNfc3ltbGluayhzdHJ1Y3QgbW50X2lkbWFwICppZG1hcCwg
c3RydWN0IGlub2RlICppbm9kZSwKIAl0bGluayA9IGNpZnNfc2JfdGxpbmsoY2lmc19zYik7CiAJ
aWYgKElTX0VSUih0bGluaykpIHsKIAkJcmMgPSBQVFJfRVJSKHRsaW5rKTsKKwkJLyogQkIgY291
bGQgYmUgY2xlYXJlciBpZiBza2lwcGVkIHB1dF90bGluayBvbiBlcnJvciBoZXJlLCBidXQgaGFy
bWxlc3MgKi8KIAkJZ290byBzeW1saW5rX2V4aXQ7CiAJfQogCXBUY29uID0gdGxpbmtfdGNvbih0
bGluayk7Ci0tIAoyLjQzLjAKCg==
--00000000000007fb4b061fd407e3--
