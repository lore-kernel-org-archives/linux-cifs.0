Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4664247F53
	for <linux-cifs@vger.kernel.org>; Fri,  6 Dec 2024 14:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496330; cv=none; b=dHD589H03Rv5DIrJqqKf/0AdjrxqIuK3vUF+4/gDVUWzMCAvdJ6UMCRa+bpc81YtOi21U7mB3BNuOV1052Ls7+yoT27O/9+B+RSjvEy8WKd3JwPyLCGyd+pkH5Kp9lVe1gnPkc+ZMC59EICzNlFOfaUSgrjKRp4XUGg/ZQLPuLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496330; c=relaxed/simple;
	bh=03K0y3+QAQCLIPyXRj6HvmwqtWwDrvNbtJhGQURKJl8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l0cEey+eYoiwTGj8KdPQX53Dw7OJtq3x3cWeY515D9uJghMOQuZKdLQt1fvqUKxKCS18JVINR+BXBoOfE3gj77cyb7nYOgLlFK/2wVuqsvHj7XpcM08QF1xEVAtJLy6qLtmjiEGUhzjowHS9dGzVESes8gEg5+WPRwp/PCtbnsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QBg0TVco; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QBg0TVco"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53e152731d0so2846595e87.0
        for <linux-cifs@vger.kernel.org>; Fri, 06 Dec 2024 06:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733496326; x=1734101126; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQCBmb3u5z+KH8EDBc5f5oRAjDMgMvMOYMttFypBTE8=;
        b=QBg0TVcoAa34oFDB5WhLX0v/4zJrZfz/5bvkCHpTGdomwWXthcxEmS0btyHLt/UFHg
         ET9SBnI9atI9+b6jS+fVArhhrhzG+IQGyTVbHUuop0qL693fR4lxmi0rS5so76TZ7QHw
         5j6X+QwbxEUAsseXr6pvLYryKYeBClSJsbp0D49jqtQvMTKcz/EC1XYvk/2npxmTcyVE
         sZ1K1OB8/AjCpdmpXU3R9FxFbDK+fUTnYLVwTAPSdXaIGvSV2bgwTvc5QWbWXofR2XM7
         sInTLIMkRyXjC6GJIz1efEX5pcnk2sFiNmFQ9/NF4vuqYuUU2MKvC6kEivRSmyPHPh3j
         hJsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733496326; x=1734101126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oQCBmb3u5z+KH8EDBc5f5oRAjDMgMvMOYMttFypBTE8=;
        b=iBYF0F5l/zm4cJt/hRuibTH7ZNTDSvxCWyRcEhD3nzT5eeADHt5Knf0JA47/soZH9a
         rJeDckVnfTfro+N2wUTT65+2ZJbwklWQOupAt6dAlR7f/RmUZlPOtn4YtxVvYToLgjCl
         LQT9n0Iag9TR52WTPUF+dXQiltflcHnl49Amp20sgmnI9XadIsSycLkH57LGA2K926UK
         bLzqM/qvPK8w9H0AYLFTQh+7yqHcB5YepJTD1iu5a5MV6cgxDRPDHh1ddwge482cRe/c
         cpF6ONcblHFzAT8BS3vHj2Yks4RBHOK289gxTmiGK4FiEsS4VPrSVdFw9/V5Qtjtq8yz
         2ixw==
X-Forwarded-Encrypted: i=1; AJvYcCVdpIzy0ZZ7IV71JkJxCbj6utek+bMD7/YA0JqUSoKz+q4fCzDH9axOvbktAV84Gu2BygsxpF1uRxQn@vger.kernel.org
X-Gm-Message-State: AOJu0YzsP3cOhhNEDhJZjVEeFauIUEacFtle3OBIhoVUngnZf6c3EGJh
	94yYZZNTYOJzKe+UZqVdCwGD5qw2cwNG9X7ZuGsJ9I4ll/SmpVRGFuub+03xtD7yKpvNG2eZ0BE
	em/g30dUvr3duktigOtbULCAsZJeQsw==
X-Gm-Gg: ASbGncvEjgNDWtXl/lCVbCqTFV2lI/p8lcBGH/Sa+tgQWaG1bMLXOzhsHenU9pBhB9X
	6hPTNq8B8ZpInASE8beMUuatbldPnu77dA7FZ3L5I8JhOS7nlvAzrn4NUGdi0cmDUrQ==
X-Google-Smtp-Source: AGHT+IFBHJP7kNGLEYMhCX1YiTXq2xcpqRJNSmPuMFWjStfw7kix7aguW6kYPkI+xryzTz/SmWDirp+Cr/EA/tmRV4Y=
X-Received: by 2002:a05:6512:234b:b0:53d:f647:430c with SMTP id
 2adb3069b0e04-53e21916dbfmr2552438e87.17.1733496325971; Fri, 06 Dec 2024
 06:45:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
 <0a8569561645ad202c5cceba02cda93a@manguebit.com> <9e94e437-487d-426d-aa96-3477e95ececa@samba.org>
 <CAH2r5muhai7Jp7feS99RSoP5S89PPzhXatv-akRtv+=Gd9+g9g@mail.gmail.com> <17cb364a-74c9-4403-a1d1-5b5ef1c71e4f@samba.org>
In-Reply-To: <17cb364a-74c9-4403-a1d1-5b5ef1c71e4f@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 6 Dec 2024 08:45:14 -0600
Message-ID: <CAH2r5muWuKBQNb9bF=Vy0YKmybMnTh008ycVeCL+dwrAyLvnyA@mail.gmail.com>
Subject: Re: Special files broken against Samba master
To: Ralph Boehme <slow@samba.org>
Cc: Paulo Alcantara <pc@manguebit.com>, Steven French <Steven.French@microsoft.com>, 
	CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 6, 2024 at 6:11=E2=80=AFAM Ralph Boehme <slow@samba.org> wrote:
>
> Hi Steve
>
> thanks for digging into this!
>
> On 12/5/24 1:06 AM, Steve French wrote:
> > I updated patch 2
> > (0002-fs-smb-client-Implement-new-SMB3-POSIX-type.patch) to address
> > various checkpatch warnings,
>
> oh, sorry for those! I'll try to remember to run it myself next time.
>
> > and added one small changeset to fix
> > mounts to older servers which don't fill in the file type in the level
> > 100 Mode field (0004-smb3.1.1-fix-posix-mounts-to-older-servers.patch),
> > and updated them in cifs-2.6.git for-next.  Let me know if any
> > objections.
>
> hm, not sure I like adding code to support non compliant SMB3 POSIX
> server implementations at this early stage of implementing them across
> various projects, clients and servers. Can't Namjae just fix it in ksmbd?

We will make sure ksmbd is changed to fill in the file type, but we
should reduce risks (where fix is easy) of breaking mounts to existing
servers, especially since this has been in for more than three years and
since the sanity check is safe and easy (ATTRIBUTE_DIRECTORY
will always be set correctly by a server).   There is also at least
one other server that implemented earlier version of the SMB3.1.1
POSIX Extensions so better to be safe when we can do a minor
check like this on the client so we don't risk any regressions, and
it also will reduce risk of a future server bug breaking mounts.


--=20
Thanks,

Steve
