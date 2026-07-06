Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3222A3EFFB4
	for <linux-cifs@vger.kernel.org>; Mon,  6 Jul 2026 11:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783335939; cv=pass; b=HrLwDtQYcuGYSXVCYBreTbIYebEHgVZLyh39KRVHT8Bdp5XKDLEcpnGO1CduN/a2Alen1JjztoXdvzEDd9TXjTW1QNqV2SPKPiEeBU9GlUys1h+imA/Cj0W4+/7X/CQX/5FdV1+ym/W7T+GjOxi8nBWPNGxTYCq/pnGhPv9Ac8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783335939; c=relaxed/simple;
	bh=/hNkRgqeQVbmzvlwRmP3/2RYGVe1oSFSJkX3H5Zcdt8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MtHcZORGZyIQp5kgxbeoVwUHTgwqrMtemvZJ3Cd5tk/gFWNHZNf51msaBIM8YShvtwDVXVuQD8nkKHMkqUgc67VEYabtb0okuyrGgT0D4DJf/C2KDTeHOcvRl2qcr7R7+zVA0VOT2LDSTwJrInj3BeYx+ObG0Phq7POOdoc0cts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=L7kbB6Wc; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="L7kbB6Wc"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51bfb91795eso16828691cf.1
        for <linux-cifs@vger.kernel.org>; Mon, 06 Jul 2026 04:05:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783335936; cv=none;
        d=google.com; s=arc-20260327;
        b=lEiM7fyfnPI4Dt11jkIhdPnVYBOQ5K7h+kp/AxaFLmhIpRpAcobWt019Zzmtrzqdjx
         0bO2n8RzZ4+UhIdpkee9BnZX1WfSuab5yTxbIshH+z2mXAQdjdmBVKIkUrT9k63W/YkD
         tC/cpNOnezETvFzDVUXgXl/ru1apT2FnH65WqeFIjBy3PTHMbgWFyGjIZrrkj1uXpOJm
         B8e8SB/CA1kGKcWJv+pUnu8pHRXJaXQEZRKeT1fKCEoCUesRAfJUk3o1LnRmo+DSoKhT
         bzV8n4cp2oZU6j7Oq6cN6YRKtZNaCC4flPnkGFVv3mV4goIhb4VTLUZjP/WRXcO+UbTI
         GWPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5N9xOz7IuFoWi/YP9UdZnMaOav6tflAjjK/V30R04Xw=;
        fh=UziU2Kw9eMb0RiwwGph3QRbwOVGsPsskCVcFQiC4e1k=;
        b=JvLq8KvJeQl7DihvW4gk4TmZ41A6YumWWxI4rpUFsCohUtBhOI3dzjEhvIPcdsYsRC
         h+nTGLssAnyw2ND3qUE4FC9RfwEZlbJiHZmNMjSv8MlzjBhf2t26H4aqwu3OxnmRQrPB
         K7au4k8rirnJEEI/y/avWkrqDODTUvv6ZOAIHBtfJNN6GXDlRLUFVwZrd00S6l7W+onb
         S9D2v3/HeXKfEQ6sUmeSGKdyU7yDbqWectv7ayF43ab65o3pjWIiTSy9r36E5Mld6hvK
         4cZzZYyBgEeH14/qRDTjpWWPyYCSonUqXrfLmDr0qyCt1hSTddOQkVenFMEzzbrAbkaa
         f3Ag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1783335936; x=1783940736; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5N9xOz7IuFoWi/YP9UdZnMaOav6tflAjjK/V30R04Xw=;
        b=L7kbB6WcHUV6HryxojFgeaun/MQ6kjrsBcAqV+yFpS2C9zHYxYE0AnI/mL+PM9VF44
         ur6rJteTLgKQNtRVXVv7dkrf8+W6qeFnqKNbE+nA/plr7sNWyKKOikW7n1UyVJ9+fttA
         W9tqDW2bVZXB4GuHXBbwsX1eIYoBWEokArOQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783335936; x=1783940736;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5N9xOz7IuFoWi/YP9UdZnMaOav6tflAjjK/V30R04Xw=;
        b=W5vX0qMyM4hWwSbp1vHA3aTjxP7pyE3MHoiDHt4huRQs1iteoutlDUmqyTQ47JRSDy
         k/JnaMKUhrKh3fRwQZ6/fdFkTwg40R9KVOSVxQclYPDaX/Gg13zYGeGcqm7f+eZ9nOk0
         1CrvftYEKvd8UpuRLKIxzQTRsQLPLKpwKmOlq/NVuuYmuORti1D8iYxt1pY0Iyhz6PGE
         nX3anQwMmBiUfHRE97ROWl/SC+maZH/4E55VVd64vAavKLyAhWkSEoEbFypl3YeUle+d
         FAfqzpEjHYhhiVBia+VX1FcOHaGL0mMjtp8WrgwLQugjRI9nEiRpaftf/ZCL0ifPjEAW
         YAJQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpi7d6KPqEiQTuYrHh7EFdGsHMgr9XdsX2EOk2OVPppjrzJfTTVbuCYECnctKoPPPdmSgH0xYDcG0FL@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3xSqydmgREF1WRewq5Ycm6crig3CcBqmluT6c99lEeXut1wak
	7kVG6zBxNr1EvKYnuvKDUX7MnC23vJL1MMkcju/t1+/Ze4iULIAb9CLZSoGm/rGeiKAWQwF9TmN
	q68ARRYP0LugWB0alFymb+OZQVGXW2jSRVPhndSPVFA==
X-Gm-Gg: AfdE7clj7Zi3lm9/4N+WbvKseMJJkAmF9nmwQEtI09rTJtgCreCZ4hNt+660us2pYq9
	fsklen2YQEe4jlAkA53iL2iDmvMCEQ0d9tt7nWKfndjrAIOKDb4Uom+BXPyb82zuxd9U69rfzIn
	xEyS+66UhSb0x1XhYv0VnKxhWCCTtNiLebrno+mkcuQQg3FjuhZxlAoV/fyvjTuogGTGda7O7HV
	oYsmoo5Ct3B1rNpFEJDjQ31dWwCH4LMbM/OxjZkcXfIV69h8ie2b44KUzPX5rK1C7SwmMJvZQcz
	lA5WE1EiUMBbtVI9K+QCBHbFPrA=
X-Received: by 2002:a05:622a:1453:b0:517:7e26:36a4 with SMTP id
 d75a77b69052e-51c4c2c14b9mr140647271cf.34.1783335935865; Mon, 06 Jul 2026
 04:05:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702021105.3406439-1-neilb@ownmail.net>
In-Reply-To: <20260702021105.3406439-1-neilb@ownmail.net>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 6 Jul 2026 13:05:23 +0200
X-Gm-Features: AVVi8CffNWtFbcBvs13jifF0StaOc8_tnG8CKCFcb9gVjjy93J7qwqRMN2Yb6cc
Message-ID: <CAJfpegtCL8S=zjv-pwxrX-9YXL0HLGb8Dsw_XWFF_H4Ui3MTZA@mail.gmail.com>
Subject: Re:
To: NeilBrown <neil@brown.name>
Cc: Steve French <sfrench@samba.org>, Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 2 Jul 2026 at 04:11, NeilBrown <neilb@ownmail.net> wrote:

> 10 years ago cifs *did* use ->d_time but was changed to use ->d_fsdata
> by Miklos with no justification (a00be0e31f8d).  Miklos: do you have any
> memory of why that was done?

Wanted to get rid of d_time, as it is no longer used by VFS, only a
handful of filesystems.   Still a worthwhile goal, IMO.

Thanks,
Miklos
