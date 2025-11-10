Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46CA26AA94
	for <linux-cifs@vger.kernel.org>; Mon, 10 Nov 2025 15:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762790220; cv=none; b=A7mnfDgu9GA7gOPT4bewEwA3FZdMDj0xyRGyZI1g0qspW54erc3FAChyvS3ih7k40bkeBTz8Z5Fs4rTNPVYjdmDCsUczNyrhoXDfHdM+3FHZnQMiQZ79OuU1k9//5+SfLVm5USfLdwZpgbOMgmRuL7gy0/N6Ii23jJ6j4xBmm74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762790220; c=relaxed/simple;
	bh=XKjwnAa4UixI8ioxUvtgsChT+T15AKiNRcG6XcxlW4M=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=kGUKBobNaPG5urNU0OyOqwsUHSIpkkYkX47GCJuFlEtjDkdF0L68WBhQQyJNYQ0skm5owdX+tS9NwOWgkcn4bwnlg9L5WD6FKCQXjdNhmt0VsLwihkBgYMXeW8c42JTZ50ZZISyTF4CGwsOJfhHSGr/yBCNHYlm2pvPx8RDXOGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eGr/bT0/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eGr/bT0/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762790217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XKjwnAa4UixI8ioxUvtgsChT+T15AKiNRcG6XcxlW4M=;
	b=eGr/bT0/KOj2UuRyq5AsAo2hrZobfni2ESwLhy1zFuz+ZzXTeplVbz6nbZXpPjprbaoni3
	LJ3ve3JK3zmQkPaY46FPc0kifyZpWVZdlZ7lycvylA6PCLCKC3UJaojRsS1v06wiPgJ/AJ
	vFliC+katF28KTyKF4SWAcenLl74AZ4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-zLZ5_OfHO7CpWcG5H8KAyA-1; Mon,
 10 Nov 2025 10:56:54 -0500
X-MC-Unique: zLZ5_OfHO7CpWcG5H8KAyA-1
X-Mimecast-MFC-AGG-ID: zLZ5_OfHO7CpWcG5H8KAyA_1762790213
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 718731955E7F;
	Mon, 10 Nov 2025 15:56:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.87])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C3EF6195608E;
	Mon, 10 Nov 2025 15:56:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4yor4cklgnkgiv4na2hl6w2zasp4w4i6zubgtnhedzqc6qreat@l3nyd3zc52k7>
References: <4yor4cklgnkgiv4na2hl6w2zasp4w4i6zubgtnhedzqc6qreat@l3nyd3zc52k7> <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de> <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com> <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu> <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop> <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: dhowells@redhat.com, Bharath SM <bharathsm.hsk@gmail.com>,
    Mark A Whiting <whitingm@opentext.com>, henrique.carvalho@suse.com,
    Steve French <smfrench@gmail.com>,
    Shyam Prasad <nspmangalore@gmail.com>,
    Paulo Alcantara <pc@manguebit.org>,
    "Heckmann,
                         Ilja" <heckmann@izw-berlin.de>,
    "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
    yangerkun@huawei.com, yangerkun@huaweicloud.com
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing, x86_64, kernel 6.6.71
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <930958.1762790207.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 10 Nov 2025 15:56:47 +0000
Message-ID: <930959.1762790207@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Enzo Matsumiya <ematsumiya@suse.de> wrote:

> The original patch by Yang Erkun (Cc'd) has been resent and Cc stable
> (6.6 to 6.9):
> https://lore.kernel.org/linux-cifs/20250912014150.3057545-1-yangerkun@hu=
awei.com/

On the Yang Erkun patch:

Reviewed-by: David Howells <dhowells@redhat.com>

