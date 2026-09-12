Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B304582FF
	for <linux-cifs@vger.kernel.org>; Sat, 12 Sep 2026 10:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210061; cv=none; b=D+vLCmFlzXtotOcw1Ydv0xvC5bL56ALnBd8DFs7wftOLTcm/NuVyUAS4VRDxB9eTWW3K/Wm2WO6Zrc6Q7jcWpV0kTJIYfuR64tw66EKTZHnH/7+o50MhUDjVU0QG6C/bcSaIyYzb9S7hxPuyaZ3wkYjfc/DMJmQxP9cHzG8fK/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210061; c=relaxed/simple;
	bh=xZyti5puh9IApHEtbblu+dH85X596e8jcnKz/h+fYQI=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Fz3t3pVGlpoAQ3lExiPGANWiohpuWSQwrIzvvdVfonILJThbL1T+buNPgq2Epg9xIa9BMPLHILNIicpLDWElqD5iEU/wLhPc/2C+xuzxHKQovNJPmiz2u9wP/DhBs2tOnA+FBbQChT1Z4WDtsUIze627RUSuStJAcEpWXnSKDgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=piGk6xFD; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="piGk6xFD"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2db479a55b6so894095ad.3
        for <linux-cifs@vger.kernel.org>; Sat, 12 Sep 2026 03:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789210059; x=1789814859; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=H8aG8KORC1ydGEXmHvJ8YVwIeau0vwTSXOhq3WoBiUM=;
        b=piGk6xFDxEZT4avhcHj2FJ/ugO4NP+E4UhB2blIlv1iiO0cAvbWNfrBTyZ9e0Sk+1q
         6zI0DwpO3lblHXtm3Mgb4FsN1mZKgeKEUdWnxh3G6oqrJU68DbzTIukrr0kbszo7SBTz
         TkY+6k3kNq9r3AZA181QXitrAqIposWfIl5vFOTCKpqAIoMHc0qQARTX/CPJzBrmnvjI
         40JTpmLsFDHrR4CC1EmYW73Qy+bBtmSU2B/R1udttSTd2qIK71+B8qs3EpclbVkkx9SE
         usSMbspqyr7keVJVHydE7R206XZ/uzjsXNfsP4raAhM1fDHIK55k2Fo2l4ZrvjRO2Dux
         X+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789210059; x=1789814859;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H8aG8KORC1ydGEXmHvJ8YVwIeau0vwTSXOhq3WoBiUM=;
        b=RDTIsQKSRRXh8UbdbgyhAhCBweiVgCQ/pMRsxALYsfHSqKoAJahDPvgw9rXq+LTyFJ
         XRzif/Veq9GDqlOklkjd6Wlkl/7uOhZgd38+q56Y6sW9eEqf3eFOEn4T0FG03B5soDn3
         dEEIVYDtfnrFD2+2/7M/8YVY68bIpA6tX/88XYkZBxbaktrMuuAp8dODTPlxXv6z2YNL
         BX/jJ4lynsuI1hKEQECpWsIHO2jR4QO0xIFG5sdbeffQgrszhUoBArYZaxR7vRBYGME8
         OodDpff6uZDBIi6nP6TCZRU5HsSfDTRQ/5muqYdekN6oTdPxRWGrezXtwl0qXPQhvRzb
         zezg==
X-Gm-Message-State: AFuF++mI8Ux/sht5eHF2vIJyXk3eHwSHXg7A0NTU15zf+4Dsbx3UyoUK
	iiLmzxsI/WTj2UU6Yzclz/bki1Fw6Jge7VW0Z5PFqyIcPjWbm6lq25uR
X-Gm-Gg: AYBFou2DxggNKcug9Bge4vwMiTJR2ehQIoi/UAUrE2BaC7SXC7HT4yIS9kge5y4gGyz
	YnE9a4odd5kAxD9r8E4wOcS6D5FDHEnVUo9Hd5An1YG20+KIMnjR678qgP/KdJfVpJeI3v2ULCZ
	VixXEJV4ZJEWWVZ8iVlBJmEE7wOpzwW5AFXGL/JjTtRQnvXLUWjy8zwgG44GeDGqe6P44D0W/Kj
	dUisnR/xnVO12yP+eNXZQKvemkoY7bN452i6dP0XcpAbKC9Q6DZE8n1t3ce1Hi3ZR9Hx0vELPA4
	NUv6r13mjfOdsHsUr53k4Ul97nujL91818mLLuBmjcjTVIqtkFiukW/ZBZHJI9SWsaO4NCVtgmZ
	eVN6eTZXBMZ2lnTzceJRgWkz1C8N2pDzl1orCvNzO4IqQw4P/s0It7FpXvvfK40t9ogS+iRTjZl
	YPbYv4aQFrpvmsIrlNFlcRSOtFDfPArG/Ebrbs2MwhxsIIHGVOH1EfB7PzVWn9w5DkhC0m1X62z
	MtfmlxLGhagThOKEve7RY4K/+j0CVxYW0S6QYr0
X-Received: by 2002:a17:902:f608:b0:2ca:de3:15eb with SMTP id d9443c01a7336-2dd2a00b056mr98602975ad.0.1789210058893;
        Sat, 12 Sep 2026 03:47:38 -0700 (PDT)
Received: from [10.7.19.162] ([49.36.138.18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cfc4403sm23046535ad.52.2026.09.12.03.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2026 03:47:38 -0700 (PDT)
Message-ID: <d80d977d-85eb-482c-a151-87f403cdf01b@gmail.com>
Date: Sat, 12 Sep 2026 16:17:29 +0530
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: pc@manguebit.org, linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org, aaptel@suse.com
From: Aaditya Kansal <aadityakansal390@gmail.com>
Subject: cifs: cifsroot: ipv6 support may not have valid path
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi all,

While looking into the IPv6 parsing TODO in cifsroot, I found that 
kernel's ip= parameter from net/ipv4/ipconfig.c only supports IPv4 and 
there is no IPv6 equivalent. On major distros (Fedora via dracut), IPv6 
network stuff happens in initramfs.

If that's correct, AFAIK adding IPv6 parsing to cifsroot wouldn't be 
testable.

Please correct me if missed something. If TODO is still considered 
valid, I would be glad to finish it.

Thanks

-AK

