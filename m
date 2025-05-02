Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F724255F57
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 15:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746199409; cv=none; b=jX1ejzWaCbJI4sd0pDmAQtO6TxO3JPNYK9b2jwt9vXc6CsD0I5px4ICv1oYP6xjyGKUKYIGX1/2T3EhTGYoZQhCI2WzYZQkVcgTCgeCqj+WNEmdKd4rAfNveOzwe45PYWtqtO0J8szXCKaaY3wPmbgfK0Y6ff7/R78sFbr9rxLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746199409; c=relaxed/simple;
	bh=iS14L5C3OQqyBc3MEklvLNcrfrUFp9jpIG62B0vOY1o=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=nK5j/bi7vrSV5ATxMMbnB2CQ6UN0pTfSrZx76/U1A9KZWav7kB+T7GIdRR1mxy16pY1Ya66IGvQalI9Vb3beazOY2jDU0HMuMzCGpl6DlK99UO9O8rxtAHZW/OmzcF9KeUW2iheqQbZvQgKlc7/lseqTpPFNvvPpbcskiV1ZF9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LInXBq9F; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LInXBq9F"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5f624291db6so3280567a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 08:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746199405; x=1746804205; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P5cd9A3VHg7JI+OhsdG5qw4MqQOLu1cbY7d4omPpn2U=;
        b=LInXBq9FOyhp5nUZXdYreJZvFVvdJmyaqFouvsmDxBoGAGmtKbI5Ba7y9F0V1I6wzR
         u0je4NoBI77H41h+ImwRajckb0yqGqp1bBA0cZexcutM0o8npdtHRegi+Jmm0KjIQxE1
         hIC+aPFjarlzhQFQ90q1ZTAXw3ML4VBOmOl3bgw0NKcARMesv4qYY6Odqf/bUB3ECJd1
         cXNVeENBBlxJ4xEBqpML2EfxGRTeZuq2sMAmVfOHPtz7gh2QY20xY72LZ6SSw+w0EAGR
         3/a2aPLHjc5nfadMmxSJXvhiw2laCeZ+MNwPhWpuw1h/fZm8RPmOpIRDQvuaCXMJut1+
         Db2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746199405; x=1746804205;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P5cd9A3VHg7JI+OhsdG5qw4MqQOLu1cbY7d4omPpn2U=;
        b=q78Q0io3CRakjJBZ//6Zelb9AXJYZCQ1GUTKSuGEPNsE2uKsp0+eJ1ad0rOdMrhVmo
         VTv/JUeejcgf0VCs25dKTIJ1ffIG8pePOpDwamod8f4f12jmwXT9GchFq/BlgNSfbl4o
         cvvRHh8jwOfsvOueDDh5v6BNlzhUNBLC1If5iRlGAhflWfxuK0CmxcIQhtNWT/xFrP1r
         r2DUVr4JP73wgQa1tH4ZIzx/5dm/om9BYWBtAL56UzxyZyxP4UHDyLahRKzc5zCm1zWS
         wXBMyepOO94fr1jo56xBPoapwhCz4sRkZ9twPuq8rtMfe+yfxJ1nMoWNvR1lfPvNfejI
         9CVg==
X-Gm-Message-State: AOJu0YxlWwBNijniAFFIbTWBSHoR3jPxYxJec3y0/BXcFkU9Kovpol+Q
	hps7MLMeR5pFGzGo8M9p5U9oYKMKjPD2n6rBHwwjZZkzY6xMn+YyvKfccItKvd98epSfsmqucYA
	dK9Ok789cy64De4HNGPimJNkBHXXpDziulwUFXA==
X-Gm-Gg: ASbGncvMGJ/Ec8j0DIMDDaGFTX1dXpfmED7ujlGQProcZZjSuVdhL7v8qxkqNezlL2+
	BEgV7fmAWvzeL6USvBeCKsqZvKXbHa/SUvrilntenLRiMflNwyDUeWXwX/dRAd3kAPfccY3c8MQ
	ySXtdZSIStQQ9JoUu/TsNT/vw=
X-Google-Smtp-Source: AGHT+IGvGZES4UeSweu3vOg2EtEdsTTxEh7IKyzG6hyijJb51eeLShfzx03+RA9whl/Iq0QRTwguvjtRUl4Z+DLLE6g=
X-Received: by 2002:a05:6402:50d4:b0:5dc:c9ce:b01b with SMTP id
 4fb4d7f45d1cf-5fa78008ac0mr2566069a12.8.1746199405023; Fri, 02 May 2025
 08:23:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Zhixu Liu <zhixu.liu@gmail.com>
