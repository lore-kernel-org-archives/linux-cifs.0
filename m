Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBEB195F25
	for <linux-cifs@vger.kernel.org>; Thu,  6 Jun 2024 16:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717692810; cv=pass; b=uwKjsEOVLK8lUEbkeuSOZlTsnJxi1c8jm+q4x6yUeShWR4ucp5AbR4Ayn/Ph8IbrUfuhMwRAm2kJMebgqzKE6isP3xQqleDdRz1BSzZt8qVcQWG9dQO7HNQol1bbqTlUdZe0/EkXaU9n8DdVRUUal99/nWoO2TgbPq1hfvsYeeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717692810; c=relaxed/simple;
	bh=gRjgEHjnnYyrKCZFzoBcO2hndTZgMv5/h8b74GMb/Qk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=lxsQdE8j8bNAnfwJFd5ihiIk9O062ykNK99E0lQjdKwmOBBRSDAj90Mjpf81jkZqH0W/fGa5zDpEUjjyHymvq+hd4WBZ4GS6jCgS7w8bWIe+UtUeISI+6wYRHhZR3JDctX5AVqOXwTNi073rr34ZTe9ifpNXCgaHfQufX8d47dE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=f/glNzk/; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="f/glNzk/"
Message-ID: <d4d9d47b3af340879126b907cfe73441@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1717692800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SxntQoAqrjpFWmiW3MHEyuESs+8PrANr8exR4Rz+LGo=;
	b=f/glNzk/bzPRREyyWi2YXmxhF+3dpEKBTCnssdlt3DveSvdCu13uj5ObJBOkRsqrj8wKoN
	beTizq+t00b6kyDqHpVUTwi2zMBmRGClAPH80d4PRhWEEU6IUGdTCu0YosWU68YYf8Zmkm
	DqBVNTbNB/wkW0agsgYhdSwr128B/5sKb1pL6vWEjbrSFh3dKQ6n8aYOdTUmF88TQttp7r
	np6f4mDAC8+re7GHdcQfmPGxnRnG3gIfayS5yAB+jrPz8aQSMh/8xkSLAYZtcbsnBAvUIj
	qwZxG4DZvxdxczzhRpMJNPK9jtpCvmk6QvjM5Yyst1bPCFRHcmrKljp4FePE1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1717692800; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SxntQoAqrjpFWmiW3MHEyuESs+8PrANr8exR4Rz+LGo=;
	b=aabGpqfsmC9B0A8YOmdi/7gf31CvhzbTg4A30Z9Y0CpoLtI35x2AXTPQD44uNeBPMQBlUL
	O+22U4TFaHnBKkADiqQXr3qBg8NR3BVi+LEsg1enEuOiNsdoCB+rtTzkwMG5GndM07AUNX
	m+AIBxaCriDrtpXblupBNINiS/k4m0vfAOHWqBqO74r6yhN24R0EduXlhsY1MsvkGvuTcC
	YfH4noLXvto2tvypJeVAzRxgkt7YOYaIdVQS4aV5muRsVJV+37AOGlqhPmHUXEVpMGnFWg
	zmcayrEvQb/6xNt8Jg7ShpCW76m8r1JaIPdNIe3pgv5nu2Wiqr5KlW8PwaK6/g==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1717692800; a=rsa-sha256;
	cv=none;
	b=BO3FFB/Sk1kYi6oeEOw0jhbNAhN/+gFQCP0pglr4C4St7pSSIf3mTV+wgo/KGroFQx9cw1
	/SaGf5YjxsXGGWH2KKoTI0HYUFkpWfxtkytZ66/ejd+keNgdey/MsjHe26iSqrPMJz7YWq
	qaYOgMMPizOVA3yg5/+rWfTDPtKLOidftTs9K3WLk2tZqkE/oRJFH0txTQWFmaqFDLZspM
	1OWfpTqHxaIIpn9Azu9FVkwdggtHu5T9imnmnSxWnumKRZHv7fAYIkzzFIi5J1NDGk+8vd
	PAPNAeMJSrDe8jQDyzwR9zUhykjI+/2hICevGFqKrn9x1hWWRQAUSQ2NdIV8Ew==
From: Paulo Alcantara <pc@manguebit.com>
To: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com
Subject: Re: [PATCH] smb: client: fix deadlock in smb2_find_smb_tcon()
In-Reply-To: <20240606161313.25521-1-ematsumiya@suse.de>
References: <20240606161313.25521-1-ematsumiya@suse.de>
Date: Thu, 06 Jun 2024 13:53:16 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Enzo Matsumiya <ematsumiya@suse.de> writes:

> Unlock cifs_tcp_ses_lock before calling cifs_put_smb_ses() to avoid such
> deadlock.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/smb/client/smb2transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
