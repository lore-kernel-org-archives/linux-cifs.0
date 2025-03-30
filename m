Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A040EEB3
	for <linux-cifs@vger.kernel.org>; Sun, 30 Mar 2025 03:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743307017; cv=none; b=LG5x1RB5bmfL0T8nymwsAZmmInkWBoUCkYmMc0xOcnuvfVG8aCrAd7okXfjIO09bKGMDyN/g8yxgexw2xo9z6MO2+J0fb3ZlCFsZGJgZVSqAFsUI17KWmsQ2tXBX1Sz8b45emTj+Slfad9MkXcaPLmKVCRDOOVJd9XOJ4qNqGvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743307017; c=relaxed/simple;
	bh=M4fkZJG4qlhD/5dS3drjgygHvGR/GooI+FwuQNcvmIU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=cSQU1XISWPQngnAmB2adToYwOngzx2tnv55ex5v0KNRu0BCjjPCrW9I2WUTgb2fDhPjNc6bpdH7dAxXBOAY2oU9NrzWEq/EGYrf64VJaWII7u2fIsTVS5qfkXpgRSvC9vWlUei55nB4vYl04je9uLAhg5WIm5BuSSGqLjbGU6RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OV7FfUwj; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OV7FfUwj"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-54b10956398so1255030e87.0
        for <linux-cifs@vger.kernel.org>; Sat, 29 Mar 2025 20:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743307014; x=1743911814; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Halz6VRqZKEu/B5+zZ/KhyzO5TUN9NKPT4FilTceNAo=;
        b=OV7FfUwjew7wK8dP5iOxF8IZfp7uCpsjk9dFLMIZV6hzX6hJHPK1xRnS4UGFpxGqk3
         uifAtSbOb+6j38ulUCMHt0/ou0kaI+iUDZjT/HzUHespdoHjb5tT3iL8z6gt5ixkmiWp
         Bb6KvIpsoefazaz9QAOfpqHyLgBbyyGjnJ9iFBc3xqHw+yryMRC+EZ7GQKg5yzyQRk4U
         +mXaVYMHljW5QD8Id+Kul8F4LPpLnV3F7uUjRo6ppVgpHbXbOUaXvy25A4wqZER3esON
         rEpfJCX4YXfFfi1U46XsBpcp1IXHvxOqNUcYt2QcdYw3lVNxUMeEhNPK0L4/HSXn7BbF
         ioXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743307014; x=1743911814;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Halz6VRqZKEu/B5+zZ/KhyzO5TUN9NKPT4FilTceNAo=;
        b=sxlVe3KsGBq68hFUYAnyquHtzWtVgezyj+ExRkS10ew5qgkAi4vk4mTa4r5g5a4oKm
         HiBQ3WaVNMNFMo0O71eSWdHjuGCP4IRhGsR1zOCQfy++Wig5dyr6NZmcTZDZo6xJ/S38
         wITP8hXCd4Rav+F09GK8PFLnVuA7qE7PVdw88iMLzzVBQkoWfBbwvbs8hPO3FY6KEA9G
         F5ZOb272wK2TRLI4Hk30ZpNQVD2lMQjqUSPS4yZ2lw8WMClEMRXcwtsgyo7FULQPhhIg
         3rdk3N776KuSdGSzJLzQsLQvp9/LHGavbxidjc9vhqB/CBr7/7/4g3U2Ye7qUj4IwKaO
         U2vg==
X-Gm-Message-State: AOJu0YxyqX6SsiLAhwsxngwGDIupkYggMMsPF4ZDC8gwHqklNnbH837w
	KSIcFJe+z8xV38nbJfGxGBNfyCFjqy3tqCWhYOAYH2tjeZNQKyinnazhzJi2atKvgYFU1CEQd0X
	TI5FDc6bkrPvk32qcdOQCvHh7sTU=
X-Gm-Gg: ASbGnctiG2I5PJyUR1ZTl/17v/UTEJiO3mmqgzUC7pCy1DfL82NsA5XR7vUk74EBwH/
	IWLtBEJSBkYbDlpFsCJlvv07H/w27Zd3igSPbelhprN9opb/KZ/lv+QdsfghyDE4M/5A15Bf6JZ
	NVE3Vcrl2jfbb72nXD4Fi1nKVto7+Uui7Osdi1pbNDWusHQIcpT1JCBhpM0QFW
X-Google-Smtp-Source: AGHT+IGsQvchOL4L+bzFEpLaRovcp7/KPbV4Ni54RfHrB5KWlWqpI82Yxl1xtWIRQVzescM4kf1hu92MdmXtd0WMbcs=
X-Received: by 2002:a05:6512:618f:b0:549:8d2f:86dd with SMTP id
 2adb3069b0e04-54b0acd156dmr3044296e87.20.1743307013579; Sat, 29 Mar 2025
 20:56:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 29 Mar 2025 22:56:42 -0500
X-Gm-Features: AQ5f1JpBEBPG5llgZokYhcH2MUJxH8TIfvE2Qkj5O9m7wDFZd1NRSOcQdh2NiBQ
Message-ID: <CAH2r5muyUqkMbDxtPrb1zbQH5TKkaAc4Th-k_Dh7xATv6sEZVw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix getting DACL-only xattr system.cifs_acl and system.smb3_acl
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Pali,
I noticed that your patch "cifs: Fix getting DACL-only xattr
system.cifs_acl and system.smb3_acl" fixed generic/598 (which I run
with idsfromsid and sfu in my test environment, and was failing with
mainline) - Good job.   Am working through your large set of cifs.ko
patches, and have been able to verify more than five of them so far,
so plan to send some of them upstream ASAP, and continue to work
through the others for the remainder of the merge window.

-- 
Thanks,

Steve
