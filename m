Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E622367A6
	for <linux-cifs@vger.kernel.org>; Wed, 11 Jun 2025 20:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749674954; cv=none; b=OaImnXYU3vYhQnQwHNq7GGj+xQIv2eXcYV6rAOXSfzDvRwSN/oqdMhSmMd0k6V65paZcAp1KPfsmhk3ehQXp+293TBQYkgMbD84j/INM3FxaWzrgF2NfmJGz+yPzPs93vk4xGr4x9cYHReBcYZT4UZ+A6BuRrw/uGceAkyvDPy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749674954; c=relaxed/simple;
	bh=IMiZ3LmIKNmp78csd151zbs40C/sGydmwYKrMkv/GkM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D+VY2Vcp5euoNrmjzasEavc+ICoHcTHei9fZetAed6vASiLOZ0gnXBXp3giM7MieCY/M+MUwqvruLc06vy1fAkSrHbmeqe1AOHWpjYvqAZLrL1EzDADGo0bcgG+S9JdTPF/YAQvMES0wnDOnCvg7I9JT6KpazaPhw+IYa5FAbE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H5QLyi/b; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H5QLyi/b"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-553246e975fso215639e87.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jun 2025 13:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749674951; x=1750279751; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IMiZ3LmIKNmp78csd151zbs40C/sGydmwYKrMkv/GkM=;
        b=H5QLyi/bTLmT1n/WXg0HHmpL0NZUBo0JCOiFysyTO0bLEkhcXDH7gDT5fbJYZWbhO+
         h41How/RAmCmWzfHPQRxBJ29FSBbJK8cPdrEEcVUTc7MmnM6qcLEdRXgElkOnKMtaFVr
         EX4zRdxXpD864aLj5SHMZqEp5DDaRmAgBqsJSbNqSHAnu1PLVkp0tsFqWnNjRKJ1MrvM
         sc/PEej5JkZym6vGOH2WZWyj5wrw0QkievrJ7JIAp1SNz6W+ari1aDjfRlvnar83uKUH
         l9rUAZlN/w5xAlHrIgjUFjWD7mypvJTwgFRlbU6EWh8midgL+sXoogmmEtsBfj8WfVtb
         Ks0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749674951; x=1750279751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IMiZ3LmIKNmp78csd151zbs40C/sGydmwYKrMkv/GkM=;
        b=H8ZBF9Iqvu37YTXwDZ1lyKVd1a39A9f1oi0je4pr4lMV9qJUMXeinMSYa+PemFzN4N
         h/37IVFxb4CxavRjJmunJOTeeYqbeTPyhZqhr/qoL/19ZvYJPzPyGgXkRFL29i2gC+dI
         Mv7PtR2qp5QLPD3M3yswECc3M6+70kKQMMbwEmsT7gKiMHKvptx/5Xwkpke06YDY0NUl
         UkqlWE7PGhwy0EkGNN045RQzw48IIZ+ayAgB3+6cmaahtGBKRP5z0SnTpb9YCsvtO0hC
         LrJaRAmjSVEJXtgm9Ly/n7YyHjBmow1RqLCkRFFbJFJALLRnQQ60A6cV49627OJzacWb
         VEhg==
X-Gm-Message-State: AOJu0YwJGEE3mTV2vGJ2jKnjq3gIPLWBRfwFuUNaruYyqI5IMeoq+Qvp
	Oj36wp3o8h6MDJ9LuqUcsXyQxHpezhWRDbcj3HceT3gpDdG0qGPqCFS8CrITzU6pcJJv03t2zo2
	SleGqJdPnxGRg53mHlEh8ogkS7qwtBfE=
X-Gm-Gg: ASbGncsfD11BnGJTrqsoHKTZUGg4Jlh9r0F7gZWs4wbp5unDsIUuhdQZrvxJEklQ1HP
	Uzx1HoO6Z5JR7m5eWO4dM5D4hOOLhkRblICYgpIiifBNL8sKJ7z3q9IEUJM27tt/w/cFOwlV77t
	M2zntw33LAoExb/zkNl16mUxLF4jcsdeVjbFHmlzzGqb+H4YprS3ttMukdD/VqWHk4YQUnPV6KL
	VkT+A==
X-Google-Smtp-Source: AGHT+IGdzEtTkW+L45l0qmCYYQhdKafzENwQewzy1WHcLNj9UG5FvRut74IZhQCATNom3Qz/tyfgxCvzZWcVKTS6TFY=
X-Received: by 2002:a2e:b8d2:0:b0:32a:8c7a:832c with SMTP id
 38308e7fff4ca-32b3070629fmr2520971fa.30.1749674950816; Wed, 11 Jun 2025
 13:49:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1192550962.455023.1749616405217.ref@mail.yahoo.com> <1192550962.455023.1749616405217@mail.yahoo.com>
In-Reply-To: <1192550962.455023.1749616405217@mail.yahoo.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 11 Jun 2025 15:48:59 -0500
X-Gm-Features: AX0GCFvuzg0aVEfNNqnfb6e6RgzoVSWlsvNmXMpZMzUCN-yNnzfdQ8PSjaauI8E
Message-ID: <CAH2r5mvTozV+kqGWdb0_95YE+Fq-tdj8D+jdE7L+8AsA=8oyFw@mail.gmail.com>
Subject: Re: Userspace mount.cifs -o cifsacl Mechanism
To: Household Cang <canghousehold@aol.com>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "sfrench@samba.org" <sfrench@samba.org>, 
	"stfrench@microsoft.com" <stfrench@microsoft.com>, "sashal@kernel.org" <sashal@kernel.org>, 
	"pali@kernel.org" <pali@kernel.org>, Rowland Penny <rpenny@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Have you tried experiments with multiuser mount option to see what SID
the different user's files get created as?

Might be a good sssd question how to enable debugging for their plugin

Have you also looked at this:
https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/wi=
ndows_integration_guide/smb-sssd

On Wed, Jun 11, 2025 at 12:44=E2=80=AFAM Household Cang <canghousehold@aol.=
com> wrote:
>
> I am trying to grasp the mechanism of cifsacl in mount.cifs.
> I fought my way from joining a Debian to AD, using sssd, doing dyn_dns to=
 heed Windows Server's RFC 2136 (found systemd-resolved is incompatible), r=
eusing krb5 ticket for mount.cifs, piping sss idmap to cifs-idmap, now curr=
ently stuck at cifsacl.
>
> I am doing this
> export KRB5CCNAME=3D/tmp/krb5cc_10001_xxxxx
> mount -t cifs //nas.domain /mnt/drive -o sec=3Dkrb5,cruid=3D10001,cifsacl
>
> Something is wrong with the cifs.upcall that it does not like extra xxxxx=
 unique identifiers being appended after uid. I can blame sssd for doing th=
is.
>
> /etc/cifs-utils/idmap-plugin --> /usr/lib/.../cifs_idmap_sss.so
>
> Once mounted, I could use getcifsacl to look at the DACLs with the resolv=
ed name from sss.so
> But the permission is not enforced through the ACL.
>
> I am seeing OWNER in cifsacl is set as the uid on files.
> But all ACLs on Windows AD groups are not translated into ACL. So unless =
I go do -o uid and gid at mount.cifs, they all remain at root.
> Is this the current limitations of cifs or I am doing something wrong?
>
> Many thanks.
> Lucas Cang.
>


--=20
Thanks,

Steve
