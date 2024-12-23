Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5282C18DF6D;
	Mon, 23 Dec 2024 10:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734950041; cv=none; b=B45ozchdZ0Ef8HaklpFSmsi2waipvbI5NTaOAoRpp6zKEdfChZEPWPK8cOPPXKmCGwSXRgRm7Ku1X4pqDLO9avD8Cz3w+uJnF02jSDWxljr1JmdkhIVBZHJ3wvRm6QGa87UoZcA+8ITy9abB4nUNVxSVwk1dtEGOILSl0W1rjOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734950041; c=relaxed/simple;
	bh=JW31Av8hFdfqwHR5CHc/hA1Wdkm/No3pG55BzpICgC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=utMemnTuC7GHj4T+2MLWmS0OCfoRt0cS3yTYuNLS7ybP970WDKCTQDR9a4pmX+tcEcTMkxh8u2EuefU5xWLheQNkhBf8oIw4XBAmzjgos2uCXGwx/WJ4PxMyvAX+MzPUNFxI622p66ubbunkhZH/kpcfbX/SPoJtgJkN64ua33c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ctK806Qc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ctK806Qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42CEC4CED3;
	Mon, 23 Dec 2024 10:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734950041;
	bh=JW31Av8hFdfqwHR5CHc/hA1Wdkm/No3pG55BzpICgC0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ctK806QcIf798LhVoNmqxlYofckN6ydLThi+Ltj++YzmgYcHthpXxXeeZDvAj++NP
	 lgHptconab0Nh5QRzHzcuWnSH6vc5dUv8iot89Ljifc+O+1r0NM/ccKPw08jl6vtUg
	 tsdIxVsfbYnhByOebCPp1KwdIWuIe2BSz6Rm43MlQcrqdb74u82BW8tuoEz3AJQRaX
	 yJ39qi2+A74cktQh1UJ/H2Bsd3C2qSjT07ZDmiVJd/pTo+psCz4broATvf3h5mlu+p
	 G7eNeY82jNqVg7a+rgoQYC/oifk0y9eGUp4E9qlznyKSZM4lKCiPxndT1Iz1y2nlCQ
	 iKfYS5eVVqHzg==
Received: by pali.im (Postfix)
	id E4524819; Mon, 23 Dec 2024 11:33:50 +0100 (CET)
Date: Mon, 23 Dec 2024 11:33:50 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] cifs: Add a new xattr system.smb3_ntsd_owner for
 getting or setting owner
Message-ID: <20241223103350.v5lmcgd3mzpyn2yc@pali>
References: <20241222151051.23917-1-pali@kernel.org>
 <20241222151051.23917-5-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241222151051.23917-5-pali@kernel.org>
User-Agent: NeoMutt/20180716

I'm thinking about this change...

Currently this change via system.smb3_ntsd_owner changes both user owner
and group owner. Would not it be rather better to have separate xattrs
for changing just user owner and separate for changing just group owner?

Example scenario: If you are logged in Administrator and have granted
zero access rights for particular file, then you do not have permission
to neither read DACL, not read user and group owner, but as you are
Administrator, you have privilege to change user and group owners.

So for example, in this scenario you as Administrator could want to just
change group owner to yourself, without touching user owner, so the
original user owner would still have all access to that file. But with
this change, this is not possible yet, as it is required to change both
user and group owners.

