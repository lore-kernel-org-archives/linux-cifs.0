Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7712A36196E
	for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 17:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789146384; cv=none; b=uKgQokT/m9Mw+jM6siX9ayRg8q4XqFPRlkCfenBkh1ItszcsTtFqaddiCksB6RzkEP+YmAKZBWjL75DmFopA385I8v3jAkPF1wYxENLn0DrOJ0uyiikkvnM2eJYKCz4g3LicuFOwY5L60P0E0No32tPVd4lWeF2engemE9g1qBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789146384; c=relaxed/simple;
	bh=+R3ivebSuZpuL4FG2TRYxlXWK7mPI4IWQ3Tpoi4odgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVclPQ+7TLYRTjdlL17PRFfKwXMEL0axu73EerMzHNLX+NH29zEhcrICEE+g/qxtoab7SgWbNsv4vTHVB/S1RHPEmqAl0D6O/3I4UpEHXe4KsaEBrnjzyFLhjUY0lmD162kylHOF/+D9wQFKITEvIqW1o9Jqjq9SN3Su0r0b3c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fcm4wEHb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nCafHl5d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fcm4wEHb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nCafHl5d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789146378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8gSh+I98IpYLSh7UCgpWIS2EiiNfz/lZyRXhuHswHY4=;
	b=fcm4wEHb8ABxN+rvpTSeI+eSRfpEASCrXlra5wDgTHEnPOHe1w1ppdb8MPxybWSIDnwe+J
	O19PwkztDr1wiFKUDunPMQvA4wxekuH4GVKkx/1eruVhKfgroL1wfATvBXmklaAXK8eIik
	ypSURLwQSwjQKlfK+HZY5sX8vrLV/YU=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-GVAi-gZ0M4Sljl0Orveimw-1; Fri, 11 Sep 2026 13:06:17 -0400
X-MC-Unique: GVAi-gZ0M4Sljl0Orveimw-1
X-Mimecast-MFC-AGG-ID: GVAi-gZ0M4Sljl0Orveimw_1789146376
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7f4e0b45e4bso1348895a34.2
        for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 10:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789146376; x=1789751176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8gSh+I98IpYLSh7UCgpWIS2EiiNfz/lZyRXhuHswHY4=;
        b=nCafHl5dxH/Vue/i1CDhYJ6MyiCWOSDH//snVCNfdEUYEbG54OayOcd+EbU2YPxAZW
         qj52WocQmfQF4XyMDzhS2+xm/9mspkAgKMoGYOzpG0q1bnAKZuZH4QfY0s7GfRgmqaMu
         TnOzho4qqko3WTI4PaBtSmLR8r68R0CZ0R2VRsTCJbVVrGuFtRRaBWx5fklHDQ1QjSbw
         8arWN/zO4fxA4YbKY5x/Ia4WAAlROuAS2WlB10fBcWGBUtYD1GD4pplaEN76/kfAOdhB
         UGzBHtQaWiM501cmFchp2tvBMgMPuqp1SJvyvWj6Czhf6Ib8v9l3Gh74KMzBiMjXWbXs
         CV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789146376; x=1789751176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8gSh+I98IpYLSh7UCgpWIS2EiiNfz/lZyRXhuHswHY4=;
        b=MmVvDg1E7IGperHVwvI1kjcdYtH3DvHoLjlFWVL2dYRzMeVCpVJ+POIgpq6KWgvvqK
         cr2D02g/F5n5f4zIWkusTc40aDi1PtnHSW5IpeJK6sYjHHmJt1aC/VAiCmYWShNtNXz1
         traUIsMfFgQJNTT+zyUCNmJl4dD6kBbE5vNV26CiQ5kcBuvQNjRyCJi08CfenwD2mIHV
         c5QDmi/S6OJoNjwkF8jKiMT9D4jE1z4FHWRVr/Mw7KMtGhtX/AZP60XPhwKcf+Amc68g
         C7wYiGug13cRqpKgp4bfjUSHKE5MRHVxePFYEeJol+QS4eBmw7fCJXZ7TP3zNN00t8m5
         ZBMQ==
X-Forwarded-Encrypted: i=1; AKwUvBw1FCJNaeUgHAnz+O0IeL6dRrQ74MTs24YvfVDeORBLSoGVSF0yNYRfVfhSQP7JwXp//79dWgPvS67H@vger.kernel.org
X-Gm-Message-State: AFuF++nrvBKKouNFNqjwN9qbpUvY7M3PEpzaL4Hs3Gu9/qVRxaXccx0Y
	UzT1w9U2+EX4JB+ucriKleeWL37D9fbsNcNS3qlvVaO9szAZtC7HZ2RTqbult2Ch1JZNL8FjSyI
	hzuZTMC6XooDWymYkjGihKau63POoHwEZxKZl+EA0pJ5el9fZapz9gZ/dZPylm+1ndlGddkeoyQ
	==
