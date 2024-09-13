Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E487974402;
	Fri, 13 Sep 2024 03:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726199095; cv=none; b=pXCaQwRV9muO5vnyRDsZfhxyxVXJYQGyvnGkRilpSmw2HhOnF0XlUZLQ54T5QMh9t5EgCi6K1fcziP9RTl00TYRgltk9KEhxH/c7jTctksrMQzduwahrv2QC6F1WhYXtyev557f0FKFJvPWajNaj8tRdP/cCaOpQJ0355qPk/Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726199095; c=relaxed/simple;
	bh=K8tPMqcuYmOZKjAw2eVx1Vvj7LMyLT8twg4BRDnl6Xc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DxSOJ3MT0lF+aVXm1BhpgmzAS6aM2opCPMQWwRMdSj8qjcG/JLtl/Z+POOiMvvCIRnVo+gUqnZ/OskAuqt9gPMC3egZuS79O0YAoXKi859eWSjE9eN0FAzxyUNy8lPH2Et5smM+cndXZ5yrx1u64E1RK0n8oHPiRyZ+1qVSCFxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lwjy9V8t; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lwjy9V8t"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-53653ee23adso1557032e87.3;
        Thu, 12 Sep 2024 20:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726199092; x=1726803892; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bdjdqStA4bP/m6JmL9lff105JkiRrmFWiXzLbSHHHdY=;
        b=lwjy9V8tF9vvpMp/IMvpINeHRpgRpuOnGOm8FpWRzYyefrRrkAmrXcD38OhSyDfKJy
         cO/ApmogdJnfy8BjeIoB2cNSse6Cmif7Be9dYNFyDW8U3pjxoCQGn7GG5bxQFP/rHHqd
         QWmQlyrNwVeCZ2jum5vAVE63F80KHd942mo+YCqIbk3NstzpBSoHhfJiuTo1FpW81jSu
         QQ4BxieZKC3NgtkbfHpLKQj4jeTo1wEcpRTfvi9rjAcSl7h1EZNYh/CU9RQlvcNThOHR
         3P+bBNTwPwOKhKSVCCqeiheD8BEhXzE1ENEX2fuZ+190t2PBNXQUyeQoISyPu14iIfca
         2C0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726199092; x=1726803892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bdjdqStA4bP/m6JmL9lff105JkiRrmFWiXzLbSHHHdY=;
        b=kHJ4EDmmNg4qhXUEqmHbPsCy8hQvB/6epeRWt5aq7e9B//v0Uw4gMD0YyKPrnmwdQZ
         NxVwwaAxdETfgZrNZ9Ik0oEzuBgdRNitkUOx87sIHCkaShkxIjKE4H2X0v+4ZsohhPb+
         P8iHaL6UFfzipMfIF6P/nqEPcxc2odsbmhoj/Fec1YEAqidjRkatBLaBKVnIAP5ijQnP
         z4dpQ2jciWAsx5Y9hFbKG37zzRJpGqHbS0fGccEXPgG1gQLKYPlz9Wxxkz1fQL+63TWn
         UesllVafL9d4beQVKlAPAi7oRTlLJ5ucufaMkSAihgGjzA5A4vYMXhdLViuYxA6gmEux
         JG3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVhOzot9pmIvTfGhl83sC6iENboV/MoQLBjgGmXj6TcrK/2c31xCpk+mwl+Q39HJwOt5lABeW3k8G47Z41D@vger.kernel.org, AJvYcCXI4DPb0ijfLa5uu+D62Uy6NoWzwtmdM7kL62hh6/ThxdnK+a/NazV8ThYzJvnPnRdON4F+bARk64UI@vger.kernel.org
X-Gm-Message-State: AOJu0YxzgPq4wwQCEq7eP2s54n13H1CdXGE7/AuDAJURThHJBpPLhyR1
	b2HNVC/2BSW6yIg79obDin6iADY0uUQ+SgpxJfyvSsewT5puE81xp/UIl1MFnD0IyrzrXUq7tvQ
	tKLHewQXpoiMabPPlB1UHp5ajrNc=
X-Google-Smtp-Source: AGHT+IFrfBTEIS7roOBWPAV3uk8zEZLQE/yrq3co/ANX2Gd+9fPL93YYP7Ow+sHjcnSEgbKSQMni2L1rCZdb+zmaf1M=
X-Received: by 2002:a05:6512:b03:b0:536:53c2:8179 with SMTP id
 2adb3069b0e04-53678feb22dmr3064017e87.37.1726199091522; Thu, 12 Sep 2024
 20:44:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912120548.15877-1-pali@kernel.org>
In-Reply-To: <20240912120548.15877-1-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Sep 2024 22:44:40 -0500
Message-ID: <CAH2r5msLPA2RB14dm2orqFoRQvUj2K2ZpCeeiNKMGVJpQLsU0Q@mail.gmail.com>
Subject: Re: [PATCH 0/7] cifs: Improve client SFU support for special files
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending review and more testi=
ng

Do you remember if there is a reference to  sections of the protocol
documentation that can help confirm some of the changes?

