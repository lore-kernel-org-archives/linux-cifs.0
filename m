Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE814AF16B
	for <linux-cifs@vger.kernel.org>; Wed,  2 Sep 2026 21:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788384587; cv=none; b=aprJSCvsJNXo+U3sK3jq74LUj2KWX4bbvSH3UY7MnWSgT5TejZ1SQ0LGvtx3gIFASt0Ya+2koUh8J2wbcku6jo2qpeBcUTe6AV7GP9Y6sJYopzNWRFAQY3qAXQyXOBL3AZDrpp8pNQuEWNycn1p7TMoi+gojhK0F1Hqsn9r9aHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788384587; c=relaxed/simple;
	bh=8ikXXU9gsjnfuEXFFzMc/pFblMUMmoXuqRxxynzibiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uxLEBbq2hzNBybBWar8tdzK2I2vzhyX0brZVY5qRWh6bPGvMxmlSIohJCk8K0m1qq2xIBvWGpdb22H/MUo67cnfJgr4aAo+CX7PzRAIEhO52UIjiCiAKDJDBBs/eFwNIeyTvDXRjwHs9/p11RM4nsoBZb10cqo4Ws0J87NlQMYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jNMPCC2K; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KbmpHe36; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jNMPCC2K";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KbmpHe36"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788384581;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G8/HZmSzxqzTAQEUn1qQz/Y2InSJgtncXySHZ9oVOAU=;
	b=jNMPCC2KRie8FteS/HkAkbruhz3+dqgQZ0E+RYzui2kldYgOWNoVLX79QerWzRBlvvQOOM
	vZspMSy5n7PvW1qiZ4BSvtK/IX68F5u8fXa9CN5vcq8eLVLR6DfmSH5qlwE+QAk87sswSb
	1hCohIXGMT+b017sTgSDHe7IdXYYPI4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-Y5ai6utOOYOONPqZzIG39A-1; Wed, 02 Sep 2026 17:29:39 -0400
X-MC-Unique: Y5ai6utOOYOONPqZzIG39A-1
X-Mimecast-MFC-AGG-ID: Y5ai6utOOYOONPqZzIG39A_1788384579
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90cea0b5522so30378236d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2026 14:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788384579; x=1788989379; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=G8/HZmSzxqzTAQEUn1qQz/Y2InSJgtncXySHZ9oVOAU=;
        b=KbmpHe36MvHM4vN5Z5GNR6NQOO1S74rStLC38fu6jFzOnCph+eX81jygU/x49mjbku
         0QOD/xYu0W3GBkyKX51b1T5pHWjDtLlXzqjmuew7/Bm/3K6wpMb4wk2KIgA5y6AnoA73
         2jYsLW3FI6dKcM26j2Yyqr2GDOgo1P4gPNfr8FAVnq/cKHVdOnfH3rnxxa+Yi4GlSuXN
         j5bPb2g5WkuqGgnosgp9/g4gKzVJieaSJXHAPmV/OPyAx3EkEvxPl50iQ4fpZkCbPq/h
         l3K0DZuFU9uSD8InK+rddmjQDT41UOX3BUff9zqBTGCdhYAIy5G/tpXlbNldkX3vfBsQ
         7rhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788384579; x=1788989379;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G8/HZmSzxqzTAQEUn1qQz/Y2InSJgtncXySHZ9oVOAU=;
        b=P+A0yLF2lgPtkq7MZk+nNv2pk9/u6nzZWxnLc7EWSVGOA2RbsA10mf9FZVvxbSVOiP
         21mQ91ajXDkviyUI/Y76TNmc2aFscqHCM5kjyvAPMlMD8j0Y7iKQF4HxitrqCeO2RBIm
         dFKA5lBkbL8A01hHwk8DgLYEft/ebW0See5nnBoJXhckNT3MQREDnUTDWeEysvv8qnqi
         VnM5JO7VCiuhBZ42NfzTWbcp+4oyZNT0O8c4mdszHdyVTc1uX/3xLKINa/Vr9gVTSDJj
         cQBegBCFUawIPzS9NtCw88KZDIngnNXjl9ynykwOCV867aiG3Ij9jiT7niI/me3/LhKc
         GSqw==
