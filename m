Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7804F052F
	for <linux-cifs@vger.kernel.org>; Fri,  4 Sep 2026 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788535310; cv=none; b=aHidsq+PvkCUXBTE2l7ONkOTZ2AhK8Ahz20QAuAwdrVdjHR0h2EKANp7FauALfKyEGaDGzN0aEJhjmCY/ax/nam41BO87zgTruYfXBrlArAjqPon4dqWI3dLeWbuf6W0/q3GX6z/4A9+Wgx7DraNC+OzZ/4AUbjI1h/vjQSl8E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788535310; c=relaxed/simple;
	bh=ZPjOre1AVHe4tzIsVMCyiaCK8qcg5TyI3ieM/HdkmcY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j/uIKkfOD8MulTrx0rg1Q111VrD3AirHP40HMBOvV8J7+uf8Sqog0nGFIyPDRzP44bfIJni2v1LqUm2z8yOYTrWH2rewdnYiOJS/UWnsG8/CGkfX5tfmiQfKqfSsvNrm54Pb1UIwl961l7/ctR/FLsjM2RVOPuKvDWFF2pfX3g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A5BGn5CV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A5BGn5CV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71151F01559
	for <linux-cifs@vger.kernel.org>; Fri,  4 Sep 2026 15:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788535308;
	bh=noNcnaSgYcuGDqPOvPD3MKIn/qvvsMZ0yW0lmGCp6TI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A5BGn5CVLu9p35XLDHOw1Tsfj2whNrCgaqq2C15v3essEfIRXGrNArHrXZs1eztLv
	 yuMxlcAImOh6NDxq1zimspPKC2xJUzTngtjr87SbJb1bebFohyEVhqcNSVFsoh8kYK
	 p/60mNpL1FsSjaSppg0+IWxaLXNEFN73h9esaiOxZpkVhGgsgA5GRX45e5zBrHqPjV
	 JGPCZt/DQvaTgR6shjOoFZNIZoTOMvCDKpweqG3WpLQa/0O3KFocYv0DSFZY4Oft8t
	 bHY/kgVnEy5JZjYSZeVQuau9NS1uSkbGN+SJyitljN9SZwbya6XwuIwbOpPbb8BFjK
	 OK0a1FzgxJOpg==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c20ce3c118aso235173366b.0
        for <linux-cifs@vger.kernel.org>; Fri, 04 Sep 2026 08:21:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByYN+u45rMA8bE7ucJJhGq9pBL0MYz1+1VH2SLojoju2aZZOwiIcFQGfuG40lTm3WfamwSMpnuCX2ca@vger.kernel.org
X-Gm-Message-State: AFuF++lfnystthV2O0Shj9XlrS0DHKp/o/q8T5UKoMHJ2XcCimW31ZJ6
	dsXRTkgdZM0R66wRIQuDjscdWcbMnns7M1uMfAnXn4gOYH6vxFVoQW+aUvTEN9krbrewxRjHfnt
	y5X/1iPTGmb/IwrsY7ngA5d0aVpU5vDM=
X-Received: by 2002:a17:907:3f9a:b0:c25:f7db:4bef with SMTP id
 a640c23a62f3a-c261052e046mr211362366b.21.1788535307125; Fri, 04 Sep 2026
 08:21:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260904104236.1603533-1-doebel@amazon.de>
In-Reply-To: <20260904104236.1603533-1-doebel@amazon.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 5 Sep 2026 00:21:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-jDPZh_x5JaOpMzHupWi97GTR_MJYhDyph4T6DJLRaFg@mail.gmail.com>
X-Gm-Features: AcwNN1W4mCJiMWNg-5I52x7pm-vYbz_0PGXse1bEu7rBrSariaLbj7x-e9tHB_A
Message-ID: <CAKYAXd-jDPZh_x5JaOpMzHupWi97GTR_MJYhDyph4T6DJLRaFg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: avoid leaking refcount when cifs_sb_tlink() fails
To: Bjoern Doebel <doebel@amazon.de>
Cc: Paulo Alcantara <pc@manguebit.org>, stable@vger.kernel.org, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 4, 2026 at 7:42=E2=80=AFPM Bjoern Doebel <doebel@amazon.de> wro=
te:
>
> cifs_oplock_break() takes over the reference that
> cifs_queue_oplock_break() acquired when it queued the work, and drops it
> with _cifsFileInfo_put() once the break has been processed.
>
> Only in setups with "-o multiuser", cifs_sb_tlink() may fail, at which
> point cifs_oplock_break() returns without putting the file reference,
> mirroring the reference leak we already fixed in the companion patch to
> cifs_queue_oplock_break().
>
> This would trigger a crash due to busy inodes on the next unmount:
>
>   BUG: Dentry ... still in use (1) [unmount of cifs cifs]
>   VFS: Busy inodes after unmount of cifs (cifs)
>
> Drop the reference on that path as well. Doing so before the out label
> mirrors the normal path, which also puts the reference before
> cifs_done_oplock_break().
>
> Found by Sashiko code review. The failure path was not exercised at
> runtime.
>
> Fixes: e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break")
> Cc: stable@vger.kernel.org
> Assisted-by: Kiro:claude-opus-5
> Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
