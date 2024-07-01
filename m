Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DB937708
	for <linux-cifs@vger.kernel.org>; Mon,  1 Jul 2024 21:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719868575; cv=none; b=uuW7I0/jLAV+ZABSWkt2hUDudcscEcnWoOeUdqOJXq6XPd4zyQjtFK2+isBWiYFDkvuxQy5IxaOqYl+fK1feSylredQftBAhV8FoR1GP5AzOat75zwapjq4g+YbI7UJdrMx40RVEl6vj8fc6MhUppRnC2jxYJ5c7EXghUGnmaYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719868575; c=relaxed/simple;
	bh=x+R0A6zBkSSAcX1piwgLRxUaLDuz5Q88ryQ2M+z7tnw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=dMAcMwN65hzOs9LU+6kJIYkWldTNRSt/WPjXlRPRs1SWXQhDtetugq9pPVeHUpjW+2Of2Zf5cJcc0GTAewDB5mEehIhS06W5i4WWgDaVLnfvM5ZTt4iStrm7CPoFva/SYcOcOFHkaj8fwm7PeZEK/b1MKMgyDHL0avnGpTXc9lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l/VZBkAX; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l/VZBkAX"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52e8b27f493so1572084e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 01 Jul 2024 14:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719868572; x=1720473372; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RVVvzEoVYaNI8dJrfbY7PheBV8sKpOTXF1JPSRz+YRA=;
        b=l/VZBkAXznSaD257/mEiaeULMNER1bNXE9Sb7tegtyicLQYl4wV7BBsRTpavKsZ8+5
         DOETPesdpjRiD0WO67724GMEPF+WcrLMFNsslwgAaPpV/Ajm3yI7aXk+WynHiipiJqJD
         To9TkXiLemcGyC/0gua7bqNfhAKMuiwQf9yRZWVn8T43ROWMCku8aLM79VMcdZn2LByS
         5a8zR/9DbNCGe9FxuR3KRXwIpoOQCul8jOsaE2wY6LjGBVWzNGFu+ub2e/t8QGlmU/38
         DB5mXtLzPnp6zccK0O3Fyi9HSun8bQ3M+P3/8gy2b1CGuVv2QdV35L+DkBHNnrKKbPP4
         l4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719868572; x=1720473372;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RVVvzEoVYaNI8dJrfbY7PheBV8sKpOTXF1JPSRz+YRA=;
        b=JEQgOwczbWL9c+9DBNM2n7qWg7zI+zV/oDxNYPEiavLvGfHIXNqWe/bUmDK/PQpJzi
         G4VCh9bx9TWlVwWlM+ez0lXsR9cGnpwgsAtTz1xLYvAYYRIdEV78r5QLTdNdWP5DMBSs
         RtxIQpNOkgS6Gj8XdE8/8M//cEIlUYReY+F23Y/crRMYZSXVBMjE8dl7VJaT9XYUwfjC
         uRscF0+xeg0oz5BQ0v+gQ+Be3INtYQ/Cpip5FVjPz4Uu2IeHb4V47Flp8lnw27kD3Ww+
         YeaxVCYg3mP9OuRyAfAVh7Pvt2enxPiTY8mAZRQiHX/wXNQrQlDknoc9BRfVs4goD5UB
         N+YQ==
X-Forwarded-Encrypted: i=1; AJvYcCWI/imJE1IRs1Utt4WvVIqrB6qAUqb98xQICkVvST+khTVxj3JqgqBwatiWtvI39YBbwlnuWsP7iVGTauwAKqR21MZBNass6+QPAg==
X-Gm-Message-State: AOJu0YwNvK53xgpO/hJqsayHg4XoY4TlUCRWn7gcm9BjIe19Jmbjom0W
	Tb2k3zcE5iItlsQMHjKWuhwzQGGwHVhP6kU1TTu2SCa52GrQ6x/kY0w1bFceU8sa3PxKqBNsXvw
	vtDdbNA76WZtIjrT64CDZOY4RKdpv4vG0
X-Google-Smtp-Source: AGHT+IHurx7eIfTqovKKHr+2ht8xPJato21RPg5BaNP3AmPYJ/oBQUidDFXXcZRvMv392v6MQHw6EW8+BJHquc9BfSs=
X-Received: by 2002:ac2:5dcc:0:b0:52b:c15f:2613 with SMTP id
 2adb3069b0e04-52e826898d9mr3715903e87.35.1719868571793; Mon, 01 Jul 2024
 14:16:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 1 Jul 2024 16:16:00 -0500
Message-ID: <CAH2r5mvQsDJZnVZyPUy0FRK5Hrfv5bEwi73N2zfOfD=tnav4ew@mail.gmail.com>
Subject: xfstest improvements with recent netfs fixes?
To: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

In comparing the test run with 6.10-rc6 yesterday
(http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/3/builds/148),
vs. mainline today which includes some netfs fixes (see
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/3/builds/149).
I noticed improvement.   In particular tests generic/198, 207, 208,
240  and generic/330 now passed.  Do you also see those netfs fixes
help? And were those expected to fix these tests?



-- 
Thanks,

Steve
