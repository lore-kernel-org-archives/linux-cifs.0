Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF9F657C5;
	Wed, 17 Apr 2024 21:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390265; cv=none; b=HpRvlLTIDPaYlE6DvY+Yq6azFyTdaGiIQmrDVcCrmxKQtBS+L+c1Sbx7WmOW2He6OWEWLQ54HfX8wVY2QTacJJAepYaSkTxLxWphF2kTejPWnVfi0AIGLQgbvc8+g0Y+bQgrJyhrl2eXZS1T0raMKlo7z3wwdRidX85hFY5rvW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390265; c=relaxed/simple;
	bh=CKUQsG0mmfIa/QAx1wtwzpQgzNw8NsmVWIrXBKfxecw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AkUPzwaPOR/CaLAIedUFRBuJhjgWiFkj8tK9KoiJjDzIVmJ5D186HaTiQ4IcR02uSFi/DonJLex01hW/kd9c0+VessLHm3PqMirDbxo6B4yLEwt96IqHPWnf0WlNResNuCtMf4MaXdf4zMtiVMzpIy7b61bkuNMb1KTIy00j3O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJGu1HGa; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJGu1HGa"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a5565291ee7so9573466b.2;
        Wed, 17 Apr 2024 14:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713390262; x=1713995062; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=R/cPwbUkdSnGIuJG3R0hCFpAuz58iZdf0S7zyLL6x1I=;
        b=iJGu1HGav9qmaXrEAcVAl/hgUJ8Crkm5MOaRky51TrrI2hoDrTFOYJiwapgkKcs9KK
         AfKB6CJUtV6E4HWsQToJ8OhcEfmLomOUa/KVnxG+Vk2O9bZ79NUowTv2uMDkask6fLyr
         ZyKghey+JnHjrK6IIQgSvZpGXHugUH3Rel8C0wuToHshGiVQc8wWDMmZszNM/BxOf+dW
         ihk/kAdQ22TRWVnHHJB401cMhcp1PGmESEfrxOPrfER66oZuRGHDvg1MzC+1v4INuKwA
         FV3SF/A1XOxlS7f+6EQMTs4qu3VzGMKeP3/oT998pfvbLgPEHyI+ggb+oVWWPkIjVTYT
         quSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713390262; x=1713995062;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R/cPwbUkdSnGIuJG3R0hCFpAuz58iZdf0S7zyLL6x1I=;
        b=r71yLT0hANgqgYoHPrCi9lTzGQGDYliKzLnWhujTrCiqID9dXdV1idwSFnlEDJEfzK
         QS0HlKix0vyshHrY4EOcWxazcfceq8Vq31y/Bsy0dO/19W7ohY1BoLTGejbf/r1EfTrf
         bnT2aq7BTMFxXm6qcdoIOLRj0CwEYjNcf+dd6TX2ZvXFwPPl/ut/fVMTPTAFgts3Tecb
         bIZMqjmubAhB51ale43CPUceR9w0XigrGxhALlTwY/cQsqBMo1c1w/9gDYIREIOsX45j
         offS4ybu5GsvpGH24SC9D/kGfgrzEZK3luKGKpqsQoDEYOnT2ZBJ2/4bnPR2LOwUmaB+
         n+Cg==
X-Forwarded-Encrypted: i=1; AJvYcCV52/sTR2UbKw5sz+Wmn19cgyTggfeVFFlu7ic2o+bdklXgvHsiId0RgjoGU/YlLrs2IVUfGZHdWGnCEr8LrrdkS3NZmbqwnu+MFQnQfclGtyP8dCo18eg3vC8lCjFtbVGcFA==
X-Gm-Message-State: AOJu0YxJZTrGGbLq5c8kWwBAeSDGU4LD4I8+Qq6tHmvxlXBkbbIqJ7uN
	yxoUzvodAdMElZkob1oKjy1QEmlmqWZMfcqiwp6tzAXrMCsXkENx
X-Google-Smtp-Source: AGHT+IGhziwNWrUflqmylzgphhuQqIOdmIo9FOUOgVFe3BA/1KzCoiE0xie2CFOhoM7YIWuhY0ETsA==
X-Received: by 2002:a17:906:6d99:b0:a52:5d42:a542 with SMTP id h25-20020a1709066d9900b00a525d42a542mr416739ejt.63.1713390261177;
        Wed, 17 Apr 2024 14:44:21 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id p7-20020a17090635c700b00a51e6222200sm66605ejb.156.2024.04.17.14.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 14:44:19 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 90DEEBE2EE8; Wed, 17 Apr 2024 23:44:18 +0200 (CEST)
Date: Wed, 17 Apr 2024 23:44:18 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: regressions@lists.linux.dev, Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Cc: gregkh@linuxfoundation.org, sashal@kernel.org, stable@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [regression 6.1.80+] "CIFS: VFS: directory entry name would overflow
 frame end of buf" and invisible files under certain conditions and at least
 with noserverino mount option
Message-ID: <ZiBCsoc0yf_I8In8@eldamar.lan>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Paulo, hi all

In Debian we got two reports of cifs mounts not functioning, hiding
certain files. The two reports are:

https://bugs.debian.org/1069102
https://bugs.debian.org/1069092

On those cases kernel logs error

[   23.225952] CIFS: VFS: directory entry name would overflow frame end of buf 00000000a44b272c

I do not have yet a minimal reproducing setup, but I was able to
reproduce the the issue cerating a simple share (done for simplicity
with ksmbd):

[global]
	...
[poc]
        path = /srv/data
        valid users = root
        read only = no

Within /srv/data create an empty file libfoo:

# touch /srv/data/libfoo

The share is mounted with noserverino (the issue is not reproducible
without at least in my case):

mount -t cifs -o noserverino //server/poc /mnt

On each access of /mnt a new error is logged, while not showing the
libfoo file:

[   23.225952] CIFS: VFS: directory entry name would overflow frame end of buf 00000000a44b272c
[  603.494356] CIFS: VFS: directory entry name would overflow frame end of buf 000000001dbf54e1
[  633.217689] CIFS: VFS: directory entry name would overflow frame end of buf 00000000fb4597c4
[  642.791862] CIFS: VFS: directory entry name would overflow frame end of buf 0000000023b48528

I have verified that reverting in 6.1.y the commit 0947d0d463d4 ("smb:
client: set correct d_type for reparse points under DFS mounts") on
top of 6.1.87 fixes the issue.

#regzbot introduced: 0947d0d463d4

I can try to make a clean environment to reproeduce the issue, but I'm
not yet there. But the regression is related to 0947d0d463d4 ("smb:
client: set correct d_type for reparse points under DFS mounts").
The mentioned commit was as well part of 6.7.7 at least, but I'm not
able to reproduce the issue from another client running 6.7,9.

Does that ring some bell?

Regards,
Salvatore
