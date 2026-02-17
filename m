Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB2B1B7F4
	for <linux-cifs@vger.kernel.org>; Tue, 17 Feb 2026 04:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771303572; cv=pass; b=FGaqits/Iy+qAfrk+gIWoWGGF0gzvVA6PllEblo5L7nPkq4tJgflv7wWM+ONGFBiQnteEITLWxtxHeXsAlyT+xPjXTGg5aljLhzw6vJSawHUmYzUfRc8O/KEsiSkXrVhqLUauHoC33vHZMWyGDf3oMfsK9Kf2pUUUrTP1k4gqsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771303572; c=relaxed/simple;
	bh=nKGvllvCG75fwMdLnJD7PMiU4Ur/hq+HZsbw0YKAafk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=nnJLEKs5FaMU0RWPhH7URJuD00iXH5vmmLaLE33YFfzh0F5YIGmpmRAmXIjDSk5FY8B/5RikAhX5NDbkacLn/BH+Vmt8vikTTxgCNPV34RDOZwCHZqzfhs2pWLLAPDfAhWJscaPtl5JYTO81P0d/1GMZWY+biqnie1he0Xt1Xvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HmL61kHQ; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HmL61kHQ"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-658b6757f7fso7282934a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 16 Feb 2026 20:46:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771303570; cv=none;
        d=google.com; s=arc-20240605;
        b=epiLVDnD1LDGMCyEyH9GoIdkXgTiFeUanwmVuloa3ck8MH1ZNylCeig5H6Nx29PKNf
         3f+K3WasAwo6cBtoulfkmNZ+9CDaOO8pG5g4VC0bdkWF4jndIXgXyXn674rpjODLmhDM
         LJ/W4CJOy5DSRdibuI7eKFBaq08a1q1KAWaiJ46WF/utbZj+tsmJ5q7DHB5zKdDg4WED
         asdcHXEyL3v1PvFnCacxAsWKtgrXB6cbXOiyF/JappKbXn83AuRYW0wvw3WbOue6mntP
         Fk0LJmWks+IXdVzikGC9j8azJ6xzX0WXKYHiayq6cMJ7F7cxTDo7JaibdV+aYXJfyekE
         Toug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=xmAbP1npaRP/EktzRfWlFJfADINwj1eoIm5/zjg+zdA=;
        fh=iQb3tbguxrEXLb8uh8gspCXdqgLXB/Bs3GfDXd1cTzc=;
        b=DsmrYkz10OIywXGR0s1rJ6y8EtpeeSc3mb+YPZUJHZj03Nt/3MACiQE+WyzoGnUx/q
         oH1aQft/qlMc62zFiNA27Xr+IJOu/M/nz3+iRJ///U8lEGeF4oD98Oroji28oa3LkdPd
         14tmrDC1n0JV3A1cAx38lIGkp/umKa4OddHtvYQnHvO3+Q47hWzdvovOWeXvvF6VJHX+
         voJ3hbjmSizFuXut8PGNWaBzHVC076OutCC20f6OmVOs2DJve82m3Wg5RpvqcQtx5/rn
         S0ymufwMkUhZ12LupsY4qCotjW8vYJp0V5FxMCP4bnDyptTcYopetPCS4MfFiGBEUWFQ
         aheA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771303570; x=1771908370; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xmAbP1npaRP/EktzRfWlFJfADINwj1eoIm5/zjg+zdA=;
        b=HmL61kHQ48KFTO1gsVXarVuiJNXp50WTfuB63Okct4sieIhJfriayZIVlmYOu1xVwW
         MDKhesC6dJ09fcmTla5KrSOj+RwWWP9TMVjSaqx6suXMPohnE6SUR1QLbJV61uzvj80O
         It0mp8L5Wpdn3tFodQZX+1URJcOCtgJxx8Ig3cv5E8P2gUJ1dZ7shE0VsyH8ZyyXnQi8
         qpreqeBufuzZbVdbP6DFXvdY6fzphWloXRDgngtJr7MdGeALb8IsJr6611/PwlcFbmI3
         atBCDWPqoxR0ktyP32f4SRjGT3voDrqyghUijtWySbjsivmu6u9RcPZctpZS345FEoFh
         Ffsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771303570; x=1771908370;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xmAbP1npaRP/EktzRfWlFJfADINwj1eoIm5/zjg+zdA=;
        b=pwROT5RJ+AslartfU/boPREcbqkzCMVoplVmJqqBTn52zQn8VKAJJ/q7ZvLabwRhIR
         D3J5FbW5Pea0taCyqtV3l4yFzNBUtKuKKZ1J5qQq/IMG+Az05ZyDPbSUrsO92Uel6bmo
         /jHq9N7gcRRWtPBTVrhvIrvHH9x9y4osechAKkpGSy3aAEvLr3xDfvVT9tSiuDRbTsNj
         QbgkSDcp1tImxdDZQRVF5S/V+egqMjI1yWqN2Ca0g38rPc1+B4Z6tu2I1nLuONHH1ESP
         lYlAmdonYseYegHMz2uVcmVrqrbVaJAQXjQKpyPHNWANlPLX3mMdKY9J7rOwKrYW7rvR
         Br0w==
