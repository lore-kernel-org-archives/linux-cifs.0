Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928BD12EBD1
	for <linux-cifs@vger.kernel.org>; Fri, 16 Feb 2024 14:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708094506; cv=pass; b=s2279iLCFeX3t0Mw1iDn79fku8y81NJK7x3OZ3QavMEL9ixYuiw15/eugCPpcc/3FDXD2ppkzPQa86hFdNt3f1cdIOX4kfo7oJK+6QEvbYGpf7qyBGChyDR8wNoTPe+y8ax0MqppdYVodPFc1dTs1DkiQRii/odghy4gWq4AEjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708094506; c=relaxed/simple;
	bh=iA+Cb7Zea/G+7JGe+QGzDVqwUEuAEX5CepI5whnRjB8=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=eeUSoqJpZixgACGlcEgcy1l1vvx1W3k+qIcMNk629Ji/S4T88l4nAb/UTe2zJWElsFNXyVVOV+BQCKsAGNwuWFl9WSesoxL8PRlX2C+D5opduMU6gfIlbUcphfaBEyOO0vaeD9ViCVjx3Srm99thT8Ov/xzz8SMVfLnmOSleuAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=GxJ7MuPk; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="GxJ7MuPk"
Message-ID: <bc2eaf5b9eafe2134820d1ea8c07e43f@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1708094496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wSCy6bUyb+5Lf26M8bgMUCBOQzAcOOuQlnyUvp7omTg=;
	b=GxJ7MuPktNCL+1SpjlAHZ0LEX1T//G6BHYpsKTXBSnD2L/w5fUyhrlscc9SP8HIra9dHij
	avzSDI5cRgRAGFoKIgKgARDIQSM8Fg9ZXWbP4GynU+qyqJ5MN/yU2mVGt9RxB9NdVPuiO/
	ca4xXfiBtvzGk2+NIxUfuKBVV5JQJvowWAcwrJzW4cLGtUT2mVHUuaLgGmh6gsg2MxC7B7
	61OXNH11usQ47NtfaTqoLOUi/kgvjilzaauKUkIhwS4M+IQjySCITS5c4LUogm3C5Roz23
	5wj/E/YFi2OB9AgId09q78ca4JnGCrcjGhLaWL7aJeUrquHP2TP4Qyr3c62SBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1708094496; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wSCy6bUyb+5Lf26M8bgMUCBOQzAcOOuQlnyUvp7omTg=;
	b=b+tL+NrlPlAs9AxYLXribplHiqkAFnUqBPFfM03yTlkQ7RzRSWABYr/VTcZ8QZl7fKCIIl
	wy8RFEv5G7u8CBJFvh+nRqV6XX8kD8Ou+yGN2eAK8hzOc/8Tl9SzPQ3RAMecRlvpZ92rxg
	ffOBb8WcTID7Wmv+35kBqTweyyzfd7d1J48m99S+H2MFMv6VxJnSo57xt6uWzNoRZ7VJ04
	kBKNzBYeLWozGcsOYc7LMmxasZHP4MQR4vl9bAoqiLsrD0TPNFbu6UqGtjK+jdK1QQSTjc
	yhhwukaLwyZKXeG1FjPlpK3Om65QR/4C4bIyBgimjN1rflGV/xTk39d5HaY0XQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1708094496; a=rsa-sha256;
	cv=none;
	b=MkfU8ZzD0nvb7BSpM/ixVQeTYfPO/LdyJqNO7Ocrb6nanCfmb3RbJhffrI3YMb5tefkv6l
	o64YIejAjtUrxfZJ0+RGcx9I+vpcv2reB7qAj6zrt+tEbRnoRhsB4iiA9MH79SJ7S6aKgg
	5pUPU4011R852ypY76nm26CHdqDiXt84MONl11gKCn/kvwWFYF7/5lYysdaLgvNYrZQOh2
	SZ+9aG4RWGGhgSq1dyfkByDugZFfdGbcybvfbGZ3veaZ7FahfTwxeXHlHfZvo7cMFEBLvr
	Phm3p0HzZV460i1ekneWBqsxtYOsAlcL7fKRuVXGuq38GpLsCG+c4FT2fk/oDg==
From: Paulo Alcantara <pc@manguebit.com>
To: Shyam Prasad N <nspmangalore@gmail.com>, Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Bharath S M
 <bharathsm@microsoft.com>, Meetakshi Setiya
 <meetakshisetiyaoss@gmail.com>, David Howells <dhowells@redhat.com>,
 samba-technical <samba-technical@lists.samba.org>
Subject: Re: [WIP PATCH] allow changing the password on remount in some cases
In-Reply-To: <CANT5p=oNRF9BAgybCX7dE+KvYj=k2G3tERa+fMJOY6tsuZ00Hw@mail.gmail.com>
References: <CAH2r5mtUnLDtwbW7or=Uc+AXkzLpHsJoPuoLE7yyjPVYjvZCow@mail.gmail.com>
 <CANT5p=oNRF9BAgybCX7dE+KvYj=k2G3tERa+fMJOY6tsuZ00Hw@mail.gmail.com>
Date: Fri, 16 Feb 2024 11:41:33 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Shyam Prasad N <nspmangalore@gmail.com> writes:

> need_recon would also be true in other cases, for example when the
> network is temporarily disconnected. This patch will allow changing of
> password even then.
> We could setup a special flag when the server returns a
> STATUS_LOGON_FAILURE for SessionSetup. We can make the check for that
> flag and then allow password change on remount.

Yes.  Allowing password change over remount simply because network is
disconnected is not a good idea.  The user could mistype the password
when performing a remount and then everything would stop working.

Not to mention that this patch is only handling a specfic case where a
mount would have a single SMB session, which isn't true for a DFS mount.

> Another option is to extend the multiuser keyring mechanism for single
> user use case as well, and use that for password update.
> Ideally, we should be able to setup multiple passwords in that keyring
> and iterate through them once to see if SessionSetup goes through.

Yes, sounds like the best approach so far.  It would allow users to
update their passwords in keyring and sysadmins could drop existing SMB
sessions from server side and then the client would reconnect by using
new password from keyring.  This wouldn't even require a remount.

Besides, marking this for -stable makes no sense.
