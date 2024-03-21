Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B568B12BF3E
	for <linux-cifs@vger.kernel.org>; Thu, 21 Mar 2024 17:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711043331; cv=none; b=aPPiHA29AY3gzjzIbBFwKIEeI6kgP8OtfAH0EpvYwGJ7JNa6eMw2ynkw/lfI9yp5wyERXdMHqoF/ZCsdz2d3JsLAVSQ2MAkJv4J7aOm1ohFet7K1oXxMHiyRVpsdkgdaRuIAuE9OoQexNyLOfL2ZuWUAnmDJdDTm1amNUgZNfpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711043331; c=relaxed/simple;
	bh=xjoQ1Y4FwsRU0J/6mtCCmbaFFQQmQTU70I4D7iHgpFE=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=fqy+HCw/GwOIyvZPqRh+osUfZetbvmWEqZsUDrtjKfvMNsYo1PPD9rz4VF3oHW0zC0LLuBQVikUCCcJteGceojwbCO2IaFoo4XNeuTUE8cW7bBWq6whWaIPatLgAvo+iQL06ksyu+oHgoKpxmh5qlHyRpTugwbF5NptfmNjxXks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=inDSvEK4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="inDSvEK4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711043328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=93nq3ioGXBO9aGa34ehrEaFOrnNf0efnwUN/i2IdS94=;
	b=inDSvEK4kNwztguzmClAz7VSv0P/OXRh3G9GS2amQSCdtDoXhyywsgNXowtIph8tF1uXog
	yZVG4w3RgxInLOlviFziw+Zecv/KfLzLvcME+51wmpHQ+wuTxdG5YB/BkaYubwd9s2O5Ly
	n9EVehHL15Z1S+Ew09i4+h8pzVswsys=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-HIRkdtXAO32AuHMqC1eQww-1; Thu, 21 Mar 2024 13:48:46 -0400
X-MC-Unique: HIRkdtXAO32AuHMqC1eQww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C659800268;
	Thu, 21 Mar 2024 17:48:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.146])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10F292022C1D;
	Thu, 21 Mar 2024 17:48:44 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>,
    Shyam Prasad N <sprasad@microsoft.com>
cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.com>,
    Ronnie Sahlberg <ronniesahlberg@gmail.com>,
    Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>,
    jlayton@kernel.org, linux-cifs@vger.kernel.org
Subject: How to manage credits handling in cifs read and write paths?
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1419722.1711043320.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 21 Mar 2024 17:48:40 +0000
Message-ID: <1419723.1711043320@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Hi Steve, Shyam,

I'd like to make the attached change to add_credits_and_wake_if().  It's
called in various places along the error handling paths, but it's not obvi=
ous
that it's consistent and that we don't get double accounting.

The obvious change would be to clear credits->value if we return the credi=
ts
back to the pool.  Assuming that's how this works.  That makes it easier t=
o
(a) clean up the netfs_io_subrequest struct or (b) renegotiate and retry w=
ith
it because I can just call it multiple times.

Also, add_credits_and_wake_if() wakes up server->request_q... but so do
cifs_add_credits() and smb2_add_credits(), so is this superfluous?

Additionally, what's the scope of a 'xid'?  I think I should add one to ea=
ch
subrequest I generate and deallocate it when the subrequest is freed.  If
that's the case, can I add an explicit "rc" argument to free_xid()?

And finally, I have my cifs conversion to netfslib down to the same xfstes=
t
failures as upstream[*].  Those patches can be found here, with an additio=
nal
one on top to address the credits and part of the xid thing:

https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/=
?h=3Dcifs-netfs

David

[*] With Samba; I still need to sort out ksmbd.
---
@@ -878,11 +878,12 @@ add_credits(struct TCP_Server_Info *server, const st=
ruct cifs_credits *credits,
 =

 static inline void
 add_credits_and_wake_if(struct TCP_Server_Info *server,
-			const struct cifs_credits *credits, const int optype)
+			struct cifs_credits *credits, const int optype)
 {
 	if (credits->value) {
 		server->ops->add_credits(server, credits, optype);
 		wake_up(&server->request_q);
+		credits->value =3D 0;
 	}
 }
 =

