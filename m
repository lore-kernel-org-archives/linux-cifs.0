Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2523A34887E
	for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 17:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963711; cv=pass; b=ijuvhyc7ifHN+YIvRL/Tbk+wu1izt0u7IRUEhUpPgiYDMo/ujW+mJUEpYSv3N5gR1OKXW1RspAABG3fpARRwjgXlw6ECUjC4J/vUtq0hbi+Rjd2e5AaZeSuTZ8gMQOUbTymLkIuYKxMyZNyYWaAZHb730yYEgmuT8xr5QvbEYKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963711; c=relaxed/simple;
	bh=TOn7OaufpVFnTCngKERiD7517EOajGuL0SqpRc86qfg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Ec3w0+gVHMev0kGZlCEfP0BQPcnznwfGGPMD6D63VI60CrDkkclSj7WV3jXSXkcjXCLykhy9q0VWJDKy1PXurKVB7Q+tRZYmvASc8Vf1uOtHIJbUn1ZoR69X/zEZsD4t3bTBqEiFZkMIgx61uUc/PAl7ZfX2fqOtR4fK8vanFxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PdF1PzMo; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PdF1PzMo"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b9e00649769so994861766b.3
        for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 10:01:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776963708; cv=none;
        d=google.com; s=arc-20240605;
        b=NcZb6TUQIG9pGI1JwzHA+V/0+xMWfziqoIVwFwtx4rS61NC0F3MefoM2A+BghJ+tKc
         joWGS2gk9pnzPRliZwULPumXR//VXrREetUoYqX2uOspB+5bECjHvfG59Bq7qCZz7nhi
         XY28HpayhTSIOidDeeGp9xnw+1t+uHlLna9EGo+AxcpaEgvhChyGtZiyLWDyl38nSesC
         sqllPukJEimer4bV6RxTEP8NmAg9/9f7aNoglaKPyrOW2SdwkS9DVP25D/JUfCVaa5K7
         lqRS4jhcrVj+9hS2XrMNdKesRnTFEbE+8VHN/ZV+Ne61vVnKsBrDpKFCiNy9jqxReMww
         G8og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=MR7Evo27Fb9n4uesCJvxrzmJyEK/vZpzgb8CmAsEAsY=;
        fh=/pAZmUPPgIMAwG+zuGCQcRUg3kDmYj/wellIzry2yRI=;
        b=C0wWCalJisBH27VIcTPgWEz2Hw+tulqGJ7rmN5UsC+H0Hl9Ulv0yeJyv0IlCROSChM
         359tMqmfCvMZmZ16tqcrIkiOA8DZcT4w7eoIpvUuU8St1Ibm3mib+fvIa2JJ19WBPm/z
         utdJFgM+vZzOtKNHocl45g5nrtQLkhOT0IaK1YVcjVSdtlc9tXLMBe2HJ117lWxpOBAd
         3p9VQkqLZzMFSrQcNb8007L/NkyNOehbWRZs2ql6MbR61IPh2iki6ho9OxvUAx4/pHIs
         23hke9FDUNiaa6pwYQ1nIV8t2BW7H/E3BOANO7p2uEVbLxmWC1IhorGRv6Tz6ivTDCj1
         xlmg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776963708; x=1777568508; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MR7Evo27Fb9n4uesCJvxrzmJyEK/vZpzgb8CmAsEAsY=;
        b=PdF1PzMohNRn0isPMagJx9rrY/oepjF5joKh5Zol1v/7Yubwk47gLSdZK0Czm6GULO
         pLOn93YoBenCX+K400L9WTJ53d+HxTuc2zm630KfpLiFwYOMezczStPEksFaCE1z6aPO
         GSuvd0fJn7TY+bBUZBpFtRejchDJ3gRmkd8Gnsg+r3bVQIMQ3Wqt7WXENsUD8fLck773
         85AWE9chzIs/auTrxMNobZEYiWW+7jy9Tm+sjp3d7LyCr2FSYzJtXATEdG1iFBqlX4O/
         gE06LdyvSzfexIcQqrIw98lxjq1LHNVsO4bWGfVjfEvuhmQ5LYdLUoy8fgFJg1tuF7/3
         bWZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776963708; x=1777568508;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MR7Evo27Fb9n4uesCJvxrzmJyEK/vZpzgb8CmAsEAsY=;
        b=qNpBOf5bsuE65cgmrAkqZFPWPRmYf0Dss9IxIGYyLmueC0HOGdw5PurAXGD6e5Utap
         4XfapHA/zSXsvcvPgNvWf84cYCP+ogRrmu7baspndIuDBe1dW1862j7OM7Aa962zryB0
         CZ1+kbAM5UWi0ONgbamz2nWE1Diygj4kLNTCSMprFhbVAJFcn0epgn5zf7M0yWnw9dGJ
         RGqTHBhRprV5D6XBPmFM0Yl6u32KfHzEn8SWjoGcRhPd+ALxxjOOBRFlcszTET9faDdH
         cju4g3umsbcCxCRRywoWCJkBMUvAP77vZZL7vvZGGBuxLV28miqK3n26I5Poa52gz4PX
         jHrQ==
