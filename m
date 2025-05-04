Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E73017578
	for <linux-cifs@vger.kernel.org>; Sun,  4 May 2025 23:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746401733; cv=none; b=OmFCe1Rp8S9I5I9LHNhjfKf7BXH2rdZufiULG1iy/wg96S/aXDtbvfF/V6F4om/RDtrQLD7ZYsJL+0rn7X9TYlfr5jHcSCiUYHCzACqrj8Ax1+Wls3BruB3zYBka3Qnfi/zYLJgUc4uFWTmkzfppvDajylsR9m1sx/gjZOLEZPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746401733; c=relaxed/simple;
	bh=lDXDDor34lQr5QixuMbx2mZgplEuXAMQXecaCXSNhhY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=fWJXCtE6mXOCxHB2nWG7upvEW5ooaCowJ94thuRr50XiEMd1TsfFZT1r9gT9/3NTTtsGb5uZ9lk0rTw/KtPELeoJ85PS8SprofVv19PAO2vFSfltFi+/2AwIxRbWYIL05kf4U1T5578iA9sOxcgrfNF6PT14vu1nHARmoJuovDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NGwqpjuG; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NGwqpjuG"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-317f68d0dffso43119681fa.2
        for <linux-cifs@vger.kernel.org>; Sun, 04 May 2025 16:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746401729; x=1747006529; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9iCBwcvUiEGu9BAFYNfEKi/Fh0hunjz4OjB2hIR2g1k=;
        b=NGwqpjuGb3gt+XNZDPeP9u6wPdcyAJIJzupGltYzmM227HppmgFKwJMCsbMK7q/eua
         WBA0p/hFmzIXoIhvNm47e+hrlXarChP2aoVjOxzSAoLRUsskUrjZk/0K2BkU0lH+Nqqh
         uAvMM3XK3qwSpasC9SjzwoMPTPQFanAzJGq004DYqWjsTXXeqazlAtDSy0vFye7B9Sbw
         4u/yxj9a5ZkdDq82stV8D6rsnVYo/N9sqb9SJOzeUZhnAFvKnpL1Ex4xIeQ8jHNcqVTg
         sG2OnTmsEBGk+aM1mvBPvyU4TbIAZ8fgXcZmM0sOBlbMYAMfZnTyTT1ZJ2qu74/Uu7zl
         mE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746401729; x=1747006529;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9iCBwcvUiEGu9BAFYNfEKi/Fh0hunjz4OjB2hIR2g1k=;
        b=xT1ICHPauBrVzCDvWm8yK1jOcd+j5KogClglQlGv3A0IwZIAEjCtSUgJsuxsvYT2KG
         S2PTiM3H9sZreNY1qNWiLKeNzA522Ow0R8Wgq5ghV5x1Yk+0qGk6Phmj0bipSQiPIAQP
         t3mGXzEJueV1ZjQry34xHn/PPafIqiyGCCdQXVPY0qyVQ6BZzNETnsNoxZAYSvCgxclu
         5wOZNcHDDI2EVYIFXPDiUU2wR8N7MICz/F7hJ6Yf6B0NNP4toHejcY9mCbs0D77SEbmX
         jaBltSf++YKvIG98GDRIBgZ5g1ifSoC9b8twFOdWglVIh6s5eTP94YPOJyfQN4LX7bki
         9DyQ==
X-Gm-Message-State: AOJu0YyWW9b1/hvTj/Z/8thEmkGw1o6LbUWnSUhYMgav9BdXlPqjimkT
	r5vC8AXE9GQeLe6y6BmWFtGEf82a+FXz4ebD41Vjkyh8hCJ/VUBOpzyZp7fadweMb2WE7riBgWD
	djjZ9FAMvFZnHeIHuGVwktf3pCi8Cre8y
X-Gm-Gg: ASbGncvI0a0GvIAEorrjTa46gjQMvRJlKLoF2GcKrz0N2UR3HCsdU3q71H74WuCzHJE
	FhtfLa48giI2+gPSTgP8U4VIOsBLARAm/1vDAgcJM7xPm50WkHPulUr2YFx6yGa1eQUnFR0J+pu
	pNNrm9olnWPVeOllRNi6t7yvk=
X-Google-Smtp-Source: AGHT+IHn2olXlLwlRQFBWVwu5hFDbuKvuFTq/2m56PcTCeoWzKJKMkzBaqPgORkhi6sSNZGOnEkwCg9urWAz4z2LBQY=
X-Received: by 2002:a05:651c:1695:b0:31a:1e23:a46e with SMTP id
 38308e7fff4ca-321db0c90demr9698911fa.14.1746401728520; Sun, 04 May 2025
 16:35:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 4 May 2025 18:35:16 -0500
