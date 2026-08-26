Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B4428B7DA
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 01:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787708885; cv=none; b=n3yilo8yTrwylYMYa3QvLfYxDvYLK33HzfB/N6fJ3N3YEJCwbjw0APYa4SY/PGg7bEVozrMn7G7RvKgNs9B6UW+4DvZsXY9AMN3Q0RS3ys1LMRYv2SVTqPcti5/B5x61FTamuhgXbUBoJW0CuiaWZo/PFMAp3VKKDUn93KhVIj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787708885; c=relaxed/simple;
	bh=oxx6ofg9a8CygyVwilfRVtmkQz10Y5fK59oDHxWn2mU=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=MN4FdjoFh6mmDE36nFg9nvjfMjp1ypmjj6WclBGMCREGIhm2xQ6Ri3EnuPcbgYJmqUKGwJKgrDmuL9JhQCx+jVKCY3HcngEFuP9F9aQ0RsxMWsMskbAKc5Ym10AahGC/u6B/vcjD3ijRWSAf79zu2Vj0eB5V0HEBKzpe1FIRZSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X9iMBF4g; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nsiEgdSI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X9iMBF4g";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nsiEgdSI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787708881;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=Vs3E98wBd4MYewi2E1vaeZjaYDi3wKaIatuQ1iqkVr8=;
	b=X9iMBF4gO+iSdIqC8YIDFA5wcuXFTSzwy6Kd4T4swQ8L8NbUjG5s1hYkjnHlLCs6g0S6E7
	3S1NYsT2d8TZNjKRMKAFHmrtHJFrnb906n8uYEzkcepZ73yHLkwGN53FHU28O+bLkad8Hi
	LuATlD/WrUKIq4XBLrMk3wCTToMKcxY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-tyP9BH95NFaDbo0Z2YDZYQ-1; Tue, 25 Aug 2026 21:47:59 -0400
X-MC-Unique: tyP9BH95NFaDbo0Z2YDZYQ-1
X-Mimecast-MFC-AGG-ID: tyP9BH95NFaDbo0Z2YDZYQ_1787708879
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c1d137a68so8264051cf.3
        for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 18:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787708879; x=1788313679; darn=vger.kernel.org;
        h=in-reply-to:content-language:from:references:cc:to:subject:reply-to
         :user-agent:mime-version:date:message-id:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Vs3E98wBd4MYewi2E1vaeZjaYDi3wKaIatuQ1iqkVr8=;
        b=nsiEgdSIOofSEaw0BiDvDKPMFnUfkZeeiDuCTzCOxY5sl0mT7PYcG2oBpfTmnqZIid
         dZkWnZmt9nxkkMzc/vp2O0uy4MX0KAZeHBkH7jSUPQ2atEZ9qjgfEwd98DFRPY9oCjc5
         nTPYMlQVlx4cQ4YuFq6q9C7rBiPU1lFIK4+wbMM4XEWjGFSTo3nQ6OToO5LZcTeLmtGP
         p3TJVeeGtqvVNoEdi022IwImQwbJt8rkdWyhdWQ1zS0Pjv80q9Lpbjkbxevr6o+M4jnr
         70yYRvKhrLR3+rQpOkXO2C10gXPEIbGFsQu1C6hQBUM/8t+Dgp/eBy2I8CGsUu6oFciX
         fQ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787708879; x=1788313679;
        h=in-reply-to:content-language:from:references:cc:to:subject:reply-to
         :user-agent:mime-version:date:message-id:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vs3E98wBd4MYewi2E1vaeZjaYDi3wKaIatuQ1iqkVr8=;
        b=qXKktiOihCQiRy7HjJ73gJ+1ruODx3Gvv1g/Z6s7o/8v0sHjR/KkRmV37qXkFmfqf+
         ilr1Xh2oewZ43XxhwZdEgjLLc17IMuY92y5MCoTZ0lvr5p4C3inOzBKsMfXkISMDqpIV
         LMBAs97HKz4mwqdLkmvehiFcJUFK4HIIYAReAsywwnsyzlzB2syL/Hs8pXCF84QIw8tZ
         hnloa/hSqACuXA8Ztk0r9JN1igaxCWn3ZC757BILRyG1lZndrLRzRrwfipkRp60duR4I
         Nzp8d1lmIeoxRDXsCKosp/m2TSKAFxrc5A/ASy+hTqwCDuaEAGqmJMFlLlk2X+OoN0dy
         Gm+Q==
