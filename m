Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0682877C3
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 02:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763000499; cv=none; b=r/b3hPC0MFzqeV16/75q3+h+fHH/WuPKv13eA8wUYOrVIWUQ49NHUgSCFd0rJApIvY3idfG9IrnsWEVGc/Wlw95rz6tKgPE9nDGtlyWTg9L1QdeSXh483mH7lGNzZ46VCQbeuW2CUB6v/HvPt+mmlL6rj2Gl4OBBLgF4HDewa0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763000499; c=relaxed/simple;
	bh=JrYpJbnMMLzKJWCfIvJsV5n9ot3SXRyGAY8AhmxUdcg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=qKjv+zlhB08MvshKp23fUOLFiPPEj2cSMcDPLNWkV1LcdPBCVGgYRgCb43r5Z9TOQ1XG/EON9/tQScPtlqacOv3jHC0hTJrhxB2jQG2j7gJdYGmWzkwVOFVBDJ+hYwLmc4Zr+kAB2f3tz1HkxHrOTQsnFpb6er7NzpEP+u+OG88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong-com.20230601.gappssmtp.com header.i=@chenxiaosong-com.20230601.gappssmtp.com header.b=jdMSb/pu; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong-com.20230601.gappssmtp.com header.i=@chenxiaosong-com.20230601.gappssmtp.com header.b="jdMSb/pu"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3437c093ef5so277821a91.0
        for <linux-cifs@vger.kernel.org>; Wed, 12 Nov 2025 18:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chenxiaosong-com.20230601.gappssmtp.com; s=20230601; t=1763000496; x=1763605296; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XQUss227TbD117Y99UM8EdtGfgfeIJ7HRgtQsqQweZs=;
        b=jdMSb/pugxu3NC7BzKQuq1rNd9AHYhRZ7Ca877dmPO4ZxyUejTJ7xlDUFmCr6rPgQC
         OHU3rT+qvRa4YdwSYbUoxi1N8cGhWlttMzGRwJQ0okskxuz01JluGFMEUIy9nuOe3Nux
         ZAn4YOAH9LMhJDprjBr9Dlz0t/xUP+H0guGH9Alx0QAcho6vbNG75rUSES3RXRXdRnPG
         bzEDloDF5EhCLf56aJuaPakNmgm1pyIsOKe/vAkYora4IBKBJys8CxB8Vlgt1ASdNNEo
         J3GL9dg6+txkTKW125A7LkRL10TNmVbaKN/T9owi+yXDcEKObGuU8TQc7wCq6CE3DZ6M
         QoDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763000496; x=1763605296;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XQUss227TbD117Y99UM8EdtGfgfeIJ7HRgtQsqQweZs=;
        b=PNHYtoQMpZguEYf/XDZp85CiUG02cujwwz7LUKH6cezRmq5yNUTnXg2MBEBu2F0Fsq
         8pI0KNbf94uwRVQ4U9jgvxWCUUIcM+yaaU2GFs09/gh4Y/JKGdSweC9/UAUIO2BqUFSV
         GTW1VzSb3390vYuk+uRnj3nKM+R2b2QspMNsR9vi7PxuPSVMHrhA6deiFgm85Jc8jMCM
         01PNiLGR34cowQTdaIw9NCsuLINhPb9S7YSOubsGB+x7G/iFYC0IaVbpkZZK1KsXlAxv
         hNnj9DgGqg8COSbohwiRBv2J0SBY5+breaKAlhWhhBMCcii2rOaGL8wK4R1fQvjL3OcL
         fu7g==
X-Forwarded-Encrypted: i=1; AJvYcCVjWzHSytRd7bN3VNDKUn7kdCFREe32Sqqy3jzT5RDiJP9gKZHcJ2vYnpO+airsiWULdTv+TOBFeMD+@vger.kernel.org
X-Gm-Message-State: AOJu0YxWqEuKT+gB5ueLG3JFZefcTEUY7+S7iT7JyB3X92V0jsDO0X82
	QmmNlat0iEa7jXcY/tiVMPfaGs6BzU2aG+JQrua69eEbQiym1h8x/RsmEQRA1LWPVT7r
X-Gm-Gg: ASbGncvBuX1pmS2xtVKBrJik/+aWFRvn6sG+25621C+HyipbG6ERjVt9Tfwb8MqQ7Vm
	Ao/dG0kE5V79hboGy/Zxe5Nl//Toa6pNqW0WRkrrDq1H9CUvQWBZM71GJhy818t5R85ce79Knnu
	9SwidxlQ7PgjEErjw2UXyCyEMNCHDXzGGOQiIoImK99jE6CLwdXYLAU48T3iOGpwqvWK7C0MSQy
	UiQqfEjt7KAanKFWaTu9OVjZ7jSMa/LxxGA31Ci5aRMxTunog7iPdIJt1otKMtC+m1hS289p/Gl
	+SYt8XkvOxyaMa7ZnwVu9pcFtr1HPk1XYJxn6jAvO82MMijJAB8+WKQf5IycaaG624SEwk2r10a
	H4LGkpyCH8Y2ZIBd6dHfG46yOeONHT8uvYilKgFa+G3uD1EXIwB6kfunTRbq4/Lf+HaVmEgxLtl
	sorJ03CQ+o22/Gw2zFygb629dLoECPXA==
X-Google-Smtp-Source: AGHT+IF7raoySsbUlfbW8T8R293TK8CZiEvhaipCZA3Z4lCexZrzcSnDUMp5q+957C2u5Z8dulGl+A==
X-Received: by 2002:a17:90a:e7d2:b0:341:88ba:bdd9 with SMTP id 98e67ed59e1d1-343ddeda0dcmr5440253a91.25.1763000496550;
        Wed, 12 Nov 2025 18:21:36 -0800 (PST)
Received: from [192.168.3.223] ([116.128.244.171])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343eaca761fsm583707a91.2.2025.11.12.18.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Nov 2025 18:21:35 -0800 (PST)
Message-ID: <d919223e-7901-4b1d-bf53-69cd71ecec70@chenxiaosong.com>
Date: Thu, 13 Nov 2025 10:21:24 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: Re: [PATCH v5 12/14] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to
 common/fscc.h
To: Namjae Jeon <linkinjeon@kernel.org>, chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251102073059.3681026-13-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_n3D=CC9DfVTak3oQa3xqkQ2jyHm9sUKDLd=exJAuXJQ@mail.gmail.com>
 <7f061d12-0166-46ff-be38-33f6acb02a49@chenxiaosong.com>
Content-Language: en-US
In-Reply-To: <7f061d12-0166-46ff-be38-33f6acb02a49@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

It seems that the client side does not use FileSystemName[52], so I will 
try modifying it to use a flexible array.

Thanks,
ChenXiaoSong.

On 11/13/25 9:56 AM, ChenXiaoSong wrote:
> In the client-side code, SMB2_QFS_attr() needs to get the maximum and 
> minimum lengths of the FileFsAttributeInformation. Using a flexible 
> array would require more extensive changes.
> 
> Thanks,
> ChenXiaoSong.
> 
> On 11/13/25 9:23 AM, Namjae Jeon wrote:
>> Is there any reason why we can not use flex-array ?
>> Thanks.
> 

