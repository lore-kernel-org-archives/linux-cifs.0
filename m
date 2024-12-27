Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B514320B;
	Fri, 27 Dec 2024 14:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735310491; cv=none; b=dLqHr/d1JLtium+ZsFkF24ZiAggbSZMxSiuHfHdMDS9GYp6ls5NK1q6iyCI+g0aoFAZR5XmAByKAVcxkCpCeLfV+COE3ff0Z2JWHM34wpNISUrgE4q9R3Pa3uZCav+n68ZY7A+Tcse8Hxe/kBeqLycgdwc4LXf/+FE2+cUmc03o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735310491; c=relaxed/simple;
	bh=Av43lv3ytxE1A7i3cWYA3i7vXwopXr2ob5+8N2cvPpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HPlNXWCaP7pEW/DSMHT5pVuOrhEO8I/pkuk+qtETzacnc7Cqflwb8QOuj/X6BmhmuL6JH957JTJnPqKw81INqvTz8Gh4KGwnpYYkiqevU8EHlVu+HJ8i6t9jYkU7GeKg0Q0vaLbZL0QVrNj2rNnaoh7Mj3rTOHh+/KXupOSCA8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qMKQ7aRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qMKQ7aRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E23C4CED0;
	Fri, 27 Dec 2024 14:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735310490;
	bh=Av43lv3ytxE1A7i3cWYA3i7vXwopXr2ob5+8N2cvPpI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qMKQ7aRFUDgOsmG486tOAf5LrfM0JG1zIYen41kXAgV9cW+o2f46U1MYpM/r2PNy7
	 Lw4UgNahNryDW+RevVGjXp25lw4xfPVNe9Lr3P7Hg3mIZV9Jxo2p5byt+2LReu+A6d
	 czrEDLnXhOV0QCjce3ji1kobvQBxLYjTARJwa5Up25qWRCsXOjTTuTMBz4u2tg30jY
	 5IgzQiDfPhr+/qAlOGuzE9+VMIfKpzmZnJD1AKrvb2qPQOtMHFhlmP5wzAhRyAXqQM
	 up952nee/Kcv8HmlvdklJ20sKR4Lq0AEos31NuRz5/zMerar6zpNLahnvofUjDXSSd
	 7qNOM9vi7h3Vg==
Received: by pali.im (Postfix)
	id 4A337787; Fri, 27 Dec 2024 15:41:20 +0100 (CET)
Date: Fri, 27 Dec 2024 15:41:20 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Implement is_network_name_deleted for SMB1
Message-ID: <20241227144120.lnxc4acxpkvt7khw@pali>
References: <20241222171431.24657-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241222171431.24657-1-pali@kernel.org>
User-Agent: NeoMutt/20180716

On Sunday 22 December 2024 18:14:31 Pali Rohár wrote:
> This change allows Linux SMB1 client to autoreconnect the share when it is
> modified on server by admin operation which removes and re-adds it.
> 
> Implementation is reused from SMB2+ is_network_name_deleted callback. There
> are just adjusted checks for error codes and access to struct smb_hdr.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  fs/smb/client/smb1ops.c | 44 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> index 0533aca770fc..76e7353f2a72 100644
> --- a/fs/smb/client/smb1ops.c
> +++ b/fs/smb/client/smb1ops.c
> @@ -14,6 +14,8 @@
>  #include "cifspdu.h"
>  #include "cifs_unicode.h"
>  #include "fs_context.h"
> +#include "nterr.h"
> +#include "smberr.h"
>  
>  /*
>   * An NT cancel request header looks just like the original request except:
> @@ -1075,6 +1077,47 @@ cifs_make_node(unsigned int xid, struct inode *inode,
>  				  full_path, mode, dev);
>  }
>  
> +static bool
> +cifs_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
> +{
> +	struct smb_hdr *shdr = (struct smb_hdr *)buf;
> +	struct TCP_Server_Info *pserver;
> +	struct cifs_ses *ses;
> +	struct cifs_tcon *tcon;
> +
> +	if (shdr->Flags2 & SMBFLG2_ERR_STATUS) {
> +		if (shdr->Status.CifsError != cpu_to_le32(NT_STATUS_NETWORK_NAME_DELETED))
> +			return false;
> +	} else {
> +		if (shdr->Status.DosError.ErrorClass != ERRSRV ||
> +		    shdr->Status.DosError.Error != cpu_to_le16(ERRinvtid))
> +			return false;
> +	}
> +
> +	/* If server is a channel, select the primary channel */
> +	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
> +
> +	spin_lock(&cifs_tcp_ses_lock);
> +	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
> +		if (cifs_ses_exiting(ses))
> +			continue;
> +		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
> +			if (tcon->tid == le32_to_cpu(shdr->Tid)) {

Kernel test robot complained on this line about endianity issues. I have
looked why, and I figured out that for smb1 the tcon->tid value is
stored in the little endian, but for smb2+ it is stored in cpu endian.
Hence this line should be:

-			if (tcon->tid == le32_to_cpu(shdr->Tid)) {
+			if (tcon->tid == shdr->Tid) {

I will include this fixup into v2 when needed (during next rebase).

Note that it is hard to catch such endianity issues as majority of user
machines are little endian, so such issues are hidden.

> +				spin_lock(&tcon->tc_lock);
> +				tcon->need_reconnect = true;
> +				spin_unlock(&tcon->tc_lock);
> +				spin_unlock(&cifs_tcp_ses_lock);
> +				pr_warn_once("Server share %s deleted.\n",
> +					     tcon->tree_name);
> +				return true;
> +			}
> +		}
> +	}
> +	spin_unlock(&cifs_tcp_ses_lock);
> +
> +	return false;
> +}
> +
>  struct smb_version_operations smb1_operations = {
>  	.send_cancel = send_nt_cancel,
>  	.compare_fids = cifs_compare_fids,
> @@ -1159,6 +1202,7 @@ struct smb_version_operations smb1_operations = {
>  	.get_acl_by_fid = get_cifs_acl_by_fid,
>  	.set_acl = set_cifs_acl,
>  	.make_node = cifs_make_node,
> +	.is_network_name_deleted = cifs_is_network_name_deleted,
>  };
>  
>  struct smb_version_values smb1_values = {
> -- 
> 2.20.1
> 
