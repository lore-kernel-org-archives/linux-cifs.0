Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442E11B2EE6
	for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 17:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261755; cv=none; b=bOgdWeyPrbb0l+e/s8lNAjBbYryqLAN/d3VnVypcfbxgKyDxHVLI0z0JTELqMaag+UsFvtgVE6Q+ZJUQ2y6UbgMpqmwXxoJ7SqATwEXzvbk9Ubb87wtfoN3F3fH1H4pCPM9jUlVClsFTKDG3LfB1Bl86IK+p8tHZM1c3E2/PhUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261755; c=relaxed/simple;
	bh=PhuTfmbz9z7XR6XarjyeOlpo2Yu76s70LUvF9M3VNmg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qAa2rHR/F6RBrbli3O5UnA+T3SK3HHMrChEQ1z4NHpq36ZIe039qJluQjyNeFPLcuPzDoRuvg94y2CJ6ZCDbL6neZUvSISCzB6cnk5v3y/6OyMJA/kUan0+7Xng/hw29DvhhWF2ichFP03cfvF9uaXEr53HZ6wv1QaNNUrH4sWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MSFJJM09; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MSFJJM09"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5334879ba28so1247012e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 10:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724261752; x=1724866552; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vwGKPR9dScyEf6RIlTCNqkBAFknVGBL0G4lRztfOGK0=;
        b=MSFJJM09kH/oy9Cc8/DLc8bRD0+GB96eAkE4hvLdePx8+uBCTx4Zp+o77dcTUMohq7
         5SRsPFabBRYolzfTsKKGSupDhSmM0/1PvrtXe2H6U3fqWQiOfpTNiv91roZ/7bmAY9+V
         CUJpi8MCA+h8JQWLGNjuGBEhSiz+DhHK1dx4n1nxLk95B3u6NqUU90kdZS62md3QZn2K
         A5bK+52t6E1l18dohJRZYf7EvhfWUWjeqIhHOyiQemdcHuNU90cAKkFHyf8o8eGW16Jr
         JJZLpr15Q6sg9JF4HVnF7OYpbTPSFBVxB1WSCGp3mDOI0aceKH6UW7XqFMC2//zAG+pG
         xc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724261752; x=1724866552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vwGKPR9dScyEf6RIlTCNqkBAFknVGBL0G4lRztfOGK0=;
        b=QVjRSlKvAyppjmJKnqlo8STSyLGVThVxtep+kkKbT9j4kzD2Src0FootwZCJcv8KI1
         7eS2QHeezHCzQKXlywc6JcWsk2FXj1yr4aZ0iloGvU2QyTERNKdc9inTegdFyeb3e2KE
         Z5PWoCCFf1uAz/lofdJQZOirtLlTN0qJrJF5CIoLEvQb0JRWVk5EK4+JQvssCX/P7HN7
         dD5wI19NVgpjXEdQWZ6kqq6XTbqjRBkK14sURE6fQvF2ioZUIJnrHjrhevgm1tVVH+70
         Raq66t9+FkrxXeS7sdlJ4xXAW0gcudX82QrMbH6Lx+QPBfsooV7/vZjSHiWRD6BuaY07
         Nwrw==
X-Forwarded-Encrypted: i=1; AJvYcCX17k6QYABmLjirmMuR7r0TxYCXAA5PChv7x3xd+b2/w+1CMSlXNg36Tl6VhGxW1NM5hOc3Ye32QSRD@vger.kernel.org
X-Gm-Message-State: AOJu0YyPjeXeRnfN4JUbfe1by31DOPCasLnEqplKeLLuaRP/PITBgySB
	tN+QZUUlb1UwcV1gDBG728VEWcaqCkWSg3x1efPR8CiJqtxzz7MM+Uf3X+ZWHByxdX42nlhwkjV
	+p6BXmh08reZ2m9Zl4HQ1lTcQmvU=
X-Google-Smtp-Source: AGHT+IE9XAgPiD6lsAiAE5ZEFlqHmA0fIxRHDUJRB057zPRD7NZpTgiLXjh3OvaSEz1WN1GKPoqf8MG1hKeZ9J4bIrI=
X-Received: by 2002:a05:6512:2214:b0:52c:8aa6:4e9d with SMTP id
 2adb3069b0e04-5334855e05emr2626320e87.29.1724261751977; Wed, 21 Aug 2024
 10:35:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtUTOFgaQMbsWwkAD-XDRiVwyAGT=Q7n9i5Sd6Wf=9q+Q@mail.gmail.com>
 <f1bc4bde-f1ff-4b52-9cf4-822f94b31a75@samba.org>
In-Reply-To: <f1bc4bde-f1ff-4b52-9cf4-822f94b31a75@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 21 Aug 2024 12:35:40 -0500
Message-ID: <CAH2r5muFV2+SXhGmkv5WYawtAyzK0D6y5hFLS4x6542cUwjACg@mail.gmail.com>
Subject: Re: Samba server multichannel session setup regression?
To: Ralph Boehme <slow@samba.org>
Cc: samba-technical <samba-technical@lists.samba.org>, 
	Shyam Prasad N <nspmangalore@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ugh - I can't reproduce it now.  I added an additional test user
(smbpasswd -a) and cleaned up a few comments in the smb.conf file and
interfaces line and it works now.   My best theory is that it was
triggered due to minor difference in the interfaces line of the newer
smb.conf

If and when I can reproduce it again, will send you a trace, but when
I had looked at it before there wasn't anything obvious in the session
setup on the additional channels that wireshark decoder flaagged.

On Wed, Aug 21, 2024 at 11:11=E2=80=AFAM Ralph Boehme <slow@samba.org> wrot=
e:
>
> Hi Steve,
>
> On 8/21/24 5:57 PM, Steve French wrote:
> > trying to setup additional channels.  Any ideas what changed?
> can you show us a network trace please?
>
> Thanks!
> -slow



--=20
Thanks,

Steve
