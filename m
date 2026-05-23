Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA25C27732
	for <linux-cifs@vger.kernel.org>; Sat, 23 May 2026 00:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779497755; cv=pass; b=SB1bzRwo53EGM2BZpU5QE/KDQlXDsGbHDhOTNA96onhVtCLZrGPgNp30FUqukRtMbB+8L8aeA9RO10fTavX4OOUeF4Z7Y9NXQwGq6weejgNX/Sx7eZQr2BokYII8sN7Gbs4SbZQ+ejQhGOu6jQUV+IRmfWtPEK1yC/IAviEC0CU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779497755; c=relaxed/simple;
	bh=axs9hCqsF4rWlI7GkjFhjy2i42lR20dzBTv033yqlLg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ZTu0g83Dp3SlW6+llyd8V0wmDzuWZn8pyPFwfpGQJ3b/hgtzNSKXNDdgqggR1pPFhnQM7WD8mZexsArMyfZW8mm9JHvy+C2IFkItUnuVSpEJdNXFGF783Yv12cB7UOHCJLYlKHM1dlmlgXYY8AxcGaSgTD8mLGVdwhxA5BzA6L0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lhcQJ+YM; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lhcQJ+YM"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8cc715824a0so17102856d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 22 May 2026 17:55:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779497753; cv=none;
        d=google.com; s=arc-20240605;
        b=IGjD6PuCIxLRpI2y1xW/wIZgXxZefAEwPeb6/g78W5LdZ2xqai05kGCWq9FOHGzZh6
         ngPkogiKsOwrWm+6ljANXeIQilXxIzBwjn1odhDCRUYGQheAhg6hKKuTnI4yPKuPalVt
         A8fpxEW7CNHwMnPzGP33UKRLrOQtonwNmljYfdbNGezsXB8NimT8PK4YzwKJz1b7UXq9
         WE0YiCLEHMgdmyEZ0hkm+eIQggD4NNoKFVuVps0jbS5NuodwLGPXJ05Zn+eANYO6C004
         MEcqeHG/MRwJW0oP1QztcCzYW7UqBgNEWn2gAqBbPciTxU2nwiRyIsjjP7r1pOrJmqSE
         VJ9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=xTd7r0/Z8n+BhL0liA6ygxKmIjg1JQEeG/6T6tubpn8=;
        fh=s1+QdwFOBcxbdisgB787aqQBE17PlfKI/4DliI5p+Fo=;
        b=GfZfAiiX4TdVfouViIyzz04cf5Hw31w1eM5sU+CoSTQWNi3g5WPIyNnaH7axv5pmFn
         lOa0CvnMPnTRWwBeBd2JNmlPUlgGnxfAJBBZbDktLbOxRyR9rnA3Fl7TRJlZPqKc9TV6
         96cPiDLtElZ6w3cSFt9Y+JgFbaKS9/N5wFebkqdW4rV+EurWWSll48J/xvBmpOhzBex6
         YNEijoXO1rhfZg3l85zfgdlsx1ZgvLW1uOO12SXVy8I2L3aYpWmWKVHYVr67Ui/PCwAz
         Nd71hFDdZX5qxsQeB0fSDUGm8ja9ZDm2/IM+PpBLuVTkEtQSwaCrYWir1JNGN8L4Y3P/
         AO4w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779497753; x=1780102553; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xTd7r0/Z8n+BhL0liA6ygxKmIjg1JQEeG/6T6tubpn8=;
        b=lhcQJ+YMvWFnLV6XZofSYvw+EvDEPvGVnrL9BTw7ntZhxRLiVuM9KpAazH42UOV3+b
         9pLM766PHwdRrh58fyn5lcesUeYs3jHXRf71g/uHeGz0I6L5xX2Mi1cVA6YPGXXmttEX
         6j8HRAY5nC1koMuP6zdoFQ4yiY3mi3pdLflq/cSf7qHXAruOfsuaSgL3uojP8MpL4M18
         gzYh19Kvd6EOwIxmwxdmkZsD5SgV7PDZ1ohL0q2+FyJU8q9gNzKas22WiYYmSAkvVN5c
         rzW8RIrFNjrQ6q+l+wI6IhYIrq6SYJZmIxU6rqrYKr5taa14+HZ2jx3IiL9mjBUi0AhP
         XCzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779497753; x=1780102553;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xTd7r0/Z8n+BhL0liA6ygxKmIjg1JQEeG/6T6tubpn8=;
        b=NRs0ofKJgdyBXu579UlyyOjSU4mYTX4aq8jFyWLcJsauYyr/gLzQUUSb8msQO3Pr0S
         vXuxKI6ed0eORwoPMwty/ZDKDw+xyuvuht1klOicspZTV2v/WbIAcNKZTxw84Zz3Ejyv
         UBn3AnmUyBtlwsPxz+8ufRJz+Lri3mDNGvkF+JZyM8SoJPD/3zumz6TXMdeXoi86lmNk
         W2+UNeI0IjMNRdjMY6D9R5XiuQpWsoG2V91H9TX00aCeLC6vTJJfN3zyzJwUbyT8gD2B
         VUGU4sA+HrM6Au7vasCGooUYgICfOqUti3OpsPQV2JykGY89fpUNFRhs8VVh+hl04URm
         QI+w==
