Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327B7347C6
	for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 23:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771717567; cv=none; b=bKC1vB3ePE8dRO0X8KbwPC/STVqTksMOViWegTuWrOIrfJzik2nhAUISwYxz+gBljeAhqoRHyQTgFpxWqtxbBhnaAy9W3dSxlBzaXYIT9/bO6fyP/1NpYtA0yFqoXy1TlCbmcRanuJ2/wSQALBVUVGo66gFK48aWbpuO7IIfJ/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771717567; c=relaxed/simple;
	bh=D8wEA4P1R/wLC0WQ2gaxmvJV8Zid0j4uMfM8HtVxkhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Txbe4BPIYiY4rEd06Io32cWgN/EVyCaGGpD2ehqwM4f2y2YBg7Etaw19yfLUeBIEkABybdgRNGURiHEwupLsNkUZ7liTPQih9sXzlRfs2/gGjFBFVLQ9xhCtxsFwhOkn2KMP4/bxuz05/9O+yH7moQkERCW7OsyK6kSDz96SDg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hxWuCmMl; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hxWuCmMl"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4836f4cbe0bso24009385e9.3
        for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 15:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771717564; x=1772322364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a6c+2c5A4IdcQR95bgfQZwtsMpRnSCzmv5kOunEAmnw=;
        b=hxWuCmMlxuj3d20al60XWs0jh2KLvmk0/jpM7jG8sjLtUj+ARfwmScdZLER6DpfOAs
         J8nWVO9IM04A+Qm71FNtsxpTM5ftoWYuG5CoE6iS+dCZ9RSZYYoP+pmhOyAgz70sC2iv
         LDvuveFZpQZy2/IC/wLc5I7ZkcufMPCm48xDHV18rMz3EllbndGCICEYY+zKzP925M1P
         L1j7TU5F2mxburUB6vGNMZfdQFHuZXWbh2ZEHD6D3l3MvO7SPXGiDAny7QDzYV1siVBQ
         FXjjbYA1cLCF3c7I92iQNDo0U9X7Emu0pfWIOGTBeLkAV5YK+VPmQv02ynK/DYnajvGz
         T9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771717564; x=1772322364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a6c+2c5A4IdcQR95bgfQZwtsMpRnSCzmv5kOunEAmnw=;
        b=ZFQS1kGRxlF/3bKEZottstrxzVPQt2RKjaGPbzN1ZY6SUk+eF4Uj//EN2A2eAs6G40
         qEGLhDCxNQOqwI3c+DZOLJiwGBkoTj8Yv/YYBFUJH8GHcRDb7AuVUHklIs0vW+PvE90X
         Iqqp+gJI8Z8hhhTU2H1MmH+gacKe4DADqNIgU6YTw8xqEoSOo+wBj3xP7J05/stZiCP+
         VCz6Tb6wf+K+kLTUVqlkl+0In65szW32dyd+e2slADeVDv9Wd7fVFnuLAdXbWYGW/O7d
         T2QKIGv+ZCeRihQyk4qCUBujw38zb8QIqy+05N8GOYyO4ck28yaCFF5k0fb45nr+7twG
         nKiw==
X-Forwarded-Encrypted: i=1; AJvYcCXveU5KaFCx5Z5mrD2PJkHaSJq0lxb5/bNt1B+c/OHwj0NOEXzWklLMprgSINWg4178iqEFy4OUIp5S@vger.kernel.org
X-Gm-Message-State: AOJu0YwJS03wBqR+KImtw3FQUUCkJpTXRzjHU5QL5O6KmD9adeewVNz8
	gmmkk4GFG7E14xV17uFka5qeX+YMMJyx6g6bT7Dmy0SJr3KMIgnag8U2
X-Gm-Gg: AZuq6aIPudwZ4d0EZMYt7uscsqfFGFbGC8alToVt2C1aCcrrFxNi4rPa1nLao928Jos
	XcgowaduDzMMr8ffQ4Uctc1nw1gpK8MnMtUAAdOJj/EzDVT5V6Np31hqWY0QGQdHFWHtZ3QQVmh
	Vii1AxbzdvEXiDcixARIh2gvmc7K2IqeCPBi2qLU4UXzbZABlLp1RwtZzLVRjf3azVpnGb3YZR1
	zRDYILtmWq4F073bJy/nmwisJ1gjX8/SinlFw2hoAUNypbpi89hBVUhXWoMSwYMFxfJzfY2RxzX
	CJYUdqIWK6XYlP3JZqaFq1UUbpF+zCSzV8aMcvIr7l5P+dAiZrf909pTO5z1KmG4Zhe4K5Cn24l
	pSG9yvSi/bc3rJcLpPzUyYTzRkCnZKm1daJkStf2gHIIpgM2hIyauzgJJ7I7KSJ3RKCFOA1aQnO
	JQhKx6txnBMQJt/hnI3fQVYfaeO7TGvA==
X-Received: by 2002:a05:600c:4749:b0:480:69b6:dfed with SMTP id 5b1f17b1804b1-483a95e5ab8mr72338125e9.24.1771717564334;
        Sat, 21 Feb 2026 15:46:04 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-483a31c56d8sm251620925e9.8.2026.02.21.15.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Feb 2026 15:46:03 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: dorjoychy111@gmail.com
Cc: ceph-devel@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	v9fs@lists.linux.dev
Subject: Re: [PATCH v4 0/4] OPENAT2_REGULAR flag support in openat2
Date: Sun, 22 Feb 2026 02:45:53 +0300
Message-ID: <20260221234553.2024832-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAFfO_h7TJbB_170eoeobuanDKa2A+64o7-sb5Mpk3ts1oVUHtg@mail.gmail.com>
References: <CAFfO_h7TJbB_170eoeobuanDKa2A+64o7-sb5Mpk3ts1oVUHtg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dorjoy Chowdhury <dorjoychy111@gmail.com>:
> I am not sure if my patch series made it properly to the mailing
> lists. https://lore.kernel.org/linux-fsdevel/  is showing a broken
> series, only the 2/4, 3/4, 4/4 and I don't see cover-letter or 1/4.
> The patch series does have a big cc list (what I got from
> get_maintainers.pl excluding commit-signers) and I used git send-email
> to send to everyone. It's also showing properly in my gmail inbox. Is
> it just the website that's not showing it properly? Should I prune the
> cc list and resend? is there any limitations to sending patches to
> mailing lists with many cc-s via gmail?

I see all 5 emails on
https://lore.kernel.org/linux-fsdevel/CAFfO_h7TJbB_170eoeobuanDKa2A+64o7-sb5Mpk3ts1oVUHtg@mail.gmail.com/T/#t .

So this was some temporary problem on lore.kernel.org .

Sometimes gmail indeed rejects mails if you try to send too many emails
to too many people. So I suggest adding "--batch-size=1 --relogin-delay=20"
to your send-email invocation. I hope this will make probability of
rejection by gmail less. I usually add these flags.

If you still expirence some problems with gmail, then you may apply
for linux.dev email (go to linux.dev). They are free for Linux contributors.

-- 
Askar Safin
