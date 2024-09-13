Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220EE126F2A;
	Fri, 13 Sep 2024 20:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726257876; cv=none; b=Ukv1WnBCLpMZKYhCcvb4BCEKxROUFiAyogcS2HMmcY3CkCAShErUddQDpguMLEFOqvNwUcatu9dkrQM5R6pfhWFVbi46lziU3l6sVr1DEplKaWON5I33VwoxEv9869G53Feb5NdNmwX4RZucwJFQejEtfoW+W4t8mc3uSGwX9G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726257876; c=relaxed/simple;
	bh=dM3QGp5ZmtjL9C71+b5qzSHRkFpnfx9h2fJN6ECQJ6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I2X1swksgFB3WUfgPeYoC1+7LrVNArCpGvGhD5jrqfdjofNSQYx9z1SdWSfwsSwG/ZQh4sCmKn8jwJkEPVsH5lN4xekISFhjPX0Izp3qChDROZXV651YrV6huCb3pxvwx6d1zDqQ9bYR1EwF059J9vKIAuDGzKvAfy84IpPkhF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tOUoikfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tOUoikfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C725C4CEC0;
	Fri, 13 Sep 2024 20:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726257875;
	bh=dM3QGp5ZmtjL9C71+b5qzSHRkFpnfx9h2fJN6ECQJ6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tOUoikfm6k2VBxCA6Bo66C5Ro3C8Np068neUzbjBQdfaeAZxdRRE4nCUJCCv1dGIB
	 7TZj0SJZxCE2gmooHYk/MBbHdh8zjj0npChFcEIh4r/dVsr08MifaA5Hl1N51mhL7P
	 YxnUU4tOrqtIw8/fka7Y/1SjJk9nwN6mQ3fp4pldndMsT1M9Qx2vF/0vrwtPzSKYso
	 TIHMTTT673/F478SkJCrond0Zguh5r55vMDT0bDFNjvTnU/z9Bmt1xpZXmB7/okIBA
	 IwzXQkQZcVsm5Yh8rLyStqVzg94PJ0P+O4SBfr/3BWIYszhVL2S/9zd+j0wqroneFB
	 Gz8RLgCMCF1lQ==
Received: by pali.im (Postfix)
	id 7D9CB725; Fri, 13 Sep 2024 22:04:30 +0200 (CEST)
Date: Fri, 13 Sep 2024 22:04:30 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] cifs: Fix recognizing SFU symlinks
Message-ID: <20240913200430.zodog6t5uaall6yv@pali>
References: <20240912120548.15877-1-pali@kernel.org>
 <20240912120548.15877-2-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240912120548.15877-2-pali@kernel.org>
User-Agent: NeoMutt/20180716

On Thursday 12 September 2024 14:05:42 Pali Rohár wrote:
> SFU symlinks have 8 byte prefix: "IntxLNK\1".
> So check also the last 8th byte 0x01.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>

Fixes: 9e294f1c4d4a ("[CIFS] Recognize properly symlinks and char/blk devices (not just FIFOs) created by SFU (part 2 of 2).")

(I located commit which probably by mistake removed that byte 0x01).

> ---
>  fs/smb/client/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 73e2e6c230b7..7d424e769a56 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -612,7 +612,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
>  			cifs_dbg(FYI, "Socket\n");
>  			fattr->cf_mode |= S_IFSOCK;
>  			fattr->cf_dtype = DT_SOCK;
> -		} else if (memcmp("IntxLNK", pbuf, 7) == 0) {
> +		} else if (memcmp("IntxLNK\1", pbuf, 8) == 0) {
>  			cifs_dbg(FYI, "Symlink\n");
>  			fattr->cf_mode |= S_IFLNK;
>  			fattr->cf_dtype = DT_LNK;
> -- 
> 2.20.1
> 