X-Forwarded-Encrypted: i=1; AJvYcCWeZhqvsefuPNCMeKMfbX4s66Q8yPsc3Hi3pkIWzsvdTmZSIFOTs5ZZRIf3sbKQ1ZYuHXQQ/Vl5L3U1@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1ulBap9ZA4IHKzYaD5dNIgG9/UYG4awpv3RBwIXwBAgjfxImw
	YTT3N7uJ0xFviHALMh8Lv5tUAUaBMAoiEgP6EkA1LqJmH6skX5rAFL7enelsZXVMosYO+xGta92
	Z2CtwWZ4B4nKvd7XF8nfGFGGb/Ve5rB8=
X-Gm-Gg: AZuq6aIT8XA3nnSemlELw5gsHA74O9aoCGQyzoUGS70AQnGlxGiq//MAvFUqAmBgUVU
	yVCnSmKQjmNUZqB3TeyGxPkcHhQBEfFM+K/1zVJhXiTkD9H/61ADiazko1J3e9y/RlEtI79D7+t
	Si3zdiRlySMjloD6OnXq/SMI1kdmn624UDOm2aPYTJLjN+GRsKQ7Kd7FT1CRToCZCgczeRJ+jcz
	2+al03kmBw7O+bMW97LpRkTKvUnKRIexir0xRyQVx2L4TfJFdpSXJqqUcNrSsX+wylGdpSdxLz1
	LjKwlA==
X-Received: by 2002:a05:6402:3554:b0:659:31af:b9af with SMTP id
 4fb4d7f45d1cf-65bc41dc297mr5553172a12.0.1771303569746; Mon, 16 Feb 2026
 20:46:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 17 Feb 2026 10:15:58 +0530
X-Gm-Features: AaiRm50t13k44Sen9NRCY3Mfw1UqRelWB9C2dA3RFTYoLt5Y4mPqd0YjIZDY934
Message-ID: <CANT5p=orpQdzqxjNronnnKUo5HFGjuVwkwpjiGHQRmwh8es0Pw@mail.gmail.com>
Subject: [LSF/MM/BPF TOPIC] Support to split superblocks during remount
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	linux-nfs@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Filesystems today use sget/sget_fc at the time of mount to share
superblocks when possible to reuse resources. Often the reuse of
superblocks is a function of the mount options supplied. At the time
of umount, VFS handles the cleaning up of the superblock and only
notifies the filesystem when the last of those references is dropped.

Some mount options could change during remount, and remount is
associated with a mount point and not the superblock it uses. Ideally,
during remount, the mount API needs to provide the filesystem an
option to call sget to get a new superblock (that can also be shared)
and do a put_super on the old superblock.

I do realize that there are challenges here about how to transparently
failover resources (files, inodes, dentries etc) to the new
superblock. I would still like to understand if this is an idea worth
pursuing?

-- 
Regards,
Shyam
