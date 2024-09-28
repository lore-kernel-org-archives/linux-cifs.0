Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECDC14D2B1;
	Sat, 28 Sep 2024 14:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727532586; cv=none; b=JzKCuBsRX7FLhWWQJSPrfT4VoXoXPtLnRqk0IQCC5TxPEKW+jxHhLwZgDWNi51HaDhweAlcv9X3EmmFjO5fRYOhRCyf/7d5RiaxLorquBLeLXIhZezP6+sidwmYqRCNAf4kclEMapW0tWGYwJMD2TQSwg6pqAFFFtwuLDbWuGAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727532586; c=relaxed/simple;
	bh=1luKZKEWrG2jEgVQPr+YTZLx0wLmzpmGZm3Ka7VtNck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IWzwGOruB4ojc5Rigwn3NnWUZulcNIjFA2+RmX4+wJtnaNuB+Rkje+71CZD0zvyYozrA9IfPZ3JeJJUNMmB1VQXlMXU7b08N9+epcm0nZ7lUvDSVwfnhxKudaVsTjGGC5oZU9i+kXzHhJCD1UY0A3cChWr8ssnJ28GPB0mrcGtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cb8UROYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cb8UROYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4C3C4CEC3;
	Sat, 28 Sep 2024 14:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727532585;
	bh=1luKZKEWrG2jEgVQPr+YTZLx0wLmzpmGZm3Ka7VtNck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cb8UROYDteO6JNhdST0n8MwOt+kdMNQxIY1KW5JPiwG5Nl5Mk2vrwnynMD+TJ55Vt
	 GQSjGHfHZnyBBomL3gDPJDHFxOfQRvRjyb8V56awvg0QAY9l0JJuS2WiRbd42kdGfU
	 9SIRUySsEXu1FeGlSm87QQ05rM0Sz8oDLBFH23vOQlbtnxUKjAvMBHROUs/vZ5ZZ2L
	 N+8BL0hcCy5D+BvL5YSE3Pr5ROCpJvJ7ifv+O4Kq1yJGrCrV3iQKc2+kgUgGzOQSUg
	 8bTPFzb+LPfJaiRmSgx381BtgPgSGXtKyP86hhNVYf6908thEPGKfzgMPxtkN6YFRl
	 UozaMj6h12iIw==
Received: by pali.im (Postfix)
	id A1F0E651; Sat, 28 Sep 2024 16:09:39 +0200 (CEST)
Date: Sat, 28 Sep 2024 16:09:39 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL
 support
Message-ID: <20240928140939.vjndryndfngzq7x4@pali>
References: <20240913200204.10660-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240913200204.10660-1-pali@kernel.org>
User-Agent: NeoMutt/20180716

On Friday 13 September 2024 22:02:04 Pali Rohár wrote:
> If SMB server does not support WSL EAs then for SMB2_OP_QUERY_WSL_EA
> request it returns STATUS_EAS_NOT_SUPPORTED. Function smb2_compound_op()
> translates STATUS_EAS_NOT_SUPPORTED to -EOPNOTSUPP which cause failure
> during calling lstat() syscall from userspace on any reparse point,
> including Native SMB symlink (which does not use any EAs). This issue
> happen for example when trying to resolve Native NTFS symlink from SMB
> server on Windows 8.

Just for completeness, why this happens also on Windows server with NTFS
which supports both EAs and Reparse Points.

Older versions of Windows do not allow to set _both_ EAs and Reparse
point at the same time for one file. This is documented limitation of
NTFS. It looks like that this limitation was fixed in later Windows
versions where is running WSL.

So QUERY EA request for file which has already set reparse point ends
with STATUS_EAS_NOT_SUPPORTED error, even server supports EAs.

And similarly, FSCTL_SET_REPARSE_POINT call fails with error
STATUS_EAS_NOT_SUPPORTED when EAs are already set on the file. It is
rather cripple error for FSCTL_SET_REPARSE_POINT, but it is documented:
https://learn.microsoft.com/en-us/windows-hardware/drivers/ifs/fsctl-set-reparse-point

So Linux SMB client code should be extended to expect that compound
operation with: CREATE_with_EAs, FSCTL_SET_REPARSE_POINT, CLOSE will
fail on the FSCTL_SET_REPARSE_POINT with STATUS_EAS_NOT_SUPPORTED (even
EAs are correctly set by CREATE). And that QUERY_EA will fail on
STATUS_EAS_NOT_SUPPORTED even when EAs are supported by server.
