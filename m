Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FBD382F25;
	Mon,  3 Aug 2026 10:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785753904; cv=none; b=QdlQPAzDjLPCJ617Gq9VsDzFiq8PGZFxiPFnQt3pa2/jVlupMTtKIy33EktbQc0U2GTcOp76aSGLkeLudd9OW60Lcs0MGgwXlXazrr/4FV48WudgNE5VSL024UrUiCKFAIjTZDhvfmvjEwsA7aaYolk2Rnc+RjFDWXtY8SUBLGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785753904; c=relaxed/simple;
	bh=R+isUq/ChITETwBkYkktWIQFkdRskG4ab1AJkhL4R3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GocnamQyT1wDEKP6wU3Ryg/kQznPK6YWdF2qwD1dvc6pJcWMpLURlChBQWf9Qv3Z/gGVdw9dNxnX8fK0uXOccJ16++mDAlhbcB7os1fUHLikt+clwsynPXMU1RGBlCDZqHKtm0jgIV5/4I5Bv8XNFjLy/B+mFDjOOroMDMumpjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RJZ8LVTt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RJZ8LVTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A60D1F000E9;
	Mon,  3 Aug 2026 10:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785753902;
	bh=avpMCXgQNdvDH5jPbA0WmKyYm0STVNXvxsfPTSbscYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RJZ8LVTthwyQhKpKDqNfIT/TYBDngS3C6i+IaRlcFlOxlsla1n1RN6lc4p3/veSQ2
	 n+JpD0ZKlcw7LwULXGd04YgpniX5QMHot3RKVzhSz4qJeUuH/2yiEyQOzHpIinRiUo
	 gxDUZgVRSzT8INmxyu/OdyP9qKrFk/D8X7YEWzJzzh7VC+krqGYw5B7Nr0vNrgfsDD
	 cOZhXrfMRC0hj0iu4Du43cfgS/aa+ySxLWElWuP7+r0A2i6zxX1apO+4FdKV2gXELz
	 HFbBoTUIE3taSRtTTB2rbBNwovo/RiYftAia4GrG2I5owAez5qeeU3dlqSzVm/jnMG
	 wV25o+ntU6R/A==
Date: Mon, 3 Aug 2026 18:44:52 +0800
From: Zorro Lang <zlang@kernel.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, hch@infradead.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	Christoph Hellwig <hch@lst.de>, fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] generic/002: add test to hardlink group
Message-ID: <anBwHPuds0VQjHuu@zlang-mailbox>
Mail-Followup-To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, hch@infradead.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	Christoph Hellwig <hch@lst.de>, fstests <fstests@vger.kernel.org>
References: <20260730021238.51634-1-chenxiaosong@chenxiaosong.com>
 <20260730021238.51634-2-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260730021238.51634-2-chenxiaosong@chenxiaosong.com>

On Thu, Jul 30, 2026 at 02:12:37AM +0000, ChenXiaoSong wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> The test creates and removes hard links, so add it to the hardlink
> group.
> 
> Suggested-by: Zorro Lang <zlang@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---

So you‘ve given up on re-writing this old case :)
Anyway, this's good to me.

Reviewed-by: Zorro Lang <zlang@kernel.org>

(Please CC fstests list)

>  tests/generic/002 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/002 b/tests/generic/002
> index 6df57a7a..a0773e22 100755
> --- a/tests/generic/002
> +++ b/tests/generic/002
> @@ -7,7 +7,7 @@
>  # simple inode link count test for a regular file
>  #
>  . ./common/preamble
> -_begin_fstest metadata udf auto quick
> +_begin_fstest metadata udf auto quick hardlink
>  
>  # Import common functions.
>  . ./common/filter
> -- 
> 2.43.0
> 
