Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B08278168
	for <linux-cifs@vger.kernel.org>; Wed,  9 Apr 2025 18:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744224013; cv=none; b=PLF3m9JiS05Y6icQF9843fuQZTqT2k/lJltEFQjErKQ03jxCG/qyROgRHeD7eudK7B4GvSSsDsCn8cyZ427o/HxfaiOg/Nq87d5UoWkugjDTXEGoFMQFTo9g/NkvqBVNKBhWFLH+TkQCDRCFRzGQI6GWMa05sanML+kYgzDIW8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744224013; c=relaxed/simple;
	bh=R7l0SpBcy4XnQ/hRffRo8HjUJr8bwN57rkNAkjQMcHE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=DSgLbbc4WmuZqi/Li0l1630sxNFjEEaoU3+2A8VLIjiebUIOiAIwOH6Mbz1waONzyJk5nJo9wQoqZwpgTABzLPA9fFpBpt2DJoimszERd/4ysrontNHnxssmqGTfMYT6/kdf1pHEj7dxvHSFVmf0XbWB0WpSs9StLgpfQxXX1O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jL/PhEQC; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jL/PhEQC"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-549946c5346so10538e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 09 Apr 2025 11:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744224010; x=1744828810; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5CNaYcyBFzucDc9+h/95El2RYapefub1S9h5tvFpD8A=;
        b=jL/PhEQC2nhhUG57IsPoa4waaz2PhbvAPi5KNyE0gkrBRHGz1xbSQNHpDItj322ieY
         XdFULy47+Inwu4inqvwIhVC9/PgjB6iKblqO41MLXmJ1/XnsjLXbCMidosMAdA3fG7Im
         hKQ9IYwCChdRP07m/yifr2xbve+TYaBIVmTxbpIn7u5PCytHuGl/8Xf8bs5XgPVmOn4E
         XJGmU19rOSjuM7gTXotfPonEhw0vaai0T8YsFT1ejieAwC449HYQYK38MNHXH8vCeiCw
         rXhO5Ji+4eFiJYSdwTJnDCx0Co5AL/OisyAl8wB9Vucz2MtaPh6VDT5Npab6ODY+jXnh
         VX4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744224010; x=1744828810;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5CNaYcyBFzucDc9+h/95El2RYapefub1S9h5tvFpD8A=;
        b=J80GUfoFWRCSXXmZXjsrhm4CdEbBf51HolCt26pBrqek8StuNEMI3j0UH6zZBDrThE
         79suZb9Z4Gj3l2ObG182hYrsmxIJ45Q8oOPhHvtTlfQF6qPlA0V8N15ow3K+jqXeA1V4
         uhakXREk3eCCRaoQyZU8Efm1jOjFTI7QCluF/nLeOJ6xGF8IAu+bPEktUdmYh9rW8CO8
         Hi6RcuqGjZKzh3NXidWaMVNJiA+U9s9Dw9nDnxxN+BcWNh20GZwnNMEm5l9TTPPuwtGS
         AEVOUzTcJ1v+cdbTfmFxhyftAjUdTB0tSK3gc++qE9mHE3wYyIdAWcd7EhyfA6VvcV7Z
         fFpw==
X-Gm-Message-State: AOJu0YygF7IJY/xH4K2rZuAfGXm3Mc1gyW+UEZWJlOUtfGdXoqKHQJi6
	+Z3OA794/H73jQXnAKslTKnG+aZnMRzoYAyBUNIz+mJC9Hr1KJRYrirJvxyg1/UkITxx1CIli1m
	lGcEs8KlO3fy+CltsYFTfeMGlwmE=
X-Gm-Gg: ASbGncuh1dvEJ4WRkSO6IEEen17W8tSkSaHyiVHraqLyyFOycqZD+kWYjBxycg/Xmd8
	FqNVyx2up8lDi6jKhDbDFbDr0UHRoGT6ADtsJttKddetJjqvIvZ8Bjo8lQdVGaRcvMk9RzT4Nry
	YLQ4D4kD9tKQZRUPnFoFYF5lpmipzH9JxJq5wbuzzJwu4ZCEaf1eifkKk=
