Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB261E5734
	for <linux-cifs@vger.kernel.org>; Thu, 10 Apr 2025 03:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744257333; cv=none; b=ohyBblgUhIe7VMBBkPlgXwP6YhI+UwJfuc3wyxt4Szmx0Qz5g0ygpPCr7rdVouw0RoD9GwWccN2uAlowRzBr0znjK7QyWyYfME6TEKHJjEm2TEzbr3LxBbuZUma91pk/YJnOYvpp0EowhpaPFL/jTFQzwtaFgmJpofXnq+FaEnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744257333; c=relaxed/simple;
	bh=eXp1QKN8SAMiI4Jva68w2X4dbNml5Vfhiry0esOfals=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=OkVsADsGGiOwkf7krvKkBUG9WDnLpr5IV+dG+U2vU6bcp/MKCo/vF1L8N//h977S03NgtgGdk4zi3OqGfiP/afIaanjsemgfu7BV+N1iEP28G549+n4xkwctIWLCMbL21AtW2xAcsAoEyDOocVdIHM/FBLZ9Sqiiaa+6hAiWnUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CL1Sp+zR; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CL1Sp+zR"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-54963160818so458317e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 09 Apr 2025 20:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744257329; x=1744862129; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+YLBy+c7rlobD2v0xr3ok/BHui3xNByHOuO6KapeFiw=;
        b=CL1Sp+zRXNxmgYe0lUlDeM9oczdKRMWJI9iNFzllSy5B6gQzkQSeleHSeO/SPLvSYQ
         DTuChfUZL5aSP0iQBOeTBNXxp/GAmzp6ub4F7f/DhrglJfdeBwJ0+CzIXqgBHEfZzJe2
         X9DLtxEjyloZeXyxyl12Lx0YExbX95U5X1gjTygXKOKHwxt2LydXzkNYBqNWKvWEGBzc
         ujVnSdwNWtxH4JXY083VkiP+B/rSsEfJfguNt/WM4Idve2MY8Kv2+H6MtS4Vu0AXsDNS
         F8GAoGsPCUCdcp2mNhz0No8TTnzF262St7YADMNAPMcWQGIwELIrpofQOr52GGEWGNjn
         M4qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744257329; x=1744862129;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+YLBy+c7rlobD2v0xr3ok/BHui3xNByHOuO6KapeFiw=;
        b=ZoPwuRB1akSwtqXcjJKVmoPW9rva03ltLbOo9bGKZ3HhJKot0p3aQTCxbpC2ESfgyO
         kI3BrdnELnjbLxljdnkGYRNxCT2jHPkh5p5FKFy5pluo6ZRWNBeqJNsJa9jiivjugqQ/
         oKDCgUwYjMZeOPySM7GBnThnpz6s8s/yTgbi93pLz3zevKBLB2VfcqHDRKQFscHa0Chg
         JYOzEcLdZUEiV3IS5g6wZqDepr914GfnhcPpN/aQBBiFTXDlJYMVZPajUaIc4+laKHrM
         mYXiL20LxfB+GQGfDp1IXMZgoX9/RVoNCL0xLu8Vh82zuH+SRSkMVE0rbDphtwoyIMvq
         Ys8g==
X-Gm-Message-State: AOJu0YyXa5+Ma9UezNRoRGDyewPNA1ONPtjiLoqCNhW3uYQTt6qOHb6i
	MpOQmSDBQcXBdhLt2FG2efoCi35qySmZmK4lXMMiGW5j8oY+erutv+ng3/ptGrEr/vQetuMNYJg
	WB+QgtUnYkmt8AIypEtctfQeldZEnwV7i
X-Gm-Gg: ASbGncv8ZP22ndRjW5cZnsD3Bq2urFVpKdLMBRlecmhVlJTJq6hHba39AC9kpOdbO7T
	4pX9fB2P5YLzocKnqOdQtyj6eRuBNgXSAtsZXKJB5h5g1iyUV01D4WEdCX8tg3S1nhfQugw+6cW
	BJscw1Ztm+pxYbLcFlZVIB9rkYAZAIsEvvGkCZNCJppaAq1AclTjdVQVM=
X-Google-Smtp-Source: AGHT+IFerYVIXiGtqKbBSpCYYSNZT25E67fS51X90afaowH38gXlrOvjPEx6H0akkp4MoF+UXy9KOvYv6qBa2wB8/HY=
X-Received: by 2002:a05:6512:158d:b0:545:ee3:f3c5 with SMTP id
 2adb3069b0e04-54d3c5a800amr173350e87.17.1744257329184; Wed, 09 Apr 2025
 20:55:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 9 Apr 2025 22:55:17 -0500
X-Gm-Features: ATxdqUHwk1qFsQAj_o5txSLEti67-Gvq-7FcadmxhUTZapiStP2Hpw1XJocCRPc
Message-ID: <CAH2r5mtHccZDP-QdWsb508iNpjeaCPsC8bxrpUgXk3y77aEcfg@mail.gmail.com>
Subject: [PATCH] Add missing defines for new File System Attributes
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Content-Type: multipart/mixed; boundary="00000000000080e56b0632648e41"

--00000000000080e56b0632648e41
Content-Type: text/plain; charset="UTF-8"

Trivial patch to add the two new defines for FileSystemAttributes


Two new file system attributes were recently added. See MS-FSCC 2.5.1:
           FILE_SUPPORTS_POSIX_UNLINK_RENAME and
           FILE_RETURNS_CLEANUP_RESULT_INFO

