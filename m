Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F339C79DA
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 00:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789258605; cv=none; b=Y9Sj7JVd61D9Lc92e1rIeH44yOT1dy41aSbxf4who1Vh/e3uIptnUwMitChWCJpSVCfIwfzoxyM5ORpIe3r00Lziwe2wjbPbPs+rZXyEjJIsHDGai1jyBI5z5lzFV7XamFnfheUBvr9Kl+VXT457ZrrSRgwd0iCVkOauF63Qd0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789258605; c=relaxed/simple;
	bh=K93JjxfVWTbVc5J84tzC1c6xHkrZ1i1aRo1YDlITJVI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KbCJwGIjgJlWumTAKNBnlE/IQCVvRnn83KENX9SptsBj7mm2TvgZlOOXSz9e2uBoYS3zSKNmg9yh6AFqzAePANhDLm3OiV48M0y1ZUrLk/w77NbZ4HJCmABabdeWnURwp90Uv1B/iCUjmOR0GHv4dP6mzHTDlic90/B48tMFrIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ECBNbBXi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ECBNbBXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2861F0089A
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 00:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789258603;
	bh=ykMd2nIO4fq4zCWHnMs0SyAl3HMmRtYQO1fhrdSGI9U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ECBNbBXi1RJnOiSFdLTbFjG8H0gyB1o3SHCFTHgfxaoi9BU2cKuBHKwGg245V5IkJ
	 FrtNWAUYByj7CPsB2LC0n5DMtOZshvCf+m36I2Gjw00IFcv1WONaQl+rmY01VJbEsx
	 g9+sPnKu0AXwSLfxb1tk5iEMp+Ko5vRRIarQdG0bKIavvUYOmdJJjSVpLljN8b5zzE
	 1kePIBLhlWJAMS8MoBIEfUBuEUkh2pLxw17Z+EgYAaCOWbIncTRBi3vvH7mw+74FSs
	 IiA9EGheO52en2BGjb9MclNzon0cKNyfZHj1R8MFCe+D0mADjm1WFX5OGDBKnAq/cl
	 izpgpaOu1eAAA==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c299de66a99so34340066b.2
        for <linux-cifs@vger.kernel.org>; Sat, 12 Sep 2026 17:16:43 -0700 (PDT)
X-Gm-Message-State: AFuF++nV7eqj5G+UX9oA47L8mytLP+stmaa9Y+4nuKreLNARjj07K0VJ
	hC6r838+dHeZIG26YF2WKR2YT3ZqIVjzvCXWPBZT9jUraTkuK2WLzOv0IFIPYVvhdwaBbsxb3Q7
	4BblIX/VbNziDTfejsSTvfl2G94teLrM=
X-Received: by 2002:a17:907:9406:b0:c29:53eb:9919 with SMTP id
 a640c23a62f3a-c296678b861mr548032566b.40.1789258602052; Sat, 12 Sep 2026
 17:16:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260912152008.392251-1-pc@manguebit.org>
In-Reply-To: <20260912152008.392251-1-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 13 Sep 2026 09:16:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9GiyCxnEzcHYffVR-9ZtwWLtaskKj4Xq6c96Sy9rAR8A@mail.gmail.com>
X-Gm-Features: AcwNN1V_t0iF3iPc-kRr-Lqbl0tWGhWCAgF_MZveUQi-Jd3YvdJeZExLrDONGpY
Message-ID: <CAKYAXd9GiyCxnEzcHYffVR-9ZtwWLtaskKj4Xq6c96Sy9rAR8A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: cancel reconnect work in clean_demultiplex_info()
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, 
	syzbot+5003556314abc915a71f@syzkaller.appspotmail.com, 
	David Howells <dhowells@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 13, 2026 at 12:20=E2=80=AFAM Paulo Alcantara <pc@manguebit.org>=
 wrote:
>
> clean_demultiplex_info() cancels server->echo delayed work but not
> server->reconnect, which can cause a use-after-free when the
> demultiplex thread exits while a reconnect work is still queued:
>
>   cifs_demultiplex_thread()
>     cifs_readv_from_socket()
>       cifs_reconnect()
>         __cifs_reconnect()
>           cifs_queue_server_reconn()
>             mod_delayed_work(cifsiod_wq, &server->reconnect, 0)
>     clean_demultiplex_info()
>       cancel_delayed_work_sync(&server->echo)   // echo canceled
>                                                  // reconnect NOT cancele=
d
>       kfree_sensitive(server)                    // server freed
>
>   ...later, on cifsiod_wq:
>
>   smb2_reconnect_server()
>     server->srv_count  // UAF read of freed server
>
> Fix this by canceling server->reconnect delayed work in
> clean_demultiplex_info() before the server is freed, the same way
> cifs_put_tcp_session() already does.
>
> Reported-by: syzbot+5003556314abc915a71f@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/r/6aa4a12d.f81106d8.2ab401.0023.GAE@googl=
e.com
> Fixes: 53e0e11efe92 ("CIFS: Fix a possible memory corruption during recon=
nect")
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
