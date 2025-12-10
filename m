Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE941280035
	for <linux-cifs@vger.kernel.org>; Wed, 10 Dec 2025 23:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765410030; cv=none; b=iyPVDEcX+B3bpUrFmcUeVQJQJY+vF4SVDwCt1P7hMTXu4TBK6Y0R32hUwI0F1rco5eJTUhVNnnQrRJVCsB13oLyEiE+87ZQp6840SZXCxnwDSWmEYwLmi5z/fqzD0qCttCPJtljJDeTHnvj96gmG47PkATDN4OhJvcAcJkIdfqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765410030; c=relaxed/simple;
	bh=jsS5w6G0YS8GSJu/2HY189UuzxbeZVX9Itm4F9Z5/+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nEhWiA/AocpCgzv9qVl6IZ4r9DowwIE+9aBMc2kTUPDRFeuPkcuHY71567YVgjpHyX7wcf67S9VgzSqVQXCumc5Up/xdn2574ZXhkAfecj/zi4CU5mD0382ebvUoaaHVJH3jS0S3tFyn+MUyF3qtJVwENArba39bWP/s9Ijxr0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A54/CcwO; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A54/CcwO"
Message-ID: <693d276d-6e0e-4457-9ace-ac1291fe2df5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765410024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7vlWBtW/JdhHOVgkxcu1wSasXoBDJ7oecN9WZ1bfoQM=;
	b=A54/CcwOiuInwEyVDqqoFKo9GFaTX3cegc2TYA/1H8stGwVRpNPtz4Ex7B5JPzmR9Yxn/0
	zk1LtIkne50dYq3rR/os4hLbnGihQQXUcIKaj13g3MJ0wJ87t/3PfvpbPwjRVIrnLyopzm
	wryKbbhPmR9UvMtxZSDdBTfMQAIS4Ms=
Date: Thu, 11 Dec 2025 07:40:00 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Can we autogenerate smb2_error_map_table[]?
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, liuzhengyuan@kylinos.cn,
 huhai@kylinos.cn, liuyun01@kylinos.cn, Paulo Alcantara <pc@manguebit.org>,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <650896.1765407799@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <650896.1765407799@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Sounds good, it could reduce a lot of code. What do others think?

Thanks,
ChenXiaoSong.

On 12/11/25 7:03 AM, David Howells wrote:
> Hi Chenxiaosong,
> 
> Can I suggest that rather than doing your "[PATCH v4 05/10] smb/client: sort
> smb2_error_map_table array", we autogenerate the table from the header file,
> putting all the info there?
> 
> One problem that we have is that we have multiple copies of the error table -
> and keeping them up to date and strictly ordered is problematic (hence your
> kunit test).  Further, each error number is mapped to an error string with the
> name of the symbol (I think they're all exactly equivalent).
> 
> So, for example, I do this for the ASN.1 Object Identifier (OID) registry.  I
> have a perl script:
> 
> 	lib/build_OID_registry
> 
> that parses the enum here:
> 
> 	include/linux/oid_registry.h
> 
> including the comments and generating tables for looking up OIDs:
> 
> 	enum OID {
> 		OID_id_dsa_with_sha1,		/* 1.2.840.10030.4.3 */
> 		OID_id_dsa,			/* 1.2.840.10040.4.1 */
> 
> This is built by rules in lib/Makefile:
> 
> 	#
> 	# Build a fast OID lookip registry from include/linux/oid_registry.h
> 	#
> 	obj-$(CONFIG_OID_REGISTRY) += oid_registry.o
> 
> 	$(obj)/oid_registry.o: $(obj)/oid_registry_data.c
> 
> 	$(obj)/oid_registry_data.c: $(srctree)/include/linux/oid_registry.h \
> 				    $(src)/build_OID_registry
> 		$(call cmd,build_OID_registry)
> 
> 	quiet_cmd_build_OID_registry = GEN     $@
> 	      cmd_build_OID_registry = perl $(src)/build_OID_registry $< $@
> 
> 	clean-files	+= oid_registry_data.c
> 
> Now, looking at smb2status.h, for example, we have a lot of:
> 
> 	#define STATUS_SUCCESS cpu_to_le32(0x00000000)
> 	#define STATUS_WAIT_0 cpu_to_le32(0x00000000)
> 	#define STATUS_WAIT_1 cpu_to_le32(0x00000001)
> 	...
> 
> and we could generate two parts of the table from this.  The third part could
> be placed in the header as well:
> 
> 	#define STATUS_SUCCESS	cpu_to_le32(0x00000000)	// 0
> 	#define STATUS_WAIT_0	cpu_to_le32(0x00000000)	// -EIO
> 	#define STATUS_WAIT_1	cpu_to_le32(0x00000001)	// -EIO
> 	...
> 
> (There's also the possibility that we don't necessarily want to list all
> statuses in the table.)
> 
> David

