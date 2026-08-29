Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5D64078DE
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 16:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788020781; cv=none; b=cXEGKgYNKVh06sY7KiD9qFhZwHt5WO6CLyRZUtFSZ3JjExHBsL4KeA10mmtMaO6x/UA1HPrmGBivI+m37x3ToDoqxEwcKbdqEXXlDGwQC0AT83IyiFrRsQgg+WzkLiRWpsYhtYGccs/601oOZEh6Mh6oV0nMS78eXh3NP1EW9Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788020781; c=relaxed/simple;
	bh=5bR150FonEhgq898E4phhk0OEo9sB3sk2J9h59+uRUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bdygqt+s5Xw1G0kLoY8WlJj1S+wB9xz2LsNj+BSNp2FjPf5yywW7RPwX+H59L/nzdLlJMlVMSHIz6TK7RoKv9+Y66XATWQWEzyhWp1fjZHyb/Yh0eu6N0H/jL5Eo8YixAqeqoDu55ojohhHA+emEd0pVOEMAwHW4GTBJMRuZVPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ivy4PC2B; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HYRdmgsj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ivy4PC2B";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HYRdmgsj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788020772;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=In8PJoJM7TuliZupFW2/GUoBwBsuu3ZJ9uWEGEaBgFk=;
	b=Ivy4PC2BHZWtJ0NlD5PkfMQSTQnwCfzesHdYGpD04D+nGEo3WcOaNwOPgqZsm9QXnNMMq0
	ZVXkRgf0fu/jDyQ0MomhP4qHjZPGmlW7IZoq+GD8EFgLTe/UG8CZ/iLTilYb0M9PLYo6Fr
	yMz4uV+Qs5MpZ2cVogHrVxAFCP0yBjk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-fpy3NzB2NsKdJyyRROJaIA-1; Sat, 29 Aug 2026 12:26:11 -0400
X-MC-Unique: fpy3NzB2NsKdJyyRROJaIA-1
X-Mimecast-MFC-AGG-ID: fpy3NzB2NsKdJyyRROJaIA_1788020771
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90e7db8d191so9499216d6.1
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 09:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788020770; x=1788625570; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=In8PJoJM7TuliZupFW2/GUoBwBsuu3ZJ9uWEGEaBgFk=;
        b=HYRdmgsjl0eBZWTq+N0qCpFFFxe0JFHLzw8vnTIclFwjZtMgTt7HK7OrkT1NDyb9jt
         XMxHp81To9CS8u9FF4xQRvylMY75JBmwHOusnWKEEYqgevtzxZ6s9QDCDyRH8cZRsmCe
         92I5lQssibkmjV7uS31LHvPUAYjNyrLm0gne9t3f5GvXXwJFcsm3dZpjWR7xe+8Vraoj
         rAOBs3j/YLVW0UG1DViFA6BfRSz4vh9m+WGtrFW0bXXHREozwmUVj2Q8Vujlwl+m4KnK
         pTOinLAig51o3OA5a+HBPg/6X20FVEOaPbsygOzn4gXHNRURXgyxan6h1Aqa10FngDQ/
         Pw2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788020770; x=1788625570;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=In8PJoJM7TuliZupFW2/GUoBwBsuu3ZJ9uWEGEaBgFk=;
        b=Irpy9DJzJ9WxBdyYYyyKYhKdG9E4qBC1mNZb3EV+jrc+r2gR5Xy8CI22rzx2AnIrKW
         4Qa++JjqdLDFsXbSjNNso4qoKirhKETQdp4Mpr7/fMtB9ciqC2Gbikgx++uTsyCCRslf
         xgBnIKguYq/Bph6L5YggJ3HSVEgi/cZl/4ODshzAY2Y342+FLbGeG0VCbtFNvMX9XmEo
         9HIFWGAMonrast7NvpBnFkwMDbPnkYRIW6KbnqDVn2483/l9N8/wBCmei+OkGPjZiZKA
         OxYTxy2SO5/4AXkoSTPssqGQ+WWPSQGA5hHi3mi3uiszz+87Bnchzb+9wN+Ip6FiZRff
         FiiA==
X-Gm-Message-State: AFuF++kHCi+Ysi4/GP3/txWV+xD4XcJ6duVDggBEC3FNf2l3y0yiiiIa
	TjH21fxumCnI4bu+hamjl239xyVvovkPo0dS3qTmsmvH3fxyWtG9u1fbOFONc2jgpkyeqQkS1iS
	W9NbU9/G+dGDtmMmIAJlSyEgp/a5z8Flip2NNbpcCQrHwAoN9bXcMchH7uOLl0T205HWbozs=
X-Gm-Gg: AYBFou2avUxEsmtYLSXCSzouPPTtC+qS0HnEDk19ZfIDLn9tSMdAtngGjx6l35H0h4L
	/mPwd5omgdSKDECwPUiXWeaG5LIprX1C9vruVub5e2Nm0CVuN5Wi/fmw1v+UL7aCCYqtP9FamkQ
	KIkUFrTQEorLQ7xDVvRCLR/suWpwWvwW+TGB6TLBxYhWyZbxcNomlD6HkYUf0qbku6Vvvb23q01
	RoTZyn5d0Xewk7hlnDvb1QRG51gVeFpg56D+lo+xM9A3G2bPOCvHSJVFpFqo5gc0ZZHsfAGY7GU
	w4Njhoe+wSjJHhfHAkvHs85akpDy5tcRr05pXE5a0kIDPQZJ+OeZGHTPKZM6Y3MrwHxvA7kyvKl
	zw6KftkfPbzKy0fth6jQIYF1rljG45NAD7TySKbhX