X-Forwarded-Encrypted: i=1; AKwUvBzslMpp7IKVx+MIFnyLsV2/LB2kqQXWpNER2Y4LfV5Cvl4pQCWEjAXJsNAqPhDf8mIn34zaMsz6o2Ii@vger.kernel.org
X-Gm-Message-State: AFuF++lm9HdSg4u6CCugHZuMqbaONFhNBLuqXJHr+N5mpbSZatI6dXyo
	pqLAFnc5R6Vb0fP33idq18X7YNU2Zga02ivKsYqn0v/rAfJHxSji69vuExANOkzPzFDMy4wTSLq
	X7E/ju7jat0WZQKK+M3+gbOY9BHGQTgH37p00cWWqjWTF2PoI2C1wHcrjUbTs0Wc=
X-Gm-Gg: AYBFou1SURrOjuHM3F0n94GX1Evwet0+WBCugz07xoUV8+YvwFPpZUFdcNRwhbk/Ed4
	ypoSMOheob+hUmd3PQLofbyIt3VQgtjsZlC5G5Yv7r3nJT8p6Gf7yeXaBVvbZ1e46zCNjghtPoL
	u6e+4YdUB3K7CzYMdTq/k/9ecgb5dmF0dGCju9UC0OBC9XjOVCSpO/AmQURwRicXobGpkepdPrF
	VSxeon+F1NiXYxZ7efH7rDeSBxtTZF1aXVjFRmPF7UOL3CyWwt+6wR4r3LjPLlBk8HffsLMacQc
	3eVGiHs/JU0IKX4R3JOkYFrzdwhVIGEb6Nom0wT08stnG+qJWuKyuM2mHqT4ylLpkR0vAtScWZb
	IM+DiK7E8equTEFY4IoPUjMQdJzM/i+VMcvvahDYk
X-Received: by 2002:ad4:5769:0:b0:90e:8e21:475c with SMTP id 6a1803df08f44-90ebab7cf42mr100561486d6.21.1788384579256;
        Wed, 02 Sep 2026 14:29:39 -0700 (PDT)
X-Received: by 2002:ad4:5769:0:b0:90e:8e21:475c with SMTP id 6a1803df08f44-90ebab7cf42mr100560936d6.21.1788384578608;
        Wed, 02 Sep 2026 14:29:38 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9f0d998dsm27152966d6.9.2026.09.02.14.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 14:29:38 -0700 (PDT)
Message-ID: <e5dec57a-0186-4087-9de4-5037f0a09879@redhat.com>
Date: Wed, 2 Sep 2026 16:29:36 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH v3 0/2] smb: client: fix out-of-bounds reads in
 CIFSSMBRead()
To: Diego Oliva <diego@bynar.io>, Paulo Alcantara <pc@manguebit.org>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
References: <20260902104207.1820332-1-diego@bynar.io>
From: Frank Sorenson <sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <20260902104207.1820332-1-diego@bynar.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Diego,

On 9/2/26 5:42 AM, Diego Oliva wrote:
> CIFSSMBRead() parses the server's READ_RSP without validating either
> the length of the response or the DataOffset it carries. A malicious
> or compromised SMB1 server can exploit either to read past the end of
> the receive buffer, leaking adjacent kernel heap into the caller's
> read buffer or oopsing on unmapped memory. SMB1 is not negotiated by
> default; reaching this code requires an explicit vers=1.0 mount.
>
> Patch 1 rejects responses too short to contain a whole READ_RSP, so
> the header fields can be dereferenced safely. Patch 2 ejects a
> DataOffset/DataLength pair that falls outside the received response.

Your patch 2 checks that data_offset + data_length fit:

+		} else if ((size_t)data_offset + data_length > rsp_iov.iov_len) {

but I think you may also need a lower-bound check to make sure
data_offset is at least sizeof(READ_RSP):

+               } else if (data_offset < sizeof(READ_RSP)) {

otherwise, the data would overlap the response header itself.

Frank

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