X-Gm-Message-State: AOJu0YwZHGG5xIFdZG2TW8Yj/VZKtCNJkwxEDLkFirYvZzS6IGZvhY2R
	Pnue/wmaP4sBSzLD8ucevifX1Zos75cq4f4KF4bJ9Zs8pS58Rqt56b0nxQx/cZvDAXVSetodIcV
	P02IyN+od7ak3Pm06eSk30dTQwNodFqT29gcqYU0=
X-Gm-Gg: Acq92OFTQa4C+9caFBCHDSxLCd/LXVQip6UzaXSawQwAp98JLvG3Z2iF1coCn+Tc+lF
	LEfplWd+ETJXmXsawatRgwohnvVxl3VclLN6+s2aH3nfyiwixZa+Mh2wAmpoq3G907VOxoEO6Rv
	SdJ1mUHGMousgy4t3jdafoeF1ozYaJ9ZovE88MOQFx5EUn8Zk90ZyPHP/4ROwhEaWSLcHdNiSMn
	Jxq2eeBd8tLWlsziMzcyuyOwbB82Fb5fNDbjMtWaLf85jfjXtPa4Cdzbm0iCh4ldSB1EQjiQKzE
	N5IjC+iA5r0dbAQAP+AGnn2JPLOAWQUJKsTQiRsBpdKX0N34dqCn3wap+xfJw2sSoX8S6NNzolg
	flEZ90N0PCgIck93lEElirBzSXr0DVNabbtCGKdpl8OIdcXitcJL7vviq8QdO/ZEQdt4fiHSO66
	94S0jdAWltNLuJ65aEd9RPLA==
X-Received: by 2002:a05:6214:4b07:b0:8ca:174d:187a with SMTP id
 6a1803df08f44-8cc7b54ff03mr109369996d6.15.1779497752418; Fri, 22 May 2026
 17:55:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 22 May 2026 19:55:40 -0500
X-Gm-Features: AVHnY4I0Y6rq2OVqBUMvrjs7lqB-QEQ4zaKOoKGbzR0siG3tA8yYwU_HHytvE1U
Message-ID: <CAH2r5muNk2e1urZk3a-dV011P8Fa1q-tz1mJ1-PWV8416wXh1g@mail.gmail.com>
Subject: [PATCH] smb: client: fix uninitialized variable in smb2_writev_callback
To: CIFS <linux-cifs@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Content-Type: multipart/mixed; boundary="00000000000069d0bc0652719b9b"

--00000000000069d0bc0652719b9b
Content-Type: text/plain; charset="UTF-8"

compiling with W=2 pointed out that "written may be used
uninitialized" in smb2pdu.c

Fixes: 20d72b00ca81 ("netfs: Fix the request's work item to not require a ref")

See attached patch.


-- 
Thanks,

Steve

--00000000000069d0bc0652719b9b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb-client-fix-uninitialized-variable-in-smb2_writev.patch"
Content-Disposition: attachment; 
	filename="0001-smb-client-fix-uninitialized-variable-in-smb2_writev.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mphmzpy20>
X-Attachment-Id: f_mphmzpy20

RnJvbSA1ZjJmYTI5NmU3YWEwYThlMTI3MDY5N2NiMTI5YmUxY2FhOGM5ZjRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjIgTWF5IDIwMjYgMTg6Mjg6NDkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWI6IGNsaWVudDogZml4IHVuaW5pdGlhbGl6ZWQgdmFyaWFibGUgaW4KIHNtYjJfd3JpdGV2X2Nh
bGxiYWNrCgpjb21waWxpbmcgd2l0aCBXPTIgcG9pbnRlZCBvdXQgdGhhdCAid3JpdHRlbiBtYXkg
YmUgdXNlZCB1bmluaXRpYWxpemVkIgoKRml4ZXM6IDIwZDcyYjAwY2E4MSAoIm5ldGZzOiBGaXgg
dGhlIHJlcXVlc3QncyB3b3JrIGl0ZW0gdG8gbm90IHJlcXVpcmUgYSByZWYiKQpDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1p
Y3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9zbWIycGR1LmMgfCAyICstCiAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9z
bWIvY2xpZW50L3NtYjJwZHUuYyBiL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jCmluZGV4IDNiZDMw
MDM0N2YxNi4uZmJlYjIxNTZkZGI2IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJwZHUu
YworKysgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwpAQCAtNDk1NSw3ICs0OTU1LDcgQEAgc21i
Ml93cml0ZXZfY2FsbGJhY2soc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBzdHJ1Y3Qg
bWlkX3FfZW50cnkgKm1pZCkKIAl1bnNpZ25lZCBpbnQgcnJlcV9kZWJ1Z19pZCA9IHdkYXRhLT5y
cmVxLT5kZWJ1Z19pZDsKIAl1bnNpZ25lZCBpbnQgc3VicmVxX2RlYnVnX2luZGV4ID0gd2RhdGEt
PnN1YnJlcS5kZWJ1Z19pbmRleDsKIAlzc2l6ZV90IHJlc3VsdCA9IDA7Ci0Jc2l6ZV90IHdyaXR0
ZW47CisJc2l6ZV90IHdyaXR0ZW4gPSAwOwogCiAJV0FSTl9PTkNFKHdkYXRhLT5zZXJ2ZXIgIT0g
c2VydmVyLAogCQkgICJ3ZGF0YSBzZXJ2ZXIgJXAgIT0gbWlkIHNlcnZlciAlcCIsCi0tIAoyLjUz
LjAKCg==
--00000000000069d0bc0652719b9b--
