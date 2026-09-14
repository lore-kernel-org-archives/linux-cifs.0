Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7E817A30A
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 01:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789348109; cv=none; b=syNnqg3MhuYznApGGLz5twM78lf0dK1EYXFANjF+6euOdJlJLJ3yuVtOv875DbbEnTENVs5bcfrIiYhteEgh0+7MUs/3wlTUD8DiiSknlnM5ceuw8I2vYdv4EYLAyBu2tXpJb9BNJbo3Se0Iw2Vngp7q0yGHp+yOXWUMA3xs6s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789348109; c=relaxed/simple;
	bh=DQ/wnVNvX1ka7omSU76z+E02ifNYOs/0mbN2a11sIhM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=u/Qfqegm2JbrgqV480eICcNYZlY4225msSQFZsHNo0kG1YkOdmdVymI0h89K8Wach1pZBdhf9VB7JX9n1jugaQo2U7tY1122clOa1XXWiF4zJw9hDoecmyPrCUgcBQmPdPFIPPtxZBvWdwwmGg72PCF29j+szSg/1q69Qcz4T7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W6m+pRA5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BasUYHTX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W6m+pRA5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BasUYHTX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789348105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/pa8dMxBQhsNMlzKnHB50SRz3RGxFovnLMTnjMuhkP4=;
	b=W6m+pRA5vHbcNl0M1C1tIGGcsWXQOk+nPc9I4qjq7Sip4xpNjtEa7JkldL/y06qV/ialf7
	uAiUlQOZCAZuJ/9BLyjt0mu6TIYlIr/5SjGdKO86VxSPbqLrOLc5cTQH18Fw9645TFr3tT
	RgE7KjgTJkNb5PId6fvauOHKTP8Jlgc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-Xd3JKgBcOYCc-C4p4oGaDw-1; Sun, 13 Sep 2026 21:08:20 -0400
X-MC-Unique: Xd3JKgBcOYCc-C4p4oGaDw-1
X-Mimecast-MFC-AGG-ID: Xd3JKgBcOYCc-C4p4oGaDw_1789348099
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91049eac948so45517736d6.1
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 18:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789348099; x=1789952899; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/pa8dMxBQhsNMlzKnHB50SRz3RGxFovnLMTnjMuhkP4=;
        b=BasUYHTXMdNHutdrwlQqZeMlxLVPoWHCmLUYVlDvMgohVbYcvp84J6fBFWAS+LqS8U
         ABawkdSyiSojGod/6TMK9yQHCgn445VIOz1Bxf12eu00pXcEDM6mn6nqVdKpCQhcqLgW
         ePwYcMz7WG0fArHmyPlad3mBkRGFM/oMPw7AWy1u2g/0eklsYS6UyKxM5w9v7ghX7eFN
         CcgpVb+gIgojrqFUcmPXWpAb7ynnb+pvHj+UAd/T3tlgytEKiuSIuOWLFx8OKMH73MbE
         Vyb2PIsOBfmHTyNBS7gmHcwbv7O+aCL7Q0AOxVVJMt/dpa0wW9mWNlZVFMwU0MXKlv34
         uDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789348099; x=1789952899;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/pa8dMxBQhsNMlzKnHB50SRz3RGxFovnLMTnjMuhkP4=;
        b=Y+2FpvvQ2U+/vG3VH5mZmpW+Bz8jqMJwC5Dv6ae+pswFC21ig/wDu5SnJSOYsTj82E
         Ud7KOtmvFHa1K3fkSWp9dYf4tgKkwnoKI9hZ7Ywo9qFBoKkkeZNBAZWZjJGF7ATPLRx9
         WIS43ZfXmeXZvMT/ahk8BYsIG0y84kXcaJjgdbdt7nmJI7fk5OThV5G6qZa+8UyUcM9v
         3kjhRdTVeIiTw8zl/EBYoyyox+m6NiU+WNnNqK3eXUbiQJ4rmWouGRYI1fdiB0iLrijH
         74i+d2UgCBVIcnW6arbW2Q7YuXU23XF3AnygkorSfLlbV+ywqD4e1WJThMLLJcKDg+Kk
         UjVA==
