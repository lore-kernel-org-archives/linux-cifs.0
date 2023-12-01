Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="OcPfCX/c"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B56F1A8
	for <linux-cifs@vger.kernel.org>; Fri,  1 Dec 2023 09:29:47 -0800 (PST)
Message-ID: <d5c487188936f998eeedc2e2e3e726ba@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701451785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hcq0Ab5qLHQ3MJCcJQDrEE4fwdqzyqkYFtkSHrEW6ZQ=;
	b=OcPfCX/cUj9twlK+XM0U60Lhc0HyDMApX9L9cFscmpFUF+6UPyqDbdLZtLpnfTnkkX6AT9
	g/DOrZFd7lTRJRDfh1K5d//6pgRn2b9Gx4WJHWuuQHlOkeJ1RqMcxkN0B99xW35SoWfcAk
	uUMgniqz1KqK3jjQ0kTnvcpklrKXJP0dBKpx8Uxo6l+Tazrlp5xYQJPYq6F2o7STDvR6wj
	OV3Uo4w4lPI1RhIF7dJHyImlbJ4PdcjqiCVPREQwfy7uXZUYbq1ApW/WK7tM20pZTV8BMo
	ulQt0LKjntKY6FbndzBDFJqZhdvhtxGs+u4pFKP1eWNV1TKUP+cSvUUzNaxVhg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1701451785; a=rsa-sha256;
	cv=none;
	b=czm7WmkpUEeqXQ0tkE9Tl49SH7aiqVJ5g/Sn3Nh88O1Tz8/QPbK8j0sBM7CZgWb84b7Mhs
	1GPnRPEVHbW8Tqy8Hc2/ffHMGckOR1G7G0PuFHVXOr4Elmg5rg9ExrOOHE/bdWHEDFw1v0
	3ujZv9boDpwvnPIwvZHnwr/VcGUDcwkaUiprIlZ8+bQSE67hKtY6tLrdvBjImnTNmsiF0X
	g0NIp2lx6KToom1KmBZ685X0c1t7l+62VDcdGPCWZB7igJu2H1K2ozKI4LAwWa4cELuvcJ
	Cax32k8BXx+REFcxtzpzrjgM3O1d5e7Vqhf+vf8EVcrfSsPX/8oPh1cFS8jq8Q==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701451785; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hcq0Ab5qLHQ3MJCcJQDrEE4fwdqzyqkYFtkSHrEW6ZQ=;
	b=Cg413qPpbVTXrDDY2UAyxv0ITr6RYU9V9HkALFsJ0rxsbbd0D26xA0/4HyzriagseoAtp9
	IJyuy6V9kf1ePTjsnjWsvg8oB4uD2J1H0NGf+fKhkoqoxdcBvDvEXrKypBYVEmq7tz1Hn7
	L8IziEaioET74XPkvgrRfMttuGU/onRETebiIrb6GXqX5TcN0jK5ftDKjswuFNjuQPzEg5
	yctoAXx0a7cDmVeg7FIFYB4ullXsgpsC26l4hMoufTVjLwD7vYSz6Yz4lZCe2f2SqHzfHX
	7YMR7A5B/6CZsNGcWTvS66/1d1yOtlDHIx7cbdU0bVzOYHsZucdC/24S1qNofg==
From: Paulo Alcantara <pc@manguebit.com>
To: David Howells <dhowells@redhat.com>, Steve French <sfrench@samba.org>
Cc: dhowells@redhat.com, ronniesahlberg@gmail.com, aaptel@samba.org,
 linux-cifs@vger.kernel.org
Subject: Re: cifs hardlink misbehaviour in generic/002?
In-Reply-To: <3755038.1701447306@warthog.procyon.org.uk>
References: <3755038.1701447306@warthog.procyon.org.uk>
Date: Fri, 01 Dec 2023 14:29:41 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

David Howells <dhowells@redhat.com> writes:

> I've seeing some weird behaviour in the upstream Linux cifs filesystem that's
> causing generic/002 to fail.  The test case makes a file and creates a number
> of hardlinks to it, then deletes those hardlinks in reverse order, checking
> the link count on the original file each time it removes one.

I could also reproduce it in ksmbd but not in Windows Server 2022 or
samba v4.19.
