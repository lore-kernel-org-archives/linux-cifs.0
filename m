Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51E8155351
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jul 2024 18:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721758922; cv=none; b=lHD2SM72GeDC9eEBbG4jFvzdKfA06lVF3h0Ce0WsjsswuPH65vA+fBPJ+8rfJiaZix+LvUnMjRJgaQbBhttS33UCfXH1U2zvAgsc/WiSHwODcOOBIRj7ioZ8hsFJ/bpIPERGCzDkUjEXB97YToDO+VlJnOSq7KNVNQgEPjNnUOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721758922; c=relaxed/simple;
	bh=W7Ocuv5f9u6PWSR+f1swXfGThreB6aVEOmQ6vGDpg+c=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=sJavuYu3zugVnjSEO8UGu6dvTUCPTX8iKuB0DzGQqzpwHmdEjCVZ7AXfwwB9SkjcJsQQTwOMqfT8fEmm3UNQetX9n3TGMJVLNVqneQ91QSZdl1dsyNjh9QxIclCtzn/nTTMNf1I4m8VcLUUvQR+GCcFpFj/kowhxM/6Ppzkuo2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JsaCZN/F; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JsaCZN/F"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52efba36802so4220621e87.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jul 2024 11:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721758919; x=1722363719; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1XDoX4Al4RHvx68f0zteTAdo2hXftFjzCiJ1b8jFKKs=;
        b=JsaCZN/Fv43uSfBPFBacBWEd3Cfc5yZhRjPbeeRQq27lmwuAo7AdntPemQxJlaLao2
         WJhzaehWbOkvul4lLnpVe/03ncUnjSk5eeVd1XddufnlSq32xydwHcPqnGdJpkH8lg30
         Rm2k3pqtavAQFvaFTYTGD0mwJI8EIA5bdZms69NbkiisjWN1er/VxzUu8jPAEuExp2z5
         tJ4/2nnz5xHQN8RBSkhfQa+Ylv1Xe90HTCHKq6V8gYn20XPhezykeTx4axOMzMcBX3Vj
         OiItEcLp4Dv8RnPpjU1e/2dyi6VCt8ygLYlKsCpjaRyuLKb3E3r2A693YUV+p7u3EkUS
         RRVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721758919; x=1722363719;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1XDoX4Al4RHvx68f0zteTAdo2hXftFjzCiJ1b8jFKKs=;
        b=g4AunapD6zimr+mYvtx42Wzm673B+mllY1bfwR8ztGp3wi94R6582faABANTywHk7D
         o+uqC24Ez//JIHHAC/wd5F+2bKXCVqp/DzMn5tzs2xlo457XT4oB9JJeo5UsH17k3K3/
         yNXLylSPtgnT1dPtGq8fmLQuhs0ufESIa/zPPIrWSvz28/sjbnZhidBxQeUZEqhgzXWE
         8FuRP6B3HUPaxwiVMAHgUNbD6J6R4rZHhr7AUp2YEb/RkRJB49EtpLhkgRp1VLpqFAnQ
         Q526Sky/tjBLAgmrl0s3dtFTNC65k7Ve+rNpnGggv8Nsj/jgc/Ab3x0sdy3Ifc7xWq51
         4CqA==
X-Forwarded-Encrypted: i=1; AJvYcCXsWhs63gYp/uXZJRhLHERH7Foswk2kd+wzhdh6ark1uczByy5jvKqRhyU1ds2+2qic8hpflKjkUfbZXm/nX4Jp9tHjDC9x/xoTgQ==
X-Gm-Message-State: AOJu0Yx8XUroaTVa560SSNiwtWvB3oXksBo6PRakno/BZGM4DBeutsTy
	cxz3PJlEuB3tWTIIP89SKBeFz1RF1A2maY0bwLPG+aMMn5FaigctjP343Ag7WAIQWS8Ym+NKqtt
	hXZbX4YtZmFkWLRNGfr4TeDxBSao=
X-Google-Smtp-Source: AGHT+IE//9pP+xUM5Z92LifXTaCHkgutPFZPFbJlPTZPd0lSuB9uG7JM6RyKFz4IyOl1s5Jcmp1CndwtZKmh0qsjyEw=
X-Received: by 2002:a05:6512:b21:b0:52e:a60e:3a04 with SMTP id
 2adb3069b0e04-52efb85af78mr6876338e87.59.1721758918723; Tue, 23 Jul 2024
 11:21:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 23 Jul 2024 13:21:45 -0500
Message-ID: <CAH2r5mvBCuc2tnbLeJnw5zEqqQJ_Qe9eiNiLxHg6eXeAi0n7FA@mail.gmail.com>
Subject: [PATCH v2][CIFS] mount with "unix" mount option for SMB1 incorrectly handled
To: samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>
Content-Type: multipart/mixed; boundary="000000000000bd8df9061dee3c22"

--000000000000bd8df9061dee3c22
Content-Type: text/plain; charset="UTF-8"

Lightly updated to include feedback from Paulo and add the reviewed-by



-- 
Thanks,

Steve

--000000000000bd8df9061dee3c22
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-mount-with-unix-mount-option-for-SMB1-incorrect.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-mount-with-unix-mount-option-for-SMB1-incorrect.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lyyqsmqx0>
X-Attachment-Id: f_lyyqsmqx0

