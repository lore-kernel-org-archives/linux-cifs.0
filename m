Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795B885C59
	for <linux-cifs@vger.kernel.org>; Wed, 24 Apr 2024 03:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713930395; cv=none; b=SuQ4hI41BVi6S5O2OhFCh8T+2569rG3BrhGG6xrraTNlyn1cGbCFgvx49t58GWTGjerwJTRbB4LeyeUoWv6uQYXKyCAje/IZ3zfZrRm6L2MxaItA7le4pH7NrkbL/EtcJr5DEyiGrSngy3Pq4iYYLVsNZh18gq3eOYULYHwP05E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713930395; c=relaxed/simple;
	bh=DMEhOrp81XbyR/nTLsFewEZnGGDbmvoNKPIyvByOpJQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Q9NReZL7Lwn7dRwtntYNwgzns93DA5nNkFE0/puFHeWSbACZKJY5wQy7Jm0PRAtP2XNOCSti2Nu1kXcIlZ8KCsXG+gDTpqfjL3rhHqu0mHM86Pcc4Nnno+HXI2sWWu5FNGRtIgU4y8W7JKs7j9fjPYkivgt8GeSYGV+CN2Pe+nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ezZpYj+l; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ezZpYj+l"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2db101c11feso3676771fa.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Apr 2024 20:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713930391; x=1714535191; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hZ05oNx3eb/gRKmx+Ygj5KdjCTaVIcBe9+0X/4/rao8=;
        b=ezZpYj+lW1xICIMD9vUZryLZJ/tkngwTl2uEYVfrcqxCPO6XjnWhl/owPIfF8ZIpwr
         pttzCJrtFop2/l3ImkXMUITospKZPWHdESzmWbxiVAuAE0bOUBp1q9OsSHdshB55fTiR
         2GdAh40lrnxQLIc2SBgrrXZS4IIKyM7AeCA/lGx9KpYgvoewAo/e09fO/4z9NOy15rrh
         qt72NMHVlmilNXzwZjuG2W7xpH+vWxGYdzD1e80pmoEr56Ye8lpRLhvckkPadw36xEka
         fewpuIB6+kmdzzsLdr6kMf5Ruu7TujST5qrFZ24EkFwwFO+EiY/847uU6w/eNi1tp9uC
         c0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713930391; x=1714535191;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hZ05oNx3eb/gRKmx+Ygj5KdjCTaVIcBe9+0X/4/rao8=;
        b=aHuFqP3TS5MNUhFztjVz+z7UPzg1sZp5s8hqwG64iNnzdRwHvQlE21eqGSOBU5VQxh
         i1ZdDBpUIJbk9XPHdGLIq9N1ePX54TF96IGyuvNO5sZExYDaFYVkASb9zWLi7FMbI64a
         baJxx9amCfAiIc8CVguB6ejarryZX/efues48EuS52IXVi9agFV1XD9qhXeSCJ3UadwS
         EvhMyl635ZNTKDs0oWJMw9z992DP3rozgLWM8kE5aH5w0UWNO3lwTT2aD3RbbB2hb/XS
         7OPl/ye+i2sG7qYhHjIf/EO8mJiec3tGP8AnU74MXSJHL2mCisgFtlr+GOXFUzShuSZ/
         d87A==
X-Gm-Message-State: AOJu0YyWXg6xX7x3ztnOXMoLP9xvD0xOu8RN8MwkKxoiCPmMD1RF5A3G
	RnaI90/NcdtnUTxR/Sml+mjADr4CkffE6DBiAngYxQR+ogCbSZxhe2efjxeOBsek34vd3YEHtmw
	4/vVneqRZImE4CGWLzw6jP9JXT8gfMZWT
X-Google-Smtp-Source: AGHT+IFm1uLv/onewmC32uo6n1UbUt6bcUaJQrOCxqo0uOVh+fdu+Isf/FQq+8f0bzL1Q8ba0zzm2oBqpdsxFp0T+wo=
X-Received: by 2002:a2e:900d:0:b0:2dd:c015:b67b with SMTP id
 h13-20020a2e900d000000b002ddc015b67bmr395571ljg.16.1713930390925; Tue, 23 Apr
 2024 20:46:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 23 Apr 2024 22:46:18 -0500
Message-ID: <CAH2r5mtJuttkzHDQB=-U3o=bBnv5U9r2w+JG-mXg1TPBT1wFog@mail.gmail.com>
Subject: [PATCH][SMB3 client] fix potential deadlock in cifs_sync_mid_result
To: CIFS <linux-cifs@vger.kernel.org>, Shyam Prasad N <nspmangalore@gmail.com>
Cc: Enzo Matsumiya <ematsumiya@suse.de>, Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000001f0f8b0616cf844a"

--0000000000001f0f8b0616cf844a
Content-Type: multipart/alternative; boundary="0000000000001f0f890616cf8448"

--0000000000001f0f890616cf8448
Content-Type: text/plain; charset="UTF-8"

