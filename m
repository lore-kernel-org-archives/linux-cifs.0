Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A023AB280
	for <linux-cifs@vger.kernel.org>; Wed,  8 Apr 2026 09:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775638991; cv=none; b=SWSBoR/NpnfGO81J9oxiS7xWQl9jia1Ocpmilce/bYtg8Vtd5I3kYYiWzRa8Qbi2XbnKZjlmZTNKSBAbbSSInk14PdLJUuFAoWzJggOJU5NHErGeDDX74JAbRQ5vNGknFYxycpV+vqvVqxyDKotox9V6EVffgwy8Dqs2Gmlt97A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775638991; c=relaxed/simple;
	bh=g6JGZLF4kDQIjsoQc7aNXnux8kxHQHVFu1AogK0yg3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pbtpm7kwKqvJE8VaRzW5jdWLLZKDpATS3mmRwCi8T4OBbqU8hHOqZUq+C8FAeTl4fN8Gk+Djb2D6TGwScG7NGJl1rtOGaGSeugyOa0WjumP9sbauXFcXmW0q0+N9zajxCkmcw3eEVBzXhhwzvSyYJkHdzr4Vrl/0nBCkhfIiAzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=P9jtNP0T; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="P9jtNP0T"
Message-ID: <297d8d9b-adf7-42fd-a1c2-5b1f230032bc@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1775638978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3CxCd6+uKaKswFIJJljIljFxiZ3MHsg6eAmb6ukrn6I=;
	b=P9jtNP0T4q1jVjQDrO01BV3Z0HUwLeuHJV8TPN7k7cGcRatgTahODx39Ou3UYlfqsiyGoj
	xzysYB7k0y6o9QqTpBjslLhQUZY/xpLtQkRLQO08reclVeEirFwl/G+HmciOIMafOoCfon
	yRmXudYTW8u6kP7h4MIYLFCrHxC9TrnqMTiPI3xKTqeoVk9QAJU757aflYwcLx88w3qT4V
	9lFSs2nA2IbUnHXiUNvEnACCKSjlNt9pccpMTEYjXBuzlfdlFBS/SwPLqRfeVmBGRRCnbe
	A2g0dVpthGjDrTaayr/6sRvyslZhDNvftoaUuokYEsHZiJFAHl8yZMtGfYBaoQ==
Date: Wed, 8 Apr 2026 17:01:56 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] smb: client: fix OOB reads parsing symlink error
 response
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, samba-technical@lists.samba.org,
 stable <stable@kernel.org>
References: <2026040635-banking-unsoiled-3250@gregkh>
 <2026040636-icy-constable-9e17@gregkh>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <2026040636-icy-constable-9e17@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Sashiko reported the following out-of-bounds issue. I have checked and 
confirmed that this indeed causes an OOB access.

When create fails on symlink, `len` in `smb2_check_message()` may be 
smaller than `calc_len`. The function flow is as follows:

```
smb2_check_message()
   // ensure StructureSize2 is 9
   if (... pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2_LE ...) // 
false
   smb2_calc_size()
     len = le16_to_cpu(shdr->StructureSize) == 64
     len += le16_to_cpu(pdu->StructureSize2) == 64 + 9
     smb2_get_data_area_len
       if (shdr->StructureSize == 9) // true, return NULL
   calc_len == 64 + 9
   if (len != calc_len) { // true
   /* create failed on symlink */
   if (command == SMB2_CREATE_HE && shdr->Status == 
STATUS_STOPPED_ON_SYMLINK) // true
```



Should we add the following check? Or check it in symlink_data()?

```
-- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -241,7 +241,8 @@ smb2_check_message(char *buf, unsigned int pdu_len, 
unsigned int len,
         if (len != calc_len) {
                 /* create failed on symlink */
                 if (command == SMB2_CREATE_HE &&
-                   shdr->Status == STATUS_STOPPED_ON_SYMLINK)
+                   shdr->Status == STATUS_STOPPED_ON_SYMLINK &&
+                   len > calc_len)
                         return 0;
                 /* Windows 7 server returns 24 bytes more */
                 if (calc_len + 24 == len && command == 
SMB2_OPLOCK_BREAK_HE)

```

>> --- a/fs/smb/client/smb2file.c
>> +++ b/fs/smb/client/smb2file.c
>> @@ -27,10 +27,11 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
>>  {
>>  	struct smb2_err_rsp *err = iov->iov_base;
>>  	struct smb2_symlink_err_rsp *sym = ERR_PTR(-EINVAL);
>> +	u8 *end = (u8 *)err + iov->iov_len;
>>  	u32 len;
>>  
>>  	if (err->ErrorContextCount) {
> Since smb2_check_message() returns success without length validation for
> the symlink error response, is it possible for iov->iov_len to be smaller
> than sizeof(struct smb2_err_rsp)?
> If the buffer only contains the base SMB2 header (64 bytes), does accessing
> err->ErrorContextCount (at offset 66) or err->ByteCount later in this
> function cause an out-of-bounds read?

-- 
ChenXiaoSong <chenxiaosong@kylinos.cn>
Chinese Homepage: chenxiaosong.com
English Homepage: chenxiaosong.com/en

