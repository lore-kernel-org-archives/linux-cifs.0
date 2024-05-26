Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60D6E573
	for <linux-cifs@vger.kernel.org>; Sun, 26 May 2024 18:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716749090; cv=none; b=op5+Pi+k75Sf4avstQ1ScUNCK3X6KmWEssMzmXyB0+CDOHRU7sMglaX/qMa6oG5vZx/PMgVRWUkH97GdCwgWWATijVW6AYDd9SyrYrM42uUfy3Q71+/kC5qbPF1UIfHjTUGZzbl34OpRz458NPeKIxFHPbhxqRKAq4NDFR3RkKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716749090; c=relaxed/simple;
	bh=29Q/u7Y3CaQwakO1OmMMEKZ37mLJeuqZXtE0rVHlXrY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ofdHAHoiNSR7m9Xo+ceabQB8UYh/aJBvddBt2SurcmtEfwLvMX5rdrqIr9XsAkKqgM3GdjlNlQP27p6fRv9qg8pwLeBW+4BROxYQRLjyANBJa1yRdZ7qC4GYCZzsvvJULeFESjyY3okLuB6lKXhprt6cBr29OeQ85WwHuyikLjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jdzxfc2Q; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jdzxfc2Q"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-529aa4e988aso1081808e87.0
        for <linux-cifs@vger.kernel.org>; Sun, 26 May 2024 11:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716749087; x=1717353887; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P847oJPCBj0fZP3WJ3qO8BVMDVb1QJyZidcbYml7QXA=;
        b=jdzxfc2Q8F/5Fdo2y13wA/Q1oSXNx3kRIPDFTXh/Q77jLTMTVhhYth3v5lz4GJ53QJ
         94rkdzlfkqCtuyBDmVGOlpqFwNpzybfensK2dHGZFSJ6HfWqss3LfYz9+0LdoSoL7ivy
         yXp35Q/eK++3/3xen9w+jlovMY/jqIZ/Gp0OOxJj2Ms4aIgT56LnZ3A6PoOBJ5B9lCW2
         d/yWp75p4VGuB/0Y1pcsOucp+Iv55/Eshpn1smLavCkpjX4zRpaMsKXUBZMhc9owwv2s
         bZJ6HEVQl4rIUY4aBUFA41+lLtRFJVwg4Kd75Ca5LhfjKfTRbRy6jLIlRIDcXalJURaj
         rDiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716749087; x=1717353887;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P847oJPCBj0fZP3WJ3qO8BVMDVb1QJyZidcbYml7QXA=;
        b=ag9LSFz4buEmu3ekukJrfWJTUuhGrqx675GrMIlnhBe1i1KXBAS+a4bJMFcBxtY2R1
         PEuA4TN3OBRe39lamwUvWZDfNytLrwfCcqvbMv+pHl12xtAva0laC9wjxqVyNtbowYzI
         SGB2iD4Ypaca+mFgR6JK6P8tfTguMhg2zTaYIx5IeiCjbVdKRDdAsoFa02vnm92YCgcG
         YLtwJkz+665+o0d86Pw+DD/OTaOwceigK2lpbaRmSrDVXT83g9a1IxaOhzJVZclZ4JY2
         g/1l7myrcneE32kCxX25hzrdPrFiJ1OPNdzfBoCIAw6EUN98Nz8+VF+cm+LBI2IZeD/5
         F8iQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfkfZAUiU8DDfbAVM4sGiaUxC5EQwxlbBi6QSQiE+ioePiq+irOHp+IHDRo1JpSUlt14xgF1XcwK1LmM1jGyZ/m2/lgNNlzBxTAg==
X-Gm-Message-State: AOJu0YwObtBh7Ge2zvY009hSkv7x4mXtwuVZeTk/5CFFV7aqAXAIgLfM
	Ld5Or9y/PydyHXfpZmAVUpkpMVd0HDoKf0M/XWkn+Iepz3EDBnbi1w/MrE9awRzq8yuEfGZ/HZe
	FffKZe+Adwm2ndTbfMNWmRXKoxlLHtQ==
X-Google-Smtp-Source: AGHT+IHbcp+D6gk0rc6tMmlddJhRgN02R/qDoLgwXVILrIJSrlRjTnUpcl5Mf8evNmKDgvPeN43/MRDdSBVOD5UzUjI=
X-Received: by 2002:a05:6512:3d1d:b0:520:ed4e:2200 with SMTP id
 2adb3069b0e04-529661f3153mr6237537e87.54.1716749086529; Sun, 26 May 2024
 11:44:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 26 May 2024 13:44:34 -0500
Message-ID: <CAH2r5mvK3CfQ=tz6FuKNwYob9M+u_RT2NJ4HLD0bn7PQpij82w@mail.gmail.com>
Subject: 6.10-rc vs. 6.9 perf degradation
To: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I am seeing xfstests running about 30 minutes slower with current
mainline (e.g. the multichannel group, 140 minutes or more vs. less
than 110 minutes with 6.8 current stable e.g.).  Presumably this is
due to the netfs changes, but are you also seeing that?  I want to
narrow it down by looking at the extended stats (number of writes in
6.9 vs. 6.10-rc for the same test, and average times etc.)

-- 
Thanks,

Steve
