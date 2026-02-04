Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFB442669A
	for <linux-cifs@vger.kernel.org>; Wed,  4 Feb 2026 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770221862; cv=none; b=AXCxKgth0wXiCSR+/smCsqznc6WXVZt9L7ryKErEcsKI88xH+AlQoAuprEWCQ0AjXERQPaN3aD5aOBhkqWgAkhRPKchmcFAehDh6W/cEkEGw/CIuEAFZvbERkld2679A9pBXd9d8Zf9pkSGD/AZ/crJOeg/CDmFWDeFfFvgXy8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770221862; c=relaxed/simple;
	bh=9Z0y2e1JTzIGb6SwyyoRNxLwWn0igeUty8to9o5sDAk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=bchQuX66Q0MMyrsESPudPVhd4MTuto5QEV7qeBwKxAymiByi4SruM36HcSlmo9d2rY3cdCw4H7oX8NhTcYWqWtQeIbI4FLGg+IlT6XebtsUI+wsibDHJZkUi1py8T47t+4q+q+Vxx+T2IKce0/9GOlYoKUmEP9iuI/DuCTYG3Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=3Pa9Audq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="3Pa9Audq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=/jdcNg9newyZPQznC8izCsRJtzwf1I5cQ4IV1MBQuAQ=; b=3Pa9AudqsssV4pA4Ey3XXQmYq0
	cvyXafyb4ZIg4Hm5XPaF7gCP2UDkAbHtyWikfwYBka69o0QWMbM5jHuhIEpjXO1D+eOHcdf2W85o6
	qsKKP8B0XCy4XZeiUx+91PrvXphsRfg6smtuwv9MzN5935RqRDswbr4ThhXRUnlrTjQdbajGTQ4gD
	YuNBeas+TqCUR4ZACCn+0A+13pyO2jNtMEp594BVY7hdv/DZbV3GL7IZjPxj1p+aQmXd6F1ZF1Lt4
	zlvjvvGz3LxyNjROouCmmuGc5VNM5WkvjJy4HY7nqlQPU0wix8z+9Mwsjdn8lrQLKiMAmQLTq71t+
	9lYz3OLN9v6OHyL6WciipeEV4Y76TbuaJSXL1tGZ/ZCY3Iw9ixW9YT+qJDonnEN8q01+BzURz8LVJ
	7qSdeSLHoeOSx8LPdXo57HaHdjO4aDKlwu/3+EeLjhw2QDpQPq2WK/1uTQZvDSO9LC8QQYlrGwIse
	JuZl8rr5T7ydH95RvAIVWWrs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vnfZT-00000004BoV-3DHw;
	Wed, 04 Feb 2026 16:17:39 +0000
Message-ID: <e2726e90-3645-44ef-9af8-2d390c4d5bc6@samba.org>
Date: Wed, 4 Feb 2026 17:17:39 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: common: add header guards to
 fs/smb/common/smb2status.h
From: Stefan Metzmacher <metze@samba.org>
To: Steve French <smfrench@gmail.com>, David Howells <dhowells@redhat.com>
Cc: Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
 Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
References: <20260203152012.914137-1-metze@samba.org>
 <68046261-f2d9-49a2-92ea-9c7abb97cd5e@samba.org>
 <46c9afa7-7834-4ac4-8509-b7087f358c96@samba.org>
Content-Language: en-US
In-Reply-To: <46c9afa7-7834-4ac4-8509-b7087f358c96@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 04.02.26 um 17:09 schrieb Stefan Metzmacher:
> Am 03.02.26 um 16:34 schrieb Stefan Metzmacher:
>> Hi Steve,
>>
>> this is on top of your for-next branch as it depends on this
>> patch from David:
>>
>> cifs: Label SMB2 statuses with errors
>>
>> While there I found that this patch:
>> cifs: Autogenerate SMB2 error mapping table
>>
>> Generates this error:
>> client/smb2maperror.c:55:60: SPARSE: error: restricted __le32 degrades to integer
>> David can you check?

This seems to be fixes by
smb/client: use bsearch() to find target in smb2_error_map_table

as I'm no longer see it when compiling all of for-next.

> This also breaks cifs.ko against a running kernel.
> 
> $(obj)/smb2_mapping_table.c: $(srctree)/fs/smb/common/smb2status.h
> 
> results in:
> 
> make[3]: *** No rule to make target '/usr/src/linux-headers-6.19.0-rc8-z-metze-perf.01+/fs/smb/common/smb2status.h', needed by 'smb2_mapping_table.c'.  Stop.
> make[3]: *** Waiting for unfinished jobs....
>    CC [M]  smb2ops.o
> make[2]: *** [/usr/src/linux-headers-6.19.0-rc8-z-metze-perf.01+/Makefile:2061: .] Error 2
> make[1]: *** [/usr/src/linux-headers-6.19.0-rc8-z-metze-perf.01+/Makefile:249: __sub-make] Error 2
> make[1]: Leaving directory '/root/cifs-backport/fs-smb/client'
> make: *** [Makefile:249: __sub-make] Error 2
> make: Leaving directory '/usr/src/linux-headers-6.19.0-rc8-z-metze-perf.01+'

This fixes it for me:

diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index 802dec276e15..3abd357d6df6 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -47,7 +47,7 @@ cifs-$(CONFIG_CIFS_COMPRESSION) += compress.o compress/lz77.o
  #
  # Build the SMB2 error mapping table from smb2status.h
  #
-$(obj)/smb2_mapping_table.c: $(srctree)/fs/smb/common/smb2status.h \
+$(obj)/smb2_mapping_table.c: $(src)/../common/smb2status.h \
                             $(src)/gen_smb2_mapping
         $(call cmd,gen_smb2_mapping)

metze

