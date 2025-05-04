Received: from gavin.smtp.mailx.hosts.net.nz (gavin.smtp.mailx.hosts.net.nz [43.245.52.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849853597E
	for <linux-cifs@vger.kernel.org>; Sun,  4 May 2025 08:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.245.52.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746346943; cv=none; b=JhU5ZBTpQTaiOJtrEKi2kZ9ejioyn1h59ahSEw6tk0wMFtRQQyhqwvwi5M8p2hzlIs0kV6OJWwjUwQbLrM9E5amH1x+rcTrLMB0fROUEsVJLJr5b70gNul95bnewr3D9VmQ09qAl/NJHBnbnPDpp7QyyggTL9wproAXjq1heCXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746346943; c=relaxed/simple;
	bh=N9OpSoUuiJqZsU7Z6K+Z0r/eQPurso/H+XYsjdZl5m4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=izX+S8NQOzf7mVxmZgKmA0gxZ0TJdeOKNooZtFPdDe4j3kB1kQWDCaotHNW98Knk5QPoRm1Lc5SqxMZv2OyME1jShSMBMIxvVsO+UUdAcXcBbmbvJjdwDVC2F5OrFWIJMheKNBnLk3Paf+xG4M4/xgjO7R+oW6HvaJKNNfnVZr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jro.nz; spf=pass smtp.mailfrom=jro.nz; arc=none smtp.client-ip=43.245.52.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jro.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jro.nz
Received: from [101.53.218.93] (helo=deetop.local.jro.nz)
	by gavin.smtp.mailx.hosts.net.nz with esmtpsa authed as jro.nz  (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <devel@jro.nz>)
	id 1uBUMa-00DLEZ-30;
	Sun, 04 May 2025 20:06:17 +1200
Date: Sun, 4 May 2025 20:08:25 +1200
From: Jethro Donaldson <devel@jro.nz>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com,
 "Volker.Lendecke@sernet.de" <Volker.Lendecke@sernet.de>, samba-technical
 <samba-technical@lists.samba.org>
Subject: Re: [PATCH] smb: client: fix zero length for mkdir POSIX create
 context
Message-ID: <20250504200825.257f762f@deetop.local.jro.nz>
In-Reply-To: <CAH2r5mvi+N7w=EmzSgH9YxEEbDLn0HXZ8cni1PKC+3d6qaS4XA@mail.gmail.com>
References: <20250430005915.5e1f3c82@deetop.local.jro.nz>
	<CAH2r5mvi+N7w=EmzSgH9YxEEbDLn0HXZ8cni1PKC+3d6qaS4XA@mail.gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.48; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Hosts-DKIM-Check: none

On Tue, 29 Apr 2025 11:20:14 -0500
Steve French <smfrench@gmail.com> wrote:

> Good catch.  I did verify that this fixes posix mkdir to ksmbd.  It
> didn't fail to Samba with posix extensions because Samba didn't check
> for the incorrect length field.   The fix also avoids another problem,
> an rmmod crash.  See below.

Must admit I didn't ever see that crash as I mostly use module-less
kernels, so thanks for sharing this. It doesn't really seem like the fix
I'd submitted has any business resolving that?

I have checked I could reproduce the rmmod crash using a modular
defconfig[+smb] kernel in qemu, and then _with_ the fix applied to
cifs.ko I've added this snippet to ksmbd_smb2_check_message() in
fs/smb/server/smb2misc.c:

+       if (command == SMB2_CREATE) {
+               struct smb2_create_req *req = (struct smb2_create_req *)hdr;
+               if (le32_to_cpu(req->CreateDisposition) == FILE_CREATED)
+                       clc_len -= 40;
+       }

This reproduces the original behaviour in cifs.ko in spite of the fix,
forcing the client back down the error handling path. The rmmod crash then
still occurs. I suspect that won't be any surprise and that you'd chosen
your words deliberately when you say "avoids another problem", but felt I
should share this observation just in case.

I'm curious and will try and make some time to look at this closer, but I
suspect it's not so much of the low hanging fruit that the prior fix was.
Any tips or pointers to documentation welcome - very limited experience
with kernel or SMB stuff here.
