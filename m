Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC023E9C1F;
	Mon,  6 Jul 2026 20:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783371011; cv=none; b=tdzFKFEqNsoVsZb7z2cNWRoakzOl3+gxucqNiRXoJmw5YKZ21/Phy1G/sgW6c5iFt1ehkNzb9DDjBeTpl8J69ZFGKpHF3VD7aVHlE8QmvwLy9ZEGctxiQRQkAiiXPF9yhuLPFVjJN8pzNK0GqdjOLvCTEgBFYsM5L7V7uELXyH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783371011; c=relaxed/simple;
	bh=bQYvLg3qvZsIXm9FKQt//N1tg037ldTljt2svvj+HC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pq6+cFS9qeppiilXj7Qffkzj8+d1sHPY79SHfvr674Bh1esW3y4A3P/0jKyHUdoRXLHCNRIKN96fyf2LjD8eXpcVQFfNS+xAgy3qEwcmEuz3635gRuzRYiDBFrtJLGOpX0MpeeB0s3dJCGNKKGeGSaVqWl/nNctyHXPbyj+yxVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DW564mii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DW564mii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F8D1F000E9;
	Mon,  6 Jul 2026 20:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783371009;
	bh=Y1lZ0IR4jhsIFiwZpxSY9NwXhbnUI+4v+4b8CE49ouE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DW564miisloInQtbNszR8Sow5HKmwL0CECoSy6sI8+qvrm2Y5kdqA5SWq5zQLLp4s
	 rXOWux0792pHnf/6fRBjCrBABYZNuszm4MHjCSEwow69sO9dOnnnvQvRD60bNC/gVU
	 1z0f6BuLm3F9n+GiOdszYVANLOAdXDtTbVerLadnO43vUcRX89IZZ/ALCUHQDiLC9m
	 UnIi5GJmCskC7Y1CsHWQtxhD6h/7ShbO61NVwv6HQRmCnttcfHvFm1QCN+RyQP8E6E
	 tP39RfIkx3DZRn5fUYmyVSvDnsiy7hRrgG7Q5qS7whugPCOl79DhNabV9VKpb/Lxym
	 qoa5x8WBEq71Q==
Received: by pali.im (Postfix)
	id 0A0FF5D7; Mon,  6 Jul 2026 22:50:06 +0200 (CEST)
Date: Mon, 6 Jul 2026 22:50:06 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 10/11] cifs: Add support for parsing WSL symlinks
 in version 1 format
Message-ID: <20260706205006.a4oczzxh4ythlty3@pali>
References: <20260706184819.22124-1-pali@kernel.org>
 <20260706184819.22124-11-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260706184819.22124-11-pali@kernel.org>
User-Agent: NeoMutt/20180716

On Monday 06 July 2026 20:48:18 Pali Rohár wrote:
> -	/* MS-FSCC 2.1.2.7 defines layout of the Target field only for Version 2. */
>  	u32 version = le32_to_cpu(buf->Version);
> +	switch (version) {
> +	case 1:
> +		/*
> +		 * Layout version 1 stores the symlink target in the data section of
> +		 * the file encoded in UTF-8 without trailing null-term byte.
> +		 */
>  
> -	if (version != 2) {
> +		oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_READ_DATA,
> +				     FILE_OPEN, CREATE_NOT_DIR | OPEN_REPARSE_POINT,
> +				     ACL_NO_MODE);
> +		oparms.fid = &fid;
> +		oplock = tcon->ses->server->oplocks ? REQ_OPLOCK : 0;
> +		rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
> +		if (rc)
> +			goto out;
> +
> +		free_symname_utf8 = true;
> +		symname_utf8_len = le64_to_cpu(data->fi.EndOfFile);
> +		symname_utf8 = kmalloc(symname_utf8_len, GFP_KERNEL);
> +		if (!symname_utf8) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}

Sashiko AI wrote:
https://sashiko.dev/#/patchset/20260706184819.22124-1-pali%40kernel.org

  Does this leak the server-side file handle and oplock?
  If this kmalloc() fails, the code jumps to the out label without calling
  tcon->ses->server->ops->close(xid, tcon, &fid).

This is really a problem. I would suggest to move the kmalloc() block
above the tcon->ses->server->ops->open(...) block which should address
this issue. E.g.:

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 3418e4b66022..3fe57d166776 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1133,6 +1133,14 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
 		 * the file encoded in UTF-8 without trailing null-term byte.
 		 */

+		free_symname_utf8 = true;
+		symname_utf8_len = le64_to_cpu(data->fi.EndOfFile);
+		symname_utf8 = kmalloc(symname_utf8_len, GFP_KERNEL);
+		if (!symname_utf8) {
+			rc = -ENOMEM;
+			goto out;
+		}
+
 		oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_READ_DATA,
 				     FILE_OPEN, CREATE_NOT_DIR | OPEN_REPARSE_POINT,
 				     ACL_NO_MODE);
@@ -1142,14 +1150,6 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
 		if (rc)
 			goto out;

-		free_symname_utf8 = true;
-		symname_utf8_len = le64_to_cpu(data->fi.EndOfFile);
-		symname_utf8 = kmalloc(symname_utf8_len, GFP_KERNEL);
-		if (!symname_utf8) {
-			rc = -ENOMEM;
-			goto out;
-		}
-
 		buf_type = CIFS_NO_BUFFER;
 		io_parms = (struct cifs_io_parms) {
 			.netfid = fid.netfid,
