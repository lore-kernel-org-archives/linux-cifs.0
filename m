Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053062C9A
	for <linux-cifs@vger.kernel.org>; Wed, 17 Jul 2024 05:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721195452; cv=none; b=MZzzJfa0XbxSfKxIYKfK0OD9vKyF1gfeMzvow+Zbo6QJobmIXrZey0njSYwecPlJxGHUPXu9VfIX7Nilg3i/PT/FHtl1gdIBNOMpIb2XS7+L+pFXMjkmQvTIUFoHphj5dtTEcwMCgkxqlKuvagPUfhG1tuINHRLs67Sf9ZF07hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721195452; c=relaxed/simple;
	bh=W/D+jJmCSwuSX9SfaTomxuiWVuFCohxPJ6ezCDHoaUg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qvCYZq92guwAVkdfyXUyfgNg8QWQQzJRREePMOUtXNJ7LAWGn9Zs5zGT35vrWbs6OcYZxHzvAjQQCo+Oue1jUc6YS20IRsZDm5+meeat6hbCWKjuzPJlrLUo64Nm5IcLFa0XtTPa+5QYFKmvCUTqlfkJRgD7DhwZ+7//ErtAAZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nbKTbz91; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nbKTbz91"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52e9c55febcso8297660e87.2
        for <linux-cifs@vger.kernel.org>; Tue, 16 Jul 2024 22:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721195449; x=1721800249; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e5+fpx10z9O3WcsMVXb5CUAhch/EF91R0lvtjEgsWko=;
        b=nbKTbz91aRztSZbdw+bhAyddzaPQdU+GxdoaBaO5kWZswX6/QcMf3bMVWTA6fZldkZ
         iSgPtgRBUzjvwL1u/nZDdLFZPyaeTQmRLhT+AncGnjPGW52aPntvkb6s3DM1LvMlVRVm
         zFaS30+3esnii88g+fl8dW4SgOqb+xlHjRn2Nmz5fpKk9S/ZtQlUCmr2OvdLRSMSXzpK
         jjcjDYGo0LadnPw6XaPXRcH+CHIjfAH1FA5klaIhg6HTlRBgvgoAWiGisKNf2gswbvxq
         xZPZ1KelR0ooMhuPRGoRtncw2BuVgm3cbKcwu0ZYUnFfBbAmAB28C7KsH2dTh8b0u6l1
         liKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721195449; x=1721800249;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e5+fpx10z9O3WcsMVXb5CUAhch/EF91R0lvtjEgsWko=;
        b=XWZGUpW5hgKaLyiUjttieUBietyCcQ3x8Ap6pjYCMbZzrZle/Ir1GhsLX5CR9VzR7q
         alBXfKWxrIMwgnbEUPjtxj+54o06oYH6PEucWfD8wIPw7b5MYT6GsEH2PEI4onJF4k61
         vYKAE9+YnJnBrCJDzPwvUfQi+7WfGd5N/FNY56s7ow5i0LbR2sJppCbB3+hUZB+w9DCM
         MCvdAzo/z+nwDUCBxtjKCcS5KAJpkvAQcGlZHAm5czV33EEacZ8FOgSVTFAqtU+lS1d+
         7efLvAYPM+sq68hsUkhKs7PBruax7DyCfwG00n2jPQMdgaj7SC8pvfl5CghoFafCSiX5
         u79Q==
X-Gm-Message-State: AOJu0Yyo9SayPPux/TguPU/Z90FOrAtLHQ8h3r7LnQwAsT/BSBvvOz6w
	qamMiEvZROk3eqAPRxtkodg0elPjC41Fonkhf59AijV93C7+SNHHPQK1hAPLrB+PZlLgum2Uipn
	b0F8Kc4JJ9fsUiXsH0DRWHtAEAD+RCuZC
X-Google-Smtp-Source: AGHT+IGAKHFTdNeB4FFqzQPGf2mvavDQr1uQgndW6blQSK8mcsGC7ggkjKUts5nxY1fkQ/O2Nyzgrk9wlaC9jhvAdr8=
X-Received: by 2002:a05:6512:234f:b0:52e:9382:a36 with SMTP id
 2adb3069b0e04-52ee53d694amr414423e87.30.1721195448410; Tue, 16 Jul 2024
 22:50:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 17 Jul 2024 00:50:36 -0500
