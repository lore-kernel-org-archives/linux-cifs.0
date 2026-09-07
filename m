Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C923403EF;
	Mon,  7 Sep 2026 17:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788803988; cv=none; b=mrSSO6+or34k/nv007CZXBt3jNtWzKaJLUI68kbQLyc+G1WYcsZPgSidXAa+RyOMB1jfZYtjZycKHAbW4PTJJwG6FgTHWOueW7f3HA1J8pdVCxC6mZ2Nwd0LBLp1kErCV7fEbF1pFY+BQQ4wHSvNZ5nmBLKfJobpV6wuGVhuo/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788803988; c=relaxed/simple;
	bh=IMHU+H5IfHFb3lkocPMvQu1REuBAuXAi57pRFXui07Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=az+1+z9SBvMom2ImPv4c17RbCevkXxqua0CC+LEoBzRUf6jFWO7ZoHoNs4lrF2Q1r25zv/yP90ssMHkfyvsp4MPUnncT/dyVuCkqrUijwXne8KGdXAUOWXjRuvamS1dlDpzfSJVbS9UZ+YGbNTaSTVlzVnww6RwVMQDwpFO/D3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=eNQi31c2; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="eNQi31c2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1788803987; x=1820339987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XvTUmXvoh3a7PVjRYBNX6k3gA2v6vhjklyK/IlRTA04=;
  b=eNQi31c2HxDXHKFFVZrpO3G035+pBZCnFws9izvWiKAoAYNgxTMGizaW
   CFDe4dQXptl9L2XCKrAX3PJP5bhYBcr92mzr6ftjm2xNVxqA+04UGJKFi
   3Odjcs/N7OVDCqcajyFSVo5r8gjWqlEbwXyxv345CVEJcrlEpd40f1dvx
   qwvr0+oHl1RtCOynSDXMAY68X5Tyo5+TlR6n2Z2fcCmbdMWI06XpSZIrv
   RWjBkmgC7OAU18VkEyk1szU/xF3R4XDy6MhqMzfUxxnoXbWzb3akWy1t9
   TpkBQVCcEXWk/okTRaHKx02zbczGAFGyZQEYugxQ9Dlh5RHYMgeyzHuMc
   Q==;
X-CSE-ConnectionGUID: R6RwG5VaTzOOg+RciZqnyw==
X-CSE-MsgGUID: EmefM6qNRKuIXsI3+N+w+w==
X-IronPort-AV: E=Sophos;i="6.25,267,1779148800"; 
   d="scan'208";a="27553766"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 17:59:44 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:4674]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.40.124:2525] with esmtp (Farcaster)
 id 0247be03-975d-4825-9943-6503bfd3dd67; Mon, 7 Sep 2026 17:59:44 +0000 (UTC)
X-Farcaster-Flow-ID: 0247be03-975d-4825-9943-6503bfd3dd67
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Mon, 7 Sep 2026 17:59:44 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Mon, 7 Sep 2026 17:59:43 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: Namjae Jeon <linkinjeon@kernel.org>
CC: Bjoern Doebel <doebel@amazon.de>, <linux-cifs@vger.kernel.org>,
	<pc@manguebit.org>, <ronniesahlberg@gmail.com>, <sprasad@microsoft.com>,
	<tom@talpey.com>, <bharathsm@microsoft.com>,
	<samba-technical@lists.samba.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] smb: client: fix heap overflow in DACL owner/group rewrite
Date: Mon, 7 Sep 2026 17:59:23 +0000
Message-ID: <ap77V8bEpMjSvdOj@amazon.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <CAKYAXd8r-zvLH6Ecxu33jDAjM_6Uv2KFS4Naa-tYFHAwntgreQ@mail.gmail.com>
References: <20260709155440.2132459-1-doebel@amazon.de> <20260904125844.1803343-1-doebel@amazon.de> <CAKYAXd8r-zvLH6Ecxu33jDAjM_6Uv2KFS4Naa-tYFHAwntgreQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D038UWC004.ant.amazon.com (10.13.139.229) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Hi Namjae,

On Sat, Sep 05, 2026 at 10:15:37AM +0900, Namjae Jeon wrote:
> > @@ -1815,11 +1815,13 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
> >                                 cifs_put_tlink(tlink);
> >                                 return rc;
> >                         }
> > -                       if (mode_from_sid)
> > -                               nsecdesclen +=
> > -                                       le16_to_cpu(dacl_ptr->num_aces) * sizeof(struct smb_ace);
> > -                       else /* cifsacl */
> > -                               nsecdesclen += le16_to_cpu(dacl_ptr->size);
> > +                       /*
> > +                        * Worst case: every ACE is rewritten with a new SID of
> > +                        * SID_MAX_SUB_AUTHORITIES sub-auths -> sizeof(smb_ace) each,
> > +                        * plus the smb_acl header replace_sids_and_copy_aces() emits.
> Since you mentioned replace_sids_and_copy_aces(), please check whether
> replace_sids_and_copy_aces() also has a potential overflow issue.

That looks sensible. I'll send a followup v3 (the original patch also
needs an update to the Fixes: tag, as you point out.)

Bjoern

