Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9056E239085
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 22:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782945750; cv=pass; b=WaMDN/UJHqMHzd6dlUcb2DvMyLtvJOMib8MfLlbkDhNEj6SGLYcGoIYrshf7LxQ6/yWO9qylVmLJWyuh/MVj6MKz9vyvv3rbfHZpthlK6omi8zvXbFBrJ/wpjr4zeE6UbCBOOJY+cNsMxO9+yZomWZWynToK1GVPRWhvvqn/3Xk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782945750; c=relaxed/simple;
	bh=5ulagWPKnSXcY0Aj5NWGLFKQcJ0cIeFLVtqcD39xtuw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=TElH1nRAN6GEVBWWYtJxufRleDeyvVKOUeqRhQyCjFtXwyTmUOZ8Q6r5FoeMiPMGjkRru71wc82UYuifSfADaXb0R+WaXN+hzxz6vW0Vwy5MZLm7NKpY73+uBQkRNXsaXqJSAmBgEo7mOdWCp4lMB/5zitXNaPfRdExonnEmmlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oqt+tGOm; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oqt+tGOm"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c29b46382so4649361cf.3
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jul 2026 15:42:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782945748; cv=none;
        d=google.com; s=arc-20260327;
        b=piKgLDp4gp2MU5MZOsI07+/Nu9CsQhuacgayI4JSDJvZe162wyQt8USdRjHhCvBTjo
         sx/EpOS0h6+OlNtp0ZJJlEjMJBZ50jghpoM5kBKcD6nenANT+0HMoBgfQW8vr/RD2png
         6V9fjn3sxVBDqwJbVbU4QXgJDM+RJKysm9McvIxjM772d723EwWshib3+6S7GsMUxAIF
         opUEb+a7ClnsjjVEYMstgbGVFZApob7s6xp3xwlP2w7OdHRrM4AymhL/Vo5SFnMWLhv4
         yiMu1QDborV00TECnMWXVM2eWMCoSTRddhFJb0GdaQgcukAU/YIJW3o4xyzO59i29RF8
         KI8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=g+lqUzo9i3jgJnOangQYsxytw5mQJd0Q4C5JLks69Lw=;
        fh=jjSpOVz37dB/dIcd2U/fJtZLOw+C4IrokNsWMNjlpFA=;
        b=sRsdwP7K7f+TX9Gq7SKPO/Mm7/EFYZgP7R3XJJ/it5rIBm3FeEUqlWh1d4wKWs6JzZ
         y/PQs2gVIJ6i1VJiZk5VSll3+GYK5CBlmPh/PLNsV3Gcw31PLTKiFHp2e8VzBFKu3BQR
         Px94dy8h3njNj9zDZbfXRpLSlVqel6hab2s7Mezq634IH0zUX9WhMXCiZqdJBWZq3wdj
         ji7TpA2GdNO+MbsI4VMam0Xp30IaCeTufGBIM7AO0vi5XO/oo7d7DG/0vE3dI/AgLMD8
         kli/aEKrc6DsuAuan71PbHaB4YH6VkOsisk9oo7DguvD/zcRtubeFhdCTnVHQgLhkNrw
         3Z5g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782945748; x=1783550548; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g+lqUzo9i3jgJnOangQYsxytw5mQJd0Q4C5JLks69Lw=;
        b=oqt+tGOmY1jPCQbdmz3AO+esitHQ+fQwtH1YScJO+/xiZY2eYlbINBVFvKZJ+S6Eiu
         PvWnkWsJPADhwXdiUWPmcA4VUryli6Wqnm4IqCfKLyAFlqe1M3n+Vq6iNjG4KiWu0tcS
         nW/BZwTVpfH/zhBu3DOIkIsGNf6UkT3Am2m3bM/gVt9M7W17Nz08cC4cIFzZ6fwpVnZR
         bBipOz105t8NHHsaVLJD5TbOZ4RNkg51uKhptIjyrbvm1aFAr0VYC4S2zq9+0RxZEkpC
         cXdHkvfPc7RrZv3mRW50tyRX3BjneZJfbuYfRZS2uZjsqlMpTQYHhTZpKyelqlibN1bQ
         5D4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782945748; x=1783550548;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g+lqUzo9i3jgJnOangQYsxytw5mQJd0Q4C5JLks69Lw=;
        b=EgGPg0m9wJFpbGG5280dB/v/mY/49FrR61q09jcYHpklmu0Sx1aMtr0PWxVZGKUjN9
         3mroIvqYNgTwwLj9JpV6L1uiGNDan7mvsSpJLmbbu0/jTjH5ZjgbWRElb4z1XD4Flokz
         nJuFcvAteGpHGSaquEY/mFCTi0t5U6HEv1m878d9xeUWe48qGrwMsixIa7gOTdwbavJT
         eF0S1P0/rp8xUToWtQhlm6WouxcpNYK2pzQj026gdUDPhtYbSyzVRpB8wlMgQpvriygp
         NZhutKa/wbFFisVKP4vhU/7JI7nEz4zoepJpyuUMBvjU9OA1GVF4TtIfgy7q63r1HIF9
         82RA==
