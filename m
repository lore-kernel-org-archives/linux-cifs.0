Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BFD10A19
	for <linux-cifs@vger.kernel.org>; Mon,  9 Sep 2024 01:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725844327; cv=none; b=mermKCnC3rzG5kl+XnjGrtMY3Fw5NNv6cBlNSvEw6QGr7OJ/0eieKebUKNlXYNy7Tu9Q7yRaLNX+rfiswKAV5Ai4yqCdUMTGI6u18wmGZhv8PEdZLaewu1yXdbuYmy86wZ0jVZVuBI0a1jJeTZ5Kj6E8BGzFfzj8nvjGkl+ExLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725844327; c=relaxed/simple;
	bh=kMFq9Bjek23sGcKhSQJkxbwovBEt8TM+Xx3OPL1lCl4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=FH5yxDPAUlTnaN9+VvIjEK+DJ9I/1SXwKffhEMxey2eERe3jL0ardOf4Mtnx+I9XWfEgR0c9vku1M6rpxfI3srP9JTpHJWO2b2DKtQBby+nwbJDoetZUPsVWIkUdQ7jq8swvdsI3NZqT5Dsj4YezE+E+HWZVEGXAI/YZPNLirZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nleTiAiX; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nleTiAiX"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-53655b9bbcdso3390371e87.2
        for <linux-cifs@vger.kernel.org>; Sun, 08 Sep 2024 18:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725844323; x=1726449123; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FC8DA1RitRFO9s2XSqQLDWC+hDdqNRLOBg1YLV6pXX0=;
        b=nleTiAiXiwB63B2dAyc1aYccbWljeI5bwOajhjFBECMc8WvMGmjlyEbuN45B+VjTWO
         OAMDtOQIxWCTKZgwHWKEdsqYXXBOua09tmnOqECvKSx/IKc9M+VYr3y+OEryTeqbSL2+
         lCDHcpIooEBCi7zyaeaXNaWxxfMzFg2QYBK5Cvh+z9ek8FOYPWuvRmyPbVDi63KbVH22
         GZX/whN/sRZFwwf31EjFY1/nR5BMG1oXAGt/YdHxpYU+R8rZ3w5PfXP3R8zwQRypQTQB
         M10Ncr9Lu5tS42gZ11UA3Z5G0xIZrW2Cdqn8uMUk0K+nDaFts0YXUbwwk7WvvJlhcv5g
         //wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725844323; x=1726449123;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FC8DA1RitRFO9s2XSqQLDWC+hDdqNRLOBg1YLV6pXX0=;
        b=t4KAA9Oylpj0t3ps79VS2ZomL/BKYG3CMAf6805/TZ+ho9XBTr+gJGYNGF7mW2vU5A
         m6M13pR5NUpJ5uqk/R0GpnvMqRx+yrc4OHqYJGUbtDkLfEF4CnzhHHFs1EPHsDtdag8N
         Xi3JMzJ+qhynQoXpDCtV35Lbx9xeuX/pn/0hXsfCmUy9JD4xZv1SNfgGOxjhfdGbq5gv
         Ooq/rdVP7WSYFxwZo4PpAoK+Upfd5flmc71+3f4Zr6ovq5VZi7sMUVh0fKK/3DukXRAz
         1jxE4IJ1NjxENC+6+zl/tgewooxKd/tvLY5JLYQglr0uItM6MCxEZ3+Squ+OcehmK6pV
         THQA==
X-Gm-Message-State: AOJu0Yy6cIjVgQ1Ri1Fuw/wsUwGr5ZLD7oIVJbPT+ORUInyZMyE4B8IG
	lQrdtyeNOIRiOxSBkwYYHq9+T2xuKbr4hstnugU9DCVMrjhNVk2d8syrzP+vyWbCKXHnwcJYwOf
	itG0Q4ebL1QGBjX+hwNiSMNRGK3TUWxBvsYc=
X-Google-Smtp-Source: AGHT+IE06XlY3Aws/B4tNQpqklSEnl2D64bvLknSxCUR5e+FK74bGoMU+jMb2P3OyiEie2EPk1Y5QYA+3j4xUM3pT4g=
X-Received: by 2002:a05:6512:2313:b0:535:3ca5:daa with SMTP id
 2adb3069b0e04-536587a54a5mr4830421e87.7.1725844322625; Sun, 08 Sep 2024
 18:12:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 8 Sep 2024 20:11:51 -0500
Message-ID: <CAH2r5mvVZrgVTdmxXwVVYrNkCS-QXQkMhwCA9At+mboiBvE-5g@mail.gmail.com>
Subject: generic/236 test failure (failure to update ctime on hardlink) turned
 out not to be a client issue
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Cc: Paulo Alcantara <pc@manguebit.com>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Was having problems reproducing the generic/236 ("Check ctime updated
or not if file linked") failure that we saw on the buildbot to Windows
(e.g. http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/6/builds/67/steps/91/logs/stdio)
but then found out that the issue was the clock was off on the test
server VM.  When I reset the time in the Windows server VM properly
the test now passes in our 'buildbot.'

The test (generic/236) still fails to Samba server but that is a
server bug (Samba server reads ctime from mtime so you don't see ctime
updated on hardlinks as expected), but at least this test works to
Windows server, ksmbd server etc, and have confirmed that it is not a
Linux client issue.

-- 
Thanks,

Steve