X-Forwarded-Encrypted: i=1; AHgh+RqykK8fU7KdvfkFIMN3rP5xLfkzVODBpTTmbhC7sg5YkbibdYAmf3FGgpkc96oMf4B0cpAv5pCrdNX1@vger.kernel.org
X-Gm-Message-State: AFuF++mWOUGpaZEZRW8iLAsIMa80rU7z2JUrseb7WdNIOxS9cAtf9qiO
	28JHIRm11R7yRxrePaBrUqu2EkC5Y8+rI52/LcRgWE5Q0MlTg8qi1YrGc6nXYIypvsXpr5Z50Xj
	8p8h9clfPkgtChWtNxJOjy9aNohvfN3lJI1BCwNDGgtQA0eHSj4njpvSUNdSeqZvBZx2THxE=
X-Gm-Gg: AR+sD12EWlfE3wx02zXMHtTfdNJW/6DIel971vPe/3QLHgQ8Ee9wNkplhlqsIzENieE
	h9EsonCsHNM08gmk6zsN4XKy/lees1doeKEA+sZuTMZTidVhID4QJh3BRXoSTJYKTaOY72u6STi
	AgFWVAp2PsXvmj/4QKphNomEr/vNpIaA/YoJn7D1wCUQWj4NZgL7YlKkY1N0XRMhyH1v3U59j+/
	f4pOa6X6L8w/ewynR/Z9wDi32JrldKmU05HQXol5HAtUE8WRw/Iz4e0E7qD8MJNSHixYsNj/vqT
	tnXEG12P/QEfUfpkG76pjyGZe17IIL/g0FgTKjKR91GQBi8ajW2fnVbKh7IupMblqAI/JqF+Wx1
	c9cmUGFPkafh4Rbh3zetaLhey7ih8j1MHe1Blm6ob
X-Received: by 2002:ac8:6f08:0:b0:51c:16b3:351a with SMTP id d75a77b69052e-52e422d9df5mr35947621cf.1.1787708878440;
        Tue, 25 Aug 2026 18:47:58 -0700 (PDT)
X-Received: by 2002:ac8:6f08:0:b0:51c:16b3:351a with SMTP id d75a77b69052e-52e422d9df5mr35947371cf.1.1787708877939;
        Tue, 25 Aug 2026 18:47:57 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc6529ab7sm12853086d6.42.2026.08.25.18.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 18:47:57 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------sna65HWIs3SbsK1LHOnCMpSc"
Message-ID: <58e597c3-93ac-45c3-a52a-ca8572fec7a8@redhat.com>
Date: Tue, 25 Aug 2026 20:47:56 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH v2] smb: client: fix heap overflow in cifs_do_set_acl()
To: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org
References: <20260825183229.3799705-1-sorenson@redhat.com>
 <20260825214328.3852168-1-sorenson@redhat.com>
 <b8ea942d21a0f0ede8518f33895def69@manguebit.org>
From: Frank Sorenson <sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <b8ea942d21a0f0ede8518f33895def69@manguebit.org>

