Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BDC41E6BE
	for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2026 21:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784065406; cv=pass; b=j45tCFSKhVDvcpa4sP1WQGMvV4880nd3s46RAKXhMMtG25wTooucWIBWgo7VvVk8Q9a64O2mE36ZkFN2ZPJAze3xXeKFjdhlw8VaEIMCcStNZGh6h7lzePb3Mz33QrfQey9Z24DJzrAdYIg2UaR/Uv4dN/5psXaacYpqra/f8zg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784065406; c=relaxed/simple;
	bh=4aQTdtO8KYad2za5eRHJV5vDJ+EA563EbVWpaDplWy0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DnXTJv7GO7d3iTl2xj5+m2pw5iEae63+izT9PKL8y1r4A8Ng9BHdYPwl+8kZd6buZL2au3Tp8CrZN7e1rHn2lNu+hRS4hmddzCrJKBLp5+VnR6+31TSiGxlE2l7ive146uFPl4yBerpp5jIh6bIRil0dY+mqpq83oOskQ22HOyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ck2XzSsp; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ck2XzSsp"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8efbafa1bacso40492696d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2026 14:43:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784065402; cv=none;
        d=google.com; s=arc-20260327;
        b=e3bxiBSCJRy/Lude92qbq+KejchskzN4h7BJog1EK22/mxO4mCAFVz4fgu3N/w46zp
         tFuJJ/HKhI5uTpDJOmIWPznqgcowEn+ERZzF91D3TT8iHLdzpZrDpY+na83J6pE53th4
         TJnFg/DCyI5QrC2boyOTV0q5IqEowgQzVuXRKROT82WYA+0GdyZjoFtRbewi48yuq91z
         P7FKjAMCn2s+ISIMPV5IEEvoOO8E4DyMj7RChurZKEoEdfh/6IzeEEqWuVELPeTeyHie
         Sf7t69Lj5tCERl9rXNVkbYggTUzO15fS6UaDJNN0NQcEvn+/7BE0l+Mxmpf1Yq6XEMq+
         12MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ce642oQbZs1xv2ArVXz4HBvznk2bFGiA93O2rqosIw8=;
        fh=AGgSXgqSwbLT+OgQKlmvjkOiEBp7oG/I7ynIHbw8z6s=;
        b=V3LpqRfinDMg6rwWQzokMNUaiUB53q1TFLvZtKZfEirZh6w2Zem5GG7noufcQOTLzM
         N0YTbL7zfTgxgOGG4qhe9wcmpRcQNERT7qrOacTyeKTaKtCRXdiCppFiXJ5LFrT1hdBn
         VOZ63IDuyyS8v3IZX8NA2E7gNZ0+L5G6k7eEIYWnlGgcoYKFfCGWiR3/F39EKfXi6nvI
         wLdJpNTSLyAeRC2TtIRFZTgYspbA5cbRe2mWf16+cI2oFbCKiK5w7MCA7R/5FN4QsZb4
         tW8lvUWWRCufKj5xTMZ3w5CLqlbo8K4COiB3/YInmt6QvGnBlu2tGXqIF9ZblcdqFt+L
         4hHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784065402; x=1784670202; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ce642oQbZs1xv2ArVXz4HBvznk2bFGiA93O2rqosIw8=;
        b=ck2XzSspYwNM4eJ51SHo7NHV2Amqvp6V9bFrF5+WZ5eUqOQGc9qk62BrVhjp6QAyQ0
         rn7U7Qd42bjIgQnLLpiaD0k9tvch8qhJYixCe+KnzQtc0Ve4ba8tVCsGd83PJT8091eL
         1tjEbJJ54/SJUjIAEqL8WaC0ljzKB5IUxwQbsZeRS7LE169DR87rvTYHHaJ41AMxDOeI
         Xz2lZ95Y5i5hj83OxF6Gc7OBXlKthbgw2FAy0eWFPEQu4NeXAg2R9FuJduRBI5wUX+Yo
         NJ1P68lVbQJKGoCkP805LvZUWcEaKvzB+NhFJykqKj/FEVzc1fq7qaa4V+RPDnHg0FUt
         ZX8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784065402; x=1784670202;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ce642oQbZs1xv2ArVXz4HBvznk2bFGiA93O2rqosIw8=;
        b=tPtyInYW6SZADawZ+aJs+FuTiNH4tY2Jzw3/wleriiuf+KFS23RoLC5Wuzlg/Btc5Z
         jzLIsNTzQEDH8JypjHlevwyNwJHou5MNwlEyRp0cQMMqRNlRcDG94k7I3+Ra9L2qEWm6
         QR3yovyizC7SK9lY9QyD0de9dgiPDmPR43hzJJLuzVLvtXCevIxqbfyXRvDulaKQTlKl
         hcM4aPhRiWIF1BEiVaNCf41tYxLbwLVwKSl3ohkw/YXcMUrq3LVdvFsoKd1IJaMAySDM
         FZdF64bRCVpYaj4SxByS3tq0EFUwD88aOrEWpvQc4UF2sE0lq4HQrFHQ24C0+0uRR9qQ
         d/Sw==
