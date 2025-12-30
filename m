Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C700327C12
	for <linux-cifs@vger.kernel.org>; Tue, 30 Dec 2025 16:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767113965; cv=none; b=nKg1l3dF+XX3CoXa2kTzeAnBkQFcxyLAYJagc+53843waGOHg4Eg7TDmdXcRE9/os1OHqCmwLPoSm+NYBE6BEJVUiFc0EgRz604KkBe1Cr1BclYVrGcGrZlDIDbL3fKUnH34T/EvyZwppBHGj/co6Iw0xA61UyLoqKH6KkNw2uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767113965; c=relaxed/simple;
	bh=5woCp2LWdf8IOxJYnoaq7xPPHGqflFJSYPZw+w0CI/k=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=aGtOEN59IUZW+S7aS2TP3+jaTOHa9jARcWvzaLXCb97WBKgBcHw4/j+TbXE1xDgvCsagaCs/9sJKwoNRMIOQs0Xe/9kzEvwisdU5mSFc4Lcfos2tuXo2zfJ/vTQpDQu+qYR0xKvknobSFX8jYvENiCkiqlS3vqCIUdCJ4Br7FVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=USVoo/RZ; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="USVoo/RZ"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8b31a665ba5so1126367985a.2
        for <linux-cifs@vger.kernel.org>; Tue, 30 Dec 2025 08:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767113961; x=1767718761; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YzkgLgT+5zazTXceqcCwS8eR2Df8LtqOkwkS5eUSVRw=;
        b=USVoo/RZ5sQbAKwEXmt48NVlh/Plqp3DflryeWQWZq2FGrYSoRNpbUH3qYdpuTkWOe
         txoqmzjBpftp8ke77XvJ4tnND3mF+RMoPTm/dT7gbeypqu6NPsOubgl70XaPlb9N9zHO
         0V5nhsViVRGppDw7M35SVkq/mjl8GQJ08AhVATV1bj9R9sVr6TP1POVjzNEqlfuBqGWM
         h7UY/kwTPndvtNrSwWETx+n4Q3D0AZ2F1mBbuEMx2P4Zk9lifKHWW/OWTMDIviA0XOB7
         OGl0HdixS23XblmGV3fhcp9xBpyD4i1LCsco45kL3pfpq0SUmpROJ2bhBKrnJZzJl0Hd
         20ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767113961; x=1767718761;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YzkgLgT+5zazTXceqcCwS8eR2Df8LtqOkwkS5eUSVRw=;
        b=i9DPFBnr121xkHwxWk8lcPJxPYS2bYNCoDmRyhQ+ZbMLbQDSc4XGfXnMSSU0nlh7E0
         wxeTZJUUlIvpF1JiE7ONyYUA2Tzef3GnqHK+4ODcS/dchtAiExZC4Ptc7zI7xx3QVa5z
         nZEelEVitBh0M03qgqq4283dIbMmby7HnV96UFyIkhC/DvBTgnMtGia4LWUFUcJ1THNL
         ugW0zhwUz5HfoQcUg1lms12nHf2IQdqfe2I3SaJFe/BJb5Nk0Ma9EjCQmuN4l6O5NxTH
         X3NpjsrVN9O8mW8yl2T4OFEQ/V+zzi7kQv3EUwZbwQ5C7wyGC5I3ZQjHOGfmomEyfFRb
         TKBw==
X-Gm-Message-State: AOJu0Yyb8novVfYUlbbV8DAyYNJOJKKqMeN8l2qafEwsdhc3xYN+Yl6T
	ZS7Igz3uGkaIBgf0btr8hXYQngLqSILIiV6G96IneLE0jAcq+TsS6PidtwXF3BPWsUij5yZYJdQ
	KAU8HKBgVwjnheAjiUiCCq5DYaX6KNRikl8l2
X-Gm-Gg: AY/fxX5BbFdHGxP3RP27c6PTGmDaAlynBwWRxFvcjE+jJyoANcPliaUdHSP5vduzmID
	kkxYqnr/lrup7oPdF8YQKJs7hFxTqoTlldUTlaQ3bUvXYNdT5l+ND4QImrKZJKbqtBZEiWxi7j3
	ShmH1FnOujnJZ44eDln6v2cnV8vjBrqrrjcW13JWz7eAh7yE5K3wgKpGslTxFBL3XZQjMIpue54
	1RX4KRkeKfqQRxp+p5N5O/8wx/2i5+fzIgDASwPooqy7s8OoyBPdhanznvD1xCz8QbCy65tRe1O
	v5Qe8bK4zlx4G81YRQ2II8XYrbPhjqQC7iZxlVR4ZbzQIi6bJWhI8YDS12/ACKBaSpmKEESIPfo
	qaYn1uAsk+/EwI+k08oZm2Q/drlsG8sNkaVM9ut2zmsFb/hahHRefQ5MN57vuiS+6
X-Google-Smtp-Source: AGHT+IFhlcMBMv1cwxoVewKSOq8HWL0IsvkGVQoXdMvZSv+168TMhMNoJ9u5DAwSztFvkI8we3gayjbRr4ZwWi4GusI=
X-Received: by 2002:a05:620a:708a:b0:8b2:ffe7:42fe with SMTP id
 af79cd13be357-8c08fbe9d54mr4697517485a.32.1767113961234; Tue, 30 Dec 2025
 08:59:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 30 Dec 2025 10:59:10 -0600
X-Gm-Features: AQt7F2qF_WkAGpxy0SpT2902G5G7ZzX1yY5RjbBgbOQXJGZjo35W5CCNpoYuP5M
Message-ID: <CAH2r5mt=iRzzb=z6_T6-_FgiFkkDUR0U__gf-YN=F8Xe0jxQbw@mail.gmail.com>
Subject: WSLv1 vs. v2 symlink format
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Do you know which versions of Windows only support the older WSLv1 format?

https://lore.kernel.org/linux-cifs/20250712161418.17696-2-pali@kernel.org/

-- 
Thanks,

Steve
