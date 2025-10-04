Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1022934BA22;
	Sat,  4 Oct 2025 13:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759585232; cv=none; b=m+Xq+lEEPvBnwGyHhzO7b6j73aSY1/8dAgoD/c3ZeHk0WRseLYKrC6u3QzfU+1hujtiZUbzBQnJrzGcYdsSu7mV1pcshKiqIN9MsekKc/+BOiUfUbDRlxZ7Vamn5tRMDt77YDblaID56MvR/k8uow8caEykl3yuM9P/paHvdfD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759585232; c=relaxed/simple;
	bh=iD5RFOAG9YjZUfHuLxAn8puczFnavYpP38JD/s0TOG8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=PeA5SLu4USDEldv/PzyYBLowcsVae9DoSCFurvdgbK5CdSUzctJfrU2GBE+J2V4zdEElJm2FfiZTUdXpcvAaQxnRiHQqRcx2gCXKwvjXx2mX8dFKzkEIOfZg/2GMhzVi+zsd8A2rk2zFIrXQ0ZL/x/E8iHL84pOSglyRWof7j1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=QIqr4OHL; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="QIqr4OHL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759585226; x=1760190026; i=markus.elfring@web.de;
	bh=y+j9Xo2fmHJTu0kh87eYhwFQMiPYprGYvi4TgllLb7Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=QIqr4OHLCjrxBuH1Gw5hCCQ9rPW+Rfkr/SDKyQPEuGN0L815w9EddXUVUvJwrtol
	 feYoHG3LANU63761V/EaqH0rwkafhQl7JQ6bNtdC1gw0qh0t2Eh8NOLbbTooyZyh/
	 IZQbYUJglF7sxectHK4wnwXwgJXEDgrIwGuahsRdbErOTSHnPnTClqAxhNCjbTXsG
	 UWoFo0LWyqGuWl6oFFU0Za4SxvC1okXh06YgEZ/chkaq5xO0v0TZstVoVlZdBcGYP
	 Ur7o6BboRGwi4zmj+qw6HbkKVJfS2Kh8cm3ulYiXuP3AKrikH+ayHIRLZUhKEQb7I
	 0w3oSjAEt4ao34udcw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.173]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MJWsm-1upiXC3LGi-00LEzB; Sat, 04
 Oct 2025 15:40:26 +0200
Message-ID: <e184fcc7-2af5-4522-9ec8-3c2e226a61f0@web.de>
Date: Sat, 4 Oct 2025 15:40:25 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
To: linux-cifs@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Ronnie Sahlberg <lsahlber@redhat.com>, Stefan Metzmacher <metze@samba.org>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] ksmbd: Avoid duplicate source code in ksmbd_lookup_fd_slow()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UayYyZa611F252N3aAfMNnfXLqP31oVatGfv1KXff8Twkls945x
 V+9SXUVbqCJfwXgogJeCBlIIRg4sdKKhzjHR127VZ54pq1J6VahP4H+8KuFYmwOzBF6qiUK
 Ma8ULo/lRx/SlJhgjmELx7CQzhl1ZTy+3+9ZHunrj0VETpEpkS8ccv8wrr0zpnqmZ1zdZGO
 HjvUZP4L/zov708/x+bUw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:VZLlRbyQONM=;OhARiYY6unLjAUObMRTZP0moUCQ
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 4 Oct 2025 15:30:16 +0200

Combine two condition checks into one in this function implementation
so that two statements are stored only once in the corresponding branch.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/server/vfs_cache.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index dfed6fce8904..16b326c4ffcf 100644
=2D-- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -470,11 +470,7 @@ struct ksmbd_file *ksmbd_lookup_fd_slow(struct ksmbd_=
work *work, u64 id,
 	}
=20
 	fp =3D __ksmbd_lookup_fd(&work->sess->file_table, id);
-	if (!__sanity_check(work->tcon, fp)) {
-		ksmbd_fd_put(work, fp);
-		return NULL;
-	}
-	if (fp->persistent_id !=3D pid) {
+	if (!__sanity_check(work->tcon, fp) || fp->persistent_id !=3D pid) {
 		ksmbd_fd_put(work, fp);
 		return NULL;
 	}
=2D-=20
2.51.0