This is a multi-part message in MIME format.
--------------sna65HWIs3SbsK1LHOnCMpSc
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 8/25/26 7:03 PM, Paulo Alcantara wrote:
> Frank Sorenson <sorenson@redhat.com> writes:
>
>> cifs_set_acl() validates ACL size using posix_acl_xattr_size():
>>
>>          4 + (count * 8)  // 4-byte header + 8 bytes per ACE
>>
>> cifs_do_set_acl() then calls posix_acl_to_cifs() to write the CIFS
>> wire format into the same buffer:
>>
>>          6 + (count * 10)  // 6-byte header + 10 bytes per ACE
>>
>> An ACL that passes the xattr-based check in cifs_set_acl() can
>> overflow the heap when posix_acl_to_cifs() writes the larger CIFS
>> format.
>>
>> Validate the CIFS format size against the remaining buffer space and
>> USHRT_MAX before converting--data_count is __u16, so sizes above
>> USHRT_MAX truncate the on-wire packet length, causing the server to
>> apply a partial ACL.  Replace MaxDataCount = 1000 with
>> min(CIFSMaxBufSize, USHRT_MAX).
>>
>> Fixes: dc1af4c4b4721 ("cifs: implement set acl method")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
>> ---
>> v2 changes:
>>   - Add USHRT_MAX bound to prevent u16 truncation of data_count for ACLs
>>     with more than 6553 entries, which would cause a partial ACL to be
>>     silently applied on the server
>>   - limit MaxDataCount to min(CIFSMaxBufSize, USHRT_MAX)
>>
>>   fs/smb/client/cifssmb.c | 13 +++++++++++--
>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
>> index f5aad5f61dce..621aca5d3b75 100644
>> --- a/fs/smb/client/cifssmb.c
>> +++ b/fs/smb/client/cifssmb.c
>> @@ -3555,6 +3555,7 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
>>   	int rc = 0;
>>   	int bytes_returned = 0;
>>   	__u16 params, byte_count, data_count, param_offset, offset;
>> +	size_t cifs_acl_size, bytes_available;
>>   
>>   	cifs_dbg(FYI, "In SetPosixACL (Unix) for path %s\n", fileName);
>>   setAclRetry:
>> @@ -3574,8 +3575,7 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
>>   	}
>>   	params = 6 + name_len;
>>   	pSMB->MaxParameterCount = cpu_to_le16(2);
>> -	/* BB find max SMB size from sess */
>> -	pSMB->MaxDataCount = cpu_to_le16(1000);
>> +	pSMB->MaxDataCount = cpu_to_le16(min_t(unsigned int, CIFSMaxBufSize, USHRT_MAX));
>>   	pSMB->MaxSetupCount = 0;
>>   	pSMB->Reserved = 0;
>>   	pSMB->Flags = 0;
>> @@ -3587,6 +3587,15 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
>>   	parm_data = ((char *)pSMB) + offset;
>>   	pSMB->ParameterOffset = cpu_to_le16(param_offset);
>>   
>> +	/* make sure we can fit the larger cifs_posix_aces in the buffer */
>> +	cifs_acl_size = sizeof(struct cifs_posix_acl) +
>> +		       (acl->a_count * sizeof(struct cifs_posix_ace));
>> +	bytes_available = (CIFSMaxBufSize + MAX_SMB2_HDR_SIZE) - offset;
> Are you sure you want to use MAX_SMB2_HDR_SIZE?  This is SMB1 code, so I
> would expect to see MAX_CIFS_HDR_SIZE.  Alternatively, use
> MAX_HEADER_SIZE() helper.

The only reason I used MAX_SMB2_HDR_SIZE is that it's the actual size 
allocated in cifs_buf_get() from cifs_req_cachep...  but now that I 
think about it, we don't actually want to use the extra 
(MAX_SMB2_HDR_SIZE - MAX_CIFS_HDR_SIZE) bytes, even though we have it 
allocated.  So as you say, MAX_CIFS_HDR_SIZE or 
MAX_HEADER_SIZE(tcon->ses->server) would be better.

I can respin.

> Do you have any reproducer?

Yes, I'll attach the script.  It sets 1800 named user ACEs, which is 
14436 xattr bytes, ~18046 CIFS bytes

7.2-ish unpatched:

