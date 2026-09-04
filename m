Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AB33A2E33
	for <linux-cifs@vger.kernel.org>; Fri,  4 Sep 2026 02:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788488779; cv=none; b=F0VdRNKZlfofOKRW4DDoDLhX/j17hyrgkEdmIC7HTx9fIZxjGm9dkbOwsY1n8Yy9r8qgS2oN/yUB0LvZNuadCOEtBpkIrxDtRouTK8ukJ525hsPpYP+FMDkQwVlXTvM6iPBPvLGltp/eWVQEgLrsv4M85rTssbLEE0LFBuaWos4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788488779; c=relaxed/simple;
	bh=Tg6zuH3sUWluVbRaNeVKRZOy8j03OWHB4FCc0r2dNYg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uW0z2z4r+B+YpvbT02jbGFQAqgQVYoFKisLGSkJV4NXAemRCE+izu0RMFdL7Q1nQAGW4F7PC3lJcHrrhRMUJoOqJH8AdwNddeBmbdhlFvUNRX3/1Ogk7ZEPKraWNooh0qcLwHZxtg2hOX3Ex4FdP/F7Ze0NUN3M9NpIXsV02L2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JmU3JtgO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JmU3JtgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6227D1F00AC4
	for <linux-cifs@vger.kernel.org>; Fri,  4 Sep 2026 02:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788488778;
	bh=tV/I5xR6ZF28TVIBU+cDKkpI/SFenH9y4vbThQbqUZo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JmU3JtgOBrhkoXsZRm8CpcRDfYsQinlkJThB2bv/50zsc1Tj2rWIYjSWw7KJkhxkj
	 3AQNnC8a5TVyoFIHjqxG+GKsPsBdgXJNrITzY/L1EL3DQ29sBEpmnxoI9c3izTfQ8O
	 hzLIE6ltpVuTARLXotL+rxD/7yvgqOj8vlt528ke5juI340eGShVj3bGMzeTf6G51q
	 hwmEuFe5K0nXdjaTHr6MguQ9+xEbSUYTC4YGIE5nSOcAKpmFpsPhXmAAYq9nGtX5vW
	 4yGSHXKAeKZpvi9jWT2K2KeOnuYyPod9l6P6awh4t/WGPGIBRnXT8AuHtR6hHRyYx/
	 El0EJCJlLZ7Dw==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c2531f453eeso67177766b.3
        for <linux-cifs@vger.kernel.org>; Thu, 03 Sep 2026 19:26:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByGGGdAeajLb3zk/42kjvxNSY8vAqNOsZ3tKBExngdOXUUHAoOS0tv968kPFGnTEyXGfO73zpyV68H8@vger.kernel.org
X-Gm-Message-State: AFuF++miykaGo3hzEwet86+stJHuNz6qdiVHcaa4SWZRe++wYlliELlu
	0X5AVO6uUxetyxHNbQj2pzmm5VlMb8IHSlY+LACROwm90QK4r3J1sWa7dVfR6agBW1wRmxyNZsA
	fiVxxA/6/t8YgscsdyPMx5ukQ16AVgpo=
X-Received: by 2002:a17:907:608b:b0:c24:c0f4:899d with SMTP id
 a640c23a62f3a-c260cb46b1cmr197588766b.22.1788488777053; Thu, 03 Sep 2026
 19:26:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260903212858.728118-1-doebel@amazon.de>
In-Reply-To: <20260903212858.728118-1-doebel@amazon.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 4 Sep 2026 11:26:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8rJF4qV1hkuaA6PQkngV7DM-HesoQ0ATWHEGa0Bm=krg@mail.gmail.com>
X-Gm-Features: AcwNN1VDwbMsOiTILhXofXiDSvCFjUYC07piWa6RnxgEF613YvSytKyy4xqmpns
Message-ID: <CAKYAXd8rJF4qV1hkuaA6PQkngV7DM-HesoQ0ATWHEGa0Bm=krg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: avoid leaking refcount in cifs_queue_oplock_break()
To: Bjoern Doebel <doebel@amazon.de>
Cc: Paulo Alcantara <pc@manguebit.org>, stable@vger.kernel.org, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	Aurelien Aptel <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 4, 2026 at 6:29=E2=80=AFAM Bjoern Doebel <doebel@amazon.de> wro=
te:
>
> cifs_queue_oplock_break() unconditionally takes a reference on the
> target file before queueing cifs_oplock_break(). Only that work item
> decreases the reference counter again.
>
> If another oplock break arrives while that work is still queued,
> queue_work() will return false and not queue this second work item. As a
> result, we will never reach the point to drop the file reference again
> and are leaking this reference. This can be triggered when interacting
> with a slow-responding server.
>
> As a result, later unmount operations for this file system will fail with
>
>   BUG: Dentry ... still in use (1) [unmount of cifs cifs]
>   VFS: Busy inodes after unmount of cifs (cifs)
>   kernel BUG at fs/super.c:777!
>
> Fix this by only incrementing the reference count if the work has been
> queued successfully. Taking it after queue_work() is safe because all
> three callers hold tcon->open_file_lock across the call and
> _cifsFileInfo_put() decrements under that same lock, so a worker that
> starts the handler in the window cannot drop the reference before it has
> been taken.
>
> Fixes: b98749cac4a69 ("CIFS: keep FileInfo handle live during oplock brea=
k")
> Cc: stable@vger.kernel.org
> Assisted-by: Kiro:claude-opus-5
> Signed-off-by: Bjoern Doebel <doebel@amazon.de>
This seems to fix the issue previously reported:

  https://lore.kernel.org/linux-cifs/8a5fd5ca-9f77-42f0-9141-d5d88c1df067@c=
henxiaosong.com/T/#u

Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
