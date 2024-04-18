Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A2D184115
	for <linux-cifs@vger.kernel.org>; Thu, 18 Apr 2024 20:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713471682; cv=none; b=UoMqOOmaEn6rj+zyN+Zaz8SFoqzmnUI4wTRpDsRK/rqq9UAMp3TEI7esuoI65b5V7CsVaDximLiPOSIx8qiTw8BBe/qVl0SSzUhdpqSCwNvSssohJpUQrk/jshXEdRZ5ivO/y+xhhBJ5mO2jW1lbFsLRehjIFpA75Et7U4ySOBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713471682; c=relaxed/simple;
	bh=LR5/x3DQOfKhRX+dKJ0P9gyaH5d8U+8AMDojt6Qv+UY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=DbfkUa+uL42vteMRYWB3kO2Zp12xKa/9JYw3eF55aJsGJerhYeG1bpJnOJDytWg/FE9OjkkpI3LmX/3U9mQzOXY3wQC6xxiDC5/tVkDkvyJcBUjmdD0sT6oQCI6mHxKhiqKjNAHI79nu4CePaT3ybyTOdkXMHZJmuxXnvSY96t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S5XnwFNf; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S5XnwFNf"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5196fe87775so1340875e87.3
        for <linux-cifs@vger.kernel.org>; Thu, 18 Apr 2024 13:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713471679; x=1714076479; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vjr23Z53w969AUhAblrzf+t0LGa6uC2BR9O7rxvFrVM=;
        b=S5XnwFNfzdQt7lDYmAZslMWY4P6GKg7+weTOg6AaGa8y2FyOFO3qfZsrdKVZFSo5+y
         4GNznyrw6RulWgrwUtmHgF9sndaCKzX8xyG4C8/nevAvVOyrIZLV78eOHEg2gccwPSJb
         eDGoPyH+roAE4BO4Lb0edwUuU5/BeMQsYVp/FSptJFqwwvMeJZWaWCZudasIKBliTUPh
         zARpsZYdod2fNiPOLviqMdTtJmUKB+pmI1Ph5fvbVwQvVzxk8/f76bW/LTa2ALtf8f36
         kiDlfzX/pjzWMHL3edEUs0P4HBxW7s5uHV05HsbHAf1M7c+OPPV4hRSydQW/SqJx9Net
         Ofzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713471679; x=1714076479;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vjr23Z53w969AUhAblrzf+t0LGa6uC2BR9O7rxvFrVM=;
        b=v3XfXUhcgBXwt+GsAjY0ddw2vOsdNXNrOgFzwqik+O66dGueVKurWomO3e+tupIwnA
         UrzFtxg8mqAIr/ASssoboqeS1Szwxk+jfWPSubIa3gMBeBTxQRQaGM3mW6/wfwDsAIiQ
         rQ+UgUse5w35DFyL4jh3/C0q6l4+bWgid9n/Mlqoc7xu433JWk7JUJhY/RIMrFMfDI6z
         FqYOFT+quxXGvQsf4KAUyCxnuZGh6ndo+jl6S9k4Okj3CYQw9NASR1iC16L7X+ltvTcc
         7WTBbKDEJ9KLL5IMWRO+XkniqDwKR5E7Z49C5yAuNiV3qUDWe9e+eNRxsX4dE1CD6GO3
         IumA==
X-Forwarded-Encrypted: i=1; AJvYcCXG5Sp4XB4X9kO1mDOLlZDdc0rdul1Lz7xTQTi1BqN7RpMO3JhO9sCm6TJ9IB60rDOayR3qZgap9QJdQXNoxuF+8IkkCQOM6VzneA==
X-Gm-Message-State: AOJu0Ywi4y7grkfaKb3AMVBsrxvASLmz1N2tUsJV1yMZs1T4q/+nXoDd
	6EKlvF0AGoFAaI5c9jDl2+91uezCuwxXnZdFySZx+r9hlnSdz6v1FqQl/TiMEFt8s1u4zeNpshx
	3cO8kfAZ1KrabZxPWBQ/NO3inSQ+79NKG
X-Google-Smtp-Source: AGHT+IE9sYOveWLhfEBtHB++ePCrCeDMXzV+t2nTAO0CXzN2nn9QW5X0bOZIy7TTBIB1ldDDdH3kxB+nMZQf5eKv+EA=
X-Received: by 2002:ac2:5381:0:b0:519:730:b399 with SMTP id
 g1-20020ac25381000000b005190730b399mr84137lfh.9.1713471678809; Thu, 18 Apr
 2024 13:21:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 18 Apr 2024 15:21:08 -0500
Message-ID: <CAH2r5mstDacz=gvpjFQeB_nc1kBjyzTZw57tF8UNrXARXkV1rQ@mail.gmail.com>
Subject: Missing protocol features that could help Linux
To: samba-technical <samba-technical@lists.samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Was following up on a recent question about support for Linux features
that are missing that could help us pass more xfstests

Looking at the standard fstests for Linux (xfstests that are skipped
or fail for cifs.ko) to find 'features' that would help, perhaps
extending the current POSIX Extensions or adding a couple of SMB3.1.1
FSCTLs, I spotted a few obvious ones:

 1) renameat2 (RENAME_EXCHANGE) and renameat2(WHITEOUT)  2) FITRIM
support 3) trusted namespace (perhaps xattr/EA extension) 4) attr
namespace 5) deduplication 6) chattr -i 7) unshare (namespace command)
8) delayed allocation 9) dax 10) attr namespace security 11) fstrim
12) chattr +s 13) exchange range

Any thoughts on which of these which would be 'easy' for samba and/or
ksmbd server to implement (e.g. as new fsctls)?
-- 
Thanks,

Steve