X-Forwarded-Encrypted: i=1; AHgh+RossKsbIuLGXfJ0H3RQ1im5uf13fROurxLL18ZRYfAfFVtrEM2a8kttP0A+xbEzmbG1CxDZ2ibhBQop@vger.kernel.org
X-Gm-Message-State: AOJu0YwxZaOs9e+qu+uhwQppy2zt6Y1UjHQJCaphXTTCy387et8Op9LQ
	aCbmd5sNBH1qmZOjaXRH8yNO+sDPjpukKEdfZgNr0Y9W63DmRAdDBxhhYwKdH7i17c2KpshKF9z
	K8vEuQmB11pkAJ3175sGxBTheaEn57Ko=
X-Gm-Gg: AfdE7cn6r00CEHCLVEfkCvr0YdrT64LrbW67xWFrtKhoxypQzt6myI7cFoW8G2bntBl
	seF9MhKn9SUhKH9sSKtGIfvHicA4QZbyJ9LLxcAmw0rOvOfsrzpVi4X/VfsPL/mLiGbSb4BZoHo
	ZFoQWUAP5d1fqa5fcqXxJsGhzeL0pMPhDCOeNgLXT97KGA+6o5+WpX6zskFJAI25g2aWC3v4C97
	XCcyE1v++4MTaD9pY1VfY8B3EIBPq8jYB5ahUhD+dbAnLUB6uGnot15+lxTfIrbAd4A5hOL1KQG
	7EWWMLDyQAb/qOdwY670HumLW2n8tfh1DGgzYLVB3CGVGAZ6CCpREVfRI8qmfRYbKpIU6LiDwli
	TMTKeSC6vwUcP1lUrfmHQdDQ+giq7Kxgz6fj7ocMsMO6MRfKLMvfUIJ1ImZ9HmATkPSYHRjcdsd
	/eCZw2TrqzrQ==
X-Received: by 2002:a05:6214:5c0a:b0:907:5613:96ba with SMTP id
 6a1803df08f44-90758cbeefamr4194226d6.1.1784065402390; Tue, 14 Jul 2026
 14:43:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709155440.2132459-3-doebel@amazon.de> <CAH2r5msvEGdEJvyV5sWcZjQ0SjMOwXP_Ad4eKN7etHtXS1vwbA@mail.gmail.com>
 <FR5P281MB509177A7DE157E6D72EC05B3CFFD2@FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM>
In-Reply-To: <FR5P281MB509177A7DE157E6D72EC05B3CFFD2@FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM>
From: Steve French <smfrench@gmail.com>
Date: Tue, 14 Jul 2026 16:43:11 -0500
X-Gm-Features: AUfX_mxGET6Hzdo3BRy4X2zGh1cwSMHd2R3p0A5ZfqRGr6sFuXPsooE4k766PEY
Message-ID: <CAH2r5ms-_Z1c3twqt8i_syyXpi1jtBJm15GuvRhUXEk8BVwAQw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: set SB_I_NODEV to prevent device node injection
To: "Manthey, Norbert" <nmanthey@amazon.de>
Cc: "Doebel, Bjoern" <doebel@amazon.de>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

If this is needed for cifs.ko wouldn't this also be needed for AFS,
NFS, CEPH and others?

