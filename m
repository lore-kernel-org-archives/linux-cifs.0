Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FE427726
	for <linux-cifs@vger.kernel.org>; Wed, 18 Jun 2025 21:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283030; cv=none; b=MS4iJ6B8MfssMe3tIwHwawGnQXcQ/Y8x6yezVA91rEO07HTm1T0IJHC+UoJf5pfceXYjtlLKMBCuGIMlxklit9OVjWVkbw7wJaLtqy8ekXhaHyZ5kgjFdYIaK0W7+TYhSGnwur7cdaGFBBOIl9mc40zSumEmyKJCbrKlr7S7C6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283030; c=relaxed/simple;
	bh=KvHFEg1Hn7jb7RciXQx/WBVrWLfLd+IbMGST/WrDgKU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=UFDp6BpdxChWy/cypmBlDa/lCnlCRGjWw1NAYQChcqscq/8NPygeboMm8Vff9II4KyO4IW+tHyNo2i4gzwDgwj0WuNeUeGYknRCIjVzu5Xq1/MrPX42tKnTkCc7G+gwmr2L4jzCXar9cFScSOXgOC19EX+7HQBU45K8YGSIOF7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OcewLYEv; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OcewLYEv"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-553241d30b3so57498e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jun 2025 14:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750283026; x=1750887826; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QYEMlC9bTeP0hHRvZwDzfoFyfHJMioTvzv+ybFjWLZ8=;
        b=OcewLYEv/NsEa7bp6My8adjlelm/omA2cZYP+0ViNiZxFNg0RLa3+UhW0LmxDO5vo1
         Lu0s+SKNaMciWKuzPeQcDeGsfC0nIShat/FZSvGhY/7yP4fNP0ser7bjaPYj/pMqkGCK
         DeIN48R5QQosi2y9AdvNpoRaOuBwfEQ8qxBqE7zofCFbpIfeX0s7iadwopmGAtmdYJ3V
         lRuxLdzM3R7Uns2yFYJic0bgx9sll+veG5vGV1Lc75+pHB7AtOsXdWjkZgvWvFXbblug
         DxKKHS4jcfRMGhvGo+YetWvKVjqmPgQ7eXKtr8xQwx/Z4r2HUOcE8a6P43+VVuZsAwLN
         KjqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750283026; x=1750887826;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QYEMlC9bTeP0hHRvZwDzfoFyfHJMioTvzv+ybFjWLZ8=;
        b=rnFTp8EHwwX5GUaftnSoyGkXJN55LHHLk5xCcL8rRJF/6XlmGTQf9m7KNsmUAMa0NC
         J0X77OFCJzxLatMA08zg9o3omZy3xOs9g018i7xjmDPhHISc3n0qgNfIcKzLSEqgP4rX
         7A+FQNToN58VbBtgJoJrN+dfRsF8iTqMECp69ndNrYc33ulmWGeuDi/G4GIUaE1MjRuz
         e/lZRPjjUnqUr6pwiAhhajGn6w3UHsopYn1lZOZEuURF5oHsSbOnxfNpwUFgR2VlrtqK
         Q1lqlW0CCcNCBoWQWQdvWCenYQurSN8hVToYGrZgoHkmIIfH7bH8w/7TUu5rhs5NJTiE
         N6ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6qYLgE3VdaobQLRBvu6to4OJv1ALkhZ3CmSOQaDj+QCS30kdp6800KN/IRMC1x9Frji+WnHmOCxbr@vger.kernel.org
X-Gm-Message-State: AOJu0YwlwB5Lan53jZzkAg6K/jPyAFMoqzTI3zJJsR+ekjzxSRVvQP0E
	ji+ngKFMNEovh+xKtnDaot82aKhOgFIe9CLCFtoLQIfgNmUhBLUbGWjbv/mofuw0F3EyIFi+G9Z
	shVVWoBSVTofIZg7BJqv5gP0dIZ0LsszX3nky
X-Gm-Gg: ASbGnct5YA7KbVZMOWsMNTJ/rQfai39Z24eCN7YsrLxnaLQndLGKeajVFbkLRkrrbmW
	QG/yzuWcGEIiAAVkwAG+YI50jhYCFgKpOrlSiWp9NxdbsMoSqktEyasPfjku2PuEX4dJfqlgSeg
	89vbDqEofjSqkALF+2P4CVd6CZLezokUhX2FOa9umXpy8oDOZyhMVgVXGjq+wwiW6wrht7X4vOP
	emWhA==
X-Google-Smtp-Source: AGHT+IHJgVriBh1ZpBb0J8HC3Iy4eEqh0C49gzQ6zXemBR3ice3Ylqlcb6NVye3WwUsS6+224muxj3xW8LaGYMrPHxo=
X-Received: by 2002:a05:6512:3da3:b0:553:2882:d79b with SMTP id
 2adb3069b0e04-553b6f16f92mr5510248e87.32.1750283026360; Wed, 18 Jun 2025
 14:43:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 18 Jun 2025 16:43:35 -0500
X-Gm-Features: AX0GCFvcXsRZ_O1Wo7xt7HwLc7P6x4LTONUOBStMghnJHPcrKR7EUuKAcp3Mn4E
Message-ID: <CAH2r5msnY6PR5GGjfheMjd4WJN4ewt06qe5MCZ-4qrtSmxi5eg@mail.gmail.com>
Subject: mount.cifs help missing some newer mount options
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I noticed that "mount.cifs --help" is missing some mount options


Usage:  mount.cifs <remotetarget> <dir> -o <options>

Mount the remote target, specified as a UNC name, to a local directory.

Options:
user=<arg>
pass=<arg>
dom=<arg>

Less commonly used options:
credentials=<filename>,guest,perm,noperm,setuids,nosetuids,rw,ro,
sep=<char>,iocharset=<codepage>,suid,nosuid,exec,noexec,serverino,
noserverino,mapchars,nomapchars,nolock,servernetbiosname=<SRV_RFC1001NAME>
cache=<strict|none|loose>,nounix,cifsacl,sec=<authentication mechanism>,
sign,seal,fsc,snapshot=<token|time>,nosharesock,persistenthandles,
resilienthandles,rdma,vers=<smb_dialect>,cruid

Options not needed for servers supporting CIFS Unix extensions
(e.g. unneeded for mounts to most Samba versions):
uid=<uid>,gid=<gid>,dir_mode=<mode>,file_mode=<mode>,sfu,
mfsymlinks,idsfromsid

Rarely used options:
port=<tcpport>,rsize=<size>,wsize=<size>,unc=<unc_name>,ip=<ip_address>,
dev,nodev,nouser_xattr,netbiosname=<OUR_RFC1001NAME>,hard,soft,intr,
nointr,ignorecase,noposixpaths,noacl,prefixpath=<path>,nobrl,
echo_interval=<seconds>,actimeo=<seconds>,max_credits=<credits>,
bsize=<size>

Options are described in more detail in the manual page
man 8 mount.cifs

To display the version number of the mount helper:
mount.cifs -V

----
Thanks,

Steve
