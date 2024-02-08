Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E866EB67
	for <linux-cifs@vger.kernel.org>; Thu,  8 Feb 2024 10:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707389489; cv=none; b=O8y74kHw16tnI4D9LCJwL8WrjCYAvyHFm+XIQrJoGwOwlk0fd1jKRkaWSW4288dZAQwBpaHl4+SiuQSFASUVUMTa9x0yC8ggOslI0uKqwb/cxyr1O79HtuZ899Zz9Z4DPQOoA9inqnVaGk3AmPtbQPZPslIP6yJrbc2bZnWtalQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707389489; c=relaxed/simple;
	bh=pYnaFJzslrxypFw25Sj8Mfon+EIE+K8wzEHhCt4dOzA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=XmGVc1DP3bjtrbb6/5khssglT3Q+hcW7HyZ0yuygwRN2wolWWoq3Pv9rkP7f928axQZYzX7gmWEHDipYnr3DhRvy/4nsk/MnF9DsyJHamuPIlmr78ATNa3m/iVMbHM4OVm7PG6kZvz7cvQYk0kL50Qd/OVVCy3QD3J182TSKycw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Af0MjhcI; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Af0MjhcI"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d0c9967fdcso8052651fa.0
        for <linux-cifs@vger.kernel.org>; Thu, 08 Feb 2024 02:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707389485; x=1707994285; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tSs951ohOy5CJPMPL0sE/ubGnZuXslG0T8Idw6fk40c=;
        b=Af0MjhcIiC/OTIxbMOCRFeHrNGvf7HLUGrSeaSVUIVAcFbIH4OUj7D5dqHvTFu9RHV
         h+EmnliLbOO4gIqh2a+lPV5CjE53Mnpg7o1KQzYCjO5ufRHI6A2BPmIMtgIIeNEOFZ9/
         9KyeDljqLGoOl5rZSHqUxlFctrSkrmPxAgYILNDoPyY0z8Bypa493FH/H1Mp0oNa620m
         plBTe3cRh/BJUwQxqxJ04/UpHb6G/tvkLUdRfcwYekV1epCo25446TNFMvsMn7+VqPxT
         RIfAynQXedvUUt/Hp8M+D8YgPG2X3Bv2lpeexUjRm8MYIY+1NM5jq4lVKvnLL/0jv68B
         dWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707389485; x=1707994285;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tSs951ohOy5CJPMPL0sE/ubGnZuXslG0T8Idw6fk40c=;
        b=jyLYvN9r0824azeQUdGUqheWVtngfwvy4U3CMhuoAWHuHXrS7HwsWwU0WNiuWJE1CN
         z8tIkJNA5tvakHe37/faUeYo7znuvX2QpXngZ3a888Uu4MCO4+VpGEmHAjYwaXhE0tAu
         VWUlGjFXUlN1HMtFa5QOj6lspiLJKsO7+B0WiKFGsG1qhEf7+2GDh+IrfKjBJ1LwHKzy
         Cynm63jPPU1jWZsOoY7loClWdmTiAQM00U6i2gf4OqVja/+pWqxmO1tqIWNdwfHbwye1
         16dFzH5KWvZ/NtOoytada5jA10HLlh9L66/o3N+gCFfyZffLpUKGOl6kx0wHv1wbV4Pj
         KAWw==
X-Forwarded-Encrypted: i=1; AJvYcCXaMpOsGhyYuliyNgmrxQkp2kwUCamgbQTP12KKDUmrDMjH7Za35Ht0zbOgsH48hY9ozX7batsANdX5lDmzGPU6Cx6qzXkCMy/jCQ==
X-Gm-Message-State: AOJu0YxX5tDJNr/9Zsvw6irJOp8z4Ig26/7rquUCog2qBQoLvskknco7
	GLm5o5lmjrn0FljmQfr0Ul3Vx4oXYOYEUPpnqN0/856YfXkaIVAspcE/2wMn3P67g3L4FUo0BCM
	nyd6yGZvdGZAdXbdhvO2fGqo2xvY=
X-Google-Smtp-Source: AGHT+IFVY3AdNpSox9beNeCqgYJD1qJybWfr8tKYAtzfbCIGBI+7u7jkI19WWbkymzZdOpggvtqyHwVFhoEDIZlFsaU=
X-Received: by 2002:a2e:b042:0:b0:2d0:8e95:612e with SMTP id
 d2-20020a2eb042000000b002d08e95612emr907367ljl.16.1707389485104; Thu, 08 Feb
 2024 02:51:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 8 Feb 2024 16:21:13 +0530
Message-ID: <CANT5p=pcSGGEEtEzJKmv6i5Cd4_Qki0kc=gVfk5omXSJjvaBrQ@mail.gmail.com>
Subject: Rename replay request semantics on SMB2
To: Stefan Metzmacher <metze@samba.org>, Tom Talpey <tom@talpey.com>, Steve French <smfrench@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi all,

I wanted to understand the server behaviour for a specific scenario,
as it was not very clear what the spec says about this.
We recently implemented the ChannelSequence and
SMB2_FLAGS_REPLAY_OPERATION header flags, which we did not do earlier.

After this, if there is a channel disconnect, and some requests are
in-flight, we are now retrying the same operation with the replay flag
set. The expectation was that the server sees this as a replayed
request, and responds to it accordingly.
However, it looks like it may not be that simple.

I noticed during my tests that when a channel is disconnected in the
middle of a rename compound operation, and the client replays this
again on another channel, the server returns STATUS_OBJECT_NOT_FOUND.
I would have expected a following replay to get this error if it was
not a replay request. But for replayed requests, my expectation was
that the server returns success, even if the rename had completed.

Re-reading through the spec, it looks to me like these (chan-seq-num +
replay) may only be used to maintain ordering of operations, and seems
to concern the ordering of ONGOING operations, and not the ones that
have already completed.
So if a rename operation completed, but the server could not send the
response back, regardless of the replay flag, the server is going to
treat this as a new rename.

Does this mean that the client needs to be aware that the server may
already have completed the prev operation and handle
STATUS_OBJECT_NOT_FOUND only for rename requests?
I would imagine similar handling needed for all non-idempotent requests.

-- 
Regards,
Shyam