Coverity spotted that the cifs_sync_mid_result function could deadlock
since cifs_server_dbg graps the srv_lock while we are still holding
the mid_lock

"Thread deadlock (ORDER_REVERSAL) lock_order: Calling spin_lock acquires
lock TCP_Server_Info.srv_lock while holding lock TCP_Server_Info.mid_lock"

Addresses-Coverity: 1590401 ("Thread deadlock (ORDER_REVERSAL)")

See attached patch


-- 
Thanks,

Steve

--0000000000001f0f890616cf8448
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Coverity spotted that the cifs_sync_mid_result function co=
uld deadlock<div>since cifs_server_dbg graps=C2=A0the srv_lock while we are=
 still holding</div><div>the mid_lock<br><br>&quot;Thread deadlock (ORDER_R=
EVERSAL) lock_order: Calling spin_lock acquires<br>lock TCP_Server_Info.srv=
_lock while holding lock TCP_Server_Info.mid_lock&quot;<div><br><div>Addres=
ses-Coverity: 1590401 (&quot;Thread deadlock (ORDER_REVERSAL)&quot;)</div><=
div><br></div><div>See attached patch<br clear=3D"all"><div><br></div><div>=
<br></div><span class=3D"gmail_signature_prefix">-- </span><br><div dir=3D"=
ltr" class=3D"gmail_signature" data-smartmail=3D"gmail_signature">Thanks,<b=
r><br>Steve</div></div></div></div></div>

--0000000000001f0f890616cf8448--
--0000000000001f0f8b0616cf844a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-lock-ordering-potential-deadlock-in-cifs_sy.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-lock-ordering-potential-deadlock-in-cifs_sy.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lvd9vwxh1>
X-Attachment-Id: f_lvd9vwxh1

RnJvbSA5YjQyMzI5MjYxMDY3YTUwMGYyNDUyZjEzMWM4OGM4Y2IwYjYyYWE1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjMgQXByIDIwMjQgMjI6MzU6MjggLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggbG9jayBvcmRlcmluZyBwb3RlbnRpYWwgZGVhZGxvY2sgaW4KIGNpZnNfc3luY19t
aWRfcmVzdWx0CgpDb3Zlcml0eSBzcG90dGVkIHRoYXQgdGhlIGNpZnNfc3luY19taWRfcmVzdWx0
IGZ1bmN0aW9uIGNvdWxkIGRlYWRsb2NrCgoiVGhyZWFkIGRlYWRsb2NrIChPUkRFUl9SRVZFUlNB
TCkgbG9ja19vcmRlcjogQ2FsbGluZyBzcGluX2xvY2sgYWNxdWlyZXMKbG9jayBUQ1BfU2VydmVy
X0luZm8uc3J2X2xvY2sgd2hpbGUgaG9sZGluZyBsb2NrIFRDUF9TZXJ2ZXJfSW5mby5taWRfbG9j
ayIKCkFkZHJlc3Nlcy1Db3Zlcml0eTogMTU5MDQwMSAoIlRocmVhZCBkZWFkbG9jayAoT1JERVJf
UkVWRVJTQUwpIikKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKU2lnbmVkLW9mZi1ieTogU3Rl
dmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvdHJh
bnNwb3J0LmMgfCA0ICsrKy0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3RyYW5zcG9ydC5jIGIvZnMvc21i
L2NsaWVudC90cmFuc3BvcnQuYwppbmRleCA5OTRkNzAxOTM0MzIuLjQ0M2I0Yjg5NDMxZCAxMDA2
NDQKLS0tIGEvZnMvc21iL2NsaWVudC90cmFuc3BvcnQuYworKysgYi9mcy9zbWIvY2xpZW50L3Ry
YW5zcG9ydC5jCkBAIC05MDksOSArOTA5LDExIEBAIGNpZnNfc3luY19taWRfcmVzdWx0KHN0cnVj
dCBtaWRfcV9lbnRyeSAqbWlkLCBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpCiAJCQls
aXN0X2RlbF9pbml0KCZtaWQtPnFoZWFkKTsKIAkJCW1pZC0+bWlkX2ZsYWdzIHw9IE1JRF9ERUxF
VEVEOwogCQl9CisJCXNwaW5fdW5sb2NrKCZzZXJ2ZXItPm1pZF9sb2NrKTsKIAkJY2lmc19zZXJ2
ZXJfZGJnKFZGUywgIiVzOiBpbnZhbGlkIG1pZCBzdGF0ZSBtaWQ9JWxsdSBzdGF0ZT0lZFxuIiwK
IAkJCSBfX2Z1bmNfXywgbWlkLT5taWQsIG1pZC0+bWlkX3N0YXRlKTsKLQkJcmMgPSAtRUlPOwor
CQlyZWxlYXNlX21pZChtaWQpOworCQlyZXR1cm4gLUVJTzsKIAl9CiAJc3Bpbl91bmxvY2soJnNl
cnZlci0+bWlkX2xvY2spOwogCi0tIAoyLjQwLjEKCg==
--0000000000001f0f8b0616cf844a--
