Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AAC3F58E0
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784739123; cv=none; b=Vm95zllyCunDcablgzUvTeKcbX4R8UZH3qyBSq6BZuyCD/BcRevJzrLDDET+/Omt44QH0JJzue/AUP6DEZwnWe+MTRNlyBNVAcSBbnyup3eP2Nxd9RsbilKPRJtvHbnx5uNBzMEQJj7d3YX1tR4p8lfdp+++DsZfdxzWwaApZt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784739123; c=relaxed/simple;
	bh=3OBjDCrXbkshDPWrBFZvUPmCd/A4iyF0hKSuVFjDq2o=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=APpqiQczH70xgiQcs8wvv+ou3ejPlifb5/AhyWQK+MARjx5FA6ykhkH9OfQpcK3DB5rv4H1FHbSCIhhNIMSbNWmO8RuJaeoyVCrOW6gt06D6awMsFsHV4uH2dmvNmTZ4zY15r+9qfiykiyl9+Fb/Z3OOL89/kNwKgqOHxzZ2+DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T4Oy45FR; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T4Oy45FR"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49553515a8bso49886595e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 09:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784739118; x=1785343918; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3OBjDCrXbkshDPWrBFZvUPmCd/A4iyF0hKSuVFjDq2o=;
        b=T4Oy45FRsQool3gTagcgDvStP4ABcXfRiueFgBhv1c2Ir4svF5BVLc6NGb61PpwHcO
         NC0i+SkTJIOfFxOgYcEWowhe9QccTxtoSqZ1oroyvQXKCg3RJV3Rm7dP2HzWfRoDlX88
         Gnpe8RBIKMc930f9I7eSKUueyhZYPyENgBCx8oeoibtkd+bYzrJmmRViayZYESVqFSNR
         525SWoxqIKMJzUuuqxBlF/nOC+pFTgdqjpqEpioCjtlyN4gqqGZ9ZBAs3B+A06sJlGb3
         p4Tk0Q4y2k5WkEH6sgPM3okmRjZJ+CJIw9cGoM+lc+hoXUPSvtJ5LpbuJwqbdqYNL/V1
         P0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784739118; x=1785343918;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3OBjDCrXbkshDPWrBFZvUPmCd/A4iyF0hKSuVFjDq2o=;
        b=FOUV1I9tXfd/AqrGT+/mnTIcjn2buMbJzjIi/RistE2bbUfOZ64CcAAwiJqoR8dsGj
         /wJf3W7LYsflBMjVT70PKpZcYt+J2W/BuCf8+mpZ9vej+6qOctyYqmlufLrAQ6UbPlzc
         kP3ORqoPs0ih5kjFyPXINXIFiZ2TbJ8AsWqJmXCoYfLhQ1BVgIZWVZBpTZ+NtBC3+/2G
         rSEoJhd6pr/QnxpsYBXOTfpKREnG+ypCrZTIJLiP9vsbJSV1edHliPPaP/mT1PQ2Ld/h
         C8maA6gFIlrD5/0saU1ugJZees3WqMKPuZIlQTlPfeWC7LrqujagraZp1FrJpje+EXF2
         KDKg==
X-Forwarded-Encrypted: i=1; AHgh+Roq8y1OhLqvKqmC+hTcEVcIZB35yItoiMyLrel6GKEOAX/Sf9a5kNk1fr7kAGWp42WWE+I3p4XrgLb3@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9Mhzrdnlyz0m4UxmHpog5kpEJIUhGEjFYEtkDEn4gx1+2cATJ
	Klkz6pXVUOA07wizbAb2BdElyLViudz2mUJ9zx8P5QfWYj3jxnsXMrfu6CkNxe+s49M=
X-Gm-Gg: AR+sD13zTkDbEEvCi2/o87kuBAYOEZ8PEyGcpwZjZES16bEHgoEGnoNTWLw8GYRnZgy
	rgtnaMJzyabuYrHeDOvSWVzRxTQ79HXRW902qInNoerwohzT5iF1tNamohtwHA/BS/21L+SwIHV
	zei7fzHugq6jVN9Y3ZW0kmfX1jG9O5VmT4PRRhdDu6GlZBfgmlQj2/R19DkH/ajRMabSTD0RNnV
	g39WHzqhJIdXj4+bTUbMoLyS9IeE9NgQnIXxQmTZzoNph2cpIcJqbZ2V/d/Xm9MYX3VZiCPlXLe
	8ydzlgxQ82SQ2i8pz205y6wk5RoAbc3xaVRWZvByOTf9qsYt8Aym6YQ4yuyPaY4EznTUywnlVXI
	Wqp8RGDSlyFH6pcPNdYLgva7xrQDprxv8zdTCWBWxegmTWqon4tw1O9sJ7QsmuqeC+6pjAa/JiX
	wX2OTKBAh2fw==
