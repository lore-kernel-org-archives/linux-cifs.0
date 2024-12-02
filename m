Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0991D90B9
	for <linux-cifs@vger.kernel.org>; Mon,  2 Dec 2024 17:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733161944; cv=none; b=hlpSpQTg53CUsCCWFaO1OCfg8PQ0uYZdVWeL/nRtXf0Ddh2fpa6BRybZDLLBdqg9VuN78ZgeGQFwCIsTkRodZAaphgOht7MmF3vp1i52T9OGv5/HLY+MLYPxFb4KzpoVw3DAfUG8FTBFGGnralFou1+Gn03CN6hyTt256HF6fuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733161944; c=relaxed/simple;
	bh=Y6+M6N4Ri6Lm7N+iQEecNEOh7R00Sb1KLscodqMPW9I=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=ba9cHLOcKLW3hiGSE9BXK9P1uxQJzze+/JTPBqyioOxZHk7Y7yi6k22UaQ2hGcHsmR40kW451/o8Jyz2tqWFobx6ZANUxEDmzlkGZuzEjCKXdhSd5bXHCXDZkfWeNseh6EKI98ddWiblFQACJ95pg/DH/9Ul30yrjg0jVPv2OlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=diA9CROf; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="diA9CROf"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-53e0844ee50so1776348e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 02 Dec 2024 09:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733161941; x=1733766741; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BVuiv0fJfeJQD+vI9caNe+uqhSxSsMu793H9JOnr6BA=;
        b=diA9CROfCt7Z0VKpYbDasoxU05VyjAm3ZTgiNLFRzf60+CYgkva7xzYDDXbgf4+o6K
         ME7Z8zlIzhpG7ZY7ETVCxy4YWmEfS0Y9DrE2JxPKHqeAIU7pMnR0gymJaKeF0WWvpHgj
         JYrm3uUSBCF0BfoWXQgDOiNfiSeTbkicFShoZETs+pl4SIqzD7Pc3n+0Xs9IYFw3CDzM
         QnECI5W81R4jlbq2Kfzm8BthIoYpnaAKnxbZwe0a/3i/R9QZA1PJVQWawN+cUx0bAcCc
         mqqX0SxbizJNyp6sRnNiCB/nNFrheMMrqgqViSgOBsqmPopun58iMTn5hmEAJe7qnsP0
         /9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733161941; x=1733766741;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BVuiv0fJfeJQD+vI9caNe+uqhSxSsMu793H9JOnr6BA=;
        b=mVTpkGpYZn/AcWy7B5EnrukcZp6Zdlrg2rx1UYyrbjBRoWQsoWJ8RXEfUjyYjOumUu
         j9ZsgHCKN/wwNgoM0ecxgJUuCHggpmr7xL0Z4DZyc7ZzAlRrbajwEPkGCgMT0cXz8MD4
         FNta/1mMPaIjmueMiY8rvW3SF+cEm6ZUTGYcS6n2ypSmV4LgoEpZXPQW9g/i5O/1bj3Q
         LrHyshhdzzuuweBmcH63mfz/XuFsa9T/orjS7BIATsZJHg9NXJwpcD4zZegsRhVRcC/Y
         Zapup45LCZvYMJf7XPOjL/lVi9Cev+uC7ID5gS5q9ZRJ0tfRuiIxNCllhKRw1I/qnVvP
         njTA==
X-Forwarded-Encrypted: i=1; AJvYcCVH09YnRLycTSewKkBtado3xLmp+P0/6B6H9i/2sI+OBDKe+OpmrW1ZhHjCDGBTWu/guGykyT5gzwD0@vger.kernel.org
X-Gm-Message-State: AOJu0YwqAS9cGwBngblIC26JYzchGX0t8RXXa+sZYbT9QWtL+T9571PU
	6QQvtNNFeolEjSyFSd9FQ5svpP+hYhZRYNuKB8oyREz7mkNVuavumIuwBZokopaxFeHVcFwHDVV
	xBCnba8zmPE3XdKLcK7JqpvW17BI=
X-Gm-Gg: ASbGncttdK2HiLAEEM5d4IgLWFLrgpf2jLU15lcmxLXAca8gAi7P867jj4X6DyXQVsX
	DLk783M6G3vKOYlejCXJWfaMC8Mbn2BVNoHh+gAjFnYWPgtlgEkFsXePLH2yM88+6MQ==
X-Google-Smtp-Source: AGHT+IEEQaRYZBC/AJHX+nMq3zidsZt8UsIBLx5EnKNKl5O4zJWUVZ/hV/AkA5Nj5678t5PchIwdaw3rgm38fzc2xzs=
X-Received: by 2002:a05:6512:124f:b0:53a:bb9:b54a with SMTP id
 2adb3069b0e04-53df010e386mr13647279e87.48.1733161940605; Mon, 02 Dec 2024
 09:52:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 2 Dec 2024 11:52:08 -0600
Message-ID: <CAH2r5mtJ-GtVWf-U5-WMrcg92cv+pd94n+F8phztuLKpYMv9Bg@mail.gmail.com>
Subject: xfstest test
To: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I sometimes see xfstest generic/207 fail (e.g. to Azure
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/281/steps/70/logs/stdio)
but usually passes.

e.g. "write of 4096 bytes @5455872 finished, expected filesize at
least 5459968, but got 5455872"

Does anyone else see that fail? or have a better repro scenario to
narrow it down?


-- 
Thanks,

Steve
