Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57151C8E2
	for <linux-cifs@vger.kernel.org>; Thu, 22 Feb 2024 06:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708584047; cv=none; b=PWIRxV+iJ8IRDmody8N1kAqvXM7tPnMtyBtEOYdGkKoyZ8FCTCR8TIf7DG33bYZwYWjjkAzgcXGq+7OrVMig9IQaSz/g5SXupY79+zZE3r5iJcVrbalpl6RD9n2WRXt9m9jbTdnaHyibId4+dngJhrzgo5u49qF+11pI8AagiRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708584047; c=relaxed/simple;
	bh=8qbDf5r+Lp32ivHPTyddRBGp9CEEjoAS+Qo9YS0wenk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=cWN2DqdDjs9feLUIoniIU1zBb03Kao8RbctM4iHNFoeHxW439e5Jb/ath/amHeF4tfhOKXf5A0XM9L43XXis16t0LUS50YGfKqlZHefPZ/hOxcWsBQrOW0Hz1ExZyahYRzmac81kSQj2/GIpgEqEJMnzvWbDnOFSP2ivZOl6WwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kNR6utzw; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kNR6utzw"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d0a4e1789cso16032791fa.3
        for <linux-cifs@vger.kernel.org>; Wed, 21 Feb 2024 22:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708584043; x=1709188843; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Is1Hk8pJRrHgKq2pzPZI4LIXhrl9F/LhHiQKLEGareo=;
        b=kNR6utzwarK+JBzp4U8YQkw7XSV7KB2FLmj4tzSGt31wJUQUZoay9qdg+dh0jtTZAe
         TghPkJnsPbhEGyJQIqf0kM8F1wgGnHDkz+cZgdtGaWTye4lehCzsAW8eFeUWRyImc4q6
         oeSBv+KnYIK9MJA2sFGv0Q1DwtvnVz7jK93uNPo4QN3FcntzMkIghPBpOnKmR5+iUCOA
         86krGyYndz4/8/DtSEXcb74Lh/ENW78/XEOQ6Hat2dsFWjQZNNhonwO3WoRc/ChmeCqu
         s0zNRcQU6BQyE28vVkS/hZOLihP5/3HZjfNbWI47HLp1V99CLvhfHINERHQxIMkslRGO
         EPMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708584043; x=1709188843;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Is1Hk8pJRrHgKq2pzPZI4LIXhrl9F/LhHiQKLEGareo=;
        b=rjoGGDXKjzeKCKlv8z4S/2S5VLCtTa0y7s6s8cwHNdfs6gErtbuepqqKnrXq4RMbOt
         v5ebautaKjt4HyflkLuHRDl5Fl/EaHTlp6uR6Y3Pi0ORsSt3iFmg4N7NcxYDUr/Hcs3Q
         XVPHK1pHVvqzfvQyQGTCPKkkq/xx24ivfiOE7A+GuvsFpDFK4I/CKWe+9bUKBYtK1aDw
         JS6EA6Ar7cgf6TpxV/aSLC+I/NrUeYA4b9AqzzN5u0fCyolVjR822Ts2TKGTN7nYm3kx
         9w3MkTYQaNn+AV10wsALlj6PIYGzyWIBmPe+Q6uMhTBlE3Z76uaV9lxRIDJHBycuBWUO
         /UcQ==
X-Gm-Message-State: AOJu0YwBEeKblKCSG4k8DlbcpTIOPPDPJRThXGg8k1JkHb8FA1KhHsCn
	/2K0ZPWqfkhQWH0mTmi2fhXol8KF0u2tXzPwMbIsqnze5Iubs3ME+RbUhDLFpAEUn63yeSL3iC1
	6HPe628krHrr2T2MDrEbFkW1b4/C89jRMZQlx7g==
X-Google-Smtp-Source: AGHT+IHQXZxOP9ohz38J//7Gnu4POLd1jWz4klsApGXUawi8i8JkCd+NqBdhgrO+WpD+mRBEfGqw3TI13Bb0MOfccgY=
X-Received: by 2002:a2e:b1c9:0:b0:2d2:3f13:52e7 with SMTP id
 e9-20020a2eb1c9000000b002d23f1352e7mr6006238lja.12.1708584042872; Wed, 21 Feb
 2024 22:40:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 22 Feb 2024 00:40:31 -0600
Message-ID: <CAH2r5mtsvNU--3EDFvAPSVuSnLpmbDr5A4YbaY=9rrndLyOpiA@mail.gmail.com>
Subject: [PATCH][SMB3 client] update allocation size more accurately on write completion
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, 
	Bharath S M <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.com>
Content-Type: multipart/mixed; boundary="000000000000f1d8440611f2b89e"

--000000000000f1d8440611f2b89e
Content-Type: text/plain; charset="UTF-8"

Changes to allocation size are approximated for extending writes of
cached files until the server returns the actual value (on SMB3 close
or query info for example), but it was setting the estimated value for
number of blocks to larger than the file size even if the file is
likely sparse which breaks various xfstests (e.g. generic/129, 130,
221, 228).

When i_size and i_blocks are updated in write completion do not
increase allocation size more than what was written (rounded up to 512
bytes).

