Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A75A2CCC5
	for <linux-cifs@vger.kernel.org>; Tue, 15 Jul 2025 01:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752542630; cv=none; b=czkVfQc3k/o76udKFzUMXnq1UvPhx4GEriYMAX5XIJWWvsPpTHN/fgSJ2nEhZrvCJaQUGh31eATruATvG9y3JVb0UFb4BTLlWICj5duzqgAVjFOz7oVKJi/NGVx3LH7LRuTXHKXeRfFpHE2ClCDva1dfu0mmPsHotN7LQ9lFiWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752542630; c=relaxed/simple;
	bh=c3clbIcxE0WeGbEQkdW6U5MtrG54IZf2Sq0ntkqxjJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XV3zx4ouyWDBYiRchokxD+2S0r2sts0Yf2PuDFMfk/23yN/LJsdCXNyKSL5hkQn0LYRXcEJ22ImLxaTR3Q4tgEHp8XupQWv2rrF0ncl1Fe0a/N0wiSCWc181Upci5D0vLrp5icmWpFBHS3OCgeRkHVk3Ex+JGNWefX2OPT3zDk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=truenas.com; spf=pass smtp.mailfrom=ixsystems.com; dkim=pass (2048-bit key) header.d=truenas.com header.i=@truenas.com header.b=WvoFuvOR; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=truenas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ixsystems.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=truenas.com header.i=@truenas.com header.b="WvoFuvOR"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-528ce9731dbso1984777e0c.0
        for <linux-cifs@vger.kernel.org>; Mon, 14 Jul 2025 18:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truenas.com; s=google; t=1752542627; x=1753147427; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3clbIcxE0WeGbEQkdW6U5MtrG54IZf2Sq0ntkqxjJo=;
        b=WvoFuvORrN43caR7DycLVXg5jvTyFOcg9CxvsON2eS+8LCrmAx8gwijkLSdi/I63ly
         sE+FX9sxpZVLUtvEZYDCJmO2fI9tawd5if61uF0EY+KxuWXp2TQU9iFq99KDVt822mjF
         o24/ZN59agG0V/IDEm4oiMlfhxNQ1+cAEz+BOrzC2jdW5wIDVago1RO6Zcp3LM67rLvQ
         JMOvQ3oC7sziiyWKTVbESSP9T6NqDk3k8WVzFeYgtEo6DeGr0p9uhaGTjDaE1oJiLkTB
         LMXUcQGBPU1HH3tGOd7kjgPAzD2alnjVhqYvcIlanb75IRJjyZVHOnRw6erTd8rFj89b
         z+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752542627; x=1753147427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c3clbIcxE0WeGbEQkdW6U5MtrG54IZf2Sq0ntkqxjJo=;
        b=gE2hOLhZGXDjFQg6EjLZ5M2OA+PRWcgAhMntodZKfaHt6eabXH/ltj1D9KvVGOaPyL
         /DOIJg8Q65XgP/4zdPjzCfVAwe0WSOmQXAB3jOnrggfHvd9HBJA9C04kuc8rgehmLvGv
         gGoVlcRffAq8xDlXfG8F5QBYGyhWblXOBliCBF8gOZF3pRL8dRhHGkguIX2leqhdBTnt
         1Y6qfdUKnBzAEFzwG5zPuwZp7euo1qHjn2Bp2TKVBLpKUcLS9gv3eLAp3m2IsCFaOONf
         mAWPHbhfpj2ohVHhERdGgL8KJbUe6/U7KD7iVUU9a7SAbVRAseMU8vAHsNevbA1DIsAb
         O/6g==