X-Google-Smtp-Source: AGHT+IF8LzmPUZFg1UEwqcmMIGcnpYMAfICfc5tmsDL0mWQ0ea/4xAX7FZdFJr4n/fKNz7xQkhRuzZxAHorUl+7CQak=
X-Received: by 2002:a05:6512:39cf:b0:54b:102b:af64 with SMTP id
 2adb3069b0e04-54caf5ac501mr10795e87.14.1744224009977; Wed, 09 Apr 2025
 11:40:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 9 Apr 2025 13:39:58 -0500
X-Gm-Features: ATxdqUHI8UZLvp3xOxnNQ3PFf9msXbB-55zeMzd2KFlpg2hEt1wCEY-FAzc9CSA
Message-ID: <CAH2r5msKV9ChZr6-2tQ3ZLSmS9D5s1SiOWGfbhCnVPMEKoDf_Q@mail.gmail.com>
Subject: Re: [PATCH 03/25] cifs: Add support for SMB1 Session Setup NTLMSSP
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000008625eb06325ccce8"

--0000000000008625eb06325ccce8
Content-Type: text/plain; charset="UTF-8"

Pali,
Have you been able to verify this (your patch, attached) to any
(presumably ancient?) server that actually wouldn't support Unicode
and would support NTLMSSP? or was this only emulated by turning off
Unicode (and if so which servers did you test it against?)




-- 
Thanks,

Steve

--0000000000008625eb06325ccce8
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0003-cifs-Add-support-for-SMB1-Session-Setup-NTLMSSP-Requ.patch"
Content-Disposition: attachment; 
	filename="0003-cifs-Add-support-for-SMB1-Session-Setup-NTLMSSP-Requ.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m9a9x5d00>
X-Attachment-Id: f_m9a9x5d00

