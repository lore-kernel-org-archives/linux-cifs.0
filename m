Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767F012B64
	for <linux-cifs@vger.kernel.org>; Mon,  7 Oct 2024 04:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728274723; cv=none; b=a1ufXNOMqtOcjnaPVfgM8NJ5EU3K5xFWx7WfSCCCHwusdeZ1W/MLSWxUtXmkUgw+r+YPO7WvIj+Ks4a/1y1pYWxkZ/+VpOE3Jh8hmpYJjlUgPxcWHO96IySLHoCTvcHP6QvxJParsRTKzY/rOyhdpeOoAm3cFTZ9TOQiTJ/5MXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728274723; c=relaxed/simple;
	bh=07WoJfZMZb0g6FrxnZzjCSrKGKwQ7tPpE/PVBLpJ+qM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gMcFR5U7CPYMfTrRkAudjucN+BJuhzgagrE7WRm9LQ+YVq6L5fjj1bHJQtJnZozRS4QDtapw32fWL0G0saJdOJkYSFlAxNaZWsfnqtG02TBNcVkQ0ygXZBrpoIdyF9OrFPRD+MhQFk2NIs/hzcOJ9y0cupvEkZodVDDXR1jMLnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ix9l1VGT; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ix9l1VGT"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5369f1c7cb8so4077181e87.1
        for <linux-cifs@vger.kernel.org>; Sun, 06 Oct 2024 21:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728274719; x=1728879519; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=07WoJfZMZb0g6FrxnZzjCSrKGKwQ7tPpE/PVBLpJ+qM=;
        b=ix9l1VGTCanR/E0tAwVarqDNQrdj05Y8QK3/uB1p5kOjGd6+jb7eOmNhIwezqsHSj/
         m3/vSetLNpHvkpZUsiiOPxZIsF0JdrNmr08u4vMNkNTOmFp1PwknqGiodnTLYIrSZ7q2
         g8EIPqNSt8vJApce/mW5H/xZPYm/e9cd1d90PBwb6WWCyNZLnbDZBcWhA7UDL0K2S8R4
         CXDJ5gtD46H6KHBjvnubOO/20Z89grri0/5tcg3uwPwXJRJ2s9Sg3Gi3fiZCKDziwujr
         krCsqfkt/UF0qZRve2tglgkvV/DcDASGz97sGx1pq238HhwHBmUlIY4m0HDBIrhRiit8
         puIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728274719; x=1728879519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=07WoJfZMZb0g6FrxnZzjCSrKGKwQ7tPpE/PVBLpJ+qM=;
        b=m+QEcaOYUrHxdPNQYt8qD6aKaHShEqx7N83U+6w89oALundJLDzQbUqBQaP+liGT7c
         8STSLjIpB7kWaF0Aoi922x6YbgMOjGaaDp88nbmaLZJxqNCihDnqb7sh37Zy6a3q8pSW
         +xnT4yhV6kZM/O5U0CVU13L79Brex8PQSlSNVkLwwwdR9FYk8YSj90kG/IjQ7F8HLp89
         2mZhWpmt4hXyiDunDMi0c0xW4VKJsr5YjOBy4Ed4s6F4q7ftnvIqJ8wp7UU82lllZf4U
         GlVVDs/qJpukMokNVppFrhq527uDqpaizPpxHXBLkxUE7nRsLiLNwk2zBN7fv48rifnY
         nf6g==
X-Forwarded-Encrypted: i=1; AJvYcCVobxRwZ9MChJpXy40jBTH2YBP3UT03mWRYL5UUPf6JkH2ZmzqSwnDlj0i4LainDOLVDr+w2wpsxp34@vger.kernel.org
X-Gm-Message-State: AOJu0YwuVa4rlF2eqyOi4E7s2OJI+zUywZAsBKl8l/8YjwsYit+E7zZC
	WzaK7yoCOzxW2+9C5h02cP2UiHaYW3vx+2q3g6Dor7V+dXy0y/SijLB7x+l20owHMZZpqe4XrBo
	FxIuTmCpPQh1u58OzJ/p+32LGIww=
X-Google-Smtp-Source: AGHT+IF1KAMP0QFYxb5emnXq08rUUZ9473yI0iL1iamBMOv6pwUXJIvcXl1kKHqmPh/KgjZny9duphGnVBsHDpxFJNU=
X-Received: by 2002:a05:6512:ba2:b0:536:9f02:17b4 with SMTP id
 2adb3069b0e04-539ab9cf41bmr4615490e87.40.1728274719336; Sun, 06 Oct 2024
 21:18:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241006103127.4f3mix7lhbgqgutg@pali>
In-Reply-To: <20241006103127.4f3mix7lhbgqgutg@pali>
From: Steve French <smfrench@gmail.com>
Date: Sun, 6 Oct 2024 23:18:28 -0500
Message-ID: <CAH2r5muZcbhy-MbhsLXgvoBCv3kZo_XhgtNPOkMyjEvLFDWbCg@mail.gmail.com>
Subject: Re: SMB2 DELETE vs UNLINK
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 6, 2024 at 5:31=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> Hello,
>
> Windows NT systems and SMB2 protocol support only DELETE operation which
> unlinks file from the directory after the last client/process closes the
> opened handle.
>
> So when file is opened by more client/processes and somebody wants to
> unlink that file, it stay in the directory until the last client/process
> stop using it.
>
> This DELETE operation can be issued either by CLOSE request on handle
> opened by DELETE_ON_CLOSE flag, or by SET_INFO request with class 13
> (FileDispositionInformation) and with set DeletePending flag.
>
>
> But starting with Windows 10, version 1709, there is support also for
> UNLINK operation, via class 64 (FileDispositionInformationEx) [1] where
> is FILE_DISPOSITION_POSIX_SEMANTICS flag [2] which does UNLINK after
> CLOSE and let file content usable for all other processes. Internally
> Windows NT kernel moves this file on NTFS from its directory into some
> hidden are. Which is de-facto same as what is POSIX unlink. There is
> also class 65 (FileRenameInformationEx) which is allows to issue POSIX
> rename (unlink the target if it exists).
>
> What do you think about using & implementing this functionality for the
> Linux unlink operation? As the class numbers are already reserved and
> documented, I think that it could make sense to use them also over SMB
> on POSIX systems.
>
>
> Also there is another flag FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE
> which can be useful for unlink. It allows to unlink also file which has
> read-only attribute set. So no need to do that racy (unset-readonly,
> set-delete-pending, set-read-only) compound on files with more file
> hardlinks.

This is a really good point - but what about mkdir (where we have a
current bug relating to rmdir of a file after "chmod 0444 dir"


--=20
Thanks,

Steve