Date: Fri, 2 May 2025 23:22:47 +0800
X-Gm-Features: ATxdqUEmm4n-us4nduw4VYH7TXz0VSGqPv10hrWrMCJX4VOZZPl5-9XoZmt1j6s
Message-ID: <CALMA0xaVdk3qwkb-92QqF2+6z+=oxbBWDR1hYEoE2WUc7jVGkw@mail.gmail.com>
Subject: [PATCH] getcifsacl, setcifsacl: use <libgen.h> for basename
To: linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000003e8aa9063428bbe8"

--0000000000003e8aa9063428bbe8
Content-Type: text/plain; charset="UTF-8"

basename() is defined in <libgen.h> only in musl, while glibc defines it
in <string.h> too, which is not standard behavior.

please see attachment for the patch, thanks.
-- 
Z. Liu

--0000000000003e8aa9063428bbe8
Content-Type: application/octet-stream; 
	name="0001-getcifsacl-setcifsacl-use-libgen.h-for-basename.patch"
Content-Disposition: attachment; 
	filename="0001-getcifsacl-setcifsacl-use-libgen.h-for-basename.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ma6xzzuf0>
X-Attachment-Id: f_ma6xzzuf0

RnJvbSBhYmQzZDlhMmQ0ZjhhNWRjNGQ5MGRhZGRjN2NmMGM2MmQ5NTRmMDNhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiAiWi4gTGl1IiA8emhpeHUubGl1QGdtYWlsLmNvbT4KRGF0ZTog
RnJpLCAyIE1heSAyMDI1IDIzOjA4OjQxICswODAwClN1YmplY3Q6IFtQQVRDSF0gZ2V0Y2lmc2Fj
bCwgc2V0Y2lmc2FjbDogdXNlIDxsaWJnZW4uaD4gZm9yIGJhc2VuYW1lCgpiYXNlbmFtZSgpIGlz
IGRlZmluZWQgaW4gPGxpYmdlbi5oPiBvbmx5IGluIG11c2wsIHdoaWxlIGdsaWJjIGRlZmluZXMg
aXQKaW4gPHN0cmluZy5oPiB0b28sIHdoaWNoIGlzIG5vdCBzdGFuZGFyZCBiZWhhdmlvci4KClNp
Z25lZC1vZmYtYnk6IFouIExpdSA8emhpeHUubGl1QGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9n
ZXRjaWZzYWNsLmMgYi9nZXRjaWZzYWNsLmMKaW5kZXggOTc0NzFlOS4uNmM2MzU2ZiAxMDA2NDQK
LS0tIGEvZ2V0Y2lmc2FjbC5jCisrKyBiL2dldGNpZnNhY2wuYwpAQCAtMzMsNiArMzMsNyBAQAog
I2luY2x1ZGUgPHN0ZGxpYi5oPgogI2luY2x1ZGUgPHN0ZGRlZi5oPgogI2luY2x1ZGUgPGVycm5v
Lmg+CisjaW5jbHVkZSA8bGliZ2VuLmg+CiAjaW5jbHVkZSA8bGltaXRzLmg+CiAjaW5jbHVkZSA8
Y3R5cGUuaD4KICNpbmNsdWRlIDxsaW51eC9saW1pdHMuaD4KZGlmZiAtLWdpdCBhL3NldGNpZnNh
Y2wuYyBiL3NldGNpZnNhY2wuYwppbmRleCBiMTk5MTE4Li4zY2I2MDNjIDEwMDY0NAotLS0gYS9z
ZXRjaWZzYWNsLmMKKysrIGIvc2V0Y2lmc2FjbC5jCkBAIC00Nyw2ICs0Nyw3IEBACiAjaW5jbHVk
ZSA8c3RkaW8uaD4KICNpbmNsdWRlIDxzdGRsaWIuaD4KICNpbmNsdWRlIDxlcnJuby5oPgorI2lu
Y2x1ZGUgPGxpYmdlbi5oPgogI2luY2x1ZGUgPGxpbWl0cy5oPgogI2luY2x1ZGUgPGN0eXBlLmg+
CiAjaW5jbHVkZSA8bGludXgvbGltaXRzLmg+Ci0tIAoyLjQ1LjIKCg==
--0000000000003e8aa9063428bbe8--
