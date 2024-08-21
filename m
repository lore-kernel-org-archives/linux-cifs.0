Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6543B14F135
	for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 15:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724255880; cv=none; b=HpMxl84GKHURDy9+oleSZBeRLrFUA+oo6fhS+y2lIZ5NuiUv7RopsMfY93/FWDzKW5RrDuc7Wj7oYswtnD95xdaTV+X3aAwaHYKEGyKl9ZFDjO55mtAJ0aGzCYDbztLwb7CXPVDIcJg15So3mKYLlXR7zO2g2RXRsmj6L/LpMns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724255880; c=relaxed/simple;
	bh=BIW4iLJEWe29Eh8K40DCAgzRNV9is+ePhXzNiuVMfyE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=kZZkVvnFpHD5Q3twa0cYIUv6TC/OPCWVU5JzaoB9zKoUygF4J7kieaPcNoTHE2jaJbJ+ZPQYuyTgwwbynzrLFa0H6zqHkoVlF4RExtKCK/pdQOCBJntTF5XLECnpUah5NaoIwKav3je/E3ZvYir4/i6X1Q/aVPjnZrB/ibO0H44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aqQUlA+v; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aqQUlA+v"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52f04b4abdcso8729960e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 08:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724255876; x=1724860676; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eGNGO2uvY56vUZH6mFvyOPdmZDbNvIRo3dnZ0pU/ySM=;
        b=aqQUlA+vMkIoROaI+nWviQ4rJNK6B6yvhPCTzFuFn/H0JQJ7wrniTu+yacumDlBL55
         0UqMbkSIC874hryALRWFDWRBMI4XWZ2FYP+A0mlFZx9usKcVAzbJkQnT2O9sSloKjzZW
         KO/+ZRq+KDXm6rnFqN95Yq1nq5M5AMUz8vFARZsMrwzBA7ME/Ux9klynDI6Sl6prNkGx
         tAlv+m0rfsr8bgep6hNyR3G4RKrIBZcCEOqRe9Y6VCvrLSYy4FgMd1CGsKdUHaS5qMgJ
         Ivjl27GWMHT9FX4omsKeHnIXX06Gt6VC8uwrIacjavkf7JiV2XuS2iDx4qnfRD4xy7ja
         UvcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724255876; x=1724860676;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eGNGO2uvY56vUZH6mFvyOPdmZDbNvIRo3dnZ0pU/ySM=;
        b=m3QSwLplzDXVqSJpA6TPveQI0t7jaVwEyzJpdL0lUH2yTlZNhKv0AUXdJDeMKlPSa6
         K2P0dPLO/9bbmDXk4HVUzAzuAS0zouoksb9UTCZYsYLoao9TzBQhIJOFrWTZiZxerfie
         XXTHPwFd5PBh+rxgymNAZL6A+bvEIl3sPYIBVz+INVBGUMj3UFljsPOGT7rRmu8mVUAz
         88EwuD1y0cx5pBGPWAau0dFXcjEEg2RMf3UqRjfyhM8KSoOItDid0sB7J8j1mkXTtIWB
         olkhLhMvncNbdvzCMS1Phxpf5CYkymnnjO+rNtaRWEgCell2ZvZJMQb+l4oWSbC2TbFh
         angA==
X-Gm-Message-State: AOJu0YyJY4r4MMrLAOHwYK7d6+6zrGXSViPcgigMmFE77yHPpfQkv0zO
	ftdOjjAuNe8IMuw4U7+M8xOmKl6YRoloids40iXCNYiaJp2crG80ofGMVf8+PdHZtg6NW3B38gw
	9q1CHT+c1kMM06dX3HXtrxEJPkwE=
X-Google-Smtp-Source: AGHT+IF+0hEFmIUeAhcvxa3+ecoDmFJ+ZGPVQR7RCXbLBMk1PmvbmpDXchfmRSTemnKkS9zHDvmQ6JRkqDGDH/za0EQ=
X-Received: by 2002:a05:6512:2210:b0:52e:f2a9:b21a with SMTP id
 2adb3069b0e04-533485545afmr1653090e87.19.1724255876267; Wed, 21 Aug 2024
 08:57:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 21 Aug 2024 10:57:45 -0500
Message-ID: <CAH2r5mtUTOFgaQMbsWwkAD-XDRiVwyAGT=Q7n9i5Sd6Wf=9q+Q@mail.gmail.com>
Subject: Samba server multichannel session setup regression?
To: samba-technical <samba-technical@lists.samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Shyam Prasad N <nspmangalore@gmail.com>, 
	Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"

Mounting multichannel from Linux to Samba server on localhost
(even current master Version 4.22.0pre1-GIT-8edb1fd13c1 but I also see
it failing on Samba 4.21 - but it works fine on Samba 4.19.5 and has
worked for years)

I see many repeated:

[ 1936.825332] CIFS: Status code returned 0xc000000d STATUS_INVALID_PARAMETER
[ 1936.825344] CIFS: VFS: \\ Send error in SessSetup = -22
[ 1936.825353] CIFS: VFS: failed to open extra channel on
iface:0000:0000:0000:0000:0000:0000:0000:0001 rc=-22

trying to setup additional channels.  Any ideas what changed?

-- 
Thanks,

Steve
