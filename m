Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABA41FC4
	for <linux-cifs@vger.kernel.org>; Fri, 10 Nov 2023 07:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gJ4+ylvP"
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4568689
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 23:30:39 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-507e85ebf50so2194061e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 Nov 2023 23:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699601438; x=1700206238; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hK9ose7rtNgcL2qBkXgfbjD4PqSd5SPvz8Udedxd9qE=;
        b=gJ4+ylvP0V6i4QEiGZUP4264SI726BOT/zHhWSCBGqBYprh9IpBScQs/gIQ0LfAeVh
         sxREhAPS16AHVrluDYH3tMm9Y17nzBfhZuM/He6PczdmQjTzSTkRcFyL6uC/noKcqV7j
         FUIq8MOYRFuIH2HFXsVdT1cvZ3O8a+fZmWgMlerf7ZJ07PAO5il5go0hyQJN5CSuSt7r
         7HYN9S3shNZuYqyo3Xt7y6lvXFBx0iOAZrfWJmnER1lr8sY0h3jRxp/4sgnjq0lShmCt
         WoQ7lvrSPZLbTXlfooMV+omTSSs5yxhVUQL/Gy8IDe1R1ImsT8YorSi2pU3R/BusHrDA
         9frw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699601438; x=1700206238;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hK9ose7rtNgcL2qBkXgfbjD4PqSd5SPvz8Udedxd9qE=;
        b=gDeGyyP/rXcJGtrQyAONCZbPDA+V0wLwbjKRCFrJQnm+xh38X3uBeXgMVKFF03Cdg6
         soyefBJ/X6KwelQmjzHbEpGkf4vKYmPjgxOwdpYHSv07xaDo0rrvPyWG/9TbQ87QjetL
         07IeWi+wQ6GlUOh28ZSqRnSDW/qVy39sbc5R4ABWNImoJD/1whEOYyzhp1WGw1NrzG62
         LLjnfbG2cSm7O2YBVYQRfhEELBEj/04eJTeqNTunzjiyrMquUgdQE5hjJjUNQ6K87DNk
         YPOndIUbXd4Z/nAL1cvgUOx/XKjG9DIkv5/7aVvlkXYe9aDYBfuX9z0Cq0X/bMKscNfd
         KfRw==
X-Gm-Message-State: AOJu0YzKfCdWrw8SNcqkQcIltuZK2iABYahelnpo3OPUlwDtsf5Q3glK
	3gRhbz0RvBlT0TygyXrObsBlORG0LqKeNpO1QoYYWrrLBGEDnmVv2uY=
X-Google-Smtp-Source: AGHT+IHVMpgt9QYF/66LHR1c+3nq3DpKlAEAvudSGACrx4FmsnK2it4LX45BeSy5UnDzXRKxA1FY/TNHcKn15XQtZY4=
X-Received: by 2002:a05:6512:34c3:b0:507:b15b:8b93 with SMTP id
 w3-20020a05651234c300b00507b15b8b93mr2766448lfr.69.1699601437554; Thu, 09 Nov
 2023 23:30:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 10 Nov 2023 01:30:26 -0600
Message-ID: <CAH2r5mub4h5XpqBy=RTDuMAEByBtP441FX0G3W6hGVvS79Lfqw@mail.gmail.com>
Subject: [PATCH][SMB3 client] flags field not being set in
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000f2100f0609c74b46"

--000000000000f2100f0609c74b46
Content-Type: text/plain; charset="UTF-8"

A very small fix ...

The tcon_flags field was always being set to zero in the information
about the mount returned by the ioctl CIFS_IOC_GET_MNT_INFO instead
of being set to the value of the Flags field in the tree connection
structure as intended.


-- 
Thanks,

Steve

--000000000000f2100f0609c74b46
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-Missing-field-not-being-returned-in-ioctl-CIFS_IOC_G.patch"
Content-Disposition: attachment; 
	filename="0001-Missing-field-not-being-returned-in-ioctl-CIFS_IOC_G.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_losasy9q0>
X-Attachment-Id: f_losasy9q0

RnJvbSBhOTlhMTI4Njc2MDAyMzFmMTJjOGJkMWRhZDE4MmM0MDg1NTQ3NmI2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTAgTm92IDIwMjMgMDE6MjQ6MTYgLTA2MDAKU3ViamVjdDogW1BBVENIXSBN
aXNzaW5nIGZpZWxkIG5vdCBiZWluZyByZXR1cm5lZCBpbiBpb2N0bAogQ0lGU19JT0NfR0VUX01O
VF9JTkZPCgpUaGUgdGNvbl9mbGFncyBmaWVsZCB3YXMgYWx3YXlzIGJlaW5nIHNldCB0byB6ZXJv
IGluIHRoZSBpbmZvcm1hdGlvbgphYm91dCB0aGUgbW91bnQgcmV0dXJuZWQgYnkgdGhlIGlvY3Rs
cyBDSUZTX0lPQ19HRVRfTU5UX0lORk8gaW5zdGVhZApvZiBiZWluZyBzZXQgdG8gdGhlIHZhbHVl
IG9mIHRoZSBGbGFncyBmaWVsZCBpbiB0aGUgdHJlZSBjb25uZWN0aW9uCnN0cnVjdHVyZSBhcyBp
bnRlbmRlZC4KClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0
LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L2lvY3RsLmMgfCAxICsKIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvaW9jdGwuYyBiL2ZzL3Nt
Yi9jbGllbnQvaW9jdGwuYwppbmRleCA3M2VkZWRhOGViYTUuLmUyZjkyYzIxZmZmNSAxMDA2NDQK
LS0tIGEvZnMvc21iL2NsaWVudC9pb2N0bC5jCisrKyBiL2ZzL3NtYi9jbGllbnQvaW9jdGwuYwpA
QCAtMTQzLDYgKzE0Myw3IEBAIHN0YXRpYyBsb25nIHNtYl9tbnRfZ2V0X2ZzaW5mbyh1bnNpZ25l
ZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCiAJZnNpbmYtPnZlcnNpb24gPSAx
OwogCWZzaW5mLT5wcm90b2NvbF9pZCA9IHRjb24tPnNlcy0+c2VydmVyLT52YWxzLT5wcm90b2Nv
bF9pZDsKKwlmc2luZi0+dGNvbl9mbGFncyA9IHRjb24tPkZsYWdzOwogCWZzaW5mLT5kZXZpY2Vf
Y2hhcmFjdGVyaXN0aWNzID0KIAkJCWxlMzJfdG9fY3B1KHRjb24tPmZzRGV2SW5mby5EZXZpY2VD
aGFyYWN0ZXJpc3RpY3MpOwogCWZzaW5mLT5kZXZpY2VfdHlwZSA9IGxlMzJfdG9fY3B1KHRjb24t
PmZzRGV2SW5mby5EZXZpY2VUeXBlKTsKLS0gCjIuMzkuMgoK
--000000000000f2100f0609c74b46--
