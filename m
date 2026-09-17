Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A594DBD62;
	Thu, 17 Sep 2026 11:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789645414; cv=none; b=DKQ7H/JWiBy6o/cPnL5QZJVy5kbcZ/E3KCjUe+Whq1IYECDmzHj1+x7wiDcVzG5ptLmF+V98BhOst79Rs2dwv+Ep+3tGXa9vVSrnbchfLmELiskz4fbrihsttUadIooy1UoPiQtn82siujfyv6N2IJ81IGWs+GqKAhZqK2oVSyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789645414; c=relaxed/simple;
	bh=+oALyQfyCBImWc42oRDoUs+yaA7/NIOCeIZKNtpZWdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KfSENvIiBpW02fr9b19pj8daf+UGV+YuMwalH1Bl0ufET1RgZQdfJDC1jeotdZ95b0qNsFqFpcwIXjqLmD8UdosyoD/pc+ySUXItdw5Ozqagd8I2xUC/CSyOzdkMz+fUwHPlqL/CuZ644PCOjvvzbbeooKPS3NjK4UHt2myUfZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=giGAT/00; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ZXPDk0xY; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="giGAT/00";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZXPDk0xY"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 655411D00065;
	Thu, 17 Sep 2026 07:43:20 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 17 Sep 2026 07:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1789645400; x=1789731800; bh=1qcRLqhjP+
	2RUdyDaTkqVzJJt8ARHYyVImCNVpe5Y50=; b=giGAT/00Fqq0KtWwuUhwKR31/4
	09TToFwhGuSPM8d5m9syzAxi16Z+dnLqMpL217yzhSocXSGMOs2IQoCwuVa2cADU
	YPfPaj4fo5o5HW2fJOKLmDYXgwsqRQgt3xiWl+rl7nfAi3GRQB1+yCFBDpDFCubH
	uLTenQUCrOsxS2rK5sMhbUhroKaxl2jbEgmAxRas24cF3KBjUNvk3G01+V4dmtS9
	uAKsujZF6Pat8YufeO0lEHZVz1LeJ+wKiP/tvCo+PC5LFBpwK6AeoTUcldX4Tsb9
	BlVQu4GIPRtjirSJRWXh2tpdcnJ7UeX03S27d8O6Kaze2kjq2cgr2WS8CfDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789645400; x=1789731800; bh=1qcRLqhjP+2RUdyDaTkqVzJJt8ARHYyVImC
	NVpe5Y50=; b=ZXPDk0xY93VzQiM97E3hNyZSbjLaVPaVe64NlqIOf27LIsG70wp
	CbtKEIIaEl1ygzgXgPaWMMCYKbSoKGAkVtdOAFlkRyJ/B1WqJeStlZ9wQ+YwB6mY
	bHTRvIMZH/PLoe5f2agWMLY/tFm4IdsMx4PYTSkMa7lsRFV0qAZmkMQBVlg1sRvt
	q2kJJKSBf6EdgooyQcu/QLuC9Nnsj325xscplciqu6tehrOJFTwKolRkYe8vGRTY
	uvXIpi1CSekVDzENDno39oSkkcciyrNsABPgaa1mgofG9+V5pzyyPbdVebevxj3i
	iwxDtVVZv1m7O+ZbiwasN1Pt5lCWbA9PZ1w==
X-ME-Sender: <xms:WNKraq4Lsr_UdvGZY6FmDTtU6lEw2oAX1o20LHBCP5zgg98BURb-Ww>
    <xme:WNKralP-httnh4g02S5WQJDvzNu6BmEu6_FZTuNuzH8B-PsvyTeNJuVKfnXWgHdQ7
    T2XTMF-FF_hrdknI9hRR7_skHwqHdvoCBMHfWFHkIM1TgdonAE>
X-ME-Received: <xmr:WNKrauHfq8oQBxQTJAdsJzfS2O814PKEYg6-l3lKcUm4BH1KNLhxL0cE2BdW>
X-ME-Proxy-Cause: dmFkZTGUCFJKPkuyaHetYCQGL7XSAIw73MfN7gRe0J8jXuosYkk6bIjLisxZNWbf1nRjr9
    xZp2qe8TaGOVKjkNJqJMGEd/AcQAuhR6XiI8PyTzQ0JmGFKVF1OBdVN/b5RyRjjhFvl8kh
    h2TKuUDx/7t7p3DkmlxWPzzuU77xh810DMskM1BIe1X97ekDr+eeMgBW+dv0EbJq5VF4FU
    Wa+xTFQFQio6zdyH1HKLRS9a5SupnNWJl6D8rhMpigr0pPfKQIDc4TxX8B9HBF36G9vbL/
    bQpwadOIMZmyfZR6YAHhjdrCb0rCrWYWUGlYDFBpBuzjTrRZllZSthzXavcQZi7kBrZ8H9
    8afp0t41sixGVgoVfCaA+6oiAP5ly0g2jFj1VNJ+7/GGknRIXXxjOezJnyBslFPqpX3nsK
    tnakKUZKw2GH3Y9HXxY5VDhW8cxQIChnH71O0i0QsqdsS4xe+zneveWcMKPIQghRAZ9t9L
    taQ1076KfQkk5Pv2ba4Qq6qc/Wl8ifJg9cwXv9CswEFJXdqLeJ+uafICcrA1v6B+iv6DYi
    mFhVHLc2sHBh9/4yS4pZURwNjkRkjQ2goygUYKEci4nosrp1b4utsUf52ekiohguQcb3Y1
    fcMyYFEOq2gw/2/KrGlfviblju6w8RqRdwQ8YhYQyKfbYbh29mVG05UkfJdA
