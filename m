Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0316E253B73
	for <linux-cifs@vger.kernel.org>; Thu, 14 Aug 2025 21:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755206689; cv=none; b=QKAyjY/Ii4SuVCmwMCM6ARMYvbLClhier/QhfSauBjJqqt/IiUHJ49ItOeM8ZRxYE7gne5Zd494Ga59tcvYXudzjC8D40dg6dboBDiZ3GBCYhVCGbHM6AXOBhcOrIGGD0jBuMV2M2Szjd972XrnhavNOVwKwbYpppo5LJXSFX1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755206689; c=relaxed/simple;
	bh=UNZ0dhDjdXCxYOELTiaUobTA3eKNfMmnrDjlWB974oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FKmRXCigvSWwxjU/ORSGk+tWEZtWJUzT0pMMDS8KDU+iADLP6MOtRvR+WwI7VAKfgct6nIKUJIPBs+b9jmvNRAOfMLuwJVQ9oRZA9d8SHnssx940vHRtnzcwqRRlN2Xxx8EZGAEJyFyitxVeRc/W897TWdjZlVD4sjzKvYtkMSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MlNFrTxO; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MlNFrTxO"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-afcb78ead12so204259166b.1
        for <linux-cifs@vger.kernel.org>; Thu, 14 Aug 2025 14:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755206686; x=1755811486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/6qZAcA33YsFmMHf2jGdno7I/KieRlxpr3C9zF0dSmI=;
        b=MlNFrTxOVtznvV3gO9dbLD+5ur389vKaheTjSYqkx7irPNg5HEo9Mijv/keXKyuC62
         w2gp24rKB93yGLQ52+lx3C6F98kECikHg3SsYgl4FfeY56ILSu62BRfVXKGkXoXsblpT
         MRnTgPxPV71fmy+yXlgayVoeydiEHW6cnOfOcDfohWnWNBinlW/St6IJPrG8/KAzZmDA
         nSv/7K4DPNeC68CioCdxaM5sj6KAcohrMX2ucTxnDrED3HAz2nsfTzpYmEyiM+VPzBCa
         1x1EUm1Be8F3Xv3LkG8xCcZ0nJB6/tvjq/M7bXI/T3BxdqSL0QUQFxcAbKQP1Brl03qD
         eCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755206686; x=1755811486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/6qZAcA33YsFmMHf2jGdno7I/KieRlxpr3C9zF0dSmI=;
        b=Ur+SejPf4za6RSrmUaZzuII+0zUebAUu+ZUFfL5kGdD1bwf/MubNFAqiBRIZACcjQY
         9ef3q+mE2ESfrW9ENIUt9m4T77d89ALEUzdLPWd5kjJ0yZQ06GEwjgstNnMFMY3jWiE8
         d3QJj8+GJ3iT0xef+QITuabxW0uSpJA+OpGF8FYK9BkA8u4faf4R7a/0rxWDlxEp601S
         bLgwdMykV6Ze2KIOPqpjKj/+gBaqxH9mpXCsf2Vjq1V1iKrhjbU1TwuOxyF+qnmKhMZ3
         4GZ/Qyo6ePKEB0MtsWuMFBlA5pOnjYfPM7tMIxMpCSztGLDQxVMNu9XgjI42Bq/Fzkhy
         XHXw==
X-Gm-Message-State: AOJu0YzngNuqLcuh6u4kj5tbf9i/D43HveJTRNAEhhVO6vZZ5GyC7SGg
	kwzdGhQnN2XVXWidNto+Z+4RTcpmvCxDWaxFJc67w5vR4UoE4HgugNh3AnNbhA==
X-Gm-Gg: ASbGncvYmqVH9/B21QqjTiMTmxg2tbSgZF/86uAro0vSuDi+S7YSlxQVhmzabR8V6+4
	JcsE3v+PHLR4kOeaBjLeL6SpxDycfIhqrUaZtO7d2zj63stLEuz+M81GDiRqYYMoiHVFjVEFxS9
	0Z6Z/ClFToh+qoJRlXRN0QNiDCMOcopJCJPq3E07n79+WKRdxMhv+IMWBwymzac7NNZXnGueES6
	KYB4pYgjFUX1A8eGkHWKEMgEe1GK68ldd7qe/gljWqxBWJFhfXtxGHGez2xaojelY7p96GOm8nY
	qMJfur+dO9iJyCNhj16QrE6gops9YSwtVFGB4qF882x1Jr+kJQlZdphd9IUeFmb50YwF6swa0ej
	j5AMyDfXi5WFuKJVL3gIxsMhVAZfd0ekEPfRO/iXwh9wTYQ==
X-Google-Smtp-Source: AGHT+IHycqfGCjGA4hDgOOOOZjB8BqIe6PvLQ7zCVyj84iIKIyBkTlehBhCVzeFPy2jdBsiHN+wxqg==
X-Received: by 2002:a17:907:9801:b0:af9:32bc:a365 with SMTP id a640c23a62f3a-afcd8d62d52mr17763666b.54.1755206685647;
        Thu, 14 Aug 2025 14:24:45 -0700 (PDT)
Received: from sunflower.zrh.bachmakov.org ([2a02:168:636c:1:2ef0:5dff:fed9:23ab])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af9215cdc53sm2612033866b.78.2025.08.14.14.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 14:24:45 -0700 (PDT)
From: Eduard Bachmakov <e.bachmakov@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: Eduard Bachmakov <e.bachmakov@gmail.com>
Subject: [PATCH] cifs-utils: Fix documentation for character remappings.
Date: Thu, 14 Aug 2025 23:22:14 +0200
Message-ID: <20250814212256.1653699-2-e.bachmakov@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current documentation swapped the relevant specs. Additionally,
elaborate on SFM a bit.

Supported by fs/cifs/cifs_unicode.c:{convert_to_sfu_char,
convert_to_sfm_char}.

Previously raised in:

  https://lore.kernel.org/linux-cifs/CADCRUiMn_2Vk3HZzU0WKu3xPgo1P-1aqDy+NjEzOz03W-HFChw@mail.gmail.com/

Signed-off-by: Eduard Bachmakov <e.bachmakov@gmail.com>
---
 mount.cifs.rst | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mount.cifs.rst b/mount.cifs.rst
index d489070..9eee7d5 100644
--- a/mount.cifs.rst
+++ b/mount.cifs.rst
@@ -307,10 +307,10 @@ rwpidforward
 
 mapchars
   Translate six of the seven reserved characters (not backslash, but
-  including the colon, question mark, pipe, asterik, greater than and
+  including the colon, question mark, pipe, asterisk, greater than and
   less than characters) to the remap range (above 0xF000), which also
   allows the CIFS client to recognize files created with such characters
-  by Windows's Services for Mac. This can also be useful when mounting to
+  by Windows's Services for Unix. This can also be useful when mounting to
   most versions of Samba (which also forbids creating and opening files
   whose names contain any of these seven characters). This has no effect
   if the server does not support Unicode on the wire. Please note that
@@ -322,7 +322,8 @@ nomapchars
 
 mapposix
   Translate reserved characters similarly to ``mapchars`` but use the
-  mapping from Microsoft "Services For Unix".
+  mapping from Microsoft "Services For Mac". This additionally remaps the
+  double quote and a trailing period or space.
 
 intr
   currently unimplemented.
-- 
2.50.1

