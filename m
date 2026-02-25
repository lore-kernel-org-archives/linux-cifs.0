Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33CA433B3
	for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 03:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771989268; cv=none; b=H/xmf5L25ODkxZEY2kaumOoUIM3Fers8lRtGKk8FguipAYVyJbr9/qJ+MCr0iCmQAuFLwoILH3gKeI3yHD0uXaYJStLg1GHLC6a3lzKoYGoHTlabkF1ulv+h4TpF2y2GNtR6hgis6iwXtDVYxOEWkfroNBlOXMJlPGk0jsiAkuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771989268; c=relaxed/simple;
	bh=xWPshT/5lnFPXJaF0vnZv7zHlCSgk4so5fSINwaQORA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hNv/TOIERKYBPamZ7MVxP7r4mRi1dX9xtd3j57LFAWiFerIcsw8bbhq2ZjngUSUCczNOrfayzOEQFl97K850KpUEMCFIZSy+4AVV6LlrYaCValWhuq64u+QfGhQHHB8Q8sdEU2catMsphrQq7p8BUITYLEn38Kqv+iqXxa4a/Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ArSYHdm6; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ArSYHdm6"
Message-ID: <b654ba09-e96a-4e8a-becb-6c30c38f325d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771989264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JahlQsIGmcVghUYJVyeruyLBQ/3AXZjNeHeXS7pVdDw=;
	b=ArSYHdm6LJCMVNbq7sK+nwrK1ETUPFNgyHwoZL+DWFxTKxYk+mPJfphzw61d0JT5utzjsD
	jtHNsOXtEaV/A9aicGp0Scrk48ZnIhu2ZGsQtHBXDbPCu7FR+0EJtVztoqv6+UUi+RMzV9
	f9l5Hr7f156//XHmtM7ovZFWT9cHKPM=
Date: Wed, 25 Feb 2026 11:14:18 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/5] smb: move duplicate definitions into common header
 file, part 2
To: Namjae Jeon <linkinjeon@kernel.org>, smfrench@gmail.com
Cc: chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
References: <20260216082018.156695-1-zhang.guodong@linux.dev>
 <CAKYAXd_MuUe9R4vnkmGEkWxG7endJFqGDiEprLcvgJDixakX2A@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ZhangGuoDong <zhang.guodong@linux.dev>
In-Reply-To: <CAKYAXd_MuUe9R4vnkmGEkWxG7endJFqGDiEprLcvgJDixakX2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

For patches 0005, struct `smb311_posix_qinfo` and `smb2_posix_info` 
cannot use flexible array member for SID buffers. So we can only move 
fixed (non-variable) part of the structures to the common header file.

We should extract and move the fixed (non-variable) part to the common 
header file, since it is defined three times which makes it hard to 
maintain.

Link: 
https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/fscc_posix_extensions.md#2311-fileposixinformation

struct smb311_posix_qinfo / smb2_posix_info {
   fixed (non-variable) part
   variable sized owner SID and group SID
   le32 filenamelength
   u8 filename[] // variable
};

On 2026/2/20 09:27, Namjae Jeon wrote:
> For patches 0004 and 0005, please move the complete definition to the
> common header instead of a partial split. So we should also use a
> flexible array member for this, and ensure that all related code is
> updated to handle the flexible array correctly.
> Thanks.
