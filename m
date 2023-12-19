Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDA91CA82
	for <linux-cifs@vger.kernel.org>; Tue, 19 Dec 2023 14:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="GzWQhCl1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1702996457; x=1734532457;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=W6VDjDYf14QSxQDawbrb1gkDsbFWMzWpadsIl9dpbKM=;
  b=GzWQhCl1W4/e0LFO8nBnn8IxKcdKAVP2KYr9SNIk5iZpLo2pIMWh1kVN
   zz3TuQsvYh8YK5M5zur5sPrq9vVuaAPfPwiQTcSUCM9v7IicVGo5FsSui
   m/ALom6/+FzmlYJ90gnJLitToJXxQm6TTJyW3hAgcM97MTBqtG2hZgalu
   Y=;
X-IronPort-AV: E=Sophos;i="6.04,288,1695686400"; 
   d="scan'208";a="375014698"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 14:34:14 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id 917C2A2E95;
	Tue, 19 Dec 2023 14:34:13 +0000 (UTC)
Received: from EX19MTAUEC001.ant.amazon.com [10.0.44.209:65164]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.59.79:2525] with esmtp (Farcaster)
 id 89d90a09-ef0b-4430-98c9-943989a62ded; Tue, 19 Dec 2023 14:34:13 +0000 (UTC)
X-Farcaster-Flow-ID: 89d90a09-ef0b-4430-98c9-943989a62ded
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 19 Dec 2023 14:34:12 +0000
Received: from dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com (10.15.57.183)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server id
 15.2.1118.40 via Frontend Transport; Tue, 19 Dec 2023 14:34:12 +0000
Received: by dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com (Postfix, from userid 5466572)
	id 4784296D; Tue, 19 Dec 2023 14:34:12 +0000 (UTC)
Date: Tue, 19 Dec 2023 14:34:12 +0000
From: Maximilian Heyne <mheyne@amazon.de>
To: Paulo Alcantara <pc@manguebit.com>
CC: <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>, <j51569436@gmail.com>
Subject: Re: [PATCH 2/2] smb: client: fix potential OOB in smb2_dump_detail()
Message-ID: <ZYGp5FL9UYY5lYHg@amazon.de>
References: <20231216041005.7948-1-pc@manguebit.com>
 <20231216041005.7948-2-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231216041005.7948-2-pc@manguebit.com>

On Sat, Dec 16, 2023 at 01:10:05AM -0300, Paulo Alcantara wrote:
> Validate SMB message with ->check_message() before calling
> ->calc_smb_size().
> 
> This fixes CVE-2023-6610.
> 
> Reported-by: j51569436@gmail.com
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218219
> Signed-off-by: Paulo Alcantara <pc@manguebit.com>
> ---
>  fs/smb/client/smb2ops.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 62b0a8df867b..66b310208545 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -403,8 +403,10 @@ smb2_dump_detail(void *buf, struct TCP_Server_Info *server)
>  	cifs_server_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d\n",
>  		 shdr->Command, shdr->Status, shdr->Flags, shdr->MessageId,
>  		 shdr->Id.SyncId.ProcessId);
> -	cifs_server_dbg(VFS, "smb buf %p len %u\n", buf,
> -		 server->ops->calc_smb_size(buf));
> +	if (!server->ops->check_message(buf, server->total_read, server)) {

Why is this check negated? Sorry for this stupid question. I'm not
familiar with this code but only stumbled upon this commit due to a CVE.

> +		cifs_server_dbg(VFS, "smb buf %p len %u\n", buf,
> +				server->ops->calc_smb_size(buf));
> +	}
>  #endif
>  }
>  
> -- 
> 2.43.0
> 



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