X-Received: by 2002:a05:6214:6344:b0:90c:e135:51e6 with SMTP id 6a1803df08f44-90ce13553cdmr149410456d6.9.1788020770510;
        Sat, 29 Aug 2026 09:26:10 -0700 (PDT)
X-Received: by 2002:a05:6214:6344:b0:90c:e135:51e6 with SMTP id 6a1803df08f44-90ce13553cdmr149410066d6.9.1788020770092;
        Sat, 29 Aug 2026 09:26:10 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90ce4534ebesm42678606d6.48.2026.08.29.09.26.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2026 09:26:09 -0700 (PDT)
Message-ID: <666879b8-5117-4c41-ab1d-e50637e68a5d@redhat.com>
Date: Sat, 29 Aug 2026 11:26:08 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH v3 11/11] smb: client: fix NameOffset and Next field
 validation in smb2_parse_contexts()
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stable@vger.kernel.org
References: <20260826153147.4112943-1-sorenson@redhat.com>
 <20260826153147.4112943-12-sorenson@redhat.com>
 <CAKYAXd8_jvTz6DX-1OjkCu1UAe7qKKHKOyW7-yOqrqVtxC6dPQ@mail.gmail.com>
From: Frank Sorenson <sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <CAKYAXd8_jvTz6DX-1OjkCu1UAe7qKKHKOyW7-yOqrqVtxC6dPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 8/29/26 9:01 AM, Namjae Jeon wrote:
>>                  case 16:
>> -                       if (posix && !memcmp(name, smb3_create_tag_posix, 16))
>> +                       if (dlen && posix && !memcmp(name, smb3_create_tag_posix, 16))
> Could we check that dlen is large enough for the fixed POSIX fields
> before calling parse_posix_ctxt()? It reads 12 bytes even when
> DataLength is smaller.

so this needs to be:
                      if (dlen > 12 && posix && !memcmp(name, smb3_create_tag_posix, 16))

I think we'll need similar before the calls to the 
server->ops->parse_lease_buf:
                     if (dlen && !strncmp(name, 
SMB2_CREATE_REQUEST_LEASE, 4)) {                                   
*oplock = server->ops->parse_lease_buf(cc, epoch,                       
                                                    lease_key);

for smb2: smb2_parse_lease_buf(void *buf, __u16 *epoch, char *lease_key) 
{         struct create_lease *lc = (struct create_lease *)buf;         
*epoch = 0; /* not used */         if (lc->lcontext.LeaseFlags & 
SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE)                 return 
SMB2_OPLOCK_LEVEL_NOCHANGE;         return 
le32_to_cpu(lc->lcontext.LeaseState);

/* See MS-SMB2 2.2.13.2.8 */ struct lease_context {         __u8 
LeaseKey[SMB2_LEASE_KEY_SIZE];         __le32 LeaseState;         __le32 
LeaseFlags;         __le64 LeaseDuration; } __packed;

for smb2, we only access through LeaseFlags (24 bytes), but the entire 
struct is 32

static __u8 smb3_parse_lease_buf(void *buf, __u16 *epoch, char 
*lease_key) {         struct create_lease_v2 *lc = (struct 
create_lease_v2 *)buf;         *epoch = le16_to_cpu(lc->lcontext.Epoch); 
         if (lc->lcontext.LeaseFlags & 
SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE)                 return 
SMB2_OPLOCK_LEVEL_NOCHANGE;         if (lease_key)                 
memcpy(lease_key, &lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);         
return le32_to_cpu(lc->lcontext.LeaseState);

/* See MS-SMB2 2.2.13.2.10 */ struct lease_context_v2 {         __u8 
LeaseKey[SMB2_LEASE_KEY_SIZE];         __le32 LeaseState;         __le32 
LeaseFlags;         __le64 LeaseDuration;         __u8 
ParentLeaseKey[SMB2_LEASE_KEY_SIZE];         __le16 Epoch;         
__le16 Reserved; } __packed; and for smb3, we'll need through Epoch, so

     SMB2_LEASE_KEY_SIZE + 4 + 4 + 8 + SMB2_LEASE_KEY_SIZE + 2 = 50,

with the entire struct being 52 bytes

and also before the call to parse_query_id_ctxt():
                           } else if (dlen > 16 && buf &&               
                        !strncmp(name, SMB2_CREATE_QUERY_ON_DISK_ID, 4)) 
{                                   parse_query_id_ctxt(cc, buf);
parse_query_id_ctxt(struct create_context *cc, struct smb2_file_all_info *buf)
{
         struct create_disk_id_rsp *pdisk_id = (struct create_disk_id_rsp *)cc;

         cifs_dbg(FYI, "parse query id context 0x%llx 0x%llx\n",
                 pdisk_id->DiskFileId, pdisk_id->VolumeId);
         buf->IndexNumber = pdisk_id->DiskFileId;

/* See MS-SMB2 2.2.14.2.9 */
struct create_disk_id_rsp {
         struct create_context_hdr ccontext;
         __u8   Name[8];
         __le64 DiskFileId;
         __le64 VolumeId;
         __u8  Reserved[16];
} __packed;


With varying sizes, how do we handle the check prior to the call to the version-specificserver->ops->parse_lease_buf ?


-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