X-Gm-Gg: AYBFou1Ahbp5vgk5nGYIrRlV9enu83aBs7LPyGG4iakAnWBe/4qhxAflHiXXVgUg4Qz
	T+DMSC1s5kuAVE7XUsm1adEWoFKC4F1H4e+8Mo3Tp3KRlXZSBu+k7tVdKOcJdOiEnkSJ7A/V2zQ
	8HVR7nNUQF8i8dAhliA3G9DvJZICzsHihXEvvWBoI1/7ZksgwJZclLUxqNssWv+QK4sM1hw6Iwz
	zr9l0Q3GKOZdEdCjsbQ+m2/hSCRPOoKNUnSjGe64bMlRKmQxI7SjotJrxWVsVrwmr+hL3Wd13dk
	BuRxFo5qwAdOZcue8OKrsjUtWE2qRuON7eH2Fa8BJGGsyU1MjJTETFl7qoo4x/9phWY/Hn1nIhr
	9JAfvOxZBPWSLrnvznL6Y5b5OS/3j577xKrv2X5xMzZ5tLHH3aPd8wyiYhaNwKC14Eg==
X-Received: by 2002:a05:6820:83cb:10b0:6b7:8415:d792 with SMTP id 006d021491bc7-6c0bd588a88mr2861333eaf.61.1789146376319;
        Fri, 11 Sep 2026 10:06:16 -0700 (PDT)
X-Received: by 2002:a05:6214:d4f:b0:912:ca8:278b with SMTP id 6a1803df08f44-91211fa9bc3mr66903086d6.0.1789146037347;
        Fri, 11 Sep 2026 10:00:37 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d0700sm25450326d6.38.2026.09.11.10.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 10:00:36 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: Zihan Xi <zihanx@nebusec.ai>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Pavel Shilovsky <pshilovsky@samba.org>,
	Aurelien Aptel <aaptel@suse.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] smb: client: fix create context out-of-bounds reads
Date: Fri, 11 Sep 2026 12:00:29 -0500
Message-ID: <20260911170034.1236993-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904140527.62354-1-zihanx@nebusec.ai>
References: <cover.1788516372.git.zihanx@nebusec.ai> <20260904140527.62354-1-zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Sep 04, 2026 at 02:05:17PM +0000, Zihan Xi wrote:
> smb2_parse_contexts() validates the complete create-context area but does
> not bound each context record by its Next field before dispatching to a
> handler.  A malformed chain can therefore expose bytes past one context to
> the handler.  The QFid handler also used a full response-structure cast even
> though it only consumes DiskFileId.

Hello,

I have some thoughts/comments on your series.

First, a possible reason for not getting a response on your v2, and
delayed response on this v3: Steve French passed away in August, so
mail addressed to him isn't reaching a maintaner, and things may
have gotten missed during transitions.  You'll want to send future
versions to Paulo Alcantara <pc@manguebit.org>, with Cc to
Namjae Jeon <linkinjeon@kernel.org>


I've been carrying an overlapping patch (an earlier posting:
https://lore.kernel.org/r/20260826153147.4112943-12-sorenson@redhat.com).
in a bounds-checking series of my own.  Like yours, my patch has
been addressing the memory safety problem in the three handlers
which read at fixed offsets, rather than the generic checks.

But I think yours is probably a better fix, and you've got the
PoC, so if we can perfect yours and get it in, I'll be dropping
mine in favor of this series.


A few points (take with a grain of salt):

1) The lease parser still reads at a fixed offset rather than from
   DataOffset:

>  		case 4:
>  			if (!strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4)) {
> -				*oplock = server->ops->parse_lease_buf(cc, epoch,
> +				if (cc_len >= smb2_create_lease_min_cc_len(server))
> +					*oplock = server->ops->parse_lease_buf(cc, epoch,
>  								       lease_key);

cc_len bounds the record, so the read stays in bounds.  But this is
just like the QFid bug you just fixed nearby:  smb2_parse_lease_buf()
and smb3_parse_lease_buf() reach the fields at the canonical offset
of the create_lease layout, not at DataOffset, so a valid but non-
canonical DataOffset could get in-bounds garbage rather than an
OOB.  That's not a security fix, but since LeaseState drives client
caching decisions, it's probably worth closing.  Reading lcontext
from DataOffset, as with DiskFileId would make the two handlers
consistent.

(My version also had this, so it's more an observation than anything
else)


2) You may want to consider matching DataLength exactly, rather than
   taking a minimum.

ksmbd's parse_lease_state() requires:

	sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)

and validates DataOffset + DataLength against the create_lease_v2
size, rather than accepting anything at least long enough.  It was
suggested to me that having the client & server halves agree on
strictness would be good.

(I did confirm your minimums cover all the fields each of the parsers
actually touch, so this is about strictness, not a hole)


Frank
--
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

