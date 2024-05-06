Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B604533D0
	for <linux-cifs@vger.kernel.org>; Mon,  6 May 2024 03:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714964896; cv=none; b=ryYhFmXwRr6R4FHKdRtVr7XMDqH4JmbFFIwM0tTc1xw2/2uaad64lj2X5Sy7uwQqw36Pxha49sKJfUOcui/jq3TgrpmkbQsgUsMR7RassAJ9iVpTsUlzZimR/2hoGXKDhkUZwabVFarD1ae2Va1owy3maprbU+DbQpSOKzqaetA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714964896; c=relaxed/simple;
	bh=PW/9Rix/CEslZLU/jenKmOucTMhC7j+xT/jGU3oV0TE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=oCuWDILizGx8c5tFinUc74kPsalk1wM3fBY6eeQt8jc1kUF/xXy1BLZwVIeKAu01LQ6sOsoLpI1yBAqHCtufIHaFXxjPn4bVyMqz5MJ+TjAKWDmLSUEL4ofC43MDo+koHfBHQ/jXFH35UsFsLQt6Y4WafFrTz10q8sSF6rBuJdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IwukNbO0; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IwukNbO0"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52006fbae67so1866797e87.0
        for <linux-cifs@vger.kernel.org>; Sun, 05 May 2024 20:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714964893; x=1715569693; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1+8amkmIHKiaRwmwfDN+f3nzAwlMMG1iFRope+EmC4I=;
        b=IwukNbO0Z8luEP13dCg64z/9Rs2NeOIEUV5g0S+ZM0QrqcLgax+P2H8jrRsw+jThrM
         lhe6ztBnC3MR24d7E+Yq43cCUyEqxwVJwdhoFkeq1XFWxznIHia9jSyByJOVBOTccppv
         AqD5W8ZUp7JzDJNYw8cX9d5OKHcYsq7r2DmQoWjxdn1exFepvRULjKBv6K9hHhQbdQQK
         LFIxLZ7az3UQNWK6WkJClKCAO57DblMFpwDR1Wa7wTsnx/4aqzxwjULinHt0Qj0sVf/6
         KmlYpnBYSuoGNxNh3arzWAxKOFq+0DLqSM+Gpn4LcOAgmKzY2idv+t0O/FVdAnkwtkMc
         bAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714964893; x=1715569693;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1+8amkmIHKiaRwmwfDN+f3nzAwlMMG1iFRope+EmC4I=;
        b=KBVOXtpG1lNAaxH+N5QrIAownWWO3EPlFQXFhTMXrWkdvMluIhVFqBLAwA4MQHFWQk
         EtUbox9+I/1DP2531m3qgLiB5sYUU6fQyMXc34ye6MEQ3yAXMl/yz9WNKboW1zqMH6l+
         8KE4uM9CEK8pLv9pQ+RQeNVUFYDOPBwjVrAlrccrmPaicr9lDG6gKu60733r7Q0QXbRy
         5SXPTyZAtyNYhwahiw8p9DlLtGvluFmjdD/QwZlx7VyerQkEQmzrltwYk4CjtB150vAT
         fxfUEwE+KDBeJ6/V5qsP/esx25y02UU8ff+SOLKh5JTNJ/RoNHbo8URluFnO79UFTUKr
         dUPw==
X-Forwarded-Encrypted: i=1; AJvYcCVdJ4YOgDhMSXyI/mn24OPD1BTrsW+yrGn7SVHvpxRbmk1fblfgh9o+KmUDi+YLqUizhGkVfbzfUMqPDZQIdTE+VV4PQsW8blYMww==
X-Gm-Message-State: AOJu0YwJI6yYYI2ktPGSd0xbiOg4Rdgi4Do1g7eDQ6s/OhyL4rHc2VRO
	o+8xV25zb+SnM9UY1Tz94gPvbidOpAiuACPCr2KG3pP9KyOmwedZHjWceyFemXM3JCcZGFEYCGq
	VqsjP2EavT8Dweki8LciDzY1jOVg=
X-Google-Smtp-Source: AGHT+IHHHi4laNgLedx6nG/eqAF99qQDOFbfIsWm/iv+K3tL8SFX1fELZtNFOg2adHfpXTPtbbGOk1frhsH6ZzFiSfk=
X-Received: by 2002:ac2:511b:0:b0:51c:c7d:7f0f with SMTP id
 q27-20020ac2511b000000b0051c0c7d7f0fmr4829727lfb.67.1714964892537; Sun, 05
 May 2024 20:08:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 5 May 2024 22:08:01 -0500
Message-ID: <CAH2r5mt5C-MbCWK--ZUgdu=T9K8F0biwTn+BvE72pXf7eF0aeQ@mail.gmail.com>
Subject: Added various xfstests to ksmbd test run
To: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Good news - I added 15 more tests to the xfstest group but one of them
(test 707) as well as one that has run fine for a long time (test
069), failed a couple times today (although succeeded when I ran them
individually later, and consistently worked fine when run on my local
system to ksmbd).   Any ideas, or additional information on why
intermittent failure in test generic/069 and generic/707?

Here is the full test run (6.9-rc6) with the 15 additional tests added:
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/10/builds/65

and here is running them individually:
generic/069 12s ...  7s
generic/707 265s ...  226s


-- 
Thanks,

Steve
