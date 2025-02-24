Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF202561D8;
	Mon, 24 Feb 2025 17:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740419586; cv=none; b=gm2PQ565MJiRhLKnImpdp3NlODDdMd1jmCX/KAqHCH1FyECGjw/8HhSR2tfJp7u3Xs/zOZkkG/joq4mRlvzU4eJYSJ0T2XWi5F1jyk0emqhf053A8oqGzAGCoPpthlYykStW6SNpg/0UleRdnPsQgsdvZr31S6CqdHhIlcjIw8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740419586; c=relaxed/simple;
	bh=SypH5F3wVUceAM6oLW8fAUMy59LCnOZGidtaq3tQLeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z2XF9brjLi8WOFtm8pFqL078lK3GbDnDD9ytjImFDJfxUgmWfSeBR2cjUaxZ4pCg9Z1JUNS0fETLQAwPPLEBvwBrDzlN6KXgSZ+Vrf++C8mv28RDH/oDsPz+UzwIBjfXcQ1hE4c90wz9jytBH15fHoYq5GIFghNbc5wIEFYlqLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwRTQcwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwRTQcwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61420C4CED6;
	Mon, 24 Feb 2025 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740419585;
	bh=SypH5F3wVUceAM6oLW8fAUMy59LCnOZGidtaq3tQLeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jwRTQcwG+0nHe4lgQJuX++cQT1hb8CZqL/QPGJswLS/RDlTZD/YWNkCRrHFfAjbFh
	 wHsI5bhiR7K3lo599/s6gg6AE543iW8CsPmKB1XUruJI6pKQFJR0CC61pyABH8wa+E
	 feQi416dNe4avOlhKiLwheqDm2mllJRhizmLrRBtd8RMsqS4UF7ezd3KS4jBg8FSh8
	 mXdbldMAbPDe6aORojwRfjrXCtuFCIDYEU2fHXGHzK59nF4sHUv17lC582Z1B8nlz/
	 iqV56XQwVOs+wobZvmW6lxvcGLDq8A63MZSaC5L5IDZZ5N96syNlmCfK0BwLCcgwg0
	 SIsrVpmciCs2Q==
Received: by pali.im (Postfix)
	id 486F88A5; Mon, 24 Feb 2025 18:52:52 +0100 (CET)
Date: Mon, 24 Feb 2025 18:52:52 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Steve French <stfrench@microsoft.com>, sfrench@samba.org,
	linkinjeon@kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: Re: [PATCH AUTOSEL 6.12 25/28] cifs: Treat unhandled directory name
 surrogate reparse points as mount directory nodes
Message-ID: <20250224175252.xuwl32zstd7ucaro@pali>
References: <20250224111759.2213772-1-sashal@kernel.org>
 <20250224111759.2213772-25-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250224111759.2213772-25-sashal@kernel.org>
User-Agent: NeoMutt/20180716

This patch depends on cad3fc0a4c8cef07b07ceddc137f582267577250 ("cifs:
Throw -EOPNOTSUPP error on unsupported reparse point type from
parse_reparse_point()". Please ensure that this dependency is included.

On Monday 24 February 2025 06:17:56 Sasha Levin wrote:
> From: Pali Rohár <pali@kernel.org>
> 
> [ Upstream commit b587fd128660d48cd2122f870f720ff8e2b4abb3 ]
> 
> If the reparse point was not handled (indicated by the -EOPNOTSUPP from
> ops->parse_reparse_point() call) but reparse tag is of type name surrogate
> directory type, then treat is as a new mount point.
> 
> Name surrogate reparse point represents another named entity in the system.
> 
> From SMB client point of view, this another entity is resolved on the SMB
> server, and server serves its content automatically. Therefore from Linux
> client point of view, this name surrogate reparse point of directory type
> crosses mount point.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/smb/client/inode.c    | 13 +++++++++++++
>  fs/smb/common/smbfsctl.h |  3 +++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index fafc07e38663c..295afb73fcdd6 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -1193,6 +1193,19 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
>  			rc = server->ops->parse_reparse_point(cifs_sb,
>  							      full_path,
>  							      iov, data);
> +			/*
> +			 * If the reparse point was not handled but it is the
> +			 * name surrogate which points to directory, then treat
> +			 * is as a new mount point. Name surrogate reparse point
> +			 * represents another named entity in the system.
> +			 */
> +			if (rc == -EOPNOTSUPP &&
> +			    IS_REPARSE_TAG_NAME_SURROGATE(data->reparse.tag) &&
> +			    (le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY)) {
> +				rc = 0;
> +				cifs_create_junction_fattr(fattr, sb);
> +				goto out;
> +			}
>  		}
>  		break;
>  	}
> diff --git a/fs/smb/common/smbfsctl.h b/fs/smb/common/smbfsctl.h
> index 4b379e84c46b9..3253a18ecb5cb 100644
> --- a/fs/smb/common/smbfsctl.h
> +++ b/fs/smb/common/smbfsctl.h
> @@ -159,6 +159,9 @@
>  #define IO_REPARSE_TAG_LX_CHR	     0x80000025
>  #define IO_REPARSE_TAG_LX_BLK	     0x80000026
>  
> +/* If Name Surrogate Bit is set, the file or directory represents another named entity in the system. */
> +#define IS_REPARSE_TAG_NAME_SURROGATE(tag) (!!((tag) & 0x20000000))
> +
>  /* fsctl flags */
>  /* If Flags is set to this value, the request is an FSCTL not ioctl request */
>  #define SMB2_0_IOCTL_IS_FSCTL		0x00000001
> -- 
> 2.39.5
> 
