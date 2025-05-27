Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DA71FDE33
	for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 19:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748375970; cv=none; b=aXW4ya2xtqNlf+hz0dFYX9fOBk7mA/l50exqw1HFPDTQj1Fs4iaYmQobkmIpPgV56ac991uyWPmyTU4/VLtffmnyJ5FLMKJBsWwNnwfcEESb5H/Y1YmGC5J4IksZRMnCUzfRjXko6yCaJE0lvH23OkVP4KoMFaCvb6pSt1vVn68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748375970; c=relaxed/simple;
	bh=LYlGJT5oUE8HWbAJf+7Ddx9YZuoJaizslEebglOIqFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R8iHw5G4HgaZpErgAitBK7YlZf+f4wJkz+XH7yzVdVfIguTMA+oTzVbSHNaw0ixKcVv6EedONAEWBwhd0k5d+0Ez7hI0cFEXfTd4ZWSAfC8Ej8Pr09/OIsyy7SxFeD0spErGZAYpLRRm2qLq/C411uVR8n8NOM1QZcro/tJDiD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=TS2LKZrh; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="TS2LKZrh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=nGfY8tZRHN8kmr7rkbb4nmZDOtvAvf9s+b7sb4fOiuo=; b=TS2LKZrhpc7NHSz+/bqc+Ush4T
	/cxoc2CMWJAbIExvEoJTfI284Hnqxb/63qb7loBB4chC8SO72R2cZgocFOaoENYnPx1XxdQcaJHIi
	ishRtMemVkOhkCC3BxXj5id9FQc8082ud22EeAFoGXVVU1wxbmjKrE9tP9MwF6Chv5DtARY18WWnV
	UAX+6C3bSrAV4N5fiZVr0xdgJOP/4sBQOGzx6aSdtZOEs7zrdOp6Qq4UoljhoDMwTfy+BLzifcE43
	ywr+Ry6hpRZrnezOR1QMeEIAoDh16ACQ7KWfWd0dHFbFCST2226uC0fcTjfqb8+o4DpRjQ4PeOQbS
	OATijEKuAnJxDZLBtQZqx61SQtXskYwBzNlFQ6sJ4GA1SJdov/5xxFNo0Z65vzPVIKGuhOx7Mm8EC
	1UYVMSrbGHZQCvml39kY6lEYgx1J3LQ9C+50l7WSqgrXp61CH9Hjfm7SsQwaLZ1EYfc6KvO/IISDI
	wmgrTh2NbBZtatsum52vAOi/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uK0SL-007XSv-1U;
	Tue, 27 May 2025 19:59:25 +0000
Message-ID: <8afdbc0b-30f9-4e17-bd34-bc807ce3883f@samba.org>
Date: Tue, 27 May 2025 21:59:25 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] smb: common: split out smb_direct related header
 files
To: Tom Talpey <tom@talpey.com>
Cc: Steve French <smfrench@gmail.com>, Long Li <longli@microsoft.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
 samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
References: <cover.1748362221.git.metze@samba.org>
 <31f6e853d60ec99136f3855acb3447d36fa0fc82.1748362221.git.metze@samba.org>
 <ace9b692-3a0d-4a47-b74b-c350a72efdf1@talpey.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <ace9b692-3a0d-4a47-b74b-c350a72efdf1@talpey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.05.25 um 20:50 schrieb Tom Talpey:
> I love the idea. Couple of questions on the pathnames...
> 
> On 5/27/2025 12:12 PM, Stefan Metzmacher wrote:
>> This is just a start moving into a common smb_direct layer.
>>
>> Cc: Steve French <smfrench@gmail.com>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Long Li <longli@microsoft.com>
>> Cc: Namjae Jeon <linkinjeon@kernel.org>
>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> Cc: linux-cifs@vger.kernel.org
>> Cc: samba-technical@lists.samba.org
>> Signed-off-by: Stefan Metzmacher <metze@samba.org>
>> ---
>>   fs/smb/common/smb_direct/smb_direct.h     | 11 +++++
>>   fs/smb/common/smb_direct/smb_direct_pdu.h | 51 +++++++++++++++++++++++
> 
> Why the underscore in "smb_direct", in both components? The protocol
> doesn't use this, and it seems awkward and search-unfriendly.

Yes, I'd also prefer smbdirect and I just used it because I had
my existing wip driver under that name, but that should not matter.

The other reason was that the existing structures used smb_direct_
as prefix, but I'll also change that.

>>   fs/smb/server/transport_rdma.h            | 43 +------------------
>>   3 files changed, 64 insertions(+), 41 deletions(-)
>>   create mode 100644 fs/smb/common/smb_direct/smb_direct.h
>>   create mode 100644 fs/smb/common/smb_direct/smb_direct_pdu.h
>>
>> diff --git a/fs/smb/common/smb_direct/smb_direct.h b/fs/smb/common/smb_direct/smb_direct.h
>> new file mode 100644
>> index 000000000000..c745c37a3fea
>> --- /dev/null
>> +++ b/fs/smb/common/smb_direct/smb_direct.h
>> @@ -0,0 +1,11 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +/*
>> + *   Copyright (C) 2025, Stefan Metzmacher <metze@samba.org>
>> + */
>> +
>> +#ifndef __FS_SMB_COMMON_SMB_DIRECT_SMB_DIRECT_H__
>> +#define __FS_SMB_COMMON_SMB_DIRECT_SMB_DIRECT_H__
>> +
>> +#include "smb_direct_pdu.h"
> 
> And, why the empty redirection? It seems unnecessary, do I assume it
> will later contain API signatures for the planned common layer? Perhaps
> it should say this, to avoid confusion while that work is being done.

I'll think about it maybe I'll remove the redirection.

In the end the pdu definitions belong only in a single common .c files,
but it will take a lot of steps to get there.

I'll post a v2 tomorrow or next week.

Thanks!
metze

