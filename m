Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A452580FE
	for <linux-cifs@vger.kernel.org>; Thu,  3 Jul 2025 19:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751572133; cv=none; b=Dm/+I6wyD3SPQJzXDAN0QynC+azSpyDc2+oagTuUPk+6VlhM7ekSwChhaFmkc+SBXI3Dtc9RjhtlSMhO3BMfuEKcjB55BFkNfCBzYh5wSwGF/VBJGol1Zu3s67/XINpvyrQujcnoYkdxPYaPPyTU2DCei6Q7gFR8cekJ7vKZP4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751572133; c=relaxed/simple;
	bh=A7twPmK5e6FXY0Qav+/4rxbZwv5nqY8qTPFB/NaOnHs=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=YywsUGNNU2evoJPlazLlFgSPWGIsM87MGXwGLmMMZq9J+QfG49bMc1XrYrl6Z7fbHy7nibLrV3GG/QaEN455LqpTXB7/BMaMmKNIjXaPqSmB8Qhe4pSZ6dy86jfQBZM2Qj5wnaG99MQc8+5PBgiSHC5/gADdWEZrc40oOHhTOaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=LEgAapXk; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="LEgAapXk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:Subject:Cc:To:From:
	Message-ID:Reply-To; bh=EiG2x90uLUchwmtQY9t3uvXtRSaU8ey3P/1rxlkuUGQ=; b=LEgAa
	pXk+oMYlqIJXjrvgMBLUMl8Rm4qOQqHqGamHqYqmm3yvO2yJhPTNHlCKo4FynqjyjfyA36XMV1l8e
	NE8VDIuF1xwm96odcmZXb9eV2RKcjc6SnIuFlBAFcPbcC1eDV4pJgE++UBsutByL5IzCqTjBVJM8B
	5tJRWAr4+eJsPFOwJM5kO98L43+H/4D7YvIQvX3D/uI0VVipe0/+fty1wnf4htjchGbOz+cR1WqMv
	PLJ16tBLJABGzpdsQCCslIiV36xnfh7IxznuI0ZgR76xgSnrVl2DfICdiktjh10LU6pzP/aPzN3ww
	7pHW/NYHYn6JhghgiSmzSoBuS8dOg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uXMI7-000000013Od-2YqZ;
	Thu, 03 Jul 2025 12:56:03 -0300
Message-ID: <9b6ca6d8c816260958a1238672994d8a@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Stefan Metzmacher <metze@samba.org>, smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org, Pierguido Lambri <plambri@redhat.com>, David
 Howells <dhowells@redhat.com>
Subject: Re: [PATCH] smb: client: fix native SMB symlink traversal
In-Reply-To: <d0117c2f-490f-4fc4-9bff-254e13b4a5cd@samba.org>
References: <20250702174001.911761-1-pc@manguebit.org>
 <d0117c2f-490f-4fc4-9bff-254e13b4a5cd@samba.org>
Date: Thu, 03 Jul 2025 12:56:02 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Stefan Metzmacher <metze@samba.org> writes:

> Am 02.07.25 um 19:40 schrieb Paulo Alcantara:
>> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
>> index a634a34d4086..d8d2d4a739e8 100644
>> --- a/fs/smb/client/fs_context.c
>> +++ b/fs/smb/client/fs_context.c
>> @@ -1825,9 +1825,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>>   			goto cifs_parse_mount_err;
>>   		}
>>   		kfree(ctx->symlinkroot);
>> -		ctx->symlinkroot = kstrdup(param->string, GFP_KERNEL);
>> -		if (!ctx->symlinkroot)
>> +		ctx->symlinkroot = kstrndup(param->string, PATH_MAX, GFP_KERNEL);
>
> Should we really truncate the string instead of generating an error?
> I really don't know, maybe it is a good thing, but we should have a comment
> that explains it why we truncate.

Good point.  We should bail out and then print an error in case the path
set in symlinkroot= is greater than PATH_MAX.  Will send v2 soon with
the fix, thanks.
