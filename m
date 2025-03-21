Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5271DE3CE
	for <linux-cifs@vger.kernel.org>; Fri, 21 Mar 2025 10:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742554332; cv=none; b=JurWdbWxW8QXyAsDqC4QW8GZef5MLskhCXj8rH6KGjvaLA0EjER+oSgWCqdQfDnK2P/8m+aGKwUOYU9bVMqqDdnaa2uvivngK1r9S+brY+q5N4I2zDtXruW3XqTyreTn1u+j15LSeK5SU6KfifMku/btdOue+wFWUcCJ+xA5dmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742554332; c=relaxed/simple;
	bh=N6zGvO285Ry6IhtrENtoLjB46GkvUMuVsQ6GZ6SUCDc=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=gFSKO63ivOD6AA8y0o0k2fZJrGzAVWL/0fafBA7rbVVc8rCbp8G3wF1ql8NJ8RFsLV/PjFKmGrYK/I0i5A19Sp7DkLeJv7mom5Xk1KQx8sOaZgx8CPdxyd1cBKTuWvl+btGWCMjF2vC9DPrbTYRN3tfd9gq56iLAk262Kw7Don8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S+z/O0Fz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+z/O0Fz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742554330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YdJsWvkJ3MvzPNK+Go2GX30hr/P60L3wxiP8eJjc2BY=;
	b=S+z/O0FzrNSxyE6T1dobsfxqtfMTuVXk738SDawndjti7QOrIHVBNfqFOFIjcRIrXvvloa
	6B9gFCWaWDATTZ9rKEzFZwKVf0wEUjiSlbedOtEuQEnnOlS0y69Ocb0oRpwdgfytmf5PAu
	3wSZ4xyfaahRQJRA/AKumzp/USDtJds=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-128-Vs1aic-fNT-7jEREYUKmPw-1; Fri,
 21 Mar 2025 06:52:08 -0400
X-MC-Unique: Vs1aic-fNT-7jEREYUKmPw-1
X-Mimecast-MFC-AGG-ID: Vs1aic-fNT-7jEREYUKmPw_1742554327
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8EEE91800361;
	Fri, 21 Mar 2025 10:52:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.61])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A00C1180175B;
	Fri, 21 Mar 2025 10:52:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5muHk=mUQo_SPk3DdzC7=0VCNiS3fDtotHxYUkT746RP=w@mail.gmail.com>
References: <CAH2r5muHk=mUQo_SPk3DdzC7=0VCNiS3fDtotHxYUkT746RP=w@mail.gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: xfstest results
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3211935.1742554325.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Mar 2025 10:52:05 +0000
Message-ID: <3211936.1742554325@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Steve French <smfrench@gmail.com> wrote:

> But with all six current netfs patches (including the two additional bel=
ow):
> 68109110fec1 netfs: Fix wait/wake to be consistent about the waitqueue u=
sed
> 4f8443992c8c netfs: Fix the request's work item to not require a ref
> =

> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders=
/5/builds/404

The server is currently inaccessible.

> I see a hang early on e.g. in cifs/100 then in cifs/103 (and all
> following cifs/105 generic/001 etc).  I don't see anything useful in
> /var/log/messages

Can you find out where it's hanging?

David

