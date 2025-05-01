Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313CD6EB79
	for <linux-cifs@vger.kernel.org>; Thu,  1 May 2025 07:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746084782; cv=none; b=n5JLTLbcJ0mYiOZd5Qv77TfshIMPkpwqtGuikkxZLCR0InVvUTDbj2h8hLQFVbDNMOtVwI4WV37m6jg8tJKkKfAo/Id3nakJZ3Aw1tv8vcN/TVJR9H4Q36zWo/DMMNFcnDS6TW184bCT/WuK9pYb5kFLIZ9xViCwXU3MmWkrWnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746084782; c=relaxed/simple;
	bh=KoJodLRENdD2C0Odu3VfgsYOLSLEUCs9D5dv7VvkHbc=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=U7G8tOa0DSpyMPGjUuOSURoeuA4s0GGeJgzRitqv52lPi/52ofzdY/zhlJBb8XRnfxbP1e/e4mHnGEhQCp16DstObcPTwv8FJlRvbGplZlHHQVeZZDbRpivAtZGm43p0ghdO6AKbti1SbKfK2BFRb3RC+Zx+ww3u35PJQENQgeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ch4NhQ5W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ch4NhQ5W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746084778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E0XiMPRko4gkJFc/R90S9ZMmrVo0hkqeOaum7nEtgjg=;
	b=ch4NhQ5WKpUV5lZjV6n44FwV0e//eYzx7cGhIljQfsh+g0WdlrKhw7cGQL4rFlILyo6YQe
	s8sl9eE+OUqhzig8l2p/SkINYZdxjV7IPCr6hJn7qKj2XOKIaN+40oaTiwotXQoAvJQ4pP
	CSItSIQ0Tx5uts0xLJ4Y588caTOJAHY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-422-BIqSsau9OJSq5YbS0Uz4rA-1; Thu,
 01 May 2025 03:32:57 -0400
X-MC-Unique: BIqSsau9OJSq5YbS0Uz4rA-1
X-Mimecast-MFC-AGG-ID: BIqSsau9OJSq5YbS0Uz4rA_1746084776
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42C6A19560AA;
	Thu,  1 May 2025 07:32:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.188])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 194FA1955F21;
	Thu,  1 May 2025 07:32:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250430231548.1836976-1-pc@manguebit.com>
References: <20250430231548.1836976-1-pc@manguebit.com>
To: Paulo Alcantara <pc@manguebit.com>
Cc: dhowells@redhat.com, smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: ensure aligned IO sizes
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <746407.1746084773.1@warthog.procyon.org.uk>
Date: Thu, 01 May 2025 08:32:53 +0100
Message-ID: <746408.1746084773@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Paulo Alcantara <pc@manguebit.com> wrote:

> Make all IO sizes multiple of PAGE_SIZE, either negotiated by the
> server or passed through rsize, wsize and bsize mount options, to
> prevent from breaking DIO reads and writes against servers that
> enforce alignment as specified in MS-FSA 2.1.5.3 and 2.1.5.4.
> 
> Cc: linux-cifs@vger.kernel.org
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>

Reviewed-by: David Howells <dhowells@redhat.com>