X-ME-Proxy: <xmx:WNKrap0geuIOiS9KMk7XweCraYOFb_rUFqHyWvjjb7vM9PR1pqXbQA>
    <xmx:WNKralGOLqQEt_D2Ic-wAurU49Or962CvLD31girPObdynwFEP6dRw>
    <xmx:WNKraqwlyEcwZHJVSOSZqbeLaiXwHiyaGbFyJH6qzMEFlOywSUGAgg>
    <xmx:WNKrasnVXhmdIlsUBhg_GYM4sI4Yn9o7wzI6XV_uilZKh4pnVqrb6w>
    <xmx:WNKrai1KwpXza7SN_7QijIqE_J1fjbOPBf01vLy8H5sN58K56uUsvuOo>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Sep 2026 07:43:19 -0400 (EDT)
Date: Thu, 17 Sep 2026 12:36:23 +0100
From: Greg KH <greg@kroah.com>
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 6.12.y 1/5] cifs: Scripted clean up
 fs/smb/client/cifs_unicode.h
Message-ID: <2026091711-fervor-scribing-aace@gregkh>
References: <2026090351-popper-penpal-d0a0@gregkh>
 <20260907114742.2872537-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907114742.2872537-1-sashal@kernel.org>

On Mon, Sep 07, 2026 at 07:47:38AM -0400, Sasha Levin wrote:
> From: David Howells <dhowells@redhat.com>
> 
> [ Upstream commit 696ca7d95658224ba807813101d0d5714d1d8aa4 ]
> 
> Remove externs, correct argument names and reformat declarations.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Steve French <sfrench@samba.org>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: Enzo Matsumiya <ematsumiya@suse.de>
> cc: linux-cifs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> cc: linux-kernel@vger.kernel.org
> Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Stable-dep-of: b8e5dc4f95e5 ("smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/smb/client/cifs_unicode.h | 17 +++++++++--------
>  fs/smb/client/inode.c        | 26 ++++++++++++++------------
>  2 files changed, 23 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/smb/client/cifs_unicode.h b/fs/smb/client/cifs_unicode.h
> index e137a0dfbbe9a..d69b64422fe98 100644
> --- a/fs/smb/client/cifs_unicode.h
> +++ b/fs/smb/client/cifs_unicode.h
> @@ -56,19 +56,20 @@
>  
>  #ifdef __KERNEL__
>  int cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
> -		    const struct nls_table *cp, int map_type);
> +		    const struct nls_table *codepage, int map_type);
>  int cifs_utf16_bytes(const __le16 *from, int maxbytes,
>  		     const struct nls_table *codepage);
> -int cifs_strtoUTF16(__le16 *, const char *, int, const struct nls_table *);
> +int cifs_strtoUTF16(__le16 *to, const char *from, int len,
> +		    const struct nls_table *codepage);
>  char *cifs_strndup_from_utf16(const char *src, const int maxlen,
>  			      const bool is_unicode,
>  			      const struct nls_table *codepage);
> -extern int cifsConvertToUTF16(__le16 *target, const char *source, int maxlen,
> -			      const struct nls_table *cp, int mapChars);
> -extern int cifs_remap(struct cifs_sb_info *cifs_sb);
> -extern __le16 *cifs_strndup_to_utf16(const char *src, const int maxlen,
> -				     int *utf16_len, const struct nls_table *cp,
> -				     int remap);
> +int cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
> +		       const struct nls_table *cp, int map_chars);
> +int cifs_remap(struct cifs_sb_info *cifs_sb);
> +__le16 *cifs_strndup_to_utf16(const char *src, const int maxlen,
> +			      int *utf16_len, const struct nls_table *cp,
> +			      int remap);
>  #endif
>  
>  wchar_t cifs_toupper(wchar_t in);
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index b67b316538b83..8c422b3c73662 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -3115,13 +3115,14 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
>  		rc = cifs_set_file_size(inode, attrs, xid, full_path, direntry);
>  		if (rc != 0)
>  			goto out;
> +		attrs->ia_valid &= ~(ATTR_CTIME | ATTR_MTIME);
>  	}
>  
>  	/* skip mode change if it's just for clearing setuid/setgid */
>  	if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
>  		attrs->ia_valid &= ~ATTR_MODE;
>  
> -	args = kmalloc(sizeof(*args), GFP_KERNEL);
> +	args = kmalloc_obj(*args);
>  	if (args == NULL) {
>  		rc = -ENOMEM;
>  		goto out;
> @@ -3217,6 +3218,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>  	struct inode *inode = d_inode(direntry);
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>  	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
> +	unsigned int sbflags = cifs_sb->mnt_cifs_flags;
>  	struct cifsFileInfo *wfile;
>  	struct cifs_tcon *tcon;
>  	const char *full_path;
> @@ -3231,7 +3233,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>  	cifs_dbg(FYI, "setattr on file %pd attrs->ia_valid 0x%x\n",
>  		 direntry, attrs->ia_valid);
>  
> -	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
> +	if (sbflags & CIFS_MOUNT_NO_PERM)
>  		attrs->ia_valid |= ATTR_FORCE;
>  
>  	rc = setattr_prepare(&nop_mnt_idmap, direntry, attrs);
> @@ -3265,7 +3267,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>  	rc = 0;
>  
>  	if ((attrs->ia_valid & ATTR_MTIME) &&
> -	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
> +	    !(sbflags & CIFS_MOUNT_NOSSYNC)) {
>  		rc = cifs_get_writable_file(cifsInode, FIND_WR_ANY, &wfile);
>  		if (!rc) {
>  			tcon = tlink_tcon(wfile->tlink);
> @@ -3291,8 +3293,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>  	if (attrs->ia_valid & ATTR_GID)
>  		gid = attrs->ia_gid;
>  
> -	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
> -	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID)) {
> +	if ((sbflags & CIFS_MOUNT_CIFS_ACL) ||
> +	    (sbflags & CIFS_MOUNT_MODE_FROM_SID)) {
>  		if (uid_valid(uid) || gid_valid(gid)) {
>  			mode = NO_CHANGE_64;
>  			rc = id_mode_to_cifs_acl(inode, full_path, &mode,
> @@ -3303,9 +3305,9 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>  				goto cifs_setattr_exit;
>  			}
>  		}
> -	} else
> -	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID))
> +	} else if (!(sbflags & CIFS_MOUNT_SET_UID)) {
>  		attrs->ia_valid &= ~(ATTR_UID | ATTR_GID);
> +	}
>  
>  	/* skip mode change if it's just for clearing setuid/setgid */
>  	if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
> @@ -3314,8 +3316,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>  	if (attrs->ia_valid & ATTR_MODE) {
>  		mode = attrs->ia_mode;
>  		rc = 0;
> -		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
> -		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) ||
> +		if ((sbflags & CIFS_MOUNT_CIFS_ACL) ||
> +		    (sbflags & CIFS_MOUNT_MODE_FROM_SID) ||
>  		    posix) {
>  			rc = id_mode_to_cifs_acl(inode, full_path, &mode,
>  						INVALID_UID, INVALID_GID);
> @@ -3338,7 +3340,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>  			dosattr = cifsInode->cifsAttrs | ATTR_READONLY;
>  
>  			/* fix up mode if we're not using dynperm */
> -			if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM) == 0)
> +			if ((sbflags & CIFS_MOUNT_DYNPERM) == 0)
>  				attrs->ia_mode = inode->i_mode & ~S_IWUGO;
>  		} else if ((mode & S_IWUGO) &&
>  			   (cifsInode->cifsAttrs & ATTR_READONLY)) {
> @@ -3349,7 +3351,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>  				dosattr |= ATTR_NORMAL;
>  
>  			/* reset local inode permissions to normal */
> -			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)) {
> +			if (!(sbflags & CIFS_MOUNT_DYNPERM)) {
>  				attrs->ia_mode &= ~(S_IALLUGO);
>  				if (S_ISDIR(inode->i_mode))
>  					attrs->ia_mode |=
> @@ -3358,7 +3360,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>  					attrs->ia_mode |=
>  						cifs_sb->ctx->file_mode;
>  			}
> -		} else if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)) {
> +		} else if (!(sbflags & CIFS_MOUNT_DYNPERM)) {
>  			/* ignore mode change - ATTR_READONLY hasn't changed */
>  			attrs->ia_valid &= ~ATTR_MODE;
>  		}
> -- 
> 2.53.0
> 
> 

The two cifs series backports conflicts, so I'll drop both :(
