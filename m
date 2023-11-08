Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C4A374CA
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 21:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y06LxX7y"
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48185211D
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 13:23:37 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-9c603e235d1so29474866b.3
        for <linux-cifs@vger.kernel.org>; Wed, 08 Nov 2023 13:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699478615; x=1700083415; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oLMUcI4/jw5EUukdjTXuzYA+uUI8JWgQmXJBcIzK6xs=;
        b=Y06LxX7yW3qWrbHqrk6e18gkWvXnukRuIVSJVqzTW21Hbf70LuNcd2LFrm+rS5wzKk
         ThyIqXWwsBlMJEKOOfNU4j9+fXcxViCkhWFnda8M/3XPBXpkTw0N3Cp0g6HraMYaHuFi
         K0VfPdTqizUtEFKIg0tUH0XjgwtPJtHqWRi6B2kfhGCsu9EYlF30atsE5eAl2C43P3nD
         BJR4trdBPwqGiSqbef2nhsMMGmfUyEw5acbFPj1UIGCtiE4tUcuc5DRPkUbpRq5K/Wn5
         6zXdXTM7hl12dpyLx/fhvAm2p3831jk+4ZBRgad9j8opJZK6CiqBGiR76W5IqYSELc7K
         uVlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699478615; x=1700083415;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oLMUcI4/jw5EUukdjTXuzYA+uUI8JWgQmXJBcIzK6xs=;
        b=o6QSQGjHd3iUNYjJt9mpI6bz5L4fCAXrn4j29MaMEThDKPMMwjt2XEbL/uyaX1C2s6
         LkSzI5W7T2TV9KAJmIV2ItSuxcEMeMtVFmqMjNQTcnzGPjJbRbHwPxbpVx+kbzvHDN7l
         j+vPmh/aKks/TppCseNBAUYx2x1mpXH8tCGOGyOPgB+giCGwixHMZra8OF/loPX2lyj6
         vr8rBCxouKpGPUkN9GkG/+PANrWLt8QGPuvZ0cODj44jgrq2UL7pib2kt3kW95jDzgrz
         kZYZp+rhUNIlO0lyGXhATNIayI5ktMd+iOGCOLQx3CcfCkn6baRXMpVfaxHJJ3SAl5PN
         7M/w==
X-Gm-Message-State: AOJu0Yxof+q0QaP0ci8am40mNVKnxWUb2zBb2RbrE+L3/yqMWDpejyCf
	N0lE/T+kNhB+M3CChX5Xn9So6q/dRvyX3lr6wwYWyiAtGdI=
X-Google-Smtp-Source: AGHT+IEBbfV/Va7cznWuAvtaymCrGdDShHsAYeqMTm35tys3/xRyu0IuRAdepwXFdROtX3aT0uApYJ1QDdvedAK3VDg=
X-Received: by 2002:a17:906:c104:b0:9d4:84b6:8715 with SMTP id
 do4-20020a170906c10400b009d484b68715mr2689220ejc.52.1699478615161; Wed, 08
 Nov 2023 13:23:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Eduard Bachmakov <e.bachmakov@gmail.com>
Date: Wed, 8 Nov 2023 22:23:07 +0100
Message-ID: <CADCRUiNvZuiUZ0VGZZO9HRyPyw6x92kiA7o7Q4tsX5FkZqUkKg@mail.gmail.com>
Subject: Unexpected additional umh-based DNS lookup in 6.6.0
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When attempting to mount (mount.cifs version 7.0) a share using

    $ mount -t cifs -o
vers=3.1.1,cred=/home/u/.secret.txt,uid=1000,gid=100
//smb.server.example.com/scans /home/u/mnt

it succeeds on 6.5.9:

    mount("//smb.server.example.com/scans", ".", "cifs", 0,
"ip=192.168.5.43,unc=\\\\smb.server.example.com\\scans,vers=3.1.1,uid=1000,gid=100,user=u,pass=mypassword")
= 0

but fails on 6.0.0:

    mount("//smb.server.example.com/scans", ".", "cifs", 0,
"ip=192.168.5.43,unc=\\\\smb.server.example.com\\scans,vers=3.1.1,uid=1000,gid=100,user=u,pass=mypassword")
= -1 ENOKEY (Required key not available)

(or ENOENT) though it still works with using the IP instead of the domain:

    mount("//192.168.5.43/scans", ".", "cifs", 0,
"ip=192.168.5.43,unc=\\\\192.168.5.43\\scans,vers=3.1.1,uid=1000,gid=100,user=u,pass=mypassword")
= 0

Based on my reading ever since 348a04a ("smb: client: get rid of dfs
code dep in namespace.c") dfs_mount_share() is now calling
dns_resolve_server_name_to_ip() early and unconditionally. This can be
verified on a running system by enabling dns_resolver logging (echo 1
| sudo tee /sys/module/dns_resolver/parameters/debug + watch dmesg).
An additional DNS lookup is attempted in 6.0.0 that previously wasn't.
My best guess is that ENOENT is "didn't work" and ENOKEY means "didn't
work but cached".

On my system the request-key mechanism is not set up so this fails.
I'm no expert on SMB so I don't know if things just happened to work
previously by me relying on a bug but this change broke my setup. Is
this expected?
