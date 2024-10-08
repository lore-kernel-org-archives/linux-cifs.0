Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B55212EFB
	for <linux-cifs@vger.kernel.org>; Tue,  8 Oct 2024 20:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728418530; cv=fail; b=ZRnnH3i4ARcP7mBeBwifUSeJv4Ef4CK441hJimooxVRx9LlFlzETFhl5KQkGtV9GWiQCSJ85VBBg8FGc/o75Wp8NW7DzxRMe+8+t+upjUdT+ihmdzMZSskKN0v8nhJVTK67/O4lvHlUdjD4AbX1SE97riMYxiJXDsLmh9TLfPfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728418530; c=relaxed/simple;
	bh=Y+/PyqsUd+VHLrINi65zBgv6crUicZWsff+Spz9HyMA=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=a75OCBiNwn41bwveZIt3Y0ZJfSFA6mR65i7CAy7ZbUSXREiJBJHAnLBhMS00hzIprken9rF8cSTW/xCDRSoDTjC3kb5xINd38IfZHHj3pf9GTjkxxg9/1Rs4ZGR9EoLo/02xraBNMY4V+NECaiGs2vbYuKaHcmIJpuSCMLuh57o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=JbBQg8gm; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="JbBQg8gm"
Message-ID: <4fc5c70cf311ed65d7c617cb154ef90c@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1728418527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OV3mTIA7M2PviwoNbULWvsuFG+CEwMfUtFy8zVtTCXo=;
	b=JbBQg8gm+2EE+3cOfgZZa1QTqaTIpQ0oZnzlZ59nMVPV3rzje4+kBmbHvENi6z1XbHH6zc
	3fzD5GcSD//p8UaI78fiQhHhcUYTZ05XYKjlxvE7feqBt2oQAPVMXch5rCSWnFyR5qmTpQ
	xlgRNJZT5jkRQX4oJ1RvTo8J6XlmCeGdJbr4ZDw46EOfBMOZk3QT3FThpJBNYx75vuFY/Q
	xHC3g5gNX3rnnxg3Vji0j7cJ7jJFgHVNShsWn+s8w0CCEUCrdwUk6a/gQV/hFBZ5VdE2Q7
	UmdSAqzeUXOFZqMnAGc1RX8MWqClZJupyt570B7dmepeLt3L4hOtpO5v9jTaZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1728418527; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OV3mTIA7M2PviwoNbULWvsuFG+CEwMfUtFy8zVtTCXo=;
	b=Ku9VOXsf/5OP/q2i6rgTznMbzVe1S9GzdI8TfTzz505PMrxDRCKU2DS/nOZO06gzRzGmC6
	WSR4gnTG3TnJVnErErpS0rpTtiSXDF+SuyFty2GLqCeutNgSFkyJ9hMLu/Ky+xkFbMXqsn
	aLxqcDVkcVSkMuxr69BZylKbZqQiTi+w8vm105Z+k3YbsmqYIKqSxNTPen+7Z/rzEN7xug
	U6zAJOKFzpP1UXbIBu36GI0zDWTH6pzRr9OpE1BCFsQ+sT0cFe+c+sswzM3y0l3K4yWFa8
	dn6RFY909ZHqrtCSjABUNRK0FAW2EKlKjc/cbXeoKRLHgVBTeou6g+3Cc/4lpg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1728418527; a=rsa-sha256;
	cv=none;
	b=H6cFS71d44IwhYuhCMTHi2iaNT7PYTCDuzJQ7DT3dfLAMXdvstAfko4SFm4YpJLqrfiEik
	vb470wf8h+DJrAUD5rvuUzmdjfVjfQcnIyJM0njO+49jZTwrg3R9/SNFIdM0Su1S9jbebg
	iv2NjOEp62dorIobvJfcA29w8a4u1tFiqt8Rvca0pxn/Mpx9pZ/CS1LnHtWlF2DU4u62eq
	iJnSS5Ho70DqBYhf7H1970fLiIykjVpAa0vID/3/YO/l3Tnxs8EEctYtVxPi3OOxQjpUSz
	/q04iXMdeU11fK+008dy12wYZGp0mv0vGryNj+mFU4Cc27mbWJccRcnQ99ru3g==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][SMB3 client] minor updates to "stop flooding dmesg" patch
In-Reply-To: <CAH2r5ms8JwSnRbyFmijk4Vhmd9-Khs+V3Co8sx6u=AEu0yb1Xg@mail.gmail.com>
References: <CAH2r5ms2jpBVtpYaE2hOgnfnjx73MnmPW2pQZnY-42ARYMf9ZQ@mail.gmail.com>
 <4bfa6f89b43289e2a66642f182f733c6@manguebit.com>
 <CAH2r5ms8JwSnRbyFmijk4Vhmd9-Khs+V3Co8sx6u=AEu0yb1Xg@mail.gmail.com>
Date: Tue, 08 Oct 2024 17:15:24 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> We still will need to have a way to log these messages at least every few
> minutes if error in session setup. That is Clifton critical information for
> user to know

Agreed.  I just think that "\\<srv> Send error in SessSetup = ..."
doesn't really mean anything to the user.  Further I/Os from the user
will fail with -ENOKEY, which also doesn't tell much.

Without this message we at least have

        VFS: \\srv has not responded in N seconds. Reconnecting...

which tells the user that connection was lost.  And, in case server
dropped the session (e.g. STATUS_USER_SESSION_DELETED), we'll also have
the above message printed out as we currently mark tcp ses for
reconnect.

We still need to handle these excessive upcalls as in my example we have
several kworkers attempting to reconnect a SMB session (on every 2s) and
then repeatedly failing due to expired key.  This could be done in a
different patch, though.
