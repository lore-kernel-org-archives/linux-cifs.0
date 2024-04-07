Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4003663A9
	for <linux-cifs@vger.kernel.org>; Sun,  7 Apr 2024 04:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712463928; cv=none; b=jRSdgLbPlUEvg9TnElbX+z+TzFfv0QfjZgIDWGkIyFyYfmr4TGaqgJlZk1hoSDzlWKD+qx9cIxLD1yWuJw6FFmhhQ4+COZCL0dtI4zzNsi57DpWFE+dSGL4tN9nVYguqKA7Txi1R16V82KLt8wyBwFFGdhuboKPux/6k3N3om6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712463928; c=relaxed/simple;
	bh=fR0QOO6czCiCPHL7pe9CqGO0fk75QPOlD9OzZbubsPI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=IZ5nFAO6tC3XPI+oDCqqqE8GFQhUxzbee9XKoCJGQZvNATyGwHVDzGwQEI/k5jgdtuNTWu9neR5zDJjm3ig0KDsshisrRoiIhrJqI+BAy2XJ0IrmXdkP/mx9IC/iiYG38hvwZcYwtYQVOUKhJeDlT0FVs5zqwUGzJO1bDDx5B5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hNXLQtmm; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hNXLQtmm"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-516d3776334so2898125e87.1
        for <linux-cifs@vger.kernel.org>; Sat, 06 Apr 2024 21:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712463925; x=1713068725; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5cptaQLMgkVEbGwtLXInv6sPWJGZ6VTRnGIaTnjxvHI=;
        b=hNXLQtmmYarv0VF1lPYBpq3ivTtyCUxemUXuN60cqDDvi7ugrQ5GvcVW855Y2zf1+e
         3V5awO2O/LJ1ZFBO/DPz85+UNCNyjo8CODow28gEcQUvvtycHpyKr2AWrK/1Fy/YB2DW
         yCBLyonhCk35WSYVXv2tsKWa1tktIIICIvgMKyKPrSVhFdCHER2QBlBWHJs6K9D6W5KF
         LeR6ZNQiJsixGkhO4yKH9iOmy51iHHu/0gnemZSMW/HgW2T0WuS4z8ZEnPcTZrnsOwZz
         xI9PAkuf/QKvs7sN11I9phMxn1yg2Axr7O4fnXrSa4d2eL/dFCt+X2qRRRO8/6jDwF4z
         DJGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712463925; x=1713068725;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5cptaQLMgkVEbGwtLXInv6sPWJGZ6VTRnGIaTnjxvHI=;
        b=uTiHgn0qh3cDe85knPhjxiRBmYZFtk8rbFZHS/oY6vs6FcvGZO93oOq1chUlKXow1p
         2TDpurameyno2S9uS4WSdvOIsTknuglzuh+/bWIO29tvxF96SIMz5R27vhCr6K8Sp+Mm
         N6vz3SApcu+oUaKPnrhTpUgm0AICTJSGWZCwTCDImWtWm2CJCP1NQXizFeWxd4VSEcgd
         v0p9Dw3OciBIapNijx+OA2CZ1ZkaQ6QAxrQWBBFGHdJiNmzPSCBwNpf7ehIOaGH+jfYa
         dT3Wu/vRRgARgL/YlRF2LptMqeuYBoTRaXw9KaTUNVoMo8Rm1Y2xJVhA7wx0ikzjKBTr
         294w==
X-Gm-Message-State: AOJu0Yw74/TCf4NgIwazOYwBu/vHUm4SMC49YHfY2cC8k7rQotDLk7I9
	u1zrgyH+LWNEzlP0b2X+E/3J2+jaOgycpQ4UZrvCBf6M+ugjuth2nvNMdeLNw0aAq0G7xc4lblS
	vnq3upwBni7J75SGdgOBF3ZLe21+5rxTGEww=
X-Google-Smtp-Source: AGHT+IG8twoRzRfnFXaUG/Kbx/YA7atV/T49RaYvTDN+WRHZML9vtC3VWkD8VfgTuw3omfrKECVdJLSslmbgbOiV1ak=
X-Received: by 2002:a05:6512:6a:b0:516:c5b0:cc12 with SMTP id
 i10-20020a056512006a00b00516c5b0cc12mr4098057lfo.14.1712463924659; Sat, 06
 Apr 2024 21:25:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 6 Apr 2024 23:25:12 -0500
Message-ID: <CAH2r5muVm6pAbZRrQ2RQddozF0=JdvMbfAJAMYnZA5wkCsUYiQ@mail.gmail.com>
Subject: 
To: CIFS <linux-cifs@vger.kernel.org>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>, 
	Ritvik Budhiraja <budhirajaritviksmb@gmail.com>
Content-Type: text/plain; charset="UTF-8"

The /proc/fs/cifs/Stats


In smb2_close_cached_fid  we were decrementing the count of open files
on server twice (e.g. for the case where we were closing cached
directories so this was more of an issue with mount to servers like
Windows that support directory leases)

    Fixes: 8e843bf38f7b ("cifs: return a single-use cfid if we did not
get a lease")

-- 
Thanks,

Steve
