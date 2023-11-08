Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3211C32
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 03:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZorB3MuF"
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAE718C
	for <linux-cifs@vger.kernel.org>; Tue,  7 Nov 2023 19:45:15 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-5079f9ec8d9so409926e87.0
        for <linux-cifs@vger.kernel.org>; Tue, 07 Nov 2023 19:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699415113; x=1700019913; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PQtjhjELkZQjaz9znHgdKufw0NPIBxGd1ImfzzNrcpw=;
        b=ZorB3MuFVz1BpJG9iHRCwXF4Jp6FEeUVsLiwkToHtQNpaRN+mXbGJYW7lrWi+HIA4E
         LARhLCiMHeLf5cwo3xAIDhk86m135wURYogmQAtlCpuoOyD8Yq7YRXkNRwEorlgC51Tn
         C0YmxPwd4W3JpeByP5VSpQ3Mdz0akDxZC592uNz32q5mKg02eKylISZB2wVM+UNFSPLh
         B1Zu0BOqoYqPGq/6KPbIz5csrlFGwrRSHgpMVCDCk8enPNByapx8nwhuUAccn19BAknq
         UxSfXWiIGAyY8G7H0741ZtmgqIhZRBvmMrDqi7uRkYWBkxyjB3hdiO1DbsKbKBDZxlE0
         kgcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699415113; x=1700019913;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PQtjhjELkZQjaz9znHgdKufw0NPIBxGd1ImfzzNrcpw=;
        b=QM0dlNdlmIuE9siarDaEoosXc5O40KgNYirT/M8HbGri3uFMjBMPFZaeLhsDYicBP1
         D8Gn3+01y155yHLmVU+LvT7o7DEZ2rMqHpwZ5X0gmCH47L1Nalincb5GT+wtPoqzw1T+
         UB9YLp0ASmpTz7UoqeR7Orf5qJ9+aP1jmijVMtX3QBJt1MpzOuvoSMpwytVlEQ5VZddP
         gXHvhaqdXV3/aid0sXKjjdCexgdhfFJXQDBVMI6Gr4NsWmgdRx977ypIUAx8bduSLBTD
         HasQJdhr3l0IdVG0QfH3WxtuqC6luoDqJaDD46nWW+D8WfZW13QVmpgrh2+b6zfsY0tW
         jibA==
X-Gm-Message-State: AOJu0Yy8ECZ0+JxRQI1qfuEDizcTQFlOzyL2ivP/Gr0xUUm91pVdKcen
	M9zNINkzNsRFqAFavELkc/YZjMcgCe5qujm2YZbZxnyBCZBpRCjQ
X-Google-Smtp-Source: AGHT+IGQwqqjbeWWr9ruBgiNobzgpROMX7RPFvxjqMP5iO/TtpXYy4pb9nXc0BE+v5RS+cZApQyc6NbLC8HMnzlbzp0=
X-Received: by 2002:a19:6d01:0:b0:501:ba04:f352 with SMTP id
 i1-20020a196d01000000b00501ba04f352mr1746858lfc.1.1699415113096; Tue, 07 Nov
 2023 19:45:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 7 Nov 2023 21:45:01 -0600
Message-ID: <CAH2r5muHx+PE3ew9RMgKfif07TExDSN_MRfV1SB5FOOFd5F_rQ@mail.gmail.com>
Subject: Fix for xfstest generic/728
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000247dd706099beaec"

--000000000000247dd706099beaec
Content-Type: text/plain; charset="UTF-8"

smb3: fix caching of ctime on setxattr

Fixes xfstest generic/728 which had been failing due to incorrect
ctime after setxattr and removexattr

Update ctime on successful set of xattr

Cc: stable@vger.kernel.org

See attached patch

-- 
Thanks,

Steve

--000000000000247dd706099beaec
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-caching-of-ctime-on-setxattr.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-caching-of-ctime-on-setxattr.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lop7v4t20>
X-Attachment-Id: f_lop7v4t20

RnJvbSBjY2E5ODVjZDM1Nzg1OTMzNDg1Mzc2MTNhZjIwYjFmZDZhZjlhMWQ1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgNyBOb3YgMjAyMyAyMTozODoxMyAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGZpeCBjYWNoaW5nIG9mIGN0aW1lIG9uIHNldHhhdHRyCgpGaXhlcyB4ZnN0ZXN0IGdlbmVy
aWMvNzI4IHdoaWNoIGhhZCBiZWVuIGZhaWxpbmcgZHVlIHRvIGluY29ycmVjdApjdGltZSBhZnRl
ciBzZXR4YXR0ciBhbmQgcmVtb3ZleGF0dHIKClVwZGF0ZSBjdGltZSBvbiBzdWNjZXNzZnVsIHNl
dCBvZiB4YXR0cgoKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKU2lnbmVkLW9mZi1ieTogU3Rl
dmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQveGF0
dHIuYyB8IDUgKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3hhdHRyLmMgYi9mcy9zbWIvY2xpZW50
L3hhdHRyLmMKaW5kZXggYWMxOTkxNjBiY2U2Li42NzgwYWEzZTk4YTEgMTAwNjQ0Ci0tLSBhL2Zz
L3NtYi9jbGllbnQveGF0dHIuYworKysgYi9mcy9zbWIvY2xpZW50L3hhdHRyLmMKQEAgLTE1MCwx
MCArMTUwLDEzIEBAIHN0YXRpYyBpbnQgY2lmc194YXR0cl9zZXQoY29uc3Qgc3RydWN0IHhhdHRy
X2hhbmRsZXIgKmhhbmRsZXIsCiAJCWlmIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNf
TU9VTlRfTk9fWEFUVFIpCiAJCQlnb3RvIG91dDsKIAotCQlpZiAocFRjb24tPnNlcy0+c2VydmVy
LT5vcHMtPnNldF9FQSkKKwkJaWYgKHBUY29uLT5zZXMtPnNlcnZlci0+b3BzLT5zZXRfRUEpIHsK
IAkJCXJjID0gcFRjb24tPnNlcy0+c2VydmVyLT5vcHMtPnNldF9FQSh4aWQsIHBUY29uLAogCQkJ
CWZ1bGxfcGF0aCwgbmFtZSwgdmFsdWUsIChfX3UxNilzaXplLAogCQkJCWNpZnNfc2ItPmxvY2Fs
X25scywgY2lmc19zYik7CisJCQlpZiAocmMgPT0gMCkKKwkJCQlpbm9kZV9zZXRfY3RpbWVfY3Vy
cmVudChpbm9kZSk7CisJCX0KIAkJYnJlYWs7CiAKIAljYXNlIFhBVFRSX0NJRlNfQUNMOgotLSAK
Mi4zOS4yCgo=
--000000000000247dd706099beaec--