On Thu, Sep 12, 2024 at 7:06=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> This patch series implement full support for SFU-style of special files
> (fifo, socket, block, char, symlink) and makes client cifs's -o sfu
> mount option to be fully compatible with SFU.
>
> Before this patch series, kernel cifs client was able to:
> * create new char and block devices in SFU-style, and detect them
> * detect existing SFU fifo, but no create/mkfifo SFU functionality
> * detect symlink SFU symlink, but no readlink() functionality and
>   neither no create SFU symlink functionality
>
> And it was able to create some SFU-incompatible sockets and fifos (when
> -o sfu was specified) which were not recognized by neither original MS
> SFU implementation and neither by others.
>
> This patch series implements missing functionality, which is:
> * detect existing SFU sockets
> * create new SFU sockets
> * create new SFU fifos
> * create new SFU symlink
> * readlink() support for existing SFU symlinks
>
> In following pragraphs are some details about these SFU special files
> which usage on Linux has to be activated by -o sfu mount option.
>
> SFU-style fifo is empty file with system attribute set. This format is
> used by old Microsoft POSIX subsystem and later also by OpenNT/Interix
> subsystem (which replaced Microsoft POSIX subsystem and is part of
> Microsoft SFU). OpenNT is previous name of Interix versions 1.x/2.x.
> Microsoft POSIX subsystem is available since the first Windows NT
> version 3.1, and it was replaced by Interix since Windows XP. Interix
> continue to use this format up to the its last released version for
> Windows 8 / Server 2012 (part of Subsystem for UNIX-based Applications).
> Hence these SFU-style fifos are for very long time unified and widely
> supported.
>
> SFU-style socket is file which has system attribute set and file content
> is one zero byte.
>
> SFU-style symlink is file which has system attribute set and file content
> is buffer "IntxLNK\1" (8th byte is 0x01) followed by the target location
> encoded in little endian UCS-2/UTF-16. There is no trailing nul.
>
> SFU-style char or block device is file which has system attribute set
> and file content is buffer "IntxBLK\0" or "IntxCHR\0" (8th byte is 0x00)
> followed by major and minor numbers encoded in twos 64-bit little endian.
>
> Format of SFU-style sockets, symlinks, char and block devices was
> introduced in Interix 3.0 subsystem, as part of the Microsoft SFU 3.0
> and is used also by all later versions, up to the Windows 8 / Server 2012
> (part of Subsystem for UNIX-based Applications) where it was deprecated.
> Previous OpenNT/Interix versions had no support for UNIX domain sockets
> (and socket files), symlinks or possibility to create character or block
> devices (but they had block/char devices in-memory, returned by stat()).
>
> Microsoft NFS server up to the version included in Windows Server 2008 R2
> also uses this SFU-style format of special files when storing them on
> local filesystem. Later Microsoft NFS server versions (starting in
> Windows Server 2012) use new NFS reparse format, which Interix subsystem
> (included in SFU or SUA) does not understand.
>
> Even SFU-style of special files is old format, it has one big advantage,
> this format does not require any support on SMB/CIFS server of special
> files, as everything is stored only in the file content. The only
> requirement from server is support for system attribute. So this allows
> to store special files also on FAT filesystem.
>
> This patch series makes cifs -o sfu mount option compatible with
> SFU-style of special files, and so compatible with the latest SFU/SUA.
>
> Note that -o sfu is by default turned off, so these changes should have
> no effect on default cifs mounts.
>
> Manually tested with MS SFU 3.5 (for Windows XP) and MS SUA 6.2 (latest
> released version of Interix) that interop works correctly, special files
> created by POSIX/Interix application can be recognized by Linux cifs
> client (exported over MS SMB) with these patches (and vice-versa setup,
> created by Linux cifs client and recognized in POSIX/Interix subsystem).
>
> Manually tested that old Linux 4.19 cifs client version can recognize
> SFU-style of special files created by Linux cifs client this patch
> series (except socket, which is unsupported in this Linux cifs version).
>
> Patch series is based on the latest upstream tag v6.11-rc7.
>
> Pali Roh=C3=A1r (7):
>   cifs: Fix recognizing SFU symlinks
>   cifs: Add support for reading SFU symlink location
>   cifs: Put explicit zero byte into SFU block/char types
>   cifs: Show debug message when SFU Fifo type was detected
>   cifs: Recognize SFU socket type
>   cifs: Fix creating of SFU fifo and socket special files
>   cifs: Add support for creating SFU symlinks
>
>  fs/smb/client/cifspdu.h    |  6 ---
>  fs/smb/client/cifsproto.h  |  4 ++
>  fs/smb/client/cifssmb.c    |  8 ++--
>  fs/smb/client/fs_context.c | 13 ++++---
>  fs/smb/client/inode.c      | 42 ++++++++++++++++++--
>  fs/smb/client/link.c       |  3 ++
>  fs/smb/client/smb1ops.c    |  2 +-
>  fs/smb/client/smb2ops.c    | 78 ++++++++++++++++++++++++++++----------
>  8 files changed, 117 insertions(+), 39 deletions(-)
>
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