# mount //vm25/user1 /mnt/vm25 -overs=1.0,username=user1,password=pass,unix
# python3 reproduce_acl_overflow.py /mnt/vm25/testfile
Setting ACL with 1800 named user ACEs (14436 xattr bytes, ~18046 CIFS bytes)
Unpatched kernel: expect KASAN report or silent heap corruption
Patched kernel:   expect -E2BIG from setxattr
setxattr failed: [Errno 5] Input/output error: '/mnt/vm25/testfile'

[ 1068.599600] BUG: KASAN: slab-out-of-bounds in 
posix_acl_to_cifs+0x60a/0x6b0 [cifs]
[ 1068.599952] Write of size 8 at addr ffff88810625c0ca by task 
python3/40835

[ 1068.600017] CPU: 2 UID: 0 PID: 40835 Comm: python3 Not tainted 
7.2.0-rc7+ #6 PREEMPT(full)
[ 1068.600029] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
1.17.0-10.fc44 06/10/2025
[ 1068.600041] Call Trace:
[ 1068.600047]  <TASK>
[ 1068.600050]  dump_stack_lvl+0x4e/0x70
[ 1068.600066]  ? posix_acl_to_cifs+0x60a/0x6b0 [cifs]
[ 1068.600312]  print_address_description.constprop.0+0x70/0x300
[ 1068.600324]  ? posix_acl_to_cifs+0x60a/0x6b0 [cifs]
[ 1068.600570]  print_report+0x108/0x209
[ 1068.600580]  ? posix_acl_to_cifs+0x60a/0x6b0 [cifs]
[ 1068.600818]  kasan_report+0xf0/0x120
[ 1068.600827]  ? posix_acl_to_cifs+0x60a/0x6b0 [cifs]
[ 1068.601059]  posix_acl_to_cifs+0x60a/0x6b0 [cifs]
[ 1068.601292]  cifs_do_set_acl+0x446/0xb90 [cifs]
...

[ 1068.616380] Allocated by task 40835:
[ 1068.617021]  kasan_save_stack+0x30/0x50
[ 1068.617033]  kasan_save_track+0x14/0x30
[ 1068.617039]  __kasan_slab_alloc+0x89/0x90
[ 1068.617045]  kmem_cache_alloc_noprof+0x155/0x430
[ 1068.617053]  mempool_alloc_noprof+0x11b/0x1e0
[ 1068.617062]  cifs_buf_get+0x36/0x90 [cifs]
[ 1068.617344]  smb_init+0x43/0x100 [cifs]
[ 1068.617618]  cifs_do_set_acl+0x147/0xb90 [cifs]
[ 1068.617860]  cifs_set_acl+0x717/0x920 [cifs]
[ 1068.618096]  vfs_set_acl+0x35a/0x880
[ 1068.618104]  do_set_acl+0xa6/0x160
[ 1068.618109]  filename_setxattr+0x129/0x170
[ 1068.618115]  path_setxattrat+0x156/0x290
[ 1068.618120]  __x64_sys_setxattr+0xc6/0x140
[ 1068.618125]  do_syscall_64+0xe3/0x540
[ 1068.618133]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

[ 1068.618793] The buggy address belongs to the object at ffff888106258000
                 which belongs to the cache cifs_request of size 16588
[ 1068.619990] The buggy address is located 16586 bytes inside of
                 allocated 16588-byte region [ffff888106258000, 
ffff88810625c0cc)

7.2 patched

# python3 reproduce_acl_overflow.py /mnt/vm25/testfile Setting ACL with 
1800 named user ACEs (14436 xattr bytes, ~18046 CIFS bytes) Unpatched 
kernel: expect KASAN report or silent heap corruption Patched kernel: 
expect -E2BIG from setxattr Got -E2BIG -- fix is active

> What server did you test these changes against?

samba


-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

--------------sna65HWIs3SbsK1LHOnCMpSc
Content-Type: text/x-python; charset=UTF-8; name="reproduce_acl_overflow.py"
Content-Disposition: attachment; filename="reproduce_acl_overflow.py"
Content-Transfer-Encoding: base64

