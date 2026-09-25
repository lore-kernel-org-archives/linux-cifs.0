Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3BB3E0234
	for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 17:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790356065; cv=pass; b=qUfKG3J4dhX4mDbPejAhP5PIw2zXIMhValTA7MpnLh4mhU06E6Rp/+4MiZk5cGQX41wYgE0FxJWNqGa9EkFhwMr6L8nGgiMz1ph3y2YURCc0L94qjn41lzp+QJC+i6CwDsmr97OR1FIDjJF2B+ggZ1j2j2epiF6CsABrsU7Wi10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790356065; c=relaxed/simple;
	bh=Z/QlDjEqmTsvd8hmVsRhjPJAPZKduCsAshcn9SEcHsU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=osEKwsZLf1DgQ1bRhdLurLO1YZBy0N+gxoFQWZVj5zcjCOqBlk2FlKF2kzNmN8f8/JmnoXqEzU8tfYh7KQ4GOjJ+9acLr6I/oluHsQkdpV9olSVoSuvKhTjtk+T6+QcGi6i/aj2NUmYS2UKEQk7beHHojoaGfV6sFUYkabgRgfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=JQ7vBslB; arc=pass smtp.client-ip=74.125.227.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="JQ7vBslB"
Received: by mail-pj2-f41.google.com with SMTP id d9443c01a7336-2df958a8272so4264825ad.3
        for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 10:07:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790356042; cv=none;
        d=google.com; s=arc-20260327;
        b=BukblSgKNGDyyybpkaayZe3/pxphHNk3enfdZCWadfIB6cGSK1nMqrmpxjE3u7uH/y
         MFMjquozHOhoejmvh8wNGBHpZp7sQACod1gRcQs+B0e3yDpDzoijOF81iIqf8xBlJels
         WTIyPhq4ahivruhF11MhWQe2iGB0ihP7cDP4Z9nPK5P1VnBV1ix3mr5atHYNMI6rVkJN
         jpomcEKQeIedrA3digwpB7LpPDyxDpj3wGDki1OoZloFRY+TmnZJxmNDuRMSo+VDFHfW
         vq2gJSs1fnQnkKE41uzN4huqeQuyJbj4/EVEDY0onFwW700ypaK4LYuLw4uJBHWG1wnc
         twTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8YwzIASUiQRwU6GfvzkJObDJseuyBEMVP7g4XrNm/58=;
        fh=kb/i/EG8WBcE9Et5+bevGmYnXhcXsL8DqQepwV7Nw+A=;
        b=acD1W6GyYcjk6KKkPJjJ5TRpmR+W9dFY7lm9zSC+IE+DdVJ3VRKypvNn5KPbArbQjw
         0/iJl6kmssEGVvUXuIsO7GoOtbMTyyyCF6K/DFPXWS+A78iYWovs1TaYmj6DMciLKNR+
         ZHVEYVq9ovPCwLS0iupb03QNizU2iz7KlutUdtCbXfeXdcor5QicfypAB2H/GW/jV+SL
         4BlrA/W+AXM1YC2DXlwvR3feYI3/yk3jypuIXjop0hFZMIxvJRmXblFB73w8al0M4L2v
         T2E22WmFtLvQfk+RV7x3RBF0KIgUmNM50ZqlNO/Kk4+PRO2kjhcahmvXWjFH798Ydgw7
         K5Zg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1790356042; x=1790960842; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8YwzIASUiQRwU6GfvzkJObDJseuyBEMVP7g4XrNm/58=;
        b=JQ7vBslBA75Oz3vhccuiegu2ZSCVFqSF0HyjC/3/vNzOkrP+yD6f4D4JjYMSYAoFrr
         wlg7Wmn6oEu7SXRotz0a67VZfHRO6XibZ9ZQ2iaB3D1nQj3Xnbu+DnvAmLPuwuabcTJk
         PXz37aU1zp89S9iK0/x3WEyWrQZ8hNLRiSYpSLIsFe52Q0ZtYHr08wUrk94pc3ENWlQd
         J+Tedgfpmw+/PX5h3yjumGEOqc+s3rcWYPx4Hn4luwZxasnr3NVcHxFxvCE/jfitgeBw
         +jOt/CmP2fD13Y486VYHbVYAPN3U4OMa+qtVuZhbWJD5jm5g1hu0o/Zq9FL93oXYU7V4
         vv7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790356042; x=1790960842;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8YwzIASUiQRwU6GfvzkJObDJseuyBEMVP7g4XrNm/58=;
        b=LHz40TU4c8pUG5ptU+Uk3Z7qzystP9dDGA9jvVleiXg9EhMNREpHEeu9MOMzanVoFh
         kolFeZhV08Y6K7ItW5XwaV3ZgyW5j+pdWJFD/ZDrGj4sjlxWOKKFP+D53PW+Y2nQa4JN
         pPzjDsfAPr/9T8DKaofylOQWPCPyqvhprTwJOdOa5G9Cci4KiK+ODQSrltlD0nvk6E6e
         +4H8sMwixv/y/Yndu4z11YwVAruGzD7e6F8OmyuOMbjMmXzLQggz6j87kAMLVepXkAOP
         voxiA4Qo6acGeTHCdikXQ6RdsDxh+Vo5Qio2meLDn5oDxvy4Wrm6k8KaviKA3yoDk861
         8ZDA==