RnJvbSAzNmEzYWQyNTI4NzM1YzQwMDdhZGU4NTIwYjY1MTQzYjU3NDAwODEyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjMgSnVsIDIwMjQgMDA6NDQ6NDggLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBtb3VudCB3aXRoICJ1bml4IiBtb3VudCBvcHRpb24gZm9yIFNNQjEgaW5jb3JyZWN0bHkK
IGhhbmRsZWQKCkFsdGhvdWdoIGJ5IGRlZmF1bHQgd2UgbmVnb3RpYXRlIENJRlMgVW5peCBFeHRl
bnNpb25zIGZvciBTTUIxIG1vdW50cyB0bwpTYW1iYSAoYW5kIHRoZXkgd29yayBpZiB0aGUgdXNl
ciBkb2VzIG5vdCBzcGVjaWZ5ICJ1bml4IiBvciAicG9zaXgiIG9yCiJsaW51eCIgb24gbW91bnQp
LCBhbmQgd2UgZG8gcHJvcGVybHkgaGFuZGxlIHdoZW4gYSB1c2VyIHR1cm5zIHRoZW0gb2ZmCndp
dGggIm5vdW5peCIgbW91bnQgcGFybS4gIEJ1dCB3aXRoIHRoZSBjaGFuZ2VzIHRvIHRoZSBtb3Vu
dCBBUEkgd2UKYnJva2UgY2FzZXMgd2hlcmUgdGhlIHVzZXIgZXhwbGljaXRseSBzcGVjaWZpZXMg
dGhlICJ1bml4IiBvcHRpb24gKG9yCmVxdWl2YWxlbnRseSAibGludXgiIG9yICJwb3NpeCIpIG9u
IG1vdW50IHdpdGggdmVycz0xLjAgdG8gU2FtYmEgb3Igb3RoZXIKc2VydmVycyB3aGljaCBzdXBw
b3J0IHRoZSBDSUZTIFVuaXggRXh0ZW5zaW9ucy4KCiAibW91bnQgZXJyb3IoOTUpOiBPcGVyYXRp
b24gbm90IHN1cHBvcnRlZCIKCmFuZCBsb2dnZWQ6CgogIkNJRlM6IFZGUzogQ2hlY2sgdmVycz0g
bW91bnQgb3B0aW9uLiBTTUIzLjExIGRpc2FibGVkIGJ1dCByZXF1aXJlZCBmb3IgUE9TSVggZXh0
ZW5zaW9ucyIKCmV2ZW4gdGhvdWdoIENJRlMgVW5peCBFeHRlbnNpb25zIGFyZSBzdXBwb3J0ZWQg
Zm9yIHZlcnM9MS4wICBUaGlzIHBhdGNoIGZpeGVzCnRoZSBjYXNlIHdoZXJlIHRoZSB1c2VyIHNw
ZWNpZmllcyBib3RoICJ1bml4IiAob3IgZXF1aXZhbGVudGx5ICJwb3NpeCIgb3IKImxpbnV4Iikg
YW5kICJ2ZXJzPTEuMCIgb24gbW91bnQgdG8gYSBzZXJ2ZXIgd2hpY2ggc3VwcG9ydHMgdGhlCkNJ
RlMgVW5peCBFeHRlbnNpb25zLgoKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKUmV2aWV3ZWQt
Ynk6IERhdmlkIEhvd2VsbHMgPGRob3dlbGxAcmVkaGF0LmNvbT4KUmV2aWV3ZWQtYnk6IFBhdWxv
IEFsY2FudGFyYSAoUmVkIEhhdCkgPHBjQG1hbmd1ZWJpdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0
ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L2Nv
bm5lY3QuYyB8IDggKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKykKCmRp
ZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYyBiL2ZzL3NtYi9jbGllbnQvY29ubmVj
dC5jCmluZGV4IGI2NmQ4YjAzYTM4OS4uODAyMjMwMDdiY2U0IDEwMDY0NAotLS0gYS9mcy9zbWIv
Y2xpZW50L2Nvbm5lY3QuYworKysgYi9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYwpAQCAtMjYxNCw2
ICsyNjE0LDE0IEBAIGNpZnNfZ2V0X3Rjb24oc3RydWN0IGNpZnNfc2VzICpzZXMsIHN0cnVjdCBz
bWIzX2ZzX2NvbnRleHQgKmN0eCkKIAkJCWNpZnNfZGJnKFZGUywgIlNlcnZlciBkb2VzIG5vdCBz
dXBwb3J0IG1vdW50aW5nIHdpdGggcG9zaXggU01CMy4xMSBleHRlbnNpb25zXG4iKTsKIAkJCXJj
ID0gLUVPUE5PVFNVUFA7CiAJCQlnb3RvIG91dF9mYWlsOworCQl9IGVsc2UgaWYgKHNlcy0+c2Vy
dmVyLT52YWxzLT5wcm90b2NvbF9pZCA9PSBTTUIxMF9QUk9UX0lEKQorCQkJaWYgKGNhcF91bml4
KHNlcykpCisJCQkJY2lmc19kYmcoRllJLCAiVW5peCBFeHRlbnNpb25zIHJlcXVlc3RlZCBvbiBT
TUIxIG1vdW50XG4iKTsKKwkJCWVsc2UgeworCQkJCWNpZnNfZGJnKFZGUywgIlNNQjEgVW5peCBF
eHRlbnNpb25zIG5vdCBzdXBwb3J0ZWQgYnkgc2VydmVyOiAlc1xuIiwKKwkJCQkJIHNlcy0+c2Vy
dmVyLT5ob3N0bmFtZSk7CisJCQkJcmMgPSAtRU9QTk9UU1VQUDsKKwkJCQlnb3RvIG91dF9mYWls
OwogCQl9IGVsc2UgewogCQkJY2lmc19kYmcoVkZTLAogCQkJCSJDaGVjayB2ZXJzPSBtb3VudCBv
cHRpb24uIFNNQjMuMTEgZGlzYWJsZWQgYnV0IHJlcXVpcmVkIGZvciBQT1NJWCBleHRlbnNpb25z
XG4iKTsKLS0gCjIuNDMuMAoK
--000000000000bd8df9061dee3c22--
