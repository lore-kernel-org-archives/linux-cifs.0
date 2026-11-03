Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793746143;
	b=OaGCr+BYHaRhyQjP15MAO9XwUPAavigMbG/yVuESfH2lWZMTVfJNRNgwBKjhH8OPjWoH
	 ud2TCA9/+8rTyyxdJDHzTmh6VMMqfFTyo8v8dUrNVz0SN9rd49WC5FLrqTEHTCiG3oqHf
	 Tt7NRZ3gUuDwApYFUbwb55Ot+5JOTrve5m3VF7Q+4Xsh1bVgpq+suNZzfwq6F5jNiV70B
	 +CK6iKLmBfnJsmExjL567b6JZRZWuICnAJQE6Df1cG31/ZszvY9tFtONcP9rTeOR0UOOi
	 P6ueAhNLsaEsHFyWfkhqqqaJB4wte7M73vhcGPoPxqd7zOF7jhOWQqdZpb6ICG+yMuA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793746143;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=KjsO2xbI1+nan0ew9bz1EKvcLMTzPy170fWQbRpKB9M=;
	b=aeN2U7/xPXNeHeIoJvNeK8NWbK47JnJfnOU/HjIf+xjT9Qc0dFA4PyZblee2/VQ9gxfF
	 lq0EASTxMtXdDqkd8GDksHJFlSZ+DBVZGOYxQ2a4feI4ZBk8AplCuvCrJUcw+HzzMNA8w
	 IeaRWB5rVuzuhyQkJdGisPN1jGLEFEzwXXBRrUSyBn7TcQg3qOZ55wwnmzYNFDiIB5N4s
	 Ic4JEu1XhyiEF9Jk5IZEqfCnNK4nZ14lVwI8a6br6OkXRB85LhEd+D/xwx+VItfy7t1rI
	 QWDduTAqs54IqwzijdzU7uP84zyv7nxLazJxmAhww+DNbtiiB8h/gZ7tOzJAmzoQTUg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CZXpytd8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.172
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C21606A31B
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 22:49:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8C21606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CZXpytd8
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8ab37e44643so966057b3.0
        for <linux-cifs@vger.kernel.org>; Tue, 03 Nov 2026 14:49:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793746142; cv=none;
        d=google.com; s=arc-20260327;
        b=Ms2cUWknWdo3/REhOCmcVJhdmGasuAsNfTdyiD9/xNNorfzD4C+p3RvAO11NEffL6q
         GxQ3C+x2YKLeZFbNr6Pu+j5ooICUnQUQHdWokdCWNEGlj3VyXyGpVCRv1pToEeuNTEtS
         HxCekhd2MiDVt+x5EB3aHrbKHaDk1ymlxunFvzCYPoaWnk+4ZrHuq4fPH42x0k3BV4cg
         whJCynl+C34Xg++pfi1L0Gu4yQe9cluZP+60owoOsPHO/020yo6ceveB16Gui57hlY2U
         dZKueHZucmGHHzR4vypT3i6A5oJZFKZeOhHeBeNm6NjHDbczGpwZcRSxLC9gvgmQMEhi
         bfsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KjsO2xbI1+nan0ew9bz1EKvcLMTzPy170fWQbRpKB9M=;
        fh=qP/Clj4SYoUcsTkEsqq2YDqRTKNs5N77u81OOqhm5AY=;
        b=XThfkmdYXk1BYi5PPmVTcYlAcgzrBsLAyjZZmqWSqRUbh/eGL3zdU3iR00KRc7clkt
         UeW+Thuo+PYHeTlAcCtEQ3GIhJnh75ImNCR0v1nOl6ltUnZvNTreNJ8NtxL909ZKjZK8
         yV9PDYFtW2b0TM8f9mFReOTJMzmUmk5IptqH0zjLpYEex9PhRoVuSeytqmX4xlj1xrgz
         daBF3sjXcx+ZYqT6ZNDt8O8JFY8EJpJFgFFSxgx5ytJpPNPSIvd/VdDyxB1H/5E2TuN6
         zTgmaVwWgM+J+67Nk/UIm6cRStPCzhfLHx/G+lmIceDWkW2LsKK26RIWmFwNkvMUL5dX
         KvaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793746142; x=1794350942; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KjsO2xbI1+nan0ew9bz1EKvcLMTzPy170fWQbRpKB9M=;
        b=CZXpytd82N+GyyopJIgKJr2BdzKJ/NFxXhBg1NBKxHgCJwb4CGKc4PqEBOzKqRuX54
         LKDmdM9OEQQ2C/zoX7/gHYbCueFW6ANoy4cK4O2vXwCfWfmpnGz0C2bcs0xXAEfmsY9+
         +2rGrC3aL9wBy+1QFWzgBlBAXhUdEzYAAw6opZH8WSxD7cudjVkq+/RomwHbjl9JK1jg
         kRH32f+YDo3jdJQMgJ2ntNv+E/ME2cZnKLFLRivYq3QMgwN3T5qZBj7ZiBItzZ/Kst6H
         zntLBvINH7WK+LpY3TNnSWtTIFSMB+7DGJXT7Sn1gtDaHq0O8jiDCx5/XyssfhMp0rAn
         gc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793746142; x=1794350942;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KjsO2xbI1+nan0ew9bz1EKvcLMTzPy170fWQbRpKB9M=;
        b=NkN0BdHwAxL3yKAgKn6+XhFG7cW1gb+WqhxMusekjlRzd+3SI+sAIElQTLQaoxdiqn
         7HHyekSfOqttZxUaJVhn+ZrmauQsTCUP8acOsYthq9xpldiLiymTBBEjtXx03opRSVhu
         CRORZ7brF3v8MkBfe8JB4SIVvEEmzf8qTkNrcNk+MqW+4Gn+U7wDowkgBv+E1/XVKUwK
         gpczFDbHYAhl8c68HXmbSu4ZMYqNQTUoErtOc7r+/zft+LHvyScz+ymNMYlyTyOfUHtH
         +HF7VTOmxx5YDPOog7GFfsmTNivh3RwdDIhbif8Jx+/CblxL9tsXJUVsZnuPZJECWmnl
         KrVg==
