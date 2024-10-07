Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F1ABA3D
	for <linux-cifs@vger.kernel.org>; Mon,  7 Oct 2024 00:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728261299; cv=none; b=De6GtrWSYS1zTNkX5sGpZW8F/fooDfZFuOxdHe/8WtgTpoBTu2gl5iyAiIzHvBlSVZiRoKBNL8v0mXH8OTh9WAw0gMmo58nOlpOu5XjpfAZzqn+yaBZHeU92NYoTytzB9QfcY0GTeygDK84OFLpgT9qzU6c9IJJ7R/Pv4SelYCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728261299; c=relaxed/simple;
	bh=zTSb+6kF5YnLk0c43LMq5gPoNbkooDf5vo/3cbdFwcM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=VTGBEy4sApm+aumNXUg9c5wlNa7tCPTpHs6rHzAX58N40qsrD7SuzpfxQm8jJ013Q9kCpzoiLg/ltO14etCg3M9vpL39OPk25m3hFzivHES/wwgCZ2LD+Roj8Z0Ef/Yvu/r++HEu7dmYqdENmXa/v4cPV9ENOF0IMy7qZqYqgBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a8d24f98215so609030866b.1
        for <linux-cifs@vger.kernel.org>; Sun, 06 Oct 2024 17:34:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728261295; x=1728866095;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zTSb+6kF5YnLk0c43LMq5gPoNbkooDf5vo/3cbdFwcM=;
        b=JXw1+fSiwsM9WLUPM1rf/M6SsUPCyYIfOFsP0sdbELADlWCI6RmXiA0eInrgcRmTU2
         m7df8oepEPZUt1uV1qtj3USWbwwnIycFtu44osUehjDPHov7wO1FveidRvVj5rLhSoeJ
         tyEdKQc7ivB4BjBh0wVBsKZ5vKEeTNoeCKqr80l1hBmDwtEdQ/eNjYeHHdrkUPMMA96Q
         zra4FuUvQmij7ASsg53nIZdhjZkK1W+NLEsu19V+GPCZfMKaJ6ZlYjRZvGCEL24sx2sY
         /GNEWmQU/BuNbpUF56BbROYKxSkmoiGCu53YJ0DYiANGErCzXUp030imX5KnB2X0l4KJ
         qKCg==
X-Gm-Message-State: AOJu0Yz/fB4thRRmSkQGmi2CfjqsdgCLkKNlAcqP/Eu/JS1kWeefzIeO
	e6hesHR35F3+n18mtHg4jEVE5h7tL8jrFucsOELaZmqGCH/m2wTkS9y/Pf+Ynx+PikxMd7wRir8
	kobsOWjYhnlYWdknzKqQDxcsIb+KYyuo=
X-Google-Smtp-Source: AGHT+IF97Rl33dJlZXO+eywiE4wgdx8hkOH5l3f32qTBueUyMwnQ9oddo24f3pSQm1OMIFRDlOY/vv1JsNpsETGW8Bs=
X-Received: by 2002:a17:907:7206:b0:a99:3dbf:648d with SMTP id
 a640c23a62f3a-a993dbf6715mr507220866b.45.1728261294503; Sun, 06 Oct 2024
 17:34:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Pavel Shilovsky <pshilovsky@samba.org>
Date: Sun, 6 Oct 2024 17:34:42 -0700
Message-ID: <CAKywueS5Qqgz62xjjJh08n2tQaFPhbi-B1a9JiSvZjDsiP=ciw@mail.gmail.com>
Subject: [ANNOUNCE] cifs-utils release 7.1 ready for download
To: linux-cifs <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, Steve French <smfrench@gmail.com>, 
	Bharath S M <bharathsm@microsoft.com>, David Voit <david.voit@gmail.com>, 
	Paulo Alcantara <pc@manguebit.com>, Anthony Nandaa <profnandaa@gmail.com>, 
	=?UTF-8?Q?Pavel_Filipensk=C3=BD?= <pfilipensky@samba.org>, 
	Sam James <sam@gentoo.org>, Daniel Parks <danielrparks@ti.com>, 
	Henrique Carvalho <henrique.carvalho@suse.com>, Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"

New version 7.1 of cifs-utils has been released today.

It brings LDAP Ping capability, smbinfo gettconinfo command and
various improvements to documentation.

Links

webpage: https://wiki.samba.org/index.php/LinuxCIFS_utils
tarball: https://download.samba.org/pub/linux-cifs/cifs-utils/
git: git://git.samba.org/cifs-utils.git
gitweb: http://git.samba.org/?p=cifs-utils.git;a=summary

Detailed list of changes since 7.0 was released:

0fae4c7 cifs-utils: bump version to 7.1
2cd7b1f cifs: update documentation for sloppy mount option
9918019 docs: add closetimeo description
c4c30b5 docs: add compress description
454870a checkopts: update it to work with latest kernel version
465f213 cifs-utils: add documentation for multichannel and max_channels
b3fe25c cifs-utils: smbinfo: add gettconinfo command
c6bf4d9 Implement CLDAP Ping to find the closest site
4718e09 (for-next) mount.cifs.rst: update section about xattr/acl support
e7ec003 mount.cifs.rst: add missing reference for sssd
3870f5b getcifsacl, setcifsacl: add missing <endian.h> include for le32toh
c8ec7d1 getcifsacl, setcifsacl: add missing <linux/limits.h> include
for XATTR_SIZE_MAX
25d6552 cifs-utils: Make automake treat /sbin as exec, not data
dac3301 pam_cifscreds: fix warning on NULL arg passed to %s in pam_syslog()
7314638 cifs.upcall: fix UAF in get_cachename_from_process_env()
ef0d95e cifs-utils: add documentation for acregmax and acdirmax
2260c0d setcifsacl: Fix uninitialized value.
1eee8e8 Use explicit "#!/usr/bin/python3"

Thanks to everyone who contributed to the release!

Best regards,
Pavel Shilovsky
