Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E79B3C4B6A
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 15:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789484684; cv=none; b=L1SSPCcm359OlnGqC8zg4RVOGNisqVGKTLc2KRYnO08uEprLJsAoa6DY/2B6Ex8nE3gBSuT8mKSD12H75ODjNBu3/2amwOiNYQJEIlFEVD9caeCNlUaa8h1uGmwhEfdWjD4Mluvzh0rA0CHkkaQzEjhCYkXL5u6XM5dshaASJYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789484684; c=relaxed/simple;
	bh=jfBGv2+sWZ3M/SxwKSqXF+n7N5WmBZIFWKllH60W4is=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=QQ1FAastm8ZHNWei1LGrA73SIqOQsDpG3JPIbLkWYrrHw/wEws5771dYY53rIQ3F2/2lDqhx5FnscwMdglhgmTOsJ+QhA4tPh31gW3UvEBx0cgNLRYmCqGwzG6Li6HnrGGXG+zPCX6WLxi90W8r4Xag30x1EvHxuSD6PtXb7n8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=PTcZ14dQ; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="PTcZ14dQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gUzloH1XcT3qP/P4rni+cEmRgYkBSC7yWvj7b5nW2DY=; b=PTcZ14dQXbfplmnONC7rzKGwam
	j5RDukmV8isOGvu7IqD1wR7+1RAoOfr/4PJybNRGFL1HJUrrf+fKfgHfCyhuO3M8iixZTqU/TvlDg
	GeJ2j7R+tiUeax4+Lr+PjDlqg5fMCHHxa0dQ7n9niRwSXsp3orlOLpAC7M+7G1bKL4Msc/Kv8CwDT
	YxF7kykS2nr2bcdIaqALmX99mzCt5OQqqKoiBz9pxS/TDCW7wOuN+iGaT+yIsQUAyQ4zIklM9gNv3
	WgXwEt00d9BCuuVpAOdtHzingPgECRVgls2+QeJmB7EiX3lPuFz3Q8UXwcTX1giNo6sp8Km7qMIaU
	CQ1wOusQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x6Ui9-00000001V01-04Fq;
	Tue, 15 Sep 2026 12:04:41 -0300
Message-ID: <0b3d295a3f9ada22c99ac4e49b935106@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com
Subject: Re: [PATCH v4 02/10] smb: client: validate minimum PDU size before
 smb2_get_data_area_len()
In-Reply-To: <20260913214510.3071370-3-sorenson@redhat.com>
References: <20260913214510.3071370-1-sorenson@redhat.com>
 <20260913214510.3071370-3-sorenson@redhat.com>
Date: Tue, 15 Sep 2026 12:04:40 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> __smb2_calc_size() calls smb2_get_data_area_len(), which reads
> command-specific struct fields to locate the data area. However,
> smb2_check_message() only validates StructureSize2, meaning a truncated
> response could cause smb2_get_data_area_len() to read out-of-bounds.
>
> Add smb2_min_pdu_len[] to track the size of the fixed response struct for
> each command with a data area, and reject PDUs shorter than this minimum
> before they are parsed.
>
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
> ---
>  fs/smb/client/smb2misc.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
> index 9068175e57cd..22afc203a1ef 100644
> --- a/fs/smb/client/smb2misc.c
> +++ b/fs/smb/client/smb2misc.c
> @@ -85,6 +85,36 @@ static const __le16 smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
>  	/* SMB2_OPLOCK_BREAK */ cpu_to_le16(24)
>  };
>  
> +/*
> + * Minimum received PDU size for commands whose fixed response struct is read
> + * by smb2_get_data_area_len() before the packet length is validated.  Must
> + * be non-zero for every command where has_smb2_data_area[] is true; zero
> + * otherwise (guard in smb2_check_message() is skipped).  Keep in sync with
> + * has_smb2_data_area[] above: adding a data area for a currently-zero command
> + * requires a matching sizeof() entry here.
> + */
> +static const size_t smb2_min_pdu_len[NUMBER_OF_SMB2_COMMANDS] = {
> +	/* SMB2_NEGOTIATE */       sizeof(struct smb2_negotiate_rsp),
> +	/* SMB2_SESSION_SETUP */   sizeof(struct smb2_sess_setup_rsp),
> +	/* SMB2_LOGOFF */          0,
> +	/* SMB2_TREE_CONNECT */    0,
> +	/* SMB2_TREE_DISCONNECT */ 0,
> +	/* SMB2_CREATE */          sizeof(struct smb2_create_rsp),
> +	/* SMB2_CLOSE */           0,
> +	/* SMB2_FLUSH */           0,
> +	/* SMB2_READ */            sizeof(struct smb2_read_rsp),
> +	/* SMB2_WRITE */           0,
> +	/* SMB2_LOCK */            0,
> +	/* SMB2_IOCTL */           sizeof(struct smb2_ioctl_rsp),
> +	/* SMB2_CANCEL */          0,
> +	/* SMB2_ECHO */            0,
> +	/* SMB2_QUERY_DIRECTORY */ sizeof(struct smb2_query_directory_rsp),
> +	/* SMB2_CHANGE_NOTIFY */   sizeof(struct smb2_change_notify_rsp),
> +	/* SMB2_QUERY_INFO */      sizeof(struct smb2_query_info_rsp),
> +	/* SMB2_SET_INFO */        0,
> +	/* SMB2_OPLOCK_BREAK */    0,
> +};

I don't understand why you're creating a new array.

What about to replace @has_smb2_data_area with the above array, then
have something like

        #define smb2_has_data_area(cmd) (smb2_min_pdu_len[cmd] != 0)

and in __smb2_calc_size()

        if (!smb2_has_data_area(le16_to_cpu(shdr->Command)))
                ....

Then we don't need to worry about keeping both arrays in sync.

> +
>  #define SMB311_NEGPROT_BASE_SIZE (sizeof(struct smb2_hdr) + sizeof(struct smb2_negotiate_rsp))
>  
>  static __u32 get_neg_ctxt_len(struct smb2_hdr *hdr, __u32 len,
> @@ -233,6 +263,16 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
>  		}
>  	}
>  
> +	if ((shdr->Status == 0 ||

nit: shdr->Status == STATUS_SUCCESS

> +	     shdr->Status == STATUS_MORE_PROCESSING_REQUIRED ||
> +	     pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2_LE) &&
> +	    smb2_min_pdu_len[command] &&
> +	    len < smb2_min_pdu_len[command]) {
> +		cifs_dbg(VFS, "SMB2 command %d response too short: %u < %zu\n",
> +			 command, len, smb2_min_pdu_len[command]);
> +		return 1;
> +	}
> +
>  	have_data = false;
>  	data_area_overlap = false;
>  	calc_len = __smb2_calc_size(buf, &have_data, &data_area_overlap);
> -- 
> 2.55.0
