Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5361641220
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 23:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JDjsQFKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC7FC433C9
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 23:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701820083;
	bh=5haMR6z10LwAOwz3Tsgh9GHuu+CZhIvtF+q3fYjk5Oc=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=JDjsQFKSdDZ3KN5McafVlUhX4zob3BuFxFNTUM7tEW/39sUeJZY47zbqnzsNsguZN
	 tsV5sMN5cRS8YG11g7zG6XjLMPJeWWMztDtLsU538zKAHE7UxPuQGx1WvNr4oSA/SD
	 HMPTn3sj3zot0WbBcaE5hy6vt3SW4UwuWjfVgmDxeP+A0qvHKEbN8TCyuBki5cZwJ3
	 EIVpjcsS/Nj2yQayPZ9IoWqKN8PVDS3yL4Oy5oFf8ThWalb+wYOKZOuKwDBrpLqzKT
	 UYxz8jMPaVpUIm87F4NvfpqmFi/mQB320yUrXN6BwSH5N9MiVTSCk3VE09k/zM/VC8
	 dKHtMf9+8ep7Q==
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-1fb04b2251bso2930374fac.0
        for <linux-cifs@vger.kernel.org>; Tue, 05 Dec 2023 15:48:03 -0800 (PST)
X-Gm-Message-State: AOJu0YzecoWO0C5QnPci8fdPQmufL3PYusHgim698t3SCQ9f8ozPKh9K
	EjlXnX00kSswkG9TzvIO2p4Qd+HYuBm1rQsO43g=
X-Google-Smtp-Source: AGHT+IGLUX8l5j/S/fZgLsr0lFIdYu0vrQ/Oo28txNFc1zOl3DhBkxBJGMHYVqofCO+o/yKrZSN+AwBKhd31fzPT0Qc=
X-Received: by 2002:a05:6870:8e0c:b0:1fb:75a:de69 with SMTP id
 lw12-20020a0568708e0c00b001fb075ade69mr9264911oab.87.1701820082923; Tue, 05
 Dec 2023 15:48:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:5a85:0:b0:507:5de0:116e with HTTP; Tue, 5 Dec 2023
 15:48:02 -0800 (PST)
In-Reply-To: <e20433c2-82e8-41e0-aa29-279dd64996fc@samba.org>
References: <CAKYAXd9-61f1cjXMrovSEdio8fuTSbegfde4FZ9m1DAAS+CxRg@mail.gmail.com>
 <e20433c2-82e8-41e0-aa29-279dd64996fc@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 6 Dec 2023 08:48:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_m2OTmh_DyYSULXiMDPNzG-mWZRhB4oZXsCZ6saaTdrg@mail.gmail.com>
Message-ID: <CAKYAXd_m2OTmh_DyYSULXiMDPNzG-mWZRhB4oZXsCZ6saaTdrg@mail.gmail.com>
Subject: Re: Name string of SMB2_CREATE_ALLOCATION_SIZE is AlSi or AISi ?
To: Ralph Boehme <slow@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, 
	Interoperability Documentation Help <dochelp@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

2023-12-05 19:01 GMT+09:00, Ralph Boehme <slow@samba.org>:
> On 12/5/23 08:48, Namjae Jeon via samba-technical wrote:
>> I found that name strings of SMB2_CREATE_ALLOCATION_SIZE are different
>> between samba and cifs/ksmbd like the following. In the MS-SMB2
>> specification, the name of SMB2_CREATE_ALLOCATION_SIZE is defined as
>> AISi.
>> Is it a typo in the specification or is samba defining it incorrectly?
>>
>> samba-4.19.2/libcli/smb/smb2_constants.h :
>> #define SMB2_CREATE_TAG_ALSI "AlSi"
>>
>> /fs/smb/common/smb2pdu.h :
>> #define SMB2_CREATE_ALLOCATION_SIZE             "AISi"
>
> looks like a bug in MS-SMB2: they have the value as 0x416c5369, which is
> "AlSi", with an "l" like in "l"ake.
I will fix it in common header of cifs/ksmbd.
Thanks for your check!

>
> Adding dochelp to cc.
>
> @dochelp: looks like you have a small bug in MS-SMB2. :)
>
> -slow
>
