Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F8A1C2A3
	for <linux-cifs@vger.kernel.org>; Sat, 11 May 2024 17:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715448789; cv=none; b=IepFNmLMWYczTdpLtRzNNQ+X8MfFBKJ9ytRX9AGYu3HNdmyZQBTkg6bae6agOg6zDiWQ3/iw+1+YBZKgV+K0bmPR3RGmm+j54cWYLioaFIDLQW5b/bLihN4YvugQ+gR/8HuV6xYpeCdOnRjyW2QHFrt4Smrn11iywj8VAIgi1qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715448789; c=relaxed/simple;
	bh=kPJSBi28E4VtVWM8kRHKmbVszGbpwNwLS/zB/6McS6Y=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=advHQDbGkeNgTq8DBtyfz4G50mO9DjsatjpvUBTJCI4sAtsC8rHcWYAC1pPN/bxd4t4b+3RHG9F/kkjwd4Y0gvySZKmWMcDeaQnSL90vuTd4PCpM/JZ9QgBnrzzM6gR6GuHxfqOaDu3rZtSPA39BAyr7GzWUXcn3ZGIOp5vMQ1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jemm/yqw; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jemm/yqw"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-51ffff16400so5003609e87.2
        for <linux-cifs@vger.kernel.org>; Sat, 11 May 2024 10:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715448786; x=1716053586; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vIaz7c9QDtkIAUNFc0P4SuWAFEA7WptyViDGs/33wJs=;
        b=jemm/yqwBWh6dUcwrKN2gRS2/LLlwTQdfUojzVuC7dEjGS8zib9IQ4++PI3CQk+Ui4
         p8KlvEnL+3SXAKQGrfE6V1c9Q8tF1tXJZGStdSN3uJ8vZRiJ8ZuINo9aU9Ep6TEk90Vt
         kKy9rGLQkWvx3DVBM7apbkv9HgrFh7zVgUv1pgzHkoLTG2HkxBLmDBKvIeQPvOUxKAr9
         cmBPk2J6XaBrlD7OLeTijIghpCQFNcHpHx0ja4rlK1XqVcwn5PcmIsNxnyh/R0IUD2sV
         MYI78lRI62Piy0Fqv8IXoY2F6cWWgJ7rRebpjxvBn4GfNsSMUGGxeNEtQJ0CWBZARim/
         ijIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715448786; x=1716053586;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vIaz7c9QDtkIAUNFc0P4SuWAFEA7WptyViDGs/33wJs=;
        b=pfUlMbSEu5uCw0nG+2naL+Z/BnkUQx5Kyv8M4/XS9+HkuawOBiA3BI5Uf5tAyRbSGM
         0zHJD0Qcu9M1wBCk1cfvKI4BIqKGOLBZinA7098elGTjowBEUgXHHdUfF7kZr3PLAPuU
         mhk1vzBTMYI/ThpRmUV6xrUKGdCIeKqzEoN7e0grnTz0SC1zivD1KXnTjU6qTHK8wel6
         +LkpnQG097/O/Fy5q63UKBExZcIPwZKGYJ9E85dE9ip6yRI02/2O4pT7C4S8jm5xavaO
         rAAF+bqn03EV881GsDhYAuIkGPsJIFFqmwf5w8KK0pQd1Nb/hQPG2KBtEr3exNsBToN1
         XDew==
X-Forwarded-Encrypted: i=1; AJvYcCWnjHLG1WLlqQ/udm7ELxgoPnWI4X8y2y0Uv3EVxQeKXKdsFg6cGMr7wmBo3tuHRLPLag7R19DelwsniAvSMeBIuffofJmb/sr6wQ==
X-Gm-Message-State: AOJu0Yzvn+H0/aTOziL1o4TyjiOCHDLZ0X+ipeJkFRntldnzZD6Hngvf
	T0qv4AlAdYfM+RAuhGxNnosiOiYv5KwON74q5Ey5IU/ClignFnGzomjDQ2IB1/kxvPWgsPcfsGr
	5KFzWMc9NSIyblchI4jib2tFTU1uFK39I
X-Google-Smtp-Source: AGHT+IENqh9SruOCTbw+YxLcM1C0Iq6Kfm/yBxaylYk9Jdw4tzx7A/J/2WGQVfxKDeYuCcZuSOtbghg/f+H1XMA+sHs=
X-Received: by 2002:a19:ca4f:0:b0:51d:3675:6a06 with SMTP id
 2adb3069b0e04-52210474021mr4240327e87.66.1715448785571; Sat, 11 May 2024
 10:33:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 11 May 2024 12:32:54 -0500
Message-ID: <CAH2r5mtvQF92b7nUA+cs0RxoGLvL5Jj2kshahcj6Z8jTtUgaoA@mail.gmail.com>
Subject: Lots of testing progress with ksmbd
To: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Great news.  We are now regularly running almost double the number of
functional and regression tests against ksmbd (now up to 275) that we
were running last year:
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/10
  Lots of ksmbd and client fixes, and improved test configs. We also
have increased the number we run against Samba (especially with
vfs_btrfs which supports the most SMB3.1.1 features) by a lot.  Very
exciting.

-- 
Thanks,

Steve
