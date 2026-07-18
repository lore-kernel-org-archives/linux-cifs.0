Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3386D37883C
	for <linux-cifs@vger.kernel.org>; Sat, 18 Jul 2026 23:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784418045; cv=none; b=qJa19/7UbIWlVU0gMAIG4xzpeqmcGlbvy7a11tdDbRWyncUz6rPfH+0uD9+kgNStJQXCDah0XISLGuuVXb6+FumjommTf/p4rHZnovu9/HZrWask0PNVizrTz2AE4FiXhaasFKsVWp5I6IGiA5CU0GIFoeCLczbmm0EXpLfR/bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784418045; c=relaxed/simple;
	bh=6tTaMeQFD7u2U43Y56raK5ishGDEQNy1sGMn6YzHJjA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Sau16q5ytfs9/hAEOpAEr/x/m9BJ/TIGJOfZtPaSgIBfamq+DgplrLwVzb2dAB8m64YAPG7OSPs+JRjUT2abz4EI4t8cjrvz/gOcA4+1wafAOXARo3xiYQk3TCvMQpSbyYiIkMS39unLqr5/k/BY91wHRH46RfECC3YDOJQevu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kHTnYQXb; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kHTnYQXb"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47f7027ca11so203661f8f.3
        for <linux-cifs@vger.kernel.org>; Sat, 18 Jul 2026 16:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784418042; x=1785022842; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6tTaMeQFD7u2U43Y56raK5ishGDEQNy1sGMn6YzHJjA=;
        b=kHTnYQXbOuqLJ6DpwhLjIpnGIoqTX+dCf6Fn1oao8M12OlAV2Tdr5pKzAdPVsWtfdb
         8Fkx+Z7UsekddGq9rlfusZ/IjBvcf5YIJp4BDtdgsDywwdGh9iJMcUtowZuow2ZUZ/S1
         UahfW6UTVsVI0wA9+0cH7DxmvMZpAY2AV/uvOJUjTUnLCZTmkntIM8YS4aOYMHfc7R7D
         5d0+O6gLZisL0Q3rPV8zTgYhLYqHJehqM3DJD5kAQYx4P5k2BEXn0RBdc4bcu4hYvv4a
         sKlB6PSnFpqvuW5H+jcZ7ipnTUSEibWqWrelHx2UaOiPnrRqOqhzzPG+mJhNVg8rf8rW
         SFxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784418042; x=1785022842;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6tTaMeQFD7u2U43Y56raK5ishGDEQNy1sGMn6YzHJjA=;
        b=nh73PZl9OtHg5VVSBSL7akE9h/vizOXQAGtA5Ff+h8hiqRX1Eni4XnjBFzI+XyxyWZ
         TR8GW++dZYmwC8tQ9xSvmBRdWrH3A8mBFnjOjhywbnchKg3Cqc8Kc09H3PkqdCHVAWH1
         GkUry+sVLw7+1j6yuPeIIDkvzLqtuEw5c8j7IagvCuDvLYBpL5joCpIow96MreTk8DGd
         Dh+RaT5laWhANIDrEoXcBCmGEWL2VueIK33zrk4cE9nrUiuYi+dysePkFL/+UMuu1RII
         aEpwyyCIiV0mXnL7Z7zvN4lANG2AP68Ee7UBr4DovV2LF27QdMNWsFg27QMCXQj5Z9zT
         SGsg==
X-Forwarded-Encrypted: i=1; AHgh+Ro8I19aT26RJNG3I0XXg1/lNn7eiwB6uens6EKwTS2+95pQvzOpLgrE2BBdJrng/9U5Pc5I0xloQeYP@vger.kernel.org
X-Gm-Message-State: AOJu0YwGM7V7fqOnYrwX1Sm1lPAYCNRqNOkEuPnIj241lvDuqXQBf2tq
	hunEUhruZeNj1QZLjbC4JnnUUnvPhmmjj7e7bacBWHQRVNGH5SeFV5Bo
X-Gm-Gg: AfdE7cmWMEKVs+TwOse8+mpMEV+EYYuW8TJHfd5NQF1I6FpuA7MZmOScrEWX4DX8oy9
	jY0plT0jcq8JN9Defh3JyhnmhW5P2qzpaekNTAFdnxrt/y4WBLZzdbWxdyhaPZK2hMq+PNWVvkA
	6zbCqnwJRP5Qc/dmC89+4xQoFMyjKwuOduHcpVxjKpNSxfpAdAoDkHWMqUbox13DpehCxsZJKQR
	dkOkHzTqwLMsLFsceXDqRI64KfSYFNrWTQn/babcfgABjmQxqXQCwOSWsTu8aa5mVMlsWwGzLHF
	RRMxs7/qkiUe6P1nsy+y+xX9JhLp/HGR6ztwVuHW52EUhlvxqMpNy9Y5dlbaG5Ggb57qwxaHdQu
	X12WbSIfedi4WtNr6TD2vM1KYJHkie1pAv11o1ZZWrqQ+df8dt+IDv+gJq4SbnBzHePqN4sfVIX
	1qRQRq7l+x669M9bl+ahSwmILFJrRgC3XnHQ==
X-Received: by 2002:a05:600c:630e:b0:493:e6f7:ad75 with SMTP id 5b1f17b1804b1-4954a3dc687mr91408505e9.11.1784418042290;
        Sat, 18 Jul 2026 16:40:42 -0700 (PDT)
Received: from smtpclient.apple ([82.67.171.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63e519f4sm15546887f8f.14.2026.07.18.16.40.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Jul 2026 16:40:41 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 0/3] smb/server: fix some bugs in preparation for change
 notify support
From: =?utf-8?Q?Ga=C3=ABl_Blivet?= <gael.blivet@gmail.com>
In-Reply-To: <CAKYAXd8-ZSbyU8NPCBYCVrExRJiRdn=y0mYbc71sSRqD4LoYAw@mail.gmail.com>
Date: Sun, 19 Jul 2026 01:40:26 +0200
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org,
 smfrench@gmail.com,
 pc@manguebit.org,
 ronniesahlberg@gmail.com,
 sprasad@microsoft.com,
 tom@talpey.com,
 bharathsm@microsoft.com,
 senozhatsky@chromium.org,
 dhowells@redhat.com,
 metze@samba.org,
 andriy.shevchenko@linux.intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <70B82D7E-4699-4C9F-A1F3-2B51C61BFD20@gmail.com>
References: <20260715135513.667260-1-chenxiaosong@chenxiaosong.com>
 <73f4bc4e-3bdc-4bf2-b145-c9b6fc480451@chenxiaosong.com>
 <CAKYAXd8-ZSbyU8NPCBYCVrExRJiRdn=y0mYbc71sSRqD4LoYAw@mail.gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
X-Mailer: Apple Mail (2.3864.600.51.1.1)

I have a draft for the follow-up patch that I am testing but I am not =
yet satisfied with it as live tests currently show workers being =
permanently wedged in smb2_notify().
I'll need a bit more time before sending it.
Thanks!

> Le 18 juil. 2026 =C3=A0 06:51, Namjae Jeon <linkinjeon@kernel.org> a =
=C3=A9crit :
>=20
> I have already merged your patch ("ksmbd: defer CHANGE_NOTIFY
> completion instead of STATUS_NOT_IMPLEMENTED") into the
> ksmbd-for-next-next branch. Please use that as the base and send a
> follow-up patches to update the implementation using the
> approach you and ChenXiaoSong discussed.


