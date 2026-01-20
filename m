Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AC52C3256
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 17:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768928612; cv=none; b=cfZw8DrUvnAQ5VktEVQkelJrOR5sKOmZ4CFI1DdDz3O89j4mg86qTf6qHqeLvManaisOGMqAoUB+ufoCmbO1t8B4Imng3+xiJP6LpVIaFngF5vI6rkGaEGsn3X6R+l4H14AluZzcOYOVValUm2S6yQQ1mzMgTtvyosHBnjtxjQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768928612; c=relaxed/simple;
	bh=69Ywl3w9xq+kGefBgpb2Nd4RIVYwrXLio17HcX3Zun8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=avZQmlwNDLI/jPmJKK7RISuvQWjkbXEyeXLat4CiHxijs37oR+b9S+sn5ij6H2YHUh7i138yPHkrSzOLqCnnSyswDGpZ7eOBgS5qPPX1VOniEOA7ipNNqR7Vg8EWLJ4Ta14Hh81zizXBAp9UFxQE/fHr5PjFC8c3ixCc1cEtipE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H/R+/b69; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H/R+/b69"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768928609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wL/I78IkyhL3WHhINDEYeLuEvurScAVQQm0lSm523Vc=;
	b=H/R+/b695wCIbuXHcSqE6yGGzitw3HnggWXOE5iorRYV7IWp5YKLM+5uXP5jak8wLDatxJ
	hklexMJatYGhvu4s12NGop3K8hdReAkWdVkxxrxS+oVihwcwKtn5B1DTbBJ9T9aUh+V9Y4
	AZCYU5feoZpNpvWandNkOutr905u+jU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-571-SGfGbgscMzWPAetHdEZ2cQ-1; Tue,
 20 Jan 2026 12:03:26 -0500
X-MC-Unique: SGfGbgscMzWPAetHdEZ2cQ-1
X-Mimecast-MFC-AGG-ID: SGfGbgscMzWPAetHdEZ2cQ_1768928604
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C53C219560AF;
	Tue, 20 Jan 2026 17:03:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.2])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2A8F51800993;
	Tue, 20 Jan 2026 17:03:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260120062152.628822-4-sprasad@microsoft.com>
References: <20260120062152.628822-4-sprasad@microsoft.com> <20260120062152.628822-1-sprasad@microsoft.com>
To: nspmangalore@gmail.com
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org, smfrench@gmail.com,
    pc@manguebit.com, bharathsm@microsoft.com,
    Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 4/4] cifs: make retry logic in read/write path consistent with other paths
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1261424.1768928601.1@warthog.procyon.org.uk>
Date: Tue, 20 Jan 2026 17:03:21 +0000
Message-ID: <1261425.1768928601@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi Shyam,

Some immediate thoughts for you.

nspmangalore@gmail.com wrote:

> +			break;
> +		} else
> +			trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_progress);

The 'else' is superfluous, given the 'break'.

> +		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_retry_needed);

Btw, feel free to add more trace values if you want to distinguish 'retries'
from 'replays' if that makes sense.

>  			break;
> -		}
> +		} else
> +			trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_progress);

Superfluous 'else' again.

> -			wdata->result = -ENOSPC;
> +			result = -ENOSPC;

I wonder if wdata->result is redundant.  Can wdata->subreq.error be used
instead (though that's unrelated to the subject of this patch).

David