On Tue, Jul 14, 2026 at 11:23=E2=80=AFAM Manthey, Norbert <nmanthey@amazon.=
de> wrote:
>
> Hi Steve,
>
> The issue is that the client takes the device node's mode straight
> from the server. So a malicious/compromised SMB server can define a
> device node (type + major/minor + permissions) on the client that the
> admin never created and cannot otherwise constrain -- the only knob
> left to block it is the "nodev" mount option. That's why we introduce
> the change using SB_I_NODEV here.
>
> We did analyze the CIFS code, and found this missing security checks.
> We have a reproducer that allows a malicious server and local user to
> elevate privileges by introducing a new device in the mount.
>
> Best,
> Norbert
>
> ________________________________________
> From: Steve French <smfrench@gmail.com>
> Sent: Thursday, July 9, 2026 7:20 PM
> To: Doebel, Bjoern <doebel@amazon.de>
> Cc: Paulo Alcantara <pc@manguebit.org>; Ronnie Sahlberg <ronniesahlberg@g=
mail.com>; Shyam Prasad N <sprasad@microsoft.com>; Tom Talpey <tom@talpey.c=
om>; Bharath SM <bharathsm@microsoft.com>; linux-cifs@vger.kernel.org <linu=
x-cifs@vger.kernel.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.ke=
rnel.org>; samba-technical@lists.samba.org <samba-technical@lists.samba.org=
>; stable@vger.kernel.org <stable@vger.kernel.org>; Manthey, Norbert <nmant=
hey@amazon.de>; linux-fsdevel <linux-fsdevel@vger.kernel.org>
> Subject: RE: [EXTERNAL] [PATCH] smb: client: set SB_I_NODEV to prevent de=
vice node injection
>
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you can confirm the sender and know t=
he content is safe.
>
>
>
> Setting SB_I_NODEV is apparently not done for any remote filesystems,
> and AI search confirmed that it probably isn't a good idea to set it
> for remote fs.  It is more of a thing in pseudofilesystems and not
> needed for network filesystems.
>
> e.g.
>
> "Is there any benefit to setting SB_I_NODEV?
>
> Today, probably not.If you grep the kernel, you'll find SB_I_NODEV is
> used in only a handful of places, and those places generally involve
> pseudo-filesystems or internal VFS assumptions rather than remote
> storage.  Setting it on CIFS or NFS is unlikely to change behavior,
> because those filesystems have worked correctly for decades without
> it. Most remote filesystems don't set s_iflags because almost none of
> the SB_I_* flags are intended as generic filesystem capability flags.
> They're mostly internal VFS state, and SB_I_NODEV in particular has a
> very specific purpose.  SB_I_NODEV does not mean "this filesystem
> contains no device nodes." It means something closer to:  This
> superblock is not associated with a block device.
> or more precisely: The VFS should not expect a backing struct
> block_device for this superblock."
>
> Has something changed?  How did this question about SB_I_NODEV come up?
>
> On Thu, Jul 9, 2026 at 11:05=E2=80=AFAM Bjoern Doebel <doebel@amazon.de> =
wrote:
> >
> > From: Norbert Manthey <nmanthey@amazon.de>
> >
> > Set SB_I_NODEV on the superblock by default for CIFS mounts. This is
> > consistent with how other filesystems handle untrusted remote content
> > and prevents the server side from injecting device nodes on the client.
> >
> > Fixes: 2e4564b31b645 ("smb3: add support for stat of WSL reparse points=
 for special file types")
> > Signed-off-by: Norbert Manthey <nmanthey@amazon.de>
> > Assisted-by: Kiro:claude-opus-4.6
> > Cc: stable@vger.kernel.org
> > ---
> >  fs/smb/client/cifsfs.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> > index ea4fc0fa68cac..35eee2f9899d5 100644
> > --- a/fs/smb/client/cifsfs.c
> > +++ b/fs/smb/client/cifsfs.c
> > @@ -208,6 +208,9 @@ cifs_read_super(struct super_block *sb)
> >         if (sbflags & CIFS_MOUNT_POSIXACL)
> >                 sb->s_flags |=3D SB_POSIXACL;
> >
> > +       /* Prevent device node opens from remote filesystem by default =
*/
> > +       sb->s_iflags |=3D SB_I_NODEV;
> > +
> >         if (tcon->snapshot_time)
> >                 sb->s_flags |=3D SB_RDONLY;
> >
> > --
> > 2.50.1
> >
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
