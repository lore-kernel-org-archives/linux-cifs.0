Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226F63A1CD
	for <linux-cifs@vger.kernel.org>; Tue,  8 Oct 2024 05:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728364643; cv=none; b=R/VjYInbyIA/Op31OiIUb0YH/7pS0PeIpWf0q0eMNbVElX0qSx1CJ/BGC46YPn2SwfLhIUZid1Ew0CzYLV+cjXjgZ/aJI+UeeWLbaSEusVRTCr4/IQYt1Jthw2omLX6Tc/SFnavI8jlJL5WFZ9ycGt7n6BU812NAMDFzDFnmG3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728364643; c=relaxed/simple;
	bh=V9ZruTGDai+Q3raXR/L20RKutrDpnH/wumYfIg4DLgQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=nFVeDTX9bJGsKhF+LtwkpCpXP3Lq5ZaYgyRU7sf+r21zQkR5Euy2Et5CH0R12DtKB6JFI8WN4nRAGxJdos0vgBteWYe+wGFZBhbpWAsG8z62H75z1SwTN2IRHRpEy3/8GMiVySK46/JxF2FbnBHUG9/GSItCOOKUqAIf2tbkxxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SHu+J4eC; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SHu+J4eC"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-53959a88668so6482077e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 07 Oct 2024 22:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728364640; x=1728969440; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ve1jSOXcYOj/U44yTu0kvkF8BmrgUqGzWcqMl9ze9uk=;
        b=SHu+J4eCNiUucmFoe+C57WOzsSPpGdd19NXqN/7qrKqgJXU3X2Hveusm9BtrZ1pygL
         p9x95W/z85X+yxKmOk37geqBchVXYWgBuQeWibm08ssZOFGuaxocGtW4Z4f4oMGXrU68
         Kaafy65ZPjTYSidB18SkcnYuQwP6u0K6e4k8EwjTzkDFV5RHGQLYRO2BNxnxeuhMK9gp
         F/cVWXsWmkHTR+B0jdJrB+d6WM1aYdP4rm1DWunTEVIb4FXGPmle9DyWd6Q0Pe7lmmQ7
         LSan+xPkKILbfcdIzFgZINokLzgG0KDAJ8BSIcIOGPW7FquF29M9V9ZtSawJfCp+XFeO
         GrtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728364640; x=1728969440;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ve1jSOXcYOj/U44yTu0kvkF8BmrgUqGzWcqMl9ze9uk=;
        b=OJx/h4/jj/wgjVNoMlNaIcjaKd3lHCzf3Oks8GY4yCoI9DGt0cf0seH5pNd9YKo1FW
         5oCb7RkEhTX/vrmviBaiOghIM+cayBFym3v+8pGcDfzTvibB5DgousNDhTkSuLlE5LE/
         H+qOlbXnyss/sCgQfg3+pGDosJ9nUTx+2MOqGVxQGuLgyE0ve4JQMEIkLTRj2xwXzL3U
         0StHa0ZZUv0aSQWTGfufsi3HQy9QEYSNjPixhNj8NR0p2ufdSvInYR6iuCm+XoZOWGJ/
         +VxMZ850B2uzHoECNF/6if2qmKgYZY/kOCqlmEFeqHCLZAln8aP1nfo89ZbvlfK5MJbh
         Qgkw==
X-Gm-Message-State: AOJu0YwWp0dIM5ZvNOkjxGymWc19rbOzMi+sjP0GxNvpGe0sbp6oJK4+
	x8lF2nwBLe3OqT6xX7jZA1w/7UB6w4mkfLFb+KMVH+G1fFhaMj2ACYIwi+wqFWSPqtIBvVIdggr
	bZDiEgBJriik0htXtyyqGUoWVtpQrkdzKw7I=
X-Google-Smtp-Source: AGHT+IGSBOckqd3Hudn5DQw8zoPbtYmKTt4zSnQxq1/JPbesE+Sgch4g7Ohuhk6f/H929PFw8oY6IswTK78l3T2TlH4=
X-Received: by 2002:a05:6512:3da3:b0:539:8f4d:a7dc with SMTP id
 2adb3069b0e04-539ab9e2e92mr6710025e87.48.1728364639917; Mon, 07 Oct 2024
 22:17:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 8 Oct 2024 00:17:07 -0500
Message-ID: <CAH2r5ms2jpBVtpYaE2hOgnfnjx73MnmPW2pQZnY-42ARYMf9ZQ@mail.gmail.com>
Subject: [PATCH][SMB3 client] minor updates to "stop flooding dmesg" patch
To: Paulo Alcantara <pc@manguebit.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000067ba100623f040b7"

--00000000000067ba100623f040b7
Content-Type: text/plain; charset="UTF-8"

I was not as comfortable with taking out where the error is logged on
session setup, but the other parts of the two patches below were fine.
So have added them back into for-next after the one small change to "
smb: client: stop flooding dmesg on failed session setups"

commit e25f5175ef11a56bba4fbfc66832817d59e887c6 (HEAD -> for-next,
origin/for-next)
Author: Paulo Alcantara <pc@manguebit.com>
Date:   Wed Sep 18 02:04:18 2024 -0300

    smb: client: stop flooding dmesg with automounts

    Avoid logging info and expected errors when automounting DFS links and
    reparse mount points as a share might contain hundreds of them and the
    client would end up flooding dmesg.

    Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

