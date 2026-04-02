Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5993EFD37;
	Thu,  2 Apr 2026 15:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775142347; cv=none; b=CroOv1/thqNm8HKnCj5eN7aTP4oMC8Ht94KVmutZQJ7eLRFzfoLN2YvXD6nQlDoRNKApS6/Rz4OiDYCE618Dr7oZ9BKs2J6FU3bB1TLHyPPHBdjXsb0gCAczIM/v7vNvQXUm1NRhqlSyrnlKJ0/r2v0xWJsRtuOjwf6LgxHlofY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775142347; c=relaxed/simple;
	bh=jNqtKS6LcbTwwNmGzwhsdyuw+/o/3zaU5vtgkQwENeU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=jo8EkH8p18AgHkMaP9wxz5qUtiQNYw9AnYQ7Mh4621KqRpvLP93ParW6tYBix1NLGOe0qegYk3e6djxj439/NZztNi86RdTm7QOlFDVIDzvURfNHqMTX+C0YAfiwMSAHq+Zmyde+77Nqefqtx2dta26JBhfG/ZZjZTChUGkYRho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=yvjZBj6H; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="yvjZBj6H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vSG9Mto5XHK7GAvGcjGb5ZYd5Vowf7DfxIcB5/5pwA0=; b=yvjZBj6HJD0PGBwmm1J3EOdxyb
	boV+jB+SoGuIW62aJ8oyJQJCZ2z0OHjFYnmWFHYN7CKYux8r8bgc304U5ksbzLj6MPWpLKWIoNCO+
	OyCLTL7e7Vmg8oL/3AJ24KcO41jIxpwwwofqylxoEf0+zHUcRotYrevVJKsh9qQoORtYS9KWS3fo/
	oa771XW89RP421j34fhFeYlTb2GVLUOx1Tu4GVj4NEZUNz0w7emYV2dp+H5W15ok43TZnASy1RKIV
	OJC0bl3DQCJ/iN3S+lrjWWCnxRXo1qpSauDb26gNpu4ZaZ21/HKiejHjSQkfB7qSkyk89tsklknAc
	oq0N8ZBg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w8Jby-000000026P3-3mHT;
	Thu, 02 Apr 2026 12:05:34 -0300
Message-ID: <6ef4707e79791f18a668b057aea62c5b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Tom Talpey <tom@talpey.com>, Steve French
 <sfrench@samba.org>, Bharath SM <bharathsm@microsoft.com>, Shyam Prasad N
 <sprasad@microsoft.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 samba-technical@lists.samba.org
Subject: Re: [BUG] Linux Kernel CIFS Client SMB2_open_free KFENCE Double-Free
In-Reply-To: <69ce4dd2.170a0220.23bcc5.dd88@mx.google.com>
References: <69ce4dd2.170a0220.23bcc5.dd88@mx.google.com>
Date: Thu, 02 Apr 2026 12:05:34 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

This should be fixed by

        048efe129a29 ("smb: client: fix oops due to uninitialised var in smb2_unlink()")
