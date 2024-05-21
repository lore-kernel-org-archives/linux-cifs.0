Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E156826296
	for <linux-cifs@vger.kernel.org>; Tue, 21 May 2024 15:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716306758; cv=none; b=EisU2m67jfhEDi9g7Zv56H8KvlHr5fYY3lNNcnBr3DUC03mTmxFFD2fewB5I72clW+FaNJ25OTf4hXlXd9tf1xzAdO8CVFKWDrIXVeJBxIkPpCQ798y/1s/dEk7WfhEFx5tSQ3pQm8wjOvYYtqnSQInRpYPavADiawQ9G8yZKWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716306758; c=relaxed/simple;
	bh=ydWfB8Ixx2WGgADol03f1VZf4M7vv9stY1thXdwwiug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZcajG2JUwII3wK1xSEWAyQVWtEj1FNLHiR0EWOMR3PEcKu/Xdq1Mh+7rrPCCe6FCNPyQJSnTXLHS4cqijwJo4kITeUCO0ALBeGpH9DOyaGuTOGl0eRcV2eUWsziQ5y/T3AqZZ72uKK9T5NCEab1gJLG/sJC6bHAs+VzgpC7TPv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SQL/+628; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SQL/+628"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-36da87c973cso1666485ab.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 May 2024 08:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716306755; x=1716911555; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lu6Cz3W/7JBafbJfSPoliRhPwzKJFkEKd4ea8AjEFNM=;
        b=SQL/+628XzU/iFw0p+1n/p5apKqFAR8URGHIFVH+euFdLfDLL2souMjSKPpEQYBqKv
         9hDyoN+KJqZM7d9TlKf/7Mz7Hb7IKaQAcy9gIvPnfdhavv+gKwhMafD0dFap3PM0vKXc
         Av4aDiMHRW5vGgbAU9iJ+1qVQ0/qieyrHot/fR6coa49jpoNuWMJSgzxI6Hg94c9A4Wb
         rE/nhVtAzfZabpc1OQuZMMp7kIHVSgNjbaU6NP+sCb6pfpKqdJ3pghLuQAnW5kRUjTTP
         e2qgNeP1D9hsvMj31t6ojW6cE006kOWJ8GcfFQynaMzSsp80tJB/E5MxmB0ruJAig6B7
         a6cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716306755; x=1716911555;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lu6Cz3W/7JBafbJfSPoliRhPwzKJFkEKd4ea8AjEFNM=;
        b=STvP0DK80wMxov8wQ1dknRkzSjQlkL8phMXZs/IvtGQQVz7N8GlS6rmyZQbK5QsQdx
         ly+zMn9f8lks7st8cxQ3qhR3r8JjF75/fJmW6G409Xj4+bW/ywR79B5e2XR/gq+57+MS
         9bR0SEKWAtBgYkeUzoEP+N+yrPrEuC4gchXmCDcENtY/isV95AtlUmJJTlvDzN5YGLtT
         KTg5x8XcQ052+PQeYNVo5GRpnavxtRRQQsHGiYCTzHQkFQReC4CGxTtycAlu/9Ig/qFO
         uQfugXAkwdJoFOv5kozI2xrllVnPQFJDOBgf/AfeejmJdo0xl2w3cdCxed5I68rlojuA
         w4uA==
X-Forwarded-Encrypted: i=1; AJvYcCXWAiSDHHDHxh81v4MeOCXSEyH/cw5AFsM0RY9V856Tt3RanAjBHOgOiyREWjeyjFsiRw+aH2E/C1zaxiswW0BtyxJRtstfAti8tQ==
X-Gm-Message-State: AOJu0YygW2j6ac9FKHvzRPUKJlzbfDuuyJm15WdE3iFRnwE6euYc/Xjn
	nAc1+DJa6tDIRfA2gXda5yy3/Yc052Uwlns5CcucmPX7CEfQWVDjvyMcz9iF2OU=
X-Google-Smtp-Source: AGHT+IHa1zyl6cmZPdjySIykg2SQdYZupp88XF9rpgThrnqOxMjg4dDFQSMzR/ggbhek66vW9xxDQg==
X-Received: by 2002:a92:c988:0:b0:36c:c86b:9181 with SMTP id e9e14a558f8ab-36cc86b9470mr305103065ab.0.1716306754979;
        Tue, 21 May 2024 08:52:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-36cb9e1363esm63659975ab.71.2024.05.21.08.52.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 08:52:34 -0700 (PDT)
Message-ID: <2e73c659-06a3-426c-99c0-eff896eb2323@kernel.dk>
Date: Tue, 21 May 2024 09:52:32 -0600
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfs: Fix setting of BDP_ASYNC from iocb flags
To: David Howells <dhowells@redhat.com>, Steve French <stfrench@microsoft.com>
Cc: Jeff Layton <jlayton@kernel.org>, Enzo Matsumiya <ematsumiya@suse.de>,
 Matthew Wilcox <willy@infradead.org>, Christian Brauner
 <brauner@kernel.org>, netfs@lists.linux.dev, v9fs@lists.linux.dev,
 linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <316306.1716306586@warthog.procyon.org.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <316306.1716306586@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/24 9:49 AM, David Howells wrote:
> Fix netfs_perform_write() to set BDP_ASYNC if IOCB_NOWAIT is set rather
> than if IOCB_SYNC is not set.  It reflects asynchronicity in the sense of
> not waiting rather than synchronicity in the sense of not returning until
> the op is complete.
> 
> Without this, generic/590 fails on cifs in strict caching mode with a
> complaint that one of the writes fails with EAGAIN.  The test can be
> distilled down to:
> 
>         mount -t cifs /my/share /mnt -ostuff
>         xfs_io -i -c 'falloc 0 8191M -c fsync -f /mnt/file
>         xfs_io -i -c 'pwrite -b 1M -W 0 8191M' /mnt/file

Looks good to me:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

However, I'll note that BDP_ASYNC is horribly named, it should be
BDP_NOWAIT instead. But that's a separate thing, fix looks correct
as-is.

-- 
Jens Axboe

