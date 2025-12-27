Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCB6313E20
	for <linux-cifs@vger.kernel.org>; Sat, 27 Dec 2025 12:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766836816; cv=none; b=iNwbzmyOVHJv1Ioy8xm9F5cx+JqCX7FqVzSXYPuusOMc4xzXNJloY0He2HmyX2oarnuyIARb9zRzXZlD/YFgHh9bpv1cIgheIT2GlxB19eN3qERR6FJhZZvP+VWXiwv5f/F98p/9W9b8lEDdu3/RWULPTaPN34wpOVpN+3pd9Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766836816; c=relaxed/simple;
	bh=ut2Jxt6oSccGPdtkW4x8ScG4/mt2DQm0GhB2lgm0XYQ=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=SX5JdvbXkekPHFCl6kNWNbGClR92pXXJOX0Z+KMSU2aJ4FbmebbkqLYZx9Qzuiju77+TFbpzEmCoM7DvQ7k38RcWCOaxuASSZ44TqWucf7/x6EoSLyV3I5wrWJZQie+u4dxjSnR6gdLNGJa0o6Kt09FLNBWOsvjF9THhsIvZTM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QNwKjZ6D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QNwKjZ6D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766836812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZXV/8QNTbdwr9L4JXKUnSUo6XxXZVDBmsNgjF0cZS2E=;
	b=QNwKjZ6DFzfZSx9VI8mmXfcOnDdDfXt2PkEvC6c0cbDlgdbohWTFxQl4cJaJkRZnAsqCN+
	/vP3M4Le0c55vtLkbrG2xtAgjrBgw1YgoDQu4t4VjRuqgb+Tk6mb2SdrUS7e89z4GTGCzm
	jeSife66gyo6etGEVPPAP987UAsUt88=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-GUbEeikFPn2Sqc318MSdSw-1; Sat,
 27 Dec 2025 07:00:09 -0500
X-MC-Unique: GUbEeikFPn2Sqc318MSdSw-1
X-Mimecast-MFC-AGG-ID: GUbEeikFPn2Sqc318MSdSw_1766836807
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58A4F1956061;
	Sat, 27 Dec 2025 12:00:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2263919560AB;
	Sat, 27 Dec 2025 12:00:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <93b7f27c-ed92-4169-912a-c83088c85df9@linux.dev>
References: <93b7f27c-ed92-4169-912a-c83088c85df9@linux.dev> <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev> <20251225021035.656639-3-chenxiaosong.chenxiaosong@linux.dev>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v6 2/5] cifs: Autogenerate SMB2 error mapping table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1266595.1766836803.1@warthog.procyon.org.uk>
Date: Sat, 27 Dec 2025 12:00:03 +0000
Message-ID: <1266596.1766836803@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev> wrote:

> The following modifications make the table sorted in little-endian 
> order. If you are okay with the modifications, I can send the next version.

Don't do that.  Store it in cpu-endian order.

David

