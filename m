Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B276D199BC
	for <linux-cifs@vger.kernel.org>; Mon, 18 Aug 2025 21:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755551808; cv=none; b=qcJk3gLv8if0C+ylMSEmJQiofiTZohCCh5v0GcRmPf4lBdSrUkFXsfXEM4ytwiSQd822eHraqcWiub+t71CV5XxOU5gQhUTmYa84LE2lWfbqq1ayDox+oOAVVAuJxajTq3lpQTiZ5/K9H5xt26NXX/TI2rWmNe5zR52+vdrTXpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755551808; c=relaxed/simple;
	bh=N6U2qlmXc5XuYPKuU/vRgiIXy0vnWBkWmdf/jqkTEUU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sR4ZeA1lB+yHjIPeGYvVjLhuHQl4KqmNjFOcu3yM7pCva6VIOKdf6dfd7g+8RGQN6ZDIFFMhBkA0j4LF0mQj4IOvxR1pvVq+UxjPnaPip0AVEZjFkKRHCqEcnBpC6H9YxusuvRaK1Q+/fgfbzsP/ameF8b8scfQq+YPyL+Zg4No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ErkpSITq; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ErkpSITq"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-70a9f6542f7so36311216d6.3
        for <linux-cifs@vger.kernel.org>; Mon, 18 Aug 2025 14:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755551805; x=1756156605; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWUVlv2pojTIZeWyJnueWXNvBqStnI18c1h6l2zfAKg=;
        b=ErkpSITq51itJTsoW32AkyhVzljMbgHkRpXhJ/R2ptzozCq291KO/5lt8G60GjZANA
         I4hmgzm/0SfuRgni08T0prn/+MMj2zoc+wpQQtWoSw2crq84Ex1yWj3mZNUZ1aJyxUGZ
         235gg8FG+VHico1zIdA0sagZAhHPilG2D0W0Lg0GF29Vgv1Ck53O2Q+ejllPbrm3mUZT
         s4lZHZdKP3yb8al/chSmCTMJYuylmVCBTRon9+gM+Ww5Al2chnLN6H6CFuKwhH8V73TM
         oJNPY+HIa2WvFb7TUXWuDb1c8ZGSqZ+WiWyuk1x5sc3wVsTFdynQIzLsmYzsRWpCZnbm
         5tXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755551805; x=1756156605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oWUVlv2pojTIZeWyJnueWXNvBqStnI18c1h6l2zfAKg=;
        b=XnPB4gXrdAbLpGDzeeh8y41vDZACykPm46aWUkV7RHNg8aZMlEcwmfuwfvMxcKipUQ
         kYQ4LQchuqL+IlfcxCcAu6yA10U1g7iY+KcujScNgD0e07oKhYpUFVcYwWWjBYJV+kjx
         T8XH/hL5DorKfyl1ToyclBwnrbuO+4arQ5M8SIKvXTGoXBm149P7bcOeF+LGA8WPTKGU
         vuYLmSB6lTBGCRZusbn0W7FdY2wK6cTKukVQcFF3KYk052jdqkSPiaOGMwdvJ+MNFCe9
         1C3SE5m7G6LBvr6rzgYburalTRCEWE1OdZ7AjQMUK5QGdkoLZeHNzCL3wbUz9XDDpEgU
         6bIA==
X-Forwarded-Encrypted: i=1; AJvYcCWs2y+uhgDzzfbwozpx00HTJZlB1l9u63Du6V9a1xXlUScwJJfRWuD+14bOKL89sIZAotjDVnc2RR1i@vger.kernel.org
X-Gm-Message-State: AOJu0YzQgnVEK8sYOYiN7IAXfCYSsemBeyKse7lzfVwkRCxfUXnZsXb3
	LJoM43LFkuSz/4/Ixt9DrirPfRAYtvyufAF6c1UvkDrtqFzMSdxIzTNHbr6AeIxK0D74M4ox0vr
	gMHCs+eF/kYQ7b9vh2M1HorQUpvbFOBs=
X-Gm-Gg: ASbGncuGvDmSGW9sFHqrOClL6c+47bdf42sAdn9PCxbUAZXKehqacxnYeARwz2qmGn3
	AfmzPd+jT+T6dn7SOmAGLUBef6uc2AiTPIGebMGOi4zr4CgyabmEA4TwnLYGq9FiTFJs/cQycq0
	xS9AN+WvbyCRb1UuOeFztGnvgmuetEXUS5q8HftQ2DvOQZskVPAg939PqSq8yZxeFdrpbaxDJif
	/0nnBajEjnO8G/q1t3cuwiIaiy+4e/fGXr8zDh1BhwLtcp86tz7tNKGROigPA==
X-Google-Smtp-Source: AGHT+IFi2SGje0Y2893DKnfTCa0l25x98OF8buxJoMBcEXDVGk1mEhrTbgDHJ+cDcq4vBzms9t0uvv62umtFCvTw3jk=
X-Received: by 2002:a05:6214:f09:b0:70b:ab91:4c74 with SMTP id
 6a1803df08f44-70c2b6ffd83mr1701616d6.6.1755551805344; Mon, 18 Aug 2025
 14:16:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c2d9d516-d203-44ff-946d-b4833019bfd5@samba.org>
In-Reply-To: <c2d9d516-d203-44ff-946d-b4833019bfd5@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 18 Aug 2025 16:16:34 -0500
X-Gm-Features: Ac12FXwFkrVY-BAQyXvf_oMhH1JOC41sBIc0ewltFj6B5gaoPGgg3m6Mz5kzkEE
Message-ID: <CAH2r5mu_Nm49VaLDvBA_n16MivzUojBBZHwQgS-JNbvL-UsMOg@mail.gmail.com>
Subject: Re: Current state of smbdirect patches
To: Stefan Metzmacher <metze@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>, 
	Long Li <longli@microsoft.com>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	Samba Technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Should I post all patches including the ones already in for-next and ksmb=
d-for-next-next?
> But resorted, first all fs/smb/common/smbdirect/ patches, then
> all fs/smb/client patches and finally all fs/smb/server patches.

Yes, that sounds reasonable

> a smbdirect-for-next branch, which could be a shared ground for
> for-next (client) and ksmbd-for-next[-next] (server)?

I can do that (create an smb3-common-next, and possibly an
smb3-common-next-next branch if we need to distinguish patches for
next release vs. next rc),
but would prefer to wait until we have more of the code moved into
smb/common.  Probably reasonable to target creating that branch in a
month or two
as the common module becomes usable.


On Mon, Aug 18, 2025 at 3:25=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi,
>
> I'm at the point where server/transport_rdma.c only has there
> local structures:
>
> struct smb_direct_device {
>          struct ib_device        *ib_dev;
>          struct list_head        list;
> };
>
> static struct smb_direct_listener {
>          struct rdma_cm_id       *cm_id;
> } smb_direct_listener;
>
> struct smb_direct_transport {
>          struct ksmbd_transport  transport;
>
>          struct smbdirect_socket socket;
> };
>
> All others are moved to smbdirect_socket.h.
>
> For the client I'm almost there I just need to
> finish the move of struct smbd_mr.
>
> Should I post all patches including the ones already in for-next and ksmb=
d-for-next-next?
> But resorted, first all fs/smb/common/smbdirect/ patches, then
> all fs/smb/client patches and finally all fs/smb/server patches.
>
> Maybe we want a smbdirect-for-next branch, which could be a shared ground=
 for
> for-next (client) and ksmbd-for-next[-next] (server)?
>
> So how should I post what I have?
>
> metze
>


--=20
Thanks,

Steve