X-Received: by 2002:a05:600c:a0a:b0:493:ee2b:c876 with SMTP id 5b1f17b1804b1-4954a41302fmr281006525e9.35.1784739117891;
        Wed, 22 Jul 2026 09:51:57 -0700 (PDT)
Received: from localhost ([2804:1b2:1845:e230:d77c:4dd5:9d52:7b96])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c2c6486f59sm3647313e0c.11.2026.07.22.09.51.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 09:51:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 22 Jul 2026 13:51:52 -0300
Message-Id: <DK597PFVFKJJ.2OYNPDJX1P98C@suse.com>
Cc: "Paulo Alcantara" <pc@manguebit.org>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>, "Tom
 Talpey" <tom@talpey.com>, "Bharath SM" <bharathsm@microsoft.com>, "Henrique
 Carvalho" <henrique.carvalho@suse.com>, <linux-cifs@vger.kernel.org>,
 <samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] smb: client: define async channel update serialization
From: "Henrique Carvalho" <henrique.carvalho@suse.com>
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>, "Steve French"
 <sfrench@samba.org>
X-Mailer: aerc 0.21.0
References: <20260722041043.90682-1-pengpeng@iscas.ac.cn>
In-Reply-To: <20260722041043.90682-1-pengpeng@iscas.ac.cn>

On Wed Jul 22, 2026 at 1:10 AM -03, Pengpeng Hou wrote:
> Commit 556bb341f9f2 ("smb: client: introduce multichannel async work
> during mount") moved multichannel setup out of the mount path and into
> independent work items. Mounts can share an existing session, so more tha=
n
> one worker can update the same channel array concurrently.
>
> cifs_try_adding_channels() snapshots chan_count and the number of missing
> channels under chan_lock, but drops that lock while each channel is opene=
d.
> Two workers can therefore act on the same initial count. More importantly=
,
> cifs_ses_add_channel() publishes a new slot before taking session_mutex, =
and
> its failure path later decrements the current chan_count. If another work=
er
> has appended a slot in between, that rollback can remove the wrong tail.
> At the array limit, a stale worker can also index chans[chan_count] after
> another worker has filled the last slot.
>
> I considered making the mount worker use
> CIFS_SES_FLAG_SCALE_CHANNELS, but that flag is not a blocking lock. A wor=
ker
> that fails to acquire it has no retry or completion to wait on.

I have a patch that uses the delaying idea, please see: https://lore.kernel=
.org/linux-cifs/20260429205236.456099-2-henrique.carvalho@suse.com/

It should be rebased and tweaked, though, I have been delaying this for
a while now.

Do you have any opinion?

> In addition,
> smb2_reconnect() currently clears the flag on a shared exit path even whe=
n it
> only observed another updater owning it,

Actually this looks like a bug to me, no? Why is smb2_reconnect()
clearing a flag it did not acquire?

> and an early channel-disable path
> runs before the existing flag acquisition.
>
> Extending session_mutex around slot publication and rollback would serial=
ize
> concurrent additions, but it does not by itself serialize the reconfigure
> decrease path. Conversely, a new mutex around all of
> smb3_update_ses_channels() needs an explicit lock order because reconnect=
 can
> call channel removal while already holding session_mutex, whereas channel
> addition later acquires session_mutex for session setup.
>
> Would you prefer this to be fixed by coalescing mount requests onto one
> per-session work item, or by introducing a dedicated channel-update
> serialization primitive with an agreed lock order? Once that lifetime and
> locking contract is clear, I can prepare a narrow patch and keep the capa=
city
> check at the actual chans[] append as a final invariant.

I like the idea to put everything in the same worker so instead of
having a mchan_mount work have just an mchan_work and reschedule it from
mount / remount / reconnect.

I have started this but abandoned because I couldn't find a good enough
reason to change things. It just seemed I was moving the complexity
elsewhere without any real benefit.

--=20
Henrique
