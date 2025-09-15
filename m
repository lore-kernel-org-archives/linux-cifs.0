Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FFF2853F9
	for <linux-cifs@vger.kernel.org>; Mon, 15 Sep 2025 23:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757977627; cv=none; b=uY9Tg5A9bcEQld6Ll2IuBCYBYUk2OHSziY61VxzyVB1+mOahqg6mdNWqQ6f1nwkc6FNdH6KbjSm/MUm9Z51P675Q84z8YPkQnH+tT7nw/X641psFLfezCXdWnzIr15Z93jU8mP646nDGfeNbRx0GchsKdQr30nsQUeBIGOADlks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757977627; c=relaxed/simple;
	bh=excbcDwDxrEvuwHqwKVQbW2H0N+JOeSU0RhDz8Q5Z7I=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=iIhTKQPAxodrvAysvpdXdgdqFei/t3rjvqZ0SkUktYtO5hyNERyEuYt1ejNN+0l0sO89xtNJN5ASnjehPPYKaQngXeH9pHjjVOReB9A6PwRxglMeskiebfM3RSesGOC/O3hQhfmiAKNNY1n27WZOWJUsb1gOexY2/FC4ZVvbMiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b47173bdb03so314828a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 15 Sep 2025 16:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757977625; x=1758582425;
        h=content-transfer-encoding:organization:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+tG2/pl1HRKUlyAsj9zDa+uGnIDTNYDArMaYIOnk47U=;
        b=I8nD8hI/z956yL4LQdlWJtRuawSDI7LyRtSnyNU8GVkT2Xgs9EqwVEyy5MtT0cROI2
         GKNsIbePJHFM5CDGILpWEju0Awpiqi5Zm/9fahxqOEiRNbYo6dqE90S0VRnVe/Ax1Y/K
         rmJk/ZflcrUCypyIK3LIglA3GHND6y6rYsn+rmqQtZXcGmJgGK6ceF7rPs8O+MWXywtD
         2jmM0DibJsAV1f/DRtUBWFZWiWOlUemp/T9IzbUvntI6JkgE6hDJQ7GwRfbQqZJUHnhi
         j7RR07vrCm+wLxNvkCRObJP0ShWHDi2Lwn9c4LBSPmW+JndoPLB+6tDXnTqDcVfkATy4
         3t0w==
X-Gm-Message-State: AOJu0YxXi+T+8yaiuuLYJd+cscYVmQWVgE9bE/pqyltuadUHQ9252U1t
	vsvJt8XvoHqsZ1+NfP1UYWGx5iQjUBh7DxRrvCGmWtquLDdkcvMjyOQP
X-Gm-Gg: ASbGncs0M6ta0/I+9mrN7eFhgebtAY9uw3FH8U1KsUxDOWRJwz7zkYrbYlvnAVQzOmg
	Ss9/YCFZIhgCTMiJuK0QgGxzUjk/TKSI/GIjo5SP8hv5A6JelF4lt6ahqdyixNczT14+kZ0BsTF
	P1zF+XbfXa5V/yT71RxCDz6+toqfCFO7J7kfy+A3LaHbmiPn8O7XilGyKMzZYaKytmKjG9R8liA
	XKOZfi7NbS1dphVzqrgMTtn+OLKD3YTz7Xdo0otaVRRdGM76JhNg79N1mBDQXt/6j4Kg/6bTZdt
	5ici7wByw5PDFkdhpoXJ+XUbIz/RnCSl1hI9alRWuzaytz1WgDh5Lfy+g7NlSfhosZF3NmzNIb8
	v5u4WpWV3uf9md61gc5nXQg9PAPSL2OEr5C7XVmYFRly76daw2nvgo19xY5n9iny2guTVrrLOfA
	+kKnwQxbAuANnSkyVnkFg3cfAdheV6
X-Google-Smtp-Source: AGHT+IGbqBJF/id9+qYtY3KsiDNgt+EfjytBm4qa0ZzMz3igOef+VrgCD1CGjFg5iy6cetqBPVxKGA==
X-Received: by 2002:a05:6a20:914c:b0:251:31a0:9e70 with SMTP id adf61e73a8af0-2602cb012a7mr10124077637.7.1757977625339;
        Mon, 15 Sep 2025 16:07:05 -0700 (PDT)
Received: from [192.168.50.136] ([118.32.98.101])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54b169f2edsm9504128a12.19.2025.09.15.16.07.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 16:07:05 -0700 (PDT)
Message-ID: <8da4d540-652c-4845-9feb-0d53eeb3b5ed@kzalloc.com>
Date: Tue, 16 Sep 2025 08:07:02 +0900
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
From: Yunseong Kim <ysk@kzalloc.com>
Subject: [RFC] ksmbd: Deprecate MD5 support and enhance AES-GCM for SMB 3.1.1
 compliance
Organization: kzalloc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi all,

I'm looking into contributing to the ksmbd crypto module, specifically
around crypto handling in crypto_ctx.c. I wanted to send this RFC to gauge
interest and get feedback before preparing patches.

First, regarding MD5 support: The current code includes HMAC-MD5
(via crypto_alloc_shash("hmac(md5)")) which appears to be for legacy SMB1
compatibility. SMB1 is widely deprecated due to security issues, and MD5
itself is vulnerable to collision attacks, making it unsuitable for modern
use. I propose deprecating or removing this support entirely, perhaps with
a config option (e.g., CONFIG_KSMBD_LEGACY_SMB1) for those who absolutely
need it, but defaulting to off. This would align ksmbd with security best
practices, similar to how Windows has disabled SMB1 by default.

Second, for SMB 3.1.1 compliance: The code already supports AES-GCM via
crypto_alloc_aead("gcm(aes)"), but to fully adhere to the spec (MS-SMB2),
we should explicitly handle AES-128-GCM as the default cipher, with
AES-256-GCM as an optional stronger variant. AES-256-GCM isn't mandatory
but is recommended for higher security (e.g., in Windows Server 2022+).

This would involve:
 - Adding key length checks and setkey logic in the caller side
   (e.g., negotiate or session setup).
 - Updating the negotiate context to include cipher selection
   (0x0001 for AES-128-GCM, 0x0002 for AES-256-GCM).
 - Potentially separating signing (AES-CMAC) from encryption ciphers for
   clarity.

Is this direction worth pursuing? I'd like to prepare patches for review
if there's consensus. Any thoughts on priorities, potential pitfalls, or
related work in progress?

Thanks for your time.

Yunseong