commit 2f34f5e966f7d99418b42b8c67cffbbbde94704b
Author: Paulo Alcantara <pc@manguebit.com>
Date:   Wed Sep 18 02:04:12 2024 -0300

    smb: client: stop flooding dmesg on failed session setups

    Stop flooding dmesg over failed session setups as kerberos tickets
    getting expired or passwords being rotated is a very common scenario.

    Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>


-- 
Thanks,

Steve

--00000000000067ba100623f040b7
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb-client-stop-flooding-dmesg-on-failed-session-set.patch"
Content-Disposition: attachment; 
	filename="0001-smb-client-stop-flooding-dmesg-on-failed-session-set.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m1zznmos0>
X-Attachment-Id: f_m1zznmos0

RnJvbSAyZjM0ZjVlOTY2ZjdkOTk0MThiNDJiOGM2N2NmZmJiYmRlOTQ3MDRiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXVsbyBBbGNhbnRhcmEgPHBjQG1hbmd1ZWJpdC5jb20+CkRh
dGU6IFdlZCwgMTggU2VwIDIwMjQgMDI6MDQ6MTIgLTAzMDAKU3ViamVjdDogW1BBVENIIDEvMl0g
c21iOiBjbGllbnQ6IHN0b3AgZmxvb2RpbmcgZG1lc2cgb24gZmFpbGVkIHNlc3Npb24gc2V0dXBz
CgpTdG9wIGZsb29kaW5nIGRtZXNnIG92ZXIgZmFpbGVkIHNlc3Npb24gc2V0dXBzIGFzIGtlcmJl
cm9zIHRpY2tldHMKZ2V0dGluZyBleHBpcmVkIG9yIHBhc3N3b3JkcyBiZWluZyByb3RhdGVkIGlz
IGEgdmVyeSBjb21tb24gc2NlbmFyaW8uCgpTaWduZWQtb2ZmLWJ5OiBQYXVsbyBBbGNhbnRhcmEg
KFJlZCBIYXQpIDxwY0BtYW5ndWViaXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2gg
PHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9jb25uZWN0LmMgfCAy
ICsrCiBmcy9zbWIvY2xpZW50L3NtYjJwZHUuYyB8IDQgKystLQogMiBmaWxlcyBjaGFuZ2VkLCA0
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVu
dC9jb25uZWN0LmMgYi9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYwppbmRleCAxNWQ5NGFjNDA5NWUu
LjQ4ZTg3ZjNhN2IyNCAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jb25uZWN0LmMKKysrIGIv
ZnMvc21iL2NsaWVudC9jb25uZWN0LmMKQEAgLTMzNzQsNiArMzM3NCw4IEBAIGludCBjaWZzX21v
dW50X2dldF9zZXNzaW9uKHN0cnVjdCBjaWZzX21vdW50X2N0eCAqbW50X2N0eCkKIAlzZXMgPSBj
aWZzX2dldF9zbWJfc2VzKHNlcnZlciwgY3R4KTsKIAlpZiAoSVNfRVJSKHNlcykpIHsKIAkJcmMg
PSBQVFJfRVJSKHNlcyk7CisJCWlmIChyYyA9PSAtRU5PS0VZICYmIGN0eC0+c2VjdHlwZSA9PSBL
ZXJiZXJvcykKKwkJCWNpZnNfZGJnKFZGUywgIlZlcmlmeSB1c2VyIGhhcyBhIGtyYjUgdGlja2V0
IGFuZCBrZXl1dGlscyBpcyBpbnN0YWxsZWRcbiIpOwogCQlzZXMgPSBOVUxMOwogCQlnb3RvIG91
dDsKIAl9CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYyBiL2ZzL3NtYi9jbGll
bnQvc21iMnBkdS5jCmluZGV4IGIyZjE2YTdiNjk2ZC4uNmY3ZjlhMWYwYTFmIDEwMDY0NAotLS0g
YS9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYworKysgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwpA
QCAtMTYzNiw4ICsxNjM2LDggQEAgU01CMl9hdXRoX2tlcmJlcm9zKHN0cnVjdCBTTUIyX3Nlc3Nf
ZGF0YSAqc2Vzc19kYXRhKQogCXNwbmVnb19rZXkgPSBjaWZzX2dldF9zcG5lZ29fa2V5KHNlcywg
c2VydmVyKTsKIAlpZiAoSVNfRVJSKHNwbmVnb19rZXkpKSB7CiAJCXJjID0gUFRSX0VSUihzcG5l
Z29fa2V5KTsKLQkJaWYgKHJjID09IC1FTk9LRVkpCi0JCQljaWZzX2RiZyhWRlMsICJWZXJpZnkg
dXNlciBoYXMgYSBrcmI1IHRpY2tldCBhbmQga2V5dXRpbHMgaXMgaW5zdGFsbGVkXG4iKTsKKwkJ
Y2lmc19kYmcoRllJLCAiJXM6IGNvdWxkbid0IGF1dGggd2l0aCBrZXJiZXJvczogJWRcbiIsCisJ
CQkgX19mdW5jX18sIHJjKTsKIAkJc3BuZWdvX2tleSA9IE5VTEw7CiAJCWdvdG8gb3V0OwogCX0K
LS0gCjIuNDMuMAoK
--00000000000067ba100623f040b7--