X-Forwarded-Encrypted: i=1; AKwUvBybBk3dw0srsz/mNl3EwGmRr9CpTEU7XUZz9DFVQxeRNw97dWFGVFxeYUMkAD4Ekx0Rw3chD5hbaJrC@vger.kernel.org
X-Gm-Message-State: AFuF++nsY19xL7/JBkRLpdyMe61P9tK4kaC4r5i8DgmjiG/aPu5q9iRF
	lyEiXHzBrgO9EOJN9RSUu8mc8IUmSqYXxzIXOM0Cs/A582UuqLoX15qsiTx4cEtdiDQaRa9A+K+
	CByT5++jecwufyav8WGJoVXI1qPy5NvvFwPs3p511
X-Gm-Gg: AYBFou2qXtOCUAUz7yVqn/YummVwkxpQzOb9rVdT5/AKCyRVlfX0RCW/8L6PuwjTe1s
	rYg0tJB8Sdo7B4/CBGhhdHGwt/P9Ks2Yrzea4dLr24NSHJlRLsrrM83IRHHW6Tw/SeV9pCE8qFr
	efjaIDS3Aj7W8BPUY5IAEvtPo3fga6EeEuzIqSvyuPU8qSnIHLsIf/oyyr3xT9DtbMHiDW2RDIA
	LUp4dPIhsU3MGgRmUNjt+tj6OTIvyyNLzyUbGaYuVe0CAAtiqc01whRDdcn0xdISND8JuAVl3im
	HBp20NJfrP8gLHl628/G0K5H4ys2XVE1uRuwEj60W8scmqSjIivEHSlYH3zGB+dTAs1MRNkE6HM
	dV2wwHKx0q+KmBvz/Wb995Q==
X-Received: by 2002:a17:902:d48d:b0:2df:99e6:9448 with SMTP id
 d9443c01a7336-2df99e695bbmr12902675ad.61.1790356042370; Fri, 25 Sep 2026
 10:07:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260924104831.1081137-1-caixinchen1@huawei.com> <20260925-zahnersatz-hielt-lerche-141893658522@brauner>
In-Reply-To: <20260925-zahnersatz-hielt-lerche-141893658522@brauner>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 25 Sep 2026 13:07:08 -0400
X-Gm-Features: AclHuK-PYyMWIn_xv6i13K6lF_3RP26uUOO_mtAnUMGHNcMrV5ydBitx8qn_ri0
Message-ID: <CAHC9VhSeXmOHvioZ12aVmnOtpP52-G=K_jS3K0fTSiCrDHStPw@mail.gmail.com>
Subject: Re: [PATCH RFC -next 00/12] landlock: Add READ_METADATA and
 WRITE_METADATA access rights
To: Christian Brauner <brauner@kernel.org>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Cai Xinchen <caixinchen1@huawei.com>, gnoack@google.com, jmorris@namei.org, 
	serge@hallyn.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	rdunlap@infradead.org, gregkh@linuxfoundation.org, rafael@kernel.org, 
	dakr@kernel.org, dlemoal@kernel.org, hch@lst.de, axboe@kernel.dk, 
	viro@zeniv.linux.org.uk, jack@suse.cz, dhowells@redhat.com, code@tyhicks.com, 
	linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com, 
	hirofumi@mail.parknet.co.jp, cel@kernel.org, jlayton@kernel.org, 
	neil@brown.name, okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com, 
	miklos@szeredi.hu, amir73il@gmail.com, senozhatsky@chromium.org, 
	chenxiaosong@chenxiaosong.com, zohar@linux.ibm.com, roberto.sassu@huawei.com, 
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com, 
	stephen.smalley.work@gmail.com, omosnacek@gmail.com, casey@schaufler-ca.com, 
	nanx95726@gmail.com, djwong@kernel.org, daniel@iogearbox.net, 
	linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netfs@lists.linux.dev, ecryptfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-integrity@vger.kernel.org, 
	selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	xiujianfeng@huawei.com, lujialin4@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 25, 2026 at 11:33=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
> On Thu, Sep 24, 2026 at 06:48:19PM +0800, Cai Xinchen wrote:
> > This series adds two new Landlock filesystem access rights,
> > LANDLOCK_ACCESS_FS_READ_METADATA and LANDLOCK_ACCESS_FS_WRITE_METADATA,
> > which control access to file and directory metadata such as inode
> > attributes (mode, ownership, timestamps), extended attributes and POSIX
> > ACLs.  It picks up the work from the "landlock: add chmod and chown
> > support" series [1] and follows the coarse-grained grouping discussed i=
n
> > that thread [2]: instead of separate chmod/chown rights, metadata
> > operations are grouped into one read and one write right.
>
> This is mostly fine for me. @Michael, for the fs side of things I would
> give you a stable branch vfs-7.*.shared.landlock.path that you can pull
> once this is ready.

This is in my queue, but I haven't reviewed the changes yet.

@Christian, I'm guessing you will merge patches 1/12, 3/13, and 4/12
since those are the VFS changes?  Once you have a branch for that, and
we have all the necessary ACKs, I'll merge the LSM changes in 2/12,
5/12, 6/12, and 7/12 and then Micka=C3=ABl can merge the Landlock patches.

Are we all okay with that?

--
paul-moore.com
