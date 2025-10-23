Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E332C11FD
	for <linux-cifs@vger.kernel.org>; Thu, 23 Oct 2025 07:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761204097; cv=none; b=T5aAMAxmcgPT0RKV/C62RBHwE4X+95VgzCctOFCAJaaikV1B9L3dhda3Q9bJbwKJ3eV6MAKs+Skc8CK7DI/pba8xpHxAzBcsT8Cihj28XMmlLdyK4b7jdgXOpAZgKZ5f68d/nveby0z6RFbgG7Aiu4fngYilj8yDPORAUsRMoZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761204097; c=relaxed/simple;
	bh=/g94T3C3FpvXuoLJ50EST30PL4M1AgzqRzsFNFlQ8HI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=UL3F5V3Jv2DXtVFmNpF9V1e34Lc1khSVdN0YFiRIxnQznlXbvae2XRXXYqia4y75ZkF0w3whGleSTk9IVd2vXzK6gKY6oDR/hh1DdD9OdMXkac7lnF7wkLp46NlxV6PBYBicv0CQwRHZz38ARao1YYCvsuv6laCe+HNAtAX0cqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YgDyha/p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YgDyha/p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761204094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lDzebCCMPQTZ7xDuMBPuzYzGqdMATmQDJmQkqVWUYuc=;
	b=YgDyha/pXDLeYg9Y2wVUTxqb+dddMNfiHLQhlp45xxY6KaDaAn8JPmuJ0gnoK9xGHIBqmh
	uY44rZyexcZuqHa8bA3aMwH9poSoq2cUq1xFc3CYLH5/CtdOWARf/Ka/druTKc+igVIavf
	0w/Lw0fYIdSw5HPtZ4gsd+ni/zsDaxg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-445-eq852SuiPCur_SwGV9o8kg-1; Thu,
 23 Oct 2025 03:21:27 -0400
X-MC-Unique: eq852SuiPCur_SwGV9o8kg-1
X-Mimecast-MFC-AGG-ID: eq852SuiPCur_SwGV9o8kg_1761204086
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C0A318001E2;
	Thu, 23 Oct 2025 07:21:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.57])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9671030002D7;
	Thu, 23 Oct 2025 07:21:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251022234321.279422-1-pc@manguebit.org>
References: <20251022234321.279422-1-pc@manguebit.org>
To: Paulo Alcantara <pc@manguebit.org>
Cc: dhowells@redhat.com, smfrench@gmail.com,
    Anoop C S <anoopcs@samba.org>, Xiaoli Feng <xifeng@redhat.com>,
    linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix cifs_close_deferred_file_under_dentry()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1837801.1761204083.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Oct 2025 08:21:23 +0100
Message-ID: <1837802.1761204083@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Paulo Alcantara <pc@manguebit.org> wrote:

> The dentry passed in cifs_close_deferred_file_under_dentry() could
> have been unhashed from its parents hash list and then looked up
> again, so matching @cfile->dentry with @dentry would no longer work.
> This would then fail to close the deferred file prior to renaming or
> unlinking it.
> =

> Fix this by matching filenames instead of dentry pointers.
> =

> This problem can be reproduced with LTP rename14 testcase:
> =

>   rename14 0 TINFO : Using /mnt/1/ltp-a5w7It6Osi/LTP_renffzJE1 as
>   tmpdir (unknown filesystem)
>   rename14    1  TPASS  :  Test Passed
>   rename14 0 TWARN : tst_tmpdir.c:347: tst_rmdir:
>   rmobj(/mnt/1/ltp-a5w7It6Osi/LTP_renffzJE1) failed:
>   unlink(/mnt/1/ltp-a5w7It6Osi/LTP_renffzJE1/.__smb0021) failed;
>   errno=3D2: ENOENT
>   <<<execution_status>>>
>   initiation_status=3D"ok"
>   duration=3D5 termination_type=3Dexited termination_id=3D4 corefile=3Dn=
o
>   cutime=3D0 cstime=3D587
>   <<<test_end>>>
>   INFO: ltp-pan reported some tests FAIL
>   LTP Version: 20250930-14-g9bb94efa3
>          ###############################################################
>               Done executing testcases.
>               LTP Version:  20250930-14-g9bb94efa3
>          ###############################################################
>   -------------------------------------------
>   INFO: runltp script is deprecated, try kirk
>   https://github.com/linux-test-project/kirk
>   -------------------------------------------
>   rm: cannot remove '/mnt/1/ltp-a5w7It6Osi/LTP_renffzJE1': Directory not=
 empty
> =

> Reported-by: Anoop C S <anoopcs@samba.org>
> Fixes: 93ed9a295130 ("smb: client: fix filename matching of deferred fil=
es")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Xiaoli Feng <xifeng@redhat.com>
> Cc: linux-cifs@vger.kernel.org

Reviewed-by: David Howells <dhowells@redhat.com>

