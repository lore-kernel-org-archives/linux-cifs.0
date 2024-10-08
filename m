Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E652139C7
	for <linux-cifs@vger.kernel.org>; Tue,  8 Oct 2024 18:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728412947; cv=fail; b=uhk4u0PqDNPlSSmUKl/vK9Yo6ttLb5/CD4GGH2pmcBRgDWDXJbG5HrwXS5Wfu2K98QuvVd9dzhVEGjemfM5gGAx261iviOGlzhRjEGgsjo4nwJYzCa9J8WZiDtN9AKuTGCHPZXfPrd6G3p1gTtRrwNTPX3zL6F5442C87i1c8VE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728412947; c=relaxed/simple;
	bh=LEq8NgV+TFys+O7QRF8ODc7Sp6iAZ1hNX+CizHXeLmA=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=UVAXmNhNRfIOn+vs0qy44p0jfQibWOud0giVV1YWZIMSpuLro+GGD8FOd2tURWxIJ1afVaY7mn9rGWuDzMYq/zbFLXvKrqVNiP4jIStSUBqvjJx+qQBwzoFCsboAcZ2wt8ACmp5YWHwcPq6hb4a7Py04E7X/o8JWHvOX2Bv8aSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=CILfBhRK; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="CILfBhRK"
Message-ID: <4bfa6f89b43289e2a66642f182f733c6@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1728412512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OqJ9eF9b4muJI29MbCqa9aPXGBMMXx91crhnpMngDqY=;
	b=CILfBhRKRnJHeRb4FliaZE1c38sZubFGd+GLw0okXA9KXWYY4BGAbWHw9wYJYmTBXpBE0y
	nHyN9OiIyjabbj5sbiAviBX1W1UpTTftf4T8RaIa3ZS1uzd/A+Ju+6xo+WBoAcmyAtsMZI
	sfeJqNd7x1LtJYrqpo5bEiRIFRD74eNSvRJzhrxKDeIpKue4SVgjQV51DVGOayYL1RyZy6
	g8cMwXkq+muUGOFaXT4pWwAp+/QKhnqix5MTI7dSX+iTxjjEU+NZBMIlx/fV2CNVUsc8H0
	QeN1mxooKwg/SLzMg+goc2eVUVJ432X754DPSoz0+In9zCi3e3IYiS5NB22u1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1728412512; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OqJ9eF9b4muJI29MbCqa9aPXGBMMXx91crhnpMngDqY=;
	b=O8lO2dEKUx6mS7XvFi7vVzBZrr3SkNS1as3ZNYDD5/7f+RlUeMa7UE9v5sf5kca6TOLH0e
	hEghtxRamE0aLG1NZuiiPxgEjR8Plo5nP2VH/XTOjd03x3WBvWnHxvJIU/PtKkuAQ4T2Vw
	NH9fxZl2JuShVIyK1649NKKyhajWx229fbZghciQo0nxGt6aC0MC2vxiuYqs9E3K9k+CRO
	RWv79QGqgOzBu9f6PggQtwswBQ4rGnby6jQAVuwpFcb560XBP27Y6tBlbUhyQNKqMj9NKy
	7QUsGa4JjBwUttGv48UT2seYpunMgv/KGE3zgNQWkEQoDQaWL9xOrX+MfMJNEQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1728412512; a=rsa-sha256;
	cv=none;
	b=OExizQVYs8CP0tnFS791GyjqB75qyUUtvlwsq8OcNwZKhVk1J74JQTGy1WmsqRu37tBciK
	8BewNEl3Qchpuv+LScKAD3CEv0d+h5awh9F4AjWvTsw9HsKGMjJp0OBRDHBPnrPuI0h6v/
	Hc1D8LEFrakuleDnQ0yY1+OR04nvw/5WIdHr5BCTkr9X7XIKYTOWKdigWa6oSG9SG82nH5
	f/elnR8b3GqS4jRrJOZ6i7VR/QVgXy1EQoQPvezHADlnyZ5cHVZVEHwWCQbA6Q2c1vjBW7
	jftpE23GKzY38rpR9UE9ITvyqM61KnWawrn4DHg9yQo7jI/iwnPjRm4cazbD9A==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][SMB3 client] minor updates to "stop flooding dmesg" patch
In-Reply-To: <CAH2r5ms2jpBVtpYaE2hOgnfnjx73MnmPW2pQZnY-42ARYMf9ZQ@mail.gmail.com>
References: <CAH2r5ms2jpBVtpYaE2hOgnfnjx73MnmPW2pQZnY-42ARYMf9ZQ@mail.gmail.com>
Date: Tue, 08 Oct 2024 15:35:08 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> I was not as comfortable with taking out where the error is logged on
> session setup, but the other parts of the two patches below were fine.
> So have added them back into for-next after the one small change to "
> smb: client: stop flooding dmesg on failed session setups"

NAK.  These changes just invalidated the patch entirely.  Either remove
it or make the "Send error in SessSetup" error messages being printed
out only once.

The client can still flood dmesg with "\\<hostname> Send error in
SessSetup = ..." messages over failed session setups with this patch.

Just try it yourself:

  kinit ...
  for i in `seq 300`; do mount.cifs //srv/share /mnt -o sec=krb5,echo_interval=5,nosharesock,nohandlecache; done
  # disconnect srv
  sleep 30
  kdestroy -A
  # reconnect srv
  journalctl -k -f
  ...
  CIFS: VFS: \\srv has not responded in 15 seconds. Reconnecting...
  CIFS: VFS: \\srv has not responded in 15 seconds. Reconnecting...
  CIFS: VFS: \\srv has not responded in 15 seconds. Reconnecting...
  CIFS: VFS: \\srv has not responded in 15 seconds. Reconnecting...
  CIFS: VFS: \\srv has not responded in 15 seconds. Reconnecting...
  CIFS: VFS: \\srv has not responded in 15 seconds. Reconnecting...
  CIFS: VFS: \\srv has not responded in 15 seconds. Reconnecting...
  CIFS: VFS: \\srv has not responded in 15 seconds. Reconnecting...
  CIFS: VFS: \\srv has not responded in 15 seconds. Reconnecting...
  CIFS: VFS: \\srv has not responded in 15 seconds. Reconnecting...
  cifs_setup_session: 23 callbacks suppressed
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  cifs_setup_session: 1618 callbacks suppressed
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  cifs_setup_session: 1786 callbacks suppressed
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  cifs_setup_session: 1728 callbacks suppressed
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  CIFS: VFS: \\srv Send error in SessSetup = -126
  ...