RnJvbSAxZDc4OWYwODQzMDc1Mzk1OTQ1YWEzMDUyOGZiMTdkNmM1MTdkMDU0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UGFsaT0yMFJvaD1DMz1BMXI/PSA8cGFsaUBr
ZXJuZWwub3JnPgpEYXRlOiBTdW4sIDYgT2N0IDIwMjQgMTk6MjQ6MjkgKzAyMDAKU3ViamVjdDog
W1BBVENIIDAzLzI1XSBjaWZzOiBBZGQgc3VwcG9ydCBmb3IgU01CMSBTZXNzaW9uIFNldHVwIE5U
TE1TU1AKIFJlcXVlc3QgaW4gbm9uLVVOSUNPREUgbW9kZQpNSU1FLVZlcnNpb246IDEuMApDb250
ZW50LVR5cGU6IHRleHQvcGxhaW47IGNoYXJzZXQ9VVRGLTgKQ29udGVudC1UcmFuc2Zlci1FbmNv
ZGluZzogOGJpdAoKU01CMSBTZXNzaW9uIFNldHVwIE5UTE1TU1AgUmVxdWVzdCBpbiBub24tVU5J
Q09ERSBtb2RlIGlzIHNpbWlsYXIgdG8KVU5JQ09ERSBtb2RlLCBqdXN0IHN0cmluZ3MgYXJlIGVu
Y29kZWQgaW4gQVNDSUkgYW5kIG5vdCBpbiBVVEYtMTYuCgpXaXRoIHRoaXMgY2hhbmdlIGl0IGlz
IHBvc3NpYmxlIHRvIHNldHVwIFNNQjEgc2Vzc2lvbiB3aXRoIE5UTE0KYXV0aGVudGljYXRpb24g
aW4gbm9uLVVOSUNPREUgbW9kZSB3aXRoIFdpbmRvd3MgU01CIHNlcnZlci4KClNpZ25lZC1vZmYt
Ynk6IFBhbGkgUm9ow6FyIDxwYWxpQGtlcm5lbC5vcmc+Ci0tLQogZnMvc21iL2NsaWVudC9zZXNz
LmMgfCAyMCArKysrKysrKysrLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlv
bnMoKyksIDEwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc2Vzcy5j
IGIvZnMvc21iL2NsaWVudC9zZXNzLmMKaW5kZXggYjNmYTllZTI2OTEyLi4wZjUxZDEzNmNmMjMg
MTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc2Vzcy5jCisrKyBiL2ZzL3NtYi9jbGllbnQvc2Vz
cy5jCkBAIC0xNjg0LDIyICsxNjg0LDIyIEBAIF9zZXNzX2F1dGhfcmF3bnRsbXNzcF9hc3NlbWJs
ZV9yZXEoc3RydWN0IHNlc3NfZGF0YSAqc2Vzc19kYXRhKQogCXBTTUIgPSAoU0VTU0lPTl9TRVRV
UF9BTkRYICopc2Vzc19kYXRhLT5pb3ZbMF0uaW92X2Jhc2U7CiAKIAljYXBhYmlsaXRpZXMgPSBj
aWZzX3NzZXR1cF9oZHIoc2VzLCBzZXJ2ZXIsIHBTTUIpOwotCWlmICgocFNNQi0+cmVxLmhkci5G
bGFnczIgJiBTTUJGTEcyX1VOSUNPREUpID09IDApIHsKLQkJY2lmc19kYmcoVkZTLCAiTlRMTVNT
UCByZXF1aXJlcyBVbmljb2RlIHN1cHBvcnRcbiIpOwotCQlyZXR1cm4gLUVOT1NZUzsKLQl9Ci0K
IAlwU01CLT5yZXEuaGRyLkZsYWdzMiB8PSBTTUJGTEcyX0VYVF9TRUM7CiAJY2FwYWJpbGl0aWVz
IHw9IENBUF9FWFRFTkRFRF9TRUNVUklUWTsKIAlwU01CLT5yZXEuQ2FwYWJpbGl0aWVzIHw9IGNw
dV90b19sZTMyKGNhcGFiaWxpdGllcyk7CiAKIAliY2NfcHRyID0gc2Vzc19kYXRhLT5pb3ZbMl0u
aW92X2Jhc2U7Ci0JLyogdW5pY29kZSBzdHJpbmdzIG11c3QgYmUgd29yZCBhbGlnbmVkICovCi0J
aWYgKCFJU19BTElHTkVEKHNlc3NfZGF0YS0+aW92WzBdLmlvdl9sZW4gKyBzZXNzX2RhdGEtPmlv
dlsxXS5pb3ZfbGVuLCAyKSkgewotCQkqYmNjX3B0ciA9IDA7Ci0JCWJjY19wdHIrKzsKKworCWlm
IChwU01CLT5yZXEuaGRyLkZsYWdzMiAmIFNNQkZMRzJfVU5JQ09ERSkgeworCQkvKiB1bmljb2Rl
IHN0cmluZ3MgbXVzdCBiZSB3b3JkIGFsaWduZWQgKi8KKwkJaWYgKCFJU19BTElHTkVEKHNlc3Nf
ZGF0YS0+aW92WzBdLmlvdl9sZW4gKyBzZXNzX2RhdGEtPmlvdlsxXS5pb3ZfbGVuLCAyKSkgewor
CQkJKmJjY19wdHIgPSAwOworCQkJYmNjX3B0cisrOworCQl9CisJCXVuaWNvZGVfb3NsbV9zdHJp
bmdzKCZiY2NfcHRyLCBzZXNzX2RhdGEtPm5sc19jcCk7CisJfSBlbHNlIHsKKwkJYXNjaWlfb3Ns
bV9zdHJpbmdzKCZiY2NfcHRyLCBzZXNzX2RhdGEtPm5sc19jcCk7CiAJfQotCXVuaWNvZGVfb3Ns
bV9zdHJpbmdzKCZiY2NfcHRyLCBzZXNzX2RhdGEtPm5sc19jcCk7CiAKIAlzZXNzX2RhdGEtPmlv
dlsyXS5pb3ZfbGVuID0gKGxvbmcpIGJjY19wdHIgLQogCQkJCQkobG9uZykgc2Vzc19kYXRhLT5p
b3ZbMl0uaW92X2Jhc2U7Ci0tIAoyLjQzLjAKCg==
--0000000000008625eb06325ccce8--
