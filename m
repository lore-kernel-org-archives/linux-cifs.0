Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989CD264A80;
	Fri, 14 Feb 2025 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739554704; cv=none; b=G9jWtBN6s5SpFGvcZ0onrWoIIuPTmr7Z9BDfzI79+RcmQz+zCOiP9yvQmZEPknzU1auppik5GFpWvUA+8z1yhUofmO+ORtcMPmfeH0mzWBaGMV0GwWvW9nC6eE2CoB/DEX3r/Zm93aITp6cPVj8BdmEXnFg3zb1BeYdTbUFqQM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739554704; c=relaxed/simple;
	bh=QPs3gUpFK4FWDMUzE0c96/LCetQlahqqneggbHHyl9g=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rOEEuneHT6QXBAdhFU0meUiuq4TSIaT7wZb1YgM5KhF5jM6jH6IcupOJYG8AxzIN+wWsmgfvqeig4KfskbhV+t3Je/Nv1q+TL4HW0ldrpIafYkI/WZkLCdwoUnrX6cNjtaAr4dLk+pPLpAq1PZEfbEWOs4Kuhj7blch4isWfexo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AjSPnsSb; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AjSPnsSb"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5451d1d56a7so2447098e87.0;
        Fri, 14 Feb 2025 09:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739554701; x=1740159501; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KBFUDI3xlZQ8GKkkFKuNnNL4ifTKfoCt6m1CciLzViQ=;
        b=AjSPnsSbQYmSmQd/a3VvcovQuPi+nX+FavmCyda1450T+IzD8jiqHgDALP5E2XCtbX
         GkorGXA7EXfwy1xgYZ2ZX9I7uPDem+ct5pwD9Vn95y6jkCq0nLxgCKn7zm+IqWcATLrm
         cqAyXAxzCNq9QysoSy4ojKCgQL9x/PMRW8K9tMyvkOvxNL7PrzJUgPZYfy1p6SruCbWz
         dImH0x6bEhAWgJZwigRj6Ox19g4P+90S5g9DfeZAmKeTAge4mpIf1nGkeLwwazLKExi0
         ZEZP2CpCZYxj5edotwJHkPkJdaXzBFV0JEV9JkFhETTqfjrMnACXu7dwTPCs2TYAbb5n
         xW/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739554701; x=1740159501;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KBFUDI3xlZQ8GKkkFKuNnNL4ifTKfoCt6m1CciLzViQ=;
        b=Bhe2mRnu+e2wpmQKRfBJUntEyNR77uiA7OLwa5ZqjCcfScIeVshYkFpOZzgqi0FBer
         JeEWnTtroHeK69/gCNJN7OLMDvs/TEPv/6iS/HNmjPbU0InxvJNvhmitvBfyLHNtrP2S
         F9TD0TZfe7vaFHvun+fPcea3kFbJuMZGR3JoC5Evd0V3foWJN6ecUd+9YfElWh8lOA/Y
         dJDChPnDaOcsWwQ0DlBW1df12DpH2MziyOgkzzDosFyPbHBugC+IYzJuVIzIayjYhRRO
         bJ7yVCO1sVNeuhzM9RH7Aarsdh04PJR7ajAnL7+KXW0Us81N9glVVrVAweTndHyofwFA
         oKwQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6yQTyMwXzFn07xE2a8sInwaL8OF3Idsp1uIukjdncYkI29OZo3rZh+IJ6S1eIZ/HSEGzzpvG/h6dz@vger.kernel.org
X-Gm-Message-State: AOJu0YwE60k+CJEpyzx4RAMBcUDd23b5dyFf9D8EZQRVinSjpCP0fQOA
	WxDOjx71yQjkkpe30q8LDjIZYvE2V0KZX8WXPyizfrUYEW/BeY8O6i/vp3DythiwZECbsMlXDdc
	ytCyFBJAnTc+emmcON358eycuZsEeImTB
X-Gm-Gg: ASbGncubNdIzpKgkvvZb3TiZ25tNPQ4RzWB5+ro9FcNod7kcXoes/Nuij17dVooxVhU
	j7y0N/T1BXH2GTSiiga0XMv99TQLlOCUtY7kfT527VOxAGRyaX/pHEiBszhzaIM7ofqPogwOtG3
	04b1QgZifiSTIuUFCKn2XZ+xFqoiXO+2k=
X-Google-Smtp-Source: AGHT+IErlXdNZY2UjkX6nT6T6lZiBSIaI+Czn+PLcvm4idY5EOhV0hA1ZMzQ5mK/HWJ2JnnbqHBYVdc9kUS5DHUWOm4=
X-Received: by 2002:a05:6512:128a:b0:545:1182:183f with SMTP id
 2adb3069b0e04-5451dfc1418mr2790297e87.4.1739554700364; Fri, 14 Feb 2025
 09:38:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 14 Feb 2025 11:38:07 -0600
X-Gm-Features: AWEUYZlBIgfs3V_pXoQk38EcHNutmpOio2VgrE0znV5zSWDZirfTgy_EY3pt4to
Message-ID: <CAH2r5mvzsA_nUYZHs4mSwU0GOOBGjKEchyjBLrCaSRf7pPyMvw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
a64dcfb451e254085a7daee5fe51bf22959d52d3:

  Linux 6.14-rc2 (2025-02-09 12:45:03 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc2-smb3-client-fixes

for you to fetch changes up to f1bf10d7e909fe898a112f5cae1e97ce34d6484d:

  cifs: pick channels for individual subrequests (2025-02-11 18:51:07 -0600)

----------------------------------------------------------------
SMB3 client multichannel fix
- fix channel allocation, especially when using larger rasize
----------------------------------------------------------------
Shyam Prasad N (1):
      cifs: pick channels for individual subrequests

 fs/smb/client/cifsglob.h | 1 -
 fs/smb/client/file.c     | 7 ++++---
 2 files changed, 4 insertions(+), 4 deletions(-)


-- 
Thanks,

Steve
