Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917F034D4E9;
	Fri, 21 Aug 2026 21:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787348843; cv=none; b=NZ/f0BIgV+1EQa555TVKDKXQ/7XPXGaqHDO5yjU4P8gHS+TfcnQyJW73SLGurfaztNAINHu9UA6bvdL5s1dTv/ZAzBQCv5ZW1ijRCIAUVEe4S6LLl+iWsNS22+uEtGQ/KhLBs/v4TVXq6Fg8RuHUNsg6Ndyado2Kv0QB0tw1cZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787348843; c=relaxed/simple;
	bh=x9aPl9YDSo7Yvc4pjUNtyLOdInVIBi3+ct4MiP+vNls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pYsIlVygcFPEzo+0wTzZ12p0ervzw8OSwlU0R0gF7tlJOc1MIlhZPvhgsnaJzZayWSLeHlMtRnI3+Xjb5a0RN1HsdS37lGX0DFGsxoUXki1UuHtUoTEAaOPRMmUBP5Vn8Q73smknO+3Dix1SfMi18MU85xmeF+5xU+s4veKR6w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hw7H504d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hw7H504d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5204F1F000E9;
	Fri, 21 Aug 2026 21:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787348842;
	bh=Q0Q/ihOu0bMqScjHnSQHzQvGpzIPhKp+vVHF4x+OGac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hw7H504dgTrDpEs9GxMRo6FVWMcu5T44hm3SKclP9b6SecnsNDYqIdtJsfSB8ByqE
	 Bx58Xl6OLKeVZ+453CaqsssYAqjD3CN+FgiQ5I8xJyfK8lLelB3ezfPPIaWiYDvzxR
	 fMXeL1z9PKeokn0KGbSAr5dNVyHsasx6bdgIUMj6ikt79jLMACNIeiGbCEOK0VlXlQ
	 foY23Ywu21kdvqWfkwIuVvBq50h/86+Vwm6SXAh1KaGM74uub01DCOJG03OWspJk/b
	 EN49C4rxL5u1AAoOQ6qVontk9WaUBVXywa7qzT6fE8tDX3CuP5ANVOjPtJNyoiWqRf
	 EJefcq8sqVEhQ==
Received: by pali.im (Postfix)
	id 26CD189E; Fri, 21 Aug 2026 23:47:22 +0200 (CEST)
Date: Fri, 21 Aug 2026 23:47:22 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 00/11] cifs: Various changes
Message-ID: <20260821214722.q7rkflclyyugdxll@pali>
References: <20260706184819.22124-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260706184819.22124-1-pali@kernel.org>
User-Agent: NeoMutt/20180716

Hello, could you look at other of changes in these series?
Steve already merged few of them and others I have rebased (cleanly) on
top of v7.2 release and pushed to my cifs branch:
https://git.kernel.org/pub/scm/linux/kernel/git/pali/linux.git/log/?h=cifs

On Monday 06 July 2026 20:48:08 Pali Rohár wrote:
> This patch series contains various cifs changes which I sent year ago.
> All those patches are rebased on top of the 7.2-rc2 and there is no new
> change in them, just they are rebased for new code base.
> 
> I pushed these changes also into my git branch cifs:
> https://git.kernel.org/pub/scm/linux/kernel/git/pali/linux.git/log/?h=cifs
> 
> 
> Note that patch "cifs: Remove cifs_backup_query_path_info() and replace
> it by cifs_query_path_info()" is removing these lines:
> 
> -			move_cifs_info_to_smb2(&data->fi, fi);
> -			fdi = (FILE_DIRECTORY_INFO *)fi;
> -			si = (FILE_ID_FULL_DIR_INFO *)fi;
> 
> And I have feeling that in this old code (which is being) removed could
> be a buffer overflow as it is casting between incompatible structures.
> I have not spent too much time with it as the code is begin removed.
> But maybe some AI tool could be able to confirm if this is some buffer
> overflow or not.
> 
> 
> Pali Rohár (11):
>   cifs: Fix and improve cifs_is_path_accessible() function
>   cifs: Remove code for querying FILE_INFO_STANDARD via
>     CIFSSMBQPathInfo()
>   cifs: Remove CIFSSMBSetPathInfoFB() fallback function
>   cifs: Remove cifs_backup_query_path_info() and replace it by
>     cifs_query_path_info()
>   cifs: Fix validation of EAs for WSL reparse points
>   cifs: Validate presence of EA $LXMOD for WSL reparse points
>   cifs: Check if server supports EAs before trying to set it for WSL
>   cifs: Extend ->set_EA() callback to allow operate on reparse point
>   cifs: Create native Window socket file compatible also with WSL
>     subsystem
>   cifs: Add support for parsing WSL symlinks in version 1 format
>   cifs: Add support for creating WSL symlinks in version 1 format
> 
>  fs/smb/client/cifsglob.h   |  10 +-
>  fs/smb/client/cifsproto.h  |   1 +
>  fs/smb/client/cifssmb.c    |  79 +++--------
>  fs/smb/client/fs_context.c |  11 +-
>  fs/smb/client/fs_context.h |   3 +-
>  fs/smb/client/inode.c      |  98 +-------------
>  fs/smb/client/link.c       |   3 +-
>  fs/smb/client/reparse.c    | 267 ++++++++++++++++++++++++++++++++-----
>  fs/smb/client/smb1ops.c    |  35 +++--
>  fs/smb/client/smb1proto.h  |   4 +-
>  fs/smb/client/smb2ops.c    |   6 +-
>  fs/smb/client/xattr.c      |   3 +-
>  fs/smb/common/fscc.h       |   5 +-
>  13 files changed, 306 insertions(+), 219 deletions(-)
> 
> -- 
> 2.20.1
> 