X-Forwarded-Encrypted: i=1; AKwUvBwVMSampKzG4ZGgwsA+dNIDoUlXT+1RpdoR/pFmgPLm7wluejs7DJLJtrESF8pHKyFNyfRjspD9iCYP@vger.kernel.org
X-Gm-Message-State: APuU4Z+aUGRHD7PHx1MwsZgO56QNx9r8KIcUwyqPktmsxn+AE7/T6AWA
	xoQP9U9AYSW/UzWYS4p8TiRS1lmRNrb6jZaerb612j25U4ljUwt4aqzy0Eg6f5fEC68pfzdxIUv
	M8sH5nXs4vcNKvrYjQSyxHHpnj8NTlxw=
X-Gm-Gg: AYBFou3ZSBl2aeUXyjdmYCaJzHXADkCFBdph3seRieZoqSNme1qq07fXwsS3NDDVhz4
	IIIOp9eYm0aVj0p3L0d7bPOi3t6OZ+Eue4k9ICWBP3uv8rYAbLKWND19IB2JmQB1aixntn2j/1x
	ZHlP0uUulCXYB5UREr3aKC8A+3gGsXhN59BYcTLudPg1iz4do+DRa/MPifwFXTdyz2waTCldAAt
	+334zDB6ijOVlFVL8fS04faPmLTNbUMU2ouguTUO1pap+XjSPLb9oHME4ADeMPFYDFJ5hvCPa91
	nXnBC8Mad3e75FrB99vkWqkI6lQ/86K43iNkKiSFw+tnPmy2jg2mpveBNi+/JS/Wkt5lBuMgTwO
	vA7dUY7eFQq9Ozyny9mx3O/BrN8LYipqf4wfKvtu0m8MoNmhvxq2nDdlz6pddaLmNKT9tm6aQIJ
	ZX5Ixz+YQQ/bilwbqEcRERDn+5Oc8ncOMG17yZyQpjiePwiVcJFJopVmWj1N+giB15LhYysoQ8o
	cBmWOjL
X-Received: by 2002:a05:690c:f93:b0:89f:4c20:73ca with SMTP id
 00721157ae682-8b2b671f0f7mr94194447b3.46.1793746141623; Tue, 03 Nov 2026
 14:49:01 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102201410.55089-1-sidchintamaneni@gmail.com>
 <2026-11-03-1-daily-reply-0011-re-smb-busy-dentry-dio@kernel.org>
 <CAE5sdEi4GOXeVDPEUk-RR7bjE8z=25f+waQNedMQd6VCum3TrQ@mail.gmail.com> <7bd9007e90f271821114f617fda2c1ee@manguebit.org>
In-Reply-To: <7bd9007e90f271821114f617fda2c1ee@manguebit.org>
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Date: Tue, 3 Nov 2026 14:48:50 -0800
X-Gm-Features: AclHuK9F4A_hrgFEV-uV0gf-kgj7qpX4biDiSW1s2drGmroNJJVSplQURRyCVRY
Message-ID: <CAE5sdEhCOuK=UK1y-25rRZwj_Ub0Bd8jETKm-VuiYtceGAJv-A@mail.gmail.com>
Subject: Re: [PATCH 6.6.y] smb: client: fix busy dentry warning on unmount
 after DIO
To: Paulo Alcantara <pc@manguebit.org>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org, gregkh@linuxfoundation.org, 
	wozizhi@huawei.com, lsahlber@redhat.com, sprasad@microsoft.com, 
	tom@talpey.com, glaming@microsoft.com, linux-cifs@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, hargar@linux.microsoft.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 3 Nov 2026 at 14:30, Paulo Alcantara <pc@manguebit.org> wrote:
>
> Siddharth Chintamaneni <sidchintamaneni@gmail.com> writes:
>
> > On Tue, 3 Nov 2026 at 06:52, Sasha Levin <sashal@kernel.org> wrote:
> >>
> >> > commit 75f5c412fa867efa0bf9b646bffe0d912109e84a upstream.
> >> >
> >> > Kernel 6.6 predates the netfs I/O request conversion and instead splits
> >> > I/O across three reference-counted structures that each hold a
> >> > cifsFileInfo reference
> >>
> >> This is a hand-written 6.6 adaptation of 75f5c412fa86 ("smb: client: fix busy
> >> dentry warning on unmount after DIO") rather than a cherry-pick, so I need an
> >> ack from a cifs maintainer (Steve French or Paulo Alcantara) on the list before
> >> queueing it. 6.1 also has 340cea84f691 and the same bug; please send a 6.1
> >> variant too.
> >>

Don't mean to dodge your request. I'll work on it.

> >
> > CC'ing Paulo Alcantara's correct email for review. Thanks!
>
> LGTM.
>
> Acked-by: Paulo Alcantara <pc@manguebit.org>

Thanks!
