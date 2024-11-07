Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83636218335;
	Thu,  7 Nov 2024 21:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013514; cv=none; b=Gv3GL4omTOFCSi3yhvyhEToumJBD1BK3B68qfOyuAOfOAZua1RiRnD1vbAasc6Gsxsm+8dlg60VSfX785S6d1rglVqSfUe8S0rWOXkFLiWeYNHvAmBdzqjmPazPo1Lvz6Psu9xJszImj7DX0Wh1vXEAVb3gXCqzfeW2NE27B4mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013514; c=relaxed/simple;
	bh=kj0DUPMYW2MkLAXHZIxssHCEzzzJuey3RIycZwaUHbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T0QqfNnaBvhAwuU09pZg47hMHXzoU6NTNx7mUJzBhZGZp14f+0/3ZFFyEdaUObSsTBt2ki0roUjc2tuSV9FjeOX3eQpVNgsBUa2CUbLDz8LEj3dDqPT5kRWMzaMof7xAufKtuGZALDxTilkroU+TGaUVF66uK23TN10jreFrr+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=H6YGGAU3; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="H6YGGAU3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=H5HDAbBQ5g60S5FukD3N5qJpZ+YuoumqSFdStqHeqUQ=; b=H6YGGAU3to2XVeuC
	4RRnpZKKgsG5Evaikol5RGv5YXG4KFxTEQ+ATNGeeLlLQEM7+b6O0y2RNlrdoRfDkzIZDrdT8oWj0
	ffsWx+GtfrxrAjb4oUcm+no5T+q4xTAR+yCfUPGL7AOplTVW3DaxfupAC3QfVRMDL+N1tge3a0D6+
	YrkqVaRqL+DEQt9kR4rA5LOPe5xONk2GLccnQFn9tnwdar3o8kwSBUMvQJNIrLhVGfmLZgVnHoqH3
	5a2GOKkMvTbGNVOBZcIjv2zjPOsjHWoPPchspe/vw7r5k9YM8ew7rmTeO12n5YPo2+870YI4qy7qn
	hpaf0VuDhnR98OmtgQ==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1t99gW-00G7tn-0C;
	Thu, 07 Nov 2024 21:04:56 +0000
Date: Thu, 7 Nov 2024 21:04:56 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com,
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Remove pre-historic unused CIFSSMBCopy
Message-ID: <Zy0reBfykkwXA47d@gallifrey>
References: <20241007210214.102568-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20241007210214.102568-1-linux@treblig.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 21:04:39 up 183 days,  8:18,  1 user,  load average: 0.14, 0.07,
 0.01
User-Agent: Mutt/2.2.12 (2023-09-09)

* linux@treblig.org (linux@treblig.org) wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> CIFSSMBCopy() is unused, remove it.
> 
> It seems to have been that way pre-git; looking in a historic
> archive, I think it landed around May 2004 in Linus'
> BKrev: 40ab7591J_OgkpHW-qhzZukvAUAw9g
> and was unused back then.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Ping?

Dave

> ---
>  fs/smb/client/cifsproto.h |  7 -----
>  fs/smb/client/cifssmb.c   | 63 ---------------------------------------
>  2 files changed, 70 deletions(-)
> 
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 1d3470bca45e..8235b5a0aa2b 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -549,13 +549,6 @@ extern int generate_smb311signingkey(struct cifs_ses *ses,
>  				     struct TCP_Server_Info *server);
>  
>  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
> -extern int CIFSSMBCopy(unsigned int xid,
> -			struct cifs_tcon *source_tcon,
> -			const char *fromName,
> -			const __u16 target_tid,
> -			const char *toName, const int flags,
> -			const struct nls_table *nls_codepage,
> -			int remap_special_chars);
>  extern ssize_t CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
>  			const unsigned char *searchName,
>  			const unsigned char *ea_name, char *EAData,
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index c6f15dbe860a..ca50ac652e02 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -2339,69 +2339,6 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
>  	return rc;
>  }
>  
> -int
> -CIFSSMBCopy(const unsigned int xid, struct cifs_tcon *tcon,
> -	    const char *fromName, const __u16 target_tid, const char *toName,
> -	    const int flags, const struct nls_table *nls_codepage, int remap)
> -{
> -	int rc = 0;
> -	COPY_REQ *pSMB = NULL;
> -	COPY_RSP *pSMBr = NULL;
> -	int bytes_returned;
> -	int name_len, name_len2;
> -	__u16 count;
> -
> -	cifs_dbg(FYI, "In CIFSSMBCopy\n");
> -copyRetry:
> -	rc = smb_init(SMB_COM_COPY, 1, tcon, (void **) &pSMB,
> -			(void **) &pSMBr);
> -	if (rc)
> -		return rc;
> -
> -	pSMB->BufferFormat = 0x04;
> -	pSMB->Tid2 = target_tid;
> -
> -	pSMB->Flags = cpu_to_le16(flags & COPY_TREE);
> -
> -	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
> -		name_len = cifsConvertToUTF16((__le16 *) pSMB->OldFileName,
> -					      fromName, PATH_MAX, nls_codepage,
> -					      remap);
> -		name_len++;     /* trailing null */
> -		name_len *= 2;
> -		pSMB->OldFileName[name_len] = 0x04;     /* pad */
> -		/* protocol requires ASCII signature byte on Unicode string */
> -		pSMB->OldFileName[name_len + 1] = 0x00;
> -		name_len2 =
> -		    cifsConvertToUTF16((__le16 *)&pSMB->OldFileName[name_len+2],
> -				       toName, PATH_MAX, nls_codepage, remap);
> -		name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
> -		name_len2 *= 2; /* convert to bytes */
> -	} else {
> -		name_len = copy_path_name(pSMB->OldFileName, fromName);
> -		pSMB->OldFileName[name_len] = 0x04;  /* 2nd buffer format */
> -		name_len2 = copy_path_name(pSMB->OldFileName+name_len+1, toName);
> -		name_len2++;    /* signature byte */
> -	}
> -
> -	count = 1 /* 1st signature byte */  + name_len + name_len2;
> -	inc_rfc1001_len(pSMB, count);
> -	pSMB->ByteCount = cpu_to_le16(count);
> -
> -	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
> -	if (rc) {
> -		cifs_dbg(FYI, "Send error in copy = %d with %d files copied\n",
> -			 rc, le16_to_cpu(pSMBr->CopyCount));
> -	}
> -	cifs_buf_release(pSMB);
> -
> -	if (rc == -EAGAIN)
> -		goto copyRetry;
> -
> -	return rc;
> -}
> -
>  int
>  CIFSUnixCreateSymLink(const unsigned int xid, struct cifs_tcon *tcon,
>  		      const char *fromName, const char *toName,
> -- 
> 2.46.2
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
