Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913812848A0
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 01:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762999000; cv=none; b=r5v1IQSWMmlScOvd/EfJUWFpC1jM3wAGOmghhGl/6v9/i2rLd+hO9+RaVS7cO4gTlLwWDpyjUaXhFMcs/4UMUx3lMuXFgRohWFpEQbk+OR0yGsr0Uo2TzT1xNrcMiKmcl4NnyE5XM9DaPbaju6fjYIhM40GtqdYNiLfJ4oM4l1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762999000; c=relaxed/simple;
	bh=dKuj/ZSHvfq50pVJAtWFPSs1RdsG4DU+WNiKSJgFSHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k3+8CyTXdb8g4egaIQhZhKM0RAgsCrdAhTJSPvXZnOPBC6uarqmMN0LRmNvIa3ltOSjChN0Cu7ZLGbGPccFQGvZtrYImobog3q57kZKc3SHv52CbPPD/tYO2IKaeylVtjurXzxg5p5+o9G2dL2YVGY0+RYVGMAW/yY7A3JSC9T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong-com.20230601.gappssmtp.com header.i=@chenxiaosong-com.20230601.gappssmtp.com header.b=SyRnn9wI; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong-com.20230601.gappssmtp.com header.i=@chenxiaosong-com.20230601.gappssmtp.com header.b="SyRnn9wI"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7aa9be9f03aso232316b3a.2
        for <linux-cifs@vger.kernel.org>; Wed, 12 Nov 2025 17:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chenxiaosong-com.20230601.gappssmtp.com; s=20230601; t=1762998998; x=1763603798; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vVWnU1CZft0ittXMJMFPMV38gYnCD3S/zh5BMLPyXNA=;
        b=SyRnn9wIU9UtAEiJZRxwbE5N2c2In7FBShRrAjVuIs6CZFX8Hq126QwONBBTBp1goR
         mspCZGjWnHr2NdtSxZrTJmJh+mmMd7yrjR8ejkxdFrgB2OLPs1G48sSHOj2qtBsJDW29
         3s692WMUNlmO57gWV+cKJ+cLLGCK6H/Zy2JcCmdE2HSVbPhs8++hNitQM4AR4ayw7AmV
         guCM6qjz07AurBdlH6GJ0jkrW2bcnbORnwDoZoyAI6gvZ34tOmCYX//k8gsTwkyJGa5Q
         L+oFR9+A85NacYRYLFWHYxXheFLduOhHbqFTaXApQRXxjzNZHEW6ZExV5itz8aOv6dWu
         HLXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998998; x=1763603798;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vVWnU1CZft0ittXMJMFPMV38gYnCD3S/zh5BMLPyXNA=;
        b=pOnV7TUX+ucfXMIK3WrAqGvDQ7GbJ6ybBrPZf4AoXPeafttQ2S9KEqyg++Lm01+dWn
         6dSmP53fJWaYy1L9hW+Z0g7usyYlvK7zPzDpgcF3d7Y7EaOPJtUWuL4euFvjQMYjB8vB
         djgw6H5znXiOVFdQkXZYbzl97pQzrLg+V5+eeNZbRUSejLjPSuVTMISfmGt4Gxkwg6Xa
         U0xNVvuMQzKk/oD5jRQHMcFcP0QcRhw0ERDduIwX3sd9m/B8whPtmPh2+F3N9FfO8c84
         EwGhmy5UR4hpJ1ACgZz1ezotuyJwgMnAKDV8zyTHAvJVoJQt/IZm9hLhDAfCsr7SrKvM
         GHPA==
X-Forwarded-Encrypted: i=1; AJvYcCVS1eYZrfEhSAWc7fncAxX4M55Bf1EAZPkARCiNBWKGxz3BL7is8SFTLKtaFfPq5/lOfwrhbJDjpsf8@vger.kernel.org
X-Gm-Message-State: AOJu0Ywjb8sA7rHSvELac8K4Hzvwxjp22inr37vXQeR1P9VrJiaJhOXk
	2fXicVuKhvSHKx0auPVUO+vdEzEFTFclJELKmbj4zRTA4CnS0up6J19yYaphEGSJFZSV
X-Gm-Gg: ASbGncuTwIO9b29DVEVyoh5/ZSX7PDdNIEpfSl6W7kv6JFyKOmroT4dWkyWIF7Kue15
	oHYU5E8e8VK4SC0c2GEFF+42I/5vl5mB5gX2q/TNBY8+C7MI3jlmJ6RNFTPHFJaW4LfLHo3UNIt
	Ykg7lXq8UfzgvoxKhfDrV5km3wQGo3MPFb9gNI29ApDa3P1SV+gXwYSW0RSFE+B+DikuB8SMA12
	P0s/3tatnSPbV4QYUmr13Qm3urA8E+mn/A7erTY66WrLNjzlpzoOeqf1knH/A0t2vTu+yNcD+JV
	CwJr8SaLtPXAIkhaZeDU6tY7CHqd6Lhuar9+k/HWcMaZ+/9/ZX/X7JbI6XeB3XqvAdqsUWlbTZY
	bB1EBI3AwaTrIkEbW7q7wQ14wszR5iGgAjI4gzDF0lQTf8qRqPiYGHUkIjRgLcnnG7kA+sumA31
	YRh0Ujv/5sLME0lnI6bRlQ5UdTknQCpIkS8zsoeO/l
X-Google-Smtp-Source: AGHT+IHEbZmLflN3bexQUBqBxwVsx4Zvx/rxh+HoCzmVBKdRm8H6UivAf07OhDcPO8D8Lh7w7xDGIQ==
X-Received: by 2002:a05:6a21:498:b0:342:3b8a:f349 with SMTP id adf61e73a8af0-3590c2011a1mr6270904637.52.1762998997773;
        Wed, 12 Nov 2025 17:56:37 -0800 (PST)
Received: from [192.168.3.223] ([116.128.244.171])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b927d1d128sm380240b3a.73.2025.11.12.17.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Nov 2025 17:56:37 -0800 (PST)
Message-ID: <7f061d12-0166-46ff-be38-33f6acb02a49@chenxiaosong.com>
Date: Thu, 13 Nov 2025 09:56:26 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/14] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to
 common/fscc.h
To: Namjae Jeon <linkinjeon@kernel.org>, chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251102073059.3681026-13-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_n3D=CC9DfVTak3oQa3xqkQ2jyHm9sUKDLd=exJAuXJQ@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd_n3D=CC9DfVTak3oQa3xqkQ2jyHm9sUKDLd=exJAuXJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

In the client-side code, SMB2_QFS_attr() needs to get the maximum and 
minimum lengths of the FileFsAttributeInformation. Using a flexible 
array would require more extensive changes.

Thanks,
ChenXiaoSong.

On 11/13/25 9:23 AM, Namjae Jeon wrote:
> Is there any reason why we can not use flex-array ?
> Thanks.

