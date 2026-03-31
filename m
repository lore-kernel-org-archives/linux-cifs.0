Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E618382F39
	for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 07:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774943655; cv=none; b=TobxMbVr+HfZiJkWqCnezbETGk8omoeTBb0x1IGjc++kHLV13/t0sLj/5ha+TJPg1EVigGUfRiGqfU9ymyzciwhwg9TtpY/z+uZYYbBnUcjSYEJWBKQMyaMRA/p5szwc77qP5Eb7UJ2+wy7Pw65nfEcbFHccwXXpYTm0AgAuF8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774943655; c=relaxed/simple;
	bh=lmze7BYV5hp4Y6sIOaGFbKHwUOMEax7foVnYPnmvQbo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LWRsxgSp6FukN0ZforYTvcJqS3qhgLsGUS/H0WHt9xc4Mlen9LMjwqen1Yry+9RMYSAc1VHg11M4z7i+I7Yqg9uq+JITDIax2RRATRF7EO9Cck6dCDlnRYUDnQ+zbtpyh1JxReBxQ+GPFmPJa7WYnRYaya6jhiH13WoJRvuOJOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=DUiRy3Q9; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="DUiRy3Q9"
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id D0F7E3F2C9
	for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 07:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1774943651;
	bh=IGd98WxReXhKmS3gVZc2py42NhhB81jPPYvyJnFKCbU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=DUiRy3Q9unGA4Zd4oN+0ElhApSSgPCyC45dDzLnYKapfZL40ud72ITVDe9a+RHfJG
	 lhEkafrwhixQb0WdOaDpKJnDClnIiAa5Fzi4NhCvUthGVCIHAcQu/dAAwXAtrfHkhv
	 x/rjQgRfUAsNdEsTFAlIIYe5g+dNlsOOs9GhJLMI/hBJOeYkUjpJ5y7Ext5KgkVf4I
	 RwhuXmX2dV/GGXerYE7K0yPiWzgfHgtkxqIQxoHlV+CnQGVHu4KuJrRZ112tO75tHE
	 fGjD1sKXDvV+ws+YgVPugWdiPqRCuGEvhW2nkrfIjVVqCVXxL9Qicr2d2sOGISL8Fj
	 U5qrZNz66pHLN0OEKX75sOukFPKdXP46VVdMCJyEv6OB+gGsl6mnzteMlQqfBfhWbS
	 kG5ZIID0C0VDOo4Yl5GZ4oDsgZwJu4s3H+2KDzJSHIW38vG2N5IBF6SpSDD4RHaaO0
	 osltoVKJJH+wxdn9y4lm4LAU73XD9cIFtXN11VsIVB13a2D6QYyRNUfSbia8DvC6Ou
	 wCeeWbflg247Xf0T9tvOokFHIXBFXKsH/PLNpy9+f9ppSYIRYJ5QTOsq5Ir4qKTwXZ
	 f+x+SN38PfIQJnk9RIGjZTGa2pa1VFfLaAhHd+TSRVimphH3jUk+uSdQigpTp3hrfX
	 BrHtEiZOBGmDIt+cP3O+SF+M=
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-486fa07f2bbso32322575e9.2
        for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 00:54:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774943651; x=1775548451;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IGd98WxReXhKmS3gVZc2py42NhhB81jPPYvyJnFKCbU=;
        b=SoycxoxNjmzPOq//kpVEWnYNllNEHm/APNRFgJdZCwxT09PsISVNCh7Ndo7tLsLYur
         SkxtUMV595W9prLifRkfG14IE58tAoERzplKkuzesfBvecOhuFuL/W3fFNjxQKndZI21
         2g6zxWo95KGw3zZwvk3UEL3vxdiS3OxUAVfQYd8tiDI8mMwRNlJGpjDPB9FNU1SyY93Y
         4TcwT09s+w9a8WGm6NzPJoJdFzh3EDUOnE/argOP886mob+gGRZztTA3mx4wsWEOA3bS
         FbANRfgzy3SYFd4nJSNLDsbRGi+Q1uNLAG4+P4YcvY+wSkVceVxxXdEAASy4dYtI8QP4
         94yA==