On Sunday 22 December 2024 16:10:51 Pali Rohár wrote:
> Changing owner is controlled by DACL permission WRITE_OWNER. Changing DACL
> itself is controlled by DACL permisssion WRITE_DAC. Owner of the file has
> implicit WRITE_DAC permission even when it is not explicitly granted for
> owner by DACL.
> 
> Reading DACL or owner is controlled only by one permission READ_CONTROL.
> WRITE_OWNER permission can be bypassed by the SeTakeOwnershipPrivilege,
> which is by default available for local administrators.
> 
> So if the local administrator wants to access some file to which does not
> have access, it is required to first change owner to ourself and then
> change DACL permissions.
> 
> Currently Linux SMB client does not support to do this, because it does not
> provide a way to change owner without touching DACL permissions.
> 
> Fix this problem by introducing a new xattr for setting only owner part of
> security descriptor.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  fs/smb/client/xattr.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
> index 95b8269851f3..b88fa04f5792 100644
> --- a/fs/smb/client/xattr.c
> +++ b/fs/smb/client/xattr.c
> @@ -32,6 +32,7 @@
>   */
>  #define SMB3_XATTR_CIFS_ACL "system.smb3_acl" /* DACL only */
>  #define SMB3_XATTR_CIFS_NTSD_SACL "system.smb3_ntsd_sacl" /* SACL only */
> +#define SMB3_XATTR_CIFS_NTSD_OWNER "system.smb3_ntsd_owner" /* owner only */
>  #define SMB3_XATTR_CIFS_NTSD "system.smb3_ntsd" /* owner plus DACL */
>  #define SMB3_XATTR_CIFS_NTSD_FULL "system.smb3_ntsd_full" /* owner/DACL/SACL */
>  #define SMB3_XATTR_ATTRIB "smb3.dosattrib"  /* full name: user.smb3.dosattrib */
> @@ -39,7 +40,7 @@
>  /* BB need to add server (Samba e.g) support for security and trusted prefix */
>  
>  enum { XATTR_USER, XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT,
> -	XATTR_CIFS_NTSD_SACL,
> +	XATTR_CIFS_NTSD_SACL, XATTR_CIFS_NTSD_OWNER,
>  	XATTR_CIFS_NTSD, XATTR_CIFS_NTSD_FULL };
>  
>  static int cifs_attrib_set(unsigned int xid, struct cifs_tcon *pTcon,
> @@ -163,6 +164,7 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
>  
>  	case XATTR_CIFS_ACL:
>  	case XATTR_CIFS_NTSD_SACL:
> +	case XATTR_CIFS_NTSD_OWNER:
>  	case XATTR_CIFS_NTSD:
>  	case XATTR_CIFS_NTSD_FULL: {
>  		struct smb_ntsd *pacl;
> @@ -190,6 +192,10 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
>  						    CIFS_ACL_GROUP |
>  						    CIFS_ACL_DACL);
>  					break;
> +				case XATTR_CIFS_NTSD_OWNER:
> +					aclflags = (CIFS_ACL_OWNER |
> +						    CIFS_ACL_GROUP);
> +					break;
>  				case XATTR_CIFS_NTSD_SACL:
>  					aclflags = CIFS_ACL_SACL;
>  					break;
> @@ -315,6 +321,7 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
>  
>  	case XATTR_CIFS_ACL:
>  	case XATTR_CIFS_NTSD_SACL:
> +	case XATTR_CIFS_NTSD_OWNER:
>  	case XATTR_CIFS_NTSD:
>  	case XATTR_CIFS_NTSD_FULL: {
>  		/*
> @@ -334,6 +341,9 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
>  		case XATTR_CIFS_NTSD:
>  			extra_info = OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO;
>  			break;
> +		case XATTR_CIFS_NTSD_OWNER:
> +			extra_info = OWNER_SECINFO | GROUP_SECINFO;
> +			break;
>  		case XATTR_CIFS_NTSD_SACL:
>  			extra_info = SACL_SECINFO;
>  			break;
> @@ -465,6 +475,13 @@ static const struct xattr_handler smb3_ntsd_sacl_xattr_handler = {
>  	.set = cifs_xattr_set,
>  };
>  
> +static const struct xattr_handler smb3_ntsd_owner_xattr_handler = {
> +	.name = SMB3_XATTR_CIFS_NTSD_OWNER,
> +	.flags = XATTR_CIFS_NTSD_OWNER,
> +	.get = cifs_xattr_get,
> +	.set = cifs_xattr_set,
> +};
> +
>  static const struct xattr_handler cifs_cifs_ntsd_xattr_handler = {
>  	.name = CIFS_XATTR_CIFS_NTSD,
>  	.flags = XATTR_CIFS_NTSD,
> @@ -511,6 +528,7 @@ const struct xattr_handler * const cifs_xattr_handlers[] = {
>  	&cifs_cifs_acl_xattr_handler,
>  	&smb3_acl_xattr_handler, /* alias for above since avoiding "cifs" */
>  	&smb3_ntsd_sacl_xattr_handler,
> +	&smb3_ntsd_owner_xattr_handler,
>  	&cifs_cifs_ntsd_xattr_handler,
>  	&smb3_ntsd_xattr_handler, /* alias for above since avoiding "cifs" */
>  	&cifs_cifs_ntsd_full_xattr_handler,
> -- 
> 2.20.1
> 
