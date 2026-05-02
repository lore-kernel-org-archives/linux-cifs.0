Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7602A1D7E41
	for <linux-cifs@vger.kernel.org>; Sat,  2 May 2026 08:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777711573; cv=none; b=dbTo+6E5PlPnl679snkXQUqZptQa3P12peIt5nSvp0B+Oqzt2gHOd9OA8ki4sCMTCV2uFv93t5HiHtCob0e1vsGEb3FAvwAOwZ4xc/oRXGWKiJun91JamCLpN4AD/63v8iqI+7f+crkYa/Maa/E2P4bI9CiA1wkzRlX/NeGGUGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777711573; c=relaxed/simple;
	bh=VcGOCDBEkVSjYcfteI505tq8HH/441f/kyhIPLa6uMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdnuj+UyU29Y6/wtkECMTIQmiaE9YBsNT5UP3rFgvC30RCc1Gb6yBtN4/sXh6QjXvZqKHObiTj9uMGcQR3k1ns5nfZpXR+0n6iDi48ayxYGDNmJNLO8/S5lRMtHybuqnKwKLbTKzaSxqTxYZcj/v36d9MHef/ZFJ8w4lWTBsHdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oz7nRUi2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oz7nRUi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F52C19425;
	Sat,  2 May 2026 08:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777711572;
	bh=VcGOCDBEkVSjYcfteI505tq8HH/441f/kyhIPLa6uMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oz7nRUi2CVtBk832dSNZIXL874x+SyjY1j3o97fzn12/qKE7dDymbixD4OfF0fdlD
	 UReJZn36OzcHrbKzuwJYTS5ALMOpt10CfcC6Pd29oyRTrFF9M2pwHZpCFg7PU0OS8D
	 2x1BilFF7JfrMGSambapMc0FbSKFq3JutMYsd2ho=
Date: Sat, 2 May 2026 10:45:32 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Zisen Ye <zisenye@stu.xidian.edu.cn>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, senozhatsky@chromium.org,
	dhowells@redhat.com, chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH 1/2] smb/client: fix out-of-bounds read in
 smb2_compound_op()
Message-ID: <2026050208-selection-blog-ff4e@gregkh>
References: <20260502083422.2955909-1-zisenye@stu.xidian.edu.cn>
 <20260502083422.2955909-2-zisenye@stu.xidian.edu.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260502083422.2955909-2-zisenye@stu.xidian.edu.cn>

On Sat, May 02, 2026 at 04:34:21PM +0800, Zisen Ye wrote:
> If a server sends a truncated response but a large OutputBufferLength, and
> terminates the EA list early, check_wsl_eas() returns success without
> validating that the entire OutputBufferLength fits within iov_len.
> 
> Then smb2_compound_op() does:
>     memcpy(idata->wsl.eas, data[0], size[0]);
> 
> Where size[0] is OutputBufferLength. If iov_len is smaller than size[0],
> memcpy can read beyond the end of the rsp_iov allocation and leak adjacent
> kernel heap memory.
> 
> Link: https://lore.kernel.org/linux-cifs/d998240c-aca9-420d-9dbd-f5ba24af19e0@chenxiaosong.com/
> Signed-off-by: Zisen Ye <zisenye@stu.xidian.edu.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2inode.c | 3 +++
>  1 file changed, 3 insertions(+)

No Fixes: tag?  No cc: stable?  Do you not want this backported
anywhere?

thanks,

greg k-h