X-Forwarded-Encrypted: i=1; AFNElJ96nXi4LPG6TRV+fLvmADLRQICGD8sWi9OqeISVz5t5BIUtptxqc2YAMA7GE74pKbL4UCOnjr+0il5n@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi4sUeHChUgOEjaI95hwSpcew1RaqIqUkMhw4RSabiDKwcy8Nz
	6aM5CU6XwOBeft9H5tCOLB4iK4vkixL0hXMBAkk9AsXpM19n3xHNvCKXDB1aBSLr265SfSMrTIt
	71wNbd+El7viM2fNVk/EBxC3WcHoTpHc1ZQ==
X-Gm-Gg: AeBDiet9SM1YTfk5Xdx3Ch2gGp5PmgvuoTk3CnyxcD8+y99+qzRx/DQquH4gRoW6pM3
	PVsTA3z1f4A6PKSV3OaFLJ4T0hvpjrcB94O3ABZ9R3tu9JExfBw7JAFNx/tDHcIwX86Kankt+5s
	j07qckol9dLfGqH00VKh+oytBaX+BJkpzEwnwNgFh17sNmW8ddkL5KwYRkkHUfrEWwrLnj4C1vg
	XsJsRz5YJYsSPHi2w1nrCanuDEXn2PUmslYBSzDw44KSIb6zkU8rE6Edp3Fm6ARBNz1jfBtN3Bj
	PPWCUat3jpSBg3oZ
X-Received: by 2002:a17:907:da7:b0:ba6:4e0f:e396 with SMTP id
 a640c23a62f3a-ba64e0fe8fdmr1021131966b.12.1776963708142; Thu, 23 Apr 2026
 10:01:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 23 Apr 2026 22:31:37 +0530
X-Gm-Features: AQROBzAXKGkL4wCrc7a7jqx_RwqEbMziZZLN-r7g3-kQL0OMGl7pH-QpRiQgpWw
Message-ID: <CANT5p=oV8kcE6hXPoUVQAYGaiz+2OERoSRLAS6X+q9KJ_8w8YQ@mail.gmail.com>
Subject: "Intent" of VFS lookups
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

Wanted to understand if this is a problem for other filesystems or if
it is specific to SMB protocol?
SMB2+ protocol mandate that open call specifies if the file being
opened is a directory or not (regular file).

This means that during the VFS lookup callback, fs/smb/client needs to
first try open as one type, check the return status and then possibly
do the open as the other type.

From SMB client POV, it would have been good to know from VFS lookup
callback if the current dentry is intended to be a leaf or not. This
would enable the SMB client to decide which type of open to make
first.

Or if there is a clever hack that I'm missing here, I'm open to ideas.

-- 
Regards,
Shyam