X-Forwarded-Encrypted: i=1; AJvYcCVgm0dlGs7/jh6IjswJ9vXoh3uY7gqCxWHS0CdIPz5C0pr4rfV1EPBIdL0qkQIQTnqML5Q5INu/OVl7@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo/lVWHE1XTFYNgzZnX61iEcB6jMBZmhWE6eExFtp3fiAyemRK
	xR5+HO7xtrdbEPW61/71MWna4Ay2ydF0SdZoH+f0nmraKpbfrXIRNqv9YseNog5R6oF0jXPdo/S
	6Q3Ub2lJXWQTsI5e37QAv+5ihR0NgN45CBgJTVuaD
X-Gm-Gg: ASbGncv+BxzaU2yIEQElPGrrgitwbBxA+v7tl6MF53eqF/Wmw2tWszNyT9qyeoDjVPs
	k/DxhJl8v6C7Rp0DgQDIsZhUWJiCRdF6TiQ+VBOh9g/vkgjsPIdillGNXUcNBRQedh7ZgZ85GRO
	B3MSgEPCVns4YuyJONbx7KKsxP/FbcGGCMnJtzLI+z81YHGyttQFmPsv/fHxabvf3kEaQ5Eijsq
	HDXU8cMnbYxurh0FmVp
X-Google-Smtp-Source: AGHT+IFon7l/CNGp5dlPGE58ieNje71hvMErhBoa4b1fxXVSxjVTVRdP1EuR+0LPsKxLVeILdxKzTsFr56RkpDjQARQ=
X-Received: by 2002:a05:6102:5cc3:b0:4ec:c549:161 with SMTP id
 ada2fe7eead31-4f64270d96bmr8807539137.21.1752542627088; Mon, 14 Jul 2025
 18:23:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250608125507.934032-1-sashal@kernel.org> <20250608125507.934032-2-sashal@kernel.org>
In-Reply-To: <20250608125507.934032-2-sashal@kernel.org>
From: Andrew Walker <andrew.walker@truenas.com>
Date: Mon, 14 Jul 2025 20:23:36 -0500
X-Gm-Features: Ac12FXw-K5s-VYYLE_3-JbI_V0BGkn5zOLC54k8RmGL3Y-XFTtqkRXPssHT-H2s
Message-ID: <CAB5c7xoe98HomEgfOx4z_H5zS5AYz4ZSYz-ZV2DES-M8cE30iA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.12 02/10] ksmbd: provide zero as a unique ID to
 the Mac client
To: Sasha Levin <sashal@kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Justin Turner Arthur <justinarthur@gmail.com>, 
	Steve French <stfrench@microsoft.com>, smfrench@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 8, 2025 at 7:55=E2=80=AFAM Sasha Levin <sashal@kernel.org> wrot=
e:
>
> From: Namjae Jeon <linkinjeon@kernel.org>
>
> [ Upstream commit 571781eb7ffefa65b0e922c8031e42b4411a40d4 ]
>
> The Mac SMB client code seems to expect the on-disk file identifier
> to have the semantics of HFS+ Catalog Node Identifier (CNID).
> ksmbd provides the inode number as a unique ID to the client,
> but in the case of subvolumes of btrfs, there are cases where different
> files have the same inode number, so the mac smb client treats it
> as an error. There is a report that a similar problem occurs
> when the share is ZFS.
> Returning UniqueId of zero will make the Mac client to stop using and
> trusting the file id returned from the server.

Doesn't returning a zero fileid just cause the MacOS client to assign
a fileid based on a hash of the file's path? In this case it doesn't
really make the problem go away, it just makes the problem more
unpredictable. In the past I was also able to reproduce the MacOS data
corruption issue with Windows server by mounting multiple NTFS volumes
within the same share. Windows servers identify mounted volumes via
reparse point: https://learn.microsoft.com/en-us/windows/win32/fileio/deter=
mining-whether-a-directory-is-a-volume-mount-point
and the last time I checked the MacOS SMB client wasn't handling it
right (I reported the issue to Apple a couple of years ago). IIRC,
minimally some versions of the Linux SMB client may also hit the same
issue (two files in the same SMB share with the same inode number).

Andrew