X-Forwarded-Encrypted: i=1; AJvYcCVUbhOjr5TFHO0NCrC8T0DhUbLchsG+60Os51za+edQnEwEpiE2h/gSsfghyvgZBVenCr45nmI+6xcH@vger.kernel.org
X-Gm-Message-State: AOJu0Yyuh6f9OtyQSk8o5f/pusIxQ4YKoLPGttQG8IGFCRoUb3NWBa3G
	rbjUh/i9L3ge3rpjqDtcKJO5utbYFLKMXHIr5HAoM7f90kqEfmH35/zQpLg6rnWqaI/obesymiM
	3sI6mc+Uv7HJFeWqfop5LlOWZ0Y35ZJv5d6gdF12reke2Uu5ORkrPq0gdaqxVyVfYgIWJTAKOcZ
	lEjFI=
X-Gm-Gg: ATEYQzyKNdbswsUVPFp74QBQDR8XIz6quW9tQLbKHS0QgmCDp3Pd+cW7U6jyZ06ujOJ
	JIZt/bSUCU6Kyl/dRvfC64xmJDhFKmXS77TDat5HhvReAD8I4HkFBYc2wKf6A9KHYw96CdZc9lU
	Tk5cxyXIXeMw1GQ0SJ4UpH6cmEQUkYq45oUkTeboTmE1eynv7Y6WXjSJ1qYjWYn7DJdOIf73FDP
	xW2jLscXdpahGwjqLnZawnu3sOuddJ8BSpdTBLBA0RDuqaUhCYNOW7GYJNuvTk20anq7vkoE6I1
	drnHByGi899YThjWqUcW6Dr2KwsschUDM2x2aL6nW2atSeGr8QVRCaJNrD4dlMDWnCyZxvIi04C
	FoRLo6BmsNnAerLoB5N2zUkzDZvkcThuTjP/g
X-Received: by 2002:a05:600c:3504:b0:485:3e20:4013 with SMTP id 5b1f17b1804b1-48727f0b109mr228374415e9.28.1774943651258;
        Tue, 31 Mar 2026 00:54:11 -0700 (PDT)
X-Received: by 2002:a05:600c:3504:b0:485:3e20:4013 with SMTP id 5b1f17b1804b1-48727f0b109mr228374125e9.28.1774943650831;
        Tue, 31 Mar 2026 00:54:10 -0700 (PDT)
Received: from [192.168.1.126] ([213.204.117.164])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887c883b96sm9903485e9.17.2026.03.31.00.54.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 00:54:10 -0700 (PDT)
Message-ID: <0dcbb073-4745-479a-8d55-bdb0a3fe55e8@canonical.com>
Date: Tue, 31 Mar 2026 10:54:08 +0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6.1.y] smb/dfs_cache: Fix NULL pointer dereference on
 session connection failure
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, Steve French <sfrench@samba.org>,
 Paulo Alcantara <pc@cjr.nz>, Ronnie Sahlberg <lsahlber@redhat.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Aurelien Aptel <aaptel@suse.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
References: <20260319144929.455978-1-ghadi.rahme@canonical.com>
 <2026032339-irate-monsoon-76ce@gregkh>
 <a7c5ecb2-d46c-4061-a70a-c7b149db56f2@canonical.com>
 <2026033140-endearing-handcraft-b66a@gregkh>
Content-Language: en-US
From: Ghadi Rahme <ghadi.rahme@canonical.com>
In-Reply-To: <2026033140-endearing-handcraft-b66a@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

 > Then why not backport the specific changes that caused newer kernels 
to not be affected?

Based on the documentation [1] for submitting patches to stable, the 
patch cannot be over 100 lines long with context.

The upstream patch exceeds this limit by a lot and cherry picking the 
specific changes from it that remove this function is not feasible 
without causing the driver to break. In other words the removal of 
"find_ipc_from_server_path" is dependent on this refactor.

 > Backport the same changes?

I can go ahead with this solution, given I get the green light to ignore 
the 100 line rule.

[1] https://www.kernel.org/doc/html/v4.11/process/stable-kernel-rules.html#

Regards,

Ghadi