IyEvdXNyL2Jpbi9lbnYgcHl0aG9uMwoiIiIKUmVwcm9kdWNlciBmb3IgY2lmc19kb19zZXRf
YWNsKCkgaGVhcCBvdmVyZmxvdy4KCmNpZnNfc2V0X2FjbCgpIHZhbGlkYXRlcyBBQ0wgc2l6
ZSB1c2luZyBMaW51eCB4YXR0ciBmb3JtYXQgKDggYnl0ZXMvQUNFKSwKYnV0IHBvc2l4X2Fj
bF90b19jaWZzKCkgd3JpdGVzIENJRlMgd2lyZSBmb3JtYXQgKDEwIGJ5dGVzL0FDRSkgaW50
byB0aGUKc2FtZSBidWZmZXIuICBXaXRoIENJRlNNYXhCdWZTaXplPTE2Mzg0IChkZWZhdWx0
KSwgb3ZlcmZsb3cgem9uZSBpcwp+MTY1MC0yMDQ3IG5hbWVkIHVzZXIgQUNFcy4KClJlcXVp
cmVzIFNhbWJhIHNoYXJlIG1vdW50ZWQgd2l0aCBVbml4IGV4dGVuc2lvbnM6CiAgbW91bnQg
LXQgY2lmcyAvL3NlcnZlci9zaGFyZSAvbW50IC1vIHVuaXgsdXNlcm5hbWU9dXNlcixwYXNz
d29yZD1wYXNzCgpVc2FnZTogcHl0aG9uMyByZXByb2R1Y2VfYWNsX292ZXJmbG93LnB5IDxw
YXRoX29uX2NpZnNfbW91bnQ+CiIiIgppbXBvcnQgb3MsIHN5cywgc3RydWN0CgpQT1NJWF9B
Q0xfWEFUVFJfVkVSU0lPTiA9IDIKQUNMX1VTRVJfT0JKICA9IDB4MDAwMQpBQ0xfVVNFUiAg
ICAgID0gMHgwMDAyCkFDTF9HUk9VUF9PQkogPSAweDAwMDQKQUNMX01BU0sgICAgICA9IDB4
MDAxMApBQ0xfT1RIRVIgICAgID0gMHgwMDIwCkFDTF9SRUFEICAgICAgPSAweDA0CgpkZWYg
YnVpbGRfYWNsKG5fdXNlcl9hY2VzKToKICAgICIiIkJ1aWxkIGEgdmFsaWQgUE9TSVggQUNM
IHhhdHRyIGJsb2Igd2l0aCBuX3VzZXJfYWNlcyBuYW1lZCB1c2VyIGVudHJpZXMuIiIiCiAg
ICBlbnRyaWVzID0gWyhBQ0xfVVNFUl9PQkosIEFDTF9SRUFELCAweGZmZmZmZmZmKV0KICAg
IGZvciB1aWQgaW4gcmFuZ2UoMSwgbl91c2VyX2FjZXMgKyAxKToKICAgICAgICBlbnRyaWVz
LmFwcGVuZCgoQUNMX1VTRVIsIEFDTF9SRUFELCB1aWQpKQogICAgZW50cmllcyArPSBbCiAg
ICAgICAgKEFDTF9HUk9VUF9PQkosIEFDTF9SRUFELCAweGZmZmZmZmZmKSwKICAgICAgICAo
QUNMX01BU0ssICAgICAgQUNMX1JFQUQsIDB4ZmZmZmZmZmYpLAogICAgICAgIChBQ0xfT1RI
RVIsICAgICAwLCAgICAgICAgMHhmZmZmZmZmZiksCiAgICBdCiAgICBibG9iID0gc3RydWN0
LnBhY2soIjxJIiwgUE9TSVhfQUNMX1hBVFRSX1ZFUlNJT04pCiAgICBmb3IgdGFnLCBwZXJt
LCB1aWQgaW4gZW50cmllczoKICAgICAgICBibG9iICs9IHN0cnVjdC5wYWNrKCI8SEhJIiwg
dGFnLCBwZXJtLCB1aWQpCiAgICByZXR1cm4gYmxvYgoKZGVmIG1haW4oKToKICAgIGlmIGxl
bihzeXMuYXJndikgIT0gMjoKICAgICAgICBwcmludChmIlVzYWdlOiB7c3lzLmFyZ3ZbMF19
IDxwYXRoX29uX2NpZnNfbW91bnQ+IikKICAgICAgICBzeXMuZXhpdCgxKQoKICAgIHBhdGgg
PSBzeXMuYXJndlsxXQogICAgaWYgbm90IG9zLnBhdGguZXhpc3RzKHBhdGgpOgogICAgICAg
IG9wZW4ocGF0aCwgJ3cnKS5jbG9zZSgpCgogICAgIyAxODAwIEFDRXM6IGNvbWZvcnRhYmx5
IGluIHRoZSBvdmVyZmxvdyB6b25lIGZvciBkZWZhdWx0IENJRlNNYXhCdWZTaXplPTE2Mzg0
CiAgICAjIHhhdHRyIHNpemU6IDQgKyAxODA0KjggPSAxNDQzNiBieXRlcyAgKHBhc3NlcyBj
aWZzX3NldF9hY2wgY2hlY2spCiAgICAjIGNpZnMgIHNpemU6IDYgKyAxODA0KjEwID0gMTgw
NDYgYnl0ZXMgKG92ZXJmbG93cyB+MTY1ODgtYnl0ZSBidWZmZXIpCiAgICBuX2FjZXMgPSAx
ODAwCiAgICBibG9iID0gYnVpbGRfYWNsKG5fYWNlcykKICAgIHByaW50KGYiU2V0dGluZyBB
Q0wgd2l0aCB7bl9hY2VzfSBuYW1lZCB1c2VyIEFDRXMgIgogICAgICAgICAgZiIoe2xlbihi
bG9iKX0geGF0dHIgYnl0ZXMsIH57NiArIChuX2FjZXMgKyA0KSAqIDEwfSBDSUZTIGJ5dGVz
KSIpCiAgICBwcmludCgiVW5wYXRjaGVkIGtlcm5lbDogZXhwZWN0IEtBU0FOIHJlcG9ydCBv
ciBzaWxlbnQgaGVhcCBjb3JydXB0aW9uIikKICAgIHByaW50KCJQYXRjaGVkIGtlcm5lbDog
ICBleHBlY3QgLUUyQklHIGZyb20gc2V0eGF0dHIiKQoKICAgIHRyeToKICAgICAgICBvcy5z
ZXR4YXR0cihwYXRoLCAic3lzdGVtLnBvc2l4X2FjbF9hY2Nlc3MiLCBibG9iKQogICAgICAg
IHByaW50KCJzZXR4YXR0ciBzdWNjZWVkZWQgKHVuZXhwZWN0ZWQgLS0gc2VydmVyIGFjY2Vw
dGVkIGl0KSIpCiAgICBleGNlcHQgT1NFcnJvciBhcyBlOgogICAgICAgIGltcG9ydCBlcnJu
bwogICAgICAgIGlmIGUuZXJybm8gPT0gZXJybm8uRTJCSUc6CiAgICAgICAgICAgIHByaW50
KCJHb3QgLUUyQklHIC0tIGZpeCBpcyBhY3RpdmUiKQogICAgICAgIGVsc2U6CiAgICAgICAg
ICAgIHByaW50KGYic2V0eGF0dHIgZmFpbGVkOiB7ZX0iKQoKaWYgX19uYW1lX18gPT0gIl9f
bWFpbl9fIjoKICAgIG1haW4oKQo=

--------------sna65HWIs3SbsK1LHOnCMpSc--