X-Gm-Features: ATxdqUH1RX7rsHdR6CznsVY6C7HJAB_6aeUSVfUmtKHPO8TGMqumpDp2Mch4GeQ
Message-ID: <CAH2r5msR0K_gbiwy0+7PU0iSrRGyUpXzABVisBiHoVF3CrgV4w@mail.gmail.com>
Subject: [PATCH][smb3 client] warn when parse contexts returns error on
 compounded operation
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000aa0190063457d637"

--000000000000aa0190063457d637
Content-Type: text/plain; charset="UTF-8"

Coverity noticed that the rc on smb2_parse_contexts() was not being checked
in the case of compounded operations.  Since we don't want to stop parsing
the following compounded responses which are likely valid, we can't easily
error out here, but at least print a warning message if server has a bug
causing us to skip parsing the open response contexts.

Addresses-Coverity: 1639191

See attached.

-- 
Thanks,

Steve

--000000000000aa0190063457d637
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-client-warn-when-parse-contexts-returns-error-o.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-client-warn-when-parse-contexts-returns-error-o.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_maaaghxr0>
X-Attachment-Id: f_maaaghxr0

RnJvbSA5MWI3ZTNmYjIwNjYwMTE1ZjM0NTdkZjhlMjNhN2I0NzFjNzI2YWM0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgNCBNYXkgMjAyNSAxODoyNjo0NSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjMgY2xpZW50OiB3YXJuIHdoZW4gcGFyc2UgY29udGV4dHMgcmV0dXJucyBlcnJvciBvbgogY29t
cG91bmRlZCBvcGVyYXRpb24KCkNvdmVyaXR5IG5vdGljZWQgdGhhdCB0aGUgcmMgb24gc21iMl9w
YXJzZV9jb250ZXh0cygpIHdhcyBub3QgYmVpbmcgY2hlY2tlZAppbiB0aGUgY2FzZSBvZiBjb21w
b3VuZGVkIG9wZXJhdGlvbnMuICBTaW5jZSB3ZSBkb24ndCB3YW50IHRvIHN0b3AgcGFyc2luZwp0
aGUgZm9sbG93aW5nIGNvbXBvdW5kZWQgcmVzcG9uc2VzIHdoaWNoIGFyZSBsaWtlbHkgdmFsaWQs
IHdlIGNhbid0IGVhc2lseQplcnJvciBvdXQgaGVyZSwgYnV0IGF0IGxlYXN0IHByaW50IGEgd2Fy
bmluZyBtZXNzYWdlIGlmIHNlcnZlciBoYXMgYSBidWcKY2F1c2luZyB1cyB0byBza2lwIHBhcnNp
bmcgdGhlIG9wZW4gcmVzcG9uc2UgY29udGV4dHMuCgpBZGRyZXNzZXMtQ292ZXJpdHk6IDE2Mzkx
OTEKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgot
LS0KIGZzL3NtYi9jbGllbnQvc21iMmlub2RlLmMgfCAyICsrCiAxIGZpbGUgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIyaW5vZGUuYyBiL2Zz
L3NtYi9jbGllbnQvc21iMmlub2RlLmMKaW5kZXggNTdkOWJmYmFkZDk3Li4yYTNlNDZiOGUxNWEg
MTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMmlub2RlLmMKKysrIGIvZnMvc21iL2NsaWVu
dC9zbWIyaW5vZGUuYwpAQCAtNjY2LDYgKzY2Niw4IEBAIHN0YXRpYyBpbnQgc21iMl9jb21wb3Vu
ZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkv
KiBzbWIyX3BhcnNlX2NvbnRleHRzKCkgZmlsbHMgaWRhdGEtPmZpLkluZGV4TnVtYmVyICovCiAJ
CXJjID0gc21iMl9wYXJzZV9jb250ZXh0cyhzZXJ2ZXIsICZyc3BfaW92WzBdLCAmb3Bhcm1zLT5m
aWQtPmVwb2NoLAogCQkJCQkgb3Bhcm1zLT5maWQtPmxlYXNlX2tleSwgJm9wbG9jaywgJmlkYXRh
LT5maSwgTlVMTCk7CisJCWlmIChyYykKKwkJCWNpZnNfZGJnKFZGUywgInJjOiAlZCBwYXJzaW5n
IGNvbnRleHQgb2YgY29tcG91bmQgb3BcbiIsIHJjKTsKIAl9CiAKIAlmb3IgKGkgPSAwOyBpIDwg
bnVtX2NtZHM7IGkrKykgewotLSAKMi40My4wCgo=
--000000000000aa0190063457d637--