X-Gm-Message-State: AFuF++nwRbKYgbJubOFC4s45paTOoWD/iWuej1nXV+1NzINgX9971w3v
	vQJfi/cJ9sGRIDGS2LRo3TMU+dGTO7IRGA1B/ktmq3axVcW17xvHSJywvfMzsv3RfF9/xVkzHW6
	vhzCedg6oXyXah5JV2/fOvydpSVeXGY0qnFunNh01hX5aGUfNVgdhkeP80o/VzmLyXpKj6woE4Q
	YogTcekOSaOSf5v4CwUwyC989yU8258v2Sad7kMCWVY2hLSXE=
X-Gm-Gg: AYBFou1Ocs3BD/Yazzw4oRKKpIiK41pty4PpKwxwqjVopNhKiDaa1czHTdsxSXbN8IW
	6bWlMxmRraxJVyRUqUR9jykVymfAme6/TTDJ2/Fwfo4xaZJxbU4wA/VakttEjV3ifQ1hTUL8XCB
	E1MgGQgko3r5m/uaRkd41CNfr5ZmdYT0ebd9gvjEp8T5F1PPShSczG3iLGd0OCLN7NTS/5fYB10
	d0Lr782Y4a5wDIteev+lAyW5rJ3hwfyLhdHZ1u9nCEN0gcjcEs/h+geOzBJUiSB8KNRsUJCAxzO
	rTd1xqdCcOcSBmv8gwwgEZLrs25tMxt68wZDOf8oAo8bFlGeBIwhDHExSw/Fpq/x/P9ekUenW3R
	2cpVsjkWBXgIk1kwIIkOwkCdX68KdlL0bTQWPm7K5
X-Received: by 2002:a05:6214:268f:b0:911:9373:a171 with SMTP id 6a1803df08f44-9122e6761b7mr9140326d6.30.1789348098714;
        Sun, 13 Sep 2026 18:08:18 -0700 (PDT)
X-Received: by 2002:a05:6214:268f:b0:911:9373:a171 with SMTP id 6a1803df08f44-9122e6761b7mr9139916d6.30.1789348098242;
        Sun, 13 Sep 2026 18:08:18 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f47a6ebsm81974886d6.22.2026.09.13.18.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 18:08:17 -0700 (PDT)
Message-ID: <a4e7d433-f5ed-4508-8749-90c433262b85@redhat.com>
Date: Sun, 13 Sep 2026 20:08:16 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/10] smb: client: fix OOB reads and UAFs in SMB2/3
 receive paths
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org, pc@manguebit.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com
References: <20260913214510.3071370-1-sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <20260913214510.3071370-1-sorenson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Notes on the Sashiko findings (https://sashiko.dev/#/patchset/20260913214510.3071370-1-sorenson%40redhat.com):

patch:

  1) pre-existing; memory leak

  2) pre-existing; OOB read + memory leak

  3) 3 findings
     a. pre-existing; could incorrect iov_len be propagated
     b. pre-existing; error handler could leak memory
     c. pre-existing; could uninitialized heap memory be leaked
        to user-space?

  4) does the lower bound protect against header data parsed as
       UTF-16 strings with multiple referrals?
     Sashiko is correct, however the read stays in bounds so the
       result would be a garbage path, not an OOB access.
     Separate hardening could be done, if exact bound is desired.

  5) pre-existing; potential race condition
  8) 4 findings:
     a. pre-existing; can uninitialized memory be read on truncated
        packets?
     b. is the new check possible to hit?
        *** Sashiko is correct; the new check will never be true ***

     c. pre-existing; can logging via %s format string trigger OOB read
     d. pre-existing; do malformed packets bypass error handling and
        get processed as oplock breaks?
10) pre-existing; does bounds check rely on a structural offset to
     calculate end, potentially leading to leak of uninitialized heap
     memory?

Recommendation:
   patch 4 is still good
   drop patch 8 entirely--it's a dead check

The remainder of the findings are for pre-existing issues; could be
investigated & addressed in future work.


I can respin v5 without patch 8, or (assuming there isn't further
work to do on the rest of the patches) we can simply drop patch 8.


Frank

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

