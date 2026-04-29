Received: from cse.ust.hk (cssvr7.cse.ust.hk [143.89.41.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FADA3B8BD1;
	Wed, 29 Apr 2026 09:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=143.89.41.157
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777453468; cv=pass; b=W3R4oVBL0a2+IASDlzpnLaqglcX1K97DkaEkEkhkDANxXXk3XR0wnzRzRDnpZIrVYymCF6lRS9OLUTX/UPWV1l7ix2Iw/vtAZD1vePTKWx8427389Fz2FnAttklTxI34jfC/lvm4dkS4YH4C69zS8lyd8ziwLn1TB/H74A6MlN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777453468; c=relaxed/simple;
	bh=iKrkcM9Z3p2ijasIv53wNOlemWi42Epaovpsf5JvyiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iTQF2zTzBV4BSNjfmm0JwCxuVgD72HuCToBweSRzn0mUfEPEzwJe9mtyS6+GI0D/BxXlMZZEAe3pQ2ik56vYPBet9b7iBiocBsgGuyPsC2RWgCwZr6dFuWYt0mYBYOgrMZM9IyTpGJPdn4MfriRy5sXSLbkba9V4BVyibWqHnyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk; spf=pass smtp.mailfrom=cse.ust.hk; dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b=whNLnPTH; arc=pass smtp.client-ip=143.89.41.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b="whNLnPTH"
ARC-Seal: i=1; d=cse.ust.hk; s=arccse; a=rsa-sha256; cv=none; t=1777453448;
	b=Nj8daFpt928C6rzNeFMQpbJcj+NDWYlogqWRX/I2xl+efh9RrEFWeMy+2LoV92QJt/vX
	 w+SvRNkEIVvLMRf1fbWzH175fXsrIOM5trg5Sv88/RWFMIl2oHOPY3pS+kJs/C/K7Fu9O
	 GaInDYSeYjDJ8qmJu09r3HeaiwR6AdfCbA=
ARC-Message-Signature: i=1; d=cse.ust.hk; s=arccse; a=rsa-sha256;
	c=relaxed/relaxed; t=1777453448;
	h=DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version;
	bh=dIR0y+9u5dRbumJlLK2vjotk4Gly3R5STWOQTyyknzE=;
	b=JiMQ+yve2YxCaUnVl0IrxLiv3gNEEecQH2H3aoz3CVrAwa+URVOzmbSLaeiSyczbdrER
	 xe0TjI33hl0a3M14kvn423WxuJq4bYFR1Rkz/h/4KVeQgvC2oLQocjuRGdJFfASZnlkzF
	 XjaumsJ+GLzM0yai/BDO7ighWNm1XVf8y4=
ARC-Authentication-Results: i=1; cse.ust.hk; arc=none smtp.remote-ip=143.89.191.45
Received: from chcpu16 (191host045.mobilenet.cse.ust.hk [143.89.191.45])
	(authenticated bits=0)
	by cse.ust.hk (8.18.1/8.12.5) with ESMTPSA id 63T93pkr3612389
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 17:04:08 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cse.ust.hk;
	s=cseusthk; t=1777453448;
	bh=dIR0y+9u5dRbumJlLK2vjotk4Gly3R5STWOQTyyknzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=whNLnPTHh+qnfxkqQJL6RIC0AYVkUcJtZ7SAq819hIu2DnDstz47UNuzuNdr7oX5x
	 ffAL2I25oRnaOb0MOk2O1X9SKPj/t3oZcPd0RsCUqq1OpVYEHp3IgaUFPWtn2QcsJr
	 MdVO/u4qba4/OYJMBL0uifh+y8AIVCK7NeuGkgFc=
Date: Wed, 29 Apr 2026 17:03:46 +0800
From: Shuhao Fu <sfual@cse.ust.hk>
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
        linux-cifs@vger.kernel.org
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ksmbd: fail share config requests when path allocation
 fails
Message-ID: <20260429090346.GA3329611@chcpu16>
References: <20260429085956.GA3326432@chcpu16>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429085956.GA3326432@chcpu16>
X-Env-From: sfual

Hi,

I did a live repro on a current mainline tree to confirm that the
published NULL share path is not just an internal invariant break and can
fault a normal ksmbd request path.

The reproducer forced only the share path duplication failure that
produces the published NULL path state. No consumer-side ksmbd path was
modified.

Repro setup:

1. Start from mainline with CONFIG_SMB_SERVER=y and CONFIG_CIFS=y.
2. Add a narrow temporary trigger in share_config_request() so that only
   one test share forces the path duplication step to fail, leaving
   share->path as NULL while still allowing the share to be published.
   No consumer-side ksmbd path was modified.
3. Boot that kernel under QEMU/KVM with a custom initramfs.
4. In the guest, run a tiny userspace generic-netlink responder that:
   - sends KSMBD_EVENT_STARTING_UP
   - answers login requests as guest
   - answers share config requests for the test share with a valid
     export path
   - answers tree connect requests as writable guest
5. From the same guest, mount that test share over loopback with:

   mount -t cifs //<guest-ip>/<test-share> /mnt/cifs \
     -o guest,vers=3.1.1,port=445,uid=0,gid=0

That mount attempt hit the expected fault path. The clean serial log
showed:

  [   21.045838] CIFS: Attempting to mount //<guest-ip>/<test-share>
  [   21.052302] BUG: kernel NULL pointer dereference, address: 0000000000000000
  [   21.062798] RIP: 0010:strlen+0xb/0x20
  [   21.077290]  do_getname_kernel+0x12/0xf0
  [   21.077707]  __ksmbd_vfs_kern_path+0x89/0x390
  [   21.078648]  smb2_open+0xa03/0x20b0

This matches the expected downstream flow:

- tree connect stores the published share in tree_conn->share_conf
- a share-root SMB2 create builds an empty pathname in smb2_open()
- ksmbd_vfs_path_lookup() interprets that as "use the share root" and
  substitutes tree_conn->share_conf->path
- the broken published share has tree_conn->share_conf->path == NULL
- that NULL pathname reaches do_getname_kernel()/strlen()

I also did a second run with the guest netlink responder logging directly
to the serial console. That log was noisy because the userspace prints
interleaved with the kernel Oops, but it still showed the login request
and the tree connect for the test share immediately around the crash.

I can provide more detail, including the temporary repro pieces and the
serial logs, if useful.

Thanks,
Shuhao

On Wed, Apr 29, 2026 at 05:00:13PM +0800, Shuhao Fu wrote:
> Non-pipe shares must have a duplicated backing path before they can be
> published. share_config_request() currently calls kstrndup() for that
> path, but if the allocation fails it leaves ret unchanged. If veto list
> parsing succeeds and share->name exists, the partially built share is
> still inserted into the global share table with share->path left NULL.
> 
> A later share-root SMB2 create uses tree_conn->share_conf->path as the
> lookup root. If the share was published with path == NULL, that request
> passes a NULL pathname into do_getname_kernel()/strlen() and can crash
> the ksmbd worker.
> 
> Set ret = -ENOMEM when path duplication fails so the incomplete share is
> destroyed before publication.
> 
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