X-Forwarded-Encrypted: i=1; AFNElJ9Yooltn8X9KQPM18kZwDFlCvU8MR025FjAM/s28Yn2g71WmCGijINY/ntglqQxBwE6osAjsJCx2lMK@vger.kernel.org
X-Gm-Message-State: AOJu0YylRJpkxjNxS8Nkt7t59WIlnKUb1dm10qYF0b38LqldCMACmDwQ
	kyA2G3+IyRUTHUDe8+TPUgLSgM8xc73wtUtzBteq38D9CjpL8TgAD8M67woT0lV7Xm/98Qcooir
	LPiXKs+0qhqwERUEnEeV3ne56I/ejFSY=
X-Gm-Gg: AfdE7cka60BzrqLDzJsaUOJrAaPSOVtm0+ls/IZ0SA+H14wWXTAK5iuFKVF7v0Fb8p0
	4ia3SyiuRz1sV+y3FQoRvmHhhnNtwg8H6R5+a3uCRLi3Uy1lpKf4fgj5JpBCofa+PejigehkcDw
	hkzfrjcsB2r459UrJHzIPRyTnyl3zTfikwxZRJoRdKVFfWqrYok0IKC5gQAMAUUt0tAJCPbc485
	YE0D5tHJIxNNqn/lovLmq7jT/1ErODsvkclZ5t7kNsAk9CT/s5A1oh2lcwubMphwixF3pYGEYmf
	0HIu+XuhWKieSLVzVV4aIiEmNugwvrEshmpl+oH0iBCPUaKt46R8W3Pb7xyKL46LdI7E3xlucHR
	KWL4nZ2Vn82hrN19Gt7NLWXG71YoqNme3uRacAX/3fUeZjA43ZeQDlFrqvZUzig==
X-Received: by 2002:a05:622a:1e8c:b0:51c:1ec5:d00 with SMTP id
 d75a77b69052e-51c26b066admr47824451cf.44.1782945748349; Wed, 01 Jul 2026
 15:42:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 1 Jul 2026 17:41:52 -0500
X-Gm-Features: AVVi8Cf3h1-be-0otyj7uiPduzjHodUFUfcS5cP4FE6bk9RPc9uzIgAR46wmVFo
Message-ID: <CAH2r5msQ7V9juC8nh2QMA+m=MD=u6Nb62j60Xx1EEDuRdkLr3A@mail.gmail.com>
Subject: Additional SMB3.1.1 FSCTLs
To: Huiwen He <hehuiwen@kylinos.cn>
Cc: Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"

Looking at MS-FSCC, I noticed some FSCTLs we don't use in current
cifs.ko but Windows supports:
2.3.13 FSCTL_FILE_LEVEL_TRIM
2.3.29 FSCTL_GET_RETRIEVAL_POINTER_COUNT
2.3.41 FSCTL_OFFLOAD_READ Request
2.3.43 FSCTL_OFFLOAD_WRITE
2.3.55 FSCTL_QUERY_FILE_REGIONS
2.3.63 FSCTL_RECALL_FILE (maybe add an smbinfo command for this?)
2.3.87 FSCTL_SET_ZERO_ON_DEALLOCATION (maybe add an smbinfo command for this?)

Do you see any of these that we should be using in cifs.ko or userspace tools?

-- 
Thanks,

Steve