Message-ID: <CAH2r5mvmbQDendkfH+kZuzx_xzqBqwHf1=fZR_vsY7PA4=sOhg@mail.gmail.com>
Subject: [PATCH][SMB3] fix noisy error message logged on cross share copy_file_range
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, Bharath S M <bharathsm@microsoft.com>
Content-Type: multipart/mixed; boundary="0000000000004aca8c061d6b0b56"

--0000000000004aca8c061d6b0b56
Content-Type: text/plain; charset="UTF-8"

    There are common cases where copy_file_range can noisily
    log "source and target of copy not on same server"
    e.g. the mv command across mounts to two different server's shares.
    Change this to informational rather than logging as an error.

    A followon patch will add dynamic trace points e.g. for
    cifs_file_copychunk_range


-- 
Thanks,

Steve

--0000000000004aca8c061d6b0b56
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-noisy-message-on-copy_file_range.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-noisy-message-on-copy_file_range.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lypfb9ab0>
X-Attachment-Id: f_lypfb9ab0

RnJvbSBiYjM2N2ZiZDNmMDE5MzViYjdjNzU0YzQxMTQyNGQxZGM0OTc3MmZkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTcgSnVsIDIwMjQgMDA6NDI6MjIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggbm9pc3kgbWVzc2FnZSBvbiBjb3B5X2ZpbGVfcmFuZ2UKClRoZXJlIGFyZSBjb21t
b24gY2FzZXMgd2hlcmUgY29weV9maWxlX3JhbmdlIGNhbiBub2lzaWx5CmxvZyAic291cmNlIGFu
ZCB0YXJnZXQgb2YgY29weSBub3Qgb24gc2FtZSBzZXJ2ZXIiCmUuZy4gdGhlIG12IGNvbW1hbmQg
YWNyb3NzIG1vdW50cyB0byB0d28gZGlmZmVyZW50IHNlcnZlcidzIHNoYXJlcy4KQ2hhbmdlIHRo
aXMgdG8gaW5mb3JtYXRpb25hbCByYXRoZXIgdGhhbiBsb2dnaW5nIGFzIGFuIGVycm9yLgoKQSBm
b2xsb3dvbiBwYXRjaCB3aWxsIGFkZCBkeW5hbWljIHRyYWNlIHBvaW50cyBlLmcuIGZvcgpjaWZz
X2ZpbGVfY29weWNodW5rX3JhbmdlCgpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpTaWduZWQt
b2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21i
L2NsaWVudC9jaWZzZnMuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2lmc2ZzLmMgYi9mcy9z
bWIvY2xpZW50L2NpZnNmcy5jCmluZGV4IDYzOTdmZGVmZDg3Ni4uYzkyOTM3YmVkMTMzIDEwMDY0
NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNmcy5jCisrKyBiL2ZzL3NtYi9jbGllbnQvY2lmc2Zz
LmMKQEAgLTEzNTksNyArMTM1OSw3IEBAIHNzaXplX3QgY2lmc19maWxlX2NvcHljaHVua19yYW5n
ZSh1bnNpZ25lZCBpbnQgeGlkLAogCXRhcmdldF90Y29uID0gdGxpbmtfdGNvbihzbWJfZmlsZV90
YXJnZXQtPnRsaW5rKTsKIAogCWlmIChzcmNfdGNvbi0+c2VzICE9IHRhcmdldF90Y29uLT5zZXMp
IHsKLQkJY2lmc19kYmcoVkZTLCAic291cmNlIGFuZCB0YXJnZXQgb2YgY29weSBub3Qgb24gc2Ft
ZSBzZXJ2ZXJcbiIpOworCQljaWZzX2RiZyhGWUksICJzb3VyY2UgYW5kIHRhcmdldCBvZiBjb3B5
IG5vdCBvbiBzYW1lIHNlcnZlclxuIik7CiAJCWdvdG8gb3V0OwogCX0KIAotLSAKMi40My4wCgo=
--0000000000004aca8c061d6b0b56--