See attached.

This fixes the recent regression in various xfstests caused by the
xfstest change

commit b4396efc75aba5325f22690303857af4f63d128e
Author: Alexander Patrakov <patrakov@gmail.com>
Date:   Tue Dec 19 04:57:20 2023 +0800

    _require_sparse_files: rewrite as a direct test instead of a black list


-- 
Thanks,

Steve

--000000000000f1d8440611f2b89e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-update-allocation-size-more-accurately-on-write.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-update-allocation-size-more-accurately-on-write.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lswur5k10>
X-Attachment-Id: f_lswur5k10

RnJvbSBhZTMzZjFiNjkxY2M5ZmQ2ZmMwZGZlODQ5ODFlNWU4ZDVmMGNkM2QyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjIgRmViIDIwMjQgMDA6MjY6NTIgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiB1cGRhdGUgYWxsb2NhdGlvbiBzaXplIG1vcmUgYWNjdXJhdGVseSBvbiB3cml0ZQogY29t
cGxldGlvbgoKQ2hhbmdlcyB0byBhbGxvY2F0aW9uIHNpemUgYXJlIGFwcHJveGltYXRlZCBmb3Ig
ZXh0ZW5kaW5nIHdyaXRlcyBvZiBjYWNoZWQKZmlsZXMgdW50aWwgdGhlIHNlcnZlciByZXR1cm5z
IHRoZSBhY3R1YWwgdmFsdWUgKG9uIFNNQjMgY2xvc2Ugb3IgcXVlcnkgaW5mbwpmb3IgZXhhbXBs
ZSksIGJ1dCBpdCB3YXMgc2V0dGluZyB0aGUgZXN0aW1hdGVkIHZhbHVlIGZvciBudW1iZXIgb2Yg
YmxvY2tzCnRvIGxhcmdlciB0aGFuIHRoZSBmaWxlIHNpemUgZXZlbiBpZiB0aGUgZmlsZSBpcyBs
aWtlbHkgc3BhcnNlIHdoaWNoCmJyZWFrcyB2YXJpb3VzIHhmc3Rlc3RzIChlLmcuIGdlbmVyaWMv
MTI5LCAxMzAsIDIyMSwgMjI4KS4KCldoZW4gaV9zaXplIGFuZCBpX2Jsb2NrcyBhcmUgdXBkYXRl
ZCBpbiB3cml0ZSBjb21wbGV0aW9uIGRvIG5vdCBpbmNyZWFzZQphbGxvY2F0aW9uIHNpemUgbW9y
ZSB0aGFuIHdoYXQgd2FzIHdyaXR0ZW4gKHJvdW5kZWQgdXAgdG8gNTEyIGJ5dGVzKS4KClNpZ25l
ZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9z
bWIvY2xpZW50L2ZpbGUuYyB8IDkgKysrKysrKystCiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9maWxlLmMg
Yi9mcy9zbWIvY2xpZW50L2ZpbGUuYwppbmRleCAwNWU5MTUxNjJmMDUuLjZiMmRhMzY4ZDUyZCAx
MDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9maWxlLmMKKysrIGIvZnMvc21iL2NsaWVudC9maWxl
LmMKQEAgLTMwOTUsOCArMzA5NSwxNSBAQCBzdGF0aWMgaW50IGNpZnNfd3JpdGVfZW5kKHN0cnVj
dCBmaWxlICpmaWxlLCBzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZywKIAlpZiAocmMgPiAw
KSB7CiAJCXNwaW5fbG9jaygmaW5vZGUtPmlfbG9jayk7CiAJCWlmIChwb3MgPiBpbm9kZS0+aV9z
aXplKSB7CisJCQlsb2ZmX3QgYWRkaXRpb25hbF9ibG9ja3MgPSAoNTEyIC0gMSArIGNvcGllZCkg
Pj4gOTsKKwogCQkJaV9zaXplX3dyaXRlKGlub2RlLCBwb3MpOwotCQkJaW5vZGUtPmlfYmxvY2tz
ID0gKDUxMiAtIDEgKyBwb3MpID4+IDk7CisJCQkvKgorCQkJICogRXN0aW1hdGUgbmV3IGFsbG9j
YXRpb24gc2l6ZSBiYXNlZCBvbiB0aGUgYW1vdW50IHdyaXR0ZW4uCisJCQkgKiBUaGlzIHdpbGwg
YmUgdXBkYXRlZCBmcm9tIHNlcnZlciBvbiBjbG9zZSAoYW5kIG9uIHF1ZXJ5aW5mbykKKwkJCSAq
LworCQkJaW5vZGUtPmlfYmxvY2tzID0gbWluX3QoYmxrY250X3QsICg1MTIgLSAxICsgcG9zKSA+
PiA5LAorCQkJCQkJaW5vZGUtPmlfYmxvY2tzICsgYWRkaXRpb25hbF9ibG9ja3MpOwogCQl9CiAJ
CXNwaW5fdW5sb2NrKCZpbm9kZS0+aV9sb2NrKTsKIAl9Ci0tIAoyLjQwLjEKCg==
--000000000000f1d8440611f2b89e--
