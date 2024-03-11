Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1606940846
	for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2024 11:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710155712; cv=none; b=MViTd5nEuF3xZ5xsMkfRO7uAlwGIScG34LHjNl693QsxWhH+Y4qPPAARxY8NWpw0IEXUDpDdcXyoHx+n20olLL5Bvgg2QIpxGvboZEYtvhoJrx7KoqzhhXbcyDjPmkeGvQ0FRJc9sZGhiqFPv5kNBTjx21CBpoZu1qrE0/in+Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710155712; c=relaxed/simple;
	bh=NV7WaJlZY8cJowu6rP1BdugepBnD9TtBVgmojuI2ulo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pYwSDZRfvnNZj+O3uS/REnt6xQ9dsF0y4a6/L1jQSWkPY2oKdyAwZCpjLyyir0Cv2il0I1sBTn/W8YREBTmTo2vx/3urnQENPntNW28eFoxnsQ0f1sxsYLHfFfdbBU/oDOiJ/5C/bX/Nw8ZUfBrJnChd0io8qbpi10BGypX6FJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MwYxPnCK; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MwYxPnCK"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d309a23d76so45117541fa.1
        for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2024 04:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710155708; x=1710760508; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZX/JTbH1IoiGOc3ngSDiJ8E+JC6UZKwvpbxQ5HNkRQ=;
        b=MwYxPnCKwE1ir4EobRNl/kFtpFz68D3Xd9BvTXPA2RpKXCgh0M1daGEQDWhzPiPE5n
         4ZakUad/Zd48fthytgntZuEHAPp20deVWGJG3NybD8+Zcvr4DoPzB4+L2YbJXiQSWlXW
         rNSTKgE9Ho7Oeg1FY6ZNqRpnq/3IaACGNNVFEoK9/TmGsZ2E+uKHCWRQSMbtWAiAVeMt
         YGpXpW0s+NYnz5y+EHDHMpA85ztoA3XAyzSGNbrKBxmltA5CGmwlyL3PlFtNs5PNEe1e
         niOFqYFkgO4bLQSh56pzeT7gzVLhQzH3Qt/CGJsoVviAqj2GcTNQZzyti7jyVvqHzTju
         dKyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710155708; x=1710760508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZX/JTbH1IoiGOc3ngSDiJ8E+JC6UZKwvpbxQ5HNkRQ=;
        b=PBfUfCT/d42SfedKPbrRB82IylW0naLsIo+PjIQdPUnUxsfGg/nn52eUbR29G4rWBY
         /TccfPNKsoQGEa+gA7Sh/Pzm8XmfLfuLXFvI4DmS9D+Jb2LiKw1MzlcvD2PTPpOUP9ie
         VbPpoMRzCTi3jU9QuyPfDNPwTOHHN5LfiNNWuql0EBY5N+DbLCtxYPTUCwRxuSIsyTFd
         NOaZhy2D3+FOdTDR8s0PROIlN6Qpoh07mPxkGp8hxiGyC1fT4SaZSJ46nUutXjdOVrdz
         qCHITr8zYIzVLjz0HXgNyMYP2ie6ekR9puhhFwCBwQUinMdNQd0BBBR5ovfS3n0/hEjt
         ylyA==
X-Forwarded-Encrypted: i=1; AJvYcCVMbjGgeSOWYb+NVvVCbiK9RGUfuJrpRC7y0AdrrfmQkOYWbMsa/VWn3+guYc/cUAdc+peFD3wjwlwmMQQGGaAt3jt0XF5Sg5QedA==
X-Gm-Message-State: AOJu0Yy1nHsJ9CIsqp6g7M+QYlPJuqKMSAN4QsAq5PDtPV8z0FIVN7xD
	HZVWk5TUamY/HNV+/k88kWiGy7AEpWTMSMkLYwNsJ90glDoy4i6cDGooqW77AKM6bBfq6jlvnhh
	YdGop3Nyxukt+dgbD88btDGTz9yk=
X-Google-Smtp-Source: AGHT+IHVjUgP1J1DfBvAuBLY4L2TU665ZEJqZTvB2QuzfMd0XjKAUG/RIOyNXt+ZgE6C9+Q8YMASfqS4PDwcZsiBDBA=
X-Received: by 2002:a2e:9c05:0:b0:2d4:22d9:b01a with SMTP id
 s5-20020a2e9c05000000b002d422d9b01amr2310370lji.11.1710155707868; Mon, 11 Mar
 2024 04:15:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230310153211.10982-1-sprasad@microsoft.com> <20230310153211.10982-8-sprasad@microsoft.com>
 <4b04b2c4-b3ff-48e7-9c24-04b1f124e7fa@sairon.cz> <CANT5p=p4+7uiWFBa6KBsqB1z1xW2fQwYD8gbnZviCA8crFqeQw@mail.gmail.com>
 <2abdfcf3-49e7-42fe-a985-4ce3a3562d73@sairon.cz> <CANT5p=oFg28z7vTgyHBOMvOeMU=-cgQQdiZOw22j4RHO94C3UA@mail.gmail.com>
 <f395be9305cbe75c3171a84e45db42fe@manguebit.com> <3fc78929-2b5e-4961-b5da-6914f2dc45e1@sairon.cz>
In-Reply-To: <3fc78929-2b5e-4961-b5da-6914f2dc45e1@sairon.cz>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 11 Mar 2024 16:44:56 +0530
Message-ID: <CANT5p=oX_d-aZMJLhECU47mqsxz+oeaqqZEzjjVv5pq2gxwtVA@mail.gmail.com>
Subject: Re: [PATCH 08/11] cifs: distribute channels across interfaces based
 on speed
To: =?UTF-8?B?SmFuIMSMZXJtw6Fr?= <sairon@sairon.cz>
Cc: Paulo Alcantara <pc@manguebit.com>, smfrench@gmail.com, bharathsm.hsk@gmail.com, 
	tom@talpey.com, linux-cifs@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>, Stefan Agner <stefan@agner.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 11, 2024 at 3:31=E2=80=AFPM Jan =C4=8Cerm=C3=A1k <sairon@sairon=
.cz> wrote:
>
> Hi Paulo, Shyam,
>
> On 06. 03. 24 16:43, Paulo Alcantara wrote:
> >
> > Yes.  I see a couple of issues here:
> >

Thanks for the review, Paulo.

> > (1) cifs_chan_update_iface() seems to be called over reconnect for all
> > dialect versions and servers that do not support
> > FSCTL_QUERY_NETWORK_INTERFACE_INFO, so @ses->iface_count will be zero i=
n
> > some cases and then VFS message will start being flooded on dmesg.

Valid point.

> >
> > (2) __cifs_reconnect() is queueing smb2_reconnect_server() even for SMB=
1
> > mounts, so smb2_reconnect() ends up being called and then call
> > SMB3_request_interfaces() because SMB2_GLOBAL_CAP_MULTI_CHANNEL is mixe=
d
> > with CAP_LARGE_FILES.

Excellent catch. I did not take this into account.
It is very likely that this is going on here.

Let me submit a patch to check the exact dialect before calling these
functions to make sure we only do it for SMB3+.

>
> thanks for looking into this! Is there anything else you'll need from me
> or to test by the users who are observing the issue, or do you have
> enough information for a fix?
>
> Regards,
> Jan

Thanks for bringing this to our notice, Jan.

--=20
Regards,
Shyam