Update the missing defines for ksmbd.ko and cifs.ko

See attached


-- 
Thanks,

Steve

--00000000000080e56b0632648e41
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-Add-defines-for-two-new-FileSystemAttributes.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-Add-defines-for-two-new-FileSystemAttributes.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m9atrmy90>
X-Attachment-Id: f_m9atrmy90

RnJvbSA1ZDE0Njk4YmJjMDE4MGFkNTZlOGExY2JkNzk2YmVhYWNmMDhhOWQ5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgOSBBcHIgMjAyNSAyMjo0NTowNSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IEFkZCBkZWZpbmVzIGZvciB0d28gbmV3IEZpbGVTeXN0ZW1BdHRyaWJ1dGVzCgpUd28gbmV3
IGZpbGUgc3lzdGVtIGF0dHJpYnV0ZXMgd2VyZSByZWNlbnRseSBhZGRlZC4gU2VlIE1TLUZTQ0Mg
Mi41LjE6CiAgICAgICBGSUxFX1NVUFBPUlRTX1BPU0lYX1VOTElOS19SRU5BTUUgYW5kCiAgICAg
ICBGSUxFX1JFVFVSTlNfQ0xFQU5VUF9SRVNVTFRfSU5GTwoKVXBkYXRlIHRoZSBtaXNzaW5nIGRl
ZmluZXMgZm9yIGtzbWJkIGFuZCBjaWZzLmtvCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2gg
PHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9jaWZzcGR1LmggICAg
fCAyICsrCiBmcy9zbWIvc2VydmVyL3NtYl9jb21tb24uaCB8IDIgKysKIDIgZmlsZXMgY2hhbmdl
ZCwgNCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzcGR1Lmgg
Yi9mcy9zbWIvY2xpZW50L2NpZnNwZHUuaAppbmRleCA0OGQwZDZmNDM5Y2YuLjE4ZDY3YWIxMTNm
MCAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jaWZzcGR1LmgKKysrIGIvZnMvc21iL2NsaWVu
dC9jaWZzcGR1LmgKQEAgLTIyNTYsNiArMjI1Niw4IEBAIHR5cGVkZWYgc3RydWN0IHsKICNkZWZp
bmUgRklMRV9TVVBQT1JUU19FTkNSWVBUSU9OCTB4MDAwMjAwMDAKICNkZWZpbmUgRklMRV9TVVBQ
T1JUU19PQkpFQ1RfSURTCTB4MDAwMTAwMDAKICNkZWZpbmUgRklMRV9WT0xVTUVfSVNfQ09NUFJF
U1NFRAkweDAwMDA4MDAwCisjZGVmaW5lIEZJTEVfU1VQUE9SVFNfUE9TSVhfVU5MSU5LX1JFTkFN
RSAweDAwMDAwNDAwCisjZGVmaW5lIEZJTEVfUkVUVVJOU19DTEVBTlVQX1JFU1VMVF9JTkZPICAw
eDAwMDAwMjAwCiAjZGVmaW5lIEZJTEVfU1VQUE9SVFNfUkVNT1RFX1NUT1JBR0UJMHgwMDAwMDEw
MAogI2RlZmluZSBGSUxFX1NVUFBPUlRTX1JFUEFSU0VfUE9JTlRTCTB4MDAwMDAwODAKICNkZWZp
bmUgRklMRV9TVVBQT1JUU19TUEFSU0VfRklMRVMJMHgwMDAwMDA0MApkaWZmIC0tZ2l0IGEvZnMv
c21iL3NlcnZlci9zbWJfY29tbW9uLmggYi9mcy9zbWIvc2VydmVyL3NtYl9jb21tb24uaAppbmRl
eCBhM2Q4YTkwNWIwN2UuLmQ3NDJiYTc1NDM0OCAxMDA2NDQKLS0tIGEvZnMvc21iL3NlcnZlci9z
bWJfY29tbW9uLmgKKysrIGIvZnMvc21iL3NlcnZlci9zbWJfY29tbW9uLmgKQEAgLTcyLDYgKzcy
LDggQEAKICNkZWZpbmUgRklMRV9TVVBQT1JUU19FTkNSWVBUSU9OCTB4MDAwMjAwMDAKICNkZWZp
bmUgRklMRV9TVVBQT1JUU19PQkpFQ1RfSURTCTB4MDAwMTAwMDAKICNkZWZpbmUgRklMRV9WT0xV
TUVfSVNfQ09NUFJFU1NFRAkweDAwMDA4MDAwCisjZGVmaW5lIEZJTEVfU1VQUE9SVFNfUE9TSVhf
VU5MSU5LX1JFTkFNRSAweDAwMDAwNDAwCisjZGVmaW5lIEZJTEVfUkVUVVJOU19DTEVBTlVQX1JF
U1VMVF9JTkZPICAweDAwMDAwMjAwCiAjZGVmaW5lIEZJTEVfU1VQUE9SVFNfUkVNT1RFX1NUT1JB
R0UJMHgwMDAwMDEwMAogI2RlZmluZSBGSUxFX1NVUFBPUlRTX1JFUEFSU0VfUE9JTlRTCTB4MDAw
MDAwODAKICNkZWZpbmUgRklMRV9TVVBQT1JUU19TUEFSU0VfRklMRVMJMHgwMDAwMDA0MAotLSAK
Mi40My4wCgo=
--00000000000080e56b0632648e41--
